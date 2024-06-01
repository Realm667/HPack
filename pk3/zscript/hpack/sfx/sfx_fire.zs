//  Fire SFX
//    - Original code by Solarsnowfall, Tormentor667 and Ghastly.
//    - Code clean-up for HPack by Blue Shadow.
//    - Zscript rewrite by Gothic.

class FireSpawner : Actor
{
enum FSArgs { ARG_SIZE, ARG_SOUND }
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Fire
	//$Sprite FLM1A0

	//$NotAngled

	//$Arg0 Size
	//$Arg0Type 11
	//$Arg0Enum { 0 = "Small"; 1 = "Medium"; 2 = "Large"; }

	//$Arg1 Sound
	//$Arg1Type 11
	//$Arg1Enum { 0 = "Yes"; 1 = "No"; }
	Height 40;
	Radius 30;
	+CLIENTSIDEONLY
	+NOINTERACTION
	}
	bool ignited;
	bool frstticbullsh; bool onsoundplayed; bool offsoundplayed;
	override void BeginPlay()
	{
		if(!bDORMANT) Activate(self);
		Super.BeginPlay();
	}
	override void Activate(Actor activator)
	{
		if(frstticbullsh && !onsoundplayed && Args[ARG_SOUND] == 0) A_StartSound("SFX/FireStart",7,0,1.0);
		ignited = true;
		onsoundplayed = true; offsoundplayed = false;
	}
	override void Deactivate(Actor activator)
	{
		if(frstticbullsh && !offsoundplayed && Args[ARG_SOUND] == 0) A_StartSound("SFX/FireDie",8,0,1.0);
		A_RemoveLight("FireLight"); A_StopSound(6);
		ignited = false;
		frstticbullsh = true; onsoundplayed = false; offsoundplayed = true;
	}
	override void Tick()
	{
		frstticbullsh = true;
		if(ignited)
		{
			if(Args[ARG_SIZE] == 0)//Small
			{
				A_AttachLightDef("FireLight","FireSpawnerSmall"); A_GiveInventory("HPSpawnSmallFire");
				if(Args[ARG_SOUND] == 0) A_StartSound("SFX/FireLoop1",6,CHANF_LOOPING,1.0);
			}
			else if(Args[ARG_SIZE] == 1)//Medium
			{
				A_AttachLightDef("FireLight","FireSpawnerMedium"); A_GiveInventory("HPSpawnMediumFire");
				if(Args[ARG_SOUND] == 0) A_StartSound("SFX/FireLoop2",6,CHANF_LOOPING,1.0);
			}
			else if(Args[ARG_SIZE] == 2)//Large
			{
				A_AttachLightDef("FireLight","FireSpawnerLarge"); A_GiveInventory("HPSpawnLargeFire");
				if(Args[ARG_SOUND] == 0) A_StartSound("SFX/FireLoop3",6,CHANF_LOOPING,1.0);
			}
		}
	super.Tick();
	}
}

class HPSpawnSmallFire : CustomInventory
{
static const string textp[] = { "FLM1A0","FLM3A0","FLM5A0" };
TextureID firtex; TextureID embtex;
vector2 FireScale;
int FireSpeedX; int FireSpeedY; int FireSpeedZ;
int EmberPosX; int EmberPosY; int EmberPosZ; int EmberVelZ;
override void BeginPlay()
	{
		Super.BeginPlay();
		FireSpeedX = frandom(-1.5,1.5); FireSpeedY = frandom(-1.5,1.5); FireSpeedZ = frandom(1,3);
		FireScale = (0.35,0.35);
		EmberPosX = 0; EmberPosY = 0; EmberPosZ = 0; EmberVelZ = frandom(1,4);
	}
override bool TryPickup(in out Actor toucher)
	{
	if(toucher)
		{
		if(hpack_particlemethod)
			{
			int spwnember = random(0,6);
			firtex = TexMan.CheckForTexture(textp[random(0,2)]);
			embtex = TexMan.CheckForTexture("EMBRA0");
			let p = Level.SpawnVisualThinker("FireSprite");
			if (p)
				{
				p.texture = firtex;
				p.pos = toucher.pos+(frandom(-0.6,0.6),frandom(-0.6,0.6),0);
				p.vel = (FireSpeedX,FireSpeedY,FireSpeedZ);
				p.flags = SPF_ROLL;//|SPF_FULLBRIGHT
				p.roll = random(0,359);
				p.alpha = 0.8;
				p.scale = FireScale;
				p.SetRenderStyle(STYLE_Add);
				p.LightLevel = 255;
				p.bAddLightLevel;
				p.bXflip = random(0,1);
				p.bYflip = random(0,1);
				}
			if(spwnember == 6)
				{
				let q = Level.SpawnVisualThinker("EmberSprite");
				if (q)
					{
					q.texture = embtex;
					q.pos = toucher.pos+(EmberPosX,EmberPosY,EmberPosZ);
					q.vel = (frandom(-1,1),frandom(-1,1),EmberVelZ);
					//q.flags = SPF_FULLBRIGHT;
					q.alpha = 0.8;
					q.scale = (0.1,0.1);
					q.SetRenderStyle(STYLE_Add);
					q.LightLevel = 255;
					q.bAddLightLevel;
					}
				}
			}
		else if(!hpack_particlemethod)
			{
			actor flame = spawn("FlameActor",toucher.pos+(frandom(-0.6,0.6),frandom(-0.6,0.6),0));
			if(flame)
				{
				flame.vel = (FireSpeedX,FireSpeedY,FireSpeedZ);
				flame.scale = FireScale;
				}
			A_SpawnItemEx("EmberActor",toucher.pos.x+EmberPosX,-toucher.pos.y+EmberPosY,toucher.pos.z+EmberPosZ,frandom(-1,1),frandom(-1,1),EmberVelZ,0,SXF_CLIENTSIDE,213);
			}
		}
	return false;
	}
override void Tick()
	{
		super.Tick();
		Destroy();
	}
}

class HPSpawnMediumFire : HPSpawnSmallFire
{
override void BeginPlay()
	{
		Super.BeginPlay();
		FireSpeedX = frandom(-2.5,2.5); FireSpeedY = frandom(-2.5,2.5); FireSpeedZ = frandom(2,4.5);
		FireScale = (0.65,0.65);
		EmberPosX = frandom(-1,1); EmberPosY = frandom(-1,1); EmberPosZ = 10; EmberVelZ = frandom(1.5,6);
	}
}

class HPSpawnLargeFire : HPSpawnSmallFire
{
override void BeginPlay()
	{
		Super.BeginPlay();
		FireSpeedX = frandom(-4.5,4.5); FireSpeedY = frandom(-4.5,4.5); FireSpeedZ = frandom(5.5,7);
		FireScale = (1.2,1.2);
		EmberPosX = frandom(-6,6); EmberPosY = frandom(-6,6); EmberPosZ = 60; EmberVelZ = frandom(2,8);
	}
}

class FireSprite : VisualThinker
{
	double RollVel;
	int ctr;
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		RollVel = randompick(-20.0,20.0);
	}
	override void Tick()
	{
		if (bDESTROYED || IsFrozen())
			return;
		Super.Tick();
		ctr++;
		Roll+= RollVel;
		Scale/= 1.035;
		if(ctr > 10)
		{
			Alpha-= 0.08;
			Scale/= 1.07;
			if (Alpha <= 0.0)
				Destroy();
		}
	}
}

class EmberSprite : VisualThinker
{
	int ctr;
	override void Tick()
	{
		if (bDESTROYED || IsFrozen())
			return;
		Super.Tick();
		ctr++;
		if(ctr > 32)
		{
			Alpha-= 0.03;
			if (Alpha <= 0.0)
				Destroy();
		}
	}
}

class HPFlameBase : Actor
{
Default
	{
	Alpha 0.8;
	RenderStyle "Add";
	+BRIGHT
	+FORCEXYBILLBOARD
	+NOINTERACTION
	+CLIENTSIDEONLY
	}
States
	{
	ToAvoidCrashes:
		FLM1 A 0;
        FLM2 A 0;
		FLM3 A 0;
		FLM4 A 0;
		FLM5 A 0;
		FLM6 A 0;
		FIR1 A 0;
		FIR2 A 0;
		2FIR A 0;
        Stop;
    }
}

class FlameActor : HPFlameBase
{
static const string firsprt[] = { "FLM1","FLM2","FLM3","FLM4","FLM5","FLM6" };
override void BeginPlay() 
	{
		super.BeginPlay();
		sprite = GetSpriteIndex(firsprt[random(0,5)]);
	}
States
    {
	Spawn:
		"####" ABCDE 2;
		"####" FFGGHHIIJJKKLL 1 A_FadeOut(0.08);
		Stop;
	}
}

class EmberActor : HPFlameBase
{
Default
	{
	Scale 0.1;
	}
States
	{
	Spawn:
		EMBR A 32;
        EMBR A 2 A_FadeOut();
        Wait;
    }
}