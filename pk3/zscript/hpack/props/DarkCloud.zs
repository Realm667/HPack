class Darkness : Actor
{
Default
	{
	//$Category EasterEggs
	//$Title Darkness Rift
	//$Sprite DRFTA0
	Radius 1;
	Height 1;
	+NOINTERACTION
	}
	bool active;
	override void BeginPlay(void)
	{
		if(!bDORMANT) Activate(self);
		Super.BeginPlay();
	}
	override void Activate(Actor activator)
	{
		active = true;
	}
	override void Deactivate(Actor activator)
	{
		active = false;
		A_StopSound(7);
	}
States
	{
	Spawn:
		TNT1 A 2 Nodelay
			{
			if(active)
				{
				A_StartSound("DarkRift/Loop",7,CHANF_LOOPING);
				A_SpawnItemEx("DarknessCloud",0,0,30,random(-4,4),random(-4,4),random(-2,2));
				}
			}
		Loop;
	}
}

class DarknessCloud : Actor
{
Default
	{
	+NOINTERACTION
	Renderstyle "Translucent";
	Alpha 0.7;
	}
States
	{
	Spawn:
		TNT1 A 0 Nodelay A_Jump(256,"Spawn1","Spawn2","Spawn3");
	Spawn1:
		DRFT ABCDE 3 A_FadeOut(0.05);
		Loop;
	Spawn2:
		DRFT FGHIJ 3 A_FadeOut(0.05);
		Loop;
	Spawn3:
		DRFT KLMNO 3 A_FadeOut(0.05);
		Loop;
	}
}