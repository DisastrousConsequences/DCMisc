class UT2003TransRecall extends WeaponFire;

var() Sound TransFailedSound;
var bool bGibMe;
var Material TransMaterials[2];

simulated function PlayFiring()
{
    if (UT2003TransFire(Weapon.GetFireMode(0)).bBeaconDeployed)
    {
        Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
    }
}

simulated function bool AllowFire()
{
    local bool success;
    
    success = ( UT2003TransLauncher(Weapon).AmmoChargeF >= 1.0 );

    if (!success && Weapon.Role == ROLE_Authority && UT2003TransLauncher(Weapon).UT2003TransBeacon != None)
    {
        if( Instigator.Controller != None && Instigator.Controller.IsA('PlayerController'))
            PlayerController(Instigator.Controller).ClientPlaySound(TransFailedSound);
    }
    return success;
}

function bool AttemptTranslocation(vector dest, UT2003TransBeacon UT2003TransBeacon)
{
	local vector OldLocation, HitLocation, HitNormal;
	local actor HitActor;
	
	OldLocation = Instigator.Location;
	if ( !TranslocSucceeded(dest,UT2003TransBeacon) )
		return false;
		
	HitActor = Trace(HitLocation,HitNormal,Instigator.Location, dest, false);
	if ( HitActor == None )
		return true;
	Instigator.SetLocation(OldLocation);
	return false;
}

function bool TranslocSucceeded(vector dest, UT2003TransBeacon UT2003TransBeacon)
{
	local vector newdest;
	
	if ( Instigator.SetLocation(dest) || BotTranslocation() )
		return true;
	if ( UT2003TransBeacon.Physics != PHYS_None )
	{
		newdest = UT2003TransBeacon.Location - (Instigator.CollisionRadius) * Normal(UT2003TransBeacon.Velocity);
		if ( Instigator.SetLocation(newdest) )
			return true;
	}
	if ( (dest != UT2003TransBeacon.Location) && Instigator.SetLocation(UT2003TransBeacon.Location) )
		return true;
	
	newdest = dest + (Instigator.CollisionRadius) * vect(1,1,0);
	if ( Instigator.SetLocation(newdest) )
		return true;
	newdest = dest + (Instigator.CollisionRadius) * vect(1,-1,0);
	if ( Instigator.SetLocation(newdest) )
		return true;
	newdest = dest + (Instigator.CollisionRadius) * vect(-1,1,0);
	if ( Instigator.SetLocation(newdest) )
		return true;
	newdest = dest + (Instigator.CollisionRadius) * vect(-1,-1,0);
	if ( Instigator.SetLocation(newdest) )
		return true;
	
	return false;
}

function Translocate()
{
    local UT2003TransBeacon UT2003TransBeacon;
	local Actor HitActor;
	local Vector HitNormal,HitLocation,dest,Vel2D;
    local Vector PrevLocation,Diff, NewDest;
    local xPawn XP;
    local controller C;
	local bool bFailedTransloc;
	local int EffectNum;
	local float DiffZ;
	
	
	if ( (Instigator == None) || (UT2003TransLauncher(Weapon) == None) )
		return;
    UT2003TransBeacon = UT2003TransLauncher(Weapon).UT2003TransBeacon;
    
    // gib if the translocator is disrupted
    if ( UT2003TransBeacon.Disrupted() )
	{
		UnrealMPGameInfo(Level.Game).SpecialEvent(Instigator.PlayerReplicationInfo,"translocate_gib");
        bGibMe = true; // delay gib to avoid destroying player and weapons right away in the middle of all this
		return;
	}

    dest = UT2003TransBeacon.Location;
    if ( UT2003TransBeacon.Physics == PHYS_None )
        dest += vect(0,0,1) * Instigator.CollisionHeight;
    else
        dest += vect(0,0,0.5) * Instigator.CollisionHeight;
	HitActor = Weapon.Trace(HitLocation,HitNormal,dest,UT2003TransBeacon.Location,true);
	if ( HitActor != None )
		dest = UT2003TransBeacon.Location;    
   
    UT2003TransBeacon.SetCollision(false, false, false);    
    
    if (Instigator.PlayerReplicationInfo.HasFlag != None)
        Instigator.PlayerReplicationInfo.HasFlag.Drop(0.5 * Instigator.Velocity);
    
    PrevLocation = Instigator.Location;
    
	// verify won't telefrag teammate or recently spawned player
	for ( C=Level.ControllerList; C!=None; C=C.NextController )
		if ( (C.Pawn != None) && (C.Pawn != Instigator) )
		{
			Diff = Dest - C.Pawn.Location;
			DiffZ = Diff.Z;
			Diff.Z = 0;
			if ( (Abs(DiffZ) < C.Pawn.CollisionHeight * Instigator.CollisionHeight)
				&& (VSize(Diff) < C.Pawn.CollisionRadius + Instigator.CollisionRadius) )
			{
				if ( (C.SameTeamAs(Instigator.Controller) || (Level.TimeSeconds - C.Pawn.SpawnTime < DeathMatch(Level.Game).SpawnProtectionTime)) )
				{ 
					bFailedTransloc = true;
					break;
				}
				else
				{
					if ( DiffZ > 1.5 * C.Pawn.CollisionHeight )
					{
						NewDest = Dest;
						NewDest.Z += 0.7 * C.Pawn.CollisionHeight;
					}
					else
						NewDest = Dest + 0.5 * C.Pawn.CollisionRadius * Normal(Diff);
					if ( Weapon.FastTrace(NewDest ,dest) )
						Dest = NewDest;

		
					C.Pawn.Died(Instigator.Controller, UT2003TransLauncher(Weapon).GetDamageType(), C.Pawn.Location);
				}
			}
		}

    if ( !bFailedTransloc && AttemptTranslocation(dest,UT2003TransBeacon) )
    {
		UT2003TransLauncher(Weapon).ReduceAmmo();

        // spawn out
        XP = xPawn(Instigator);
        if( XP != None )
            XP.DoTranslocateOut(PrevLocation);
 
		// bound XY velocity to prevent cheats
		Vel2D = Instigator.Velocity;
		Vel2D.Z = 0;
		Vel2D = Normal(Vel2D) * FMin(Instigator.GroundSpeed,VSize(Vel2D));
		Vel2D.Z = Instigator.Velocity.Z;
		Instigator.Velocity = Vel2D;
		
        if ( Instigator.PlayerReplicationInfo.Team != None )
			EffectNum = Instigator.PlayerReplicationInfo.Team.TeamIndex;
			
        Instigator.SetOverlayMaterial( TransMaterials[EffectNum], 1.0, false );
        Instigator.PlayTeleportEffect( false, false);

		if ( !Instigator.PhysicsVolume.bWaterVolume )
		{
			if ( Bot(Instigator.Controller) != None )
			{
				Instigator.Velocity.X = 0;
				Instigator.Velocity.Y = 0;
				Instigator.Velocity.Z = -150;
				Instigator.Acceleration = vect(0,0,0);
			}
			Instigator.SetPhysics(PHYS_Falling);
		}
		if ( UnrealTeamInfo(Instigator.PlayerReplicationInfo.Team)!= None )
			UnrealTeamInfo(Instigator.PlayerReplicationInfo.Team).AI.CallForBall(Instigator);  // for bombing run
		
    }
    else if( PlayerController(Instigator.Controller) != None )
            PlayerController(Instigator.Controller).ClientPlaySound(TransFailedSound);

    UT2003TransBeacon.Destroy();
    UT2003TransLauncher(Weapon).UT2003TransBeacon = None;
    UT2003TransLauncher(Weapon).ViewPlayer();
}

function ModeDoFire()
{
    local UT2003TransBeacon UT2003TransBeacon;

    Super.ModeDoFire();

    if (Weapon.Role == ROLE_Authority && bGibMe)
    {
        UT2003TransBeacon = UT2003TransLauncher(Weapon).UT2003TransBeacon;
        UT2003TransLauncher(Weapon).UT2003TransBeacon = None;
        UT2003TransLauncher(Weapon).ViewPlayer();
        Instigator.GibbedBy(UT2003TransBeacon.Disruptor);
        UT2003TransBeacon.Destroy();
        bGibMe = false;
    }
}

function DoFireEffect()
{
    if (UT2003TransLauncher(Weapon).UT2003TransBeacon != None)
    {
        Translocate();
    }
}

// AI Interface
function bool BotTranslocation()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || !B.bPreparingMove || (B.RealTranslocationTarget == None) )
		return false;

	// if bot failed to translocate, event though beacon was in target cylinder, 
	// try at center of cylinder
	return ( Instigator.SetLocation(B.RealTranslocationTarget.Location) );
}
// END AI interface

defaultproperties
{
     TransFailedSound=Sound'WeaponSounds.BaseGunTech.BSeekLost1'
     TransMaterials(0)=Shader'XGameShaders.PlayerShaders.PlayerTransRed'
     TransMaterials(1)=Shader'XGameShaders.PlayerShaders.PlayerTrans'
     bModeExclusive=False
     FireAnim="Recall"
     FireRate=0.250000
     BotRefireRate=0.300000
}
