// Staff of Chaos ---------------------------------------------

class HPStaffChaos : Weapon
{
Default
	{
	//$Category Weapons
	//$Title Staff of Chaos
	Weapon.SelectionOrder 3000;
	Weapon.SisterWeapon "HPStaffChaosPowered";
	Weapon.AmmoType "DummyHealthAmmo";
	Weapon.AmmoUse 1;
	Weapon.AmmoGive 0;
	Weapon.KickBack 300;
	Weapon.YAdjust 0;
	Inventory.Icon "WSCHA0";
	Inventory.PickupMessage "$TXT_WPNSTAFFCHAOS";
	Tag "$TAG_STAFFOFCHAOS";
	+WEAPON.AMMO_OPTIONAL
	+WEAPON.NOAUTOFIRE
	}
	uint CountChaos;
	bool RightFired;
	States
	{
	Select:
		TNT1 A 1 { A_StartSound("Weapon/StaffChaos/Static",CHAN_AUTO); A_Overlay(6,"HealthScan"); }
		STCH A 1 A_Raise();
		Wait;
	HealthScan:
		TNT1 A 1 SetInventory("DummyHealthAmmo",Health);
		Loop;
	Deselect:
		STCH A 1 A_Lower();
		Loop;
	Ready:
		STCH A 1 A_WeaponReady();
		Loop;
	Fire:
		STCH A 3 Bright
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireNone"); }
			else if(health <= 11)
				{ return ResolveState("LowFire"); }
			else { A_StartSound("Weapon/StaffChaos/Charge",CHAN_AUTO); }
			return ResolveState(null);
			}
		STCH BC 3 Bright;
		STCH D 3 Bright A_Light(1);
		STCH E 3 Bright A_Light(2);
		STCH F 3 Bright
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireFail"); }
			else
				{
				A_Light(3); A_Recoil(4); A_SetPitch(Pitch-2); A_SetAngle(Angle+FRandom(-1,1));
				A_StartSound("Weapon/StaffChaos/Fire",CHAN_WEAPON); A_FireProjectile("ChaosMissile",0,0);
				A_DamageSelf(2,"Electric",DMSS_FOILINVUL|DMSS_NOPROTECT|DMSS_NOFACTOR,null,"None",AAPTR_DEFAULT,AAPTR_DEFAULT);
				if(health < 26 && health > 1)
					{ A_StartSound("*Pain25",CHAN_BODY); }
				}
			return ResolveState(null);
			}
	FireDone:
		STCH G 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); A_Light(2); }
		STCH B 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); A_Light(1); }
		STCH A 3 Bright A_Light(0);
		STCH A 3 { invoker.CountChaos = 16; }
		Goto FireDone1;
	FireDone1:
		STCH A 1 { A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH); invoker.CountChaos--; }
		STCH A 0
			{
			if(invoker.CountChaos >= 1)
				{ return ResolveState("FireDone1"); }
			else { A_Refire(); }
			return ResolveState(null);
			}
		Goto Ready;
	FireFail:
		STCH D 3 Bright { A_StartSound("Weapon/StaffChaos/Static",CHAN_WEAPON); A_Light(1); }
		STCH C 3 A_Light(0);
		STCH BA 3 Bright;
		STCH A 3 { invoker.CountChaos = 16; }
		Goto FireDone1;
	FireNone:
		STCH A 0 A_StartSound("Weapon/StaffChaos/Static",CHAN_AUTO);
		STCH AAAAAAAA 1 A_WeaponOffset(frandom(-1,1),frandom(32,34));
		STCH A 3 { invoker.CountChaos = 16; }
		Goto FireDone1;
	Hold:
		STCH A 0 A_JumpIfHealthLower(11,"LowHold");
		STCH A 0 A_ClearRefire();
		Goto Fire;
	LowFire:
		STCH A 3 Bright
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireNone"); }
			else { A_StartSound("Weapon/StaffChaos/Charge",CHAN_AUTO); }
			return ResolveState(null);
			}
		STCH H 3 Bright
			{
			if(invoker.RightFired == true)
				{ return ResolveState("LowFireLeft"); }
			else { invoker.RightFired = true; }
			return ResolveState(null);
			}
		Goto LowHold1;
	LowFireLeft:
		STCH M 3 Bright { invoker.RightFired = false; }
		Goto LowHoldLeft1;
	LowHold:
		STCH H 3 Bright Offset(-1,36)
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireNone"); }
			else if(invoker.RightFired == true)
				{ return ResolveState("LowHoldLeft"); }
			else { invoker.RightFired = true; }
			return ResolveState(null);
			}
	LowHold1:
		STCH IJK 3 Bright Offset(1,33);
		STCH L 3 Bright Offset(4,40) { A_FireProjectile("ChaosBolt1",-5,0,8,2); A_StartSound("Weapon/StaffChaos/ZapShot",CHAN_WEAPON); A_Light(1); }
		STCH A 3 Bright Offset(2,36) { A_Light(0); A_Refire(); }
		STCH A 3 Bright Offset(1,33) { invoker.CountChaos = 4; }
		Goto FireDone1;
	LowHoldLeft:
		STCH M 3 Bright Offset(1,36) { invoker.RightFired = false; }
	LowHoldLeft1:
		STCH NOP 3 Bright Offset(-1,33);
		STCH Q 3 Bright Offset(-4,40) { A_FireProjectile("ChaosBolt1",5,0,-8,2); A_StartSound("Weapon/StaffChaos/ZapShot",CHAN_WEAPON); A_Light(1); }
		STCH A 3 Bright Offset(-2,36) { A_Light(0); A_Refire(); }
		STCH A 3 Bright Offset(-1,33) { invoker.CountChaos = 4; }
		Goto FireDone1;
	LowFireFail:
		STCH A 3 Bright Offset(0,33) A_StartSound("Weapon/StaffChaos/Static",CHAN_WEAPON);
		STCH A 3 Offset(0,33) { invoker.CountChaos = 8; }
		Goto FireDone1;
	Spawn:
		WSCH A 1;
		WSCH A 1 Bright;
		Loop;
	}
}

class HPStaffChaosPowered : HPStaffChaos
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPStaffChaos";
	Tag "$TAG_STAFFOFCHAOSP";
	}
	States
	{
	Fire:
		STCH A 3 Bright
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireNone"); }
			else if(health <= 11)
				{ return ResolveState("LowFire"); }
			else { A_StartSound("Weapon/StaffChaos/Charge",CHAN_AUTO); }
			return ResolveState(null);
			}
		STCH R 3 Bright;
		STCH S 3 Bright A_Light(1);
		STCH T 3 Bright A_Light(2);
		STCH U 3 Bright A_Light(3);
		STCH V 3 Bright
			{
			if(CountInv("PowerInvulnerable") || CountInv("FlagChaosArcActive"))
				{ return ResolveState("FireFail"); }
			else
				{
				A_Light(4); A_Recoil(8); A_SetPitch(Pitch-5); A_SetAngle(Angle+FRandom(-2,2));
				A_StartSound("Weapon/StaffChaos/Fire",CHAN_WEAPON); A_FireProjectile("ChaosArcSpawner",0,0,0,0,1);
				A_DamageSelf(5,"Electric",DMSS_FOILINVUL|DMSS_NOPROTECT|DMSS_NOFACTOR,null,"None",AAPTR_DEFAULT,AAPTR_DEFAULT);
				A_GiveInventory ("FlagChaosArcActive",1);
				if(health < 26 && health > 1)
					{ A_StartSound("*Pain25",CHAN_BODY); }
				}
			return ResolveState(null);
			}
	FireDone:
		STCH W 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); A_Light(3); }
		STCH X 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); A_Light(2); }
		STCH C 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); A_Light(1); }
		STCH B 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); A_Light(0); }
		STCH A 3 Bright { A_SetPitch(Pitch+1); A_SetAngle(Angle+FRandom(-0.5,0.5)); }
		STCH A 3 Bright { invoker.CountChaos = 16; }
		Goto FireDone1;
	FireFail:
		STCH D 3 Bright { A_StartSound("Weapon/StaffChaos/Static",CHAN_WEAPON); A_Light(2); }
		STCH C 3 Bright A_Light(1);
		STCH B 3 Bright A_Light(0);
		STCH A 3 Bright;
		STCH A 3 { invoker.CountChaos = 16; }
		Goto FireDone1;
	Hold:
		STCH A 0 A_JumpIfHealthLower(11,"LowFire");
		STCH A 0 A_ClearRefire();
		Goto Fire;
	LowFire:
	LowHold:
		STCH A 3 Bright
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireNone"); }
			else { A_StartSound("Weapon/StaffChaos/Charge",CHAN_AUTO); }
			return ResolveState(null);
			}
		STCH BCD 3 Bright;
		STCH Y 3 Bright A_Light(1);
		STCH Z 3 Bright Offset(0,40)
			{
			if(CountInv("PowerInvulnerable"))
				{ return ResolveState("FireNone"); }
			else
				{
				A_StartSound("Weapon/StaffChaos/ZapShot",CHAN_WEAPON); A_Light(2);
				A_FireProjectile("ChaosBolt2",0,0,8,2); A_FireProjectile("ChaosBolt2",0,0,-8,2);
				A_FireProjectile("ChaosBolt2",-5,0,8,2); A_FireProjectile("ChaosBolt2",5,0,-8,2);
				}
			return ResolveState(null);
			}
	LowDone:
		STCH A 3 Bright Offset(0,36) A_Light(1);
		STCH A 3 Bright Offset(0,33) A_Light(0);
		STCH A 0 A_Refire();
		STCH A 3 { invoker.CountChaos = 4; }
		Goto FireDone1;
	}
}

class FlagChaosArcActive : Powerup {Default{ Powerup.Duration 128; }}

class ChaosMissile : Sorcerer2FX1
{
Default
	{
	Damage 20;
	DamageType "Electric";
	SeeSound "Weapon/StaffChaos/Shock";
	DeathSound "Weapon/StaffChaos/Hit";
	Obituary "$OB_MPSTAFFCHAOS";
	Decal "ChaosLightning";
	+SEEKERMISSILE
	+SCREENSEEKER
	+NODAMAGETHRUST
	+FORCEXYBILLBOARD
	+FORCERADIUSDMG
	}
	States
	{
	Spawn:
		FX16 ABC 3 Bright A_BlueSpark();
	Spawn1:
		FX16 ABC 3 Bright Light("ChaosFlash8")
			{
			A_AlertMonsters(); A_BlueSpark(); A_StartSound("Weapon/StaffChaos/Charge",CHAN_AUTO);
			A_SeekerMissile(1,2,SMF_LOOK|SMF_PRECISE,128,8);
			A_ChangeVelocity(0,FRandom(-1,1),FRandom(-1,1),1);
			}
		Loop;
	Death:
		FX16 G 1 Bright Light("ChaosFlash8") A_Explode(40,256,0,1,128);
		FX16 G 1 Bright Light("ChaosFlash9");
		FX16 G 1 Bright Light("ChaosFlash10");
		FX16 H 1 Bright Light("ChaosFlash11") A_Explode(40,256,0,0,128);
		FX16 H 1 Bright Light("ChaosFlash12");
		FX16 H 1 Bright Light("ChaosFlash13");
		FX16 I 1 Bright Light("ChaosFlash14") A_Explode(40,256,0,0,128);
		FX16 I 1 Bright Light("ChaosFlash15");
		FX16 I 1 Bright Light("ChaosFlash16");
		FX16 JKL 3 Bright Light("ChaosFlash16") A_Explode(40,256,0,0,128);
		TNT1 A 1 Light("ChaosFlash15");
		TNT1 A 1 Light("ChaosFlash14");
		TNT1 A 1 Light("ChaosFlash13");
		TNT1 A 1 Light("ChaosFlash12");
		TNT1 A 1 Light("ChaosFlash11");
		TNT1 A 1 Light("ChaosFlash10");
		TNT1 A 1 Light("ChaosFlash9");
		TNT1 A 1 Light("ChaosFlash8");
		TNT1 A 1 Light("ChaosFlash7");
		TNT1 A 1 Light("ChaosFlash6");
		TNT1 A 1 Light("ChaosFlash5");
		TNT1 A 1 Light("ChaosFlash4");
		TNT1 A 1 Light("ChaosFlash3");
		TNT1 A 1 Light("ChaosFlash2");
		TNT1 A 1 Light("ChaosFlash1");
		Stop;
	}
}

class ChaosBolt1 : ChaosMissile
{
Default
	{
	Radius 2;
	Height 4;
	Speed 40;
	Damage 12;
	BounceFactor 1.0;
	WallBounceFactor 1.0;
	BounceCount 4;
	SeeSound "Weapon/StaffChaos/ZapShot";
	DeathSound "";
	BounceSound "Weapon/StaffChaos/Zapped";
	Obituary "$OB_MPSTAFFCHAOS";
	+BOUNCEONWALLS
	+BOUNCEONFLOORS
	+BOUNCEONCEILINGS
	+CANBOUNCEWATER
	+BOUNCEAUTOOFF
	+FORCEXYBILLBOARD
	}
	States
	{
	Spawn:
		FX16 DEDE 1 Bright A_SpawnItemEx("ChaosBoltTrail1");
	Spawn1:
		TNT1 A 0 { A_SeekerMissile(2,2,SMF_LOOK|SMF_PRECISE,128,8); A_ChangeVelocity(0,FRandom(-1,1),FRandom(-1,1),1); }
		FX16 DEDE 1 Bright Light("ChaosFlash2") A_SpawnItemEx("ChaosBoltTrail1");
		Loop;
	Death:
		FX16 D 3 Bright Light("ChaosFlash4") { A_BlueSpark(); A_StartSound("Weapon/StaffChaos/ZapHit"); }
		FX16 E 3 Bright Light("ChaosFlash3") A_BlueSpark();
		FX16 F 3 Bright Light("ChaosFlash2") A_BlueSpark();
		TNT1 A 1 Light("ChaosFlash1") A_BlueSpark();
		Stop;
	}
}

class ChaosBolt2 : ChaosBolt1
{
Default
	{
	Speed 48;
	Obituary "$OB_MPSTAFFCHAOS";
	}
	States
	{
	Spawn:
		FX16 DEDE 1 Bright A_SpawnItemEx("ChaosBoltTrail2");
	Spawn1:
		FX16 D 1 Bright Light("ChaosFlash2")
			{ A_SpawnItemEx("ChaosBoltTrail2"); A_SeekerMissile(2,2,SMF_LOOK|SMF_PRECISE,128,8); A_ChangeVelocity(0,FRandom(-1,1),FRandom(-1,1),1); }
		FX16 E 1 Bright Light("ChaosFlash2")
			{ A_SpawnItemEx("ChaosBoltTrail2"); A_SeekerMissile(0,1,SMF_LOOK|SMF_PRECISE,128,8); A_ChangeVelocity(0,FRandom(-1,1),FRandom(-1,1),1); }
		Loop;
	}
}

class ChaosBoltTrail1 : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	Scale 0.5;
	}
	States
	{
	Spawn:
		TNT1 A 2;
		FX16 EDF 2 Bright;
		Stop;
	}
}

class ChaosBoltTrail2 : ChaosBoltTrail1
{
	States
	{
	Spawn:
		TNT1 A 2;
		FX16 EDF 3 Bright;
		Stop;
	}
}

class ChaosArcSpawner : FastProjectile
{
Default
	{
	Radius 4;
	Height 8;
	Speed 256;
	Damage 0;
	DamageType "Electric";
	ReactionTime 7;
	AttackSound "Weapon/StaffChaos/Static";
	SeeSound "Weapon/StaffChaos/Arc";
	+BLOODLESSIMPACT
	+NODAMAGETHRUST
	+PAINLESS
	+SEEKERMISSILE
	}
	States
	{
	Spawn:
		TNT1 A 1 A_CountDown();
		Loop;
	Death:
		TNT1 A 1 A_SpawnItemEx("ChaosArcTracker",0,0,0,32,0,0,0,SXF_TRANSFERPOINTERS|SXF_NOCHECKPOSITION);
		Stop;
	}
}

class ChaosArcTracker : Actor
{
Default
	{
	Projectile;
	Radius 2;
	Height 2;
	Speed 32;
	Damage 0;
	DamageType "Electric";
	BounceType "Grenade";
	BounceFactor 1.0;
	WallBounceFactor 1.0;
	ReactionTime 128;
	RenderStyle "Add";
	SeeSound "Weapon/StaffChaos/Arc";
	DeathSound "Weapon/StaffChaos/Static";
	+NOEXPLODEFLOOR
	+SEEKERMISSILE
	+BLOODLESSIMPACT
	+THRUACTORS
	+NOTRIGGER
	}
	static const string ArcZap[] = { "ChaosArcZap1", "ChaosArcZap2" };
	States
	{
	Spawn:
		TNT1 A 0
			{
			A_AlertMonsters(); A_SeekerMissile(10,45,SMF_LOOK|SMF_PRECISE,256,2);
			if(CheckIfCloser(tracer,4096))
				{ return ResolveState("Spawn1"); }
			else
			{ A_SetAngle(Random(0,359)); A_ChangeVelocity(32,0,0,3); }
			return ResolveState(null);
			}
	Spawn1:
		TNT1 A 1 Light("ChaosFlash16")
			{
			int zapn;
			zapn = random(0,1);
			A_SpawnItemEx(ArcZap[zapn],Random(-64,64),Random(-64,64),CeilingZ-Pos.Z-32,0,0,-32,Random(0,359),SXF_TRANSFERPOINTERS);
			A_CountDown();
			}
		Goto Spawn;
	Death:
		TNT1 A 1 Light("ChaosFlash16");
		TNT1 A 1 Light("ChaosFlash15");
		TNT1 A 1 Light("ChaosFlash14");
		TNT1 A 1 Light("ChaosFlash13");
		TNT1 A 1 Light("ChaosFlash12");
		TNT1 A 1 Light("ChaosFlash11");
		TNT1 A 1 Light("ChaosFlash10");
		TNT1 A 1 Light("ChaosFlash9");
		TNT1 A 1 Light("ChaosFlash8");
		TNT1 A 1 Light("ChaosFlash7");
		TNT1 A 1 Light("ChaosFlash6");
		TNT1 A 1 Light("ChaosFlash5");
		TNT1 A 1 Light("ChaosFlash4");
		TNT1 A 1 Light("ChaosFlash3");
		TNT1 A 1 Light("ChaosFlash2");
		TNT1 A 1 Light("ChaosFlash1");
		Stop;
	}
}

class ChaosArcZap1 : Actor
{
Default
	{
	Projectile;
	Radius 8;
	Height 32;
	Damage 2;
	DamageType "Electric";
	RenderStyle "Add";
	SeeSound "Weapon/StaffChaos/Static";
	DeathSound "Weapon/StaffChaos/Arc";
	Obituary "$OB_MPSTAFFCHAOS";
	+BLOODLESSIMPACT
	+NODAMAGETHRUST
	+RIPPER
	+FORCERADIUSDMG
	-ACTIVATEIMPACT
	-ACTIVATEPCROSS
	}
	States
	{
	Spawn:
		TNT1 A 0 NoDelay A_Jump(256,1,2,3,4,5);
	Spawn1:
		CHE1 IIJJKKLLMM 1 Bright Light("ChaosFlash4") A_Explode(Random(8,16),16,0,0,16);
		Loop;
	Death:
		CHE1 N 2 Bright Light("ChaosFlash4") A_Explode(10,64,0,0,64);
		CHE1 O 2 Bright Light("ChaosFlash4");
		CHE1 PQ 2 Bright Light("ChaosFlash3");
		CHE1 RS 2 Bright Light("ChaosFlash2");
		CHE1 TU 2 Bright Light("ChaosFlash1");
		Stop;
	}
}

class ChaosArcZap2 : ChaosArcZap1
{
Default
	{
	Damage 1;
	+PAINLESS
	Obituary "$OB_MPSTAFFCHAOS";
	}
}

class DummyHealthAmmo : Ammo
{
Default
	{
	Inventory.Amount 1;
	Inventory.MaxAmount 100;
	Inventory.InterHubAmount 0;
	Ammo.BackpackAmount 0;
	Ammo.BackpackMaxAmount 0;
	Inventory.Icon "PTN1A0";
	}
}

class Sorcerer2FXSparkXY : Sorcerer2FXSpark Replaces Sorcerer2FXSpark {Default{ +FORCEXYBILLBOARD }}

