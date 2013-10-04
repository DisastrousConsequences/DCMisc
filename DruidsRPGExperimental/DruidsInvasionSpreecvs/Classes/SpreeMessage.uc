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

class SpreeMessage extends LocalMessage;

var(Message) localized string Message[17];
var(Message) color YellowColor;

static function color GetColor
(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2
)
{
	return Default.YellowColor;
}

static function string GetString
(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
)
{
	Local int realSwitch;
	if ( class'PlayerController'.default.bNoMatureLanguage )
	{
		if(Switch == 6)
			realSwitch = 16;
		else if(Switch == 8)
			realSwitch = 9;
		else
			realSwitch = Switch;
	}
	else
		realSwitch = Switch;


	return (RelatedPRI_1.PlayerName@Default.Message[realSwitch]);
}

defaultproperties
{
     Message(0)="was awarded Double Kill"
     Message(1)="was awarded Multi Kill!"
     Message(2)="was awarded Mega Kill!"
     Message(3)="was awarded Ultra Kill!"
     Message(4)="was awarded Monster Kill!"
     Message(5)="was awarded Ludicrous Kill!"
     Message(6)="was awarded Holy Shit Kill!"
     Message(7)="is a Flak Monkey!"
     Message(8)="is a Combo Whore!"
     Message(9)="is a Combo Master!"
     Message(10)="is a Head Hunter!"
     Message(11)="got a Headshot!"
     Message(12)="got a Road Kill!"
     Message(13)="is on a Road Rampage!"
     Message(14)="got an Eagle Eye!"
     Message(15)="is a Top Gun!"
     Message(16)="was awarded Holy Crap Kill!"
     YellowColor=(G=255,R=255,A=255)
     bIsSpecial=False
}
