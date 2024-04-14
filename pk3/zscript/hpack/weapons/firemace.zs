// Firemace ---------------------------------------------

class HPMace : Mace replaces MaceSpawner
{
Default
	{
	//$Category Weapons
	//$Title Firemace
	Weapon.SelectionOrder 1300;
	Weapon.SisterWeapon "HPMacePowered";
	Weapon.SlotPriority 0;
	Tag "$TAG_MACE";
	}
	States
	{
	Ready:
		MACE A 1 A_WeaponReady;
		Loop;
	Deselect:
		MACE A 1 A_Lower;
		Loop;
	Select:
		MACE A 1 A_Raise;
		Loop;
	Fire:
		MACE B 2;
	Hold:
		MACE C 2 Offset(-1,32) { A_FireProjectile("HPMaceBall",frandom(-4.5,4.5),1,0,0,CMF_AIMOFFSET,frandom(-1.5,1.5)); A_StartSound("weapons/macehit",CHAN_WEAPON); }
		MACE D 2 Offset(-3,31) A_FireProjectile("HPMaceBall",frandom(-4.5,4.5),0,0,0,CMF_AIMOFFSET,frandom(-1.5,1.5));
		MACE E 2 Offset(-1,30) { A_FireProjectile("HPMaceBall",frandom(-4.5,4.5),1,0,0,CMF_AIMOFFSET,frandom(-1.5,1.5)); A_StartSound("weapons/macehit",CHAN_WEAPON); }
		MACE F 2 Offset(1,31) A_FireProjectile("HPMaceBall",frandom(-4.5,4.5),0,0,0,CMF_AIMOFFSET,frandom(-1.5,1.5));
		MACE B 3 Offset(1,32) A_ReFire();
		Goto Ready;
	}
}

class HPMacePowered : HPMace
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPMace";
	Weapon.AmmoUse 2;
	Weapon.AmmoGive 0;
	Tag "$TAG_MACEP";
	}
	States
	{
	Fire:
		MACE B 2;
	Hold:
		MACE F 2 Offset(0,38) { A_FireProjectile("HPBigMaceBall",frandom(-2.5,2.5),1,0,0); A_StartSound("weapons/macepowhit",CHAN_WEAPON); }
		MACE F 2 Offset(0,36);
		MACE B 2 Offset(0,34);
		MACE A 2 Offset(0,33);
		MACE A 0 Offset(0,32) A_ReFire();
		Goto Ready;
	}
}

class HPMaceBall : Actor
{
Default
	{
	Radius 8;
	Height 6;
	Speed 25;
	Damage 2;
	SeeSound "weapons/maceshoot";
	DeathSound "weapons/macehit";
	BounceSound "weapons/macebounce";
	BounceCount 6;
	BounceFactor 1.0;
	WallBounceFactor 1.0;
	Projectile;
	Obituary "$OB_MPMACE";
	+BOUNCEONWALLS
	+BOUNCEONCEILINGS
	+BOUNCEONFLOORS
	+THRUGHOST
	}
	States
	{
	Spawn:
		FX02 AABB 2 A_SpawnItemEx("HPMaceTrailSmall");
		Loop;
	Death:
		FX02 F 2 Bright;
		FX02 GHIJ 3 Bright;
		Stop;
	}
}

class HPBigMaceBall : HPMaceBall
{
Default
	{
	Damage 15;
	ProjectileKickback 1;
	DeathSound "weapons/macepowhit";
	Obituary "$OB_MPPMACE";
	+SEEKERMISSILE
	+USEBOUNCESTATE
	}
	States
	{
	Spawn:
		FX02 CCDD 2 A_SpawnItemEx("HPMaceTrail");
		Loop;
	Bounce:
		FX02 AA 0 A_SeekerMissile(90,90,SMF_LOOK,256);
		Goto Spawn;
	}
}

class HPMaceTrail : Puffy
{
	States
	{
	Spawn:
		TNT1 A 2;
		FRB1 DEFGH 2 Bright;
		Stop;
	}
}

class HPMaceTrailSmall : HPMaceTrail {Default { Scale 0.5; }}
