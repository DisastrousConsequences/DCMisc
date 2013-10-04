class InvWeaponGameRules extends GameRules
	config(InvWeapon);

var config float ShieldGunMultiplier;
var config float AvrilMultiplier;
var config float VehicleMultiplier;
var config float MonsterVehicleMultiplier;

function int NetDamage(int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(injured != None && injured.isA('Monster'))
	{
		if(ClassIsChildOf(DamageType, class'DamTypeShieldImpact'))
			Damage = Damage * ShieldGunMultiplier;
		else if(ClassIsChildOf(DamageType, class'DamTypeONSAVRiLRocket') || instr(caps(string(DamageType)), "AVRIL") > -1)//hack for vinv avril
			Damage = Damage * AvrilMultiplier;
		else if(ClassIsChildOf(DamageType, class'DamTypeRoadkill'))
			Damage = Damage * VehicleMultiplier;
	}
	else if(injured != None && injured.isA('Vehicle') && instigatedBy != None && instigatedBy.isA('Monster'))
		Damage = Damage * MonsterVehicleMultiplier;

	return super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     ShieldGunMultiplier=1.750000
     AvrilMultiplier=2.500000
     VehicleMultiplier=0.050000
     MonsterVehicleMultiplier=3.000000
}