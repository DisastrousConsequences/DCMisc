class LimitBreakMessage extends LocalMessage;

var localized string LimitBreakMsg;
var(Message) color PendingColor;
var(Message) color Stage1Color;
var(Message) color Stage2Color;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return "Limit Break...";
	}
	else
	{
		return "Limit Break!";
	}
}

//I can't get this to work. I want green when pending, white stage 1, and gold stage 2... -Moof
/*static function color GetColor(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 0)
	{
		return Default.PendingColor;
	}
	else if (Switch == 1)
	{
		return Default.Stage1Color;
	}
	else if (Switch == 2)
	{
		return Default.Stage2Color;
	}
	else
	{
		return Default.DrawColor;
	}
}*/

static function float GetLifetime(int Switch)
{
	if (Switch == 1)
	{
		return 5;
	}
	else if (Switch == 2)
	{
		return 15;
	}
	else
	{
		return 1;
	}
}

defaultproperties
{
    LimitBreakMsg="Limit Break!"
    bIsUnique=True
    bIsConsoleMessage=False
    bFadeMessage=False
    Lifetime=1
	PendingColor=(R=0,G=102,B=0)
    Stage1Color=(R=255,G=255,B=255)
    Stage2Color=(R=255,G=255,B=0)
    DrawColor=(R=255,G=255,B=255)
    PosY=0.2
}