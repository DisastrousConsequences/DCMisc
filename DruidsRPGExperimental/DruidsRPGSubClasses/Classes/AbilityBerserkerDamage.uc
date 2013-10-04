class AbilityBerserkerDamage extends RPGAbility
	config(UT2004RPG) 
	abstract;

var config int RequiredLevel;
var config float MinDamageBonus, MaxDamageBonus;
var config float MaxDamageDist;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if(Data.Level < (default.RequiredLevel + CurrentLevel*2))
		return 0;

	return Super.Cost(Data, CurrentLevel);
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float damageScale, dist, distScale;
	local vector dir;

	if (DamageType == class'DamTypeRetaliation' || Injured == Instigator || Instigator == None || Damage <= 0)
		return;
		
	// extra damage done depends on closeness to enemy. Up close do more damage and take less damage, due to the adrenaline. Further away not so good. 
	dir = Instigator.Location - Injured.Location;
	dist = FMax(1,VSize(dir));
	
	if (dist > default.MaxDamageDist)
		distScale = 0.0;
	else
		distScale = 1 - FMax(0,dist/default.MaxDamageDist);

	if (bOwnedByInstigator) 
	{
		// the higher distScale the more damage
		damageScale = default.MinDamageBonus + distscale * (default.MaxDamageBonus - default.MinDamageBonus);
		Damage *= (1 + (AbilityLevel * damageScale));
	}
	else
	{
		// the higher distScale the lower the damage
		damageScale = default.MaxDamageBonus - distscale * (default.MaxDamageBonus - default.MinDamageBonus);
		Damage *= (1 + (AbilityLevel * damageScale));
	}
}

DefaultProperties
{
	AbilityName="Berserker Damage Bonus"
	Description="Increases your cumulative total damage bonus by 5-15% per level, depending on closeness to enemy. However, you also take 5-15% extra damage per level, again depending on how close. |Cost (per level): 10. You must be level 60 to purchase the first level of this ability, level 62 to purchase the second level, and so on."
	
	MinDamageBonus=0.050000
	MaxDamageBonus=0.150000
	MaxDamageDist=2500
	RequiredLevel=60
	StartingCost=10
	CostAddPerLevel=0
	MaxLevel=20
}