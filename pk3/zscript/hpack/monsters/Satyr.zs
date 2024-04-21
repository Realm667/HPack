class Satyr : Actor //3999
{
Default
	{
	//$Category Monsters
	//$Title Satyr Archer
	Monster;
	Health 150;
	Radius 24;
	Height 64;
	Speed 13;
	PainChance 50;
	Mass 150;
	SeeSound "satyr/sight";
	PainSound "satyr/pain";
	DeathSound "satyr/death";
	ActiveSound "satyr/active";
	Obituary "$OB_SATYR";
	Tag "$FN_SATYR";
	+FLOORCLIP
	DropItem "CrossbowMed", 64, 5;
	}
States
	{
	Spawn:
		STY2 AB 10 A_Look();
		Loop;
	See:
		STY2 AABBCCDD 3 A_Chase();
		Loop;
	Missile:
		STY2 E 6 { A_FaceTarget(); A_StartSound("satyr/attack1",6); }
		STY2 F 6;
		STY2 G 8;
		STZ2 A 3 Light("SatyrTrail3") { A_FaceTarget(); A_SpawnProjectile("SatyrArrow",40); A_StartSound("satyr/attack2",7); }
		STY2 H 3 Light("SatyrTrail6");
		Goto See;
	Pain:
		STY2 I 2;
		STY2 I 2 A_Pain();
		Goto See;
	Death:
		STY2 J 5;
		STY2 K 5 { A_Scream(); A_SpawnProjectile("SatyrBow",44,32,-90); }
		STY2 L 6;
		STY2 M 7 A_Fall();
		STY2 NO 4;
		STY2 P -1;
		Stop;
	XDeath:
		STY2 Q 5;
		STY2 R 5 { A_XScream(); A_SpawnProjectile("SatyrBow",44,32,-90); }
		STY2 S 5;
		STY2 T 5 A_Fall();
		STY2 UVWXY 5;
		STY2 Z -1;
		Stop;
	Ice:
		ST2I A 5 A_FreezeDeath();
		ST2I A 1 A_FreezeDeathChunks();
		Wait;
	Raise:
		STY2 PONMLKJ 8;
		Goto See;
	}
}

class SatyrArrow : Actor
{
Default
	{
	Projectile;
	Radius 3;
	Height 3;
	Speed 40;
	Damage 3;
	Scale 0.75;
	Decal "CrossbowScorch";
	DeathSound "satyr/hit";
	+THRUGHOST
	}
States
	{
	Spawn:
		RFX1 P 1 Bright A_SpawnItemEx("SatyrTrail");
		Loop;
	Death:
		TNT1 AAAAAAAA 0 A_SpawnItemEx("SatyrTrail",random(-1,1),random(-1,1),random(0,8),(0.1)*Random(1,3),0,(0.1)*Random(1,10),random(0,360));
		TNT1 ABCDEFG 3;
		Stop;
	}
}

class SatyrTrail : Actor
{
Default
	{
	+NOINTERACTION
	Renderstyle "Add";
	Alpha 0.8;
	Scale 0.5;
	}
States
	{
	Spawn:
		BONE IJKLMNO 2 Bright;
		Stop;
	}
}

class SatyrBow : Actor
{
Default
	{
	Projectile;
	Radius 8;
	Height 8;
	Speed 1;
	Gravity 0.125;
	-NOGRAVITY
	-ACTIVATEIMPACT
	-ACTIVATEPCROSS
	}
States
	{
	Spawn:
		STYB A 10 Bright;
		goto Death;
	Death:
		STYB A -1;
		Stop;
	}
}