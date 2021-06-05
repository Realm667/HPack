/*
 * HPack ZScript: Common utils
 */

/**
 * HPackCachedCvar
 *
 * Lazy cached cvar class, for performance's sake.
 */
class HPackCachedCvar
{
	Name name;
	PlayerInfo player;
	transient CVar cv;

	/**
	 * Create
	 *
	 * Creates n' returns a new cached cvar.
	 * 'Nuff said.
	 */
	static HPackCachedCvar Create(Name name, PlayerInfo player = null)
	{
		HPackCachedCvar newCVar = new('HPackCachedCvar');

		newCVar.name = name;
		newCVar.player = player;

		return newCVar;
	}

	/**
	 * Get
	 *
	 * Returns the cvar. Only calls GetCvar
	 * (which is known to be slow) on first
	 * access, and serves a cached value
	 * on subsequent calls.
	 *
	 * For sanity, this function will very
	 * loudly report an error if the cvar
	 * in question is not defined.
	 */
	CVar Get()
	{
		if(cv) {
			return cv;
		}

		cv = CVar.GetCvar(name, player);
		if(!cv) {
			String cvarTypeName = (player ? "user" : "server");
			ThrowAbortException( "HPackCachedCvar::Get: " .. cvarTypeName .. " cvar '%s' not found. Doublecheck cvarinfo.txt and make sure this cvar is defined correctly!", name );
		}
		return cv;
	}
}
