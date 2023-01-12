/*
 * HPack ZScript: Arcane Soul Vortex (my new band name)
 */

class HPVortex : SwitchableDecoration
{
	//$Category HPack_SpecialEffects
	//$Title Soul Vortex
	//$Sprite MUMMA0

	//$NotAngled

	//$Arg0 Radius
	//$Arg0Default 128

	//$Arg1 Height
	//$Arg1Default 256

	//$Arg2 Twist Angle
	//$Arg2Default 45

	//$Arg3 Twist Velocity Percent (for precision, yo)
	//$Arg3Default 300

	//$Arg4 Fail Chance
	//$Arg4Default 0

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
		TNT1 A 1 H_SpawnVortexSouls(HP_VORTEX_NUM_SOULS_PER_TIC);
		Wait;
	Inactive:
		TNT1 A 1;
		Wait;
	}

	/**
	 * H_SpawnVortexSouls
	 */
	void H_SpawnVortexSouls(int amount)
	{
		double pct = frandom(0.1, 1.0);
		for(int i = 0; i < amount; i++) {
			A_SpawnItemEx("HPVortexSoul", 
				xofs: args[0] * pct, 
				yofs: 0,
				zofs: args[1] * pct,
				xvel: args[3] * cos(args[2] + 180) * 0.01 * pct,
				yvel: args[3] * sin(args[2] + 180) * 0.01 * pct,
				zvel: frandom[HPEffectRandom](-3,-4),
				angle: frandom(0, 360),
				flags: 0,
				failchance: args[4]
			);
		}
	}
}

class HPVortexSoul : Actor
{
	Default
	{
		+NOGRAVITY;
		+THRUACTORS;
		+DONTSPLASH;
		+DONTBLAST;
		+CLIENTSIDEONLY;
		+FORCEXYBILLBOARD;

		Radius 1;
		Height 1;
		YScale -1.0;
		Translation "5:31=169:176", "36:43=169:176", "44:44=183:183";
		Alpha 0.1;
		Renderstyle "Add";
	}

	States
	{
	Spawn:
		MUMM RRRRSSSST 2 Bright A_FadeIn(0.1);
		MUMM T 12 Bright A_SetTranslucent(1.0, 1);
		MUMM UVW 6 Bright;
		Stop;
	}
}

class HPVortexRock : Actor
{
	Default
	{
		Projectile;
		+THRUACTORS;
		+DONTBLAST;
		+CLIENTSIDEONLY;
		+FORCEXYBILLBOARD;
		Damage 0;
		Speed 20;
		Radius 1;
		Height 1;
	}

	States
	{
	Spawn:
		RCK1 A 0 NoDelay H_VortexRockInit();
	Spawn1:
		RCK1 A -1;
		Stop;
	Spawn2:
		RCK2 A -1;
		Stop;
	}

	/**
	 * H_VortexRockInit
	 */
	state H_VortexRockInit()
	{
		double scale = frandom(0.5, 1.0);
		self.scale.x = scale * ( random(0, 1) * 2 - 1 );
		self.scale.y = scale * ( random(0, 1) * 2 - 1 );
		return A_Jump(256, "Spawn1", "Spawn2");
	}
}

class HPVortexRockSpawner : Actor
{
	//$Category HPack_SpecialEffects
	//$Title Vertical Rock Spawner

	//$Arg0 X range
	//$Arg0Default 128

	//$Arg1 Y range
	//$Arg1Default 128

	//$Arg2 Fail Chance
	//$Arg2Default 0

	//$Arg3 Velocity Percent
	//$Arg3Default 0

	//$Arg4 Scale Percent
	//$Arg4Default 0

	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+NOSECTOR
		+NOINTERACTION
		+NOCLIP
		-SOLID
		+CLIENTSIDEONLY
	}

	States
	{
	Spawn:
	Active:
		TNT1 A 1 NoDelay H_SpawnVortexRock();
		Loop;
	Inactive:
		TNT1 A 1;
		Loop;
	}

	/**
	 * H_SpawnVortexRock
	 */
	void H_SpawnVortexRock()
	{
		double velPercent = 1.0f;
		if(Args[3] > 0) {
			velPercent = 0.01 * Args[3];
		}

		double scalePercent = 1.0f;
		if(Args[4] > 0) {
			scalePercent = 0.01 * Args[4];
		}

		bool spawned;
		Actor rock;

		[spawned, rock] = A_SpawnItemEx( "HPVortexRock",
			xofs: frandom(-Args[0], Args[0]),
			yofs: frandom(-Args[1], Args[1]),
			zvel: frandom(20.0, 40.0) * velPercent,
			angle: angle,
			flags: SXF_CLIENTSIDE,
			failchance: Args[2]
		);

		if(rock) {
			rock.scale.x *= scalePercent;
			rock.scale.y *= scalePercent;
		}
	}
}

// Special FX for H4M8's final sky

class HPSkySoul : Actor
{
	Default
	{
		+NOGRAVITY;
		+THRUACTORS;
		+DONTSPLASH;
		+DONTBLAST;
		+CLIENTSIDEONLY;
		+FORCEYBILLBOARD;

		Radius 1;
		Height 1;
	}

	States
	{
	Spawn:
		XSOL A 200 Bright;
		XSOL # 1 Bright A_FadeOut(0.01);
		Wait;
	Precache:
		XSOL ABCDE 0;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		self.frame = frandom(0,4);
	}
}

class HPSkySoulSpawner : Actor
{
	enum ESkySoulSpawnerArgs
	{
		ARG_RADIUS,
		ARG_FREQ
	}

	Default
	{
		//$Category HPack_SpecialEffects
		//$Title Sky Souls
		//$Sprite XSOLA0

		//$NotAngled

		//$Arg0 Radius
		//$Arg0Default 128

		//$Arg1 Frequency
		//$Arg1Tooltip The lower the number, the more frequent the spawn rate.

		Height 1;
		Radius 1;

		+CLIENTSIDEONLY
		+NOINTERACTION
	}

	override void Tick ()
	{
		Super.Tick();

		if (!isFrozen())
		{
			A_SpawnItemEx("HPSkySoul",
				xofs: Random(-args[ARG_RADIUS], args[ARG_RADIUS]),
				zofs: 2,
				zvel: 8.0,
				angle: Random(0, 359),
				flags: SXF_CLIENTSIDE,
				failchance: args[ARG_FREQ]
			);
		}
	}
}
