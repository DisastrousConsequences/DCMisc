//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GiveItemsInv extends Inventory;

//client side only
var PlayerController PC;
var Player Player;
var DruidsRPGKeysInteraction DKInteraction;

var MutDruidRPG KeysMut;
var bool Initialized;
var bool InitializedSubClasses;
var bool InitializedAbilities;
var int tickcount;

struct ArtifactKeyConfig
{
	Var String Alias;
	var Class<RPGArtifact> ArtifactClass;
};
var config Array<ArtifactKeyConfig> ArtifactKeyConfigs;

// now the subclass stuff.
// This is all local copies of what is in the SubClass ability config. Copied here for replication to client
// structure containing list of subclasses available to each class, and what minimum level it can be bought at
var Array<string> SubClasses;

struct SubClassConfig
{
	var class<RPGClass> AvailableClass;
	var string AvailableSubClass;
	var int MinLevel;
};
var Array<SubClassConfig> SubClassConfigs;

// structure containing list of abilities available to each class/subclass. Set MaxLevel to zero for abilities not available.
struct AbilityConfig
{
	var string AvailableSubClass;	// can be none
	var class<RPGAbility> AvailableAbility;
	var int MaxLevel;
};
var Array<AbilityConfig> AbilityConfigs;

var RPGStatsInv ClientStatsInv;		// set clientside by RPGMenus

replication
{
	reliable if (Role<ROLE_Authority)
		DropHealthPickup, DropAdrenalinePickup, ServerSellData, ServerSetSubClass, ServerGetAbilities;
	reliable if (Role == ROLE_Authority)
		ClientReceiveKeys, ClientRemainingAbility, ClientRemoveAbilities, ClientReceiveSubClass, ClientReceiveSubClasses, ClientReceiveSubClassAbilities, ClientSetSubClass, ClientSetSubClassSizes, ClientDoReconnect;
}


function PostBeginPlay()
{
	if(Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer || Level.NetMode == NM_Standalone)
		setTimer(5, true);
	super.postBeginPlay();
}

simulated function PostNetBeginPlay()
{
	if(Level.NetMode != NM_DedicatedServer)
		enable('Tick');		// tick on client
	super.PostNetBeginPlay();
}

simulated function Tick(float deltaTime)
{
	local int x;
	local RPGInteraction rpgi;

	if (Level.NetMode == NM_DedicatedServer || DKInteraction != None)
	{
		disable('Tick');
	}
	else
	{
		if (!Initialized)
		{
			tickcount++;
			if (tickcount>10)
				disable('Tick');
			return;
		}

		PC = Level.GetLocalPlayerController();
		if (PC != None)
		{
			Player = PC.Player;
			if(Player != None)
			{
				//first, find out if they have the interaction already.
				
				for(x = 0; x < Player.LocalInteractions.length; x++)
				{
					if (RPGInteraction(Player.LocalInteractions[x]) != None && DruidsRPGKeysInteraction(Player.LocalInteractions[x]) == None )
					{
						rpgi = RPGInteraction(Player.LocalInteractions[x]);
					} 
					else
					if(DruidsRPGKeysInteraction(Player.LocalInteractions[x]) != None)
					{
						DKInteraction = DruidsRPGKeysInteraction(Player.LocalInteractions[x]);
					}
				}
				if (rpgi != None && Player.InteractionMaster != None )
				{
					Player.InteractionMaster.RemoveInteraction(rpgi);
				} 
				if(DKInteraction == None) //they dont have one
					AddInteraction();
			}
			if(DKInteraction != None)
				disable('Tick');
		}
	}
}


//not done through the interaction master, because that requires a string with a package name.
simulated function AddInteraction()
{
	local int x;

	DKInteraction = new class'DruidsRPGKeysInteraction';

	if (DKInteraction != None)
	{
		Player.LocalInteractions.Length = Player.LocalInteractions.Length + 1;
		Player.LocalInteractions[Player.LocalInteractions.Length-1] = DKInteraction;
		DKInteraction.ViewportOwner = Player;

		// Initialize the Interaction

		DKInteraction.Initialize();
		DKInteraction.Master = Player.InteractionMaster;
		
		// now copy the keys over
		DKInteraction.ArtifactKeyConfigs.Length = 0;
		for (x = 0; x < ArtifactKeyConfigs.Length; x++)
		{
			if(ArtifactKeyConfigs[x].Alias != "")
			{
				DKInteraction.ArtifactKeyConfigs.Length = x+1;
				DKInteraction.ArtifactKeyConfigs[x].Alias = ArtifactKeyConfigs[x].Alias;
				DKInteraction.ArtifactKeyConfigs[x].ArtifactClass = ArtifactKeyConfigs[x].ArtifactClass;
			}
		}
	}
	else
		Log("Could not create DruidsRPGKeysInteraction");

} 

function InitializeKeyArray()
{
	// create client side copy of keys
	local int x;

	if(!Initialized)
	{
		if(KeysMut != None)
		{
			for (x = 0; x < KeysMut.ArtifactKeyConfigs.Length; x++)
			{
				if(KeysMut.ArtifactKeyConfigs[x].Alias != "")
				{
					ClientReceiveKeys(x, KeysMut.ArtifactKeyConfigs[x].Alias, KeysMut.ArtifactKeyConfigs[x].ArtifactClass);
				}else
				{
					ClientReceiveKeys(x, "", None);
				}
			}
			ClientReceiveKeys(-1, "", None);
			Initialized = True;
		}
	}
}

simulated function ClientReceiveKeys(int index, string newAliasString, Class<RPGArtifact> newArtifactClass)
{
	if(Level.NetMode != NM_DedicatedServer)
	{
		if (index < 0)
		{
			Initialized = True;
		}
		else
		{
			ArtifactKeyConfigs.Length = index+1;
			ArtifactKeyConfigs[index].Alias = newAliasString;
			ArtifactKeyConfigs[index].ArtifactClass = newArtifactClass;
		}
	}
}

simulated function Destroyed()
{	
	if(DKInteraction != None)
	{
		RemoveInteraction();
	}
	
	super.Destroyed();
}

simulated function RemoveInteraction()
{
	if(Player != None && Player.InteractionMaster != None && DKInteraction != None)
		Player.InteractionMaster.RemoveInteraction(DKInteraction);
	DKInteraction = None;
}

static function DropHealth(Pawn P)
{
	local GiveItemsInv GI;

	if (P == None)
		return;
	if (P.Health <= 25)
		return;

	// ok, lets try it
	GI = GiveItemsInv(P.FindInventoryType(class'GiveItemsInv'));
	if (GI != None)
	{
		GI.DropHealthPickup();
	}
}


function DropHealthPickup()
{
	local vector X, Y, Z;
	local Inventory Inv;
	local int HealthUsed;
	local RPGStatsInv StatsInv;
	local int ab;
	local Pawn PawnOwner;
	local Pickup NewPickup; 

	PawnOwner = Pawn(Owner);
	if (PawnOwner == None)
		return;

	HealthUsed = class'DruidHealthPack'.default.HealingAmount;

	// ok, now we need to check if this bod has smart healing, to avoid throw and pickup exploit
	for (Inv = PawnOwner.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		StatsInv = RPGStatsInv(Inv);
		if (StatsInv != None)
			break;
	}
	if (StatsInv == None) //fallback, should never happen
		StatsInv = RPGStatsInv(PawnOwner.FindInventoryType(class'RPGStatsInv'));
	if (StatsInv != None) //this should always be the case
	{
		for (ab = 0; ab < StatsInv.Data.Abilities.length; ab++)
		{
			if (ClassIsChildOf(StatsInv.Data.Abilities[ab], class'AbilitySmartHealing'))
			{
				HealthUsed += 25 * 0.25 * StatsInv.Data.AbilityLevels[ab];
			}
		}
	}


	if (PawnOwner.Health <= HealthUsed)
		return;

	GetAxes(PawnOwner.Rotation, X, Y, Z);
	NewPickup = PawnOwner.spawn(class'DruidHealthPack',,, PawnOwner.Location + (1.5*PawnOwner.CollisionRadius + 1.5*class'DruidHealthPack'.default.CollisionRadius) * Normal(Vector(PawnOwner.Controller.GetViewRotation())));
	if (NewPickup == None)
	{
		return;
	}
	NewPickup.RemoteRole = ROLE_SimulatedProxy;
	NewPickup.bReplicateMovement = True;
	NewPickup.bTravel=True;
	NewPickup.NetPriority=1.4;
	NewPickup.bClientAnim=true;
	NewPickup.Velocity = Vector(PawnOwner.Controller.GetViewRotation());
	NewPickup.Velocity = NewPickup.Velocity * ((PawnOwner.Velocity Dot NewPickup.Velocity) + 500) + Vect(0,0,200);
	NewPickup.RespawnTime = 0.0;
	NewPickup.InitDroppedPickupFor(None);
	NewPickup.bAlwaysRelevant = True;

	PawnOwner.Health -= HealthUsed;
	if (PawnOwner.Health <= 0)
		PawnOwner.Health = 1;	// dont kill it by throwing health. Shouldn't really need this, but...
	// no exp for dropping health - too exploitable

}

static function DropAdrenaline(Pawn P)
{
	local GiveItemsInv GI;

	if (P == None)
		return;
	if (P.Health <= 5)
		return;

	// ok, lets try it
	GI = GiveItemsInv(P.FindInventoryType(class'GiveItemsInv'));
	if (GI != None)
	{
		GI.DropAdrenalinePickup();
	}
}


function DropAdrenalinePickup()
{
	local vector X, Y, Z;
	local Pawn PawnOwner;
	local AdrenalinePickup NewPickup; 
	Local XPawn xP;

	PawnOwner = Pawn(Owner);
	if (PawnOwner == None)
		return;
	if (PawnOwner.Controller == None)
		return;
	if (PawnOwner.Controller.Adrenaline < 25)
		return;
	xP = xPawn(PawnOwner);
	if (xP != None && xP.CurrentCombo != None)
		return;		// can't drop while in combo

	GetAxes(PawnOwner.Rotation, X, Y, Z);
	NewPickup = PawnOwner.spawn(class'DruidAdrenalinePickup',,, PawnOwner.Location + (1.5*PawnOwner.CollisionRadius + 1.5*class'DruidAdrenalinePickup'.default.CollisionRadius) * Normal(Vector(PawnOwner.Controller.GetViewRotation())));
	if (NewPickup == None)
	{
		return;
	}
	NewPickup.RemoteRole = ROLE_SimulatedProxy;
	NewPickup.bReplicateMovement = True;
	NewPickup.bTravel=True;
	NewPickup.NetPriority=1.4;
	NewPickup.bClientAnim=true;
	NewPickup.Velocity = Vector(PawnOwner.Controller.GetViewRotation());
	NewPickup.Velocity = NewPickup.Velocity * ((PawnOwner.Velocity Dot NewPickup.Velocity) + 500) + Vect(0,0,200);
	NewPickup.RespawnTime = 0.0;
	NewPickup.InitDroppedPickupFor(None);
	NewPickup.bAlwaysRelevant = True;
	NewPickup.AdrenalineAmount = 25;
	NewPickup.SetDrawScale(class'AdrenalinePickup'.default.DrawScale * 2);	// bigger cos more adrenaline

	PawnOwner.Controller.Adrenaline -= 25;
	if (PawnOwner.Controller.Adrenaline < 0)
		PawnOwner.Controller.Adrenaline = 0;
	// no exp for dropping health - too exploitable

}


//----------------------------------------------------------------------------------------
// OK, now the stuff for handling subclasses

// first intialize the data. Copy from configuration in the SubClass config and replicate to the client
function InitializeSubClasses(Pawn Other)
{
	// create client side copy of subclasses and limits
	// copied from the SubClass ability coinfiguration
	local int x;

	if(!InitializedSubClasses)
	{
		// first setup the server from the subClass config
		SubClasses.length = class'SubClass'.default.SubClasses.length;
		for (x = 0; x < SubClasses.Length; x++)
		{
			SubClasses[x] = class'SubClass'.default.SubClasses[x];
		}
		SubClassConfigs.length = class'SubClass'.default.SubClassConfigs.length;
		for (x = 0; x < SubClassConfigs.Length; x++)
		{
			SubClassConfigs[x].AvailableClass = class'SubClass'.default.SubClassConfigs[x].AvailableClass;
			SubClassConfigs[x].AvailableSubClass = class'SubClass'.default.SubClassConfigs[x].AvailableSubClass;
			SubClassConfigs[x].MinLevel = class'SubClass'.default.SubClassConfigs[x].MinLevel;
		}
		AbilityConfigs.length = class'SubClass'.default.AbilityConfigs.length;
		for (x = 0; x < AbilityConfigs.Length; x++)
		{
			AbilityConfigs[x].AvailableSubClass = class'SubClass'.default.AbilityConfigs[x].AvailableSubClass;
			AbilityConfigs[x].AvailableAbility = class'SubClass'.default.AbilityConfigs[x].AvailableAbility;
			AbilityConfigs[x].MaxLevel = class'SubClass'.default.AbilityConfigs[x].MaxLevel;
		}
		InitializedAbilities = true;		//server side

		// now lets replicate
		for (x = 0; x < SubClasses.Length; x++)
		{
				ClientReceiveSubClass(x, SubClasses[x]);
		}
		for (x = 0; x < SubClassConfigs.Length; x++)
		{
			if(SubClassConfigs[x].AvailableClass != None)
			{
				ClientReceiveSubClasses(x, SubClassConfigs[x].AvailableClass, SubClassConfigs[x].AvailableSubClass, SubClassConfigs[x].Minlevel);
			}else
			{
				ClientReceiveSubClasses(x, None, "", 0);
			}
		}
		// do not replicate abilities for the moment - too slow. Wait for request from client
		//for (x = 0; x < AbilityConfigs.Length; x++)
		//{
		//	ClientReceiveSubClassAbilities(x, AbilityConfigs[x].AvailableSubClass, AbilityConfigs[x].AvailableAbility, AbilityConfigs[x].MaxLevel);
		//}
		ClientSetSubClassSizes(SubClasses.Length,SubClassConfigs.Length,0);		// no abilities yet - too slow
		InitializedSubClasses = True;
	}

	if (Other != none && Other.Controller != None && Other.Controller.isA('PlayerController'))
	{
		if (!ValidateSubClassData(RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'))))
		{
			Log("+++++++ GI ValidateSubClassData faiied");
			ClientDoReconnect();
		}
	}
}

simulated function ClientDoReconnect()
{
	// force the reconnect through
	if(Level.NetMode == NM_Client)
	{
		Log("++++++++ GI ClientDoReconnect");
		if (Player != None && Player.GUIController != None )
		{
			Log("++++++++ GI ClientDoReconnect issuing request");
			Player.GUIController.ViewportOwner.Console.DelayedConsoleCommand("Reconnect");
		}
	}
}

simulated function ClientReceiveSubClass(int index, string thisSubClass)
{
	if(Level.NetMode == NM_Client)
	{
		if (index >= 0)
		{
			if (index+1 > SubClasses.Length)
				SubClasses.Length = index+1;
			SubClasses[index] = thisSubClass;
		}
	}
}

simulated function ClientReceiveSubClasses(int index, class<RPGClass> AvailableClass, string AvailableSubClass, int MinLevel)
{
	if(Level.NetMode == NM_Client)
	{
		if (index >= 0)
		{
			if (index+1 > SubClassConfigs.Length)
				SubClassConfigs.Length = index+1;
			SubClassConfigs[index].AvailableClass = AvailableClass;
			SubClassConfigs[index].AvailableSubClass = AvailableSubClass;
			SubClassConfigs[index].MinLevel = MinLevel;
		}
	}
}

simulated function ClientReceiveSubClassAbilities(int index, string AvailableSubClass, class<RPGAbility> AvailableAbility, int MaxLevel)
{
	if(Level.NetMode == NM_Client)
	{
		if (index >= 0)
		{
			if (index+1 > AbilityConfigs.Length)
				AbilityConfigs.Length = index+1;
			AbilityConfigs[index].AvailableSubClass = AvailableSubClass;
			AbilityConfigs[index].AvailableAbility = AvailableAbility;
			AbilityConfigs[index].MaxLevel = MaxLevel;
		}
	}
}

simulated function ClientSetSubClassSizes(int SubClassesLen,int SubClassConfigsLen,int AbilitiesLen)
{
	if(Level.NetMode == NM_Client)
	{
		if (SubClassesLen >= 0 && SubClassesLen < SubClasses.Length)
			SubClasses.Length = SubClassesLen;
			
		if (SubClassConfigsLen >= 0 && SubClassConfigsLen < SubClassConfigs.Length)
			SubClassConfigs.Length = SubClassConfigsLen;
			
		if (AbilitiesLen >= 0 && AbilitiesLen < AbilityConfigs.Length)
			AbilityConfigs.Length = AbilitiesLen;
		InitializedSubClasses = True;
		if (AbilitiesLen > 0)
			InitializedAbilities = True;
		else
			InitializedAbilities = False;
	}
}


simulated function int MaxCanBuy(string CurrentSubClass, class<RPGAbility> RequestedAbility)
{
	local int x;
	local int MaxL;

	MaxL = RequestedAbility.default.MaxLevel;		// default to normal max level, unless prohibited
	for (x = 0; x < AbilityConfigs.length; x++)
		if (AbilityConfigs[x].AvailableSubClass == CurrentSubClass && AbilityConfigs[x].AvailableAbility == RequestedAbility)
			MaxL = AbilityConfigs[x].MaxLevel;
			
	return MaxL;
}

function bool ValidateSubClassData(RPGStatsInv StatsInv)
{
	// validate that the subclass is ok for the given class, and that all abilities are still allowed. if not, sell.
	// return true if ok, false if we had to change something
	local class<RPGClass> curClass;
	local string curSubClass;			// what it is configured as - the class name or the subclass
	local int curSubClasslevel;			// what it is configured as - the class name or the subclass
	local int x,y;
	local bool bGotSubClass;
	local bool bUpdatedAbility;

	if (StatsInv == None || StatsInv.RPGMut == None || StatsInv.DataObject.Abilities.length == 0)
	{
		Log("++++++++++ GI ValidateSubClassData problem player" @ Pawn(Owner).PlayerReplicationInfo.PlayerName @ "couldnt process. StatsInv:" $ StatsInv);
		return true;		// not sure true is correct here? But we didnt change anything?
	}
		
	curClass = None;
	curSubClass = "";
	// first lets find the class
	for (y = 0; y < StatsInv.DataObject.Abilities.length; y++)
		if (ClassIsChildOf(StatsInv.DataObject.Abilities[y], class'RPGClass'))
		{
			// found the class
			curClass = class<RPGClass>(StatsInv.DataObject.Abilities[y]);
		}
		else
		if (ClassIsChildOf(StatsInv.DataObject.Abilities[y], class'SubClass'))
		{
			//found the subclass
			curSubClassLevel = StatsInv.DataObject.AbilityLevels[y];
			if (curSubClassLevel < class'SubClass'.default.SubClasses.length)
				curSubClass = class'SubClass'.default.SubClasses[curSubClassLevel];
			else
			{
				// this subclass no longer exists. Remove  ***************
				Log("++++++++++ GI ValidateSubClassData problem player" @ Pawn(Owner).PlayerReplicationInfo.PlayerName @ "subclass out of range");
				ServerSellData(None, StatsInv);
				return false;
			}
		}
	
	// lets check if the subclass is still valid
	if (curSubClass != "" && curClass != None && curSubClass != curClass.default.AbilityName)		// no subclass is always ok
	{
		// look through the list of classes and subclasses and check it is still there
		bGotSubClass = false;
		for (y = 0; y < class'SubClass'.default.SubClassConfigs.length; y++)
		{
			if (class'SubClass'.default.SubClassConfigs[y].AvailableClass == curClass && class'SubClass'.default.SubClassConfigs[y].AvailableSubClass == curSubClass && class'SubClass'.default.SubClassConfigs[y].MinLevel <= StatsInv.DataObject.Level)
			{	// got it, so still valid 
				bGotSubClass = true;
			}
		}
		if (!bGotSubClass)
		{
			// must sell   **************************
			Log("++++++++++ GI ValidateSubClassData problem player" @ Pawn(Owner).PlayerReplicationInfo.PlayerName @ "subclass:" $ curSubClass @ "not found for class");
			ServerSellData(None, StatsInv);
			return false;
		}
	}
	
	if (curSubClass == "")
	{
		if (curclass != None) 
			curSubClass = curClass.default.AbilityName;	// got class but no subclass
		else
			curSubClass = "None";		// no class or subclass
	}
	// ok, now lets check the abilities. Loop through the abilities the player has and check if the subclass config limits it
	bUpdatedAbility = false;
	for (x = 0; x < StatsInv.DataObject.Abilities.length; x++)
		if (!ClassIsChildOf(StatsInv.DataObject.Abilities[x], class'SubClass') && !ClassIsChildOf(StatsInv.DataObject.Abilities[x], class'RPGClass'))
		{
			// not the class or subclass. Lets see if it is in the list for this subclass
			for (y = 0; y < class'SubClass'.default.AbilityConfigs.length; y++)
			{
				if (class'SubClass'.default.AbilityConfigs[y].AvailableSubClass == curSubClass && class'SubClass'.default.AbilityConfigs[y].AvailableAbility == StatsInv.DataObject.Abilities[x])
				{	// got it, so still valid if level ok
					if (class'SubClass'.default.AbilityConfigs[y].MaxLevel < StatsInv.DataObject.AbilityLevels[x])
					{
						// have a problem. Lets either sell the ability or reduce to the max
						if (class'SubClass'.default.AbilityConfigs[y].MaxLevel > 0)
						{
							Log("++++++++++ GI ValidateSubClassData problem player" @ Pawn(Owner).PlayerReplicationInfo.PlayerName @ "subclass:" $ curSubClass @ "ability:" $ StatsInv.DataObject.Abilities[x] @ "level:" $ StatsInv.DataObject.AbilityLevels[x] @ "too high, max now:" $ class'SubClass'.default.AbilityConfigs[y].MaxLevel);
							 StatsInv.DataObject.AbilityLevels[x] = class'SubClass'.default.AbilityConfigs[y].MaxLevel;
						}
						else
						{
							Log("++++++++++ GI ValidateSubClassData problem player" @ Pawn(Owner).PlayerReplicationInfo.PlayerName @ "subclass:" $ curSubClass @ "ability:" $ StatsInv.DataObject.Abilities[x] @ "not available for subclass");
							StatsInv.DataObject.Abilities.Remove(x, 1); 
							StatsInv.DataObject.AbilityLevels.Remove(x, 1);
							x--; 
						}
						bUpdatedAbility = true;;
					}
					break;
				}
			}
			// if can't find ability in subclass config, then it must be an ability like AirControl that isn't controlled. So ok
		}
	if (bUpdatedAbility)
	{
		StatsInv.DataObject.saveConfig();
		//now, recalculate their stats
		StatsInv.DataObject.CreateDataStruct(StatsInv.Data, false);
		if (StatsInv.RPGMut != None)
		{
			StatsInv.RPGMut.ValidateData(StatsInv.DataObject);
			StatsInv.DataObject.CreateDataStruct(StatsInv.Data, false);
		}
		// but no reset. For this game they may have the benefit of the extra ability level
		return false;
	}
	

	// all ok
	Log("++++++++++ GI ValidateSubClassData ok player" @ Pawn(Owner).PlayerReplicationInfo.PlayerName @  "subclass:" $ curSubClass  );
	return true;
}

function ServerSetSubClass(RPGStatsInv StatsInv, int SubClassLevel)
{
	// player should have bought the SubClass ability. Now set the level correctly
	local int x, spaceindex;
	local MutRPGHUD HUDMut;
	local Mutator m;
	local string tmpstr;

	if (StatsInv == None || StatsInv.RPGMut == None || StatsInv.DataObject.Abilities.length == 0)
		return;
		
	// find the SubClass
	for (x = 0; x < StatsInv.DataObject.Abilities.length; x++)
		if (ClassIsChildOf(StatsInv.DataObject.Abilities[x], class'SubClass') )
		{
			StatsInv.DataObject.AbilityLevels[x] = SubClassLevel;
			StatsInv.Data.AbilityLevels[x] = SubClassLevel;
			
			ClientSetSubClass(SubClassLevel);		// now tell the client
			break;
		}
	// ok now let's make sure the scoreboard gets updated
	for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
		if (MutRPGHUD(m) != None)
		{
			HUDMut = MutRPGHUD(m);
			break;
		}
	if (HUDMut != None && Instigator != None && Instigator.PlayerReplicationInfo != None)
		for (x = 0; x < HUDMut.InitialXPs.Length; x++)
		{
			if(HUDMut.InitialXPs[x].PlayerName == Instigator.PlayerReplicationInfo.PlayerName)
			{
				// make sure subclass set correctly
    			tmpstr = class'SubClass'.default.SubClasses[SubClassLevel];
    			// but text is too long, so lets split at a space if we can
    			spaceindex = Instr(tmpstr," ");
    			if (spaceindex > 0)
           			HUDMut.InitialXPs[x].SubClass = Left (tmpstr, spaceindex);
           		else
           			HUDMut.InitialXPs[x].SubClass = tmpstr;
           		break;
			}
		}

}

simulated function ClientSetSubClass(int SubClassLevel)
{
	local int x;

	if (Level.NetMode == NM_Client) //already did this on listen/standalone servers
	{
		if (ClientStatsInv == None)
		{
			return;
		}
		for (x = 0; x < ClientStatsInv.Data.Abilities.length; x++)
			if (ClassIsChildOf(ClientStatsInv.Data.Abilities[x], class'SubClass') )
			{
				ClientStatsInv.Data.AbilityLevels[x] = SubClassLevel;
				x = ClientStatsInv.Data.Abilities.length;
			}
	
		if (ClientStatsInv.StatsMenu != None)
		{
			if (DruidsRPGStatsMenu(ClientStatsInv.StatsMenu) != None)
			{
			    if (DruidsRPGStatsMenu(ClientStatsInv.StatsMenu).GiveItems != None)
			    {
					DruidsRPGStatsMenu(ClientStatsInv.StatsMenu).InitFor(ClientStatsInv);
				}
				else
				{
					DruidsRPGStatsMenu(ClientStatsInv.StatsMenu).InitFor2(ClientStatsInv, self);
				}
			}
		}
		else
		{
			if (Player != None && Player.GUIController != None )
			{
				Player.GUIController.OpenMenu(string(class'DruidsRPGStatsMenu'));
				DruidsRPGStatsMenu(GUIController(Player.GUIController).TopPage()).InitFor2(ClientStatsInv,self);
			}
		}
	}	
}

function ServerGetAbilities(string SubClass)
{
	// player should have bought the SubClass ability. Now set the level correctly
	local int x, NumAbilities;
	NumAbilities = 0;
	for (x = 0; x < AbilityConfigs.Length; x++)
	{
		if (SubClass == AbilityConfigs[x].AvailableSubClass)
		{
			ClientReceiveSubClassAbilities(NumAbilities, AbilityConfigs[x].AvailableSubClass, AbilityConfigs[x].AvailableAbility, AbilityConfigs[x].MaxLevel);
			NumAbilities++;
		}
	}
	ClientSetSubClassSizes(SubClasses.Length,SubClassConfigs.Length,NumAbilities);		// set number of abilities

}


// Now some extra functions for selling player abilities
//Sell the player's abilities, but not classes. Called by the client from the stats menu, after clicking the obscenely small button and confirming it
function ServerSellData(PlayerReplicationInfo PRI, RPGStatsInv StatsInv)
{
	local int x;

	if (StatsInv == None || StatsInv.RPGMut == None || Level.Game.bGameRestarted || StatsInv.DataObject.Abilities.length == 0)
		return;
		
	// go through the abilities and lose the ones which are not classes
	for (x = 0; x < StatsInv.DataObject.Abilities.length; x++)
		if (!ClassIsChildOf(StatsInv.DataObject.Abilities[x], class'RPGClass') )
		{
			StatsInv.DataObject.Abilities.Remove(x, 1); 
			StatsInv.DataObject.AbilityLevels.Remove(x, 1);
			x--; 
		}

	// ok, are down now to just classes. Make sure the client data set is exactly the same
	StatsInv.Data.Abilities.length = 0;
	StatsInv.Data.AbilityLevels.length = 0;
	for (x = 0; x < StatsInv.DataObject.Abilities.length; x++)
	{
		StatsInv.Data.Abilities[x] = StatsInv.DataObject.Abilities[x];
		StatsInv.Data.AbilityLevels[x] = StatsInv.DataObject.AbilityLevels[x];
	}
	
	// so calculate points left. Could call RPGMut.ValidateData(), but instead lets force the user to reconnect to get his points to spend. Stops exploits.
	// should set to zero, but possible exploit with levelling, so set negative
	StatsInv.DataObject.PointsAvailable = -30;
	StatsInv.Data.PointsAvailable = -30;

	// and also reset the player. A bit over the top since we are forcing them to reset, but who cares.
	if (Instigator != None && Instigator.Health > 0)
	{
		//StatsInv.OwnerDied();
		// and remove artifacts ?
		Level.Game.SetPlayerDefaults(Instigator);
		OwnerEvent('ChangedWeapon');
		Timer();
	}

	// and tell the client to update itself.
	ClientRemoveAbilities(StatsInv);		// loses all abilities
	for (x = 0; x < StatsInv.DataObject.Abilities.length; x++)
	{
		ClientRemainingAbility(x, StatsInv.Data.Abilities[x], StatsInv.Data.AbilityLevels[x], StatsInv);	//StatsInv just references an object. The call doesn't pass the object, just the reference.
	}

}

simulated function ClientRemoveAbilities(RPGStatsInv thisStatsInv)
{
	if (Level.NetMode == NM_Client) //already did this on listen/standalone servers
	{
		thisStatsInv.Data.Abilities.length = 0;
		thisStatsInv.Data.AbilityLevels.length = 0;
		thisStatsInv.Data.PointsAvailable = -30;
		// also reset what abilities are in list to buy
		AbilityConfigs.Length = 0;	
		InitializedAbilities = False;
	}	
}

simulated function ClientRemainingAbility(int x, class<RPGAbility> thisAbility, int thisLevel, RPGStatsInv thisStatsInv)
{
	if (Level.NetMode == NM_Client) //already did this on listen/standalone servers
	{
		thisStatsInv.Data.Abilities[x] = thisAbility;
		thisStatsInv.Data.AbilityLevels[x] = thisLevel;
	}	
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     RemoteRole=ROLE_AutonomousProxy
}
