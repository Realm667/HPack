class HandStatue : Actor
{
Actor crystal;
Default
	{
	//$Category Obstacles
	//$Hand Statue
	//$Arg0 Color
	//$Arg0Type 11
	//$Arg0Enum { 0 = "Red"; 1 = "Yellow"; 2 = "Green"; 3 = "Blue"; 4 = "Orange"; 5 = "Purple"; 6 = "White"; 7 = "Black"; 8 = "Russet"; 9 = "Chartreuse"; 10 = "Lime"; 11 = "Cobalt"; 12 = "Pink"; }
	+SOLID
	Radius 16;
	Height 36;
	ProjectilePassHeight 32;
	Scale 0.5;
	}
States
	{
	Spawn:
		HAND A 0 NoDelay
			{
			crystal = Spawn("HandCrystal",(pos.x,pos.y,pos.z+42));
			HP_CrystalColor(args[0]);
			}
	Stand:
		HAND A -1;
		Stop;
	ChangetoRed:
		HAND A 0 HP_CrystalColor(0);
		goto Stand;
	ChangetoYellow:
		HAND A 0 HP_CrystalColor(1);
		goto Stand;
	ChangetoGreen:
		HAND A 0 HP_CrystalColor(2);
		goto Stand;
	ChangetoBlue:
		HAND A 0 HP_CrystalColor(3);
		goto Stand;
	ChangetoOrange:
		HAND A 0 HP_CrystalColor(4);
		goto Stand;
	ChangetoPurple:
		HAND A 0 HP_CrystalColor(5);
		goto Stand;
	ChangetoWhite:
		HAND A 0 HP_CrystalColor(6);
		goto Stand;
	ChangetoBlack:
		HAND A 0 HP_CrystalColor(7);
		goto Stand;
	ChangetoRusset:
		HAND A 0 HP_CrystalColor(8);
		goto Stand;
	ChangetoChartreuse:
		HAND A 0 HP_CrystalColor(9);
		goto Stand;
	ChangetoLime:
		HAND A 0 HP_CrystalColor(10);
		goto Stand;
	ChangetoCobalt:
		HAND A 0 HP_CrystalColor(11);
		goto Stand;
	ChangetoPink:
		HAND A 0 HP_CrystalColor(12);
		goto Stand;
	}
void HP_CrystalColor (int number)
	{
	if (crystal)
		{
		if (number ==  0) crystal.SetStatelabel("ColorRed");
		else if (number ==  1) crystal.SetStatelabel("ColorYellow");
		else if (number ==  2) crystal.SetStatelabel("ColorGreen");
		else if (number ==  3) crystal.SetStatelabel("ColorBlue");
		else if (number ==  4) crystal.SetStatelabel("ColorOrange");
		else if (number ==  5) crystal.SetStatelabel("ColorPurple");
		else if (number ==  6) crystal.SetStatelabel("ColorWhite");
		else if (number ==  7) crystal.SetStatelabel("ColorBlack");
		else if (number ==  8) crystal.SetStatelabel("ColorRusset");
		else if (number ==  9) crystal.SetStatelabel("ColorChartreuse");
		else if (number ==  10) crystal.SetStatelabel("ColorLime");
		else if (number ==  11) crystal.SetStatelabel("ColorCobalt");
		else if (number ==  12) crystal.SetStatelabel("ColorPink");
		}
	}
override void OnDestroy()
	{
	if (crystal) crystal.SetStatelabel("Null");
	Super.OnDestroy();
	}
}

class HandCrystal : Actor
{
Default
	{
	//+NOINTERACTION
	+NOCLIP +NOGRAVITY
	+RELATIVETOFLOOR
	RenderStyle "Translucent";
	Alpha 0.5;
	Scale 0.5;
	}
States
	{
	Spawn:
		TNT1 A 0;
	ColorRed:
		HANC A -1 Bright Light("HandCrystalRed");
	ColorYellow:
		HANC B -1 Bright Light("HandCrystalYellow");
	ColorGreen:
		HANC C -1 Bright Light("HandCrystalGreen");
	ColorBlue:
		HANC D -1 Bright Light("HandCrystalBlue");
	ColorOrange:
		HANC E -1 Bright Light("HandCrystalOrange");
	ColorPurple:
		HANC F -1 Bright Light("HandCrystalPurple");
	ColorWhite:
		HANC G -1 Bright Light("HandCrystalWhite");
	ColorBlack:
		HANC H -1 Bright Light("HandCrystalBlack");
	ColorRusset:
		HANC I -1 Bright Light("HandCrystalRusset");
	ColorChartreuse:
		HANC J -1 Bright Light("HandCrystalChartreuse");
	ColorLime:
		HANC K -1 Bright Light("HandCrystalLime");
	ColorCobalt:
		HANC L -1 Bright Light("HandCrystalCobalt");
	ColorPink:
		HANC M -1 Bright Light("HandCrystalPink");
	Stop;
	}
}