// ------------------------------------------------------------------------------------------------
//
//   Powerups
//
// ------------------------------------------------------------------------------------------------

class PowerNoDrown : Powerup
{
	Default
	{
		Inventory.Icon "TDEPA0";
	}

	override void DoEffect ()
	{
		if (Owner.player)
		{
			Owner.player.mo.ResetAirSupply();
		}
	}
}

class PowerFireBoots : PowerIronFeet
{
	Default
	{
		Powerup.Duration -60;
		Powerup.Color "ff 40 00", 0.125;
		Powerup.Mode "Full";
	}

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
	{
		// don't protect against drowning
	}

	override void DoEffect ()
	{
		// don't reset air supply
	}
}
