Class Wicked : Actor
{
Default
	{
	//$Category Monsters
	//$Title Wicked
	Monster;
	Health 225;
	Radius 25;
	Height 88;
	Mass 200;
	Speed 10;
	CameraHeight 73;
	PainChance 112;
	Obituary "$OB_WICKED";
	Tag "$FN_WICKED";
	SeeSound "monster/wiksit";
	PainSound "monster/wikpai";
	DeathSound "monster/wikdth";
	ActiveSound "monster/wikact";
	+NoGravity
	+Float
	}
States
  {
  Spawn:
    WICK ABCD 8 A_Look();
    Loop;
  See:
    WICK AABBCCDD 4 A_Chase();
    WICK A 0 A_Jump(64, "See2");
    Loop;
  See2:
    WICK EEFFGGHH 2 A_Chase();
    WICK E 0 A_Jump(32, "See");
    Loop;
  Missile:
    WICK I 1 A_StartSound("monster/wikatk");
    WICK I 4 A_FaceTarget();
    WICK J 5 Bright A_FaceTarget();
    WICK K 8 Bright A_SpawnProjectile("WickedShot",60,0,0);
    WICK L 5;
    Goto See;
  Pain:
    WICK M 3;
    WICK M 3 A_Pain();
    WICK M 3;
    Goto See;
  Death:
    WICK N 5 A_Scream();
    WICK OP 5;
    WICK P 0 A_SpawnItemEX("WickedTorso", 0,0,48, 0,0,0, 0, SXF_SETMASTER);
    WICT A 5 A_NoBlocking();
    WICT BCDEF 5;
    WICT G -1 A_SetFloorClip();
    Stop;
  Raise:
    WICT G 0 A_RemoveChildren(true);
    WICK G 0 A_SpawnItemEx("WickedTorsoRes", 0,0,0, 0,0,1, 0, 0);
    WICT G 5 A_UnSetFloorClip();
    WICT FEDBC 5;
    WICK PON 5;
    Goto See;
  }
}

Class WickedShot : Actor
{
  Default
  {
    Radius 8;
    Height 8;
    Speed 12;
	FastSpeed 18;
    Damage 4;
    RenderStyle "Add";
    DamageType "Fire";
    Alpha 0.67;
    SeeSound "weapons/firmfi";
    DeathSound "weapons/firex5";
    Projectile;
    //+ThruGhost
    +SeekerMissile
    +ForceXYBillboard
  }
  States
  {
  Spawn:
    WIBL ABCDABCDABCDABCDABCDABCDABCD 1 Bright A_SpawnItemEx("WickedFX", 0,0,0, random(-1,1),random(-1,1),random(-1,1), 0, SXF_CLIENTSIDE, 0);
    WIBL ABCD 0 Bright A_SeekerMissile(90,90);
    Loop;
  Death:
    WIBL JKLMN 3 Bright;
    Stop;
  }
}

Class WickedFX : Actor
{
  Default
  {
    RenderStyle "Add";
    Alpha 0.67;
    +NoInteraction
    +ForceXYBillboard
  }
  States
  {
  Spawn:
    TNT1 A 3 Bright;
    WIBL EFGHI 3 BRIGHT;
    Stop;
  }
}

Class WickedTorso : Actor
{
  Default
  {
    Mass 1000000;
    Radius 1;
    Height 1;
    +IsMonster
    +Corpse
  }

  States
  {
  Spawn:
    WICK Q 5 NoDelay A_StartSound("monster/tenpn1");
    WICK R 5;
    Wait;
  Crash:
    WICK S 1 A_SetFloorClip();
    WICK S 4 A_StartSound("monster/tenpn2");
    WICK TUV 5;
    WICK W -1;
    Stop;
  }
}

Class WickedTorsoRes : Actor
{
  Default
  {
    Radius 24;
    Height 24;
    +NoGravity
    +NoBlockMap
    +NoClip
  }
  States
  {
  Spawn:
    WICK WVUTSRQ 5;
    Stop;
  }
}
