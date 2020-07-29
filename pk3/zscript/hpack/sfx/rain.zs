// ------------------------------------------------------------------------------------------------
//
//	 Special effect: Rain
//
//	 Place the RainSpawner on your map, and use values set on the specials tab to modify it.
//
//	 * The first argument controls area. 128, for example makes it a 256x256 square or 256-radius
//	   circle (See fourth argument).
//	 * The second argument controls frequency. The lower the number, the heavier the rainfall.
//	 * The third argument controls whether or not it plays its ambient sound. 0 will play the sound,
//	   1 will not.
//	 * The fourth argument controls the area type. 0 is square, 1 is circle.
//
//	 The spawner code is originally by Tormentor667 and Ghastly, re-written by Blue Shadow.
//
// ------------------------------------------------------------------------------------------------

class RainSpawner : Actor
{
	enum ERainSpawnerArgs
	{
		ARG_AREA,
		ARG_FREQ,
		ARG_SOUND,
		ARG_AREATYPE
	}

	// If the player is this value (or greater) away from the spawner, the rain will not fall.
	// Note that this value is added to the coverage area (ARG_AREA).
	const CRP_DISTANCE = 768.0;

	Default
	{
		//$Category HPack_SpecialEffects
		//$Title Rain
		//$Sprite SPSHH0

		//$NotAngled

		//$Arg0 Area
		//$Arg0Default 128

		//$Arg1 Frequency
		//$Arg1Tooltip The lower the number, the heavier the rainfall.

		//$Arg2 Sound
		//$Arg2Type 11
		//$Arg2Enum { 0 = "Yes"; 1 = "No"; }

		//$Arg3 Area type
		//$Arg3Type 11
		//$Arg3Enum { 0 = "Square"; 1 = "Circle"; }

		Height 1;
		Radius 1;
		SeeSound "Ambient/Rain";

		+CLIENTSIDEONLY
		+NOINTERACTION
		+SPAWNCEILING
	}

	override void PostBeginPlay ()
	{
		Super.PostBeginPlay();

		// If ARG_SOUND is less than 1, play the sound.
		if (args[ARG_SOUND] <= 0)
		{
			A_StartSound(SeeSound, CHAN_BODY, CHANF_LOOPING);
		}
	}

	override void Tick ()
	{
		Super.Tick();

		if (!isFrozen() && !(level.maptime % 2) && !CheckRange(CRP_DISTANCE + args[ARG_AREA], true))
		{
			// If ARG_AREATYPE is greater than zero, the area type is circle, otherwise it's square.
			if (args[ARG_AREATYPE] > 0)
			{
				A_SpawnItemEx("RainDrop", Random(-args[ARG_AREA], args[ARG_AREA]), 0, -2, 0, 0, 0, Random(0, 359),
					SXF_CLIENTSIDE, args[ARG_FREQ]);
			}
			else
			{
				A_SpawnItemEx("RainDrop", Random(-args[ARG_AREA], args[ARG_AREA]), Random(-args[ARG_AREA], args[ARG_AREA]), -2, 0, 0, 0, 0,
					SXF_CLIENTSIDE, args[ARG_FREQ]);
			}
		}
	}
}

class RainDrop : Actor
{
	Default
	{
		Alpha 0.8;
		Height 2;
		Radius 2;
		RenderStyle "Translucent";
		YScale 1.6;

		+DONTSPLASH
		+MISSILE
		+NOBLOCKMAP
	}

	States
	{
	Spawn:
		RNDR A 1 A_JumpIf(waterlevel > 0, "Death");
		Loop;

	Death:
		RNDR BCDEFGH 3 A_FadeOut(0.15);
		Stop;
	}
}
