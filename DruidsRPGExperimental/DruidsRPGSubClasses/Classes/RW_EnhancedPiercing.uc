class RW_EnhancedPiercing extends RW_Piercing
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		Damage = Max(Damage, OriginalDamage); //smokes any reduction. This wont affect reduction because of skills though.
		//if I Ever think of coding up a "skill" that does damage reduction, I'll have to do math
		// here to increase the damage up enough that the reduction results in nothing.
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}

	super.AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);
}

defaultproperties
{
	DamageBonus=0.050000
	MaxModifier=6
	MinModifier=-2
	PrefixNeg="Piercing "
}
