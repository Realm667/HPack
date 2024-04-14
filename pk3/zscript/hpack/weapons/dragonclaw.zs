// Dragon Claw -------------------------------------------------------

class HPBlaster : Blaster replaces Blaster
{
Default
	{
	//$Category Weapons
	//$Title Dragon Claw
	Weapon.SelectionOrder 400;
	Weapon.YAdjust 0;
	Weapon.SisterWeapon "HPBlasterPowered";
	Decal "RailScorchLower";
	Inventory.PickupMessage "$TXT_WPNBLASTER";
	Obituary "$OB_MPBLASTER";
	Tag "$TAG_BLASTER";
	}
	States
	{
	Ready:
		BLSR A 1 A_WeaponReady();
		Loop;
	Deselect:
		BLSR A 1 A_Lower();
		Loop;
	Select:
		BLSR A 1 A_Raise();
		Loop;
	Fire:
		BLSR BC 3 Bright;
	Hold:
		BLSR D 2 Bright A_FireBlasterPL1;
		BLSR CB 2 Bright;
		BLSR A 0 Bright A_Refire();
		Goto Ready;
	}
}

class HPBlasterPowered : HPBlaster
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPBlaster";
	Weapon.AmmoUse 5;
	Weapon.AmmoGive 0;
	Tag "$TAG_BLASTERP";
	Obituary "$OB_MPBLASTER";
	}
	States
	{
	Fire:
		BLSR BC 0;
	Hold:
		BLSR D 2 Bright A_FireProjectile("HPBlasterFX1");
		BLSR CB 2 Bright;
		BLSR A 5;
		BLSR A 0 A_ReFire;
		Goto Ready;
	}
}

class HPBlasterPuff : BlasterPuff replaces BlasterPuff
{
Default
	{
	+FORCEXYBILLBOARD
	}
	States
	{
	Crash:
		FX17 A 4 Bright Light("CLAWPUFF1");
		FX17 B 4 Bright Light("CLAWPUFF2");
		FX17 C 4 Bright Light("CLAWPUFF3");
		FX17 D 4 Bright Light("CLAWPUFF4");
		FX17 E 4 Bright;
		Stop;
	Spawn:
		FX17 F 4 Bright Light("CLAWPUFF1");
		FX17 G 4 Bright Light("CLAWPUFF2");
		FX17 H 4 Bright Light("CLAWPUFF3");
		FX17 I 4 Bright Light("CLAWPUFF4");
		FX17 JKL 4 Bright;
		Stop;
	}
}

class HPBlasterFX1 : BlasterFX1 replaces BlasterFX1 {Default { +FORCEXYBILLBOARD Decal "HImpScorch"; Obituary "$OB_MPPBLASTER"; }}
class HPBlasterSmoke : BlasterSmoke replaces BlasterSmoke {Default { +FORCEXYBILLBOARD }}
class HPRipper : Ripper replaces Ripper {Default { +FORCEXYBILLBOARD Decal "HImpScorch"; }}