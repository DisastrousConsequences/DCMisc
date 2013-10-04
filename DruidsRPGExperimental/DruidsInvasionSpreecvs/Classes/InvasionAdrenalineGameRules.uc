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

class InvasionAdrenalineGameRules extends InvasionBasicGameRules
	config(InvasionSpree);

struct SAdrenalineBonus
{
	var EBonusType Type;
	var float Amount;
};

var config Array<SAdrenalineBonus> AdrenalineBonus;

function giveAward(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type)
{
	Local int i;

	super.giveAward(Killer, KillerPawn, EBonusType, level, type);

	for(i = 0; i < AdrenalineBonus.length; i++)
		if(AdrenalineBonus[i].Type == EBonusType)
			break;

	if(i == AdrenalineBonus.length)
		return;
	if(AdrenalineBonus[i].Amount > 0.000000)
	{
		killer.AwardAdrenaline(AdrenalineBonus[i].Amount);
	}
}

defaultproperties
{
     AdrenalineBonus(0)=(Amount=25.000000)
     AdrenalineBonus(1)=(Type=BONUS_Spree,Amount=20.000000)
     AdrenalineBonus(2)=(Type=BONUS_Multikill,Amount=10.000000)
     AdrenalineBonus(3)=(Type=BONUS_MultikillFinal)
     AdrenalineBonus(4)=(Type=BONUS_FlakMonkey,Amount=25.000000)
     AdrenalineBonus(5)=(Type=BONUS_ShockCombo,Amount=40.000000)
     AdrenalineBonus(6)=(Type=BONUS_HeadHunter,Amount=100.000000)
     AdrenalineBonus(7)=(Type=BONUS_HeadShot,Amount=10.000000)
     AdrenalineBonus(8)=(Type=BONUS_RoadKill)
     AdrenalineBonus(9)=(Type=BONUS_RoadRampage,Amount=15.000000)
     AdrenalineBonus(10)=(Type=BONUS_EagleEye,Amount=5.000000)
     AdrenalineBonus(11)=(Type=BONUS_TopGun,Amount=5.000000)
}
