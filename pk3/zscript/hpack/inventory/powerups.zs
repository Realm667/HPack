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
