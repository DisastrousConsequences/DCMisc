class MonsterAbility extends RPGAbility
	abstract;

//called by MonsterPointsInv when the monster is created _instead_ of ModifyPawn
static simulated function ModifyMonster(Monster Other, int AbilityLevel);