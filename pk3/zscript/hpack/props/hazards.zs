/*
 * HPack ZScript: Misc Hazards
 */

Class VolcanoPurpleFX : BishopFX
{
	Default
	{
		DeathSound "";
	}
	States
	{
	Spawn:
		BPFX ABABABABABABABABABABABABABAB 1 Bright A_BishopMissileWeave();
	Fade:
		BPFX AB 1 Bright A_VolcanoPurpleFXFade();
		Loop;
	}

	void A_VolcanoPurpleFXFade()
	{
		A_BishopMissileWeave();
		A_FadeOut(0.05);
	}
}

Class VolcanoPurple : Volcano
{
	States
	{
	Spawn:
		VLCP A 350;
	ThisSureIsAStateName:
		VLCP A 35 A_VolcanoSet();
		VLCP BCDBCD 3;
		VLCP E 10;
		VLCP E 0 A_VolcanoPurpleErupt();
		Goto ThisSureIsAStateName;
	}

	void A_VolcanoPurpleErupt()
	{
		int i;
		for(i = 0; i < 12; i++) {
			A_CustomMissile("VolcanoPurpleFX", 16.0, 0.0, frandom(90.0, 270.0), 6.0, frandom(0.0, 20.0));
		}
		for(i = 0; i < 12; i++) {
			A_CustomMissile("VolcanoPurpleFX", 16.0, 0.0, random(0.0, 360.0), 6.0, frandom(0.0, 90.0));
		}
		A_PlaySound("BishopMissileExplode");
	}
}
