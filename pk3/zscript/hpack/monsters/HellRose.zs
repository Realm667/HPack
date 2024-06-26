class Hellrose : Actor
{
bool dontremove; int spitchance; int spitlimit; string spitactor;
static const string commonspit[] = { "SpitHorn", "SpitHelmet", "SpitBrace", "SpitSkull", "SpitBoot" };
static const string uncommonspit[] = { "BlasterAmmo", "SkullRodAmmo", "GoldWandMed", "PhoenixRodAmmo", "MaceMed" };
static const string rarespit[] = { "HPMorphWand", "SpitCaco", "SpitNemeskull" };
Default
	{
	//$Category Monsters
	//$Title Hell Rose
	Monster;
	Health 300;
	Radius 32;
	Height 56;
	CameraHeight 41;
	Mass 5000;
	Speed 0;
	MaxTargetRange 896;
	Scale 0.8;
	BloodColor "0 50 0";
	DeathSound "HellRose/Death";
	Obituary "$OB_HELLROSE";
	Tag "$FN_HELLROSE";
	+DONTMORPH
	+FLOORCLIP
	+STANDSTILL
	+LOOKALLAROUND
	+NOPAIN
	+DONTTHRUST
	}
States
	{
	Spawn:
		ROSE A 2 A_Look();
		Loop;
	See:
		ROSE A 4 { A_Chase(); spitchance = random(1,5000); }
		Loop;
	Spit:
		ROSE A 55 A_StartSound("HellRose/StomachGrowl",2);
		ROSE B 5 HP_RoseSporeSpit(2);
		ROSE C 5 { HP_RoseSporeSpit(2); HP_RoseChunkSpit(); }
		ROSE CB 3 HP_RoseSporeSpit(2);
		goto See;
	Missile:
		ROSE A 0 A_StartSound("HellRose/Attack");
		ROSE A 0 A_Jump(64,"Missile2","Missile3");
		ROSE BBCC 3;
		ROSE CC 0 HP_RoseVine();
		ROSE B 3 HP_RoseSporeSpit(4);
		ROSE A 0 HP_RoseSporeSpit(2);
		Goto See;
	Missile2:
		ROSE BBCCDD 3;
		ROSE DD 0 HP_RoseVine();
		ROSE C 3 HP_RoseSporeSpit(5);
		ROSE B 3 HP_RoseSporeSpit(4);
		ROSE A 0 HP_RoseSporeSpit(2);
		Goto See;
	Missile3:
		ROSE BBCCDDEE 3;
		ROSE EE 0 HP_RoseVine();
		ROSE DC 3 HP_RoseSporeSpit(5);
		ROSE B 3 HP_RoseSporeSpit(4);
		ROSE A 0 HP_RoseSporeSpit(2);
		Goto See;
	Death:
		ROSE F 6;
		ROSE G 6 A_Scream();
		ROSE H 6 A_Fall();
		ROSE IJ 6;
		ROSE K -1;
		Stop;
	XDeath:
		ROSE L 5 ;
		ROSE M 5 A_StartSound("HellRose/XDeath",2);
		ROSE N 5 A_Fall();
		ROSE OPQ 5;
		ROSE R -1;
		Stop;
	Raise:
		ROSE KJIHGF 5;
		goto See;
	Ice:
		ROSE T 5 A_FreezeDeath();
		ROSE T 1 A_FreezeDeathChunks();
		Wait;
	}
	void HP_RoseSporeSpit(int times = 1)
	{
	while(times > 0)
		{
		A_SpawnItemEx("Spore",0,0,56,frandom(1,2),0,frandom(2,4),random(0,359));
		times--;
		}	
	}
	void HP_RoseChunkSpit()
	{
		A_StartSound("HellRose/Spit");
		int x = random(1,1000);
		if(x > 980) spitactor = rarespit[random(0,2)];
		else if(x < 981 && x > 889 ) spitactor = uncommonspit[random(0,4)];
		else spitactor = commonspit[random(0,4)];
		A_SpawnItemEx(spitactor,0,0,56,frandom(2,4),0,frandom(3,5),random(0,359));
		A_SpawnItemEx("Blood",0,0,56,frandom(2,3),0,frandom(2,4),random(0,359),SXF_USEBLOODCOLOR);
		A_SpawnItemEx("Blood",0,0,56,frandom(2,3),0,frandom(2,4),random(0,359),SXF_USEBLOODCOLOR);
		A_SpawnItemEx("Blood",0,0,56,frandom(2,3),0,frandom(2,4),random(0,359),SXF_USEBLOODCOLOR);
		A_SpawnItemEx("Blood",0,0,56,frandom(2,3),0,frandom(2,4),random(0,359),SXF_USEBLOODCOLOR);
		A_SpawnItemEx("Blood",0,0,56,frandom(2,3),0,frandom(2,4),random(0,359),SXF_USEBLOODCOLOR);
		A_SpawnItemEx("Blood",0,0,56,frandom(2,3),0,frandom(2,4),random(0,359),SXF_USEBLOODCOLOR);
	}
	void HP_RoseVine()
	{
		if (special1 > 10) return;
		A_SpawnItemEx("HellroseBramble",randompick(-2,2),randompick(-2,2),0,0,0,0,0,SXF_SETMASTER|SXF_NOCHECKPOSITION);
		special1++;
	}
	override void Tick()
	{
		super.Tick();
		if(!isFrozen() && target && Distance3D(target) < 1024 && InStateSequence(self.Curstate,self.ResolveState("See")) && spitlimit < 4 && spitchance == 5000)
		{
			spitlimit++;
			SetStateLabel("Spit");
		}
	}
	override void Die(Actor source,Actor inflictor,int dmgflags,Name MeansOfDeath)
	{
		A_GiveToChildren("InvulUncheck",1);
		A_KillChildren(MeansOfDeath,KILS_FOILINVUL);
		if(MeansOfDeath == "ice") dontremove = true;
		super.Die(source,inflictor,dmgflags,MeansOfDeath);
	}
	override void OnDestroy()
	{
		if(!dontremove) A_RemoveChildren(true,RMVF_MISC);
		Super.OnDestroy();
	}
}

class InvulUncheck : CustomInventory
{
override bool TryPickup(in out Actor toucher)
	{
	if(toucher)
		{
		toucher.bSHOOTABLE = true;
		toucher.bSOLID = true;
		toucher.bINVULNERABLE = false;
		toucher.bREFLECTIVE = false;
		}
	return false;
	}
override void Tick()
	{
		super.Tick();
		Destroy();
	}
}

class HellroseBramble : Actor
{
int bramblescramble;
Default
	{
	Monster;
	Height 64;
	Radius 20;
	Speed 12;
	Health 50;
	Mass 5000;
	MeleeRange 60;
	BloodColor "0 50 0";
	Painchance 128;
	DeathSound "HellRose/BrambleDeath";
	Obituary "$OB_HELLROSE";
	Tag "$FN_HELLROSEBRAMBLE";
	-SLIDESONWALLS
	-CANPASS
	-OLDRADIUSDMG
	-SHOOTABLE
	-SOLID
	-COUNTKILL
	+DONTTHRUST
	+DONTMORPH
	-WINDTHRUST
	+NOTARGETSWITCH
	+FLOORCLIP
	+LOOKALLAROUND
	+NOPAIN
	}
States
	{
	Spawn:
		ROSX R 2 A_Look();
		Loop;
	See:
      ROSX RST 3
		{
		A_Chase();
		bramblescramble++;
		if(bramblescramble % 2) A_SpawnItemEx("DrtTrail",0,0,2,frandom(3,5),0,frandom(1,3),random(0,359));
		if(bramblescramble > 54)
			{
				if (CheckIfTargetInLOS()) return ResolveState("Melee");
				else bramblescramble = 0;
			}
			return ResolveState(null);
		}
		Loop;
	Melee:
		ROSX R 3 { bSHOOTABLE = true; bSOLID = true; bramblescramble = 0; A_StartSound("HellRose/Unearth",5,0,0.5); }
		ROSX Q 3;
		ROSX QQQQ 0 A_SpawnItemEx("DrtTrail",0,0,2,frandom(3,5),0,frandom(3,9),random(0,359));
		ROSX P 3 { A_FaceTarget(); A_CustomMeleeAttack(3,"HellRose/Hit"); }
		ROSX ONML 3;
		ROSX L 0 { A_StartSound("Hellrose/Swing",6,CHANF_LOOPING,0.5); bNOPAIN = false; }
	MeleeAnim:
		ROSX ABC 4;
		ROSX D 3 { A_FaceTarget(); A_CustomMeleeAttack(3,"HellRose/Hit"); }
		ROSX D 0 A_Jump(64,"MeleeAnim2");
		ROSX EF 5;
		ROSX G 3 { A_FaceTarget(); A_CustomMeleeAttack(3,"HellRose/Hit"); }
		ROSX G 0 HP_VineDistCheck();
		Loop;
	MeleeAnim2:
		ROSX JKL 4 ;
		ROSX H 3 { A_FaceTarget(); A_CustomMeleeAttack(3,"HellRose/Hit"); }
		ROSX H 0 HP_VineDistCheck();
		goto MeleeAnim;
	Pain:
		ROSX L 3 { bNOPAIN = true; bramblescramble = 0; A_StartSound("HellRose/Dig",5,0,0.5); A_StopSound(6); }
		ROSX LMNOPQ 3 A_SpawnItemEx("DrtTrail",0,0,2,frandom(3,5),0,frandom(1,3),random(0,359));
		ROSX R 3 { bSHOOTABLE = false; bSOLID = false; }
		Goto See;
	Death:
		ROSX U 5;
		ROSX V 5 A_ScreamandUnblock();
		ROSX WXR 5;
		ROSX R 50;
		ROSX R 5 A_FadeOut(0.1);
		Wait;
	}
	void HP_VineDistCheck()
	{
		int jumpchance = random(1,100);
		if(!CheckIfCloser(target,92,true) && jumpchance < 40) SetStateLabel("Pain");
		else A_MonsterRefire(30,"Pain");
	}
	override void Die(Actor source,Actor inflictor,int dmgflags,Name MeansOfDeath)
	{
		A_StopSound(6);
		if(master && master.special1 > 0) master.special1--;
		if(MeansOfDeath == "ice")
		{
			if(frame == 16 || frame == 17 || frame == 18 || frame == 19) frame = 15;
		}
		super.Die(source,inflictor,dmgflags,MeansOfDeath);
	}
	override void OnDestroy()
	{
		if(health>0) Die(self,self);
		Super.OnDestroy();
	}
}

class Spore : Actor
{
Default
	{
	Radius 2;
	Height 4;
	Renderstyle "Translucent";
	Alpha 0.5;
	Gravity 0.5;
	+MISSILE
	+NOTELEPORT
	+THRUACTORS
	}
States
	{
	Spawn:
		ROSE S 9;
		ROSE S 3 A_FadeOut(0.3);
		Wait;
	Death:
		TNT1 A 1;
		Stop;
	}
}

class DrtTrail : Actor
{
Default
	{
	Radius 2;
	Height 4;
	Gravity 0.5;
	+MISSILE
	+NOTELEPORT
	+THRUACTORS
	}
States
	{
	Spawn:
		TNT1 A 0 Nodelay A_Jump(256,"Drt1","Drt2","Drt3");
	Drt1:
		DIRT ABC 5;
		Loop;
	Drt2:
		DIRT DEF 5;
		Loop;
	Drt3:
		DIRT GHI 5;
		Loop;
	Death:
		DIRT JKL 3;
		Stop;
	}
}

class SpitBase : Actor
{
Default
	{
	Radius 4;
	Height 8;
	Gravity 0.7;
	+MISSILE
	+NOTELEPORT
	+THRUACTORS
	+BOUNCEONWALLS
	}
States
	{
	Spawn:
		"####" A 1;
		Loop;
	Death:
		"####" B -1;
		Stop;
	ToAvoidCrashes:
		HSP1 A 0;
		HSP2 A 0;
		HSP3 A 0;
		HSP4 A 0;
		HSP5 A 0;
		HSP6 A 0;
		HSP7 A 0;
		Stop;
	}
}

class SpitHorn : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP1");
	}
}

class SpitHelmet : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP2");
	}
}

class SpitBrace : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP3");
	}
}

class SpitSkull : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP4");
	}
}

class SpitBoot : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP5");
	}
}

class SpitCaco : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP6");
	}
}

class SpitNemeskull : SpitBase
{
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex("HSP7");
	}
}
