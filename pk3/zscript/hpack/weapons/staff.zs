// Corvus's Staff -------------------------------------------------------

/*
Staff Combos:

Left-Right : Doubleswipe, Bash.
Left-Left-Left : Doubleswipe, Uppercut, Thrust.
Left-Left-Right-Right : Doubleswipe, Uppercut, Righthook, Overhead.
Left-Left-Right-Left-Right : Doubleswipe, Uppercut, Righthook, Leftswipe, Overhead.

Right-Right : Block, Hold.
Right-Left-Left : Block, Swing, Bash.
Right-Left-Right-Right : Block, Swing, Leftswipe, Thrust.
*/

class HPStaff : Staff replaces Staff
{
Default
	{
	Weapon.SelectionOrder 3700;
	Weapon.SisterWeapon "HPStaffPowered";
	Weapon.Kickback 10;
	+WEAPON.NOALERT;
	Decal "BulletChip";
	Inventory.PickupMessage "TXT_WPNSTAFF";
	Inventory.Icon "WSTFI0";
	Obituary "$OB_MPSTAFF";
	Tag "$TAG_STAFF";
	}
	uint StaffToken;
	States
	{
	Spawn:
		WSTF A -1;
		Stop;
	Ready:
		STFF A 0 { invoker.StaffToken = 0; }
		STFF A 1
			{
			if(CountInv("MasterScrollActive"))
			{ A_WeaponReady(); }
		else { A_WeaponReady(WRF_NOSECONDARY); }
			}
		Wait;
	Deselect:
		STFF A 1 A_Lower();
		Loop;
	Select:
		STFF A 1 A_Raise();
		Loop;
	Fire:
		STFF A 0 A_JumpIfInventory("MasterScrollActive",1,"Combo");
		STFF A 2;
		STFF A 2 Offset(0,28)A_StartSound("weapons/staffswing");
		STFF B 2 Offset(0,32);
		STFF C 2 Offset(0,34) A_StaffAttack(random[StaffAttack](5, 20),"StaffPuff");
		STFF C 2 Offset(0,32);
		STFF BA 2;
		STFF A 8 A_ReFire();
		Goto Ready;
	Combo:
		"####" "#" 0
			{
			Switch(invoker.StaffToken)
				{
				Case 1: return ResolveState("Left1"); Break;
				Case 2: return ResolveState("Left2"); Break;
				Case 3: return ResolveState("Left3"); Break;
				Case 4: return ResolveState("End"); Break;
				Case 5: return ResolveState("Left5"); Break;
				Case 6: return ResolveState("Right1"); Break;
				}
			return ResolveState(null);
			}
	Left0: //Doubleswipe
		STFF A 2 { A_WeaponOffset(-17,39); invoker.StaffToken+=1; }
		STFF B 2 A_WeaponOffset(-35,53);
		STFF B 2 { A_WeaponOffset(-20,16); A_StartSound("weapons/staffswing1",CHAN_WEAPON); }
		STFF D 2 { A_WeaponOffset(0,32); A_CustomPunch(7,0,0,"StaffPuff",120); }
		STFF EFJK 1;
		STFF L 2 A_StartSound("weapons/staffswing3",CHAN_WEAPON);
		STFF M 2 A_CustomPunch(6,0,0,"StaffPuff",120);
		STFF M 2 A_WeaponOffset(69,48);
		STFF M 2 A_WeaponOffset(118,63);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		goto End;
	Left1: //Uppercut
		TNT1 A 4 { invoker.StaffToken+=1; }
		STFF I 2 A_WeaponOffset(98,141);
		STFF I 1 { A_WeaponOffset(35,80); A_StartSound("weapons/staffswing1",CHAN_WEAPON); }
		STFF I 1 { A_WeaponOffset(0,32); A_CustomPunch(10,0,0,"StaffPuff",120); }
		STFF H 1;
		STFF G 2 A_WeaponOffset(51,72);
		STFF G 2 A_WeaponOffset(0,32);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		Goto End;
	Left2: //Thrust
		TNT1 A 4 { invoker.StaffToken-=6; }
		STFF A 2 A_StartSound("weapons/staffswing2",CHAN_WEAPON);
		STFF B 2;
		STFF C 6 A_CustomPunch(20,0,0,"StaffPuff",144);
		STFF B 2;
		STFF A 8;
		Goto Ready;
	Left3: //Leftswipe
		TNT1 A 4 { invoker.StaffToken+=1; }
		STFF M 2 A_WeaponOffset(118,63);
		STFF M 2 { A_WeaponOffset(69,48); A_StartSound("weapons/staffswing2",CHAN_WEAPON); }
		STFF M 2 A_WeaponOffset(0,32);
		STFF L 1 A_CustomPunch(8,0,0,"StaffPuff",120);
		STFF KJFE 1;
		STFF D 1 A_StartSound("weapons/staffswing3",CHAN_WEAPON);
		STFF B 2 { A_WeaponOffset(-40,32); A_CustomPunch(8,0,0,"StaffPuff",120); }
		STFF B 2 A_WeaponOffset(-95,40);
		STFF B 2 A_WeaponOffset(-135,58);
		TNT1 A 0 A_WeaponOffset(0,32);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		Goto End;
	Left5: //Swing
		TNT1 A 0 { invoker.StaffToken+=1; }
		STFF JK 2;
		STFF L 1 A_StartSound("weapons/staffswing1",CHAN_WEAPON);
		STFF M 1 A_CustomPunch(12,0,0,"StaffPuff",120);
		STFF M 2 A_WeaponOffset(69,48);
		STFF M 2 A_WeaponOffset(118,63);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		Goto End;
	End:
		TNT1 A 0 { invoker.StaffToken-=6; }
		STFF A 1 A_WeaponOffset(0,64);
		STFF A 1 A_WeaponOffset(0,56);
		STFF A 1 A_WeaponOffset(0,48);
		STFF A 1 A_WeaponOffset(0,40);
		Goto Ready;
	AltFire:
		"####" "#" 0
			{
			Switch(invoker.StaffToken)
				{
				Case 1: return ResolveState("Right1"); Break;
				Case 2: return ResolveState("Right2"); Break;
				Case 3: Case 4: return ResolveState("Right3"); Break;
				Case 5: return ResolveState("Right5"); Break;
				Case 6: return ResolveState("Right6"); Break;
				}
			return ResolveState(null);
			}
	Right0: //Block
		STFF B 2 { A_WeaponOffset(-20,16); invoker.StaffToken+=5; }
		STFF D 2 { A_WeaponOffset(0,32); A_StartSound("weapons/staffswing3",CHAN_WEAPON); }
		STFF E 2;
		STFF FFFFF 1 A_SpawnItemEx("StaffBlock",32);
		STFF FFFFFFFF 1 { A_WeaponReady(); A_SpawnItemEx("StaffBlock",32); }
	BlockEnd:
		STFF E 2 { invoker.StaffToken-=6; }
		STFF D 2 A_WeaponOffset(10,32);
		goto Ready;
	Right1: //Bash
		TNT1 A 6 { invoker.StaffToken-=6; }
		STFF N 2;
		STFF N 1 { A_WeaponOffset(-40,72); A_StartSound("weapons/staffswing1",CHAN_WEAPON); }
		STFF O 1 A_WeaponOffset(0,32);
		STFF P 1 A_CustomPunch(16,0,0,"StaffPuff",120);
		STFF P 1 A_WeaponOffset(-30,103);
		TNT1 A 12;
		goto End;
	Right2: //Righthook
		TNT1 A 5 { invoker.StaffToken+=1; }
		STFF B 2 A_WeaponOffset(-135,53);
		STFF B 2 { A_WeaponOffset(-95,21); A_StartSound("weapons/staffswing1",CHAN_WEAPON); }
		STFF B 1 A_WeaponOffset(-40,16);
		STFF D 1 { A_WeaponOffset(0,32); A_CustomPunch(10,0,0,"StaffPuff",120); }
		STFF E 1;
		STFF E 2 A_WeaponOffset(60,32);
		STFF E 2 A_WeaponOffset(120,32);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		goto End;
	Right3: //Overhead
		TNT1 A 6 { invoker.StaffToken-=6; }
		STFF G 2;
		STFF G 2 { A_WeaponOffset(51,72); A_StartSound("weapons/staffswing2",CHAN_WEAPON); }
		STFF H 1 A_WeaponOffset(0,32);
		STFF I 1 A_CustomPunch(30,0,0,"StaffPuff",120);
		STFF I 1 A_WeaponOffset(35,80);
		STFF I 1 A_WeaponOffset(98,131);
		TNT1 A 12;
		goto End;
	Right5: //Hold
		STFF A 0 { A_StartSound("weapons/staffblock",CHAN_WEAPON); invoker.StaffToken-6; }
		STFF F 1 { A_WeaponOffset(6,42); A_SpawnItemEx("StaffBlock",32); }
		STFF F 1 { A_WeaponOffset(3,37); A_SpawnItemEx("StaffBlock",32); }
		STFF F 1 { A_WeaponOffset(0,32); A_SpawnItemEx("StaffBlock",32); }
		STFF FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF 1 A_SpawnItemEx("StaffBlock",32);
		Goto BlockEnd;
	Right6: //LeftswipeJump
		STFF A 0 { invoker.StaffToken-=3; }
		Goto Left3;
	}
}

class StaffBlock : Actor
{
Default
	{
	Health 5;
	Height 44;
	Radius 24;
	Speed 8;
	Renderstyle "None";
	+NOBLOOD
	+SHOOTABLE
	+NOGRAVITY
	+REFLECTIVE
	}
	States
	{
	Spawn: 
		TNT1 A 1;
		Stop;
	Death:
		TNT1 A 0;
		Stop;
	}
}

class HPStaffPowered : HPStaff
{
Default
	{
	+WEAPON.POWERED_UP
	Weapon.SisterWeapon "HPStaff";
	+WEAPON.STAFF2_KICKBACK
	Obituary "$OB_MPPSTAFF";
	Tag "$TAG_STAFFP";
	}
	int readysnd;
	States
	{
	Ready:
		STFP A 0 { invoker.StaffToken = 0; }
		STFP ABC 4 Bright
		{
		if(CountInv("MasterScrollActive"))
			{ A_WeaponReady(); }
		else { A_WeaponReady(WRF_NOSECONDARY); }
		invoker.readysnd = random(0,7);
		if(invoker.readysnd == 7)
			{ A_StartSound("weapons/staffcrackle",10,0,0.6); }
		}
		goto Ready+1;
	Deselect:
		STFP AAAABBBBCCCC 1 Bright A_Lower();
		Loop;
	Select:
		STFP AAAABBBBCCCC 1 Bright A_Raise();
		Loop;
	Fire:
		STFP A 0 A_JumpIfInventory("MasterScrollActive",1,"Combo");
		STFP A 2 Bright;
		STFP D 2 Bright Offset(0,48) A_StartSound("weapons/staffswing");
		STFP D 2 Bright Offset(0,32);
		STFP E 2 Bright Offset(0,34) A_StaffAttack(random[StaffAttack](18,81),"StaffPuff2");
		STFP E 2 Bright Offset(0,32);
		STFP D 2 Bright Offset(0,30);
		STFP C 2 Bright Offset(0,26);
		STFP A 0 Bright Offset(0,32);
		STFP ABC 3 Bright A_ReFire();
		Goto Ready;
	Combo:
		"####" "#" 0
			{
			Switch(invoker.StaffToken)
				{
				Case 1: return ResolveState("Left1"); Break;
				Case 2: return ResolveState("Left2"); Break;
				Case 3: return ResolveState("Left3"); Break;
				Case 4: return ResolveState("End"); Break;
				Case 5: return ResolveState("Left5"); Break;
				Case 6: return ResolveState("Right1"); Break;
				}
			return ResolveState(null);
			}
	Left0: //Doubleswipe
		STFP A 2 Bright { A_WeaponOffset(-17,38); invoker.StaffToken+=1; }
		STFP D 2 Bright A_WeaponOffset(-34,43);
		STFP D 2 Bright { A_WeaponOffset(-20,16); A_StartSound("weapons/staffswing1",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP F 2 Bright { A_WeaponOffset(0,32); A_CustomPunch(14,0,0,"StaffPuff2",120); }
		STFP GHRK 1 Bright;
		STFP L 2 Bright { A_StartSound("weapons/staffswing3",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP S 2 Bright A_CustomPunch(12,0,0,"StaffPuff2",120);
		STFP S 2 Bright A_WeaponOffset(69,48);
		STFP S 2 Bright A_WeaponOffset(118,63);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		goto End;
	Left1: //Uppercut
		TNT1 A 4 { invoker.StaffToken+=1; }
		STFP P 2 Bright A_WeaponOffset(98,131);
		STFP P 1 Bright { A_WeaponOffset(35,80); A_StartSound("weapons/staffswing1",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP P 1 Bright { A_WeaponOffset(0,32); A_CustomPunch(20,0,0,"StaffPuff2",120); }
		STFP Q 1 Bright;
		STFP M 2 Bright A_WeaponOffset(51,72);
		STFP M 2 Bright A_WeaponOffset(0,32);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		Goto End;
	Left2: //Thrust
		TNT1 A 4 { invoker.StaffToken-=6; }
		STFP A 2 Bright { A_StartSound("weapons/staffswing2",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP D 2 Bright;
		STFP E 6 Bright A_CustomPunch(40,0,0,"StaffPuff2",144);
		STFP D 2 Bright;
		STFP BC 4 Bright;
		Goto Ready;
	Left3: //Leftswipe
		TNT1 A 4 { invoker.StaffToken+=1; }
		STFP S 2 Bright A_WeaponOffset(118,63);
		STFP S 2 Bright { A_WeaponOffset(69,48); A_StartSound("weapons/staffswing2",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP S 2 Bright A_WeaponOffset(0,32);
		STFP T 1 Bright A_CustomPunch(16,0,0,"StaffPuff2",120);
		STFP URHV 1 Bright;
		STFP W 1 Bright { A_StartSound("weapons/staffswing3",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP D 2 Bright { A_WeaponOffset(-40,16); A_CustomPunch(16,0,0,"StaffPuff2",120); }
		STFP D 2 Bright A_WeaponOffset(-94,43);
		STFP D 2 Bright A_WeaponOffset(-134,61);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		Goto End;
	Left5: //Swing
		TNT1 A 0 { invoker.StaffToken+=1; }
		STFP RK 2 Bright;
		STFP L 1 Bright { A_StartSound("weapons/staffswing1",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP L 1 Bright A_CustomPunch(24,0,0,"StaffPuff2",120);
		STFP S 2 Bright A_WeaponOffset(69,48);
		STFP S 2 Bright A_WeaponOffset(118,63);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		Goto End;
	End:
		STFP A 0 { invoker.StaffToken-=6; }
		STFP B 1 Bright A_WeaponOffset(0,64);
		STFP B 1 Bright A_WeaponOffset(0,56);
		STFP B 1 Bright A_WeaponOffset(0,48);
		STFP C 1 Bright A_WeaponOffset(0,40);
		Goto Ready;
	AltFire:
		"####" "#" 0
			{
			Switch(invoker.StaffToken)
				{
				Case 1: return ResolveState("Right1"); Break;
				Case 2: return ResolveState("Right2"); Break;
				Case 3: Case 4: return ResolveState("Right3"); Break;
				Case 5: return ResolveState("Right5"); Break;
				Case 6: return ResolveState("Right6"); Break;
				}
			return ResolveState(null);
			}
	Right0: //Block
		STFP D 2 Bright { A_WeaponOffset(-20,16); invoker.StaffToken+=5; }
		STFP F 2 Bright { A_WeaponOffset(0,32); A_StartSound("weapons/staffswing3",CHAN_WEAPON); A_StartSound("weapons/lightstaffblock",7,CHANF_OVERLAP); }
		STFP G 2 Bright;
		STFP JHHHH 1 Bright A_SpawnItemEx("StaffBlock",32);
		STFP IIIIJJJJ 1 Bright { A_WeaponReady(); A_SpawnItemEx("StaffBlock",32); }
	BlockEnd:
		STFP G 2 Bright { invoker.StaffToken-=6; }
		STFP F 2 Bright A_WeaponOffset(10,32);
		goto Ready;
	Right1: //Bash
		TNT1 A 6 { invoker.StaffToken-=6; }
		STFP X 2 Bright;
		STFP X 1 Bright { A_WeaponOffset(-40,72); A_StartSound("weapons/staffswing1",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP Y 1 Bright A_WeaponOffset(0,32);
		STFP Z 1 Bright A_CustomPunch(32,0,0,"StaffPuff2",120);
		STFP Z 1 Bright A_WeaponOffset(-30,103);
		TNT1 A 12 Bright;
		goto End;
	Right2: //Righthook
		TNT1 A 5 { invoker.StaffToken+=1; }
		STFP D 2 Bright A_WeaponOffset(-134,53);
		STFP D 2 Bright { A_WeaponOffset(-94,21); A_StartSound("weapons/staffswing1",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP D 1 Bright A_WeaponOffset(-40,16);
		STFP F 1 Bright { A_WeaponOffset(0,32); A_CustomPunch(20,0,0,"StaffPuff2",120); }
		STFP G 1 Bright;
		STFP G 2 Bright A_WeaponOffset(60,32);
		STFP G 2 Bright A_WeaponOffset(120,32);
		TNT1 AAAAAAAAAAAAAAAA 1 A_WeaponReady();
		goto End;
	Right3: //Overhead
		TNT1 A 6 { invoker.StaffToken-=6; }
		STFP M 2 Bright;
		STFP M 2 Bright { A_WeaponOffset(51,72); A_StartSound("weapons/staffswing2",CHAN_WEAPON); A_StartSound("weapons/lightstaffswing",7,CHANF_OVERLAP); }
		STFP N 1 Bright A_WeaponOffset(0,32);
		STFP O 1 Bright A_CustomPunch(60,0,0,"StaffPuff2",120);
		STFP O 1 Bright A_WeaponOffset(35,80);
		STFP O 1 Bright A_WeaponOffset(98,131);
		TNT1 A 12 Bright;
		goto End;
	Right5: //Hold
		STFP A 0 { A_StartSound("weapons/staffblock",CHAN_WEAPON); invoker.StaffToken-6; }
		STFP H 1 Bright { A_WeaponOffset(6,42); A_SpawnItemEx("StaffBlock",32); }
		STFP H 1 Bright { A_WeaponOffset(3,37); A_SpawnItemEx("StaffBlock",32); }
		STFP H 1 Bright { A_WeaponOffset(0,32); A_SpawnItemEx("StaffBlock",32); }
		STFP HIIIIJJJJHHHHIIIIJJJJHHHHIIIIJ 1 Bright A_SpawnItemEx("StaffBlock",32);
		Goto BlockEnd;
	Right6: //LeftswipeJump
		STFP A 0 Bright { invoker.StaffToken-=3; }
		Goto Left3;
	}
}

class HPStaffPuff : StaffPuff replaces StaffPuff {Default{ +FORCEXYBILLBOARD }}
class HPStaffPuff2 : StaffPuff2 replaces StaffPuff2 {Default{ +FORCEXYBILLBOARD }}
