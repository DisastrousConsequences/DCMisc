class UT2003TransAttachment extends xWeaponAttachment;

function InitFor(Inventory I)
{
    Super.InitFor(I);
}

simulated event ThirdPersonEffects()
{
    Super.ThirdPersonEffects();
}

defaultproperties
{
     bHeavy=True
     Mesh=SkeletalMesh'Weapons.TransLauncher_3rd'
}
