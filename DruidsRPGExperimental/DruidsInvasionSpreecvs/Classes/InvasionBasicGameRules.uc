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

class InvasionBasicGameRules extends InvasionSpreeGameRules
	config(InvasionSpree);

struct Announce
{
	var EBonusType Type;
	var bool AnnounceSelf;
	var bool AnnounceOthers;
	var int AnnounceOthersMinLevel;
};

var config Array<Announce> AnnouncementRules;

function notify(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type)
{
	local Announce announcementInfo;
	local int i;

	for(i = 0; i < announcementRules.length; i++)
	{
		if(AnnouncementRules[i].Type == EBonusType)
		{
			announcementInfo = AnnouncementRules[i];
			break;
		}
	}
	if(i == announcementRules.length)
		return;

	switch(EBonusType)
	{
		case BONUS_FirstBlood:
			if(announcementInfo.AnnounceSelf)
				Killer.ReceiveLocalizedMessage(class'FirstBloodMessage', level-1, Killer.PlayerReplicationInfo);
			break;

		case BONUS_Spree:
			if(announcementInfo.AnnounceSelf)
				Killer.ReceiveLocalizedMessage(class'KillingSpreeMessage', level-1, Killer.PlayerReplicationInfo);
			break;

		case BONUS_Multikill:
			if(announcementInfo.AnnounceSelf)
				Killer.ReceiveLocalizedMessage(class'InvasionMultikillMessage', min(level - 1, 6));
			break;

		case BONUS_MultikillFinal:
			if(announcementInfo.AnnounceSelf)
				Killer.ReceiveLocalizedMessage(class'InvasionMultikillMessage', Min(level - 1, 6));
			break;

		case BONUS_FlakMonkey:
			if(announcementInfo.AnnounceSelf && UnrealPlayer(Killer) != None)
				UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('FlackMonkey',15);
			break;

		case BONUS_ShockCombo:
			if(announcementInfo.AnnounceSelf && UnrealPlayer(Killer) != None)
				Killer.receiveLocalizedMessage(Class'ComboMasterMessage', 0);
			break;

		case BONUS_HeadHunter:
			if(announcementInfo.AnnounceSelf && UnrealPlayer(Killer) != None)
				UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('HeadHunter',15);
			break;

		case BONUS_HeadShot:
			if(announcementInfo.AnnounceSelf && UnrealPlayer(Killer) != None)
				Killer.ReceiveLocalizedMessage(Class'XGame.SpecialKillMessage', 0, Killer.PlayerReplicationInfo, None, None );
			break;

		case BONUS_RoadKill:
			if(announcementInfo.AnnounceSelf)
			{
				if(Type == 'Pancake')
					Killer.receiveLocalizedMessage(Class'Onslaught.ONSVehicleKillMessage', Rand(class'DamTypePancake'.default.NumMessages) + class'DamTypePancake'.default.MessageSwitchBase);
				else
					Killer.receiveLocalizedMessage(Class'Onslaught.ONSVehicleKillMessage', Rand(class'DamTypeRoadkill'.default.NumMessages) + class'DamTypeRoadkill'.default.MessageSwitchBase);
			}
			break;

		case BONUS_RoadRampage:
			if(announcementInfo.AnnounceSelf && UnrealPlayer(Killer) != None)
				UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('RoadRampage', 15);
			break;

		case BONUS_EagleEye:
			if(announcementInfo.AnnounceSelf)
				Killer.ReceiveLocalizedMessage(class'ONSVehicleKillMessage', 5);
			break;

		case BONUS_TopGun:
			if(announcementInfo.AnnounceSelf)
				Killer.ReceiveLocalizedMessage(class'ONSVehicleKillMessage', 6);
			
			break;
	}
}

function notifyOthers(PlayerController Killer, EBonusType EBonusType, int level, name type)
{
	Local int i;
	Local Controller C;

	for(i = 0; i < announcementRules.length; i++)
		if(AnnouncementRules[i].Type == EBonusType)
			break;

	if(i == announcementRules.length)
		return;

	if(!AnnouncementRules[i].AnnounceOthers || AnnouncementRules[i].AnnounceOthersMinLevel > level)
		return;

	switch(EBonusType)
	{
		case BONUS_FirstBlood:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'FirstBloodMessage', level-1, Killer.PlayerReplicationInfo);
			break;

		case BONUS_Spree:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'KillingSpreeMessage', level-1, Killer.PlayerReplicationInfo);
			break;

		case BONUS_Multikill:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', min(level-1, 6), Killer.PlayerReplicationInfo);
			break;

		case BONUS_MultikillFinal:
			//this one is only called on the destruction of the 
			//short lifespan counter, not for every instance.
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', min(level-1, 6), Killer.PlayerReplicationInfo);
			break;

		case BONUS_FlakMonkey:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 7, Killer.PlayerReplicationInfo);
			break;

		case BONUS_ShockCombo:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 8, Killer.PlayerReplicationInfo);
			break;

		case BONUS_HeadHunter:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 10, Killer.PlayerReplicationInfo);
			break;

		case BONUS_HeadShot:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 11, Killer.PlayerReplicationInfo);
			break;

		case BONUS_RoadKill:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 12, Killer.PlayerReplicationInfo);
			break;

		case BONUS_RoadRampage:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 13, Killer.PlayerReplicationInfo);
			break;

		case BONUS_EagleEye:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 14, Killer.PlayerReplicationInfo);
			break;

		case BONUS_TopGun:
			for (C=Killer.Level.ControllerList; C!=None; C=C.NextController)
				if (PlayerController(C) != None && C != Killer)
					PlayerController(C).ReceiveLocalizedMessage(class'SpreeMessage', 15, Killer.PlayerReplicationInfo);
			break;
	}
}

function giveAward(PlayerController Killer, Pawn KillerPawn, EBonusType EBonusType, int level, name type)
{
	local xPlayerReplicationInfo xPRI;
	local TeamPlayerReplicationInfo TPRI;

	switch(EBonusType)
	{
		case BONUS_FirstBlood:
			if (TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo) != None)
				TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo).bFirstBlood = true;
			dm.SpecialEvent(Killer.PlayerReplicationInfo,"first_blood");
			
			break;
		case BONUS_Spree:
			if (UnrealPawn(Killer.Pawn) != None)
				UnrealPawn(Killer.Pawn).spree = Level * 5;

			dm.SpecialEvent(Killer.PlayerReplicationInfo,"spree_"$(level - 1));

			if (TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo) != None)
			{
				TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo).Spree[level-1] += 1;
				//this removed the previous award since they've now received a higher award for this life.
				if ( level - 1 > 0 )
					TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo).Spree[level - 2] -= 1;
			}		
		break;
		case BONUS_Multikill:
		        dm.SpecialEvent(Killer.PlayerReplicationInfo, "multikill_"$min(level - 1, 6));
			
			break;
		case BONUS_MultikillFinal:
        		if (TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo) != None)
					TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo).MultiKills[min(level-1, 6)] += 1;			
			break;
		case BONUS_FlakMonkey:		
			xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			if (xPRI != None && xPRI.flakcount < 15)
				xPRI.flakcount = 15;
			break;
		case BONUS_ShockCombo:
			xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			if (xPRI != None && xPRI.combocount < 15)
				xPRI.combocount = 15;
			break;
		case BONUS_HeadHunter:
			xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			if ( xPRI != None && xPRI.headcount < 15)
				xPRI.headcount = 15;
			break;
		case BONUS_HeadShot:
			xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			if (xPRI != None)
				if(xPRI.headcount != 14) //trap this in case the score doesn't match the head count.
					xPRI.headcount++;
			break;
		case BONUS_RoadKill:
			TPRI = TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			if (TPRI != None)
				if(TPRI.ranovercount != 9) //trap this in case the score doesn't match the smash count
					TPRI.ranovercount++;
			break;
		case BONUS_RoadRampage:
			TPRI = TeamPlayerReplicationInfo(Killer.PlayerReplicationInfo);
			if (TPRI != None)
				if(TPRI.ranovercount < 10)
					TPRI.ranovercount = 10;
			break;
		case BONUS_EagleEye:
				//do nothing
			break;
		case BONUS_TopGun:
				//do nothing
			break;
	}
}

defaultproperties
{
     AnnouncementRules(0)=(AnnounceSelf=True,AnnounceOthers=True)
     AnnouncementRules(1)=(Type=BONUS_Spree,AnnounceSelf=True,AnnounceOthers=True)
     AnnouncementRules(2)=(Type=BONUS_Multikill,AnnounceSelf=True)
     AnnouncementRules(3)=(Type=BONUS_MultikillFinal,AnnounceOthers=True,AnnounceOthersMinLevel=4)
     AnnouncementRules(4)=(Type=BONUS_FlakMonkey,AnnounceSelf=True,AnnounceOthers=True)
     AnnouncementRules(5)=(Type=BONUS_ShockCombo,AnnounceSelf=True,AnnounceOthers=True)
     AnnouncementRules(6)=(Type=BONUS_HeadHunter,AnnounceSelf=True,AnnounceOthers=True)
     AnnouncementRules(7)=(Type=BONUS_HeadShot,AnnounceSelf=True)
     AnnouncementRules(8)=(Type=BONUS_RoadKill,AnnounceSelf=True)
     AnnouncementRules(9)=(Type=BONUS_RoadRampage,AnnounceSelf=True,AnnounceOthers=True)
     AnnouncementRules(10)=(Type=BONUS_EagleEye,AnnounceSelf=True)
     AnnouncementRules(11)=(Type=BONUS_TopGun,AnnounceSelf=True)
}
