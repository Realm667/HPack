// Gauntlets of the Necromancer ---------------------------------------------

class HPGauntlets : Gauntlets replaces Gauntlets
{
Default
	{
	//$Category Weapons
	//$Title Gauntlets of the Necromancer
	Scale 0.75;
	Weapon.SisterWeapon "HPGauntletsPowered";
	Weapon.SelectionOrder 2200;
	Obituary "$OB_MPGAUNTLETS";
	Tag "$TAG_GAUNTLETS";
	}
	States
	{
	Ready:
		GAUN A 1 A_WeaponReady();
		Loop;
	Deselect:
		GAUN A 1 A_Lower();
		Loop;
	Select:
		GAUN A 1 A_Raise();
		Loop;
	Fire:
		GAUN B 4 Bright A_StartSound("weapons/gauntletsuse",CHAN_WEAPON);
		GAUN C 4 Bright;
	Hold:
		GAUN D 2 Bright A_GauntletAttack(0);
		GAUN D 2 Bright A_Saw("","",1,"None");
		GAUN E 2 Bright A_Saw("","",1,"GauntletPuff1");
		GAUN E 1 Bright A_Saw("","",1,"None");
		GAUN E 1 Bright A_Saw("","",1,"None");
		GAUN F 2 Bright A_Saw("","",1,"GauntletPuff1");
		GAUN F 2 Bright A_Saw("","",1,"None");
		GAUN C 2 Bright A_ReFire();
		GAUN C 2 Bright;
		GAUN B 4 Bright A_Light0();
		Goto Ready;
	}
}

class HPGauntletsPowered : HPGauntlets
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPGauntlets";
	Weapon.Kickback 100;
	Obituary "$OB_MPPGAUNTLETS";
	Tag "$TAG_GAUNTLETSP";
	}
	States
	{
	Ready:
		GAUN GGGHHHIII 1 Bright A_WeaponReady();
		Loop;
	Deselect:
		GAUN GGGHHHIII 1 Bright A_Lower();
		Loop;
	Select:
		GAUN GGGHHHIII 1 Bright A_Raise();
		Loop;
	Fire:
		GAUN J 4 Bright A_StartSound("weapons/gauntletsuse",CHAN_WEAPON);
		GAUN K 4 Bright;
	Hold:
		GAUN LMN 4 Bright A_GauntletAttack(1);
		GAUN K 4 Bright A_ReFire();
		GAUN J 4 Bright A_Light0();
		Goto Ready;
	}
}
