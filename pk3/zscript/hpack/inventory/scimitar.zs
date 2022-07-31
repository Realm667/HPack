/*
 * HPack ZScript: Scimitar of the Sages
 * (c) Xaser Acheron, MIT License, etc.
 *
 * Fires a wide-range sweeping arc attack. 'Nuff said.
 */

class ArtiScimitar : CustomInventory
{
	Default
	{
		// $Category Artifacts
		// $Title Scimitar of the Sages

		+COUNTITEM;
		+FLOATBOB;
		+INVENTORY.INVBAR;
		+INVENTORY.FANCYPICKUPSOUND;

		Inventory.DefMaxAmount;
		Inventory.Icon "ARTISCIM";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_ARTISCIMITAR";
		Inventory.PickupFlash "PickupFlash";
		Tag "$TAG_ARTISCIMITAR";
	}

	States
	{
	Spawn:
		ASCI A -1 Bright;
		Loop;
	Use:
		TNT1 A 0 H_ScimitarAttack();
		Stop;
	}

	action void H_ScimitarAttack()
	{
		// the actual attack
		H_ScimitarWave("ScimitarWaveEdge"  ,-64.0);
		H_ScimitarWave("ScimitarWaveEdge"  ,-48.0);
		H_ScimitarWave("ScimitarWaveEdge"  ,-32.0);
		H_ScimitarWave("ScimitarWaveEdge"  ,-16.0);
		H_ScimitarWave("ScimitarWaveCenter",  0.0);
		H_ScimitarWave("ScimitarWaveEdge"  , 16.0);
		H_ScimitarWave("ScimitarWaveEdge"  , 32.0);
		H_ScimitarWave("ScimitarWaveEdge"  , 48.0);
		H_ScimitarWave("ScimitarWaveEdge"  , 64.0);

		// swingy sword fx
		Actor SWORDS = invoker.Spawn("ScimitarSword", invoker.owner.Vec3Angle(24.0, invoker.owner.angle, 28.0 - invoker.owner.floorclip), ALLOW_REPLACE);
		if (SWORDS) {
			SWORDS.target = invoker.owner;
		}
	}

	action void H_ScimitarWave(Class<Actor> waveActor, double offset)
	{
		Actor WAVE = A_FireProjectile(waveActor, spawnofs_xy: offset);
		if (WAVE) {
			WAVE.pitch = self.pitch;
		}
	}
}

class ScimitarSword : Actor
{
	Default
	{
		DeathSound "misc/timebomb";

		+NOGRAVITY;
	}

	States
	{
	Spawn:
		SCIM ABCD 3 Bright;
		SCIM E 1 Bright A_FadeOut(0.2);
		Wait;
	}
}

Class ScimitarWaveEdge : Actor
{
	Array<Actor> hitActors;

	Default
	{
		DamageFunction(50);
		Radius 8;
		Height 6;
		Speed 15;

		Obituary "$OB_MPSCIMITAR";
		RenderStyle "None";
		Alpha 1.0;

		Projectile;
		-ACTIVATEIMPACT;
		-ACTIVATEPCROSS;
		+RIPPER;
	}

	States
	{
	Spawn:
		SWAV A 10 Bright;
	Death:
		SWAV A 1 Bright A_FadeOut(0.1);
		Wait;
	}

	override int DoSpecialDamage(Actor target, int damage, Name damagetype)
	{
		// check if we've already hit this actor once and
		// bail out if so; makes rippers slightly less OP.
		if(hitActors.Find(target) < hitActors.Size()) {
			return 0;
		}

		// not found? then damage, dammit!
		hitActors.Push(target);
		return damage;
	}
}

Class ScimitarWaveCenter : ScimitarWaveEdge
{
	Default
	{
		SeeSound "artifacts/scimitar";
		RenderStyle "Add";
		XScale 2.0;

		+FLATSPRITE;
	}

	override void Tick()
	{
		Super.Tick();

		if(level.frozen) {
			return;
		}

		// spawn ye trail
		Actor trail = Spawn("ScimitarTrail", self.pos);
		if (trail) {
			trail.angle = self.angle;
			trail.pitch = self.pitch;
			trail.alpha = self.alpha;
			trail.scale = self.scale;
			trail.vel.z = -1.0;
		}
	}
}

Class ScimitarTrail : Actor
{
	Default
	{
		Alpha 1.0;
		RenderStyle "Add";
		+NOINTERACTION;
		+FLATSPRITE;
	}

	States
	{
	Spawn:
		SWAV A 1 Bright A_FadeOut(0.1);
		Wait;
	}
}
