class DM extends Mutator;

function PreBeginPlay()
{
	local MutatorConfig mc;

	Log("MutatorConfig for Game type" @ Level.Game.class @ "selected.");

	mc = new(None, string(Level.Game.class)) class'MutatorConfig';
	mc.fire(self);

	destroy();
	super.PreBeginPlay();
}

defaultproperties
{
     GroupName="MutatorConfig"
     FriendlyName="Druid's Mutator Config"
     Description="Assigns mutators for various game types."
}
