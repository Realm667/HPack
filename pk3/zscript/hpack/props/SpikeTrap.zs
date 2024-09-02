class SpikeTrap : Actor
{
enum STArgs { ARG_SOUND }
Default
	{
	//$Category HPack_SpecialEffects
	//$Title Spike Trap
	//$Sprite 4XSPA0
	//$NotAngled
	
	//$Arg0 Sound
	//$Arg0Type 11
	//$Arg0Enum { 0 = "Yes"; 1 = "No"; }
	-SOLID
	+FLOORCLIP
	Radius 30;
	Height 58;
	}
	bool SpikeTrigger;
	override void Activate(Actor activator)
	{
		SpikeTrigger = true;
	}
	override void Deactivate(Actor activator) { }
States
	{
	Spawn:
		TNT1 A 1 Nodelay A_JumpIf(SpikeTrigger == true,"Rising");
		Loop;
	Rising:
		4XSP A 3 A_SpriteOffset(0,55);
		4XSP A 20 { A_SpriteOffset(0,50); if (Args[ARG_SOUND] < 1) A_StartSound("Spiketrap/Alert"); }
		4XSP A 2 { A_SpriteOffset(0,40); if (Args[ARG_SOUND] < 1) A_StartSound("Spiketrap/Raise"); }
		4XSP A 2
			{
			bSOLID = true; A_SpriteOffset(0,20); A_SpawnItemEx("ExtraExplosion",0,0,48);
			RadiusAttack(self,500,32,'none',RADF_SOURCEISSPOT|RADF_THRUSTLESS,32,'none');
			}
		4XSP A 100 A_SpriteOffset(0,0);
		4XSP A 2 { A_SpriteOffset(0,5); bSOLID = false; if (Args[ARG_SOUND] < 1) A_StartSound("Spiketrap/Lower"); }
		4XSP A 2 A_SpriteOffset(0,10);
		4XSP A 2 A_SpriteOffset(0,15);
		4XSP A 2 A_SpriteOffset(0,20);
		4XSP A 2 A_SpriteOffset(0,25);
		4XSP A 2 A_SpriteOffset(0,30);
		4XSP A 2 A_SpriteOffset(0,35);
		4XSP A 2 A_SpriteOffset(0,40);
		4XSP A 2 A_SpriteOffset(0,45);
		4XSP A 2 A_SpriteOffset(0,50);
		4XSP A 2 A_SpriteOffset(0,55);
		TNT1 A 20;
		TNT1 A 2 { SpikeTrigger = false; }
		goto Spawn;
	}
}

class ExtraExplosion : Actor
{
Default
	{
	+NOINTERACTION
	Radius 30;
	Height 30;
	}
States
	{
	Spawn:
		TNT1 A 1 Nodelay RadiusAttack(self,500,32,'none',RADF_SOURCEISSPOT|RADF_THRUSTLESS,32,'none');
		Stop;
	}
}