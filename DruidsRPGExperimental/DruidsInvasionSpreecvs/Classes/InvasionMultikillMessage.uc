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

class InvasionMultikillMessage extends LocalMessage;

var localized string HCKill;

static function string GetString
(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
)
{
	if ( class'PlayerController'.default.bNoMatureLanguage && Switch >= 6)
		return Default.HCKill;

	else
		return class'MultiKillMessage'.Default.KillString[Min(Switch,6)]; 
}

static function int GetFontSize( int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer )
{
	return class'MultiKillMessage'.static.GetFontSize(Switch, RelatedPRI1, RelatedPRI2, LocalPlayer);
}

static simulated function ClientReceive
( 
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	if ( class'PlayerController'.default.bNoMatureLanguage && Switch >= 6)
		return;

	P.PlayRewardAnnouncement(class'MultiKillMessage'.Default.KillSoundName[Min(Switch,6)],1,true);
}

defaultproperties
{
     HCKill="H O L Y  C R A P !"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(B=0,G=0)
     StackMode=SM_Down
     PosY=0.242000
     FontSize=1
}
