class AbilityLoadedHealing extends RPGAbility
	config(UT2004RPG)
	abstract;

var config int Lev2Cap;
var config int Lev3Cap;

var config bool enableSpheres;

var config float WeaponDamage;
var config float HealingDamage;
var config float AdrenalineUsage;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactMakeSuperHealer AMSH;
	local ArtifactHealingBlast AHB;
	local ArtifactSphereHealing ASpH;

	if(Monster(Other) != None)
		return; //Not for pets

	AMSH = ArtifactMakeSuperHealer(Other.FindInventoryType(class'ArtifactMakeSuperHealer'));

	if(AMSH != None)
	{
		if(AMSH.AbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		AMSH = Other.spawn(class'ArtifactMakeSuperHealer', Other,,, rot(0,0,0));
		if(AMSH == None)
			return; //get em next pass I guess?

		AMSH.giveTo(Other);
		// I'm guessing that NextItem is here to ensure players don't start with
		// no item selected.  So the if should stop wierd artifact scrambles.
		if(Other.SelectedItem == None)
			Other.NextItem();
	}
	AMSH.AbilityLevel = AbilityLevel;
	if(AbilityLevel == 2)
		AMSH.MaxHealth = Default.Lev2Cap;
	if(AbilityLevel >= 3)
	{
		AMSH.MaxHealth = Default.Lev3Cap;
		if (AbilityLevel >= 4)
			AMSH.HealingDamage = default.HealingDamage;
		if(default.enableSpheres)
		{
			// ok let's give them some artifacts
			AHB = ArtifactHealingBlast(Other.FindInventoryType(class'ArtifactHealingBlast'));
			if(AHB == None)
			{
				AHB = Other.spawn(class'ArtifactHealingBlast', Other,,, rot(0,0,0));
				if(AHB == None)
					return; //get em next pass I guess?

				if (AbilityLevel >= 4)
					AHB.EnhanceArtifact(default.AdrenalineUsage);
				AHB.giveTo(Other);
				// I'm guessing that NextItem is here to ensure players don't start with
				// no item selected.  So the if should stop wierd artifact scrambles.
				if(Other.SelectedItem == None)
					Other.NextItem();
			}
			ASpH = ArtifactSphereHealing(Other.FindInventoryType(class'ArtifactSphereHealing'));
			if(ASpH == None)
			{
				ASpH = Other.spawn(class'ArtifactSphereHealing', Other,,, rot(0,0,0));
				if(ASpH == None)
					return; //get em next pass I guess?

				if (AbilityLevel >= 4)
					ASpH.EnhanceArtifact(default.AdrenalineUsage);
				ASpH.giveTo(Other);
				// I'm guessing that NextItem is here to ensure players don't start with
				// no item selected.  So the if should stop wierd artifact scrambles.
				if(Other.SelectedItem == None)
					Other.NextItem();
			}
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && AbilityLevel >= 4)
	{
		// half weapon damage
		if (ClassIsChildOf(DamageType, class'WeaponDamageType') || ClassIsChildOf(DamageType, class'VehicleDamageType'))
			Damage *= default.WeaponDamage;
	}
}

defaultproperties
{
     AbilityName="Loaded Medic"
     Description="Gives you bonuses towards healing.|Level 1 gives you a Medic Weapon Maker. |Level 2 allows you to use the Medic Gun to heal teammates +100 beyond their max health. |Level 3 allows you to heal teammates +150 points beyond their max health. Level 4 gives extra healing power for the medic weapon and less adrenaline requirements for healing artifacts, but less weapon damage(|Cost (per level): 3,6,9,12"
     StartingCost=3
     CostAddPerLevel=3
     Lev2Cap=100
     Lev3Cap=150
     MaxLevel=4
     enableSpheres = false
     WeaponDamage=0.5
     HealingDamage=3.0
     AdrenalineUsage=0.5
}
