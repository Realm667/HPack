class HTeleportFog : TeleportFog replaces TeleportFog
{
States
	{
	Raven:
		TNT1 A 3 A_SpawnItemEx("TCentreStar",0,0,0,0,0,0,0,SXF_TRANSFERTRANSLATION|SXF_NOCHECKPOSITION|SXF_CLIENTSIDE);
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("TGlitter",random(32,-32),random(32,-32),-20,0,0,random(1,4),0,SXF_TRANSFERTRANSLATION|SXF_NOCHECKPOSITION|SXF_CLIENTSIDE);
		TNT1 A 3;
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("TGlitter",random(32,-32),random(32,-32),-20,0,0,random(1,4),0,SXF_TRANSFERTRANSLATION|SXF_NOCHECKPOSITION|SXF_CLIENTSIDE);
		TNT1 A 3;
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("TGlitter",random(32,-32),random(32,-32),-20,0,0,random(1,4),0,SXF_TRANSFERTRANSLATION|SXF_NOCHECKPOSITION|SXF_CLIENTSIDE);
		TNT1 A 3;
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("TGlitter",random(32,-32),random(32,-32),-20,0,0,random(1,4),0,SXF_TRANSFERTRANSLATION|SXF_NOCHECKPOSITION|SXF_CLIENTSIDE);
		TNT1 A 3;
		TNT1 AAAAAAAAAA 0 A_SpawnItemEx("TGlitter",random(32,-32),random(32,-32),-20,0,0,random(1,4),0,SXF_TRANSFERTRANSLATION|SXF_NOCHECKPOSITION|SXF_CLIENTSIDE);
		Stop;
	}
}

class TCentreStar : Actor
{
Default
	{
	+NOINTERACTION
	RenderStyle "Add";
	Alpha 1;
	}
States
	{
	Spawn:
		TELE ABCDEF 3 Bright;
	Fade:
		TELE GH 3 Bright A_FadeOut(0.1);
		Loop;
	}
}

class TGlitter : TCentreStar
{
States
	{
	Spawn:
		TGLT FGHIJ 2 Bright A_FadeOut(0.075);
		Loop;
	}
}

class HTeleportFogRed : HTeleportFog { Default { Translation "185:208=145:168","177:184=249:245"; } }
class HTeleportFogGold : HTeleportFog { Default { Translation "185:208=111:136","177:184=137:144"; } }
class HTeleportFogGreen : HTeleportFog { Default { Translation "185:208=209:224","177:184=233:240"; } }
class HTeleportFogTan : HTeleportFog { Default { Translation "185:208=66:94","177:184=95:110"; } }

class HPTeleGlitter1 : TeleGlitter1 replaces TeleGlitter1 { Default { +FORCEXYBILLBOARD +CLIENTSIDEONLY } }
class HPTeleGlitter2 : TeleGlitter2 replaces TeleGlitter2 { Default { +FORCEXYBILLBOARD +CLIENTSIDEONLY } }
/*Gold*/ class TeleGlitter3 : HPTeleGlitter1 { Default { Translation "151:165=119:133"; } }
/*Green*/ class TeleGlitter4 : HPTeleGlitter1 { Default { Translation "145:168=209:224"; } }
/*Purple*/ class TeleGlitter5 : HPTeleGlitter1 { Default { Translation "145:168=170:176"; } }
/*White*/ class TeleGlitter6 : HPTeleGlitter1 { Default { Translation "151:165=20:34"; } }

class RedStar : BaseStar2 { Default { Translation "209:224=145:159"; } }
class RedSparkle : BaseStar { Default { Translation "0:35=145:163"; } }
class RedSparkleAccel : BaseStarAccel { Default { Translation "0:35=145:163"; } }

class RandomParticleSpawnerBase : Actor
{
bool itsaglitter; int s1; string selectstar; string sprkltrans; string startrans;
Array<String> StarFnt; TextureID sprkltex; string whatstartext; string whatstarthinker;
Default
	{
	+NOBLOCKMAP
	+NOSECTOR
	+NOGRAVITY
	+THRUACTORS
	}
States
	{
	Spawn:
		TNT1 A 1 Nodelay HP_SpawnRandomStar();
		Stop;
	}
	void HP_SpawnRandomStar()
	{
		s1 = StarFnt.Size() - 1;
		selectstar = StarFnt[random(0,s1)];
		HP_RPSBProcessData();
		HP_RPSBSpitThatStar();
	}
	void HP_RPSBProcessData()
	{
		if(selectstar == "TeleGlitter1" || selectstar == "TeleGlitter2" || selectstar == "TeleGlitter3" || selectstar == "TeleGlitter4" || selectstar == "TeleGlitter5" || selectstar == "TeleGlitter6")
			itsaglitter = true;
		else if(selectstar == "RedStar" || selectstar == "BlueStar" || selectstar == "OrangeStar" || selectstar == "GreenStar" || selectstar == "PurpleStar" || selectstar == "WhiteStar")
			{ whatstartext = "SKFXA0"; whatstarthinker = "StarSprite"; }
		else if(selectstar == "RedSparkle" || selectstar == "BlueSparkle" || selectstar == "YellowSparkle" || selectstar == "GreenSparkle" || selectstar == "PurpleSparkle" || selectstar == "WhiteSparkle")
			{ whatstartext = "PTCLA0"; whatstarthinker = "SparkleSprite"; }
		else if(selectstar == "RedSparkleAccel" || selectstar == "BlueSparkleAccel" || selectstar == "YellowSparkleAccel" || selectstar == "GreenSparkleAccel" || selectstar == "PurpleSparkleAccel" || selectstar == "WhiteSparkleAccel")
			{ whatstartext = "PTCLA0"; whatstarthinker = "SparkleAccelSprite"; }
	}
	void HP_RPSBSpitThatStar()
	{
		if(hpack_particlemethod && !itsaglitter)
		{
			sprkltex = TexMan.CheckForTexture(whatstartext);
			let p = Level.SpawnVisualThinker(whatstarthinker);
			if (p)
			{
				p.texture = sprkltex;
				p.pos = pos;
				p.vel = vel;
				p.SetRenderStyle(STYLE_Add);
				p.LightLevel = 255;
				p.bAddLightLevel;
				if(whatstartext == "PTCLA0")
				{
					p.flags = SPF_ROLL;
					p.roll = random(0,359);
					p.alpha = 0.01;
					p.scale = (0.2,0.2);
					p.SetTranslation(sprkltrans);
				}
				else
				{
					p.alpha = 1.0;
					p.scale = (0.1,0.1);
					p.SetTranslation(startrans);
				}
			}
		}
		else
		{
			A_SpawnItemEx(selectstar,0,0,0,0,0,vel.z,0,SXF_CLIENTSIDE);
			itsaglitter = false;
		}
	}
}

class RandomRedParticle : RandomParticleSpawnerBase
{
	override void PostBeginPlay()
	{
		StarFnt.PushV("TeleGlitter1","RedStar","RedSparkle","RedSparkleAccel");
		sprkltrans = "RedSpSpwn"; startrans = "RedStSpwn";
		Super.PostBeginPlay();
	}
}

class BlueStar : BaseStar2 { Default { Translation "209:224=185:200"; } }
class BlueSparkle : BaseStar { Default { Translation "0:35=185:199"; } }
class BlueSparkleAccel : BaseStarAccel { Default { Translation "0:35=185:199"; } }
class CyanSparkle : BaseStar { Default { Translation "0:35=192:208"; } }
class CyanSparkleAccel : BaseStarAccel { Default { Translation "0:35=192:208"; } }
class RandomBlueParticle : RandomParticleSpawnerBase
{
	override void PostBeginPlay()
	{
		StarFnt.PushV("TeleGlitter2","BlueStar","BlueSparkle","BlueSparkleAccel","CyanSparkle","CyanSparkleAccel");
		startrans = "BlueStSpwn";
		if (random(1,10) < 5) sprkltrans = "CyanSpSpwn";
		else sprkltrans = "BlueSpSpwn";
		Super.PostBeginPlay();
	}
}

class OrangeStar : BaseStar2 { Default { Translation "209:224=112:127"; } }
class YellowSparkle : BaseStar { Default { Translation "0:35=111:136"; } }
class YellowSparkleAccel : BaseStarAccel { Default { Translation "0:35=111:136"; } }
class RandomGoldParticle : RandomParticleSpawnerBase
{
	override void PostBeginPlay()
	{
		StarFnt.PushV("TeleGlitter3","OrangeStar","YellowSparkle","YellowSparkleAccel");
		sprkltrans = "YellowSpSpwn"; startrans = "OrangeStSpwn";
		Super.PostBeginPlay();
	}
}

class GreenStar : BaseStar2 {}
class GreenSparkle : BaseStar { Default { Translation "0:35=209:224"; } }
class GreenSparkleAccel : BaseStarAccel { Default { Translation "0:35=209:224"; } }
class RandomGreenParticle : RandomParticleSpawnerBase
{
	override void PostBeginPlay()
	{
		StarFnt.PushV("TeleGlitter4","GreenStar","GreenSparkle","GreenSparkleAccel");
		sprkltrans = "GreenSpSpwn"; startrans = "NoTrans";
		Super.PostBeginPlay();
	}
}

class PurpleStar : BaseStar2 { Default { Translation "209:224=169:176"; } }
class PurpleSparkle : BaseStar { Default { Translation "0:35=169:176"; } }
class PurpleSparkleAccel : BaseStarAccel { Default { Translation "0:35=169:176"; } }
class RandomPurpleParticle : RandomParticleSpawnerBase
{
	override void PostBeginPlay()
	{
		StarFnt.PushV("TeleGlitter5","PurpleStar","PurpleSparkle","PurpleSparkleAccel");
		sprkltrans = "PurpleSpSpwn"; startrans = "PurpleStSpwn";
		Super.PostBeginPlay();
	}
}

class WhiteStar : BaseStar2 { Default { Translation "209:224=1:35","208:208=35:35"; } }
class WhiteSparkle : BaseStar {}
class WhiteSparkleAccel : BaseStarAccel {}
class RandomWhiteParticle : RandomParticleSpawnerBase
{
	override void PostBeginPlay()
	{
		StarFnt.PushV("TeleGlitter6","WhiteStar","WhiteSparkle","WhiteSparkleAccel");
		sprkltrans = "NoTrans"; startrans = "WhiteStSpwn";
		Super.PostBeginPlay();
	}
}

class RandomParticle : RandomSpawner
{
Default
	{
	DropItem "RandomRedParticle";
	DropItem "RandomBlueParticle";
	DropItem "RandomGoldParticle";
	DropItem "RandomGreenParticle";
	DropItem "RandomPurpleParticle";
	DropItem "RandomWhiteParticle";
	}
}

class TeleGlitterGenerator3 : TeleGlitterGenerator1
{
Default
	{
	//$Category Teleports
	//$Title Teleport Glitter (Gold)
	}
States
	{
	Spawn:
		TNT1 A 8 A_SpawnItemEx("TeleGlitter3", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		Loop;
	}
}

class TeleGlitterGenerator4 : TeleGlitterGenerator1
{
Default
	{
	//$Category Teleports
	//$Title Teleport Glitter (Green)
	}
	States
	{
	Spawn:
		TNT1 A 8 A_SpawnItemEx("TeleGlitter4", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		Loop;
	}
}

class TeleGlitterGenerator5 : TeleGlitterGenerator1
{
Default
	{
	//$Category Teleports
	//$Title Teleport Glitter (Purple)
	}
	States
	{
	Spawn:
		TNT1 A 8 A_SpawnItemEx("TeleGlitter5", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		Loop;
	}
}

class TeleGlitterGenerator6 : TeleGlitterGenerator1
{
Default
	{
	//$Category Teleports
	//$Title Teleport Glitter (White)
	}
	States
	{
	Spawn:
		TNT1 A 8 A_SpawnItemEx("TeleGlitter6", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		Loop;
	}
}

class TeleGlitterGenerator7 : TeleGlitterGenerator1
{
Default
	{
	//$Category Teleports
	//$Title Teleport Glitter (All Colors)
	}
	States
	{
	Spawn:
		TNT1 A 8 A_SpawnItemEx("TeleGlitter1", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		TNT1 A 8 A_SpawnItemEx("TeleGlitter2", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		TNT1 A 8 A_SpawnItemEx("TeleGlitter3", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		TNT1 A 8 A_SpawnItemEx("TeleGlitter4", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		TNT1 A 8 A_SpawnItemEx("TeleGlitter5", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		TNT1 A 8 A_SpawnItemEx("TeleGlitter6", random[TeleGlitter](0,31)-16, random[TeleGlitter](0,31)-16, 0, 0,0,0.25);
		Loop;
	}
}

class RandomStarFountain : Actor
{
bool activated; double ZVelocity; vector2 sprkangle; vector3 sprkcoord;
Array<String> StarFnt; Array<String> StarFntRndm; Array<String> TransStar;  Array<String> TransSparkle;
bool itsaglitter; TextureID sprkltex; string whatstartext; string whatstarthinker; string selecttrans1; string selecttrans2; string selectstar;
int s1; int s2; int s3; int s4;
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Random Star Fountain
	//$NotAngled

	//$Arg0 Radius
	//$Arg0Type 0

	//$Arg2 Vertical Spread
	//$Arg2Type 0

	//$Arg3 Color Number
	//$Arg3Type 0
	//$Arg3Tooltip "1 is red\n2 is blue\n4 is yellow\n8 is green\n16 is purple\n32 is white\nThese values can be combined, for example 21 will result in red, yellow and purple particles\n0 & 63 spawns all colors"
	+NOBLOCKMAP
	+NOGRAVITY
	+DONTSPLASH
	+MOVEWITHSECTOR
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
		TNT1 A 6 HP_SpawnRandomStars();
		Loop;
	}
	void HP_SpawnRandomStars()
	{
		if(Args[0] == 0) Args[0] = 16; if(Args[2] == 0) Args[2] = 4; if(Args[3] == 0) Args[3] = 63;
		sprkangle = vec2angle(frandom(-Args[0],Args[0]),angle); sprkcoord = (sprkangle,pos.z+random(0,2*Args[2]));
		if(activated)
		{
			HP_RSFDataRead();
			s1 = StarFnt.Size() - 1; s2 = StarFntRndm.Size() - 1; s3 = TransStar.Size() - 1; s4 = TransSparkle.Size() - 1;
			selectstar = StarFnt[random(0,s1)]; selecttrans1 = TransStar[random(0,s3)]; selecttrans2 = TransSparkle[random(0,s4)];
			HP_RSFProcessData();
			HP_RSFSpitThatStar();
			A_SpawnItemEx(StarFntRndm[random(0,s2)],random(-Args[0],Args[0]),0,random(0,2*Args[2]),0,0,frandom(0.5,5.0),random(0,359),SXF_CLIENTSIDE);
			StarFnt.Clear(); StarFntRndm.Clear(); TransStar.Clear(); TransSparkle.Clear();
		}
	}
	void HP_RSFDataRead()
	{
		if((Args[3] & 1))
		{
			StarFnt.PushV("TeleGlitter1","RedStar","RedSparkle","RedSparkleAccel"); StarFntRndm.PushV("RandomRedParticle");
			TransStar.PushV("RedStSpwn"); TransSparkle.PushV("RedSpSpwn");
		}
		if((Args[3] & 2))
		{
			StarFnt.PushV("TeleGlitter2","BlueStar","BlueSparkle","BlueSparkleAccel"); StarFntRndm.PushV("RandomBlueParticle");
			TransStar.PushV("BlueStSpwn"); TransSparkle.PushV("BlueSpSpwn");
		}
		if((Args[3] & 4))
		{
			StarFnt.PushV("TeleGlitter3","OrangeStar","YellowSparkle","YellowSparkleAccel"); StarFntRndm.PushV("RandomGoldParticle");
			TransStar.PushV("OrangeStSpwn"); TransSparkle.PushV("YellowSpSpwn");
		}
		if((Args[3] & 8))
		{
			StarFnt.PushV("TeleGlitter4","GreenStar","GreenSparkle","GreenSparkleAccel"); StarFntRndm.PushV("RandomGreenParticle");
			TransStar.PushV("NoTrans"); TransSparkle.PushV("GreenSpSpwn");
		}
		if((Args[3] & 16))
		{
			StarFnt.PushV("TeleGlitter5","PurpleStar","PurpleSparkle","PurpleSparkleAccel"); StarFntRndm.PushV("RandomPurpleParticle");
			TransStar.PushV("PurpleStSpwn"); TransSparkle.PushV("PurpleSpSpwn");
		}
		if((Args[3] & 32))
		{
			StarFnt.PushV("TeleGlitter6","WhiteStar","WhiteSparkle","WhiteSparkleAccel"); StarFntRndm.PushV("RandomWhiteParticle");
			TransStar.PushV("WhiteStSpwn"); TransSparkle.PushV("NoTrans");
		}
	}
	void HP_RSFProcessData()
	{
		if(selectstar == "TeleGlitter1" || selectstar == "TeleGlitter2" || selectstar == "TeleGlitter3" || selectstar == "TeleGlitter4" || selectstar == "TeleGlitter5" || selectstar == "TeleGlitter6")
			{ ZVelocity = 0.25; itsaglitter = true; }
		
		else if(selectstar == "RedStar" || selectstar == "BlueStar" || selectstar == "OrangeStar" || selectstar == "GreenStar" || selectstar == "PurpleStar" || selectstar == "WhiteStar")
			{ ZVelocity = 0; whatstartext = "SKFXA0"; whatstarthinker = "StarSprite"; }
		
		else if(selectstar == "RedSparkle" || selectstar == "BlueSparkle" || selectstar == "YellowSparkle" || selectstar == "GreenSparkle" || selectstar == "PurpleSparkle" || selectstar == "WhiteSparkle")
			{ ZVelocity = frandom(1.0,4.0); whatstartext = "PTCLA0"; whatstarthinker = "SparkleSprite"; }
		
		else if(selectstar == "RedSparkleAccel" || selectstar == "BlueSparkleAccel" || selectstar == "YellowSparkleAccel" || selectstar == "GreenSparkleAccel" || selectstar == "PurpleSparkleAccel" || selectstar == "WhiteSparkleAccel")
			{ ZVelocity = frandom(0.25,2.0); whatstartext = "PTCLA0"; whatstarthinker = "SparkleAccelSprite"; }
	}
	void HP_RSFSpitThatStar()
	{
		if(hpack_particlemethod && !itsaglitter)
		{
			angle = random(0,359);
			sprkltex = TexMan.CheckForTexture(whatstartext);
			let p = Level.SpawnVisualThinker(whatstarthinker);
			if (p)
			{
				p.texture = sprkltex;
				p.pos = sprkcoord;
				p.vel = (0,0,ZVelocity);
				p.SetRenderStyle(STYLE_Add);
				p.LightLevel = 255;
				p.bAddLightLevel;
				if(whatstartext == "PTCLA0")
				{
					p.flags = SPF_ROLL;
					p.roll = random(0,359);
					p.alpha = 0.01;
					p.scale = (0.2,0.2);
					p.SetTranslation(selecttrans2);
				}
				else
				{
					p.alpha = 1.0;
					p.scale = (0.1,0.1);
					p.SetTranslation(selecttrans1);
				}
			}
		}
		else
		{
			angle = 0;
			A_SpawnItemEx(selectstar,random(-Args[0],Args[0]),0,random(0,2*Args[2]),0,0,ZVelocity,random(0,359),SXF_CLIENTSIDE);
			itsaglitter = false;
		}
	}
}