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
		HPDeprecatedActor.ReplacementActor 'RedChaosSerpent';
	}
}

class BloodLich : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'HPSentinel';
	}
}

class ChaosWyvern : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'SkullWizard';
	}
}

class ShadowDragon : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'Beast';
	}
}

class DragonFamiliar : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'None';
	}
}

class JumpClink : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'Clink';
	}
}

class HPBeastStrong : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'RedChaosSerpent';
	}
}

class HPSuperGargoyle : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'HPHereticImpLeader';
	}
}

class HPZTwinedTorchUnlit : HPDeprecatedActor
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'TOTLTwinedTorch2';
	}
	override Name ChooseSpawn()
	{
		console.Printf(TEXTCOLOR_ORANGE .. "Warning: Actor '%s' has been removed. Replace it with its lit counterpart with the DORMANT flag set.", GetClassName(), replacementActor);
		return replacementActor;
	}
}

class ZWallTorchUnlitNew : HPZTwinedTorchUnlit
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'ZWallTorchNew2';
	}
}

class ZFireBullUnlitNew : HPZTwinedTorchUnlit
{
	Default
	{
		HPDeprecatedActor.ReplacementActor 'ZFireBullNew2';
	}
}

class TOTLTwinedTorch2 : TOTLTwinedTorch {Default{ +DORMANT }}
class ZWallTorchNew2 : ZWallTorchNew {Default{ +DORMANT }}
class ZFireBullNew2 : ZFireBullNew {Default{ +DORMANT }}