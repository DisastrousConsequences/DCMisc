class DruidArtifactLightningRod extends ArtifactLightningRod
	config(UT2004RPG);

var config float CostPerHit;
var config float HealthMultiplier;
var config int MaxDamagePerHit;
var config int MinDamagePerHit;

state Activated
{
	function Timer()
	{
		local Controller C, NextC;
		local int DamageDealt;
		local xEmitter HitEmitter;
		local int lCost;

		if(Instigator == None || Instigator.Controller == None)
			return; //must have a controller when active. (Otherwise they're probably ghosting)

		//need to be moving for it to do anything... so can't just sit somewhere and camp
		if (VSize(Instigator.Velocity) ~= 0)
			return;

		C = Level.ControllerList;
		while (C != None)
		{
			// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
			NextC = C.NextController;
			
			//Is this just some sort of weird unreal script bug? Sometimes C is None
			if(C == None)
			{
				C = NextC;
				break;
			}
			
			if ( C.Pawn != None && Instigator != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller)
			     && VSize(C.Pawn.Location - Instigator.Location) < TargetRadius && FastTrace(C.Pawn.Location, Instigator.Location) )
			{
				//deviation from Mysterial's class to figure out the damage and adrenaline drain.
				DamageDealt = max(min(C.Pawn.HealthMax * HealthMultiplier, MaxDamagePerHit), MinDamagePerHit);
				
				lCost = DamageDealt * CostPerHit;
				
				if(lCost < 1)
					lCost = 1;
				
				if(lCost < Instigator.Controller.Adrenaline)
				{
					//Is this just some sort of weird unreal script bug? Sometimes C is None
					if(C == None)
					{
						C = NextC;
						break;
					}

					HitEmitter = spawn(HitEmitterClass,,, Instigator.Location, rotator(C.Pawn.Location - Instigator.Location));
					if (HitEmitter != None)
						HitEmitter.mSpawnVecA = C.Pawn.Location;

					if(C == None)
					{
						C = NextC;
						break;
					}

					if ( Instigator != None && Instigator.Controller != None)
					{
						C.Pawn.TakeDamage(DamageDealt, Instigator, C.Pawn.Location, vect(0,0,0), class'DamTypeEnhLightningRod');
						Instigator.Controller.Adrenaline -= lCost;

						//now see if we killed it
						if (C == None || C.Pawn == None || C.Pawn.Health <= 0 )
							if ( Instigator != None)
								class'ArtifactLightningBeam'.static.AddArtifactKill(Instigator, class'WeaponRod');	// assume killed

					}
				}
			}
			C = NextC;
		}
	}

	function BeginState()
	{
		SetTimer(0.5, true);
		bActive = true;
	}

	function EndState()
	{
		SetTimer(0, false);
		bActive = false;
	}
}

defaultproperties
{
     TargetRadius=2000.000000
     //The actual damage per hit is calculated off the base health of the target
     MaxDamagePerHit=100
     MinDamagePerHit=5
     HitEmitterClass=Class'XEffects.LightningBolt'
     //deviation from Mysterial's class This is the slow drain when nothing is occurring.
     CostPerSec=1
     //CostPerHit is the amount of adrenaline drained when you do a point of damage to a monster
     CostPerHit=0.150000
     //HealthMultiplier is the percentage of life that will be taken from a single hit of the LR.
     HealthMultiplier=0.100000
     PickupClass=Class'DruidArtifactLightningRodPickup'
     IconMaterial=Texture'UTRPGTextures.Icons.LightningIcon'
     ItemName="Lightning Rod"
}