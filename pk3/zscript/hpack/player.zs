/**
 * HPack Player Definition (and friends)
 */

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

	bool footstepLeft; // left foot, right foot, left foot...
	int footstepTics;

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

	/**
	 * PostBeginPlay
	 *
	 * Initializes cvar accessors.
	 */
	override void PostBeginPlay()
	{
		cvars.footstepVolume = HPackCachedCvar.Create('hpack_footstep_volume', self.player);
		super.PostBeginPlay();
	}

	/**
	 * Tick tock.
	 */
	override void Tick()
	{
		super.Tick();

		H_PlayFootsteps();
	}

	/**
	 * H_PlayFootsteps
	 *
	 * A simple-ish footstep implementation that uses
	 * TERRAIN to figure out what sounds to play. If
	 * the player's grounded and moving, step to it!
	 */
	void H_PlayFootsteps()
	{
		// tick up the footstep timer first,
		// in case we abort early for any reason.
		// don't let it grow arbitrary large though;
		// that'd be an overflow waiting to happen. :P
		if(footstepTics <= HP_PLAYER_FOOTSTEP_RUN_TICS ||
		   footstepTics <= HP_PLAYER_FOOTSTEP_WALK_TICS) {
			footstepTics++;
		}

		// check if we're underwater. doesn't make
		// sense to play footsteps while swimming. :P
		if (waterlevel >= 3) {
			return;
		}

		// check if player is on the ground.
		// conveniently, floorz accounts for
		// 3D floors, so this is dead simple.
		if (pos.z > floorz) {
			return;
		}

		// if partially submerged, use a couple
		// of dedicated liquid footstep sounds
		sound leftSound;
		sound rightSound;
		if(waterlevel > 0) {
			leftSound = "footstep/liquid3/left";
			rightSound = "footstep/liquid3/right";
		} else {
			// otherwise, check to see if there's even a
			// terrain def for the floor the player
			// is standing on. no terrain, no sound.
			TerrainDef terrain = GetFloorTerrain();
			if (terrain == NULL) {
				return;
			}
			leftSound = terrain.LeftStepSound;
			rightSound = terrain.RightStepSound;
		}

		// next, check to see if the player is
		// moving quickly enough to warrant
		// a footstep. small nudges don't count.
		double playerVel = (player == NULL ? 0.0 : player.vel.Length() );
		if(playerVel < HP_PLAYER_FOOTSTEP_WALK_THRESHOLD) {
			return;
		}

		// note on the above: player.vel is the
		// player's "voluntary" velocity (i.e.
		// the direction the player is _trying_
		// to move), which is exactly what we
		// want here. don't wanna play footstep
		// noises if being pushed by a scrolling
		// floor or thrust by an explosion, etc.

		// finally, check the timer; if it's too
		// soon to play a footstep, bail out now.
		bool isRunning = (playerVel >= HP_PLAYER_FOOTSTEP_RUN_THRESHOLD);
		if((isRunning && footstepTics <= HP_PLAYER_FOOTSTEP_RUN_TICS) ||
		  (!isRunning && footstepTics <= HP_PLAYER_FOOTSTEP_WALK_TICS)) {
			return;
		}

		// we've now determined that it's time
		// to play a footstep sound, so grab it
		// from TERRAIN. left foot, right foot...
		sound footstepSound = (footstepLeft ? leftSound : rightSound);
		footstepLeft = !footstepLeft;

		// play the sound, using the player as
		// the origin, so it sounds correct even
		// when the player moves. friggin finally :P
		double footstepVolume = cvars.footstepVolume.Get().GetFloat();
		A_StartSound(footstepSound, HP_PLAYER_FOOTSTEP_CHANNEL, CHANF_OVERLAP, footstepVolume);

		// now reset the footstep timer,
		// and we'll all be done!
		footstepTics = 0;
	}
}
