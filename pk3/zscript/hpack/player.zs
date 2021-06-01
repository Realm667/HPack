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
	See:
		PLAY A 5;
		PLAY B 5 H_Footstep(PLAYER_FOOT_LEFT);
		PLAY C 5;
		PLAY D 5 H_Footstep(PLAYER_FOOT_RIGHT);
		Goto Spawn;
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
