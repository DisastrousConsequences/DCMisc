class DruidAdrenalineSurge extends AbilityAdrenalineSurge
	config(UT2004RPG) 
	abstract;

var config int AdjustableStartingDamage, AdjustableStartingAdrenaline;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.AdrenalineMax < default.AdjustableStartingAdrenaline || Data.Attack < default.AdjustableStartingDamage)
		return 0;

	return super.Cost(Data, CurrentLevel);
}

defaultproperties
{
     Description="For each level of this ability, you gain 50% more adrenaline from all kill related adrenaline bonuses. You must have a Damage Bonus of at least 50 and an Adrenaline Max stat at least 150 to purchase this ability. |Cost (per level): 2,8..."
     StartingCost=2
     CostAddPerLevel=6

     AdjustableStartingDamage=50
     AdjustableStartingAdrenaline=150
     MaxLevel=4
}