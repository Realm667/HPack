/*
 * HPack ZScript: Shrines
 * (c) Xaser Acheron, MIT License, etc.
 *
 * Shrines grant a boon (item) when touched by a player,
 * provided that they don't already own any of the item
 * (or have one active). Essentially, they're auto-
 * respawning pickups that ensure you have at least 1
 * of a given item.
 */

class ShrineBase : SwitchableDecoration
{
	// associated flare fx actor.
	Actor flare;

	// item to give when receiving a boon.
	Class< Inventory > boonItem;
	property BoonItem:boonItem;

	// powerup associated with the boon item;
	// this is used to check if the player
	// already has one activated.
	Class< Inventory > boonPowerup;
	property BoonPowerup:boonPowerup;

	// boon cooldown tics; used to prevent
	// granting multiple boons at once.
	int boonCooldown;

	States
	{
	Spawn:
	Active:
		TNT1 A 1;
		loop;
	Inactive:
		TNT1 A 1;
		loop;
	}

	Default
	{
		Radius 20;
		Height 16;
		Mass 0x7fffffff;
		RenderStyle "Add";

		+NOGRAVITY;
		+DONTSPLASH;
		+SOLID;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		// spawn a glowy flare thingy
		self.flare = Spawn("ShrineFlare", (pos.x, pos.y, pos.z + 32), NO_REPLACE);
		self.flare.translation = self.translation;
	}

	override void Tick()
	{
		Super.Tick();

		// cool yer jets, kid
		if(self.boonCooldown > 0) {
			self.boonCooldown--;
		}

		// if the local player is eligible to receive a
		// boon, do some fancy visual effects. otherwise,
		// fade out the shrine and hide the flare actor.
		if(H_CheckBoonEligible(players[consoleplayer].mo)) {
			self.alpha = 1.0;
			self.flare.alpha = 1.0;
			H_SpawnShrineSpark();
		} else {
			self.alpha = 0.33;
			self.flare.alpha = 0.0;
		}
	}

	override bool CanCollideWith(Actor other, bool passive)
	{
		// if a player is colliding with this shrine, check if
		// they're eligible for a boon and grant it if so.
		if(passive && H_CheckBoonEligible(PlayerPawn(other))) {
			H_GrantBoon(other);
		}

		// don't actually collide with this actor; we're
		// cheating and using the SOLID flag to trigger this
		// function, but we don't really want it to be solid :P
		return false;
	}

	void H_SpawnShrineSpark()
	{
		A_SpawnItemEx("ShrineSparks", zofs: 32, xvel: frandom(-1, 1), yvel: frandom(-1, 1), zvel: frandom(-1, 1), flags: SXF_TRANSFERTRANSLATION);
	}

	bool H_CheckBoonEligible(Actor playerPawn)
	{
		// check if this player is eligible to receive a
		// boon. players are eligible if the item to be
		// granted is neither in their inventory nor in use.
		if(!playerPawn) {
			return false;
		}

		// don't grant the boon during cooldown.
		if(self.boonCooldown > 0) {
			return false;
		}

		bool hasItem = (playerPawn.FindInventory(self.boonItem));
		bool hasPowerup = (self.boonPowerup && playerPawn.FindInventory(boonPowerup));

		return (!hasItem && !hasPowerup);
	}

	void H_GrantBoon(Actor player)
	{
		// grant a boon to the player. it's a bit cheap,
		// but just spawn an invisible version of the item
		// at the shrine's origin and immediately trigger
		// the pickup logic. it's stupid, but it works. :P
		Actor boon = Spawn(self.boonItem, self.pos);
		if(boon) {
			boon.Touch(player);
			self.boonCooldown = 10;
		}
	}
}

class ShrineSparks : Actor
{
	Default
	{
		Radius 1;
		Height 1;
		RenderStyle "Add";
		Alpha 1.0;
		Scale 0.1;

		+NOINTERACTION;
	}

	States
	{
	Spawn:
		FGST ABCD 3;
		goto Death;
	Death:
		FGST ABCDABCDABCD 3 Bright A_FadeOut(0.1);
		stop;
	}
}

class ShrineFlare : Actor
{
	Default
	{
		RenderStyle "Add";
		Scale 0.4;
		Alpha 1.0;

		+NOINTERACTION;
		+FORCEXYBILLBOARD;
	}

	States
	{
	Spawn:
		WFLR A -1 Bright;
		Stop;
	}
}


//
// Shrines for vanilla Heretic artifacts:
//

class ShrineTeleport : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Chaos Device Shrine

		ShrineBase.BoonItem "ArtiTeleport";
		Translation "0:255=#[255,0,0]";
	}

	States
	{
	Spawn:
	Active:
		STLP A -1 Bright;
		loop;
	}
}

class ShrineEgg : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Morph Ovum Shrine

		ShrineBase.BoonItem "ArtiEgg";
		Translation "0:255=#[121,194,101]";
	}

	States
	{
	Spawn:
	Active:
		SEGG A -1 Bright;
		loop;
	}
}

class ShrineTimeBomb : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Time Bomb of the Ancients Shrine

		ShrineBase.BoonItem "ArtiTimeBomb";
		Translation "0:255=#[160,108,64]";
	}

	States
	{
	Spawn:
	Active:
		SBOM A -1 Bright;
		loop;
	}
}

class ShrineInvisibility : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Shadowsphere Shrine

		ShrineBase.BoonItem "ArtiInvisibility";
		ShrineBase.BoonPowerup "PowerGhost";
		Translation "0:255=#[103,131,95]";
	}

	States
	{
	Spawn:
	Active:
		SNVS A -1 Bright;
		loop;
	}
}

class ShrineInvulnerability : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Ring of Invincibility Shrine

		ShrineBase.BoonItem "ArtiInvulnerability";
		ShrineBase.BoonPowerup "PowerInvulnerable";
		Translation "0:255=#[248,190,3]";
	}

	States
	{
	Spawn:
	Active:
		SINV A -1 Bright;
		loop;
	}
}

class ShrineHealth : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Quartz Flask Shrine

		ShrineBase.BoonItem "ArtiHealth";
		Translation "0:255=#[216,44,252]";
	}

	States
	{
	Spawn:
	Active:
		SPTN A -1 Bright;
		loop;
	}
}

class ShrineTomeOfPower : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Tome of Power Shrine

		ShrineBase.BoonItem "ArtiTomeOfPower";
		ShrineBase.BoonPowerup "PowerWeaponLevel2";
		Translation "0:255=#[255,0,0]";
	}

	States
	{
	Spawn:
	Active:
		SPBK A -1 Bright;
		loop;
	}
}

class ShrineFly : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Wings of Wrath Shrine

		ShrineBase.BoonItem "ArtiFly";
		ShrineBase.BoonPowerup "PowerFlight";
		Translation "0:255=#[248,190,3]";
	}

	States
	{
	Spawn:
	Active:
		SFLY A -1 Bright;
		loop;
	}
}

class ShrineSuperHealth : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Mystic Urn Shrine

		ShrineBase.BoonItem "ArtiSuperHealth";
		Translation "0:255=#[248,190,3]";
	}

	States
	{
	Spawn:
	Active:
		SSPH A -1 Bright;
		loop;
	}
}

class ShrineTorch : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Torch Shrine

		ShrineBase.BoonItem "ArtiTorch";
		ShrineBase.BoonPowerup "PowerTorch";
		Translation "0:255=#[255,127,0]";
	}

	States
	{
	Spawn:
	Active:
		STRC A -1 Bright;
		loop;
	}
}


//
// Shrines for new HPack artifacts:
//

class ShrineHighJump : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Boots of High Jump Shrine

		ShrineBase.BoonItem "ArtiHighJump";
		ShrineBase.BoonPowerup "PowerHighJump";
		Translation "0:255=#[224,255,224]";
	}

	States
	{
	Spawn:
	Active:
		SJMP A -1 Bright;
		loop;
	}
}

class ShrineFireBoots : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Boots of the Firewalker Shrine

		ShrineBase.BoonItem "ArtiFireBoots";
		ShrineBase.BoonPowerup "PowerFireBoots";
		Translation "0:255=#[244,14,3]";
	}

	States
	{
	Spawn:
	Active:
		SFBT A -1 Bright;
		loop;
	}
}

class ShrineTomeOfMight : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Tome of Might Shrine

		ShrineBase.BoonItem "ArtiTomeOfMight";
		ShrineBase.BoonPowerup "TomeOfMightSpeed";
		Translation "0:255=#[255,0,64]";
	}

	States
	{
	Spawn:
	Active:
		STOM A -1 Bright;
		loop;
	}
}

class ShrineBlastRadius : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Disc of Repulsion Shrine

		ShrineBase.BoonItem "ArtiBlastRadius";
		Translation "0:255=#[251,184,0]";
	}

	States
	{
	Spawn:
	Active:
		SBST A -1 Bright;
		loop;
	}
}

class ShrineRoyalDagger : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Royal Dagger Shrine

		ShrineBase.BoonItem "ArtiRoyalDagger";
		Translation "0:255=#[216,44,252]";
	}

	States
	{
	Spawn:
	Active:
		SDAG A -1 Bright;
		loop;
	}
}

class ShrineDepthsTalisman : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Talisman of the Depths Shrine

		ShrineBase.BoonItem "ArtiDepthsTalisman";
		ShrineBase.BoonPowerup "PowerNoDrown";
		Translation "0:255=#[0,96,255]";
	}

	States
	{
	Spawn:
	Active:
		SDEP A -1 Bright;
		loop;
	}
}

class ShrineScrollOfHellfire : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Scroll of Hellfire Shrine

		ShrineBase.BoonItem "ArtiScrollOfHellfire";
		Translation "0:255=#[255,127,0]";
	}

	States
	{
	Spawn:
	Active:
		SHFS A -1 Bright;
		loop;
	}
}

class ShrineMasterScroll : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Scroll of the Master Shrine

		ShrineBase.BoonItem "ArtiMasterScroll";
		ShrineBase.BoonPowerup "MasterScrollActive";
		Translation "0:255=#[224,224,255]";
	}

	States
	{
	Spawn:
	Active:
		SMST A -1 Bright;
		loop;
	}
}

class ShrineMaskOfTerror : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Mask of Terror Shrine

		ShrineBase.BoonItem "ArtiMaskOfTerror";
		ShrineBase.BoonPowerup "PowerFrightener";
		Translation "0:255=#[128,255,0]";
	}

	States
	{
	Spawn:
	Active:
		SMTR A -1 Bright;
		loop;
	}
}

class ShrineRingOfRegeneration : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Ring of Regeneration Shrine

		ShrineBase.BoonItem "ArtiRingOfRegeneration";
		ShrineBase.BoonPowerup "PowerRegeneration";
		Translation "0:255=#[255,224,224]";
	}

	States
	{
	Spawn:
	Active:
		SRGN A -1 Bright;
		loop;
	}
}

class ShrineAegisWard : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Aegis Ward Shrine

		ShrineBase.BoonItem "ArtiAegisWard";
		ShrineBase.BoonPowerup "PowerAegis";
		Translation "0:255=#[127,130,240]";
	}

	States
	{
	Spawn:
	Active:
		SSHL A -1 Bright;
		loop;
	}
}

class ShrineTomeOfEternity : ShrineBase
{
	Default
	{
		// $Category HPack_Shrines
		// $Title Tome of Eternity Shrine

		ShrineBase.BoonItem "ArtiTomeOfEternity";
		ShrineBase.BoonPowerup "PowerEternity";
		Translation "0:255=#[248,190,3]";
	}

	States
	{
	Spawn:
	Active:
		STIN A -1 Bright;
		loop;
	}
}
