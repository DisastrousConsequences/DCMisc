//=============================================================================
// Translocator Launcher
//=============================================================================
class UT2003TransLauncher extends TransLauncher;

defaultproperties
{
     AmmoChargeF=5.000000
     RepAmmo=5
     AmmoChargeMax=5.000000
     AmmoChargeRate=0.300000
     FireModeClass(0)=Class'UT2003TransLauncher.UT2003TransFire'
     FireModeClass(1)=Class'XWeapons.TransRecall'

     Description="The Translocator was originally designed by Liandri Corporation's R&D sector to facilitate the rapid recall of miners during tunnel collapses. However, rapid deresolution and reconstitution can have several unwelcome effects, including increases in aggression and paranoia.||In order to prolong the careers of today's contenders, limits have been placed on Translocator use in the lower-ranked leagues. The latest iteration of the Translocator features a remotely operated camera, exceptionally useful when scouting out areas of contention.|It should be noted that while viewing the camera's surveillance output, the user is effectively blind to their immediate surroundings."

     DisplayFOV=60.000000
     SmallViewOffset=(X=19.000000,Y=13.000000,Z=-10.500000)
     CustomCrosshair=2
     CustomCrossHairColor=(G=0,R=0)
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Cross3"
     PickupClass=Class'XWeapons.Transpickup'
     PlayerViewOffset=(X=7.000000,Y=7.000000,Z=-4.500000)
     AttachmentClass=Class'UT2003TransLauncher.UT2003TransAttachment'
     IconMaterial=Texture'InterfaceContent.HUD.SkinA'
     IconCoords=(X1=322,Y1=7,X2=444,Y2=98)
     ItemName="UT2003 Translocator"
     Mesh=SkeletalMesh'Weapons.TransLauncher_1st'
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'

//     Skins(0)=FinalBlend'EpicParticles.JumpPad.NewTransLaunBoltFB'
//     Skins(1)=Texture'WeaponSkins.Skins.NEWTranslocatorTEX'
//     Skins(2)=Texture'WeaponSkins.AmmoPickups.NEWTranslocatorPUCK'
//     Skins(3)=FinalBlend'WeaponSkins.AmmoPickups.NewTransGlassFB'
}
