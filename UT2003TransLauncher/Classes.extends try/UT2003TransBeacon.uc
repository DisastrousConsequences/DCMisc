//=============================================================================
// Translocator Beacon
//=============================================================================
class UT2003TransBeacon extends TransBeacon;

simulated function HitWall( vector HitNormal, actor Wall )
{
	super.HitWall(HitNormal, Wall); 

        if( Wall.IsA('Monster'))
        {
            Velocity = 0.3*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity + Instigator.Velocity);
	    return;
        }
}

// END AI interface

defaultproperties
{
     Mesh=SkeletalMesh'Weapons.TransBeacon'
     DrawScale=1.500000
     PrePivot=(Z=-7.000000)
}