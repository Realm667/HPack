/**
 * HPack Player Definition (and friends)
 */

enum EPlayerFoot
{
	PLAYER_FOOT_LEFT = 0,
	PLAYER_FOOT_RIGHT,
	NUM_PLAYER_FEET
}

struct HPackPlayerCVars
{
	HPackCachedCvar footstepVolume;
}

/**
 * Corvus says "hi"
 */
class HPackPlayer : HereticPlayer
{
	HPackPlayerCVars cvars;

	Default
	{
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		Painchance 255;
		Speed 1;
		Player.ColorRange 225, 240;
		Player.DisplayName "Sidhe";
		Player.StartItem "GoldWandAmmo", 50;
		Player.StartItem "HPWand";
		Player.StartItem "HPStaff";
		Player.WeaponSlot 1, "HPStaff", "HPGauntlets";
		Player.WeaponSlot 2, "HPWand";
		Player.WeaponSlot 3, "HPCrossbow";
		Player.WeaponSlot 4, "HPBlaster";
		Player.WeaponSlot 5, "HPSkull";
		Player.WeaponSlot 6, "HPPhoenix";
		Player.WeaponSlot 7, "HPMace";
		Player.WeaponSlot 8, "HPSunStaff";
		Player.WeaponSlot 9, "HPDSparilGauntlets";
		Player.WeaponSlot 0, "HPMorphWand", "HPStaffChaos";
	}

	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	See:
		PLAY A 5;
		PLAY B 5 H_Footstep(PLAYER_FOOT_LEFT);
		PLAY C 5;
		PLAY D 5 H_Footstep(PLAYER_FOOT_RIGHT);
		Goto Spawn;
	Melee:
	Missile:
		PLAY F 6 BRIGHT;
		PLAY E 12;
		Goto Spawn;
	Pain:
		PLAY G 4;
		PLAY G 4 A_Pain();
		Goto Spawn;
	Death:
		PLAY H 6 A_PlayerSkinCheck("AltSkinDeath");
		PLAY I 6 A_PlayerScream();
		PLAY JK 6;
		PLAY L 6 A_NoBlocking();
		PLAY MNO 6;
		PLAY P -1;
		Stop;
	XDeath:
		PLAY Q 0 A_PlayerSkinCheck("AltSkinXDeath");
		PLAY Q 5 A_PlayerScream();
		PLAY R 0 A_NoBlocking();
		PLAY R 5 A_SkullPop();
		PLAY STUVWX 5;
		PLAY Y -1;
		Stop;
	Burn:
		FDTH A 5 BRIGHT A_StartSound("*burndeath");
		FDTH B 4 BRIGHT;
		FDTH C 5 BRIGHT;
		FDTH D 4 BRIGHT A_PlayerScream();
		FDTH E 5 BRIGHT;
		FDTH F 4 BRIGHT;
		FDTH G 5 BRIGHT A_StartSound("*burndeath");
		FDTH H 4 BRIGHT;
		FDTH I 5 BRIGHT;
		FDTH J 4 BRIGHT;
		FDTH K 5 BRIGHT;
		FDTH L 4 BRIGHT;
		FDTH M 5 BRIGHT;
		FDTH N 4 BRIGHT;
		FDTH O 5 BRIGHT A_NoBlocking();
		FDTH P 4 BRIGHT;
		FDTH Q 5 BRIGHT;
		FDTH R 4 BRIGHT;
		ACLO E 35 A_CheckPlayerDone();
		Wait;
	AltSkinDeath:
		PLAY H 10;
		PLAY I 10 A_PlayerScream();
		PLAY J 10 A_NoBlocking();
		PLAY KLM 10;
		PLAY N -1;
		Stop;
	AltSkinXDeath:
		PLAY O 5;
		PLAY P 5 A_XScream();
		PLAY Q 5 A_NoBlocking();
		PLAY RSTUV 5;
		PLAY W -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		cvars.footstepVolume = HPackCachedCvar.Create('hpack_footstep_volume', self.player);
		super.PostBeginPlay();
	}

	void H_Footstep(EPlayerFoot foot)
	{
		// check if player is on the ground.
		// conveniently, floorz accounts for
		// 3D floors, so this is dead simple.
		if (pos.z > floorz) {
			return;
		}

		// not much to do if there ain't no terrain.
		TerrainDef terrain = GetFloorTerrain();
		if (terrain == NULL) {
			return;
		}

		// play the sound, using the player as
		// the origin, so it sounds correct even
		// when the player moves. friggin finally :P
		sound footstepSound = (foot == PLAYER_FOOT_LEFT ? terrain.LeftStepSound : terrain.RightStepSound);
		double footstepVolume = cvars.footstepVolume.Get().GetFloat();
		A_StartSound(footstepSound, HP_PLAYER_FOOTSTEP_CHANNEL, CHANF_OVERLAP, footstepVolume);
	}
}
