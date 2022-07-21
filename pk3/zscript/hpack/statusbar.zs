class HPackStatusBar : HereticStatusBar
{
	private int wiggle;

	override void Draw (int state, double TicFrac)
	{
		BaseStatusBar.Draw(state, TicFrac);

		if (state == HUD_StatusBar)
		{
			BeginStatusBar();
			HPack_DrawMainBar(TicFrac);
		}
		else if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreenStuff();
		}
	}

	protected void HPack_DrawMainBar (double TicFrac)
	{
		DrawImage("BARBACK", (0, 158), DI_ITEM_OFFSETS);
		DrawImage("LTFCTOP", (0, 148), DI_ITEM_OFFSETS);
		DrawImage("RTFCTOP", (290, 148), DI_ITEM_OFFSETS);
		if (isInvulnerable())
		{
			//god mode
			DrawImage("GOD1", (16, 167), DI_ITEM_OFFSETS);
			DrawImage("GOD2", (287, 167), DI_ITEM_OFFSETS);
		}
		//health
		DrawImage("CHAINBAC", (0, 190), DI_ITEM_OFFSETS);
		// wiggle the chain if it moves
		int inthealth =  mHealthInterpolator.GetValue();
		DrawGem("CHAIN", "LIFEGEM2",inthealth, CPlayer.mo.GetMaxHealth(true), (2, 191 + wiggle), 15, 25, 16, (multiplayer? DI_TRANSLATABLE : 0) | DI_ITEM_LEFT_TOP);
		DrawImage("LTFACE", (0, 190), DI_ITEM_OFFSETS);
		DrawImage("RTFACE", (276, 190), DI_ITEM_OFFSETS);
		DrawShader(SHADER_HORZ, (19, 190), (16, 10));
		DrawShader(SHADER_HORZ|SHADER_REVERSE, (278, 190), (16, 10));

		if (!isInventoryBarVisible())
		{
			//statbar
			if (!deathmatch)
			{
				DrawImage("LIFEBAR", (34, 160), DI_ITEM_OFFSETS);
				DrawImage("ARMCLEAR", (57, 171), DI_ITEM_OFFSETS);
				DrawString(mHUDFont, FormatNumber(mHealthInterpolator.GetValue(), 3), (88, 170), DI_TEXT_ALIGN_RIGHT);
			}
			else
			{
				DrawImage("STATBAR", (34, 160), DI_ITEM_OFFSETS);
				DrawImage("ARMCLEAR", (57, 171), DI_ITEM_OFFSETS);
				DrawString(mHUDFont, FormatNumber(CPlayer.FragCount, 3), (88, 170), DI_TEXT_ALIGN_RIGHT);
			}
			DrawString(mHUDFont, FormatNumber(GetArmorAmount(), 3), (255, 170), DI_TEXT_ALIGN_RIGHT);

			//ammo
			Ammo ammo1, ammo2;
			[ammo1, ammo2] = GetCurrentAmmo();
			if (ammo1 != null && ammo2 == null)
			{
				DrawString(mHUDFont, FormatNumber(ammo1.Amount, 3), (136, 162), DI_TEXT_ALIGN_RIGHT);
				DrawTexture(ammo1.icon, (123, 180), DI_ITEM_CENTER);
			}
			else if (ammo2 != null)
			{
				DrawString(mIndexFont, FormatNumber(ammo1.Amount, 3), (137, 165), DI_TEXT_ALIGN_RIGHT);
				DrawString(mIndexFont, FormatNumber(ammo2.Amount, 3), (137, 177), DI_TEXT_ALIGN_RIGHT);
				DrawTexture(ammo1.icon, (115, 169), DI_ITEM_CENTER);
				DrawTexture(ammo2.icon, (115, 180), DI_ITEM_CENTER);
			}

			//keys
			if (CPlayer.mo.CheckKeys(4, false, true)) DrawImage("RKEYICON", (153, 163), DI_ITEM_OFFSETS);
			if (CPlayer.mo.CheckKeys(3, false, true)) DrawImage("YKEYICON", (153, 169), DI_ITEM_OFFSETS);
			if (CPlayer.mo.CheckKeys(1, false, true)) DrawImage("GKEYICON", (153, 175), DI_ITEM_OFFSETS);
			if (CPlayer.mo.CheckKeys(2, false, true)) DrawImage("BKEYICON", (153, 181), DI_ITEM_OFFSETS);

			//inventory box
			if (CPlayer.mo.InvSel != null)
			{
				DrawInventoryIcon(CPlayer.mo.InvSel, (194, 175), DI_ARTIFLASH|DI_ITEM_CENTER|DI_DIMDEPLETED, boxsize:(28, 28));
				if (CPlayer.mo.InvSel.Amount > 1)
				{
					DrawString(mIndexFont, FormatNumber(CPlayer.mo.InvSel.Amount, 3), (209, 182), DI_TEXT_ALIGN_RIGHT);
				}
			}
		}
		else
		{
			DrawImage("INVBAR", (34, 160), DI_ITEM_OFFSETS);
			DrawInventoryBar(diparms_sbar, (49, 160), 7, DI_ITEM_LEFT_TOP, HX_SHADOW);
		}
	}
}
