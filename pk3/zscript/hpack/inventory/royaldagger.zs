/*
 * HPack ZScript: Royal Dagger
 * (c) Xaser Acheron, MIT License, etc.
 *
 * Fires a long-range, single-target-ish damaging projectile.
 * Perfect for taking out those pesky goat snipers in E1.
 *
 * Why a dagger? Well, this was originally conceived as a
 * "sniper arrow" item, but there happened to be some cool
 * dagger sprites lying around so I just used that. :P
 */

class ArtiRoyalDagger : CustomInventory
{
	Default
	{
		// $Category Artifacts
		// $Title Royal Dagger

		+COUNTITEM;
		+FLOATBOB;
		+INVENTORY.INVBAR;
		+INVENTORY.FANCYPICKUPSOUND;		
		Inventory.PickupFlash "PickupFlash";
		Inventory.DefMaxAmount;
		Inventory.Icon "ARTIDAGG";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_ARTIROYALDAGGER";
		Tag "$TAG_ARTIROYALDAGGER";
	}

	States
	{
	Spawn:
		ADAG ABC 4 Bright;
		Loop;
	Use:
		TNT1 A 0 H_ThrowDagger();
		Stop;
	}

	action void H_ThrowDagger()
	{
		A_FireProjectile("RoyalDagger");
	}
}

Class RoyalDagger : FastProjectile
{
	Default
	{
		DamageFunction(80 + 20*random(1,4));
		Radius 10;
		Height 6;
		Speed 60;

		Obituary "$OB_MPROYALDAGGER";
		SeeSound "artifacts/dagger/throw";
		RenderStyle "Normal";
		Decal "HImpScorch";

		-ACTIVATEIMPACT;
		-ACTIVATEPCROSS;
		+FORCEYBILLBOARD;
	}

	States
	{
	Spawn:
		DAGG A 1 Bright H_DaggerTrail();
		Loop;
	Death:
		TNT1 A 1 Bright H_DaggerHitWall();
		Stop;
	XDeath:
		DAGG B 4 Bright H_DaggerHitEnemy();
		DAGG CDE 4 Bright;
		Stop;
	}

	void H_DaggerTrail()
	{
		A_SpawnItemEx("RoyalDaggerTrail", random2[BoltSpark]() * 0.015625, random2[BoltSpark]() * 0.015625, 0, 0, 0, 0, 0, SXF_ABSOLUTEPOSITION, 50);
	}

	void H_DaggerHitWall()
	{
		A_SpawnItemEx("RoyalDaggerPuff");
		A_StartSound("artifacts/dagger/hitwall", CHAN_5);
	}

	void H_DaggerHitEnemy()
	{
		A_SetRenderStyle(1.0, STYLE_ADD);
		A_SpawnItemEx("RoyalDaggerPuff");
		A_StartSound("artifacts/dagger/hitbody", CHAN_5);
		A_Explode(64, 64, 0); // small bit of radius damage, just to chip away a bit
	}
}

Class RoyalDaggerTrail : Actor
{
	Default
	{
		+FORCEXYBILLBOARD;
		+SYNCHRONIZED;
		-RANDOMIZE;
		-NOGRAVITY;

		Alpha 1.0;
		RenderStyle "Add";
		Gravity 0.05;
	}

	States
	{
	Spawn:
		TNT1 A 2;
		GNFX L 8 Bright;
		GNFX M 8 Bright A_FadeOut(0.2);
		Stop;
	}
}

Class RoyalDaggerPuff : Actor
{
	Default
	{
		+NOGRAVITY;
		+NOBLOCKMAP;
		+FORCEXYBILLBOARD;

		Alpha 1.0;
		RenderStyle "Add";
	}

	States
	{
	Spawn:
		SBFX ABCDEFG 3 Bright;
		Stop;
	}
}
