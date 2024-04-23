// ------------------ //
// SCROLL OF HELLFIRE //
// ------------------ //

class ArtiScrollOfHellfire : CustomInventory
{
Default
	{
	//$Category Artifacts
	//$Title Scroll of Hellfire
	+INVENTORY.INVBAR
	+FLOATBOB
	+COUNTITEM
	Inventory.PickupSound "misc/p_pkup";
	Inventory.Icon "ARTIHFSC";
	Inventory.PickupFlash "PickupFlash";
	Inventory.DefMaxAmount;
	Inventory.PickupMessage "$TXT_ARTIHELLFIRE";
	Tag "$TAG_ARTIHELLFIRE";
	}
States
	{
	Spawn:
		AHFS ABCB 6 Bright;
		Loop;
	Use:
		TNT1 A 0 A_JumpIf(Waterlevel>1,"Failed");
		TNT1 A 0 A_FireProjectile("FirewallSpawner",0,0,0);
		Stop;
	Failed:
		TNT1 A 0 A_Print("$TXT_FIREWALLFAILED");
		Fail;
	}
}

class FirewallSpawner : Actor
{
Default
	{
	Radius 8;
	Height 5;
	Damage 0;
	Speed 16;
	+THRUACTORS
	+DROPOFF
	+FLOORCLIP
	+NOBLOCKMAP
	+DONTSPLASH
	+NOTELEPORT
	}
States
	{
	Spawn:
		TNT1 A 4;
	Death:
		TNT1 A 6 { HP_HFWallSpwnSet(0,1338); A_Stop(); A_StartSound("ScrollOfHellfire/Start",7); }
		TNT1 A 6 { HP_HFWallSpwnSet(-32,1337); HP_HFWallSpwnSet(-16); HP_HFWallSpwnSet(16); HP_HFWallSpwnSet(32,1337); }
		TNT1 A 6 { HP_HFWallSpwnSet(-64,1338); HP_HFWallSpwnSet(-48); HP_HFWallSpwnSet(48); HP_HFWallSpwnSet(64,1338); }
		TNT1 A 6 { HP_HFWallSpwnSet(-80); HP_HFWallSpwnSet(80); }
		Stop;
	}
void HP_HFWallSpwnSet(double postn, int tagn = 0)
	{
	A_SpawnItemEx("FireWall",0,postn,0,0,0,0,0,SXF_TRANSFERPOINTERS,0,tagn);
	}
}

class FireWall : Actor
{
Default
	{
	Radius 15;
	Height 60;
	Mass 1000;
	DamageType "Fire";
	Obituary "$OB_HELLFIRE";
	+SHOOTABLE
	+NOTELEPORT
	+NODAMAGE
	+DONTTHRUST
	+NOBLOOD
	+DONTSPLASH
	+NODAMAGETHRUST
	+BLOODLESSIMPACT
	-BLOODSPLATTER
	+NOTARGET
	+NOTAUTOAIMED // [Blue Shadow] Don't snag autoaim
	}
int countd;
States
	{
	Spawn:
		TNT1 A 1 { A_Explode(2,32,XF_HURTSOURCE,0,32); HP_WillitBurn(); }
		TNT1 AAAA 1 HP_WillitBurn();
		Loop;
	Death:
		TNT1 A 2 { A_RemoveLight("HF"); A_SoundVolume(9,0.35); }
		TNT1 A 2 A_SoundVolume(9,0.3);
		TNT1 A 2 A_SoundVolume(9,0.25);
		TNT1 A 2 A_SoundVolume(9,0.2);
		TNT1 A 2 A_SoundVolume(9,0.15);
		TNT1 A 2 A_SoundVolume(9,0.1);
		TNT1 A 2 A_SoundVolume(9,0.05);
		TNT1 A 2 A_StopSound(9);
		Stop;
	}
override void Tick()
	{
	Super.Tick();
	if (Waterlevel > 1)
		{
		A_Die();
		}
	}
void HP_WillitBurn()
	{
	if (TID >= 1337)
		{
		A_SpawnItemEx("FirewallFlames",Random(0,4),0,15,Random(0,2),0,Random(1,3),Random(0,360),128);
		A_AttachLightDef("HF","HELLFIRE");
		if (TID == 1338)
			{ A_StartSound("ScrollOfHellfire/Loop",9,CHANF_LOOPING,0.4,ATTN_NORM,frandom(0.69,0.71)); }
		}
	countd++;
	if (countd == 1050)
		{ A_Die(); }
	}
}

class FirewallFlames : Actor
{
Default
	{
	+NOINTERACTION
	+FORCEXYBILLBOARD
	RenderStyle "Add";
	Scale 0.65;
	}
States
	{
	Spawn:
		TNT1 A 0 NoDelay A_Jump(128,"Spawn2");
		HLFR ABCDEFG 2 Bright;
		HLFR HIJKL 1 Bright A_FadeOut(0.15);
		Stop;
	Spawn2:
		HLFR MNOPQRS 2 Bright;
		HLFR TUVWX 1 Bright A_FadeOut(0.15);
		Stop;
	}
}

// ------------ //
// END HELLFIRE //
// ------------ //