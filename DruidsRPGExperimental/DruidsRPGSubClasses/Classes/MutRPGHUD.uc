class MutRPGHUD extends Mutator;

// server side array for replicating xp etc
struct InitialXPValues
{
	Var String PlayerName;
	var RPGStatsInv StatsInv;
	var int InitialXP;
	var int AdditionalXP;
	var int Level;
	var int NeededXP;
	var int PlayerClass;
	var int XPGained;
	var string SubClass;
};
var Array<InitialXPValues> InitialXPs;

function ModifyPlayer(Pawn Other)
{
	Local ClientHudInv Inv;
	local ClientHudInv TempCInv;
	local String PlayerName;
	
	super.ModifyPlayer(Other);
	
	// now lets set up the xp score replication for players
	if (Other != None && Other.Controller != None && Other.Controller.isA('PlayerController') && Other.PlayerReplicationInfo != None) 
	{
		// lets see if we already have a ClientHudInv
		Inv = ClientHudInv(Other.FindInventoryType(class'ClientHudInv'));
		if (Inv == None)
		{
		    PlayerName = Other.PlayerReplicationInfo.PlayerName;
			if (Inv == None)
			{
				ForEach DynamicActors(class'ClientHudInv',TempCInv)
					if (TempCInv.OwnerName == PlayerName)
					{
						Inv = TempCInv;
					}
			}
			// no so lets allocate
			if (Inv == None)
			{
				Inv = Other.spawn(class'ClientHudInv', Other,,, rot(0,0,0));
				Inv.OwnerName = PlayerName;
			}
			//and give to user
			Inv.giveTo(Other);
		}	
	}
	if (Inv != None && Inv.HUDMut == None)
        Inv.HUDMut = self;	

	if (Other.Controller.isA('PlayerController'))
	{
	    if (Other.Level.Game.IsA('Invasion'))
	    {
			PlayerController(Other.Controller).ClientSetHUD(class'RPGHUDInvasion', class'RPGScoreboardInvasion');
		}
		else
		{
			PlayerController(Other.Controller).ClientSetHUD(class'RPGHUDInvasion', class<Scoreboard>(DynamicLoadObject(Level.Game.ScoreBoardType, class'Class')));
		}
	}

}

function PostBeginPlay()
{
	SetTimer(5, true);
	Super.PostBeginPlay();
}

function RPGStatsInv GetStatsInvFor(Controller C, optional bool bMustBeOwner)
{
	local Inventory Inv;

	for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
		if ( Inv.IsA('RPGStatsInv') && ( !bMustBeOwner || Inv.Owner == C || Inv.Owner == C.Pawn
						   || (Vehicle(C.Pawn) != None && Inv.Owner == Vehicle(C.Pawn).Driver) ) )
			return RPGStatsInv(Inv);

	//fallback - shouldn't happen
	if (C.Pawn != None)
	{
		Inv = C.Pawn.FindInventoryType(class'RPGStatsInv');
		if ( Inv != None && ( !bMustBeOwner || Inv.Owner == C || Inv.Owner == C.Pawn
				      || (Vehicle(C.Pawn) != None && Inv.Owner == Vehicle(C.Pawn).Driver) ) )
			return RPGStatsInv(Inv);
	}

	return None;
}

function SetupInitDetails(int x, Controller C)
{
	local int a;

	InitialXPs[x].StatsInv = GetStatsInvFor(C, false);
	if (InitialXPs[x].StatsInv != None && InitialXPs[x].StatsInv.DataObject != None)
	{
	  InitialXPs[x].InitialXP = InitialXPs[x].StatsInv.DataObject.Experience;
	  InitialXPs[x].Level = InitialXPs[x].StatsInv.DataObject.Level;
	  InitialXPs[x].NeededXP = InitialXPs[x].StatsInv.DataObject.NeededExp;
	  InitialXPs[x].AdditionalXP = 0;
	  InitialXPs[x].SubClass = "";
	  // ok now find the class, if any
	  InitialXPs[x].PlayerClass = 0;
	  for (a=0; a< InitialXPs[x].StatsInv.DataObject.Abilities.Length; a++)
	  {
	       if (InitialXPs[x].StatsInv.DataObject.Abilities[a] == class'ClassWeaponsMaster')
	           InitialXPs[x].PlayerClass = 1;
	       if (InitialXPs[x].StatsInv.DataObject.Abilities[a] == class'ClassAdrenalineMaster')
	           InitialXPs[x].PlayerClass = 2;
	       if (InitialXPs[x].StatsInv.DataObject.Abilities[a] == class'ClassMonsterMaster')
	           InitialXPs[x].PlayerClass = 3;
	       if (InitialXPs[x].StatsInv.DataObject.Abilities[a] == class'ClassEngineer')
	           InitialXPs[x].PlayerClass = 4;
	       if (InitialXPs[x].StatsInv.DataObject.Abilities[a] == class'ClassGeneral')
	           InitialXPs[x].PlayerClass = 5;
	
	       if (InitialXPs[x].StatsInv.DataObject.Abilities[a] == class'SubClass')
	    		if (InitialXPs[x].StatsInv.DataObject.AbilityLevels[a] > 0 && InitialXPs[x].StatsInv.DataObject.AbilityLevels[a] < class'SubClass'.default.SubClasses.length)
	    			InitialXPs[x].SubClass = class'SubClass'.default.SubClasses[InitialXPs[x].StatsInv.DataObject.AbilityLevels[a]];
	  }
	  //Log("***MutRPGHud Adding player:" $ x @ InitialXPs[x].PlayerName @ "class:" $ InitialXPs[x].PlayerClass @ "InitialXP:" $ InitialXPs[x].InitialXP @ "Level:" $ InitialXPs[x].Level @ "NeededXP:" $ InitialXPs[x].NeededXP);
	}
	else
	{
	  InitialXPs[x].InitialXP = -1;
	  InitialXPs[x].PlayerClass = -1;
	}

}

function Timer()
{
	local int x;
	Local Controller C;
	local string PlayerName;

	// create server side copy of data

	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding all players
		if ( C.Pawn != None && C.Pawn.PlayerReplicationInfo != None && Monster(C.Pawn) == None 			/* not PlayerController(C) != None as want to show scores for bots */ 
			  && DruidSentinelController(C) == None && DruidBaseSentinelController(C) == None && DruidDefenseSentinelController(C) == None && DruidLightningSentinelController(C) == None )	// not a sentinel
		{
		    PlayerName = C.Pawn.PlayerReplicationInfo.PlayerName;
		    x = 0;
		    while (x < InitialXPs.Length && InitialXPs[x].PlayerName != PlayerName)
		      x++;
		    if (x >= InitialXPs.Length)
		    {
		      //didnt find the player, so add
		       x = InitialXPs.Length;
		       InitialXPs.Length = x+1;
		       InitialXPs[x].PlayerName = PlayerName;
		       SetupInitDetails(x,C);
            }
            // now calculate xp gained
            if (InitialXPs[x].InitialXP >= 0 && InitialXPs[x].StatsInv != None && InitialXPs[x].StatsInv.DataObject != None)
            {
                // first see if have levelled
                if (InitialXPs[x].InitialXP >= 0 && InitialXPs[x].Level < InitialXPs[x].StatsInv.DataObject.Level)
                {
                    // have levelled
                    InitialXPs[x].AdditionalXP += InitialXPs[x].NeededXP - InitialXPs[x].InitialXP;
                    InitialXPs[x].InitialXP = 0;
                    InitialXPs[x].Level = InitialXPs[x].StatsInv.DataObject.Level;
                    InitialXPs[x].NeededXP = InitialXPs[x].StatsInv.DataObject.NeededExp;
 	  				//Log("***MutRPGHud Player leveled:" $ x @ InitialXPs[x].PlayerName @ "Experience:" $ InitialXPs[x].StatsInv.DataObject.Experience @ "InitialXP:" $ InitialXPs[x].InitialXP @ "AdditionalXP:" $ InitialXPs[x].AdditionalXP @ "Level:" $ InitialXPs[x].Level @ "NeededXP:" $ InitialXPs[x].NeededXP);
               }
  				//Log("***MutRPGHud Player values:" $ x @ InitialXPs[x].PlayerName @ "Experience:" $ InitialXPs[x].StatsInv.DataObject.Experience @ "InitialXP:" $ InitialXPs[x].InitialXP @ "AdditionalXP:" $ InitialXPs[x].AdditionalXP @ "Level:" $ InitialXPs[x].Level @ "NeededXP:" $ InitialXPs[x].NeededXP);
                InitialXPs[x].XPGained = InitialXPs[x].StatsInv.DataObject.Experience + InitialXPs[x].AdditionalXP - InitialXPs[x].InitialXP;
            }
            else
            {
 	  			//Log("***MutRPGHud Player problem with xp:" $ x @ InitialXPs[x].PlayerName @ "InitialXP:" $ InitialXPs[x].InitialXP @ "AdditionalXP:" $ InitialXPs[x].AdditionalXP @ "Level:" $ InitialXPs[x].Level @ "NeededXP:" $ InitialXPs[x].NeededXP);
            	// not got all the information we need. Can we fix this?
            	if (InitialXPs[x].StatsInv == None)
            	{
           			// try to setup again, for next time around loop
		       		SetupInitDetails(x,C);
	          	}
	          	else
	          	{
	          		if (InitialXPs[x].StatsInv.DataObject != None)
						InitialXPs[x].InitialXP = InitialXPs[x].StatsInv.DataObject.Experience;
	          	}
                InitialXPs[x].XPGained = -1;
            }
		}
		C = C.NextController;
	}
}

defaultproperties
{
     GroupName="RPGHUDInvasion"
     FriendlyName="Druid's Invasion RPG HUD"
     Description="Show Friendly Monsters In HUD and show monsters on a danger scale from Green to Red. Also show xp gained on Invasion scoreboard."
}
