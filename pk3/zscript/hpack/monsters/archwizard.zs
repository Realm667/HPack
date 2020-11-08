class ArchWizard : Heresiarch
{
	const ARCHWIZARD_LOSEFIRSTBALL_THRESHOLD = 0.50;
	const ARCHWIZARD_LOSESECONDBALL_THRESHOLD = 0.25;

	enum EArchwizardAttack
	{
		ARCHWIZARD_ATTACK_LASER = 0,
		ARCHWIZARD_ATTACK_SUMMON,
		ARCHWIZARD_ATTACK_ACID,
		NUM_ARCHWIZARD_ATTACKS
	}

	SorcBall balls[NUM_ARCHWIZARD_ATTACKS];
	int lastAttack;
	int numBalls;

	Default
	{
		//$Category Monsters
		//$Title Arch Wizard

		Speed 7;
		Radius 40;
		Height 88;
		Health 1200;
		PainChance 32;
		Mass 0x7fffffff;
		Damage 0;

		DamageFactor "Poison", 0.0; // lazy self-poison immunity

		SeeSound "archwizard/sight";
		DeathSound "archwizard/death";
		ActiveSound "archwizard/active";
		PainSound "archwizard/pain";
		BloodType "WizardPurpleBlood";

		Obituary "$OB_ARCHWIZARD";
		Tag "$FN_ARCHWIZARD";

		+BOSS;
		+NOBLOODDECALS;
	}

	States
	{
	Spawn:
		ARCM A 10 A_Look();
		Wait;
	See:
		ARCM AABB 3 A_Chase();
		ARCM A 0 A_Jump(16, "Teleport");
		Loop;
	Pain:
		ARCM A 4 A_Pain();
		Goto Teleport;
	Teleport:
		ARCM A 1 H_ArchwizardTeleportStart();
		ARCM AAAAAAAAA 1 H_ArchwizardFadeOut();
		TNT1 A 1 H_ArchwizardTeleport();
		ARCM AAAAAAAAA 1 H_ArchwizardFadeIn();
		ARCM A 1 H_ArchwizardTeleportEnd();
		Goto See;
	Missile:
		ARCM D 8 H_ArchwizardChooseAttack();
		Goto See;
	AttackLaser:
		ARCM D 0 A_StartSound("archwizard/attack3");
		ARCM DCDCD 4 Bright A_FaceTarget();
		ARCM C 8 Bright H_ArchwizardLaserAttack();
		ARCM D 8 A_FaceTarget();
		Goto See;
	AttackSummon:
		ARCM D 0 A_StartSound("archwizard/attack1");
		ARCM DMDMD 4 Bright A_FaceTarget();
		ARCM M 4 Bright H_ArchwizardSummonFX();
		ARCM D 4 Bright A_FaceTarget();
		ARCM M 8 Bright H_ArchwizardSummon();
		ARCM D 8 A_FaceTarget();
		Goto See;
	AttackAcid:
		ARCM D 0 A_StartSound("archwizard/attack2");
		ARCM DNDND 4 Bright A_FaceTarget();
		ARCM N 8 Bright H_ArchwizardAcidAttack();
		ARCM D 8 A_FaceTarget();
		Goto See;
	Death:
		ARCM E 8 Bright A_Scream();
		ARCM F 8 Bright;
		ARCM G 6 Bright H_ArchwizardSkeltalInsideU();
		ARCM H 6 Bright A_NoBlocking();
		ARCM IJ 6 Bright;
		ARCM K -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		// most of this is yoinked from the heresiarch,
		// so it's kinda magic.

		// [XA] TODO: just copy over the stuff we need
		// instead of relying on all the heresiarch bullshit :P

		args[0] = 0;
		args[2] = Heresiarch.SORCBALL_INITIAL_SPEED;
		args[3] = Heresiarch.SORC_NORMAL;
		args[4] = Heresiarch.SORCBALL_INITIAL_SPEED;
		self.BallAngle = 1.0;

		balls[ARCHWIZARD_ATTACK_LASER ] = H_ArchwizardSpawnBall("SorcBall1");
		balls[ARCHWIZARD_ATTACK_SUMMON] = H_ArchwizardSpawnBall("SorcBall2");
		balls[ARCHWIZARD_ATTACK_ACID  ] = H_ArchwizardSpawnBall("SorcBall3");

		numBalls = NUM_ARCHWIZARD_ATTACKS;
		lastattack = -1;
	}

	override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
	{
		// if enough damage has been taken, lose a ball. do two
		// separate checks, since we may want to lose two balls at once
		// in case a whole lot of damage was dealt simultaneously somehow.

		double spawnHealth = double(SpawnHealth());
		double newHealthPercent = spawnHealth == 0.0 ? 0.0 : ((self.health - damage) / spawnHealth);

		if(numballs == NUM_ARCHWIZARD_ATTACKS && newHealthPercent < ARCHWIZARD_LOSEFIRSTBALL_THRESHOLD) {
			H_ArchwizardLoseBall();
			bMISSILEMORE = true;
		}
		if(numballs == NUM_ARCHWIZARD_ATTACKS-1 && newHealthPercent < ARCHWIZARD_LOSESECONDBALL_THRESHOLD) {
			H_ArchwizardLoseBall();
			bMISSILEEVENMORE = true;
		}

		// don't take any damage from self or ball explosions
		if(source == inflictor || source is "SorcBall") {
			return 0;
		}

		// otherwise, leave the damage alone
		return damage;
	}

	SorcBall H_ArchwizardSpawnBall(class<Actor> ballClass)
	{
		Actor ball = Spawn(ballClass, pos, NO_REPLACE);
		if (ball) {
			ball.target = self;
		}
		return SorcBall(ball);
	}

	void H_ArchwizardLoseBall()
	{
		// pop off whichever ball corresponds to the
		// most-recently-used attack -- or if none,
		// just pick the first available one in the list.
		int ballToRemove = -1;

		if(lastAttack > 0 && lastattack < NUM_ARCHWIZARD_ATTACKS) {
			ballToRemove = lastAttack;
		} else {
			for(int i = 0; i < NUM_ARCHWIZARD_ATTACKS; i++) {
				if(balls[i]) {
					ballToRemove = i;
				}
			}
		}

		if(ballToRemove < 0) {
			A_Log("ArchWizard::H_ArchwizardLoseBall: Could not determine which ball to remove. This shouldn't happen!");
			return;
		}

		balls[ballToRemove].target = NULL;
		balls[ballToRemove] = NULL;
		lastAttack = -1;
		numballs--;
	}

	void H_ArchwizardTeleportStart()
	{
		A_UnSetshootable();
		A_FaceTarget();
		A_StartSound("misc/teleport");
	}

	void H_ArchwizardFadeOut()
	{
		A_FadeOut(0.1, FTF_CLAMP);
	}

	void H_ArchwizardTeleport()
	{
		// [XA] pretty low-tech way of doing this
		// nowadays, but hey, it works... ;)
		for(int i = 0; i < 102; i++) {
			A_Wander();
		}
		A_StartSound("misc/teleport");
	}

	void H_ArchwizardFadeIn()
	{
		A_FadeIn(0.1, FTF_CLAMP);
	}

	void H_ArchwizardTeleportEnd()
	{
		A_SetTranslucent(1.0, 0);
		A_SetShootable();
		A_FaceTarget();
	}

	state H_ArchwizardChooseAttack()
	{
		// select an attack randomly from the pool of
		// available attacks (i.e. which balls are left)
		int ballsToCheck = self.numBalls;
		for(int i = 0; i < NUM_ARCHWIZARD_ATTACKS; ++i) {

			// if the ball is gone, skip it.
			if(!balls[i]) {
				continue;
			}

			// if the ball is there, roll the dice
			if(random(0, ballsToCheck-1) == 0) {
				self.lastAttack = i;
				switch(i) {
					case ARCHWIZARD_ATTACK_LASER:
						return FindState("AttackLaser");
					case ARCHWIZARD_ATTACK_SUMMON:
						return FindState("AttackSummon");
					case ARCHWIZARD_ATTACK_ACID:
						return FindState("AttackAcid");
				}
			}

			// keep searchin' -- reduce the check pool
			// a bit so the diceroll chances work out.
			ballsToCheck--;
		}

		// we probably shouldn't be here...
		A_Log("ArchWizard::H_ArchwizardChooseAttack: Could not determine which attack to use. This shouldn't happen!");
		return NULL;
	}

	void H_ArchwizardLaserAttack()
	{
		A_SpawnProjectile("ArchWizardLaser", 48, 0, 0, 0);
	}

	void H_ArchwizardSummonFX()
	{
		A_SpawnProjectile("ArchWizardSummonPulse", 36, 0, 0, 0);
		A_StartSound("archwizard/summon", CHAN_5);
	}

	void H_ArchwizardSummon()
	{
		// A_PainAttack hardcodes the spawn height to 8 units above
		// the caller's height (which is hella low), so temporarily
		// offset the archwizard's Z position a bit so the wraith
		// spawn doesn't look totally stupid. :P
		Vector3 oldpos = pos;
		self.SetXYZ(pos + (0, 0, 16.0));
		A_PainAttack("HPWraith", 0, 0, 0);
		self.SetXYZ(oldpos);
	}

	void H_ArchwizardAcidAttack()
	{
		H_ArchwizardFireAcidShot(-4.0, -4, 32);
		H_ArchwizardFireAcidShot( 4.0,  4,  0);
	}

	void H_ArchwizardFireAcidShot(double xyOffset, int cloudHorzSpeed, int shotWeaveIndex)
	{
		Actor mo = A_SpawnProjectile("ArchWizardAcidShot", 48, xyOffset, 0, 0);
		if(mo) {
			mo.vel = mo.speed * mo.Vec3To(self.target).Unit(); // aim at target's feet
			mo.args[0] = cloudHorzSpeed;
			mo.WeaveIndexXY = shotWeaveIndex;
		}
	}

	void H_ArchwizardSkeltalInsideU()
	{
		A_StartSound("archwizard/explode");
		A_SpawnItemEx("ArchWizardSkeleton", flags: SXF_NOCHECKPOSITION);
	}
}

class ArchWizardSkeleton : Actor
{
	Default
	{
	+NOINTERACTION
	}

	States
	{
	Spawn:
		SKLD A 32;
		SKLD B 5 A_StartSound("archwizard/bones");
		SKLD CDEFGH 5;
		SKLD I -1;
		stop;
	}
}

class ArchWizardLaser : Actor
{
	Vector3 bounceVec;

	Default
	{
		Projectile;

		Radius 10;
		Height 6;
		Speed 20;
		FastSpeed 25;
		Damage 5;
		RenderStyle "Add";

		SeeSound "archwizard/laserfire";
		DeathSound "misc/magichit";

		BounceFactor 1.0;
		WallBounceFactor 1.0;
		BounceCount 3;

		-ACTIVATEIMPACT;
		-ACTIVATEPCROSS;
		+SEEKERMISSILE;
		+BOUNCEONWALLS;
		+BOUNCEONFLOORS;
		+BOUNCEONCEILINGS;
		+CANBOUNCEWATER;
		+USEBOUNCESTATE;
	}

	States
	{
	Spawn:
		SBS4 AA 1 Bright H_ArchwizardLaserTrail(0);
		SBS4 BB 1 Bright H_ArchwizardLaserTrail(1);
		SBS4 CC 1 Bright H_ArchwizardLaserTrail(2);
		Loop;
	Bounce:
		SBS4 A 2 Bright H_ArchwizardLaserBounce();
		SBS4 BCABC 2 Bright;
		SBS4 A 0 Bright H_ArchwizardLaserSeek();
		Goto Spawn;
	Death:
		SBFX HIJKL 5 Bright;
		Stop;
	}

	void H_ArchwizardLaserTrail(int trailFrame)
	{
		bool spawned;
		Actor trail;
		[spawned, trail] = A_SpawnItemEx("ArchWizardLaserTrail", flags: SXF_NOCHECKPOSITION);

		if(trail) {
			trail.frame = trailFrame;
		}
	}

	void H_ArchwizardLaserBounce()
	{
		A_StartSound("archwizard/laserbounce1");
		A_SpawnItemEx("ArchWizardLaserPulse", flags: SXF_NOCHECKPOSITION);

		// store current bounce velocity, then halt in place for a moment
		self.bounceVec = self.vel;
		self.vel = (0, 0, 0);
	}

	void H_ArchwizardLaserSeek()
	{
		// if the tracer is in sight, "bounce" straight at 'em.
		// otherwise, use the stored vector to do a normal bounce.
		if(CheckSight(self.tracer)) {
			A_StartSound("archwizard/laserbounce2");
			Vector3 targetPos = (self.tracer.pos.x, self.tracer.pos.y, self.tracer.pos.z + self.tracer.height/2);
			self.vel = self.speed * LevelLocals.Vec3Diff(self.pos, targetPos).Unit();
		} else {
			self.vel = self.bounceVec;
		}
	}
}

class ArchWizardLaserTrail : Actor
{
	Default
	{
		+NOINTERACTION;
		RenderStyle 'Add';
	}

	States
	{
	Spawn:
		SBS4 A 1 Bright A_FadeOut(0.2);
		Loop;
	}
}

class ArchWizardLaserPulse : ArchWizardLaserTrail
{
	States
	{
	Spawn:
		SBFX ABCDEFG 4 Bright;
		Stop;
	}
}

class ArchWizardSpark : ArchWizardLaserTrail
{
	States
	{
	Spawn:
		FX11 G 1 Bright Light("DISCIPLEBALL_X2") A_FadeOut (0.1);
		Loop;
	}
}

class ArchWizardAcidShot : Actor
{
	Default
	{
		Radius 5;
		Height 5;
		Speed 15;
		FastSpeed 20;
		Damage 2;
		RenderStyle 'Add';
		Alpha 0.8;

		Seesound "archwizard/acidfire";
		DeathSound "archwizard/acidhit";

		Projectile;
		+THRUGHOST;
	}

	States
	{
	Spawn:
		GHFX AB 2 Bright H_SpawnAcidTrail();
		loop;
	Death:
		GHFX CD 4 Bright;
		GHFX E 4 Bright H_SpawnAcidCloud();
		GHFX F 4 Bright;
		stop;
	}

	void H_SpawnAcidTrail()
	{
		Spawn("ArchWizardAcidTrail", pos);
		A_Weave(4, 0, 2.0, 0.0);
	}

	void H_SpawnAcidCloud()
	{
		A_SpawnItemEx("ArchWizardAcidCloud", yvel: args[0], flags: SXF_TRANSFERPOINTERS);
	}
}

class ArchWizardAcidCloud : PoisonCloud
{
	Default
	{
		Height 48;
		DamageType "Poison";
		RenderStyle "Add";
		Alpha 0.667;
		ReactionTime 7;
	}

	States
	{
	Spawn:
		GGAS A 5 Bright;
		GGAS B 5 Bright H_AcidCloudStartSounds();
	IntestinalDistress:
		GGAS CDEFGFED 5 Bright A_PoisonBagDamage();
		GGAS A 0 Bright A_Countdown();
		Loop;
	Death:
		GGAS CDEFGFED 5 Bright H_AcidCloudFade();
		loop;
	}

	override void Tick()
	{
		Super.Tick();

		// float upward a bit if too low to the ground
		//self.vel.z = (self.pos.z < self.floorz+24 ? 1.0 : 0.0);
		double zTargetHeight = 24.0;
		self.vel.z = clamp((self.floorz+zTargetHeight - self.pos.z) / zTargetHeight, 0.0, 1.0);

		// reduce xy velocity a tiny bit each frame;
		self.vel.xy *= 0.9;
	}

	void H_AcidCloudStartSounds()
	{
		A_StartSound("archwizard/acidcloud");
		A_StartSound("archwizard/acidloop", CHAN_5, CHANF_LOOP);
	}

	void H_AcidCloudFade()
	{
		A_PoisonBagDamage();
		A_FadeOut(0.1);
	}
}

class ArchWizardAcidTrail : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		RenderStyle 'Add';
		Alpha 0.75;
		Gravity 0.33;
		+DONTSPLASH;
	}

	States
	{
	Spawn:
		TNT1 A 1;
		SSFX ABCDEFGH 2 Bright;
		Stop;
	}
}

class ArchWizardSummonPulse : ArchWizardLaserTrail
{
	States
	{
	Spawn:
		SBS5 ABCDEFG 4 Bright;
		Stop;
	}
}
