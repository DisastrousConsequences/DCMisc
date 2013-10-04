//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MutInvCleanup extends Mutator;

function PostBeginPlay()
{
	local GameRules G;
	
	Super.PostBeginPlay();
	if (TeamGame(Level.Game) != None)
		G = spawn(class'InvWeaponGameRules');
	else
		G = spawn(class'InvWeaponGameRules');
	if ( Level.Game.GameRulesModifiers == None )
		Level.Game.GameRulesModifiers = G;
	else
	{
		G.AddGameRules(Level.Game.GameRulesModifiers);
		Level.Game.GameRulesModifiers = G;
	}
}

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local Teleporter TeL;
	local PhysicsVolume V;

	bSuperRelevant = 0;

	 if ( Other.IsA('GameObjective') )
	 {

	 	if (Other.IsA('ONSPowerCore'))
	 	{
				 if ( ONSPowerCoreRed(Other) != None || ONSPowerCoreBlue(Other) != None)
						 Other.SetStaticMesh(none);
	 	    // changed in version 3236 - no need to remove PowerCore Beam effect now
	 	    if (int(Level.EngineVersion) < 3236)
	 	    {
	 		     ONSPowerCore(Other).bShowNodeBeams=false;
	 		     if (ONSPowerCore(Other).NodeBeamEffect != None)
	 			      ONSPowerCore(Other).NodeBeamEffect.Destroy();
				 }
	 	} // remove DOM domination points sounds
	 	else if (Other.isa('xDomPointA'))
	 	{
	 		xDomPointA(GameObjective(Other)).ControlSound=None;
	 		GameObjective(other).SetCollision(false, false, false);
	 	}
	 	else if (Other.isa('xDomPointB'))
	 	{
	 		xDomPointB(GameObjective(Other)).ControlSound=None;
	 		GameObjective(Other).SetCollision(false, false, false);
	 	} // hides Bombing Run goals and other BR related stuff
	 	else if (Other.isa('xBombdelivery'))
	 	{
	 		if (xBombdelivery(Other).MyHole != None)
	 			xBombdelivery(Other).MyHole.bhidden = true;
				if (Mid(Caps(string(Level)), 0 , 13) != "BR-DISCLOSURE")
					 foreach RadiusActors( class'Teleporter', TeL, 300, xBombdelivery(other).location )
					        TeL.bEnabled =false;

	 		xBombdelivery(Other).SetCollision(false, false, false);
	 		xBombdelivery(Other).bhidden=true;

	 	 /* now Emitters and other stuff are hidden using the vehicleInvasion HUd class (client side) */
	 		foreach RadiusActors( class'PhysicsVolume', V, 300 ,xBombdelivery(other).location)
				{
	 				V.setcollision(false,false,false);
	 				V.DamagePerSec = 0;
	 				V.bpainCausing = false;
	 				V.Gravity.x = -425;
				}
	 	} // hides JailBreak switch base
	 	else if (Mid(string(other.name), 0, 6) == "JBGame")
	 	{
	 		other.bHidden = true;
	 		other.SetCollision( false,false,false);
	 	}
		}
	else if (other.isa('xDomLetter') || other.isa('xDomRing')  )
	{
		other.destroy();
		return false;
	}
	else if (other.isa('xDomMonitor'))
	{
	     if (other.isa('xDomMonitorA'))
			xDomMonitorA(other).bHidden = true;
		 else if (other.isa('xDomMonitorB'))
			xDomMonitorB(other).bHidden = true;
	}
	else if (other.isa('xBombdeliveryhole'))
		xBombdeliveryhole(other).SetCollision(false, false, false);
	 else if (other.isa('PlayerSpawnManager'))
		other.destroy();
	 return true;
}

DefaultProperties
{

}
