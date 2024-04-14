// Gauntlets of D'Sparil ---------------------------------------------

class HPDSparilGauntlets : Weapon
{
Default
	{
	//$Category Weapons
	//$Title Gloves of D'Sparil
	Weapon.SisterWeapon "HPDSparilGauntletsPowered";
	Weapon.SelectionOrder 2001;
	Weapon.Kickback 25;
	Weapon.AmmoUse 1;
	Weapon.AmmoGive 10;
	Weapon.YAdjust 10;
	Weapon.AmmoType "ChaosAmmo";
	+WEAPON.NOAUTOFIRE
	Inventory.PickupMessage "$TXT_WPNDSPARILS";
	Obituary "$OB_MPDSPARILS";
	Tag "$TAG_DSPARILSG";
	}
	bool LeftHand;
	States
	{
	Spawn:
		WGT3 A -1;
		Stop;
	Ready:
		GAU3 A 1 { A_WeaponReady(); invoker.LeftHand=false; }
		Loop;
	Deselect:
		GAU3 A 1 { A_Lower(); invoker.LeftHand=false; }
		Loop;
	Select:
		GAU3 A 1 { A_Raise(); invoker.LeftHand=false; }
		Loop;
	Fire:
		GAU3 A 3 A_StartSound("weapons/gauntletsactivate");
		GAU3 BC 3;
		GAU3 D 1 Bright;
		GAU3 E 1 Bright
			{
			A_StartSound("weapons/gauntletsshoot",CHAN_AUTO);
			A_FireProjectile("GauntletFX1",5.625,1,-8);
			A_FireProjectile("GauntletFX1",-5.625,0,-8);
			A_FireProjectile("GauntletFX1",0.000,0,-8);
			}
		GAU3 FGH 2;
		GAU3 A 2 { A_Refire(); A_StartSound("weapons/gauntletsrip",CHAN_WEAPON); }
		Goto Ready;
	Hold:
		GAU3 A 0 A_JumpIf(invoker.LeftHand,"FireLeft");
	FireRight:
		GAU3 I 2 { invoker.LeftHand=true; }
		GAU3 J 1 Bright;
		GAU3 K 1 Bright
			{
			A_StartSound("weapons/gauntletsshoot",CHAN_AUTO);
			A_FireProjectile("GauntletFX1",5.625,1,8);
			A_FireProjectile("GauntletFX1",-5.625,0,8);
			A_FireProjectile("GauntletFX1",0.000,0,8);
			}
		GAU3 LMN 2;
		GAU3 A 2 { A_Refire(); A_StartSound("weapons/gauntletsrip",CHAN_WEAPON); }
		Goto Ready;
	FireLeft:
		GAU3 O 2 { invoker.LeftHand=false; }
		GAU3 P 1 Bright;
		GAU3 E 1 Bright 
			{
			A_StartSound("weapons/gauntletsshoot",CHAN_AUTO);
			A_FireProjectile("GauntletFX1",5.625,1,-8);
			A_FireProjectile("GauntletFX1",-5.625,0,-8);
			A_FireProjectile("GauntletFX1",0.000,0,-8);
			}
		GAU3 FGH 2;
		GAU3 A 2 { A_Refire(); A_StartSound("weapons/gauntletsrip",CHAN_WEAPON); }
		Goto Ready;
	}
}

class GauntletFX1 : WizardFX1
{
Default
	{
	Damage 5;
	+SEEKERMISSILE
	+FORCEXYBILLBOARD
	DeathSound "weapons/macehit";
	Decal "HImpScorch";
	Obituary "%o was seared to a crisp by %k's gauntlets.";
	}
	States
	{
	Spawn:
		GNFX AAABBB 1 Bright A_SpawnItemEx("GauntletFX2",random2[BoltSpark]()*0.015625,random2[BoltSpark]()*0.015625,0,0,0,0,0,SXF_ABSOLUTEPOSITION,50);
		Loop;
	Death:
		GNFX C 4 Bright A_SpawnItemEx("GauntletFX3",0,0,0,0,0,0,0,0);
		GNFX DEFG 4 Bright;
		Stop;
	}
}

class GauntletFX2 : GauntletPuff2
{
Default
	{
	+FORCEXYBILLBOARD
	}
	States
	{
	Spawn:
		GNFX HIJK 3 Bright;
		Stop;
	}
}

class GauntletFX3 : GauntletFX2
{
Default
	{
	+FORCEXYBILLBOARD
	Alpha 0.8;
	}
	States
	{
	Spawn:
		GNFX NO 3 Bright;
		GNFX PPPQQQ 1 Bright A_FadeOut(0.1);
		Stop;
	}
}

class HPDSparilGauntletsPowered : HPDSparilGauntlets
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPDSparilGauntlets";
	Weapon.Kickback 25;
	Weapon.AmmoUse 2;
	Tag "$TAG_DSPARILSGP";
	}
	States
	{
	Ready:
		GAU2 AAAQQQRRR 1 { A_WeaponReady(); invoker.LeftHand=false; }
		Loop;
	Deselect:
		GAU2 A 1 { A_Lower(); invoker.LeftHand=false; }
		Loop;
	Select:
		GAU2 A 1 { A_Raise(); invoker.LeftHand=false; }
		Loop;
	Fire:
		GAU2 A 3 A_StartSound("weapons/gauntletsactivate");
		GAU2 BC 3;
		GAU2 D 2 Bright;
		GAU2 E 2 Bright
			{
			A_StartSound("weapons/gauntletspowshoot",CHAN_AUTO);
			A_FireProjectile("GauntletFX4",5.625,1,-8);
			A_FireProjectile("GauntletFX4",-5.625,0,-8);
			A_FireProjectile("GauntletFX4",0.000,0,-8);
			}
		GAU2 FGH 2;
		GAU2 A 2 { A_Refire(); A_StartSound("weapons/gauntletsrip",CHAN_WEAPON); }
		Goto Ready;
	Hold:
		GAU2 A 0 A_JumpIf(invoker.LeftHand,"FireLeft");
	FireRight:
		GAU2 I 2 { invoker.LeftHand=true; }
		GAU2 J 2 Bright;
		GAU2 K 2 Bright
			{
			A_StartSound("weapons/gauntletspowshoot",CHAN_AUTO);
			A_FireProjectile("GauntletFX4",5.625,1,8);
			A_FireProjectile("GauntletFX4",-5.625,0,8);
			A_FireProjectile("GauntletFX4",0.000,0,8);
			}
		GAU2 LMN 2;
		GAU2 A 2 { A_Refire(); A_StartSound("weapons/gauntletsrip",CHAN_WEAPON); }
		Goto Ready;
	FireLeft:
		GAU2 O 2 { invoker.LeftHand=false; }
		GAU2 P 2 Bright;
		GAU2 E 2 Bright
			{
			A_StartSound("weapons/gauntletspowshoot",CHAN_AUTO);
			A_FireProjectile("GauntletFX4",5.625,1,-8);
			A_FireProjectile("GauntletFX4",-5.625,0,-8);
			A_FireProjectile("GauntletFX4",0.000,0,-8);
			}
		GAU2 FGH 2;
		GAU2 A 2 { A_Refire(); A_StartSound("weapons/gauntletsrip",CHAN_WEAPON); }
		Goto Ready;
	}
}

class GauntletFX4 : GauntletFX1
{
Default
	{
	Alpha 1;
	//SeeSound "weapons/gauntletspowshoot";
	DeathSound "weapons/dspgntpowhit";
	+FORCEXYBILLBOARD
	+EXTREMEDEATH
	Decal "HImpScorch";
	}
	States
	{
	Spawn:
		GNF2 AAABBB 1 Bright A_SpawnItemEx("GauntletFX5",random2[BoltSpark]()*0.015625,random2[BoltSpark]()*0.015625,0,0,0,0,0,SXF_ABSOLUTEPOSITION,50);
		Loop;
	Death:
		GNF2 C 4 Bright A_SpawnItemEx("PowGauntletExp",0,0,0,0,0,0,0,0);
		GNF2 D 4 Bright A_Explode(40,64,0,0,64);
		GNF2 EFG 4 Bright;
		Stop;
	}
}

class GauntletFX5 : GauntletFX2
{
Default
	{
	+FORCEXYBILLBOARD
	-NOGRAVITY
	Gravity 0.05;
	Alpha 1;
	Renderstyle "Add";
	}
	States
	{
	Spawn:
		GNF2 L 8 Bright;
		GNF2 M 8 Bright A_FadeOut(0.2);
		Stop;
	}
}

class PowGauntletExp : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	Alpha 1;
	Renderstyle "Add";
	Scale 0.55;
	}
	States
	{
	Spawn:
		GNF3 DEF 2 Bright;
		GNF3 GHIJK 2 Bright A_FadeOut(0.2);
		Stop;
	}
}
