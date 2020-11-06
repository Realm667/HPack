class ArchWizard : Heresiarch
{
	Default
	{
		//$Category Monsters
		//$Title Arch Wizard

		Speed 7;
		Radius 40;
		Height 88;
		Health 1000;
		PainChance 32;
		Mass 0x7fffffff;
		Damage 0;

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
		ARCM A 3;
		ARCM A 2 A_SorcSpinBalls();
	Idle:
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
		ARCM D 0 A_StartSound("archwizard/attack3");
		ARCM DCDCD 4 Bright A_FaceTarget();
		ARCM C 8 Bright H_ArchwizardFireLaser();
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

	void H_ArchwizardFireLaser()
	{
		A_SpawnProjectile("ArchWizardLaser", 48, 0, 0, 0);
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
		SBS4 A 0 Bright H_ArchwizardLaserSpawn();
	Fly:
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

	void H_ArchwizardLaserSpawn()
	{
		A_SpawnItemEx("ArchWizardLaserPulse", flags: SXF_NOCHECKPOSITION);
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
