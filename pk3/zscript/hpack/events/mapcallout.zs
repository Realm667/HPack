/*
 * HPack ZScript: Map Name+Author Callouts
 */

class HPMapCallout
{
	string name;
	string author;
	Vector2 pos;
	int startTime;
	int endTime;
}

class HPMapCalloutEventHandler : EventHandler
{
	array<HPMapCallout> callouts;

	/**
	 * WorldLoaded
	 *
	 * Kicks off the map author+name callout when a map is started.
	 */
	override void WorldLoaded(WorldEvent e)
	{
		// exclude the titlemap
		if(GameState == GS_TITLELEVEL) {
			return;
		}

		string name   = level.levelname;
		string by     = StringTable.Localize("$MAP_AUTHOR_FORMAT");
		string author = level.authorname == "" ? "" : String.Format(by, level.authorname);

		AddMapCallout(name, author, HP_MAP_CALLOUT_XPOS, HP_MAP_CALLOUT_YPOS, HP_MAP_CALLOUT_DURATION_SECONDS);
	}

	/**
	 * WorldTick
	 *
	 * Removes expired map callouts.
	 */
	override void WorldTick()
	{
		int numCallouts = callouts.Size();
		for(int i = numCallouts-1; i >=0; i--) {
			if(callouts[i].endTime <= level.totaltime ) {
				callouts.Delete(i);
			}
		}
	}

	/**
	 * RenderOverlay
	 *
	 * Draws the map callouts. 'Nuff said.
	 */
	override void RenderOverlay(RenderEvent e)
	{
		int numCallouts = callouts.Size();
		for(int i = 0; i < numCallouts; i++) {
			DrawMapCallout(callouts[i]);
		}
	}

	/**
	 * AddMapCallout
	 *
	 * Does what it says on the tin.
	 */
	void AddMapCallout(string name, string author, float xpos, float ypos, int durationSeconds)
	{
		let callout = new('HPMapCallout');

		callout.name   = name;
		callout.author = author;

		callout.pos.x = xpos;
		callout.pos.y = ypos;

		callout.startTime = level.totaltime;
		callout.endTime   = level.totalTime + (durationSecondS * TICRATE);

		callouts.Push(callout);
	}

	/**
	 * DrawMapCallout
	 *
	 * Ditto.
	 */
	ui void DrawMapCallout(HPMapCallout callout)
	{
		int nameWidth   = bigfont.StringWidth(callout.name) * CleanXFac;
		int nameHeight  = bigfont.GetHeight() * CleanYFac;
		int authorWidth = smallfont.StringWidth(callout.author) * CleanXFac;

		int xpos = Screen.GetWidth()  * callout.pos.x; //these two pos gets their floating point value truncated, requires different formula - ozy81
		int ypos = Screen.GetHeight() * callout.pos.y;

		float startfade = clamp(double(level.totaltime - callout.startTime) / (HP_MAP_CALLOUT_FADE_IN_SECONDS  * TICRATE), 0.0, 1.0);
		float endfade   = clamp(double(callout.endTime - level.totaltime  ) / (HP_MAP_CALLOUT_FADE_OUT_SECONDS * TICRATE), 0.0, 1.0);
		float alpha     = min(startfade, endfade);

		Screen.DrawText(bigfont  , Font.CR_RED  , (xpos - (nameWidth   / 2) ), ypos             , callout.name  , DTA_CleanNoMove, true, DTA_Alpha, alpha);
		Screen.DrawText(smallfont, Font.CR_WHITE, (xpos - (authorWidth / 2) ), ypos + nameHeight, callout.author, DTA_CleanNoMove, true, DTA_Alpha, alpha);
	}
}
