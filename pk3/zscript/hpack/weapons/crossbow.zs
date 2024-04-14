// Ethereal Crossbow -------------------------------------------------------

class HPCrossbow : Crossbow replaces Crossbow
{
Default
	{
	//$Category Weapons
	//$Title Ethereal Crossbow
	Weapon.SelectionOrder 700;
	Weapon.AmmoType "HPCrossbowAmmo";
	Weapon.SisterWeapon "HPCrossbowPowered";
	Inventory.PickupMessage "$TXT_WPNCROSSBOW";
	Obituary "$OB_MPCROSSBOW";
	Tag "$TAG_CROSSBOW";
	}
	States
	{
	Ready:
		CRBW AAAAAABBBBBBCCCCCC 1 A_WeaponReady();
		Loop;
	Deselect:
		CRBW A 1 A_Lower();
		Loop;
	Select:
		CRBW A 1 A_Raise();
		Loop;
	Fire:
		CRBW D 3 Bright
			{
			A_FireProjectile("HPCrossbowFX8",9.0,0,4,3);
			A_FireProjectile("HPCrossbowFX1",0.0,1,0,3);
			A_FireProjectile("HPCrossbowFX8",-4.5,0,-2,3);
			A_FireProjectile("HPCrossbowFX8",4.5,0,2,3);
			A_FireProjectile("HPCrossbowFX8",-9.0,0,-4,3);
			A_StartSound("weapons/bowshoot",CHAN_WEAPON);
			}
		CRBW D 3 Offset(0,36);
		CRBW E 3 Offset(0,36);
		CRBW E 3 Offset(0,33);
		CRBW E 6 Offset(0,32);
		CRBW F 3 A_StartSound("weapons/bowreload",7);
		CRBW GH 3;
		CRBW AB 4;
		CRBW C 5 A_ReFire();
		Goto Ready;
	}
}

class HPCrossbowPowered : HPCrossbow
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPCrossbow";
	Weapon.AmmoGive 0;
	Obituary "$OB_MPPCROSSBOW";
	Tag "$TAG_CROSSBOWP";
	}
	States
	{
	Fire:
		CRBW D 3 Bright
			{
			A_FireProjectile("HPCrossbowFX8",9.0,0,4,3);
			A_FireProjectile("HPCrossbowFX7",0.0,1,0,3);
			A_FireProjectile("HPCrossbowFX7",-4.5,0,-2,3);
			A_FireProjectile("HPCrossbowFX7",4.5,0,2,3);
			A_FireProjectile("HPCrossbowFX8",-9.0,0,-4,3);
			}
		CRBW E 2;
		CRBW F 2 A_StartSound("weapons/bowreload",7);
		CRBW G 3;
		CRBW H 2;
		CRBW A 3;
		CRBW B 3;
		CRBW C 4 A_ReFire();
		Goto Ready;
	}
}

class HPCrossbowFX1 : CrossbowFX1 replaces CrossbowFX1 {Default { SeeSound ""; }}
class HPCrossbowFX4 : CrossbowFX4 replaces CrossbowFX4 {Default { +FORCEXYBILLBOARD }}
class HPCrossbowFX7 : CrossbowFX2 {Default { Damage 7; }}
class HPCrossbowFX8 : CrossbowFX3 {Default { Damage 4; }}
