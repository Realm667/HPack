// Glass -----------------------------------------------------------------------------------------

Class GlassShardSpawner : Actor
{
	string baseShardTypeName;
	property BaseShardType: baseShardTypeName;

	Default
	{
		Alpha 0.0;
		Mass 0;
		Radius 0;
		GlassShardSpawner.BaseShardType "HPShard";
	}

	States
	{
	Spawn:
		TNT1 A 0 NoDelay HP_SpawnGlassShard();
		Stop;
	}

	void HP_SpawnGlassShard()
	{
		int shardIndex = random(1, 10);
		Class<Actor> shardType = (baseShardTypeName .. shardIndex);
		A_SpawnItemEx(shardType, 0, 0, 0, frandom(4, 16), 0, frandom(-4, 4), frandom(-30, 30) );
	}
}
Class HPShard1 : SGShard1 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard2 : SGShard2 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard3 : SGShard3 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard4 : SGShard4 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard5 : SGShard5 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard6 : SGShard6 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard7 : SGShard7 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard8 : SGShard8 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard9 : SGShard9 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }
Class HPShard0 : SGShard0 { Default { -NOGRAVITY; +THRUACTORS; Gravity 0.5; } }

Class GlassShardClearSpawner : GlassShardSpawner
{
	Default
	{
		GlassShardSpawner.BaseShardType "HPShardClear";
	}
}
Class HPShardClear1 : HPShard1 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear2 : HPShard2 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear3 : HPShard3 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear4 : HPShard4 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear5 : HPShard5 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear6 : HPShard6 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear7 : HPShard7 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear8 : HPShard8 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear9 : HPShard9 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
Class HPShardClear0 : HPShard0 { Default { Translation "Grayscale"; RenderStyle "Add"; Alpha 0.5; } }
