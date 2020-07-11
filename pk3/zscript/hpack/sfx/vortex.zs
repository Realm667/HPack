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
