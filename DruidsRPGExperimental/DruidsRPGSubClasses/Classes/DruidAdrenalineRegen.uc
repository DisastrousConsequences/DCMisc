class DruidAdrenalineRegen extends AbilityAdrenalineRegen
	config(UT2004RPG) 
	abstract;

var config int PointsPerLevel;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (Data.AdrenalineMax < 100 + default.PointsPerLevel * (CurrentLevel + 1))
		return 0;

	return super.Cost(Data, CurrentLevel);
}

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DruidAdrenRegenInv R;
	local Inventory Inv;

	if (Other.Role != ROLE_Authority)
		return;

	//remove old one, if it exists
	//might happen if player levels up this ability while still alive
	Inv = Other.FindInventoryType(class'DruidAdrenRegenInv');
	if (Inv != None)
		Inv.Destroy();

	R = Other.spawn(class'DruidAdrenRegenInv', Other,,,rot(0,0,0));
	R.GiveTo(Other);
	if (AbilityLevel >= 3)
	{
		R.RegenAmount *= (AbilityLevel - 2);
		R.SetTimer(1, true);
	}
	else
	{
		R.SetTimer(4 - AbilityLevel, true);
	}
}

defaultproperties
{
     Description="Slowly drips adrenaline into your system.|At level 1 you get one adrenaline every 3 seconds.|At level 2 you get one adrenaline every 2 seconds.|At level 3 you get one adrenaline every second. |At level 4 you get two adrenaline per second.|You must spend 25 points in your Adrenaline Max stat for each level of this ability you want to purchase. |Cost (per level): 2,8,14..."

     StartingCost=2
     CostAddPerLevel=6

     MaxLevel=6
     PointsPerLevel=25
}
