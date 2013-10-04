class SubClass extends RPGAbility
	config(UT2004RPG)
	abstract;

// this ability is just a place holder for the different subclasses on the system.
// each level represents a different subclass.

// mapping of level to subclass. level 0 is no subclass. level 1 is SubClasses(1) etc.
var config Array<string> SubClasses;

// structure containing list of subclasses available to each class, and what minimum level it can be bought at
struct SubClassAvailability
{
	var class<RPGClass> AvailableClass;
	var string AvailableSubClass;
	var int MinLevel;			// min level this class can use this subclass
};
var config Array<SubClassAvailability> SubClassConfigs;
// to remove a subclass, remove it from this SubClassConfigs list. Then the L screen will force the user to sell.

// structure containing list of abilities available to each class/subclass. Set MaxLevel to zero for abilities not available.
struct AbilityConfig
{
	var string AvailableSubClass;	// can be none
	var class<RPGAbility> AvailableAbility;
	var int MaxLevel;
};
var config Array<AbilityConfig> AbilityConfigs;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if (CurrentLevel==0)
		return 1;	// can buy. Check for valid class is done elsewhere
	else
		return 0;	// can only buy one level for cost purposes

}

defaultproperties
{
	BotChance=1			// reduce chance of bot buying this

	SubClasses(0)="None"
	SubClasses(1)="AM/WM hybrid"
	SubClasses(2)="AM/MM hybrid"
	SubClasses(3)="AM/Eng hybrid"
	SubClasses(4)="WM/MM hybrid"
	SubClasses(5)="WM/Eng hybrid"
	SubClasses(6)="MM/Eng hybrid"
	SubClasses(7)="Extreme AM"
	SubClasses(8)="Extreme WM"
	SubClasses(9)="Extreme Medic"
	SubClasses(10)="Extreme Monsters"
	SubClasses(11)="Extreme Engineer"
	SubClasses(12)="Berserker"
	
	SubClassConfigs(0)=(AvailableClass=Class'ClassAdrenalineMaster',AvailableSubClass="AM/WM hybrid",MinLevel=90)
	SubClassConfigs(1)=(AvailableClass=Class'ClassAdrenalineMaster',AvailableSubClass="AM/MM hybrid",MinLevel=90)
	SubClassConfigs(2)=(AvailableClass=Class'ClassAdrenalineMaster',AvailableSubClass="AM/Eng hybrid",MinLevel=90)
	SubClassConfigs(3)=(AvailableClass=Class'ClassAdrenalineMaster',AvailableSubClass="Extreme AM",MinLevel=110)
	SubClassConfigs(4)=(AvailableClass=Class'ClassWeaponsMaster',AvailableSubClass="AM/WM hybrid",MinLevel=90)
	SubClassConfigs(5)=(AvailableClass=Class'ClassWeaponsMaster',AvailableSubClass="WM/MM hybrid",MinLevel=90)
	SubClassConfigs(6)=(AvailableClass=Class'ClassWeaponsMaster',AvailableSubClass="WM/Eng hybrid",MinLevel=90)
	SubClassConfigs(7)=(AvailableClass=Class'ClassWeaponsMaster',AvailableSubClass="Extreme WM",MinLevel=110)
	SubClassConfigs(8)=(AvailableClass=Class'ClassWeaponsMaster',AvailableSubClass="Berserker",MinLevel=110)
	SubClassConfigs(9)=(AvailableClass=Class'ClassMonsterMaster',AvailableSubClass="AM/MM hybrid",MinLevel=90)
	SubClassConfigs(10)=(AvailableClass=Class'ClassMonsterMaster',AvailableSubClass="WM/MM hybrid",MinLevel=90)
	SubClassConfigs(11)=(AvailableClass=Class'ClassMonsterMaster',AvailableSubClass="MM/Eng hybrid",MinLevel=90)
	SubClassConfigs(12)=(AvailableClass=Class'ClassMonsterMaster',AvailableSubClass="Extreme Medic",MinLevel=110)
	SubClassConfigs(13)=(AvailableClass=Class'ClassMonsterMaster',AvailableSubClass="Extreme Monsters",MinLevel=110)
	SubClassConfigs(14)=(AvailableClass=Class'ClassEngineer',AvailableSubClass="AM/Eng hybrid",MinLevel=90)
	SubClassConfigs(15)=(AvailableClass=Class'ClassEngineer',AvailableSubClass="WM/Eng hybrid",MinLevel=90)
	SubClassConfigs(16)=(AvailableClass=Class'ClassEngineer',AvailableSubClass="MM/Eng hybrid",MinLevel=90)
	SubClassConfigs(17)=(AvailableClass=Class'ClassEngineer',AvailableSubClass="Extreme Engineer",MinLevel=110)
	SubClassConfigs(18)=(AvailableClass=Class'ClassGeneral',AvailableSubClass="AM/WM hybrid",MinLevel=90)
	SubClassConfigs(19)=(AvailableClass=Class'ClassGeneral',AvailableSubClass="AM/MM hybrid",MinLevel=90)
	SubClassConfigs(20)=(AvailableClass=Class'ClassGeneral',AvailableSubClass="AM/Eng hybrid",MinLevel=90)
	SubClassConfigs(21)=(AvailableClass=Class'ClassGeneral',AvailableSubClass="WM/MM hybrid",MinLevel=90)
	SubClassConfigs(22)=(AvailableClass=Class'ClassGeneral',AvailableSubClass="WM/Eng hybrid",MinLevel=90)
	SubClassConfigs(23)=(AvailableClass=Class'ClassGeneral',AvailableSubClass="MM/Eng hybrid",MinLevel=90)

	// now the subtypes.
	// first the default no subclass versions. These take the AbilityName of the class, and do not appear in the SubClassConfigs above
	AbilityConfigs(0)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)   // 4
	AbilityConfigs(1)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(2)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)  // 2
	AbilityConfigs(3)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)    // 5
	AbilityConfigs(4)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)   // 2
	AbilityConfigs(5)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidLoaded',MaxLevel=0)           // 5
	AbilityConfigs(6)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidVampire',MaxLevel=0)          // 10
	AbilityConfigs(7)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0) // 10
	AbilityConfigs(8)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=15) // 15
	AbilityConfigs(9)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidShieldRegen',MaxLevel=15)      // 15
	AbilityConfigs(10)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityShieldHealing',MaxLevel=3)   // 3
	AbilityConfigs(11)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidArmorRegen',MaxLevel=5)        // 5
	AbilityConfigs(12)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidArmorVampire',MaxLevel=10)     // 10
	AbilityConfigs(13)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=10)  // 10
	AbilityConfigs(14)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=1)  // 1
	AbilityConfigs(15)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityRapidBuild',MaxLevel=5)         // 5
	AbilityConfigs(16)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)       // 3
	AbilityConfigs(17)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)          // 9
	AbilityConfigs(18)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)      // 2
	AbilityConfigs(19)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)     // 15
	AbilityConfigs(20)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0) // 10
	AbilityConfigs(21)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)      // 20
	AbilityConfigs(22)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)       // 7
	AbilityConfigs(23)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(24)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)  // 10
	AbilityConfigs(25)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidAmmoRegen',MaxLevel=0)    // 4
	AbilityConfigs(26)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidAwareness',MaxLevel=0)    // 2
	AbilityConfigs(27)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0) // 2 or 3
	AbilityConfigs(28)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidRegen',MaxLevel=0)        // 5
	AbilityConfigs(29)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0) // 3
	AbilityConfigs(30)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityVehicleEject',MaxLevel=4)  // 1 or 4
	AbilityConfigs(31)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=3)  // 1 or 3
	AbilityConfigs(32)=(AvailableSubClass="Class: Engineer",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)	// 0

	AbilityConfigs(33)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=4)
	AbilityConfigs(34)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(35)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=2)
	AbilityConfigs(36)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidEnergyVampire',MaxLevel=5)
	AbilityConfigs(37)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityEnergyShield',MaxLevel=2)
	AbilityConfigs(38)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(39)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(40)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(41)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(42)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(43)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(44)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(45)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(46)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(47)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(48)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(49)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(50)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(51)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(52)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(53)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(54)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(55)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(56)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(57)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(58)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidAmmoRegen',MaxLevel=4)
	AbilityConfigs(59)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(60)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=3)
	AbilityConfigs(61)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidRegen',MaxLevel=0)
	AbilityConfigs(62)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=3)
	AbilityConfigs(63)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(64)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(65)=(AvailableSubClass="Class: Adrenaline Master",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(66)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(67)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(68)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(69)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(70)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(71)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidLoaded',MaxLevel=5)
	AbilityConfigs(72)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidVampire',MaxLevel=10)
	AbilityConfigs(73)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=10)
	AbilityConfigs(74)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(75)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(76)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(77)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(78)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(79)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(80)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(81)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(82)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(83)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(84)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(85)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(86)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(87)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(88)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(89)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(90)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(91)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidAmmoRegen',MaxLevel=4)
	AbilityConfigs(92)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(93)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=2)
	AbilityConfigs(94)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidRegen',MaxLevel=5)
	AbilityConfigs(95)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0)
	AbilityConfigs(96)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(97)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(98)=(AvailableSubClass="Class: Weapons Master",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)

	AbilityConfigs(99)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(100)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(101)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(102)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(103)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(104)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(105)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(106)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(107)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=3)
	AbilityConfigs(108)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityExpHealing',MaxLevel=9)
	AbilityConfigs(109)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=2)
	AbilityConfigs(110)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=15)
	AbilityConfigs(111)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=10)
	AbilityConfigs(112)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=20)
	AbilityConfigs(113)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=7)
	AbilityConfigs(114)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(115)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=10)
	AbilityConfigs(116)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(117)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(118)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(119)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(120)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(121)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(122)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(123)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(124)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidAmmoRegen',MaxLevel=0)
	AbilityConfigs(125)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(126)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(127)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidRegen',MaxLevel=5)
	AbilityConfigs(128)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=3)
	AbilityConfigs(129)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(130)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(131)=(AvailableSubClass="Class: Monster/Medic Master",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)

	// now the hybrids
	AbilityConfigs(132)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(133)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=2)   // 4
	AbilityConfigs(134)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(135)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidEnergyVampire',MaxLevel=5)
	AbilityConfigs(136)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(137)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidLoaded',MaxLevel=2)
	AbilityConfigs(138)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidVampire',MaxLevel=3)
	AbilityConfigs(139)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(140)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(141)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(142)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(143)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(144)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(145)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(146)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(147)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(148)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(149)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(150)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(151)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(152)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(153)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(154)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(155)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(156)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(157)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidAmmoRegen',MaxLevel=4)
	AbilityConfigs(158)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(159)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(160)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidRegen',MaxLevel=3)
	AbilityConfigs(161)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0)
	AbilityConfigs(162)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(163)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(164)=(AvailableSubClass="AM/WM hybrid",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(165)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(166)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=2)   // 4
	AbilityConfigs(167)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(168)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(169)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityEnergyShield',MaxLevel=1)
	AbilityConfigs(170)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(171)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(172)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(173)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=2)
	AbilityConfigs(174)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityExpHealing',MaxLevel=2)
	AbilityConfigs(175)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(176)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(177)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(178)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(179)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(180)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(181)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(182)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(183)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(184)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(185)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(186)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(187)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(188)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(189)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(190)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidAmmoRegen',MaxLevel=2)
	AbilityConfigs(191)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(192)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(193)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidRegen',MaxLevel=3)
	AbilityConfigs(194)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=3)
	AbilityConfigs(195)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(196)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(197)=(AvailableSubClass="AM/MM hybrid",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(198)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(199)=(AvailableSubClass="AM/Eng hybridr",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=2)   // 4
	AbilityConfigs(200)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(201)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(202)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityEnergyShield',MaxLevel=2)
	AbilityConfigs(203)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(204)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(205)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(206)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(207)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(208)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(209)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(210)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(211)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(212)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(213)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(214)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(215)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=8)
	AbilityConfigs(216)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(217)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(218)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(219)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(220)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=6)
	AbilityConfigs(221)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(222)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(223)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidAmmoRegen',MaxLevel=2)
	AbilityConfigs(224)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(225)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(226)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidRegen',MaxLevel=0)
	AbilityConfigs(227)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=3)
	AbilityConfigs(228)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(229)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(230)=(AvailableSubClass="AM/Eng hybrid",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(231)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(232)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(233)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(234)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(235)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(236)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidLoaded',MaxLevel=2)
	AbilityConfigs(237)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(238)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(239)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=2)
	AbilityConfigs(240)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityExpHealing',MaxLevel=2)
	AbilityConfigs(241)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(242)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(243)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(244)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(245)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(246)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(247)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(248)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(249)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(250)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(251)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(252)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(253)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(254)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(255)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(256)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidAmmoRegen',MaxLevel=2)
	AbilityConfigs(257)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(258)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(259)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidRegen',MaxLevel=5)
	AbilityConfigs(260)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=1)
	AbilityConfigs(261)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(262)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(263)=(AvailableSubClass="WM/MM hybrid",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(264)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(265)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(266)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(267)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(268)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(269)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidLoaded',MaxLevel=2)
	AbilityConfigs(270)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidVampire',MaxLevel=3)
	AbilityConfigs(271)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(272)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(273)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(274)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(275)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(276)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(277)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(278)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(279)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(280)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(281)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=8)
	AbilityConfigs(282)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(283)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityShieldHealing',MaxLevel=3)
	AbilityConfigs(284)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidArmorRegen',MaxLevel=2)
	AbilityConfigs(285)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidArmorVampire',MaxLevel=5)
	AbilityConfigs(286)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=6)
	AbilityConfigs(287)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(288)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(289)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidAmmoRegen',MaxLevel=2)
	AbilityConfigs(290)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(291)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(292)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidRegen',MaxLevel=3)
	AbilityConfigs(293)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0)
	AbilityConfigs(294)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(295)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(296)=(AvailableSubClass="WM/Eng hybrid",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
			             
	AbilityConfigs(297)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(298)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(299)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(300)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(301)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(302)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(303)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(304)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(305)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=2)
	AbilityConfigs(306)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityExpHealing',MaxLevel=2)
	AbilityConfigs(307)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(308)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(309)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(310)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(311)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(312)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(313)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=5)
	AbilityConfigs(314)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=8)
	AbilityConfigs(315)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(316)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityShieldHealing',MaxLevel=3)
	AbilityConfigs(317)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(318)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(319)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=6)
	AbilityConfigs(320)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(321)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(322)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidAmmoRegen',MaxLevel=3)
	AbilityConfigs(323)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(324)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(325)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidRegen',MaxLevel=3)
	AbilityConfigs(326)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=1)
	AbilityConfigs(327)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(328)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(329)=(AvailableSubClass="MM/Eng hybrid",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	// now the extremes and other novelty ones
	AbilityConfigs(330)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=5)
	AbilityConfigs(331)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(332)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=3)
	AbilityConfigs(333)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidEnergyVampire',MaxLevel=2)
	AbilityConfigs(334)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityEnergyShield',MaxLevel=3)
	AbilityConfigs(335)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(336)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(337)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(338)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(339)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(340)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(341)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(342)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(343)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(344)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(345)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(346)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(347)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(348)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(349)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(350)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(351)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(352)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(353)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(354)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(355)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidAmmoRegen',MaxLevel=1)
	AbilityConfigs(356)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(357)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(358)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidRegen',MaxLevel=0)
	AbilityConfigs(359)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=4)
	AbilityConfigs(360)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityVehicleEject',MaxLevel=0)
	AbilityConfigs(361)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=0)
	AbilityConfigs(362)=(AvailableSubClass="Extreme AM",AvailableAbility=class'DruidGhost',MaxLevel=2)
	AbilityConfigs(363)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityFastWeaponSwitch',MaxLevel=1)
	AbilityConfigs(364)=(AvailableSubClass="Extreme AM",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	               
	AbilityConfigs(365)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)	
	AbilityConfigs(366)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(367)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(368)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(369)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(370)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidLoaded',MaxLevel=6)
	AbilityConfigs(371)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidVampire',MaxLevel=15)
	AbilityConfigs(372)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=10)
	AbilityConfigs(373)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(374)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(375)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(376)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(377)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(378)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(379)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(380)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(381)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(382)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(383)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(384)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(385)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(386)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(387)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(388)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(389)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(390)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidAmmoRegen',MaxLevel=4)
	AbilityConfigs(391)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(392)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(393)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidRegen',MaxLevel=0)
	AbilityConfigs(394)=(AvailableSubClass="Extreme WM",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0)
	AbilityConfigs(395)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityVehicleEject',MaxLevel=0)
	AbilityConfigs(396)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=0)
	AbilityConfigs(397)=(AvailableSubClass="Extreme WM",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(398)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(399)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(400)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=2)
	AbilityConfigs(401)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(402)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(403)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidLoaded',MaxLevel=5)
	AbilityConfigs(404)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidVampire',MaxLevel=10)
	AbilityConfigs(405)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(406)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(407)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(408)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(409)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(410)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(411)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(412)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(413)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(414)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(415)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(416)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(417)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(418)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(419)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(420)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(421)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(422)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(423)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidAmmoRegen',MaxLevel=4)
	AbilityConfigs(424)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(425)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(426)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidRegen',MaxLevel=0)
	AbilityConfigs(427)=(AvailableSubClass="Berserker",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0)
	AbilityConfigs(428)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityVehicleEject',MaxLevel=0)
	AbilityConfigs(429)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=0)
	AbilityConfigs(430)=(AvailableSubClass="Berserker",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=20)

	AbilityConfigs(431)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(432)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(433)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(434)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(435)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(436)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(437)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(438)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(439)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=4)
	AbilityConfigs(440)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityExpHealing',MaxLevel=15)
	AbilityConfigs(441)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=2)
	AbilityConfigs(442)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(443)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(444)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(445)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(446)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(447)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=10)
	AbilityConfigs(448)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(449)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(450)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(451)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(452)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(453)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(454)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(455)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(456)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidAmmoRegen',MaxLevel=0)
	AbilityConfigs(457)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(458)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(459)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidRegen',MaxLevel=5)
	AbilityConfigs(460)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=2)
	AbilityConfigs(461)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityVehicleEject',MaxLevel=0)
	AbilityConfigs(462)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=0)
	AbilityConfigs(463)=(AvailableSubClass="Extreme Medic",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(464)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(465)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(466)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(467)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(468)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(469)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(470)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(471)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(472)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=2)
	AbilityConfigs(473)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(474)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=1)
	AbilityConfigs(475)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=20)
	AbilityConfigs(476)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=10)
	AbilityConfigs(477)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=30)
	AbilityConfigs(478)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=7)
	AbilityConfigs(479)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=20)
	AbilityConfigs(480)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=10)
	AbilityConfigs(481)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0)
	AbilityConfigs(482)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(483)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(484)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(485)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(486)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)
	AbilityConfigs(487)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(488)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(489)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidAmmoRegen',MaxLevel=0)
	AbilityConfigs(490)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(491)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(492)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidRegen',MaxLevel=5)
	AbilityConfigs(493)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=2)
	AbilityConfigs(494)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityVehicleEject',MaxLevel=0)
	AbilityConfigs(495)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=0)
	AbilityConfigs(496)=(AvailableSubClass="Extreme Monsters",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	
	AbilityConfigs(497)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(498)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(499)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(500)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)
	AbilityConfigs(501)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(502)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidLoaded',MaxLevel=0)
	AbilityConfigs(503)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidVampire',MaxLevel=0)
	AbilityConfigs(504)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0)
	AbilityConfigs(505)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)
	AbilityConfigs(506)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(507)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(508)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(509)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(510)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(511)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(512)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(513)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)
	AbilityConfigs(514)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=20)
	AbilityConfigs(515)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(516)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(517)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidArmorRegen',MaxLevel=5)
	AbilityConfigs(518)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidArmorVampire',MaxLevel=15)
	AbilityConfigs(519)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=10)
	AbilityConfigs(520)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(521)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityRapidBuild',MaxLevel=10)
	AbilityConfigs(522)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidAmmoRegen',MaxLevel=0)
	AbilityConfigs(523)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidAwareness',MaxLevel=0)
	AbilityConfigs(524)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(525)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidRegen',MaxLevel=0)
	AbilityConfigs(526)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0)
	AbilityConfigs(527)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityVehicleEject',MaxLevel=4)
	AbilityConfigs(528)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=3)
	AbilityConfigs(529)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)
	AbilityConfigs(530)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'DruidGhost',MaxLevel=2)
	AbilityConfigs(531)=(AvailableSubClass="Extreme Engineer",AvailableAbility=class'AbilityFastWeaponSwitch',MaxLevel=1)

	// now the General class
	AbilityConfigs(532)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)
	AbilityConfigs(533)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=1)   // 4
	AbilityConfigs(534)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)
	AbilityConfigs(535)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidEnergyVampire',MaxLevel=3)
	AbilityConfigs(536)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)
	AbilityConfigs(537)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidLoaded',MaxLevel=1)
	AbilityConfigs(538)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidVampire',MaxLevel=2)
	AbilityConfigs(539)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=2)
	AbilityConfigs(540)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=2)
	AbilityConfigs(541)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)
	AbilityConfigs(542)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)
	AbilityConfigs(543)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)
	AbilityConfigs(544)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0)
	AbilityConfigs(545)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)
	AbilityConfigs(546)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)
	AbilityConfigs(547)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(548)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=2)
	AbilityConfigs(549)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=5)
	AbilityConfigs(550)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)
	AbilityConfigs(551)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)
	AbilityConfigs(552)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)
	AbilityConfigs(553)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)
	AbilityConfigs(554)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=3)
	AbilityConfigs(555)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)
	AbilityConfigs(556)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)
	AbilityConfigs(557)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidAmmoRegen',MaxLevel=2)
	AbilityConfigs(558)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidAwareness',MaxLevel=2)
	AbilityConfigs(559)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0)
	AbilityConfigs(560)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidRegen',MaxLevel=3)
	AbilityConfigs(561)=(AvailableSubClass="Class: General",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=3)
	AbilityConfigs(562)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityVehicleEject',MaxLevel=1)
	AbilityConfigs(563)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=1)
	AbilityConfigs(564)=(AvailableSubClass="Class: General",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)


	// now the "No class" ability settings
	AbilityConfigs(565)=(AvailableSubClass="None",AvailableAbility=class'DruidArtifactLoaded',MaxLevel=0)   // 4
	AbilityConfigs(566)=(AvailableSubClass="None",AvailableAbility=class'DruidArtifactLoadedHybrid',MaxLevel=0)   // 4
	AbilityConfigs(567)=(AvailableSubClass="None",AvailableAbility=class'DruidAdrenalineSurge',MaxLevel=0)  // 2
	AbilityConfigs(568)=(AvailableSubClass="None",AvailableAbility=class'DruidEnergyVampire',MaxLevel=0)    // 5
	AbilityConfigs(569)=(AvailableSubClass="None",AvailableAbility=class'AbilityEnergyShield',MaxLevel=0)   // 2
	AbilityConfigs(570)=(AvailableSubClass="None",AvailableAbility=class'DruidLoaded',MaxLevel=0)           // 5
	AbilityConfigs(571)=(AvailableSubClass="None",AvailableAbility=class'DruidVampire',MaxLevel=0)          // 10
	AbilityConfigs(572)=(AvailableSubClass="None",AvailableAbility=class'AbilityEnhancedDamage',MaxLevel=0) // 10
	AbilityConfigs(573)=(AvailableSubClass="None",AvailableAbility=class'AbilityLoadedEngineer',MaxLevel=0) // 15
	AbilityConfigs(574)=(AvailableSubClass="None",AvailableAbility=class'DruidShieldRegen',MaxLevel=0)      // 15
	AbilityConfigs(575)=(AvailableSubClass="None",AvailableAbility=class'AbilityShieldHealing',MaxLevel=0)   // 3
	AbilityConfigs(576)=(AvailableSubClass="None",AvailableAbility=class'DruidArmorRegen',MaxLevel=0)        // 5
	AbilityConfigs(577)=(AvailableSubClass="None",AvailableAbility=class'DruidArmorVampire',MaxLevel=0)     // 10
	AbilityConfigs(578)=(AvailableSubClass="None",AvailableAbility=class'AbilityConstructionHealthBonus',MaxLevel=0)  // 10
	AbilityConfigs(579)=(AvailableSubClass="None",AvailableAbility=class'AbilityEngineerAwareness',MaxLevel=0)  // 1
	AbilityConfigs(580)=(AvailableSubClass="None",AvailableAbility=class'AbilityRapidBuild',MaxLevel=0)         // 5
	AbilityConfigs(581)=(AvailableSubClass="None",AvailableAbility=class'AbilityLoadedHealing',MaxLevel=0)       // 3
	AbilityConfigs(582)=(AvailableSubClass="None",AvailableAbility=class'AbilityExpHealing',MaxLevel=0)          // 9
	AbilityConfigs(583)=(AvailableSubClass="None",AvailableAbility=class'AbilityMedicAwareness',MaxLevel=0)      // 2
	AbilityConfigs(584)=(AvailableSubClass="None",AvailableAbility=class'AbilityLoadedMonsters',MaxLevel=0)     // 15
	AbilityConfigs(585)=(AvailableSubClass="None",AvailableAbility=class'AbilityMonsterHealthBonus',MaxLevel=0) // 10
	AbilityConfigs(586)=(AvailableSubClass="None",AvailableAbility=class'AbilityMonsterPoints',MaxLevel=0)      // 20
	AbilityConfigs(587)=(AvailableSubClass="None",AvailableAbility=class'AbilityMonsterSkill',MaxLevel=0)       // 7
	AbilityConfigs(588)=(AvailableSubClass="None",AvailableAbility=class'AbilityMonsterDamage',MaxLevel=0)
	AbilityConfigs(589)=(AvailableSubClass="None",AvailableAbility=class'AbilityEnhancedReduction',MaxLevel=0)  // 10
	AbilityConfigs(590)=(AvailableSubClass="None",AvailableAbility=class'DruidAmmoRegen',MaxLevel=0)    // 4
	AbilityConfigs(591)=(AvailableSubClass="None",AvailableAbility=class'DruidAwareness',MaxLevel=0)    // 2
	AbilityConfigs(592)=(AvailableSubClass="None",AvailableAbility=class'DruidNoWeaponDrop',MaxLevel=0) // 2 or 3
	AbilityConfigs(593)=(AvailableSubClass="None",AvailableAbility=class'DruidRegen',MaxLevel=0)        // 5
	AbilityConfigs(594)=(AvailableSubClass="None",AvailableAbility=class'DruidAdrenalineRegen',MaxLevel=0) // 3
	AbilityConfigs(595)=(AvailableSubClass="None",AvailableAbility=class'AbilityVehicleEject',MaxLevel=0)  // 1 or 4
	AbilityConfigs(596)=(AvailableSubClass="None",AvailableAbility=class'AbilityWheeledVehicleStunts',MaxLevel=0)  // 1 or 3
	AbilityConfigs(597)=(AvailableSubClass="None",AvailableAbility=class'AbilityBerserkerDamage',MaxLevel=0)	// 0
                 

	MaxLevel=SubClasses.length
}