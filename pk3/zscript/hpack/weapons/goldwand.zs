// Elven Wand ---------------------------------------------

class HPWand : GoldWand replaces GoldWand
{
Default
	{
	//$Category Weapons
	//$Title Elven Wand
	Weapon.SelectionOrder 1900;
	Weapon.SisterWeapon "HPWandPowered";
	Weapon.YAdjust 0;
	Decal "RailScorchLower";
	Inventory.PickupMessage "$TXT_WPNWAND";
	Obituary "$OB_MPGOLDWAND";
	Tag "$TAG_GOLDWAND";
	}
	States
	{
	Spawn:
		WAND A -1;
		Stop;
	Ready:
		GWND A 1 A_WeaponReady();
		Loop;
	Deselect:
		GWND A 1 A_Lower();
		Loop;
	Select:
		GWND A 1 A_Raise();
		Loop;
	Fire:
		GWND B 3;
		GWND C 0 Bright A_StartSound("weapons/wandhit",CHAN_WEAPON);
		GWND C 4 Bright A_FireBullets(random(5,6),0,1,random(7,8),"GoldWandPuff1");
		GWND D 3;
		GWND D 0 A_ReFire();
		Goto Ready;
	}
}

class HPGoldWandPuff1 : GoldWandPuff1 replaces GoldWandPuff1 {Default{ +FORCEXYBILLBOARD }}
class HPGoldWandPuff2 : GoldWandPuff2 replaces GoldWandPuff2 {Default{ +FORCEXYBILLBOARD }}
class HPGoldWandFX1 : GoldWandFX1 replaces GoldWandFX1 {Default{ +FORCEXYBILLBOARD Decal "HImpScorch"; }}
class HPGoldWandFX2 : GoldWandFX2 replaces GoldWandFX2 {Default{ +FORCEXYBILLBOARD Decal "HImpScorch"; }}

class HPWandPowered : HPWand
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPWand";
	Weapon.AmmoGive 0;
	Weapon.YAdjust 0;
	Obituary "$OB_MPGOLDWAND";
	Tag "$TAG_GOLDWANDP";
	}
	States
	{
	Fire:
		GWND B 3 A_StartSound("weapons/wandcharge");
		GWND C 3 Bright A_FireGoldWandPL2;
		GWND D 3;
		GWND D 0 A_ReFire();
		Goto Ready;
	}
	//----------------------------------------------------------------------------
	// Copypasted stuff from gzdoom.pk3
	//----------------------------------------------------------------------------
	action void A_FireGoldWandPL2 ()
	{
		if (player == null)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (weapon.bAltFire))
				return;
		}
		double pitch = BulletSlope();

		double vz = -GetDefaultByType("GoldWandFX2").Speed * clamp(tan(pitch), -5, 5);
		SpawnMissileAngle("GoldWandFX2", angle - (45. / 8), vz);
		SpawnMissileAngle("GoldWandFX2", angle + (45. / 8), vz);
		double ang = angle - (45. / 8);
		for(int i = 0; i < 5; i++)
		{
			int damage = random[FireGoldWand](1, 8);
			LineAttack (ang, PLAYERMISSILERANGE, pitch, damage, 'Hitscan', "GoldWandPuff2");
			ang += ((45. / 8) * 2) / 4;
		}
		A_StartSound("weapons/wandhit", CHAN_WEAPON);
	}
	//----------------------------------------------------------------------------
	// End copypaste
	//----------------------------------------------------------------------------
}
