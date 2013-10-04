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

class InvasionSpreeGameRules extends GameRules
	config(InvasionSpree)
	abstract;

var config int SpreeMessageScore[6];
var config int MultiKillMessageScore[7];

var config float MultiKillLifeSpanForScore;

var config int FlakMonkeyScore;
var config int ShockComboScore;
var config int RoadRampageScore;

var config bool AllowVehicleHeadShot;

var config int HeadHunterKills;

var DeathMatch dm;

enum EBonusType
{
	BONUS_FirstBlood,
	BONUS_Spree,
	BONUS_Multikill,
	BONUS_MultikillFinal,
	BONUS_FlakMonkey,
	BONUS_ShockCombo,
	BONUS_HeadShot,
	BONUS_HeadHunter,
	BONUS_RoadKill,
	BONUS_RoadRampage,
	BONUS_EagleEye,
	BONUS_TopGun,
};

function PreBeginPlay()
{
	super.PreBeginPlay();
	dm = DeathMatch(Level.Game);
	if(dm == None)
	{
		log("Unable to create InvasionSpree because game is not a DeathMatch");
		Destroy();
	}
}

function ScoreKill(Controller Killer, Controller Killed)
{
	Local ShortTermScoreInv shortScoreInv;
	Local LifetimeScoreInv longScoreInv;
	Local Controller C;

	//need to check here to see if a player that's in a spree is killed my a monster
	//and announce it properly.
	if
	(
		Killer.Pawn != None && 
		Monster(Killer.Pawn) != None && 
		Killed != None && 
		Killed.PlayerReplicationInfo != None && 
		PlayerController(Killed) != None && 
		Killed.Pawn != None &&
		UnrealPawn(Killed.Pawn) != None
	)
	{
		longScoreInv = LifetimeScoreInv(Killed.Pawn.FindInventoryType(class'LifetimeScoreInv'));
		if(longScoreInv != None && longScoreInv.lastLevel > 0)
		{
			shortScoreInv = ShortTermScoreInv(Killed.Pawn.FindInventoryType(class'ShortTermScoreInv'));
			if(shortScoreInv != None)
				shortScoreInv.executeNotify();

			for ( C=Level.ControllerList; C!=None; C=C.NextController )
				if ( PlayerController(C) != None )
					PlayerController(C).ReceiveLocalizedMessage(class'MonsterEndSpreeMessage', 1, Killed.PlayerReplicationInfo);

			UnrealPawn(Killed.Pawn).spree = 0;
		}
	}
	super.ScoreKill(Killer, Killed);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{	
	Local Monster m;
	Local LifetimeScoreInv longScoreInv;
	Local ShortTermScoreInv shortScoreInv;
	Local bool rv;
	Local int fixedLevel;
	Local Pawn player;

	//check and see if their death is really prevented. (IE: RPG Ghost Ability)
	rv = super.PreventDeath(Killed, Killer, damageType, HitLocation);
	if(rv == true)
		return true;
	
	if(Killer == None)
		return false;
	if(Killed == None)
		return false;

	if
	(
		Killer.Pawn != None && 
		Monster(Killer.Pawn) != None && 
		Killed != None && 
		Killed.Controller != None &&
		PlayerController(Killed.Controller) != None && 
		UnrealPawn(Killed) != None
	)
	{
		UnrealPawn(Killed).spree = 0; //set to zero so DeathMatch doesn't trigger.
		return false;
	}
	if(PlayerController(Killer) == None)
		return false;

	if(Killer.PlayerReplicationInfo == None)
		return false;

	m = Monster(Killed);
	if(m == None)
		return false;

	Player = Killer.Pawn;
	if(Player != None && Player.isA('Vehicle'))
	{
		if ( Vehicle(Player).Driver != None)
			Player = Vehicle(Player).Driver;
	}

	if(!dm.bFirstBlood)
	{
		dm.bFirstBlood = True;
		executeNotification(PlayerController(Killer), Player, BONUS_FirstBlood, 1, 'None');
	}

	if (Player != None)
	{
		longScoreInv = LifetimeScoreInv(Player.FindInventoryType(class'LifetimeScoreInv'));
		if(longScoreInv == None)
		{
			longScoreInv = Player.Spawn(class'LifetimeScoreInv');
			longScoreInv.giveTo(Player);
		}

		longScoreInv.score += m.ScoringValue;
		
		while
		(
			longScoreInv.lastLevel < ArrayCount(SpreeMessageScore) && 
			longScoreInv.score >= SpreeMessageScore[longScoreInv.lastLevel]
		)
		{
			longScoreInv.score -= SpreeMessageScore[longScoreInv.lastLevel];
			executeNotification(PlayerController(Killer), Player, BONUS_Spree, longScoreInv.lastLevel + 1, 'None');
			longScoreInv.lastLevel ++;
		}


		shortScoreInv = ShortTermScoreInv(Player.FindInventoryType(class'ShortTermScoreInv'));
		if(shortScoreInv == None)
		{
			shortScoreInv = Player.Spawn(class'ShortTermScoreInv');
			shortScoreInv.rules = Self;
			shortScoreInv.giveTo(Player);
		}
		
		shortScoreInv.setTimer(0.0, false); //clear any existing timers.
		shortScoreInv.setTimer(MultiKillLifeSpanForScore, false);

		shortScoreInv.score += m.ScoringValue;

		//The way the game is designed, this can keep looping on the last level
		for(fixedLevel = Min(shortScoreInv.lastLevel,6); shortScoreInv.score >= MultiKillMessageScore[fixedLevel]; fixedLevel = Min(shortScoreInv.lastLevel,6))
		{
			shortScoreInv.score -= MultiKillMessageScore[fixedLevel];
			executeNotification(PlayerController(Killer), Player, BONUS_MultiKill, fixedLevel + 1, 'None');
			shortScoreInv.lastLevel ++;
		}

		if(Class<DamTypeShockCombo>(damageType) != None)
		{
			if(longScoreInv.shockComboScore > -1)
				longScoreInv.shockComboScore += m.ScoringValue;

			if(longScoreInv.shockComboScore >= ShockComboScore)
			{
				longScoreInv.shockComboScore = -1;
				executeNotification(PlayerController(Killer), Player, BONUS_ShockCombo, 1, 'None');
			}
		}
		else if(Class<DamTypeFlakChunk>(damageType) != None)
		{
			if(longScoreInv.flakScore > -1)
				longScoreInv.flakScore += m.ScoringValue;

			if(longScoreInv.flakScore >= FlakMonkeyScore)
			{
				longScoreInv.flakScore = -1;
				executeNotification(PlayerController(Killer), Player, BONUS_FlakMonkey, 1, 'None');
			}
		}
		else if
		(
			Class<DamTypeClassicHeadShot>(damageType) != None || 
			Class<DamTypeSniperHeadShot>(damageType) != None || 
			(
				Class<DamTypeHoverBikeHeadshot>(damageType) != None && 
				AllowVehicleHeadShot
			)
		)
		{
			longScoreInv.Headshots++;
			if(longScoreInv.Headshots != HeadHunterKills)
				executeNotification(PlayerController(Killer), Player, BONUS_HeadShot, fixedLevel + 1, 'None');
			else
				executeNotification(PlayerController(Killer), Player, BONUS_HeadHunter, fixedLevel + 1, 'None');
		}
		else if(Class<DamTypeTankShell>(damageType) != None)
		{
			if(m.Physics == PHYS_Flying)
				executeNotification(PlayerController(Killer), Player, BONUS_EagleEye, fixedLevel + 1, 'None');
		}
		else if(Class<DamTypeAttackCraftMissle>(damageType) != None || Class<DamTypeAttackCraftPlasma>(damageType) != None)
		{
			if(m.Physics == PHYS_Flying)
				executeNotification(PlayerController(Killer), Player, BONUS_TopGun, fixedLevel + 1, 'None');
		}
		else if(Class<DamTypeRoadKill>(damageType) != None)
		{
			if(Class<DamTypePancake>(damageType) != None)			
				executeNotification(PlayerController(Killer), Player, BONUS_RoadKill, 1, 'Pancake');
			else
				executeNotification(PlayerController(Killer), Player, BONUS_RoadKill, 1, 'None');

			if(longScoreInv.roadScore > -1)
				longScoreInv.roadScore += m.ScoringValue;

			if(longScoreInv.roadScore >= RoadRampageScore)
			{
				longScoreInv.roadScore = -1;
				executeNotification(PlayerController(Killer), Player, BONUS_RoadRampage, 1, 'None');
			}
		}
	}

	return false;
}

function executeNotification(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type)
{
	notify(Killer, KillerPawn, EBonusType, level, type);
	notifyOthers(Killer, EBonusType, level, type);
	giveAward(Killer, KillerPawn, EBonusType, level, type);
}

function notify(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type);
function notifyOthers(PlayerController Killer, EBonusType EBonusType, int level, name type);
function giveAward(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type);

defaultproperties
{
     SpreeMessageScore(0)=100
     SpreeMessageScore(1)=125
     SpreeMessageScore(2)=150
     SpreeMessageScore(3)=200
     SpreeMessageScore(4)=275
     SpreeMessageScore(5)=350
     MultiKillMessageScore(0)=32
     MultiKillMessageScore(1)=12
     MultiKillMessageScore(2)=14
     MultiKillMessageScore(3)=16
     MultiKillMessageScore(4)=20
     MultiKillMessageScore(5)=22
     MultiKillMessageScore(6)=16
     MultiKillLifeSpanForScore=6.500000
     FlakMonkeyScore=150
     ShockComboScore=100
     RoadRampageScore=200
     HeadHunterKills=8
}
