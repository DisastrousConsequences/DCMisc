class RW_Vorpal extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if ( ClassIsChildOf(Weapon, class'ShieldGun') || ClassIsChildOf(Weapon, class'SniperRifle') || ClassIsChildOf(Weapon, class'ONSAVRiL') || ClassIsChildOf(Weapon, class'ShockRifle') || ClassIsChildOf(Weapon, class'ClassicSniperRifle'))
		return true;

	if(instr(caps(string(Weapon)), "AVRIL") > -1)//hack for vinv avril
		return true;

	return false;
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local int Chance;
	local Actor A;

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(Victim == None)
		return; //nothing to do

	if(damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}

	Chance = Modifier - MinModifier;

	if(Damage > 0 && Chance >= rand(99))
	{
		//this is a vorpal hit. Frag them.

		//fire the sound

		if(Victim != None && Victim.isA('Pawn'))
		{
			A = spawn(class'RocketExplosion',,, Instigator.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'WeaponSounds.Misc.instagib_rifleshot',,2.5*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
			}
			
			if(Victim != None)
				Pawn(Victim).Died(Instigator.Controller, DamageType, Victim.Location);
				
			if(Victim != None)
			{
				A = spawn(class'RocketExplosion',,, Victim.Location);
				
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
					A.PlaySound(sound'WeaponSounds.Misc.instagib_rifleshot',,2.5*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
				}
			}
		}
	}
}

defaultproperties
{
	  DamageBonus=0.100000
	  ModifierOverlay=Shader'XGameShaders.BRShaders.BombIconYS'
	  MinModifier=6
	  MaxModifier=10
	  AIRatingBonus=0.080000
	  PrefixPos="Vorpal "
}