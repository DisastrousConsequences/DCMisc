class DruidAwareness extends AbilityAwareness;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local PlayerController PC;
	local int x;
	local DruidAwarenessInteraction Interaction;

	if (Other.Level.NetMode == NM_DedicatedServer)
		return;

	PC = PlayerController(Other.Controller);
	if (PC == None)
		return;

	for (x = 0; x < PC.Player.LocalInteractions.length; x++)
		if (DruidAwarenessInteraction(PC.Player.LocalInteractions[x]) != None)
		{
			Interaction = DruidAwarenessInteraction(PC.Player.LocalInteractions[x]);
			break;
		}
	if (Interaction == None)
		AddInteraction(PC,AbilityLevel);
	else
		if(Interaction.AbilityLevel != AbilityLevel)
		{
			Interaction.NotifyLevelChange();
			AddInteraction(PC,AbilityLevel);
		}
}

static simulated function AddInteraction(PlayerController PC,int AbilityLevel) //modified from MonsterPointsInv.uc
{
	local Player Player;
	local DruidAwarenessInteraction Interaction;

	Interaction = new class'DruidAwarenessInteraction';

	Player = PC.Player;
	if (Interaction != None)
	{
		Player.LocalInteractions.Length = Player.LocalInteractions.Length + 1;
		Player.LocalInteractions[Player.LocalInteractions.Length-1] = Interaction;
		Interaction.ViewportOwner = Player;

		// Initialize the Interaction
		Interaction.Initialize();
		Interaction.Master = Player.InteractionMaster;
		Interaction.AbilityLevel = AbilityLevel;
	}
	else
		Log("Could not create DruidAwarenessInteraction");

} // AddInteraction

defaultproperties
{
	Description="Informs you of your enemies' health with a display over their heads. At level 1 you get a small, dully-colored indicator (green, yellow, or red). At level 2 you get a larger colored health bar and a shield bar. You must have at least 5 points in every stat to purchase this ability. |Cost (per level): 20,25"
}
