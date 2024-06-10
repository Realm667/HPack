////////////////////////////
// SPARKLE SPAWNERS ////////
// for REALM667     ////////
// by Tormentor667  ////////
////////////////////////////
//Zscript conversion by Gothic


///////////////////////////////// HERETIC VARIANT /////////////////////////////////////////////

class GreenStarSpawner : Actor
{
bool activated;
TextureID sprkltex;  string trnstable;
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Star Spawner (Green)
	//$NotAngled

	//$Arg1 Area Radius
	//$Arg1Type 0

	//$Arg2 Fail Chance
	//$Arg2Type 0
	+NOINTERACTION
	+CLIENTSIDEONLY
	}
	override void BeginPlay()
	{
		if(!bDORMANT) Activate(self);
		Super.BeginPlay();
	}
	override void Activate(Actor activator)
	{
		activated = true;
	}
	override void Deactivate(Actor activator)
	{
		activated = false;
	}
	override void Tick()
	{
		if(!isFrozen() && activated)
		{
			if(hpack_particlemethod)
			{
				if(random(1,256) <= Args[2]) return;
				sprkltex = TexMan.CheckForTexture("SKFXA0");
				let p = Level.SpawnVisualThinker("StarSprite");
				if (p)
				{
					p.texture = sprkltex;
					p.pos = pos+(random(-Args[1],Args[1]),random(-Args[1],Args[1]),random(0,2*Args[1]));
					//p.flags = SPF_FULLBRIGHT;
					p.alpha = 1.0;
					p.scale = (0.1,0.1);
					p.SetRenderStyle(STYLE_Add);
					p.LightLevel = 255;
					p.bAddLightLevel;
					p.SetTranslation(trnstable);
				}
			}
			else if(!hpack_particlemethod)
			{
				A_SpawnItemEx("BaseStar2",
						random(-Args[1],Args[1]),	// X offset
						random(-Args[1],Args[1]),	// Y offset
						random(0,2*Args[1]),		// Z offset
						0,0,0,						// X/Y/Z velocities
						0,							// Angle
						SXF_TRANSFERTRANSLATION|SXF_CLIENTSIDE,
						Args[2]);					// Fail chance
			}
		}
		super.Tick();
	}
}

class BlueStarSpawner : GreenStarSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Star Spawner (Blue)
	Translation "209:224=185:200";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "BlueStSpwn";
	}
}

class WhiteStarSpawner : GreenStarSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Star Spawner (White)
	Translation "209:224=1:35","208:208=35:35";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "WhiteStSpwn";
	}
}

class RedStarSpawner : GreenStarSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Star Spawner (Red)
	Translation "209:224=145:159";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "RedStSpwn";
	}
}

class OrangeStarSpawner: GreenStarSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Star Spawner (Orange)
	Translation "209:224=112:127";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "OrangeStSpwn";
	}
}

class PurpleStarSpawner: GreenStarSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Star Spawner (Purple)
	Translation "209:224=169:176";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "PurpleStSpwn";
	}
}

class BaseStar2 : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	Alpha 1.0;
	Scale 0.1;
	}
	States
	{
	Spawn:
		SKFX A 1 Bright Nodelay A_FadeOut(0.1);
		SKFX A 1 Bright A_SetScale(scale.x+0.05);
		Loop;
	}
}

class StarSprite : VisualThinker
{
	override void Tick()
	{
		if (bDESTROYED || IsFrozen()) return;
		Super.Tick();
		Alpha-= 0.05;
		Scale+= (0.025,0.025);
		if (Alpha <= 0.0) Destroy();
	}
}

// special window-go-poof effect used in H2M4.
// no doomednum; it's spawned with a script.

class WindowPoof64 : Actor
{
Default
	{
	+NOINTERACTION
	+CLIENTSIDEONLY
	Translation "209:224=0:35";
	}
	States
	{
	Spawn:
		TNT1 A 5;
		TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 A_SpawnItemEx(
			/*actor*/  "BaseStar2",
			/*xofs*/   0,
			/*yofs*/   frandom(-32.0, 32.0),
			/*zofs*/   frandom(8.0, ceilingz-floorz-8.0),
			/*xvel*/   0,
			/*yvel*/   0,
			/*zvel*/   0,
			/*angle*/  0,
			/*flags*/  SXF_TRANSFERTRANSLATION | SXF_CLIENTSIDE);
		Stop;
	}
}
