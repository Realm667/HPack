// Sun Staff ---------------------------------------------

class HPSunstaff : Weapon
{
Default
	{
	//$Category Weapons
	//$Title Lightbringer
	Weapon.SisterWeapon "HPSunstaffPowered";
	Weapon.SelectionOrder 2000;
	Weapon.Kickback 0;
	Weapon.AmmoUse 1;
	Weapon.AmmoGive 50;
	Weapon.AmmoType "SunStaffAmmo";
	Weapon.YAdjust 0;
	Obituary "$OB_MPSUNSTAFF";
	Inventory.PickupMessage "$TXT_WPNSUNSTAFF";
	Tag "$TAG_SUNSTAFF";
	+WEAPON.NOAUTOFIRE
	}
	States
	{
	Spawn:
		WSUN A -1 light("LWANDAMMO");
		Stop;
	Ready:
		SUNS AAABBBCCCDDD 1 Bright A_WeaponReady();
		Loop;
	Deselect:
		SUNS KKLLMMNNNNNNNNN 1 Bright { A_StopSound(CHAN_WEAPON); A_Lower(); }
		Loop;
	Select:
		SUNS NNNNNNNNNNNMMLL 1 Bright A_Raise();
		Loop;
	Fire:
		SUNS A 0 { A_StartSound("weapons/sunstaffstart"); A_StartSound("weapons/sunstaffbeam1",CHAN_WEAPON); }
		SUNS KKII 1 Bright A_FireProjectile("SunFake2",0,0,0);
		SUNS E 1 Bright A_FireProjectile("SunBeam",0,1,0);
		SUNS E 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS F 1 Bright A_FireProjectile("SunBeam",0,0,0);
		SUNS F 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS G 1 Bright A_FireProjectile("SunBeam",0,1,0);
		SUNS G 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS H 1 Bright A_FireProjectile("SunBeam",0,0,0);
		SUNS H 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS A 0 A_StartSound("weapons/sunstaffbeam2",CHAN_WEAPON,CHANF_LOOPING);
		SUNS A 0 A_Refire();
		Goto Release;
	Hold:
		SUNS E 1 Bright A_FireProjectile("SunBeam",0,1,0);
		SUNS E 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS F 1 Bright A_FireProjectile("SunBeam",0,0,0);
		SUNS F 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS G 1 Bright A_FireProjectile("SunBeam",0,1,0);
		SUNS G 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS H 1 Bright A_FireProjectile("SunBeam",0,0,0);
		SUNS H 1 Bright A_FireProjectile("SunFake",0,0,0);
		SUNS A 0 A_Refire();
	Release:
		SUNS J 0 A_StartSound("weapons/sunstaffbeam3",CHAN_WEAPON);
		SUNS JJ 1 Bright A_FireProjectile("SunFake2",0,0,0);
		SUNS KD 2 Bright;
		Goto Ready;
	}
}

class HPSunStaffPowered : HPSunStaff
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPSunStaff";
	Weapon.AmmoGive 0;
	Weapon.AmmoUse 25;
	Tag "$TAG_SUNSTAFFP";
	}
	States
	{
	Ready:
		SUNS AAABBBCCCDDD 1 Bright
		{
		if(CountInv("SunStaffAmmo")<25)
			{ A_WeaponReady(WRF_NOPRIMARY); }
		else { A_WeaponReady(); }
		}
		Loop;
	Fire:
		SUNS A 0 A_StartSound("Weapons/sunstaffcharge",CHAN_WEAPON);
		SUNS BCDABCDABCDABCDEFGHEFGHEFGH 2 Bright;
		SUNS I 4 Bright;
		SUNS N 2 Offset(0,48) { A_FireProjectile("SunMeltdown",0,1,0,0); A_StartSound("Weapons/sunstaffpowshoot",CHAN_WEAPON); A_SetBlend("FF FF 88",1.0,35); }
		SUNS N 2 Offset(0,40);
		SUNS N 2 Offset(0,36);
		SUNS N 2 Offset(0,34);
		SUNS N 10 Offset(0,32);
		SUNS N 10 A_StartSound("weapons/sunstaffnew");
		SUNS ML 3;
		SUNS KABCD 3 Bright;
		Goto Ready;
    Flash:
		TNT1 A 1 A_LightInverse();
		TNT1 A 0 A_Light0();
		Stop;
	}
}

class SunBeam : FastProjectile
{
Default
	{
	Projectile;
	Radius 6;
	Height 4;
	Speed 100;
	DamageFunction random(1,2);
	Alpha 1.0;
	Scale 0.9;
	Renderstyle "Add";
	Damagetype "Solar";
	+PAINLESS
	+RIPPER
	+BLOODLESSIMPACT
	+FORCEXYBILLBOARD
	-BLOODSPLATTER
	}
	States
	{
	Spawn:
		TNT1 A 1 Bright Light("SUNSTAFFFX") A_SpawnProjectile("SunSpot",0,0,180);
		Wait;
	Death:
		SUND ABCDEF 2 Bright Light("SUNSTAFFFX");
		Stop;
	}
}

class SunFake  : SunBeam {Default{ Damage 0; }}
class SunFake2 : SunFake
{
	States
	{
	Spawn:
		TNT1 A 1 Bright Light("SUNSTAFFFX") A_SpawnProjectile("SunSpot2",0,0,180);
		Wait;
	}
}

class SunSpot : Actor
{
Default
	{
	Height 2;
	Radius 6;
	Damage 0;
	Speed 0.2;
	Renderstyle "Add";
	Alpha 0.9;
	Scale 1.5;
	+FORCEXYBILLBOARD
	+NOGRAVITY
	+DROPOFF
	}
	States
	{
	Spawn:
		SUNP BB 1 Bright Light("SUNSTAFFFX");
		Stop;
	}
}

class SunSpot2 : SunSpot
{
	States
	{
	Spawn:
		SUNP AA 1 Bright Light("SUNSTAFFFX");
		Stop;
	}
}

class SunMeltdown : Actor
{
Default
	{
	Projectile;
	Radius 16;
	Height 8;
	Speed 0;
	Damagetype "Solar";
	}
	States
	{
		Spawn:
			TNT1 A 0;
		Death:
			TNT1 A 1 A_BFGSpray("SunBurst",40,15);
			Stop;
	}
}

class SunBurst : Actor
{
Default
	{
	Radius 8;
	Height 16;
	RenderStyle "Add";
	+NOGRAVITY
	+FORCEXYBILLBOARD
	}
	States
	{
	Spawn:
		SUNM G 0 Bright Nodelay A_StartSound("weapons/sunstaffSphereExp");
		SUNM GGGG 0 A_SpawnItemEx("SunRay",0,0,0,8,0,random(4,16),random(1,360),160,0);
		SUNM G 4 Bright Light("SUNSPHERE_X1");
		SUNM HI 4 Bright Light("SUNSPHERE_X2");
		SUNM JK 4 Bright Light("SUNSPHERE_X3");
		SUNM LM 4 Bright Light("SUNSPHERE_X4");
		SUNM NO 4 Bright Light("SUNSPHERE_X5");
		SUNM P 4;
		Stop;
	}
}

class SunRay : Actor
{
Default
	{
	Radius 5;
	Height 6;
	Speed 16;
	Projectile;
	+THRUACTORS
	-NOGRAVITY
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	}
	States
	{
	Spawn:
		FX01 AAABBB 1 Bright Light("SUNSTAFFFX") A_SpawnItemEx("SunRayTrail",0,0,0,0,0,0,0,0);
		Loop;
	Death:
		FX01 EFGH 3 Bright Light("SUNSTAFFFX");
		Stop;
	}
}


class SunRayTrail : Actor
{
Default
	{
	Gravity 0.125;
	RenderStyle "Add";
	Alpha 0.4;
	+FORCEXYBILLBOARD
	+NOBLOCKMAP
	}
	States
	{
	Spawn:
		FX01 EFGH 2 Bright;
		Stop;
  }
}
