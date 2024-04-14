// Hellstaff -------------------------------------------------------

class HPSkull : SkullRod replaces SkullRod
{
Default
	{
	//$Category Weapons
	//$Title Hellstaff
	Weapon.SelectionOrder 100;
	Weapon.YAdjust 10;
	Weapon.SisterWeapon "HPSkullPowered";
	Obituary "$OB_MPSKULLROD";
	}
	States
	{
	Ready:
		HROD A 1 A_WeaponReady();
		Loop;
	Deselect:
		HROD A 1 A_Lower();
		Loop;
	Select:
		HROD A 1 A_Raise();
		Loop;
	Fire:
		HROD B 2 Bright A_FireSkullRodPL1;
		HROD F 2 Bright;
		HROD B 0 A_ReFire();
		Goto Ready;
	}
}

class HPSkullPowered : HPSkull
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPSkull";
	Weapon.AmmoUse 5;
	Weapon.AmmoGive 0;
	Obituary "$OB_MPPSKULLROD";
	Tag "$TAG_SKULLRODP";
	}
	States
	{
	Fire:
		HROD C 2 Bright A_StartSound("weapons/hornrodpowshoot2",CHAN_AUTO);
		HROD D 3 Bright;
		HROD E 2 Bright;
		HROD F 3 Bright;
		HROD G 4 Bright 
			{
			A_FireBullets(0,0,1,20*random(1, 8),"HPHellstaffPowerPuff",FBF_NORANDOM);
			A_RailAttack(0,0,1,"","",RGF_SILENT|RGF_NOPIERCING,0,"None",0,0,0,0,32,0,"HPHellstaffPowerSmoke");
			A_StartSound("weapons/hornrodpowshoot3", CHAN_WEAPON);
			}
		HROD F 2 Bright;
		HROD E 3 Bright;
		HROD D 2 Bright;
		HROD C 2 Bright A_ReFire();
		Goto Ready;
	}
}

class HPHornRodFX1 : HornRodFX1 replaces HornRodFX1
{
Default
	{
	Speed 20;
	Damage 4;
	Decal "PlasmaScorchLower";
	Scale 0.75;
	Alpha 0.75;
	+FORCEXYBILLBOARD
	+SEEKERMISSILE
	+SCREENSEEKER
	}
	States
	{
	Spawn:
		FX00 AAABBB 1 Bright A_SeekerMissile(9,6,SMF_Look|SMF_CURSPEED,75,10);
		Loop;
	}
}

class HPHellstaffPowerPuff : HornRodFX2 // here they come just in time
{
Default
	{
	Health 240;
	ProjectileKickBack 1;
	-MISSILE
	+PUFFGETSOWNER
	+PUFFONACTORS
	+ALWAYSPUFF
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_StartSound("weapons/hornrodpowhit",CHAN_WEAPON);
		Goto Death;
	}
}

class HPHellstaffPowerSmoke : Actor // power mirrors not included in base package
{
Default
	{
	RenderStyle "Translucent";
	Alpha 0.4;
	+NOINTERACTION
	}
	States
	{
	Spawn:
		XRFX A 4 Bright NoDelay A_Jump(128,1);
		XRFX BCDE 4 Bright;
		Stop;
	}
}

class HPRainPillar : RainPillar replaces RainPillar
{
Default
	{
	Damage 10;
	Speed 20;
	ProjectileKickBack 1;
	}
}
