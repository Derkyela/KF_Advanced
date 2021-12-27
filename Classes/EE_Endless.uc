class EE_Endless extends KFGameInfo_Endless
    config(Endless_Encore);

var config bool ForceOutbreakWaves;
var config bool ForceSpecialWaves;
var config int ConfigVersion;

event InitGame( string Options, out string ErrorMessage )
{
	Super.InitGame( Options, ErrorMessage );
    SetupConfig(Options);
}

protected function SetupConfig(string Options) {
    if(ConfigVersion < 1)
    {
        ForceOutbreakWaves = true;
        ForceSpecialWaves = true;
        ConfigVersion = 1;
    }

    if(HasOption(Options, "ForceOutbreakWaves"))
    {
        ForceOutbreakWaves = bool(ParseOption(Options, "ForceOutbreakWaves"));
    }

    if(HasOption(Options, "ForceSpecialWaves"))
    {
        ForceSpecialWaves = bool(ParseOption(Options, "ForceSpecialWaves"));
    }

    SaveConfig();
}

function WaveStarted()
{
    if (ForceOutbreakWaves && ForceSpecialWaves)
    {
        if (bool(Rand(2)))
        {
            bForceOutbreakWave = true;
        }
        else
        {
            bForceSpecialWave = true;
        }
    }
    else
    {
        if (ForceOutbreakWaves)
        {
            bForceOutbreakWave = true;
        }

        if (ForceSpecialWaves)
        {
            bForceSpecialWave = true;
        }
    }

	super.WaveStarted();
}

function bool TrySetNextWaveSpecial()
{
	local float OutbreakPct, SpecialWavePct;
	local int OutbreakEventIdx;

    //Originally it is not allowed to have a special or outbreak wave right before the boss
    //so if the next wave is the boss we do it anyway, otherwise we use the core method
	if (MyKFGRI.IsBossWaveNext())
	{
		OutbreakPct = EndlessDifficulty.GetOutbreakPctChance();
        SpecialWavePct = EndlessDifficulty.GetSpeicalWavePctChance();
        if (bForceOutbreakWave || (WaveNum >= OutbreakWaveStart && OutbreakPct > 0.f && FRand() < OutbreakPct))
        {
            if(DebugForcedOutbreakIdx == INDEX_NONE)
            {
                OutbreakEventIdx = Rand(OutbreakEvent.SetEvents.length);
            }
            else
            {
                `log("Forcing Outbreak" @ DebugForcedOutbreakIdx);
                OutbreakEventIdx = DebugForcedOutbreakIdx;
            }
            KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode = OutbreakEventIdx;
            bForceOutbreakWave = false;
            DebugForcedOutbreakIdx = INDEX_NONE;
            return true;
        }
        else if (bForceSpecialWave || (WaveNum >= SpecialWaveStart && SpecialWavePct > 0.f && FRand() < SpecialWavePct))
        {
            bUseSpecialWave = true;
            if(DebugForceSpecialWaveZedType == INDEX_NONE)
            {
                SpecialWaveType = EndlessDifficulty.GetSpecialWaveType();
            }
            else
            {
                `log("Forcing Special Wave Type" @ EAIType(DebugForceSpecialWaveZedType));
                SpecialWaveType = EAIType(DebugForceSpecialWaveZedType);
            }
            KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentSpecialMode = SpecialWaveType;
            bForceSpecialWave = false;
            DebugForceSpecialWaveZedType = INDEX_NONE;
            return true;
        }

        bForceOutbreakWave = false;
        bForceSpecialWave = false;

        DebugForcedOutbreakIdx = INDEX_NONE;
        DebugForceSpecialWaveZedType = INDEX_NONE;

        return false;
	}
    else
    {
        return super.TrySetNextWaveSpecial();
    }
}

defaultproperties {
    SpecialWaveStart=1
	OutbreakWaveStart=1
}