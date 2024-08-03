/* The Inferno Demon is a mighty demon with full control over the power of fire. This monster 
   took a shit load of time to create and perfect, I hope you like it.
   I recommend to use it only as a boss like monster as it is extremely powerful and can kill 
   you really fast if you haven't mastered dodging. He can't hurt himself because he uses a 
   damage type and is resistant to his own damage type. He has about five attacks, one of which 
   has about twenty different combinations. */

class InfernoDemon : Actor
{
Default
	{
	//$Category Monsters
	//$Title Inferno Demon
	Monster;
	//DropItem "PhoenixRodHefty", 84, 10;
	//DropItem "ArtiSuperHealth", 51;
	Health 5000;
	Speed 16;
	Radius 65;
	Height 115;
	CameraHeight 100;
	Mass 5000;
	Damage 15;
	BloodColor "Orange";
	PainChance 4;
	DamageFactor "Inferno", 0;
	SeeSound "Infdem/see";
	PainSound "Infdem/pain";
	DeathSound "Infdem/death";
	ActiveSound "Infdem/active";
	Obituary "$OB_INFERNODEMON";
	Tag "$FN_INFERNODEMON";
	+MISSILEMORE
	+MISSILEEVENMORE
	+BOSS
	+FLOORCLIP
	+TELESTOMP
	+DONTMORPH
	+NOTARGET
	+NOICEDEATH
	//+NOTIMEFREEZE
	}
States
	{
	Spawn:
		DIAB A 5 A_Look();
		Loop;
	See:
		DIAB A 6 { A_Chase(); A_QuakeEx(3,3,3,3,0,768,"",QF_SCALEDOWN); A_StartSound("KoraxStep",6,CHANF_OVERLAP,0.7); }
		DIAB B 6 A_Chase();
		DIAB C 6 { A_Chase(); A_QuakeEx(3,3,3,3,0,768,"",QF_SCALEDOWN); A_StartSound("KoraxStep",6,CHANF_OVERLAP,0.7); }
		DIAB D 6 A_Chase();
		Loop;
	Missile:
		DIAB A 1 A_Jump(128,"Att05","Att06","Att07","Att08","Att09","Att10","Att11","Att12","Att13","Att14","Att15","Att16","Att17","Att18","Att19","Att20","Att21","Att22","Att23","Att24","Att25");
		DIAB A 1 A_Jump(256,"Att01","Att02","Att03","Att04");
	Att01:
		DIAB A 2 Bright A_FaceTarget();
		DIAB GGG 2 Bright A_SpawnItemEx("FirePuff",-24,0,96,0,0,7);
		DIAB G 15 Bright A_SpawnProjectile("MeteorBolt",32,0,0,0,0);
		goto See;
	Att02:
		DIAB A 2 Bright A_FaceTarget();
		DIAB H 15 Bright A_SpawnProjectile("InfernoBomb",70,0,0,0,0);
		goto See;
	Att03:
		DIAB B 20 Bright A_FaceTarget();
		DIAB C 20 Bright
			{
			for(double ang = -80; ang < 100; ang+=20)
				{ A_SpawnProjectile("FireBeam",0,0,ang,2,0); }
			A_QuakeEx(5,5,5,15,0,1280,"world/quake",QF_SCALEDOWN);
			}
		DIAB B 20 Bright A_FaceTarget();
		DIAB C 20 Bright
			{
			for(double ang = -80; ang < 100; ang+=20)
				{ A_SpawnProjectile("FireBeam",0,0,ang,2,0); }
			A_QuakeEx(5,5,5,15,0,1280,"world/quake",QF_SCALEDOWN);
			}
		Goto See;
	Att04:
		DIAB A 2 Bright A_FaceTarget();
		DIAB I 15 Bright A_SpawnProjectile("FireGlyphLineSpawner1",32,0,0,0,0);
		Goto See;
	Att05:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			for(double high = 60; high < 150; high+=30)
				{
				A_SpawnProjectile("LavaBall",high,32,0,0,0);
				A_SpawnProjectile("LavaBall",high,-32,0,0,0);
				}
			}
		Goto See;
	Att06:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright
			{
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",90,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			}
		DIAB F 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			A_SpawnProjectile("LavaBall",90,-32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			}
		Goto See;
	Att07:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright
			{
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			A_SpawnProjectile("LavaBall",90,-32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			}
		DIAB F 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",90,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			}
		Goto See;
	Att08:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright 
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",90,32,0,0,0);
			A_SpawnProjectile("LavaBall",90,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			}
		Goto See;
	Att09:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",90,32,0,0,0);
			A_SpawnProjectile("LavaBall",90,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			}
		Goto See;
	Att10:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",120,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",90,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",60,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",60,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",90,32,0,0,0); }
		DIAB F 10 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",120,-32,0,0,0); }
		Goto See;
	Att11:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",120,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",90,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",60,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",60,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",90,-32,0,0,0); }
		DIAB F 10 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",120,32,0,0,0); }
		Goto See;
	Att12:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			for(double high = 60; high < 150; high+=30)
				{
				A_SpawnProjectile("DemonMeteor",high,32,0,0,0);
				A_SpawnProjectile("DemonMeteor",high,-32,0,0,0);
				}
			}
		Goto See;
	Att13:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright
			{
			A_SpawnProjectile("DemonMeteor",60,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,32,0,0,0);
			}
		DIAB F 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("DemonMeteor",60,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,-32,0,0,0);
			}
		Goto See;
	Att14:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright
			{
			A_SpawnProjectile("DemonMeteor",60,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,-32,0,0,0);
			}
		DIAB F 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("DemonMeteor",60,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,32,0,0,0);
			}
		Goto See;
	Att15:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",60,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",60,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",120,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,-32,0,0,0);
			}
		Goto See;
	Att16:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",120,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",60,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",60,-32,0,0,0);
			}
		Goto See;
	Att17:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",120,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",90,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",60,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",60,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",90,32,0,0,0); }
		DIAB F 10 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",120,-32,0,0,0); }
		Goto See;
	Att18:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",120,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",90,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",60,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",60,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",90,-32,0,0,0); }
		DIAB F 10 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",120,32,0,0,0); }
		Goto See;
	Att19:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			}
		Goto See;
	Att20:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright
			{
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",90,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			}
		DIAB F 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("DemonMeteor",60,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,-32,0,0,0);
			}
		Goto See;
	Att21:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright
			{
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			A_SpawnProjectile("LavaBall",90,-32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			}
		DIAB F 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_SpawnProjectile("DemonMeteor",60,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,32,0,0,0);
			}
		Goto See;
	Att22:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",60,32,0,0,0);
			A_SpawnProjectile("LavaBall",60,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",90,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",90,-32,0,0,0);
			}
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",120,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",120,-32,0,0,0);
			}
		Goto See;
	Att23:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",120,32,0,0,0);
			A_SpawnProjectile("LavaBall",120,-32,0,0,0);
			}
		
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("LavaBall",90,32,0,0,0);
			A_SpawnProjectile("LavaBall",90,-32,0,0,0);
			}
		
		DIAB F 10 Bright
			{
			A_FaceTarget();
			A_SpawnProjectile("DemonMeteor",60,32,0,0,0);
			A_SpawnProjectile("DemonMeteor",60,-32,0,0,0);
			}
		Goto See;
	Att24:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",120,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",90,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",60,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",60,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",90,32,0,0,0); }
		DIAB F 10 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",120,-32,0,0,0); }
		Goto See;
	Att25:
		DIAB E 2 Bright A_FaceTarget();
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",120,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",90,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("LavaBall",60,-32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",60,32,0,0,0); }
		DIAB F 8 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",90,-32,0,0,0); }
		DIAB F 10 Bright { A_FaceTarget(); A_SpawnProjectile("DemonMeteor",120,32,0,0,0); }
		Goto See;
	Pain:
		DIAB A 0 A_Pain();
		Goto See;
	Death:
		DIAB J 5;
		DIAB K 5 A_FaceTarget();
		DIAB L 5 A_Scream();
		DIAB MNOPQ 5;
		DIAB R 10 A_NoBlocking();
		DIAB S 5 A_QuakeEx(10,10,10,200,0,1024,"world/quake",QF_SCALEUP|QF_SCALEDOWN);
		DIAB TUV 5;
		TNT1 A 0 A_SpawnProjectile("SmithDFSpawner",0,16,0,0);
		TNT1 A 0 A_SpawnItemEx("LargeGlyphExplosion1");
		DIAB WWWWWWWWWWW 5
			{
			for(int repeats = 0; repeats < 10; repeats+=1)
				{ A_SpawnItemEx("ApocalypseMeteor",Random(-5,5),Random(-5,5),Random(2,10),Random(-5,5),Random(-5,5),Random(2,20),Random(0,359),SXF_CLIENTSIDE); }
			}
		DIAB W 150;
		DIAB WWW 25 A_SpawnProjectile("FinaleMeteor",0,0,0,2);
		DIAB W 1 A_SpawnProjectile("SmithDFSpawner2",0,16,0,0);
		TNT1 A 1;
		Stop;
	}
}

class InfernoSFXSpawnBase : Actor
{
	/*will probably add an option to spawn particles/Visualthinkers here someday
	also it broke my heart knowing that making for/while loops here is useless
	if a parameter is random*/
	void HP_SpawnFireSpark(double xoffs = 0.0, double yoffs = 0.0, double zoffs = 0.0, double xvel = 0.0, double yvel = 0.0, double zvel = 0.0, double angl = 0.0)
	{
		A_SpawnItemEx("FireSpark",xoffs,yoffs,zoffs,xvel,yvel,zvel,angl,SXF_CLIENTSIDE|SXF_TRANSFERPOINTERS);
	}
	void HP_SpawnBoulder(double xoffs = 0.0, double yoffs = 0.0, double zoffs = 1.0, double xvel = 0.0, double yvel = 0.0, double zvel = 1.0, double angl = 0.0)
	{
		A_SpawnItemEx("BoulderSmall",xoffs,yoffs,zoffs,xvel,yvel,zvel,angl,SXF_CLIENTSIDE|SXF_TRANSFERPOINTERS);
	}
	void HP_SpawnParticleFloat(double xoffs = 0.0, double yoffs = 0.0, double zoffs = 0.0, double xvel = 0.0, double yvel = 0.0, double zvel = 0.0, double angl = 0.0)
	{
		A_SpawnItemEx("FireParticleFloat",xoffs,yoffs,zoffs,xvel,yvel,zvel,angl,SXF_CLIENTSIDE|SXF_TRANSFERPOINTERS);
	}
}

class FireParticleFloat : Actor
{
Default
	{
	+NoInteraction
	+ForceXYBillboard
	RenderStyle "Add";
	Scale 0.125;
	}
States
	{
	Spawn:
		ORPA A 10 Bright;
		ORPA A 1 Bright A_FadeOut(0.1);
		Wait;
	}
}

class FireSpark : Actor
{
Default
	{
	Projectile;
	Radius 1;
	Height 1;
	Scale 0.1;
	Gravity 0.5;
	RenderStyle "Add";
	+ForceXYBillboard
	-NoGravity
	+DontSplash
	+THRUACTORS
	//+NOCLIP
	-ACTIVATEIMPACT
	-ACTIVATEPCROSS
	}
States
	{
	Spawn:
		ORPA A 10 Bright;
		ORPA A 1 Bright A_FadeOut();
		Wait;
	Death:
		TNT1 A 1;
		Stop;
	}
}

class BoulderSmall : Actor
{
Default
	{
	Projectile;
	Radius 6;
	Height 6;
	Speed 20;
	VSpeed 3;
	Scale 0.2;
	Bouncetype "Doom";
	BounceCount 6;
	-NOGRAVITY
	+CANBOUNCEWATER
	+BOUNCEONACTORS
	-ACTIVATEIMPACT
	-ACTIVATEPCROSS
	+DontSplash
	}
States
	{
	Spawn:
		SE01 ABCDEFGH 3;
		Loop;
	Death:
		SE01 H 100;
		SE01 H 5 A_Fadeout();
		Wait;
	}
}

class SmithDFSpawner : Actor
{
Default
	{
	Projectile;
	Radius 1;
	Height 2;
	Speed 0;
	Damage 0;
	ReactionTime 150;
	+NOEXPLODEFLOOR
	+DONTBLAST
	}
States
	{
	Spawn:
		TNT1 A 1 Nodelay A_SpawnItemEx("SmithDeathFire",random(-3,3),random(-3,3),0,0,0,16,0,SXF_TRANSFERPOINTERS);
		TNT1 A 0 A_CountDown();
		Loop;
	Death:
		TNT1 A 1;
		Stop;
	}
}

class SmithDFSpawner2 : SmithDFSpawner { Default { ReactionTime 10; } }
class SmithDFSpawner3 : SmithDFSpawner
{
Default
	{
	Radius 4;
	Height 64;
	ReactionTime 40;
	+DontSplash
	}
States
	{
	Spawn:
		TNT1 A 0 Nodelay A_StartSound("harvester/ghost");
		TNT1 A 1 { A_RadiusThrust(600,256,RTF_NOIMPACTDAMAGE); A_SpawnItemEx("SmithDeathFire",random(-3,3),random(-3,3),0,0,0,16,0,SXF_TRANSFERPOINTERS); }
		TNT1 A 0 A_CountDown();
		goto Spawn+1;
	Death:
		TNT1 AAAAA 1 A_SpawnItemEx("SmithDeathFire",random(-3,3),random(-3,3),0,0,0,16,0,SXF_TRANSFERPOINTERS);
		Stop;
	}
}

class SmithDeathFire : Actor
{
Default
	{
	RenderStyle "Add";
	Alpha 0.67;
	Scale 2.0;
	+NOINTERACTION
	+ForceXYBillboard
	}
States
	{
	Spawn:
		FRFX JKLMNOP 2 Bright;
		Stop;
	}
}

class DemonMeteorTail : Actor
{
Default
	{
	RenderStyle "Add";
	Alpha 0.4;
	+NOINTERACTION
	+ForceXYBillboard
	}
States
	{
	Spawn:
		AF03 ABCDEFGHI 1 Bright;
		Stop;
	}
}

class DemonMeteor : InfernoSFXSpawnBase
{
Default
	{
	Projectile;
	Radius 6;
	Height 8;
	Speed 15;
	Damage 6;
	Scale .55;
	DamageType "Inferno";
	SeeSound "Apocalypse/Meteor";
	DeathSound "Apocalypse/Death";
	Decal "BaronScorch";
	+ForceXYBillboard
	}
States
	{
	Spawn:
		AF02 AAAABBBBCCCC 1 Bright A_SpawnItemEx("DemonMeteorTail",0,0,0,0,0,0,0,SXF_TRANSFERPOINTERS);
		Loop;
	Death:
		AF02 E 4 Bright
		{
			for(int times1 = 16; times1 > 0; times1--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,10));
			}
			for(int times2 = 8; times2 > 0; times2--)
			{
				HP_SpawnBoulder(random(-5,5),random(-5,5),random(1,10),random(-5,5),random(-5,5),random(2,10));
			}
		}
		AF02 FGHI 4 Bright;
		Stop;
	}
}

class MeteorBolt : FastProjectile
{
Default
	{
	Radius 8;
	Height 8;
	Speed 500;
	Damage 0;
	+SKYEXPLODE
	+DONTBLAST
	}
States
	{
	Spawn:
		TNT1 A 2;
		Loop;
	Death:
		TNT1 A 35
		{
			A_SpawnProjectile("FireGlyphLine",0,0,0,2);
			A_SpawnProjectile("FireGlyphLine",0,0,135,2);
			A_SpawnProjectile("FireGlyphLine",0,0,-135,2);
			A_SpawnProjectile("FireGlyphLine2",0,0,0,2);
			A_SpawnProjectile("FireGlyphLine2",0,0,135,2);
			A_SpawnProjectile("FireGlyphLine2",0,0,-135,2);
		}
		TNT1 A 6 A_SpawnProjectile("FinaleMeteor",0,0,0,2);
		Stop;
	}
}

class ApocalypseMeteor : InfernoSFXSpawnBase
{
Default
	{
	Projectile;
	Radius 2;
	Height 2;
	Damage 8;
	DamageType "Inferno";
	Speed 1;
	SeeSound "Apocalypse/Meteor";
	DeathSound "Apocalypse/Death";
	-NOGRAVITY
	-FLOAT
	+FLOORCLIP
	+SPAWNCEILING
	+ForceXYBillboard
	}
States
	{
	Spawn:
		AF02 AABBCC 1 Bright A_SpawnItemEx("MeteorTrail",0,0,0,0,0,0,0,SXF_CLIENTSIDE);
		Loop;
	Death:
		AF02 D 4 Bright
		{
			A_Explode(16,64,0);
			for(int times1 = 16; times1 > 0; times1--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,10));
			}
			for(int times2 = 8; times2 > 0; times2--)
			{
				HP_SpawnBoulder(random(-5,5),random(-5,5),random(1,10),random(-5,5),random(-5,5),random(2,10));
			}
		}
		AF02 EFGHI 4 Bright;
		Stop;
	}
}

class ApocalypseFinaleMeteor : ApocalypseMeteor
{
Default
	{
	Damage 16;
	Scale 2.5;
	DamageType "Inferno";
	SeeSound "weapons/firbfi";
	DeathSound "weapons/hellex";
	+DONTTHRUST
	+ForceXYBillboard
	}
States
	{
	Spawn:
		G001 AABBCC 1 Bright A_SpawnItemEx("MeteorFinaleTrail",0,0,0,0,0,0,0,SXF_CLIENTSIDE);
		Loop;
	Death:
		G001 J 4 Bright
		{
			for(int repeats = 0; repeats < 19; repeats++)
				{ A_SpawnItemEx("ApocalypseMeteor",Random(-5,5),Random(-5,5),Random(2,10),Random(-5,5),Random(-5,5),Random(2,20),Random(0,359),SXF_CLIENTSIDE|SXF_TRANSFERPOINTERS); }
			A_Explode(32,128,0);
			for(int times = 32; times > 0; times--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,20));
			}
			A_SetRenderStyle(1.0,STYLE_Add);
		}
		G001 KLMN 2 Bright A_Fadeout(0.2);
		Stop;
	}
}

class MeteorFinaleTrail : Actor
{
Default
	{
	RenderStyle "Add";
	Alpha 0.4;
	Scale 2.5;
	+NOINTERACTION
	+ForceXYBillboard
	}
States
	{
	Spawn:
		G001 DEFGHI 1 Bright;
		Stop;
	}
}

class MeteorTrail : Actor
{
Default
	{
	RenderStyle "Add";
	Alpha 0.4;
	+NOINTERACTION;
	+ForceXYBillboard
	}
States
	{
	Spawn:
		AF03 ABCDEFGHI 1 Bright;
		Stop;
	}
}

class FinaleMeteor : Actor
{
Default
	{
	Projectile;
	Radius 0;
	Height 0;
	Speed 0;
	SeeSound "weapons/diasht";
	+CEILINGHUGGER
	+NOCLIP
	}
States
	{
	Spawn:
		TNT1 A 3;
		TNT1 A 3 A_SpawnProjectile("ApocalypseFinaleMeteor",-16,0,0,0,0);
		Stop;
	}
}

class FireGlyphLine : Actor
{
Default
	{
	Projectile;
	Radius 0;
	Height 32;
	Speed 16;
	SeeSound "weapons/diasht";
	+CEILINGHUGGER
	+NOCLIP
	+DONTBLAST
	}
States
	{
	Spawn:
		TNT1 A 3;
		TNT1 AAAAAAAAAA 3 A_SpawnProjectile("ApocalypseMeteor",-16,0,0,0,0);
		Stop;
	}
}

class FireGlyphLine2 : FireGlyphLine
{
States
	{
	Spawn:
		TNT1 A 3;
		TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAA 1 A_SpawnItemEx("StayFire",0,0,0,0,0,0,0,SXF_CLIENTSIDE);
		Stop;
	}
}

class StayFire : Actor
{
Default
	{
	Scale 0.8;
	Speed 6;
	Renderstyle "Add";
	Alpha 0.67;
	ReactionTime 3;
	+MISSILE
	+THRUACTORS
	+DROPOFF
	+RANDOMIZE
	+CANBOUNCEWATER
	+DONTSPLASH
	+FLOORHUGGER
	}
States
	{
	Spawn:
		TNT1 A 0;
		FRTF ABCDEFGHIJK 3 Bright;
		TNT1 A 0 A_Countdown();
		Goto Spawn+4;
	Death:
		FRTF LMNO 3 Bright;
		Stop;
	}
}

class FirePuff : Actor
{
Default
	{
	Scale 3.0;
	Renderstyle "Add";
	Alpha 0.67;
	+NOINTERACTION
	+ForceXYBillboard
	}
States
	{
	Spawn:
		DFFP ABCDEFGHIJKLMNOPQR 1 Bright;
		Stop;
	}
}

class InfernoBomb : InfernoSFXSpawnBase
{
int rad1; int rad2;
Default
	{
	Projectile;
	Radius 8;
	Height 8;
	Speed 15;
	Damage 0;
	DamageType "Inferno";
	Renderstyle "Add";
	Alpha 0.95;
	SeeSound "weapons/justfi";
	DeathSound "weapons/firex3";
	ReactionTime 7;
	+THRUACTORS
	+DONTBLAST
	+ForceXYBillboard
	}
States
	{
	Spawn:
		TNT1 A 0 Nodelay { rad1 = 48; rad2 = 52; A_AttachLight("ChargeLight",DynamicLight.FlickerLight,"orange",rad1,rad2,DYNAMICLIGHT.LF_ATTENUATE,(0,0,0),0.8); }
		SBLL ABCDEFGHIJ 2 Bright
		{
			A_SpawnItem("BombTrail",0,0);
			for(int times1 = 8; times1 > 0; times1--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,20));
			}
			for(int times2 = 4; times2 > 0; times2--)
			{
				HP_SpawnParticleFloat(random(-5,5),random(-5,5),random(-5,5),random(-1,1),random(-1, 1),random(2,4));
			}
		}
	ChargeBall:
		TNT1 A 0 { bFLOATBOB = true; A_ChangeVelocity(0,0,0,CVF_REPLACE); }
		TNT1 A 0 { A_StartSound("monster/bomb"); A_AttachLight("ChargeLight",DynamicLight.FlickerLight,"orange",rad1,rad2,DYNAMICLIGHT.LF_ATTENUATE,(0,0,0),0.8); }
		SBLL ABCDE 2 bright
		{
			for(int times1 = 8; times1 > 0; times1--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,20));
			}
			for(int times2 = 4; times2 > 0; times2--)
			{
				HP_SpawnParticleFloat(random(-5,5),random(-5,5),random(-5,5),random(-1,1),random(-1, 1),random(2,4));
			}
		}
		TNT1 A 0 { A_SetScale(scale.X+0.1,scale.Y+0.1); A_CountDown(); rad1+=10; rad2+=10; }
		TNT1 A 0 { A_StartSound("monster/bomb"); A_AttachLight("ChargeLight",DynamicLight.FlickerLight,"orange",rad1,rad2,DYNAMICLIGHT.LF_ATTENUATE,(0,0,0),0.8); }
		SBLL FGHIJ 2 bright
		{
			for(int times1 = 8; times1 > 0; times1--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,20));
			}
			for(int times2 = 4; times2 > 0; times2--)
			{
				HP_SpawnParticleFloat(random(-5,5),random(-5,5),random(-5,5),random(-1,1),random(-1, 1),random(2,4));
			}
		}
		TNT1 A 0 { A_SetScale(scale.X+0.1,scale.Y+0.1); A_CountDown(); rad1+=10; rad2+=10; }
		Goto ChargeBall+1;
	Death:
		SBLL K 2 Bright
		{
			for(double angl; angl < 350; angl+=15)
				{
				A_SpawnProjectile("LavaBall",0,16,angl,2,-15);
				A_SpawnProjectile("LavaBall",0,16,angl,2,-10);
				A_SpawnProjectile("LavaBall",0,16,angl,2,-5);
				A_SpawnProjectile("LavaBall",0,16,angl,2,0);
				A_SpawnProjectile("LavaBall",0,16,angl,2,5);
				A_SpawnProjectile("LavaBall",0,16,angl,2,10);
				A_SpawnProjectile("LavaBall",0,16,angl,2,15);
				}
			for(int times = 40; times > 0; times--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,20));
			}
			bFLOATBOB = false; A_RemoveLight("ChargeLight");
		}
		SBLL LMNOPQRSTUVW 2 Bright;
		Stop;
	}
}

class BombTrail : Actor
{
Default
	{
	+NOINTERACTION
	+ForceXYBillboard
	RenderStyle "Add";
	Scale 0.8;
	}
States
	{
	Spawn:
		SBLL ABCDEF 1 Bright;
		SBLL GHIJABCDE 1 Bright A_FadeOut(0.08);
		Stop;
	}
}

class Lavaball : InfernoSFXSpawnBase
{
Default
	{
	Projectile;
	Radius 8;
	Height 8;
	Speed 15;
	Damage 6;
	DamageType "Inferno";
	Obituary "%o was sent to burn in the fires of hell for an eternity.";
	Renderstyle "Add";
	Alpha 0.95;
	//+THRUGHOST
	+ForceXYBillboard
	SeeSound "weapons/firmfi";
	DeathSound "weapons/firex3";
	Decal "DoomImpScorch";
	}
States
	{
	Spawn: 
		VFBL AB 4 Bright A_SpawnItemEx("RedPuff",0,0,0);
		Loop;
	Death:
		BAL3 C 5 Bright
		{
			A_Explode(32,96);
			for(int times = 8; times > 0; times--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,10),random(-5,5),random(-5,5),random(0,20));
			}
		}
		BAL3 DE 5 Bright;
		Stop;
	}
}

class FireBeam : Actor
{
Default
	{
	Projectile;
	Height 10;
	Radius 10;
	DamageType "Inferno";
	Obituary "%o was sent to burn in the fires of hell for an eternity.";
	Renderstyle "Add";
	Speed 12;
	Scale 0.5;
	Alpha 0.75;
	Damage 5;
	ReactionTime 50;
	ActiveSound "monster/firebeamstart";
	Decal "BaronScorch";
	+DROPOFF
	-NOGRAVITY
	+FLOORHUGGER
	+EXTREMEDEATH
	+DONTSPLASH
	+RIPPER
	+BLOODLESSIMPACT
	}
States
	{
	Spawn:
		HK04 ABC 1 bright A_SpawnProjectile("BeamFire",0,0,0,4);
		TNT1 A 0 A_CountDown();
		TNT1 A 0 A_LoopActiveSound();
		Loop;
	Death:
		HK05 ABCDE 2 bright;
		Stop;
	}
}

class BeamFire : Actor
{
Default
	{
	Scale 0.5;
	DamageType "Inferno";
	Renderstyle "Add";
	Obituary "%o was sent to burn in the fires of hell for an eternity.";
	+DONTSPLASH
	+EXTREMEDEATH
	+NOINTERACTION
	}
States
	{
	Spawn:
		TNT1 A 5;
		FRTF ABCDEFGHIJKLMNO 3 bright A_Explode(1,8);
		Stop;
	}
}

class FireGlyphLineSpawner1 : FastProjectile
{
Default
	{
	Radius 2;
	Height 32;
	Speed 500;
	SeeSound "weapons/diasht";
	//+THRUACTORS
	+DONTBLAST
	}
States
	{
	Spawn:
		TNT1 A 1;
		Loop;
	Death:
		TNT1 A 0 
			{
			A_SpawnItemEx("StayFire",0,0,0,4,0,0,0);
			A_SpawnItemEx("StayFire",0,0,0,-4,0,0,0);
			A_SpawnItemEx("StayFire",0,0,0,0,4,0,0);
			A_SpawnItemEx("StayFire",0,0,0,0,-4,0,0);
			}
		TNT1 A 35 A_StartSound("Glyph/Start");
		TNT1 A 0
			{
			A_SpawnProjectile("FireGlyphLine10",0,0,0,2);
			A_SpawnProjectile("FireGlyphLine10",0,0,135,2);
			A_SpawnProjectile("FireGlyphLine10",0,0,-135,2);
			A_SpawnItemEx("LargeGlyphExplosion1",0,0,0,0,0,0,0,SXF_TRANSFERPOINTERS);
			A_SpawnItemEx("FireSpiral",20,20,40,0,0,0,0,SXF_TRANSFERPOINTERS);
			}
		Stop;
	}
}

class FireGlyphLine10 : Actor
{
Default
	{
	Projectile;
	Radius 2;
	Height 32;
	Speed 16;
	+FLOORHUGGER
	+THRUACTORS
	+DONTBLAST
	}
States
	{
	Spawn:
		TNT1 AAAAAAAAAAAAAAAA 1 A_SpawnItemEx("StayFire",0,0,0,0,0,0,0,SXF_CLIENTSIDE);
		TNT1 A 0 A_ChangeVelocity(-16,20,0,CVF_RELATIVE|CVF_REPLACE);
		TNT1 AAAAAAAAAAAAAAAA 1 A_SpawnItemEx("StayFire",0,0,0,0,0,0,0,SXF_CLIENTSIDE);
		TNT1 A 1 A_SpawnItem("GlyphExplosion1",0,0,0);
		Stop;
	}
}

class GlyphExplosion1 : InfernoSFXSpawnBase
{
Default
	{
	Radius 8;
	Height 56;
	Scale 0.5;
	DamageType "Inferno";
	+NOGRAVITY
	}
States
	{
	Spawn:
		NKXP A 3 Bright;
		NKXP B 3 Bright A_StartSound("pyro/explosion");
		NKXP C 3 Bright A_Explode(50,128,1);
		NKXP D 3 Bright
		{
		for(int times = 64; times > 0; times--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,32),random(-5,5),random(-5,5),random(0,20));
			}
		}
		NKXP EFGHIJKLMNOPQRSTU 3 Bright;
		Stop;
    }
}

class LargeGlyphExplosion1 : GlyphExplosion1
{
Default
	{ Scale 1.0; }
States
	{
	Spawn:
		NKXP A 3 Bright;
		NKXP B 3 Bright A_StartSound("pyro/explosion");
		NKXP C 3 Bright A_Explode(100,256,1);
		NKXP D 3 Bright 
		{
		for(int times = 128; times > 0; times--)
			{
				HP_SpawnFireSpark(random(-5,5),random(-5,5),random(0,96),random(-5,5),random(-5,5),random(0,20));
			}
		}
		NKXP EFGHIJKLMNOPQRSTU 3 Bright;
		Stop;
	}
}

class FireSpiral : Actor
{
Default
	{
	+NOINTERACTION
	+DONTBLAST
	ReactionTime 60;
	}
States
	{
	Spawn:
		TNT1 A 2 NoDelay { A_SetAngle(angle+15); A_ChangeVelocity(3,3,3,CVF_RELATIVE|CVF_REPLACE); A_SpawnItemEx("SpiralFire1",0,0,0); }
		TNT1 A 0 A_CountDown();
		Loop;
	Death:
		TNT1 A 1;
		Stop;
	}
}

class SpiralFire1 : Actor
{
Default
	{
	+NOINTERACTION
	Renderstyle "Add";
	Alpha 0.85;
	}
States
	{
	Spawn:
		RI01 ABCDEFGHIJKLMABCDEFGHIJKLMNOP 2 bright;
		Stop;
	}
}
