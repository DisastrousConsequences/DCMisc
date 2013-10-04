/*
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

class ShortTermScoreInv extends Inventory;

var int score;

var int lastLevel;

var InvasionSpreeGameRules rules;

var Controller PC;	// store player controller here for when killing from vehicle passenger guns

function Destroyed()
{
	executeNotify();
	super.Destroyed();
}

function Timer()
{
	super.Timer();
	executeNotify();
}

function executeNotify()
{
	if
	(
		rules != None && 
		lastLevel > 0 && 
		Instigator != None
	)
	{
		if (Instigator.Controller != None && PlayerController(Instigator.Controller) != None)
			rules.executeNotification(PlayerController(Instigator.Controller), Instigator, BONUS_MultikillFinal, lastLevel, 'None');
		else if (PC != None && PlayerController(PC) != None)
			rules.executeNotification(PlayerController(PC), Instigator, BONUS_MultikillFinal, lastLevel, 'None');
	}
	lastLevel = 0;
	score = 0;
}

defaultproperties
{
     RemoteRole=ROLE_DumbProxy
}
