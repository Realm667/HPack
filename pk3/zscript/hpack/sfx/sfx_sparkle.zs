/////////////////////////////
// SPARKLE FOUNTAINS ////////
// for UTNT          ////////
// by Tormentor667   ////////
/////////////////////////////
//Zscript conversion by Gothic

class WhiteSparkleSpawner : Actor
{
bool activated;
double YOffsets; double ZVelocity; int SpwnrAngle;
vector2 sprkangle; vector3 sprkcoord; TextureID sprkltex;  string trnstable; 
static const string SparkleActor[] = { "BaseStar","BaseStarAccel" };
static const string SparkleThinker[] = { "SparkleSprite","SparkleAccelSprite" };
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (White)
	//$NotAngled
	
	//$Arg0 Radius
	//$Arg0Type 0

	//$Arg1 Type of Area
	//$Arg1Type 11
	//$Arg1Enum { 0 = "Square"; 1 = "Circle"; }

	//$Arg2 Vertical Spread
	//$Arg2Type 0

	//$Arg3 Speed Variable
	//$Arg3Type 11
	//$Arg3Enum { 0 = "Constant"; 1 = "Acceleration"; }

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
		sprkangle = vec2angle(random(-Args[0],Args[0]),angle);
		if(Args[1] == 1) { YOffsets = 0; SpwnrAngle = random(0,359); sprkcoord = (sprkangle,pos.z+random(0,2*Args[2])); }
		else { YOffsets = random(-Args[0],Args[0]); sprkcoord = pos+(random(-Args[0],Args[0]),YOffsets,random(0,2*Args[2])); }
		
		if(Args[2] == 0) Args[2] = 4;
		
		if(Args[3] == 1) ZVelocity = frandom(0.1,2.0);
		else ZVelocity = frandom(1,4);
		
		if(!isFrozen() && activated)
		{
			if(hpack_particlemethod)
			{
				if(Args[1] == 1) angle = random(0,359);
				sprkltex = TexMan.CheckForTexture("PTCLA0");
				let p = Level.SpawnVisualThinker(SparkleThinker[Args[3]]);
				if (p)
				{
					p.texture = sprkltex;
					p.pos = sprkcoord;
					p.vel = (0,0,ZVelocity);
					p.flags = SPF_ROLL;//|SPF_FULLBRIGHT
					p.roll = random(0,359);
					p.alpha = 0.01;
					p.scale = (0.2,0.2);
					p.SetRenderStyle(STYLE_Add);
					p.LightLevel = 255;
					p.bAddLightLevel;
					p.SetTranslation(trnstable);
				}
			}
			else
			{
				angle = 0;
				A_SpawnItemEx(SparkleActor[Args[3]],
							random(-Args[0],Args[0]),	// X offset
							YOffsets,					// Y offset
							random(0,2*Args[2]),		// Z offset
							0,							// X velocity
							0,							// Y velocity
							ZVelocity,					// Z velocity
							SpwnrAngle,					// Angle
							SXF_TRANSFERTRANSLATION|SXF_CLIENTSIDE);
			}
		}
		super.Tick();
	}
}

class BlueSparkleSpawner : WhiteSparkleSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (Blue)
	Translation "0:35=185:199";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "BlueSpSpwn";
	}
}

class GreenSparkleSpawner : WhiteSparkleSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (Green)
	Translation "0:35=209:224";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "GreenSpSpwn";
	}
}

class RedSparkleSpawner : WhiteSparkleSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (Red)
	Translation "0:35=145:163";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "RedSpSpwn";
	}
}

class YellowSparkleSpawner: WhiteSparkleSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (Yellow)
	Translation "0:35=111:136";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "YellowSpSpwn";
	}
}

class PurpleSparkleSpawner: WhiteSparkleSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (Purple)
	Translation "0:35=169:176";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "PurpleSpSpwn";
	}
}

class CyanSparkleSpawner : WhiteSparkleSpawner
{
Default
	{
	//$Category HPack_SpecialEffects
	//$Title SparkleSpawner (Cyan)
	Translation "0:35=192:208";
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		trnstable = "CyanSpSpwn";
	}
}

class SparkleSprite : VisualThinker
{
	double RollVel; int ctr;
	override void Tick()
	{
		if (bDESTROYED || IsFrozen()) return;
		Super.Tick();
		Roll-= 20;
		if(ctr < 8) Alpha+= 0.18;
		else
		{
			Alpha-= 0.08;
			if (Alpha <= 0.0)
				Destroy();
		}
		ctr++;
	}
}

class SparkleAccelSprite : SparkleSprite
{
	override void Tick()
	{
		super.Tick();
		if(ctr > 4) vel.z *= 1.1;
	}
}

class BaseStar : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	Alpha 0.01;
	Scale 0.20;
	}
States
	{
	Spawn:
		PTCL AABBCCAA 1 Bright A_FadeIn(0.2);
		PTCL BBCCAABBCCAABBCCAA 1 Bright A_FadeOut(0.06);
		Stop;
	}
}

class BaseStarAccel : BaseStar
{
	override void Tick()
	{
		super.Tick();
		if(GetAge() > 4) vel.z *= 1.1;
	}
}
