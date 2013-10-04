//=============================================================================
// Translocator Launcher
//=============================================================================
class UT2003TransLauncher extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

var UT2003TransBeacon UT2003TransBeacon;
var() float     MaxCamDist;
var() float AmmoChargeF;
var int RepAmmo;
var() float AmmoChargeFMax;
var() float AmmoChargeFRate;
var globalconfig bool bPrevWeaponSwitch;

replication
{
    reliable if ( bNetOwner && (ROLE==ROLE_Authority) )
        UT2003TransBeacon,RepAmmo;
}

simulated function bool HasAmmo()
{
    return true;
}

// AI Interface...
function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other, Pickup);

	if ( Bot(Other.Controller) != None )
		Bot(Other.Controller).bHasTranslocator = true;
}

function bool ShouldTranslocatorHop(Bot B)
{
	local float dist;
	local Actor N;
	local bool bHop;

	bHop = B.bTranslocatorHop;
	B.bTranslocatorHop = false;

	if ( bHop && (B.Focus == B.TranslocationTarget) && (B.NextTranslocTime < Level.TimeSeconds) && B.InLatentExecution(B.LATENT_MOVETOWARD) && B.Squad.AllowTranslocationBy(B) )
	{
		if ( (UT2003TransBeacon != None) && UT2003TransBeacon.IsMonitoring(B.Focus) )
			return false;
		dist = VSize(B.TranslocationTarget.Location - B.Pawn.Location);
		if ( dist < 300 )
		{
			// see if next path is possible
			N = B.AlternateTranslocDest();
			if ( (N == None) || ((vector(B.Rotation) Dot Normal(N.Location - B.Pawn.Location)) < 0.5)  )
			{
				if ( dist < 200 )
				{
					B.TranslocationTarget = None;
					B.RealTranslocationTarget = None;
					return false;
				}
			}
			else
			{
				B.TranslocationTarget = N;
				B.RealTranslocationTarget = B.TranslocationTarget;
				B.Focus = N;
				return true;
			}
		}
		if ( (vector(B.Rotation) Dot Normal(B.TranslocationTarget.Location - B.Pawn.Location)) < 0.5 )
		{
			SetTimer(0.1,false);
			return false;
		}
		return true;
	}
	return false;
}

simulated function Timer()
{
	local Bot B;

	if ( Instigator != None )
	{
		B = Bot(Instigator.Controller);
		if ( (B != None) && (B.TranslocationTarget != None) && (B.bPreparingMove || ShouldTranslocatorHop(B)) )
			FireHack(0);
	}
	Super.Timer();
}

function FireHack(byte Mode)
{
	local Actor TTarget;
	local vector TTargetLoc;

	if ( Mode == 0 )
	{
		if ( UT2003TransBeacon != None )
		{
			// this shouldn't happen
			UT2003TransBeacon.bNoAI = true;
			UT2003TransBeacon.Destroy();
			UT2003TransBeacon = None;
		}
		TTarget = Bot(Instigator.Controller).TranslocationTarget;
		if ( TTarget == None )
			return;
		// hack in translocator firing here
        FireMode[0].PlayFiring();
        FireMode[0].FlashMuzzleFlash();
        FireMode[0].StartMuzzleSmoke();
        IncrementFlashCount(0);
		ProjectileFire(FireMode[0]).SpawnProjectile(Instigator.Location,Rot(0,0,0));
		// find correct initial velocity
		TTargetLoc = TTarget.Location;
		if ( JumpSpot(TTarget) != None )
		{
			TTargetLoc.Z += JumpSpot(TTarget).TranslocZOffset;
			if ( (Instigator.Anchor != None) && Instigator.ReachedDestination(Instigator.Anchor) )
			{
				// start from same point as in test
				UT2003TransBeacon.SetLocation(UT2003TransBeacon.Location + Instigator.Anchor.Location + (Instigator.CollisionHeight - Instigator.Anchor.CollisionHeight) * vect(0,0,1)- Instigator.Location);
			}
		}
		else if ( TTarget.Velocity != vect(0,0,0) )
		{
			TTargetLoc += 0.3 * TTarget.Velocity;
			TTargetLoc.Z = 0.5 * (TTargetLoc.Z + TTarget.Location.Z);
		}
		else if ( (Instigator.Physics == PHYS_Falling)
					&& (Instigator.Location.Z < TTarget.Location.Z)
					&& (Instigator.PhysicsVolume.Gravity.Z > -800) )
			TTargetLoc.Z += 128;

		UT2003TransBeacon.Velocity = Bot(Instigator.Controller).AdjustToss(UT2003TransBeacon.Speed, UT2003TransBeacon.Location, TTargetLoc,false);
		UT2003TransBeacon.SetTranslocationTarget(Bot(Instigator.Controller).RealTranslocationTarget);
	}
}

// super desireable for bot waiting to translocate
function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;
	if ( B.bPreparingMove && (B.TranslocationTarget != None) )
		return 10;
	if ( B.bTranslocatorHop && ((B.Focus == B.MoveTarget) || ((B.TranslocationTarget != None) && (B.Focus == B.TranslocationTarget))) && B.Squad.AllowTranslocationBy(B) )
	{
		if ( Instigator.Weapon == self )
			SetTimer(0.2,false);
		return 4;
	}
	if ( Instigator.Weapon == self )
	return AIRating;
}

function bool BotFire(bool bFinished, optional name FiringMode)
{
	return false;
}

// End AI interface

function bool ConsumeAmmo(int mode, float load, optional bool bAmountNeededIsMax)
{
	return true;
}

function ReduceAmmo()
{
	enable('Tick');
    AmmoChargeF -= 1;
    RepAmmo -= 1;
    if ( Bot(Instigator.Controller) != None )
    	Bot(Instigator.Controller).TranslocFreq = 3 + FMax(Bot(Instigator.Controller).TranslocFreq,Level.TimeSeconds);
}

simulated function GetAmmoCount(out float MaxAmmoPrimary, out float CurAmmoPrimary)
{
	MaxAmmoPrimary = AmmoChargeFMax;
	CurAmmoPrimary = AmmoChargeF;
}

function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
    Super.GiveAmmo(m, WP,bJustSpawned);
    AmmoChargeF = Default.AmmoChargeF;
    RepAmmo = int(AmmoChargeF);
}

simulated function bool StartFire(int Mode)
{
	if ( !bPrevWeaponSwitch || (Mode == 1) || (Instigator.Controller.bAltFire == 0) || (PlayerController(Instigator.Controller) == None) )
		return Super.StartFire(Mode);
	if ( (OldWeapon != None) && OldWeapon.HasAmmo() )
	    Instigator.PendingWeapon = OldWeapon;
	ClientStopFire(0);
	Instigator.Controller.StopFiring();
	PutDown();
    return false;
}

simulated function Tick(float dt)
{
    if (Role == ROLE_Authority)
    {
		if ( AmmoChargeF >= AmmoChargeFMax )
		{
			if ( RepAmmo != int(AmmoChargeF) ) // condition to avoid unnecessary bNetDirty of ammo
				RepAmmo = int(AmmoChargeF);
			disable('Tick');
			return;
		}
		AmmoChargeF += dt*AmmoChargeFRate;
		AmmoChargeF = FMin(AmmoChargeF, AmmoChargeFMax);
        if ( RepAmmo != int(AmmoChargeF) ) // condition to avoid unnecessary bNetDirty of ammo
			RepAmmo = int(AmmoChargeF);
    }
    else
    {
        // client simulation of the charge bar
        AmmoChargeF = FMin(RepAmmo + AmmoChargeF - int(AmmoChargeF)+dt*AmmoChargeFRate, AmmoChargeFMax);
    }
}

simulated function DoAutoSwitch()
{
}

simulated function ViewPlayer()
{
    if ( (PlayerController(Instigator.Controller) != None) && PlayerController(Instigator.Controller).ViewTarget == UT2003TransBeacon )
    {
        PlayerController(Instigator.Controller).ClientSetViewTarget( Instigator );
        PlayerController(Instigator.Controller).SetViewTarget( Instigator );
        UT2003TransBeacon.SetRotation(PlayerController(Instigator.Controller).Rotation);
    }
}

simulated function ViewCamera()
{
    if ( UT2003TransBeacon!=None )
    {
        if ( Instigator.Controller.IsA('PlayerController') )
        {
            PlayerController(Instigator.Controller).SetViewTarget(UT2003TransBeacon);
            PlayerController(Instigator.Controller).ClientSetViewTarget(UT2003TransBeacon);
            PlayerController(Instigator.Controller).SetRotation( UT2003TransBeacon.Rotation );
        }
    }
}


simulated function Reselect()
{
	if ( (UT2003TransBeacon == None) || (Instigator.Controller.IsA('PlayerController') && (PlayerController(Instigator.Controller).ViewTarget == UT2003TransBeacon)) )
        ViewPlayer();
    else
        ViewCamera();
}

simulated event RenderOverlays( Canvas Canvas )
{
	local float tileScaleX, tileScaleY, dist, clr;

	if ( PlayerController(Instigator.Controller).ViewTarget == UT2003TransBeacon )
    {
		tileScaleX = Canvas.SizeX / 640.0f;
		tileScaleY = Canvas.SizeY / 480.0f;

        Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		Canvas.DrawColor.A = 255;

        Canvas.Style = 255;
		Canvas.SetPos(0,0);
        Canvas.DrawTile( Material'TransCamFB', Canvas.SizeX, Canvas.SizeY, 0.0, 0.0, 512, 512 ); // !! hardcoded size
        Canvas.SetPos(0,0);

        dist = VSize(UT2003TransBeacon.Location - Instigator.Location);
        if ( dist > MaxCamDist )
        {
            clr = 255.0;
        }
        else
        {
            clr = (dist / MaxCamDist);
            clr *= 255.0;
        }
        clr = Clamp( clr, 20.0, 255.0 );
        Canvas.DrawColor.R = clr;
		Canvas.DrawColor.G = clr;
		Canvas.DrawColor.B = clr;
        Canvas.DrawColor.A = 255;
        Canvas.DrawTile( Material'ScreenNoiseFB', Canvas.SizeX, Canvas.SizeY, 0.0, 0.0, 512, 512 ); // !! hardcoded size
	}
    else
    {
        Super.RenderOverlays(Canvas);
    }
}

simulated function bool PutDown()
{
    ViewPlayer();
    return Super.PutDown();
}

simulated function Destroyed()
{
    if (UT2003TransBeacon != None)
        UT2003TransBeacon.Destroy();
    Super.Destroyed();
}

simulated function float ChargeBar()
{
	return AmmoChargeF - int(AmmoChargeF);
}

function class<DamageType> GetDamageType()
{
	return class'XWeapons.DamTypeTeleFrag';
}

defaultproperties
{
     MaxCamDist=4000.000000
     AmmoChargeF=5.000000
     RepAmmo=5
     AmmoChargeFMax=5.000000
     AmmoChargeFRate=0.300000
     FireModeClass(0)=Class'UT2003TransLauncher.UT2003TransFire'
     FireModeClass(1)=Class'UT2003TransLauncher.UT2003TransRecall'
     SelectAnim="Pickup"
     PutDownAnim="PutDown"
     IdleAnimRate=0.250000
     SelectSound=Sound'WeaponSounds.Misc.translocator_change'
     SelectForce="Translocator_change"
     AIRating=-1.000000
     CurrentRating=-1.000000
     bShowChargingBar=True
     bCanThrow=False
     EffectOffset=(X=100.000000,Y=30.000000,Z=-19.000000)
     DisplayFOV=60.000000
     Priority=12
     DefaultPriority=1
     HudColor=(B=255,G=0,R=0)
     SmallViewOffset=(X=19.000000,Y=13.000000,Z=-10.500000)
     CenteredRoll=0
     InventoryGroup=10
     PlayerViewOffset=(X=7.000000,Y=7.000000,Z=-4.500000)
     PlayerViewPivot=(Pitch=1000,Yaw=400)
     BobDamping=1.800000
     AttachmentClass=Class'UT2003TransLauncher.UT2003TransAttachment'
     IconMaterial=Texture'InterfaceContent.HUD.SkinA'
     IconCoords=(X1=322,Y1=7,X2=444,Y2=98)
     ItemName="Translocator"
     Mesh=SkeletalMesh'Weapons.TransLauncher_1st'
     UV2Texture=Shader'XGameShaders.WeaponShaders.WeaponEnvShader'
}