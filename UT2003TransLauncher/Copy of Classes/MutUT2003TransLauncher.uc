class MutUT2003TransLauncher extends Mutator;

function ModifyPlayer(Pawn Other)
{
    Other.GiveWeapon("UT2003TransLauncher.UT2003TransLauncher");

	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}


function string GetInventoryClassOverride(string InventoryClassName)
{
	if (InventoryClassName ~= "XWeapons.TransLauncher")
		return "UT2003TransLauncher.UT2003TransLauncher";

	return Super.GetInventoryClassOverride(InventoryClassName);
}

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local int i;
	local WeaponLocker L;

	bSuperRelevant = 0;
        if ( xWeaponBase(Other) != None )
        {
		if ( xWeaponBase(Other).WeaponType == class'XWeapons.TransLauncher' )
			xWeaponBase(Other).WeaponType = class'UT2003TransLauncher.UT2003TransLauncher';
	}
	else if ( TransPickup(Other) != None )
		ReplaceWith( Other, "UT2003TransLauncher.UT2003TransLauncher");
	else if ( WeaponLocker(Other) != None )
	{
		L = WeaponLocker(Other);
		for (i = 0; i < L.Weapons.Length; i++)
			if (L.Weapons[i].WeaponClass == class'XWeapons.TransLauncher')
				L.Weapons[i].WeaponClass = class'UT2003TransLauncher.UT2003TransLauncher';
		return true;
	}
	else
		return true;
	return false;
}

defaultproperties
{
     GroupName="UT2003Trans"
     FriendlyName="UT2003 TransLauncher"
     Description="Gives all players a UT2003 TransLauncher"
}