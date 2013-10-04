class DruidArtifactLoadedHybrid extends DruidArtifactLoaded
	config(UT2004RPG) 
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local LoadedInv LInv;
	
	Super.ModifyPawn(Other, AbilityLevel);

	LInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if(LInv == None)
		return;

	if(AbilityLevel >= 2)
		LInv.ProtectArtifacts = true;
	else
		LInv.ProtectArtifacts = false;
		
}

DefaultProperties
{
	AbilityName="Loaded Artifacts (Hybrid)"
	Description="When you spawn:|Level 1: You are granted the globe and triple.|Level 2: You are granted weapon artifacts and some special artifacts, and your breakable artifacts are made unbreakable.|Level 3:You get offensive artifacts.|Level 4: You get team artifacts.|Extreme level 5 reduces adrenaline used in offensive attacks, but reduces damage from weapons|Cost (per level): 2,9,16,9,15"
	
	// DruidArtifactLoaded has arrays 4,6,6,5 long, so we need to remove any ones that might carry through
	SlowArtifact[0]=class'DruidArtifactTripleDamage'
	SlowArtifact[1]=class'UT2004RPG.ArtifactInvulnerability'
	SlowArtifact[2]=None
	SlowArtifact[3]=None
	
	QuickArtifact[0]=class'DruidArtifactMakeMagicWeapon'
	QuickArtifact[1]=class'DruidDoubleModifier'
	QuickArtifact[2]=class'DruidMaxModifier'
	QuickArtifact[3]=class'DruidPlusOneModifier'
	QuickArtifact[4]=None
	QuickArtifact[5]=None

	ExtraArtifact[0]=Class'ArtifactLightningBolt'
	ExtraArtifact[1]=Class'ArtifactLightningBeam'
	ExtraArtifact[2]=Class'ArtifactMegaBlast'
	ExtraArtifact[3]=Class'ArtifactFreezeBomb'
	ExtraArtifact[4]=Class'ArtifactPoisonBlast'
	ExtraArtifact[5]=Class'ArtifactRepulsion'
	ExtraArtifact[6]=class'DruidArtifactLightningRod'

	TeamArtifact[0]=Class'ArtifactSphereInvulnerability'
	TeamArtifact[1]=Class'ArtifactSphereDamage'
	TeamArtifact[2]=Class'ArtifactRemoteDamage'
	TeamArtifact[3]=Class'ArtifactRemoteInvulnerability'
	TeamArtifact[4]=Class'ArtifactRemoteMax'
}
