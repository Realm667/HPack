/*
 * HPack ZScript: Deprecated actor replacers
 */

class HPDeprecatedActor : RandomSpawner
{
	name replacementActor;
	property ReplacementActor: replacementActor;

	Default
	{
		HPDeprecatedActor.ReplacementActor 'Unknown';
	}

	/**
	 * ChooseSpawn
	 *
	 * Logs a warning message to the console and
	 * spawns the replacement actor. 'Nuff said.
	 */
	override Name ChooseSpawn()
	{
		console.Printf(TEXTCOLOR_ORANGE .. "Warning: Actor '%s' has been removed. Spawning '%s' instead until this map is updated.", GetClassName(), replacementActor);
		return replacementActor;
	}
}

class HornBeast : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'RedChaosSerpent';
	}
}

class BloodLich : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'HPSentinel';
	}
}

class ChaosWyvern : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'SkullWizard';
	}
}

class ShadowDragon : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'Beast';
	}
}

class DragonFamiliar : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'None';
	}
}

class JumpClink : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'Clink';
	}
}

class HPBeastStrong : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'RedChaosSerpent';
	}
}

class HPSuperGargoyle : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'HPHereticImpLeader';
	}
}

class HPZTwinedTorchUnlit : HPDeprecatedActor
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'TOTLTwinedTorch2';
	}
	override Name ChooseSpawn()
	{
		console.Printf(TEXTCOLOR_ORANGE .. "Warning: Actor '%s' has been removed. Replace with its lit counterpart with the DORMANT flag.", GetClassName(), replacementActor);
		return replacementActor;
	}
}

class ZWallTorchUnlitNew : HPZTwinedTorchUnlit
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'ZWallTorchNew2';
	}
}

class ZFireBullUnlitNew : HPZTwinedTorchUnlit
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'ZFireBullNew2';
	}
}

class HPZChandelierUnlit : HPZTwinedTorchUnlit
{
	Default
	{
	//$Category HPack Deprecated Classes
		HPDeprecatedActor.ReplacementActor 'HPZChandelier2';
	}
}

class TOTLTwinedTorch2 : TOTLTwinedTorch {Default{ +DORMANT }}
class ZWallTorchNew2 : ZWallTorchNew {Default{ +DORMANT }}
class ZFireBullNew2 : ZFireBullNew {Default{ +DORMANT }}
class HPZChandelier2 : HPZChandelier {Default{ +DORMANT }}