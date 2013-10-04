class UT2003TransFire extends TransFire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local TransBeacon TransBeacon;

    if (TransLauncher(Weapon).TransBeacon == None)
    {
		if ( (Instigator == None) || (Instigator.PlayerReplicationInfo == None) || (Instigator.PlayerReplicationInfo.Team == None) )
			TransBeacon = Weapon.Spawn(class'UT2003TransLauncher.UT2003TransBeacon',,, Start, Dir);
		else if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 0 )
			TransBeacon = Weapon.Spawn(class'UT2003TransLauncher.UT2003RedBeacon',,, Start, Dir);
		else
			TransBeacon = Weapon.Spawn(class'UT2003TransLauncher.UT2003BlueBeacon',,, Start, Dir);
        TransLauncher(Weapon).TransBeacon = TransBeacon;
        Weapon.PlaySound(TransFireSound,SLOT_Interact,,,,,false);
    }
    else
    {
        return super.SpawnProjectile(Start, Dir);
    }
    return TransBeacon;
}

defaultproperties
{
     ProjectileClass=Class'UT2003TransLauncher.UT2003TransBeacon'
}