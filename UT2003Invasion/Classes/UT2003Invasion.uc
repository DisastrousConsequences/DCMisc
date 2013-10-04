class UT2003Invasion extends Invasion;

event PlayerController Login
(
    string Portal,
    string Options,
    out string Error
)
{
	bMustJoinBeforeStart = false;
	return Super.Login(Portal,Options,Error);
}

function ReplenishWeapons(Pawn P)
{
	local Inventory Inv;

	for (Inv = P.Inventory; Inv != None; Inv = Inv.Inventory)
		if (Weapon(Inv) != None)
		{
			Weapon(Inv).FillToInitialAmmo();
			Inv.NetUpdateTime = Level.TimeSeconds - 1;
		}
}

defaultproperties
{
     InitialWave=15
     FinalWave=32
     Waves(0)=(WaveMask=63104)
     bAllowNonTeamChat=True
     bAdjustSkill=True
     SpawnProtectionTime=0.000000
     DefaultMaxLives=0
     LateEntryLives=999999
     GameName="2003 Invasion"
     Acronym="2k3INV"
}
