class UT2003TransFire extends ProjectileFire;

var() Sound TransFireSound;
var() Sound RecallFireSound;
var UT2003TransDummyBeacon DummyBeacon;
var TransRecallEffect RecallEffect;
var bool bBeaconDeployed; // meaningful for client
var() String TransFireForce;
var() String RecallFireForce;

simulated function DestroyEffects()
{
	Super.DestroyEffects();
	
    if (DummyBeacon != None)
        DummyBeacon.Destroy();

    if (RecallEffect != None)
        RecallEffect.Destroy();
}

function InitEffects()
{
    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    Super.InitEffects();
    
    if( DummyBeacon == None )
        DummyBeacon = Spawn(class'UT2003TransDummyBeacon');
    Weapon.AttachToBone(DummyBeacon, 'beaconbone');
    if ( RecallEffect == None )
        RecallEffect = Spawn(class'TransRecallEffect');
    Weapon.AttachToBone(RecallEffect, 'beaconbone');

    SetTimer(0.1, true);
}

simulated function PlayFiring()
{
    if (!bBeaconDeployed)
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
        ClientPlayForceFeedback( TransFireForce );  // jdf
    }
}

function Rotator AdjustAim(Vector Start, float InAimError)
{
    return Instigator.Controller.Rotation;
}

simulated function bool AllowFire()
{
    return ( UT2003TransLauncher(Weapon).AmmoChargeF >= 1.0 );
}

simulated function DoRecallEffect()
{
    RecallEffect.mStartParticles = RecallEffect.ClampToMaxParticles(100);
    ClientPlayForceFeedback( RecallFireForce );  // jdf
}

simulated function Timer()
{
    if (DummyBeacon != None)
    {
        if (UT2003TransLauncher(Weapon).UT2003TransBeacon != None && !bBeaconDeployed)
        {
            bBeaconDeployed = true;
            DummyBeacon.bHidden = true;
        }
        else if (UT2003TransLauncher(Weapon).UT2003TransBeacon == None && bBeaconDeployed)
        {
            bBeaconDeployed = false;
            DummyBeacon.bHidden = false;
            DoRecallEffect();
        }
    }
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local UT2003TransBeacon UT2003TransBeacon;

    if (UT2003TransLauncher(Weapon).UT2003TransBeacon == None)
    {
		if ( (Instigator == None) || (Instigator.PlayerReplicationInfo == None) || (Instigator.PlayerReplicationInfo.Team == None) )
			UT2003TransBeacon = Spawn(class'UT2003TransLauncher.UT2003TransBeacon',,, Start, Dir);
		else if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 0 )
			UT2003TransBeacon = Spawn(class'UT2003TransLauncher.UT2003RedBeacon',,, Start, Dir);
		else
			UT2003TransBeacon = Spawn(class'UT2003TransLauncher.UT2003BlueBeacon',,, Start, Dir);
        UT2003TransLauncher(Weapon).UT2003TransBeacon = UT2003TransBeacon;
        Weapon.PlaySound(TransFireSound,SLOT_Interact,,,,,false);
    }
    else
    {
        UT2003TransLauncher(Weapon).ViewPlayer();
        UT2003TransLauncher(Weapon).UT2003TransBeacon.Destroy();
        UT2003TransLauncher(Weapon).UT2003TransBeacon = None;
        Weapon.PlaySound(RecallFireSound,SLOT_Interact,,,,,false);
    }
    return UT2003TransBeacon;
}

defaultproperties
{
     TransFireSound=SoundGroup'WeaponSounds.Translocator.TranslocatorFire'
     RecallFireSound=SoundGroup'WeaponSounds.Translocator.TranslocatorModuleRegeneration'
     TransFireForce="TranslocatorFire"
     RecallFireForce="TranslocatorModuleRegeneration"
     ProjSpawnOffset=(X=25.000000,Y=8.000000)
     bLeadTarget=False
     bWaitForRelease=True
     bModeExclusive=False
     FireAnimRate=1.500000
     FireRate=0.250000
     AmmoPerFire=1
     ProjectileClass=Class'UT2003TransLauncher.UT2003TransBeacon'
     BotRefireRate=0.300000
}
