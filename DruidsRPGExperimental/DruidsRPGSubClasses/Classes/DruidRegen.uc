class DruidRegen extends AbilityRegen
	config(UT2004RPG) 
	abstract;

var config int AdjustableMultiplierPerLevel;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.HealthBonus < default.AdjustableMultiplierPerLevel * (CurrentLevel + 1))
		return 0;
	
	return super.Cost(Data, CurrentLevel);
}

defaultproperties
{
     Description="Heals 1 health per second per level. Does not heal past starting health amount. You must have a Health Bonus stat equal to 30 times the ability level you wish to have before you can purchase it. |Cost (per level): 15,20,25,30,..."
     AdjustableMultiplierPerLevel=30
     MaxLevel=10
}