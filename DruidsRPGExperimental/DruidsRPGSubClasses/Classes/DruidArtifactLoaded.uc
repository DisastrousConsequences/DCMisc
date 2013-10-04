class DruidArtifactLoaded extends RPGDeathAbility
	config(UT2004RPG) 
	abstract;

var config Array< class<RPGArtifact> > SlowArtifact;
var config Array< class<RPGArtifact> > QuickArtifact;
var config Array< class<RPGArtifact> > ExtraArtifact;
var config Array< class<RPGArtifact> > TeamArtifact;

var config int level1;
var config int level2;
var config int level3;
var config int level4;
var config int level5;

var config float WeaponDamage;
var config float AdrenalineDamage;
var config float AdrenalineUsage;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (CurrentLevel == 0)
		return default.level1;
	if (CurrentLevel == 1)
		return default.level2;
	if (CurrentLevel == 2)
		return default.level3;
	if (CurrentLevel == 3)
		return default.level4;
	if (CurrentLevel == 4)
		return default.level5;
	return 0;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int x;
	local LoadedInv LoadedInv;
	local bool Enhance;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedArtifacts && LoadedInv.LAAbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedArtifacts = true;
	LoadedInv.LAAbilityLevel = AbilityLevel;

	if(AbilityLevel >= 3)
		LoadedInv.ProtectArtifacts = true;
	else
		LoadedInv.ProtectArtifacts = false;
		
	if(AbilityLevel > 4)
		Enhance = true;
	else
		Enhance = false;

	for(x = 0; x < default.SlowArtifact.length; x++)
		if (default.SlowArtifact[x] != None)
			giveArtifact(other, default.SlowArtifact[x], Enhance);

	if(AbilityLevel > 1)
		for(x = 0; x < default.QuickArtifact.length; x++)
			if (default.QuickArtifact[x] != None)
				giveArtifact(other, default.QuickArtifact[x], Enhance);

	if(AbilityLevel > 2)
		for(x = 0; x < default.ExtraArtifact.length; x++)
			if (default.ExtraArtifact[x] != None)
				giveArtifact(other, default.ExtraArtifact[x], Enhance);

	if(AbilityLevel > 3)
		for(x = 0; x < default.TeamArtifact.length; x++)
			if (default.TeamArtifact[x] != None)
				giveArtifact(other, default.TeamArtifact[x], Enhance);
		
// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop wierd artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function giveArtifact(Pawn other, class<RPGArtifact> ArtifactClass, bool Enhance)
{
	local RPGArtifact Artifact;

	if(Other.IsA('Monster'))
		return;
	if(Other.findInventoryType(ArtifactClass) != None)
		return; //they already have one
		
	Artifact = Other.spawn(ArtifactClass, Other,,, rot(0,0,0));
	if(Artifact != None)
	{
		if (Enhance && EnhancedRPGArtifact(Artifact) != None)
			EnhancedRPGArtifact(Artifact).EnhanceArtifact(default.AdrenalineUsage);
		Artifact.giveTo(Other);
	}
}

static function GenuineDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	Local Inventory inv;

// If we end up with some wierdness here, it would be because we haven't
// ejected the player.  However, we shouldn't have to worry about that
// any more; it should be handled elsewhere, if needed.
	if(Killed.isA('Vehicle'))
	{
		Killed = Vehicle(Killed).Driver;
	}
// Wierdness - looks like sometimes PD called twice, particularly in VINV?
// Killed can become "None" somewhere along the line.
	if(Killed == None)
	{
		return;
	}

	for (inv=Killed.Inventory ; inv != None ; inv=inv.Inventory)
	{
		if(ClassIsChildOf(inv.class, class'UT2004RPG.RPGArtifact'))
		{
// Important note: *NO* artifact currently in possession will get dropped!
			inv.PickupClass = None;
		}
	}

	return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && AbilityLevel > 4)
	{
		if (ClassIsChildOf(DamageType, class'WeaponDamageType') || ClassIsChildOf(DamageType, class'VehicleDamageType'))
			Damage *= default.WeaponDamage;
		else
			Damage *= default.AdrenalineDamage;
	}
}

static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	if (ClassIsChildOf(item.InventoryType, class'EnhancedRPGArtifact'))
	{
		if(Other.findInventoryType(item.InventoryType) != None)
		{
			bAllowPickup = 0;	// not allowed
			return true; 		//they already have one, and ours is probably enhanced already
		}
	}
	return false;		// don't know, so let someone else decide
}


DefaultProperties
{
	AbilityName="Loaded Artifacts"
	Description="When you spawn:|Level 1: You are granted all slow drain artifacts and a magic weapon maker.|Level 2: You are granted all fast drain artifacts and some special artifacts.|Level 3: Your breakable artifacts are made unbreakable, and you get some extra artifacts.|Level 4: You get team artifacts.|Extreme level 5 reduces adrenaline used in offensive attacks, but reduces damage from weapons|Cost (per level): 2,9,16,9,15"
	
	StartingCost=2
	CostAddPerLevel=7
	MaxLevel=5
		  
	level1=2
	level2=9
	level3=16
	level4=9
	level5=15
	
	WeaponDamage=0.5
	AdrenalineDamage=2.0
	AdrenalineUsage=0.5

	SlowArtifact[0]=class'UT2004RPG.ArtifactFlight'
	SlowArtifact[1]=class'UT2004RPG.ArtifactTeleport'
	SlowArtifact[2]=class'DruidArtifactSpider'
	SlowArtifact[3]=class'DruidArtifactMakeMagicWeapon'
	
	QuickArtifact[0]=class'DruidDoubleModifier'
	QuickArtifact[1]=class'DruidMaxModifier'
	QuickArtifact[2]=class'DruidPlusOneModifier'
	QuickArtifact[3]=class'UT2004RPG.ArtifactInvulnerability'
	QuickArtifact[4]=class'DruidArtifactTripleDamage'
	QuickArtifact[5]=class'DruidArtifactLightningRod'

	ExtraArtifact[0]=Class'ArtifactLightningBolt'
	ExtraArtifact[1]=Class'ArtifactLightningBeam'
	ExtraArtifact[2]=Class'ArtifactMegaBlast'
	ExtraArtifact[3]=Class'ArtifactFreezeBomb'
	ExtraArtifact[4]=Class'ArtifactPoisonBlast'
	ExtraArtifact[5]=Class'ArtifactRepulsion'

	TeamArtifact[0]=Class'ArtifactSphereInvulnerability'
	TeamArtifact[1]=Class'ArtifactSphereDamage'
	TeamArtifact[2]=Class'ArtifactRemoteDamage'
	TeamArtifact[3]=Class'ArtifactRemoteInvulnerability'
	TeamArtifact[4]=Class'ArtifactRemoteMax'
}
