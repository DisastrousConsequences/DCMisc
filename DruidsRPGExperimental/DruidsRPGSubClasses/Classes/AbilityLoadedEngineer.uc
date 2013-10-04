class AbilityLoadedEngineer extends RPGAbility
	config(UT2004RPG)
	abstract;

struct SentinelConfig
{
	Var String FriendlyName;
	var Class<Pawn> Sentinel;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
	var int Level;
};
var config Array<SentinelConfig> SentinelConfigs;

struct TurretConfig
{
	Var String FriendlyName;
	var Class<Pawn> Turret;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
	var int Level;
};
var config Array<TurretConfig> TurretConfigs;

struct VehicleConfig
{
	Var String FriendlyName;
	var Class<Pawn> Vehicle;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
	var int Level;
};
var config Array<VehicleConfig> VehicleConfigs;

struct BuildingConfig
{
	Var String FriendlyName;
	var Class<Pawn> Building;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
	var int Level;
};
var config Array<BuildingConfig> BuildingConfigs;

var config int PointsPerLevel;
var config Array<string> IncludeVehicleGametypes;

var config float WeaponDamage;
var config float AdrenalineDamage;
var config float VehicleDamage;
var config float SentinelDamage;
var config int MaxNormalLevel;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.Level < ((CurrentLevel+1)*6))
		return 0;

	return super.Cost(Data, CurrentLevel);
}

static function SetShieldHealingLevel(Pawn Other, RW_EngineerLink EGun)
{
	local int x;
	local RPGStatsInv StatsInv;

	if (EGun == None || Other == None)
		return;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityShieldHealing')
		{	// code duplicated from AbilityShieldHealing.ModifyPlayer
			EGun.HealingLevel = StatsInv.Data.AbilityLevels[x];
			EGun.ShieldHealingPercent = class'AbilityShieldHealing'.default.ShieldHealingPercent;
		}

	return;
}

static function EngineerPointsInv GetEngInv(Pawn Other)
{
	local EngineerPointsInv EInv;
	local RPGStatsInv StatsInv;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	EInv = EngineerPointsInv(Other.FindInventoryType(class'EngineerPointsInv'));
	if (EInv != None && StatsInv != None)
		EInv.PlayerLevel = StatsInv.Data.Level;
	
	// if they haven't got one, its time they had.
	if(EInv == None)
	{
		EInv = Other.spawn(class'EngineerPointsInv', Other,,, rot(0,0,0));
		if(EInv == None)
		{
			return EInv; //get it later I guess?
		}
		EInv.UsedBuildingPoints = 0;
		EInv.UsedSentinelPoints = 0;
		EInv.UsedVehiclePoints = 0;
		EInv.UsedTurretPoints = 0;
		EInv.FastBuildPercent = 1.0;
		if (StatsInv != None)
			EInv.PlayerLevel = StatsInv.Data.Level;
		EInv.giveTo(Other);
	}
	return EInv;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int i;
	local LoadedInv LoadedInv;
	Local RPGArtifact Artifact;
	Local bool PreciseLevel;
	local Inventory OInv;
	local Weapon NewWeapon;
	local EngineerPointsInv EInv;
	local bool bAddVehicles;
	local bool bGotTrans;
	local EngTransLauncher ETrans;
	local RW_EngineerLink EGun;
	local int Level;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedEngineer)
		{
			if (LoadedInv.LEAbilityLevel == AbilityLevel)
				return;
			PreciseLevel = true; //only giving artifacts for this level.
		}
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
		PreciseLevel = false; 	//give all artifacts up to this level.
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedEngineer = true;
	LoadedInv.LEAbilityLevel = AbilityLevel;

	EInv = GetEngInv(Other);
	if (EInv != None)
	{
		EInv.TotalBuildingPoints = AbilityLevel*Default.PointsPerLevel;
		EInv.TotalSentinelPoints = AbilityLevel*Default.PointsPerLevel;
		EInv.TotalVehiclePoints = AbilityLevel*Default.PointsPerLevel;
		EInv.TotalTurretPoints = AbilityLevel*Default.PointsPerLevel;
	}

	// see if we need to add vehicles as well
	bAddVehicles = false;
	for(i = 0; i < Default.IncludeVehicleGametypes.length; i++)
	{
		if (caps(Default.IncludeVehicleGametypes[i]) == "ALL"
		 || (Other.Level.Game != None && instr(caps(Other.Level.Game.GameName), caps(Default.IncludeVehicleGametypes[i])) > -1))
			bAddVehicles = true;
	}

	// ok, now lets give them the spawning artifacts
	for(i = 0; i < Default.SentinelConfigs.length; i++)
	{
		if(Default.SentinelConfigs[i].Sentinel != None) //make sure the object is sane.
		{
			Level = Default.SentinelConfigs[i].Level;
			if (Level == 0)
				Level = Default.SentinelConfigs[i].Points/Default.PointsPerLevel;		// in case not specified in ini
			if(Level <= AbilityLevel)
			{
				if (PreciseLevel && Level < AbilityLevel)
					continue;
				Artifact = Other.spawn(class'DruidSentinelSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidSentinelSummon(Artifact).Setup(Default.SentinelConfigs[i].FriendlyName, Default.SentinelConfigs[i].Sentinel, Default.SentinelConfigs[i].Points, Default.SentinelConfigs[i].StartHealth, Default.SentinelConfigs[i].NormalHealth, Default.SentinelConfigs[i].RecoveryPeriod);
				Artifact.GiveTo(Other);
			}
		}
	}

	for(i = 0; i < Default.TurretConfigs.length; i++)
	{
		if(Default.TurretConfigs[i].Turret != None) //make sure the object is sane.
		{
			Level = Default.TurretConfigs[i].Level;
			if (Level == 0)
				Level = Default.TurretConfigs[i].Points/Default.PointsPerLevel;		// in case not specified in ini
			if(Level <= AbilityLevel)
			{
				if (PreciseLevel && Level < AbilityLevel)
					continue;
				Artifact = Other.spawn(class'DruidTurretSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidTurretSummon(Artifact).Setup(Default.TurretConfigs[i].FriendlyName, Default.TurretConfigs[i].Turret, Default.TurretConfigs[i].Points, Default.TurretConfigs[i].StartHealth, Default.TurretConfigs[i].NormalHealth, Default.TurretConfigs[i].RecoveryPeriod);
				Artifact.GiveTo(Other);
			}
		}
	}

	if (bAddVehicles)
	{
		for(i = 0; i < Default.vehicleConfigs.length; i++)
		{
			if(Default.vehicleConfigs[i].vehicle != None) //make sure the object is sane.
			{
				Level = Default.vehicleConfigs[i].Level;
				if (Level == 0)
					Level = Default.vehicleConfigs[i].Points/Default.PointsPerLevel;		// in case not specified in ini
				if(Level <= AbilityLevel)
				{
					if (PreciseLevel && Level < AbilityLevel)
						continue;
					Artifact = Other.spawn(class'DruidvehicleSummon', Other,,, rot(0,0,0));
					if(Artifact == None)
						continue; // wow.
					DruidvehicleSummon(Artifact).Setup(Default.vehicleConfigs[i].FriendlyName, Default.vehicleConfigs[i].vehicle, Default.vehicleConfigs[i].Points, Default.vehicleConfigs[i].StartHealth, Default.vehicleConfigs[i].NormalHealth, Default.vehicleConfigs[i].RecoveryPeriod);
					Artifact.GiveTo(Other);
				}
			}
		}
	}

	for(i = 0; i < Default.BuildingConfigs.length; i++)
	{
		if(Default.BuildingConfigs[i].Building != None) //make sure the object is sane.
		{
			Level = Default.BuildingConfigs[i].Level;
			if (Level == 0)
				Level = Default.BuildingConfigs[i].Points/Default.PointsPerLevel;		// in case not specified in ini
			if(Level <= AbilityLevel)
			{
				if (PreciseLevel && Level < AbilityLevel)
					continue;
				Artifact = Other.spawn(class'DruidBuildingSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidBuildingSummon(Artifact).Setup(Default.BuildingConfigs[i].FriendlyName, Default.BuildingConfigs[i].Building, Default.BuildingConfigs[i].Points, Default.BuildingConfigs[i].StartHealth, Default.BuildingConfigs[i].NormalHealth, Default.BuildingConfigs[i].RecoveryPeriod);
				Artifact.GiveTo(Other);
			}
		}
	}

	// ok,lets add the kill artifacts
	if(!PreciseLevel)
	{
		Artifact = Other.spawn(class'ArtifactKillAllSentinels', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
		Artifact = Other.spawn(class'ArtifactKillAllTurrets', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
		if (bAddVehicles)
		{
			Artifact = Other.spawn(class'ArtifactKillAllVehicles', Other,,, rot(0,0,0));
			Artifact.GiveTo(Other);
		}
		Artifact = Other.spawn(class'ArtifactKillAllBuildings', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
	}

// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop weird artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();

	// lets see if they have a translocator. If not, then perhaps running a gametype that transing isn't a good idea
	// give them a limited translocator that will let them spawn items, but not translocate
	bGotTrans = false;
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(instr(caps(OInv.ItemName), "TRANSLOCATOR") > -1 && ClassIsChildOf(OInv.Class,class'Weapon'))
		{
			bGotTrans=true;
		}
	}
	if (!bGotTrans)
	{
		ETrans = Other.spawn(class'EngTransLauncher', Other,,, rot(0,0,0));
		if (ETrans != None)
			ETrans.GiveTo(Other);
	}

	// Now let's give the EngineerLinkGun
	EGun = None;
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(ClassIsChildOf(OInv.Class,class'RW_EngineerLink'))
		{
			EGun = RW_EngineerLink(OInv);
			break;
		}
	}
	if (EGun != None)
		return; //already got one

	// now add the new one.
	NewWeapon = Other.spawn(class'EngineerLinkGun', Other,,, rot(0,0,0));
	if(NewWeapon == None)
		return;
	while(NewWeapon.isA('RPGWeapon'))
		NewWeapon = RPGWeapon(NewWeapon).ModifiedWeapon;

	EGun = Other.spawn(class'RW_EngineerLink', Other,,, rot(0,0,0));
	if(EGun == None)
		return;

	EGun.Generate(None);
	if(EGun != None)
		SetShieldHealingLevel(Other, EGun);	// set shield healing level
	
	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(EGun != None)
		EGun.SetModifiedWeapon(NewWeapon, true);

	if(EGun != None)
		EGun.GiveTo(Other);

}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local float KillScore;
	local Controller PlayerSpawner;
	local TeamPlayerReplicationInfo TPPI;
	local class<Vehicle> V;
	local int i;
	local TeamPlayerReplicationInfo.VehicleStats NewVehicleStats;

	// score and stats not generated for sentinels. So add here.
	if (!bOwnedByKiller)
		return;

	if (Killer == None || Killed == None)
		return;

	PlayerSpawner = None;
	if (DruidSentinelController(Killer) != None)
		PlayerSpawner = DruidSentinelController(Killer).PlayerSpawner;
	else if (DruidBaseSentinelController(Killer) != None)
		PlayerSpawner = DruidBaseSentinelController(Killer).PlayerSpawner;
	else if (DruidLightningSentinelController(Killer) != None)
		PlayerSpawner = DruidLightningSentinelController(Killer).PlayerSpawner;
	else if (DruidEnergyWallController(Killer) != None)
		PlayerSpawner = DruidEnergyWallController(Killer).PlayerSpawner;
	else
		return;	// not a sentinel controller

	if (PlayerSpawner == None)
		return;

	// now, don't want to add points to killer, but to owner.
	if (PlayerSpawner.PlayerReplicationInfo == None)
		return;

	// ok, first lets add the stats
	PlayerSpawner.PlayerReplicationInfo.Kills++;
	KillScore = float(Killed.Pawn.GetPropertyText("ScoringValue"));
	if (KillScore < 1.0)
		KillScore = 1.0;
	PlayerSpawner.PlayerReplicationInfo.Score += KillScore;
	PlayerSpawner.PlayerReplicationInfo.Team.Score += KillScore;
	PlayerSpawner.PlayerReplicationInfo.Team.NetUpdateTime = PlayerSpawner.Level.TimeSeconds - 1;
	PlayerSpawner.AwardAdrenaline(KillScore);
	PlayerSpawner.PlayerReplicationInfo.NetUpdateTime = PlayerSpawner.Level.TimeSeconds - 1;
	TPPI = TeamPlayerReplicationInfo(PlayerSpawner.PlayerReplicationInfo);
	if (TPPI != None && Killer.Pawn != None)
	{
		v = class<Vehicle>(Killer.Pawn.Class);
		for (i = 0; i < TPPI.VehicleStatsArray.Length && i<200; i++)
			if (TPPI.VehicleStatsArray[i].VehicleClass == V)
			{
				TPPI.VehicleStatsArray[i].Kills++;
				return;
			}
		NewVehicleStats.VehicleClass = V;
		NewVehicleStats.Kills = 1;
		TPPI.VehicleStatsArray[TPPI.VehicleStatsArray.Length] = NewVehicleStats;
	}

}

static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	local class<Weapon> NewWeaponClass;

	if (RPGLinkGunPickup(item) != None)
	{
		bAllowPickup = 0;	// not allowed
		return true;
	}
	else if (WeaponPickup(item) != None && WeaponPickup(item).InventoryType != None)
	{
		NewWeaponClass = class<Weapon>(WeaponPickup(item).InventoryType);
		if (NewWeaponClass != None && ClassIsChildOf(NewWeaponClass, class'RPGLinkGun'))
		{
			bAllowPickup = 0;	// not allowed
			return true;
		}
	}
	else if (WeaponLocker(item) != None && WeaponLocker(item).InventoryType != None)
	{
		NewWeaponClass = class<Weapon>(WeaponLocker(item).InventoryType);
		if (NewWeaponClass != None && ClassIsChildOf(NewWeaponClass, class'RPGLinkGun'))
		{
			bAllowPickup = 0;	// not allowed
			return true;
		}
	}
	return false;			// don't know, so let someone else decide
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local vehicle V;
	
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && AbilityLevel > default.MaxNormalLevel)
	{
		if (ClassIsChildOf(DamageType, class'VehicleDamageType'))
		{
			//Log("*** LEng Damage:" $ Damage @ "from:" $ Instigator @ "type:" $ DamageType @ "vehicle, so adjusted by:" $ default.VehicleDamage);
			Damage *= default.VehicleDamage;
		}
		else
			if (ClassIsChildOf(DamageType, class'WeaponDamageType'))
			{
				// ok, using a weapon. But are we in a turret or vehicle?
				V = Vehicle(Instigator);
				if (V != None )
				{
					//Log("*** LEng Damage:" $ Damage @ "from:" $ Instigator @ "type:" $ DamageType @ "vehicle, so adjusted by:" $ default.VehicleDamage);
					Damage *= default.VehicleDamage;
				}
				else
					// not in vehicle. Is sentinel?
					if (Instigator.Controller != None && 
						(DruidSentinelController(Instigator.Controller) != None || DruidBaseSentinelController(Instigator.Controller) != None || DruidLightningSentinelController(Instigator.Controller) != None || DruidEnergyWallController(Instigator.Controller) != None))
					{
						// I don't think we actually get here, as sentinels do not get the abilities added.
						//Log("*** LEng Damage:" $ Damage @ "from:" $ Instigator @ "type:" $ DamageType @ "sentinel, so adjusted by:" $ default.SentinelDamage);
						Damage *= default.SentinelDamage;
					}
					else
					{
						//Log("*** LEng Damage:" $ Damage @ "from:" $ Instigator @ "type:" $ DamageType @ "weapon, so adjusted by:" $ default.WeaponDamage);
						Damage *= default.WeaponDamage;
					}
			}
			else
			{
				// this code is here for consistency. Nothing actually uses at the mo, cos rod etc bypass this with the superweapon flag.
				//Log("*** LEng Damage:" $ Damage @ "from:" $ Instigator @ "type:" $ DamageType @ "adrenaline, so adjusted by:" $ default.AdrenalineDamage);
				Damage *= default.AdrenalineDamage;
			}
	}
}

defaultproperties
{
     AbilityName="Loaded Engineer"
     Description="Learn sentinels, turrets, vehicle and buildings to summon. At each level, you can summon better items. You need to have a level six times the ability level you wish to purchase. |Cost (per level): 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17..."
     StartingCost=3
     CostAddPerLevel=1
     MaxLevel=30
     PointsPerLevel=1
//I assume you'll either use the provided config, or come up with your own. This one is provided as reference.
     SentinelConfigs(0)=(FriendlyName="Sentinel",Sentinel=Class'DruidSentinel',Points=3,StartHealth=5,NormalHealth=300,RecoveryPeriod=60)
     vehicleConfigs(0)=(FriendlyName="Scorpion",Vehicle=Class'Onslaught.ONSRV',Points=3,StartHealth=10,NormalHealth=300,RecoveryPeriod=60)
// now say which gametypes to include vehicles. "All" will include in all games
     IncludeVehicleGametypes(0)="Vehicle"
     IncludeVehicleGametypes(1)="Onslaught"
     
     MaxNormalLevel=15
     WeaponDamage=0.8
     AdrenalineDamage=0.5
     VehicleDamage=1.5
     SentinelDamage=1.2
}
