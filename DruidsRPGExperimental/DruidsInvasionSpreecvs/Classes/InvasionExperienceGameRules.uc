/*
    Copyright (C) 2005  Clinton H Goudie-Nice aka TheDruidXpawX

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

class InvasionExperienceGameRules extends InvasionAdrenalineGameRules
	config(InvasionSpree);

struct SExperienceBonus
{
	var EBonusType Type;
	var float Amount;
	var float LevelMultiplier;
};

var config Array<SExperienceBonus> ExperienceBonus;

var MutUT2004RPG RPG;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	RPG = class'MutUT2004RPG'.static.GetRPGMutator(Level.Game);
}

function giveAward(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type)
{
	Local RPGStatsInv StatsInv;
	Local int i;

	super.giveAward(Killer, KillerPawn, EBonusType, level, type);

	for(i = 0; i < ExperienceBonus.length; i++)
		if(ExperienceBonus[i].Type == EBonusType)
			break;

	if(i == ExperienceBonus.length)
		return;

	StatsInv = RPGStatsInv(KillerPawn.FindInventoryType(class'RPGStatsInv'));
	if(StatsInv == None)
		return;

	if(ExperienceBonus[i].LevelMultiplier == 0.000000)
	{
		StatsInv.DataObject.Experience += ExperienceBonus[i].Amount;
	}
	else
	{
		StatsInv.DataObject.Experience += ExperienceBonus[i].Amount * Level * ExperienceBonus[i].LevelMultiplier;
	}

	if (RPG == None)
		RPG = class'MutUT2004RPG'.static.GetRPGMutator(Killer.Pawn.Level.Game);
	RPG.CheckLevelUp(StatsInv.DataObject, KillerPawn.PlayerReplicationInfo);
}

defaultproperties
{
     ExperienceBonus(0)=(Amount=25.000000)
     ExperienceBonus(1)=(Type=BONUS_Spree,Amount=6.000000,LevelMultiplier=1.500000)
     ExperienceBonus(2)=(Type=BONUS_Multikill,Amount=4.000000,LevelMultiplier=1.050000)
     ExperienceBonus(3)=(Type=BONUS_MultikillFinal)
     ExperienceBonus(4)=(Type=BONUS_FlakMonkey,Amount=25.000000)
     ExperienceBonus(5)=(Type=BONUS_ShockCombo,Amount=40.000000)
     ExperienceBonus(6)=(Type=BONUS_HeadHunter,Amount=100.000000)
     ExperienceBonus(7)=(Type=BONUS_HeadShot,Amount=10.000000)
     ExperienceBonus(8)=(Type=BONUS_RoadKill)
     ExperienceBonus(9)=(Type=BONUS_RoadRampage,Amount=15.000000)
     ExperienceBonus(10)=(Type=BONUS_EagleEye,Amount=5.000000)
     ExperienceBonus(11)=(Type=BONUS_TopGun,Amount=5.000000)
}
