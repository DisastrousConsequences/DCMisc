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

class MonsterEndSpreeMessage extends LocalMessage;

var(Message) localized string MessageMonster;

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
	return class'KillingSpreeMessage'.static.getFontSize(Switch, RelatedPRI1, RelatedPRI1, LocalPlayer);
}

static function string GetString
(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
)
{
	if(RelatedPRI_1 == None)
		return "";

	return (RelatedPRI_1.PlayerName$class'KillingSpreeMessage'.Default.EndSpreeNote$" a "$Default.MessageMonster);
}

defaultproperties
{
     MessageMonster="Monster"
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(G=160,R=0)
     StackMode=SM_Down
     FontSize=1
}
