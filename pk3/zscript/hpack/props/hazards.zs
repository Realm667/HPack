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
	int LightRad; int LightCol; int LightZ;
	States
	{
	Spawn:
		VLCP A 350;
	ThisSureIsAStateName:
		VLCP A 35 { A_RemoveLight('Light'); LightRad = 48; LightCol = 250; LightZ = 30; A_VolcanoSet(); }
		VLCP BCDBCD 3;
		VLCP E 0 A_VolcanoPurpleErupt();
		VLCP EEEEEAAAAA 2
		{
			color Purp = color(LightCol,0,LightCol);
			A_AttachLight('Light',DynamicLight.PointLight,Purp,LightRad,LightRad,DynamicLight.LF_ATTENUATE,(0,0,LightZ));
			LightRad+=32; LightCol-=25; LightZ+=10;
		}
		Goto ThisSureIsAStateName;
	}

	void A_VolcanoPurpleErupt()
	{
		int i;
		for(i = 0; i < 12; i++) {
			A_SpawnProjectile("VolcanoPurpleFX", 16.0, 0.0, frandom(90.0, 270.0), CMF_AIMDIRECTION, frandom(-20.0, -1.0));
		}
		for(i = 0; i < 12; i++) {
			A_SpawnProjectile("VolcanoPurpleFX", 16.0, 0.0, random(0.0, 359.0), CMF_AIMDIRECTION, frandom(-90.0, -1.0));
		}
		A_StartSound("BishopMissileExplode");
	}
}
