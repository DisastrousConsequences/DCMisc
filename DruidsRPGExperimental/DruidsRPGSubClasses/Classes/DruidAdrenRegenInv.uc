class DruidAdrenRegenInv extends Inventory
	config(UT2004RPG);

var config int RegenAmount;

function bool HasActiveArtifact()
{
	return class'ActiveArtifactInv'.static.hasActiveArtifact(Instigator);
}

function Timer()
{
	local Controller C;

	if (Instigator == None || Instigator.Health <= 0)
	{
		Destroy();
		return;
	}

	C = Instigator.Controller;
	if (C == None && Instigator.DrivenVehicle != None)
		 C = Instigator.DrivenVehicle.Controller;

	if (C != None && !Instigator.InCurrentCombo() && !HasActiveArtifact())
	{
		C.AwardAdrenaline(RegenAmount);
	}
}

defaultproperties
{
	RemoteRole=ROLE_DumbProxy
	RegenAmount = 1;
}