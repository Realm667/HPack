/////////////////////////////
// LAVA EMBER        ////////
// for UTNT          ////////
// by Tormentor667   ////////
/////////////////////////////
//Zscript conversion by Gothic

class EmberSpawner : Actor
{
bool activated; double YOffsets; double embractorangle;
TextureID embtex; vector3 embrcoord; vector2 embrangle;
Default
	{
	//$Category HPack_SpecialEffects
	//$NotAngled
	
	//$Arg0 Radius
	//$Arg0Type 0

	//$Arg1 Type of Area
	//$Arg1Type 11
	//$Arg1Enum { 0 = "Square"; 1 = "Circle"; }

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
States
	{
	Spawn:
		TNT1 A 2 Nodelay HP_SpawnEmber();
		Loop;
	}
	void HP_SpawnEmber()
	{
		embrangle = vec2angle(frandom(-Args[0],Args[0]),angle);
		if(Args[1] == 1) { YOffsets = 0; embractorangle = random(0,359); embrcoord = (embrangle,pos.z+random(0,8)); }
		else { YOffsets = frandom(-Args[0],Args[0]); embractorangle = 0; embrcoord = pos+(frandom(-Args[0],Args[0]),YOffsets,random(0,8)); }
		
		if(activated)
		{
			if(hpack_particlemethod)
			{
				if(random(1,256) <= Args[2]) return;
				if(Args[1] == 1) angle = random(0,359);
				else angle = 0;
				embtex = TexMan.CheckForTexture("EMBRA0");
				let p = Level.SpawnVisualThinker("EmberSprite2");
				if (p)
				{
					p.texture = embtex;
					p.pos = embrcoord;
					//p.flags = SPF_FULLBRIGHT;
					p.vel = (0.1*frandom(-3,3),0.1*frandom(-3,3),0.1*frandom(1,10));
					p.alpha = 0.01;
					p.scale = (0.06,0.06);
					p.SetRenderStyle(STYLE_Add);
					p.LightLevel = 255;
					p.bAddLightLevel;
				}
			}
			else if(!hpack_particlemethod)
			{
				angle = 0;
				A_SpawnItemEx("BaseEmber",frandom(-Args[0],Args[0]),YOffsets,random(0,8),(0.1)*frandom(-3,3),(0.1)*frandom(-3,3),(0.1)*frandom(1,10),embractorangle,SXF_CLIENTSIDE,Args[2]);
			}
		}
	}
}

class EmberSprite2 : VisualThinker
{
	int ctr; int ctr2; bool ctr3; bool ctr4;
	override void Tick()
	{
		if (bDESTROYED || IsFrozen()) return;
		Super.Tick();
		if(ctr3) Alpha-= 0.06;
		else if(!ctr4) Alpha+= 0.2;
		if(ctr > 4)
		{
			ctr4 = true;
			ctr2+=2;
			if(random(1,ctr2) > 50)
			{
				ctr3 = true;
			}
		}
		ctr++;
		if (Alpha <= 0.0) Destroy();
	}
}

class BaseEmber : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	Alpha 0.01;
	Scale 0.06;
	}
States
	{
	Spawn:
		EMBR AAAA 1 Bright A_FadeIn(0.25);
		TNT1 A 0 A_Jump(80,2,3,4,5);
		EMBR AAAAA 8 Bright;
		EMBR AAAAAAAAAAAAAAAAAAAA 1 Bright A_FadeOut(0.06);
		Stop;
	}
}