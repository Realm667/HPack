/*
 * HPack ZScript: Fountains
 *
 * Adapted from The Adventures of Square,
 * so big thanks to MTrop + Jimmy
 */

class HPFountain : SwitchableDecoration
{
	Default
	{
		Height 0;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+INVISIBLE;
		+CLIENTSIDEONLY;
	}

	States
	{
	Spawn:
	Active:
		TNT1 A 1;
		TNT1 A 1 H_SpawnFountainDroplets(HP_FOUNTAN_NUM_PARTICLES);
		Loop;
	Inactive:
		TNT1 A 1;
		Wait;
	}

	/**
	 * H_SpawnFountainDroplets
	 */
	void H_SpawnFountainDroplets(int amount)
	{
		for(int i = 0; i < amount; i++) {
			A_SpawnItemEx("FountainDroplet", frandom[HPEffectRandom](-5,5), frandom[HPEffectRandom](-5,5), frandom[HPEffectRandom](0,4), frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](2,HP_FOUNTAN_MAX_Z_VELOCITY), 0, SXF_TRANSFERTRANSLATION, 192);
			A_SpawnItemEx("TinyDroplet"    , frandom[HPEffectRandom](-5,5), frandom[HPEffectRandom](-5,5), 0                           , frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](2,HP_FOUNTAN_MAX_Z_VELOCITY), 0, SXF_TRANSFERTRANSLATION, 192);
		}
	}
}

class HPFountainLine : SwitchableDecoration
{
	//angle is line normal.
	//args[0] halfwidth

	Default
	{
		Height 0;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+INVISIBLE;
		+CLIENTSIDEONLY;
	}

	States
	{
	Spawn:
	Active:
		TNT1 A 1;
		TNT1 A 1 H_SpawnLineFountainDroplets(HP_FOUNTAN_NUM_PARTICLES);
		Wait;
	Inactive:
		TNT1 A 1;
		Wait;
	}

	/**
	 * H_SpawnLineFountainDroplets
	 */
	void H_SpawnLineFountainDroplets(int amount)
	{
		for(int i = 0; i < amount; i++) {
			A_SpawnItemEx("FountainDroplet", 0, frandom[HPEffectRandom](-args[0],args[0]), 0, frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](2,HP_FOUNTAN_MAX_Z_VELOCITY), 0, SXF_TRANSFERTRANSLATION, 192);
			A_SpawnItemEx("TinyDroplet"    , 0, frandom[HPEffectRandom](-args[0],args[0]), 0, frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](-2,2), frandom[HPEffectRandom](2,HP_FOUNTAN_MAX_Z_VELOCITY), 0, SXF_TRANSFERTRANSLATION, 192);
		}
	}
}

class FountainDroplet : Actor
{
	Default
	{
		Projectile;
		-NOGRAVITY;
		-NOBLOCKMONST;
		+THRUACTORS;
		+DONTSPLASH;
		+DONTBLAST;
		+BOUNCEONWALLS;
		+BOUNCEONCEILINGS;
		+CLIENTSIDEONLY;
		+FORCEXYBILLBOARD;

		Radius 1;
		Height 1;
	}
	States
	{
	Spawn:
		SPSH A 0 NoDelay H_RandomFlip();
		SPSH AAABBBAAABBBAAABBBAAA 1 A_FountainDropletCheck();
		Stop;
	Death:
	Crash:
		SPSH E 2 A_FountainDropletCrash();
		SPSH K 2;
		Stop;
	}

	/**
	 * H_RandomFlip
	 */
	void H_RandomFlip()
	{
		scale.x *= (random(0, 1) * 2 - 1);
		scale.y *= (random(0, 1) * 2 - 1);
	}

	/**
	 * A_FountainDropletCheck
	 */
	void A_FountainDropletCheck()
	{
		if( waterlevel > 0 ) {
			A_Die();
		}
	}

	/**
	 * A_FountainDropletCrash
	 */
	void A_FountainDropletCrash()
	{
		A_Stop();
		self.bNoGravity = true;
		// [XA] TODO: use this or remove it
//		if(waterlevel >= 2) {
//			A_SpawnItemEx("Bubble1", 0, 0, 0, 0, 0, random[HPEffectRandom](-2,-4), 0, 0, 160);
//		}
	}
}

class TinyDroplet : FountainDroplet
{
	States
	{
	Spawn:
		SPSH C 0 NoDelay H_RandomFlip();
		SPSH CDCD 3;
		Stop;
	}
}

class HPFountainBlue           : HPFountain { }
class HPFountainRed            : HPFountain { Default { Translation "192:208=145:168"; } }
class HPFountainBlack          : HPFountain { Default { Translation "192:208=0:14"   ; } }
class HPFountainGreen          : HPFountain { Default { Translation "192:208=209:223"; } }
class HPFountainOlive          : HPFountain { Default { Translation "192:208=225:240"; } }
class HPFountainPurple         : HPFountain { Default { Translation "192:208=169:176"; } }
class HPFountainWhite          : HPFountain { Default { Translation "192:208=16:35"  ; } }
class HPFountainYellow         : HPFountain { Default { Translation "192:208=120:136"; } }
class HPFountainGold           : HPFountain { Default { Translation "192:208=137:144"; } }
class HPFountainBrown          : HPFountain { Default { Translation "192:208=73:94"  ; } }
class HPFountainFire           : HPFountain { Default { Translation "192:208=247:241"; } }
class HPFountainIceGray        : HPFountain { Default { Translation "192:208=52:63"  ; } }
class HPFountainIceBlue        : HPFountain { Default { Translation "192:208=177:184"; } }

class HPFountainLineBlue       : HPFountainLine { }
class HPFountainLineRed        : HPFountainLine { Default { Translation "192:208=145:168"; } }
class HPFountainLineBlack      : HPFountainLine { Default { Translation "192:208=0:14"   ; } }
class HPFountainLineGreen      : HPFountainLine { Default { Translation "192:208=209:223"; } }
class HPFountainLineOlive      : HPFountainLine { Default { Translation "192:208=225:240"; } }
class HPFountainLinePurple     : HPFountainLine { Default { Translation "192:208=169:176"; } }
class HPFountainLineWhite      : HPFountainLine { Default { Translation "192:208=16:35"  ; } }
class HPFountainLineYellow     : HPFountainLine { Default { Translation "192:208=120:136"; } }
class HPFountainLineGold       : HPFountainLine { Default { Translation "192:208=137:144"; } }
class HPFountainLineBrown      : HPFountainLine { Default { Translation "192:208=73:94"  ; } }
class HPFountainLineFire       : HPFountainLine { Default { Translation "192:208=247:241"; } }
class HPFountainLineIceGray    : HPFountainLine { Default { Translation "192:208=52:63"  ; } }
class HPFountainLineIceBlue    : HPFountainLine { Default { Translation "192:208=177:184"; } }
