class MutatorConfig extends Object
	config(MutatorConfigs)
	PerObjectConfig;

var config Array< class<Mutator> > Mutator;
var config Array<string> DownloadPackage;

function fire(Mutator parent)
{
	Local Mutator m;
	local int x;

	for(x = 0; x < Mutator.length; x++)
	{
		Log("Loading Mutator:" @ Mutator[x]);
		m = parent.spawn(Mutator[x]);
		parent.Level.Game.BaseMutator.AddMutator(m);
	}

	for(x = 0; x < DownloadPackage.length; x++)
	{
		Log("Adding package:" @ DownloadPackage[x] @ " to download list");
		parent.AddToPackageMap(DownloadPackage[x]);
	}
}

defaultproperties
{
}
