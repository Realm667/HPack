class HPSwitchableLightSource : Actor
{
TextureID firtex; string lightname; string FireActor;
bool flarespwn; bool frstticbullsh; bool onsoundplayed; bool offsoundplayed;
Default
	{
	+SOLID
	}
	override void BeginPlay()
	{
		if(!bDORMANT) Activate(self);
		Super.BeginPlay();
	}
	override void Activate(Actor activator)
	{
		if(frstticbullsh && !onsoundplayed) A_StartSound("Torch/Light");
		SetStateLabel("Active");
		onsoundplayed = true; offsoundplayed = false;
	}
	override void Deactivate(Actor activator)
	{
		if(frstticbullsh && !offsoundplayed) A_StartSound("Torch/Die");
		SetStateLabel("Inactive");
		flarespwn = false;
		A_RemoveChildren(true,RMVF_MISC); A_RemoveLight("PropLight");
		frstticbullsh = true; onsoundplayed = false; offsoundplayed = true;
	}
	override void OnDestroy()
	{
		A_RemoveChildren(true,RMVF_MISC);
		Super.OnDestroy();
	}
void HP_ZTFire(int xoffs,int yoffs,int zoffs,int flarezoffs,int firezvmult,string flaretype="RedFlare",string firesprt="FIR1A0",double firescl=0.175)
	{
	if(hpack_lightsourcestyle && frstticbullsh)
		{
		if(!flarespwn)
			{
			A_SpawnItemEx(flaretype,0,0,flarezoffs,0,0,0,0,SXF_SETMASTER|SXF_CLIENTSIDE);
			flarespwn = true;
			}
		if(hpack_particlemethod)
			{
			firtex = TexMan.CheckForTexture(firesprt);
			let p = Level.SpawnVisualThinker("FireSprite2");
			if (p)
				{
				p.texture = firtex;
				p.pos = pos+(random(-xoffs,xoffs),random(-yoffs,yoffs),random(zoffs,zoffs+2));
				p.vel = (0.001*random(-100,100),0.001*random(-100,100),0.001*firezvmult);
				p.flags = SPF_ROLL;//|SPF_FULLBRIGHT
				p.roll = random(0,359);
				p.alpha = 1.0;
				p.scale = (firescl,firescl);
				p.SetRenderStyle(STYLE_Add);
				p.LightLevel = 255;
				p.bAddLightLevel;
				p.bXflip = random(0,1);
				p.bYflip = random(0,1);
				p.bflipoffsetX = true;
				p.bflipoffsetY = true;
				}
			}
		else if(!hpack_particlemethod)
			{
			if (firesprt == "FLM1A0" || firesprt == "FLM3A0" || firesprt == "FLM5A0") FireActor = "BigRedFire";
			else FireActor = "RedFire1";
			A_SpawnItemEx(FireActor,frandom(-xoffs,xoffs),frandom(-yoffs,yoffs),frandom(zoffs,zoffs+2),0.001*frandom(-100,100),0.001*frandom(-100,100),0.0014*firezvmult,0,SXF_CLIENTSIDE);
			}
		}
	}
void HP_ZTEtherFire(int xoffs,int yoffs,int zoffs,int flarezoffs,int firezvmult,name transtable="",string flaretype="BlueFlare",string firesprt="SKFXA0",double firescl=0.2)
	{
	if(hpack_lightsourcestyle && frstticbullsh)
		{
		if(!flarespwn)
			{
			A_SpawnItemEx(flaretype,0,0,flarezoffs,0,0,0,0,SXF_SETMASTER|SXF_CLIENTSIDE);
			flarespwn = true;
			}
		if(hpack_particlemethod)
			{
			firtex = TexMan.CheckForTexture(firesprt);
			let p = Level.SpawnVisualThinker("EtherSprite");
			if (p)
				{
				p.texture = firtex;
				p.pos = pos+(frandom(-xoffs,xoffs),frandom(-yoffs,yoffs),frandom(zoffs,zoffs+2));
				p.vel = (0.001*random(-100,100),0.001*random(-100,100),0.001*firezvmult);
				p.alpha = 1.0;
				p.scale = (firescl,firescl);
				p.SetRenderStyle(STYLE_Add);
				//p.flags = SPF_FULLBRIGHT
				p.LightLevel = 255;
				p.bAddLightLevel;
				p.SetTranslation(transtable);
				}
			}
		else if(!hpack_particlemethod)
			{
			if (flaretype == "RainbowFlare") FireActor = "TorchStarRandom";
			else FireActor = "TorchStarBlue";
			A_SpawnItemEx(FireActor,frandom(-2,2),frandom(-2,2),frandom(zoffs,zoffs+2),0.001*Random(-100,100),0.001*Random(-100,100),0.001*firezvmult,0,SXF_CLIENTSIDE);
			}
		}
	}
	override void Tick()
	{
		if(!isFrozen() && !InStateSequence(self.Curstate,self.ResolveState("Inactive")))
		{
			frstticbullsh = true; A_AttachLightDef("PropLight",lightname);
			if(InStateSequence(self.Curstate,self.ResolveState("Active")) && !hpack_lightsourcestyle)
			{
				A_RemoveChildren(true,RMVF_MISC);
				flarespwn = false;
				SetStateLabel("Normal");
			}
			else if(InStateSequence(self.Curstate,self.ResolveState("Normal")) && hpack_lightsourcestyle)
			{
				SetStateLabel("Active");
			}
		}
	super.Tick();
	}
}

class FireSprite2 : VisualThinker
{
	double RollVel;
	int ctr;
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		RollVel = randompick(-35.0,35.0);
	}
	override void Tick()
	{
		if (bDESTROYED || IsFrozen())
			return;
		Super.Tick();
		ctr++;
		Roll+= RollVel;
		Scale/= 1.07;
		if(ctr > 11)
		{
			Alpha-= 0.15;
			if (Alpha <= 0.0)
				Destroy();
		}
	}
}

class FireSprite3 : VisualThinker
{
	int ctr;
	override void Tick()
	{
		if (bDESTROYED || IsFrozen())
			return;
		Super.Tick();
		ctr++;
		if(ctr > 7)
		{
			Alpha-= 0.15;
			if (Alpha <= 0.0)
				Destroy();
		}
	}
}

class EtherSprite : VisualThinker
{
	override void Tick()
	{
		if (bDESTROYED || IsFrozen())
			return;
		Super.Tick();
		Alpha-= 0.05;
		Scale*= 1.066;
		if (Alpha <= 0.0)
			Destroy();
	}
}
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

class ToTLBrassTorch : HPSwitchableLightSource
{
Default
	{
	//$Category Lights
	//$Title Brass Torch
	//$Sprite BRTRB0
	Radius 6;
	Height 35;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "BRASSTORCH";
	}
States
	{
	Spawn:
	Active:
		BRTR N 1 HP_ZTFire(2,2,34,38,frandom(1000,1600));
		Loop;
	Normal:
		BRTR ABCDEFGHIJKLM 4 Bright;
		Loop;
	Inactive:
		BRTR N -1;
		Stop;
	}
}

class TOTLTwinedTorch : HPSwitchableLightSource
{
Default
	{
	//$Category Lights
	//$Title Twined Torch
	//$Sprite TWTRA0
	Radius 10;
	Height 64;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "TWINETORCH";
	}
States
	{
	Spawn:
	Active:
		TWTR J 1 HP_ZTFire(2,2,58,64,frandom(1000,1600));
		Loop;
	Normal:
		TWTR ABCDEFGH 4 Bright;
		Loop;
	Inactive:
		TWTR I -1;
		Stop;
	}
}

class ToTLSkullTorch : HPSwitchableLightSource
{
Default
	{
	//$Category Lights
	//$Title Demon Brazier
	//$Sprite FSKLA0
	Radius 5;
	Height 28;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "BRASSTORCH";
	}
States
	{
	Spawn:
	Active:
		FSKL J 1 HP_ZTFire(2,2,26,27,frandom(1000,1600));
		Loop;
	Normal:
		FSKL A 4 Bright;
		FSKL B 3 Bright;
		FSKL C 4 Bright;
		FSKL D 3 Bright;
		FSKL E 4 Bright;
		FSKL F 3 Bright;
		FSKL G 4 Bright;
		FSKL H 3 Bright;
		FSKL I 4 Bright;
		Loop;
	Inactive:
		FSKL J -1;
		Stop;
	}
}

class TOTLFireBrazier : HPSwitchableLightSource replaces FireBrazier
{
Default
	{
	//$Category Lights
	//$Title Fire Brazier
	//$Sprite KFR1A0
	Radius 16;
	Height 44;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "FIREBRAZ";
	}
States
	{
	Spawn:
	Active:
		KFR1 I 1 HP_ZTFire(2,2,43,45,frandom(1000,1600));
		Loop;
	Normal:
		KFR1 ABCDEFGH 3 Bright;
		Loop;
	Inactive:
		KFR1 I -1;
		Stop;
	}
}

class ToTLSerpentTorch : HPSwitchableLightSource replaces SerpentTorch
{
Default
	{
	//$Category Lights
	//$Title Serpent Torch
	//$Sprite SRTCA0
	Radius 12;
	Height 54;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "SERPTORCH";
	}
States
	{
	Spawn:
	Active:
		SRTC D 1 HP_ZTFire(2,2,52,54,frandom(1000,1600));
		Loop;
	Normal:
		SRTC ABC 4 Bright;
		Loop;
	Inactive:
		SRTC D -1;
		Stop;
	}
}

class SnakeBrazierBrass : HPSwitchableLightSource
{
Default
	{
	//$Category Lights
	//$Title Snake Brazier (Brass)
	Radius 12;
	Height 56;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "SNAKETORCH";
	}
States
	{
	Spawn:
	Active:
		BNAK H 1 HP_ZTFire(2,2,58,62,frandom(1000,1600));
		Loop;
	Normal:
		BNAK ABCDEFG 3 Bright;
		Loop;
	Inactive:
		BNAK H -1;
		Stop;
	}
}

class SnakeBrazierGold : SnakeBrazierBrass
{
Default
	{
	//$Category Lights
	//$Title Snake Brazier (Gold)
	}
States
	{
	Spawn:
	Active:
		YNAK H 1 HP_ZTFire(2,2,58,62,frandom(1000,1600));
		Loop;
	Normal:
		YNAK ABCDEFG 3 Bright;
		Loop;
	Inactive:
		YNAK H -1;
		Stop;
	}
}

class SnakeBrazierJade : SnakeBrazierBrass
{
Default
	{
	//$Category Lights
	//$Title Snake Brazier (Jade)
	}
States
	{
	Spawn:
	Active:
		GNAK H 1 HP_ZTFire(2,2,58,62,frandom(1000,1600));
		Loop;
	Normal:
		GNAK ABCDEFG 3 Bright;
		Loop;
	Inactive:
		GNAK H -1;
		Stop;
	}
}

class TOTLWallTorch : HPSwitchableLightSource replaces WallTorch
{
Default
	{
	//$Category Lights
	//$Title Wall Torch
	//$Sprite WTRHA0
	Radius 6;
	Height 16;
	+NoGravity
	+FixMapThingPos
	-Solid
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "WALLTORCH";
	}
States
	{
	Spawn:
	Active:
		WTRH D 1 HP_ZTFire(2,2,71,72,frandom(1000,1600));
		Loop;
	Normal:
		WTRH ABC 6 Bright;
		Loop;
	Inactive:
		WTRH D -1;
		Stop;
	}
}

class ZWallTorchNew : TOTLWallTorch
{
Default
	{
	//$Category Lights
	//$Title Wall Torch (Hexen)
	//$Sprite WLTRA0
	}
States
	{
	Spawn:
	Active:
		WLTR I 1 HP_ZTFire(2,2,71,72,frandom(1000,1600));
		Loop;
	Normal:
		WLTR ABCDEFGH 5 Bright;
		Loop;
	Inactive:
		WLTR I -1;
		Stop;
	}
}

class ZFireBullNew : HPSwitchableLightSource
{
static const string textp[] = { "FLM1A0","FLM3A0","FLM5A0" };
Default
	{
	//$Category Lights
	//$Title Maulotaur Brazier
	//$Sprite FBULA0
	Radius 20;
	Height 80;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "FIREBULL";
	}
States
	{
	Spawn:
	Active:
		FBUL K 1 HP_ZTFire(1,1,28,30,frandom(2500,3000),"Flare_Red_A1B",textp[random(0,2)],0.4);
		Loop;
	Normal:
		FBUL ABCDEFG 4 Bright;
		Loop;
	Inactive:
		FBUL H -1;
		Stop;
	}
}

class HPMagicWallTorch : TOTLWallTorch
{
static const string trnsp[] = { "TSGreen","TSBlue","TSWhite","TSRed","TSOrange","TSPurple" };
Default
	{
	//$Category Lights
	//$Title Wall Torch (Magic)
	//$Sprite ETRHA0
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "WHITETORCHLIGHT";
	}
States
	{
	Spawn:
	Active:
		ETRH A 1 HP_ZTEtherFire(2,2,67,72,frandom(1000,2000),trnsp[random(0,5)],"RainbowFlare");
		Loop;
	Normal:
		ETRH BCDEFG 4 Bright;
		Loop;
	Inactive:
		ETRH A -1;
		Stop;
	}
}

class EtherealStatueRed : HPSwitchableLightSource
{
Default
	{
	//$Category Obstacles
	//$Title Statue (Ethereal Red)
	//$Sprite STE1A0
	Radius 10;
	Height 62;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "ETHERSTATUERED";
	}
States
	{
	Spawn:
	Active:
		STE1 A 1 Bright HP_ZTFire(2,2,77,78,frandom(1000,1600));
		Loop;
	Normal:
		STE1 BCDEFG 3 Bright;
		Loop;
	Inactive:
		STE1 A -1;
		Stop;
	}
}

class EtherealStatueBlue : HPSwitchableLightSource
{
Default
	{
	//$Category Obstacles
	//$Title Statue (Ethereal Blue)
	//$Sprite STE2A0
	Radius 10;
	Height 62;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "ETHERSTATUEBLUE";
	}
States
	{
	Spawn:
	Active:
		STE2 A 1 Bright HP_ZTEtherFire(2,2,75,76,frandom(1000,2000),"TSBlue");
		Loop;
	Normal:
		STE2 BCDEFG 4 Bright;
		Loop;
	Inactive:
		STE2 A -1;
		Stop;
	}
}

class DSparilStatue : HPSwitchableLightSource
{
Default
	{
	//$Category Obstacles
	//$Title Statue (D'Sparil Shrine)
	//$Sprite STARA0
	//$IsDecoration
	//$NotAngled
	Radius 14;
	Height 96;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		lightname = "DSPARILSTATUERED";
	}
States
	{
	Spawn:
	Active:
		STAR D 1 Bright
		{
		if(hpack_lightsourcestyle && frstticbullsh)
			{
			if(!flarespwn)
				{
				A_SpawnItemEx("DoubleRedFlare",0,0,102,0,0,0,0,SXF_SETMASTER|SXF_CLIENTSIDE);
				flarespwn = true;
				}
			if(hpack_particlemethod)
				{
				firtex = TexMan.CheckForTexture("2FIRA0");
				let p = Level.SpawnVisualThinker("FireSprite3");
				if (p)
					{
					p.texture = firtex;
					p.pos = pos+(frandom(-2,2),frandom(-2,2),frandom(102,104));
					p.vel = (0.001*frandom(-100,100),0.001*frandom(-100,100),0.001*frandom(1000,2000));
					p.flags = SPF_LOCAL_ANIM;//|SPF_FULLBRIGHT
					p.alpha = 1.0;
					p.scale = (0.175,0.175);
					p.SetRenderStyle(STYLE_Add);
					p.LightLevel = 255;
					p.bAddLightLevel;
					p.bXflip = random(0,1);
					p.bYflip = random(0,1);
					p.bflipoffsetX = true;
					p.bflipoffsetY = true;
					}
				}
			else if(!hpack_particlemethod) A_SpawnItemEx("DoubleFireFX",frandom(-2,2),frandom(-2,2),frandom(102,104),0.001*frandom(-100,100),0.001*frandom(-100,100),0.001*frandom(1000,2000),0,SXF_CLIENTSIDE);
			}
		}
		Loop;
	Normal:
		STAR ABC 6 Bright;
		Loop;
	Inactive:
		STAR D -1;
		Stop;
	}
}

// Effect -----------------------------------------------------------------------------------------

class RedFire1 : Actor
{
static const string firsprt[] = { "FIR1","FIR2" };
Default
	{
	+NoInteraction
	+ForceXYBillboard
	RenderStyle "Add";
	Scale 0.175;
	}
override void PostBeginPlay() 
	{
		super.PostBeginPlay();
		sprite = GetSpriteIndex(firsprt[random(0,1)]);
	}
States
	{
	Spawn:
		"####" ABCDEFG 1 Bright;
		"####" HIJKL 1 Bright A_FadeOut(0.15);
		Stop;
	}
}

class BigRedFire : RedFire1
{
static const string firsprt[] = { "FLM1","FLM2","FLM3","FLM4","FLM5","FLM6" };
Default
	{
	Scale 0.4;
	}
override void PostBeginPlay() 
	{
		super.PostBeginPlay();
		sprite = GetSpriteIndex(firsprt[random(0,5)]);
	}
}

class DoubleFireFX : RedFire1
{
override void PostBeginPlay() 
	{
		super.PostBeginPlay();
		sprite = GetSpriteIndex("2FIR");
	}
}

// ye olde magick torche --------------------------------------------------------------------------

class TorchStarGreen : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	Alpha 1;
	Scale 0.2;
	}
States
	{
	Spawn:
		SKFX A 1 Bright A_FadeOut(0.1);
		SKFX A 1 Bright A_SetScale(scale.x+0.033);
		Loop;
	}
}

class TorchStarBlue : TorchStarGreen { Default { translation "209:224=185:200"; } }
class TorchStarWhite : TorchStarGreen { Default { translation "209:224=0:35"; } }
class TorchStarRed : TorchStarGreen { Default { translation "209:224=145:159"; } }
class TorchStarOrange : TorchStarGreen { Default { translation "209:224=112:127"; } }
class TorchStarPurple : TorchStarGreen { Default { translation "209:224=169:176"; } }

class TorchStarRandom : TorchStarGreen
{
static const string starstr[] = { "TorchStarGreen","TorchStarBlue","TorchStarWhite","TorchStarRed","TorchStarOrange","TorchStarPurple" };
States
	{
	Spawn:
		TNT1 A 1 Nodelay A_SpawnItemEx(starstr[random(0,5)],0,0,0,vel.x,vel.y,vel.z,angle,SXF_CLIENTSIDE);
		Stop;
	}
}

// Flares -----------------------------------------------------------------------------------------

class TorchFlareBase : Actor
{
Default
	{
	+ForceXYBillboard
	+RelativeToFloor
	+NoGravity
	+Bright
	RenderStyle "Add";
	Height 2;
	Radius 2;
	Scale 0.3;
	Alpha 0.5;
	}
}

class RedFlare : TorchFlareBase
{
States
	{
	Spawn:
		RFLR A -1;
		Stop;
	}
}

class BlueFlare : TorchFlareBase
{
States
	{
	Spawn:
		RFLB A -1;
		Stop;
	}
}

class GreenFlare : TorchFlareBase
{
States
	{
	Spawn:
		RFLG B -1;
		Stop;
	}
}

class YellowFlare : TorchFlareBase
{
States
	{
	Spawn:
		RFLY A -1;
		Stop;
	}
}

class RedFlareFade : TorchFlareBase
{
Default
	{
	Alpha 0;
	}
States
	{
	Spawn:
		RFLR A 0;
		Goto Fade;
	Fade:
		"####" "##########" 1 A_FadeIn(0.05);
		"####" "##########" 1 A_FadeOut(0.05);
		Stop;
	}
}

class BlueFlareFade : RedFlareFade
{
States
	{
	Spawn:
		RFLB A 0;
		Goto Fade;
	Fade:
		"####" "##########" 1 A_FadeIn(0.1); // blue is a bit too dark at 0.5
		"####" "##########" 1 A_FadeOut(0.1);
		Stop;
	}
}

class GreenFlareFade : RedFlareFade
{
States
	{
	Spawn:
		RFLG B 0;
		Goto Fade;
	}
}

class YellowFlareFade : RedFlareFade
{
States
	{
	Spawn:
		RFLY A 0;
		Goto Fade;
	}
}

class RainbowFlare : TorchFlareBase
{
States
	{
	Spawn:
		TNT1 A 0 NoDelay A_Jump(256,1,2,3,4);
	Rrrrrrrrrrainbows:
		TNT1 A 10 A_SpawnItemEx("RedFlareFade", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
		TNT1 A 10 A_SpawnItemEx("BlueFlareFade", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
		TNT1 A 10 A_SpawnItemEx("GreenFlareFade", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
		TNT1 A 10 A_SpawnItemEx("YellowFlareFade", 0, 0, 0, 0, 0, 0, 0, SXF_CLIENTSIDE);
		Loop;
	}
}

class Flare_Red_A1B : TorchFlareBase
{
Default
	{
	Alpha 0.8;
	Scale 1;
	}
States
	{
	Spawn:
		FLRE A -1;
		Stop;
	}
}

class DoubleRedFlare : TorchFlareBase
{
Default
	{
	Scale 0.26;
	}
States
	{
	Spawn:
		2FLA A -1;
		Stop;
	}
}