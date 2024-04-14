// Polymorph Wand ---------------------------------------------

class HPMorphWand : Weapon
{
Default
	{
	//$Category Weapons
	//$Title Polymorph Wand
	Weapon.SelectionOrder 2000;
	Weapon.AmmoGive 5;
	Weapon.AmmoUse 1;
	Weapon.AmmoType "AcornAmmo";
	Weapon.YAdjust 0;
	Weapon.SisterWeapon "HPMorphWandPowered";
	Inventory.PickupMessage "$TXT_WPNPOLYMORPH";
	Tag "$TAG_POLYMORPHWAND";
	}
	States
	{
	Spawn:
		ANTL A -1;
		Stop;
	Ready:
		ANTL B 1 A_WeaponReady();
		ANTL B 0 A_Jump(5,"WobbleStart");
		Loop;
	WobbleStart:
		ANTL CCCCCDDDD 1 A_WeaponReady();
	WobbleLoop:
		ANTL D 1 A_WeaponReady();
		ANTL D 0 A_Jump(15,"WobbleEnd");
		Loop;
	WobbleEnd:
		ANTL CCCCC 1 A_WeaponReady();
		Goto Ready;
	Deselect:
		ANTL B 1 A_Lower();
		Loop;
	Select:
		ANTL B 1 A_Raise();
		Loop;
	Fire:
		ANTL EF 3;
		ANTL GH 2 bright;
		ANTL I 2 bright A_FireProjectile("SquirrelFX");
		ANTL FFFFEB 3;
		Goto Ready;
	}
}

class HPMorphWandPowered : HPMorphWand
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPMorphWand";
	Tag "$TXT_POLYMORPHWANDP";
	}
	States
	{
	Fire:
		ANTL E 0 A_JumpIfNoAmmo("Ready");
		ANTL EF 3;
		ANTL GJ 4 bright;
		ANTL K 4 bright A_FireProjectile("SquirrelFX2");
		ANTL JI 4 bright;
		ANTL FFEB 3;
		Goto Ready;
	}
}

class SquirrelFX : MorphProjectile
{
Default
	{
	+FORCEXYBILLBOARD
	Radius 8;
	Height 8;
	Speed 18;
	RenderStyle "Add";
	Alpha 0.5;
	SeeSound "weapons/polyshot";
	DeathSound "weapons/polyhit";
	MorphProjectile.PlayerClass "SquirrelPlayer";
	MorphProjectile.MonsterClass "Squirrel";
	MorphProjectile.Duration 3150;
	MorphProjectile.MorphStyle MRF_UNDOBYTOMEOFPOWER;
	}
	States
	{
	Spawn:
		CURS ABCDEF 4 Bright;
		Loop;
	Death:
		CURS GHIJKL 3 Bright;
		Stop;
	}
}

class SquirrelFX2 : Actor
{
Default
	{
	Radius 1;
	Height 1;
	Speed 3;
	RenderStyle "Add";
	Alpha 0.8;
	Projectile;
	+RIPPER
	+NOBOSSRIP
	+DONTREFLECT
	+BLOODLESSIMPACT
	+NOEXPLODEFLOOR
	+PAINLESS
	+SLIDESONWALLS
	+FORCEXYBILLBOARD
	SeeSound "weapons/polyshot";
	DeathSound "weapons/polyhit";
	reactiontime 30;
	}
	States
	{
	Spawn:
		CURS MNO 4 bright;
		CURS P 4 bright A_Stop();
		CURS QRS 4 bright;
	Stay:
		CURS UVW 5 bright A_SpawnProjectile("SquirrelFX3",-12);
		CURS W 0 bright A_CountDown();
		Loop;
	Death:
		CURS GHIJKL 3 bright;
		Stop;
	}
}

class SquirrelFX3 : MorphProjectile
{
Default
	{
	Radius 16;
	Height 24;
	Speed 0;
	RenderStyle "Add";
	Alpha 0.8;
	DeathSound "weapons/polyhit";
	MorphProjectile.PlayerClass "SquirrelPlayer";
	MorphProjectile.MonsterClass "Squirrel";
	MorphProjectile.Duration 3150;
	MorphProjectile.MorphStyle MRF_UNDOBYTOMEOFPOWER;
	+FORCEXYBILLBOARD
	+NOEXPLODEFLOOR
	+SLIDESONWALLS
	}
	States
	{
	Spawn:
		TNT1 AAAAA 1;
		Stop;
	XDeath:
		CURS GHIJKL 3 bright;
		Stop;
	Death:
		TNT1 A 1;
		Stop;
	}
}

class Squirrel : MorphedMonster// 30156
{
Default
	{
	//$Category Monsters
	//$Title Squirrel
	Health 10;
	Radius 10;
	Height 20;
	Mass 40;
	Speed 10;
	Monster;
	-COUNTKILL
	+DONTMORPH
	+FLOORCLIP
	+FRIGHTENED
	SeeSound "squirrel/active";
	AttackSound "squirrel/attack";
	PainSound "squirrel/pain";
	DeathSound "squirrel/death";
	ActiveSound "squirrel/active";
	Obituary "$OB_SQUIRREL";
	Tag "$FN_SQUIRREL";
	}
	States
	{
	Spawn:
		SQRL AA 10 A_Look();
		Loop;
	See:
		SQRL ABC 3 A_Chase();
		SQRL A 0 { bTOUCHY = true; }
		Loop;
	Melee:
		SQRL A 6;
		SQRL B 6 A_CustomMeleeAttack(random(1,8));
		Goto See;
	Death:
		SQRL D 6 A_Scream();
		SQRL E 6 A_NoBlocking();
		SQRL F 6;
		Stop;
	}
}

class SquirrelPlayer : PlayerPawn
{
Default
	{
	Health 30;
	ReactionTime 0;
	PainChance 255;
	Radius 10;
	Height 20;
	Speed 1;
	+NOSKIN
	-PICKUP
	PainSound "squirrel/pain";
	DeathSound "squirrel/death";
	Player.JumpZ 3;
	Player.Viewheight 18;
	Player.ForwardMove 1.22, 1.22;
	Player.SideMove 1.22, 1.22;
	Player.SpawnClass "Squirrel";
	Player.SoundClass "Squirrel";
	Player.DisplayName "Squirrel";
	Player.MorphWeapon "SquirrelNose";
	}
	States
	{
	Spawn:
		SQRL A -1;
		Stop;
	See:
		SQRL ABC 3;
		Loop;
	Melee:
	Missile:
		SQRL C 12;
		Goto Spawn;
	Pain:
		SQRL C 4 A_Pain();
		Goto Spawn;
	Death:
		SQRL D 3 A_Scream();
		SQRL E 3 A_NoBlocking();
		SQRL F 3;
		TNT1 A 35 A_CheckPlayerDone();
		Wait;
	}
}

class SquirrelNose : Beak
{
Default
	{
	Weapon.SelectionOrder 10000;
	+WEAPON.DONTBOB
	+WEAPON.MELEEWEAPON
	Weapon.YAdjust 15;
	Weapon.SisterWeapon "SquirrelNosePowered";
	}
	States
	{
	Ready:
		SQRL GGGGGG 1 A_WeaponReady();
		SQRL G 0 A_Jump(16,1);
		Loop;
		SQRL H 1 A_StartSound("squirrel/sight");
		SQRL HHH 1;
		Loop;
	Deselect:
		SQRL G 1 A_Lower();
		Loop;
	Select:
		SQRL G 1 A_Raise();
		Loop;
	Fire:
		SQRL H 1 A_StartSound("rat/attack");
		SQRL H 5 A_CustomPunch(2);
		SQRL G 3;
		Goto Ready;
	}
}

class SquirrelNosePowered : SquirrelNose
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "SquirrelNose";
	}
}