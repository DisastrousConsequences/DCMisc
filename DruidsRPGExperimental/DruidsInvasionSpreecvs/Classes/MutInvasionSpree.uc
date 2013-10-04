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

class MutInvasionSpree extends Mutator
	config(InvasionSpree);

var config class<InvasionSpreeGameRules> rules;

var InvasionSpreeGameRules G;

function PreBeginPlay()
{

	Super.PreBeginPlay();
		
	G = spawn(rules);

	if ( Level.Game.GameRulesModifiers == None )
			Level.Game.GameRulesModifiers = G;
	else    
		Level.Game.GameRulesModifiers.AddGameRules(G);
}

function ModifyPlayer(Pawn Other)
{
	Local LifetimeScoreInv longScoreInv;
	Local ShortTermScoreInv shortScoreInv;

	super.ModifyPlayer(Other);
	//add the default items to their inventory..

	longScoreInv = LifetimeScoreInv(Other.FindInventoryType(class'LifetimeScoreInv'));
	if(longScoreInv == None)
	{
		longScoreInv = Other.Spawn(class'LifetimeScoreInv', Other);
		longScoreInv.giveTo(Other);
	}

	shortScoreInv = ShortTermScoreInv(Other.FindInventoryType(class'ShortTermScoreInv'));
	if(shortScoreInv == None)
	{
		shortScoreInv = Other.Spawn(class'ShortTermScoreInv', Other);
		shortScoreInv.rules = G;
		shortScoreInv.PC = Other.Controller;
		shortScoreInv.giveTo(Other);
	}
}

defaultproperties
{
     Rules=Class'DruidsInvasionSpreecvs.InvasionAdrenalineGameRules'
     GroupName="DruidsInvasionSpree"
     FriendlyName="Druid's Invasion Spree"
     Description="Score messages for Invasion game types."
}
