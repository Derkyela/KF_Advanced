class EE_Endless extends KFGameInfo_Endless
    config(Endless_Encore);

var	array< class<KFPawn_Monster> > ExtraBossClassList;

var config bool ForceOutbreakWaves;
var config bool ForceSpecialWaves;
var config bool ForceObjectiveCompletion;
var config int ConfigVersion;

event InitGame( string Options, out string ErrorMessage )
{
	Super.InitGame( Options, ErrorMessage );
    SetupConfig(Options);

    ExtraBossClassList[BAT_Hans] = class'Endless_Encore.EE_Hans';
    ExtraBossClassList[BAT_Patriarch] = class'Endless_Encore.EE_Patriarch';
    ExtraBossClassList[BAT_KingFleshpound] = class'Endless_Encore.EE_FleshpoundKing';
    ExtraBossClassList[BAT_KingBloat] = class'Endless_Encore.EE_BloatKing';
    ExtraBossClassList[BAT_Matriarch] = class'Endless_Encore.EE_Matriarch';
}

event PreBeginPlay()
{
    GameReplicationInfoClass = class'Endless_Encore.EE_GameReplicationInfo';
	super.PreBeginPlay();
}

protected function SetupConfig(string Options) {
    if(ConfigVersion < 1)
    {
        ForceOutbreakWaves = true;
        ForceSpecialWaves = true;
        ForceObjectiveCompletion = true;
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

    if(HasOption(Options, "ForceObjectiveCompletion"))
    {
        ForceObjectiveCompletion = bool(ParseOption(Options, "ForceObjectiveCompletion"));
    }

    SaveConfig();
}

function WaveStarted()
{
    if(!MyKFGRI.IsBossWave())
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
    }

	super.WaveStarted();

    if(MyKFGRI.IsBossWave())
    {
        SetTimer(15, false, 'AddExtraBosses');
    }
}

function AddExtraBosses()
{
    local int I;
    local int AmountBosses;
    local array< class<KFPawn_Monster> > ExtraBosses;

    AmountBosses = FCeil(float(MyKFGRI.WaveNum) / 10);
    for(I = 1; I < AmountBosses; I++)
    {
        ExtraBosses.AddItem(ExtraBossClassList[Rand(ExtraBossClassList.Length)]);
        SpawnManager.SpawnSquad(ExtraBosses);
    }
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

function BossDied(Controller Killer, optional bool bCheckWaveEnded = true)
{
    local KFPawn_MonsterBoss Boss;
    DramaticEvent(1);

    foreach WorldInfo.AllPawns(class'KFPawn_MonsterBoss', Boss)
    {
        if(Boss.Health > 0)
        {            
            return;
        }
    }        

    super.BossDied(Killer, bCheckWaveEnded);
}

defaultproperties {
    SpecialWaveStart=1
	OutbreakWaveStart=1
}