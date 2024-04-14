// Phoenix Rod -------------------------------------------------------

class HPPhoenix : PhoenixRod replaces PhoenixRod
{
Default
	{
	//$Category Weapons
	//$Title Phoenix Rod
	Weapon.SelectionOrder 2500;
	Weapon.Sisterweapon "HPPhoenixPowered";
	Tag "$TAG_PHOENIXROD";
	}
	States
    {
	Ready:
		PHNX A 1 A_WeaponReady();
		Loop;
	Deselect:
		PHNX A 1 A_Lower();
		Loop;
	Select:
		PHNX A 1 A_Raise();
		Loop;
    Fire:
    	PHNX B 5 Bright A_StartSound("weapons/phoenixshoot2",CHAN_AUTO);
    	PHNX C 7 Bright { A_FireProjectile("HPPhoenixFX1",0,1,0,0); A_Recoil(4); }
    	PHNX D 4 Bright;
    	PHNX A 4 Offset(0,36);
    	PHNX B 0 Offset(0,32);
    	PHNX B 0 A_ReFire();
    	Goto Ready;
	}
}

class HPPhoenixPowered : HPPhoenix
{
const FLAME_THROWER_TICS = (10*TICRATE);
private int FlameCount;
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPPhoenix";
	Weapon.AmmoGive 0;
	Tag "$TAG_PHOENIXRODP";
	}
	States
	{
	Ready:
		PHNX AAAAEEEEFFFFEEEE 1 A_WeaponReady();
		Loop;
	Fire:
		PHNX A 3 Bright Offset(0,36) A_InitPhoenixPL2();
	Hold:
		PHNX GGHHIIHH 1 Bright Offset(0,40) A_FirePhoenixPL2();
		PHNX A 2 Bright Offset(0,38) A_ReFire();
	Powerdown:
		PHNX A 2 Bright Offset(0,36) A_ShutdownPhoenixPL2();
		PHNX A 2 Bright Offset(0,34);
		Goto Ready;
	}
	//----------------------------------------------------------------------------
	// Copypasted stuff from gzdoom.pk3
	//----------------------------------------------------------------------------
	override void EndPowerup ()
	{
		if (FlameCount > 0) DepleteAmmo (bAltFire);
		Owner.player.refire = 0;
		Owner.A_StopSound (CHAN_WEAPON);
		Owner.player.ReadyWeapon = SisterWeapon;
		Owner.player.SetPsprite(PSP_WEAPON, SisterWeapon.GetReadyState());
	}
	action void A_InitPhoenixPL2()
	{
		if (player != null)
		{
			HPPhoenixPowered flamethrower = HPPhoenixPowered(player.ReadyWeapon);
			if (flamethrower != null)
			{
				flamethrower.FlameCount = FLAME_THROWER_TICS;
			}
		}
	}
	action void A_FirePhoenixPL2()
	{
		if (player == null)
		{
			return;
		}

		HPPhoenixPowered flamethrower = HPPhoenixPowered(player.ReadyWeapon);
		
		if (flamethrower == null || --flamethrower.FlameCount == 0)
		{ // Out of flame
			player.SetPsprite(PSP_WEAPON, flamethrower.FindState("Powerdown"));
			player.refire = 0;
			A_StopSound (CHAN_WEAPON);
			return;
		}

		double slope = -clamp(tan(pitch), -5, 5);
		double xo = Random2[FirePhoenixPL2]() / 128.;
		double yo = Random2[FirePhoenixPL2]() / 128.;
		Vector3 spawnpos = Vec3Offset(xo, yo, 26 + slope - Floorclip);

		slope += 0.1;
		Actor mo = Spawn("PhoenixFX2", spawnpos, ALLOW_REPLACE);
		if (mo != null)
		{
			mo.target = self;
			mo.Angle = Angle;
			mo.VelFromAngle();
			mo.Vel.XY += Vel.XY;
			mo.Vel.Z = mo.Speed * slope;
			mo.CheckMissileSpawn (radius);
		}
		if (!player.refire)
		{
			A_StartSound("weapons/phoenixpowshoot", CHAN_WEAPON, CHANF_LOOPING);
		}	
	}
	action void A_ShutdownPhoenixPL2()
	{
		if (player == null)
		{
			return;
		}
		A_StopSound (CHAN_WEAPON);
		HPPhoenixPowered weapon = HPPhoenixPowered(player.ReadyWeapon);
		if (weapon != null)
		{
			weapon.FlameCount = 0;
			weapon.DepleteAmmo (weapon.bAltFire);
		}
	}
	//----------------------------------------------------------------------------
	// End copypaste
	//----------------------------------------------------------------------------
}

class HPPhoenixFX1 : PhoenixFX1
{
Default
	{
	Scale 0.5;
	Obituary "$OB_MPPHOENIXROD";
	}
	States
	{
	Spawn:
		PHOX A 4 Bright A_PhoenixPuff();
		Loop;
	Death:
		FX08 A 6 Bright { A_Explode(); A_SetScale(1.0); }
		FX08 BC 5 Bright;
		FX08 DEFGH 4 Bright;
		Stop;
	}
}

class HPPhoenixPuff : PhoenixPuff replaces PhoenixPuff {Default{ +FORCEXYBILLBOARD }}

class HPPhoenixFlame : PhoenixFX2 replaces PhoenixFX2
{
Default
	{
	Damage 3;
	Speed 15;
	ProjectileKickBack 1;
	+FORCEXYBILLBOARD
	Obituary "$OB_MPPPHOENIXROD";
	}
	States
	{
	Spawn:
		TNT1 A 2;
		FX09 ABABABABA 2 Bright;
		FX09 B 2 Bright A_FlameEnd();
		FX09 CDEF 2 Bright;
		Stop;
	}
}
