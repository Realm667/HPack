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
