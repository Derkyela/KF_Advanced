class EE_Endless extends KFGameInfo_Endless
    config(Endless_Encore);

var	transient array< class<KFPawn_Monster> > ExtraBossClassList;
var transient bool IsWaveStart;

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
    IsWaveStart = true;

    if(MyKFGRI.WaveNum == 1)
    {
        ForceSpecialOrOutbreakIfConfigured();
    }

	super.WaveStarted();

    if(MyKFGRI.IsBossWave())
    {
        SetTimer(15, false, 'AddExtraBosses');
    }
}

protected function ForceSpecialOrOutbreakIfConfigured()
{
    if(!bForceOutbreakWave && !bForceSpecialWave && KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode == INDEX_NONE && !bUseSpecialWave && KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentSpecialMode == INDEX_NONE)
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
}

function AddExtraBosses()
{
    local int I;
    local int AmountBosses;
    local array< class<KFPawn_Monster> > ExtraBosses;

    AmountBosses = FCeil(float(MyKFGRI.WaveNum + 1) / 10);
    for(I = 1; I < AmountBosses; I++)
    {
        ExtraBosses.AddItem(ExtraBossClassList[Rand(ExtraBossClassList.Length)]);
        SpawnManager.SpawnSquad(ExtraBosses);
    }
}

function bool TrySetNextWaveSpecial()
{
    if ((!MyKFGRI.IsBossWave() || !IsWaveStart) && !MyKFGRI.IsBossWaveNext() && !(MyKFGRI.WaveNum == 1 && IsWaveStart))
	{
		ForceSpecialOrOutbreakIfConfigured();
	}

    return super.TrySetNextWaveSpecial();
}

function WaveEnded(EWaveEndCondition WinCondition)
{
    IsWaveStart = false;
    super.WaveEnded(WinCondition);
}

function BossDied(Controller Killer, optional bool bCheckWaveEnded = true)
{
    local KFPawn_MonsterBoss Boss;
    DramaticEvent(1);

    foreach WorldInfo.AllPawns(class'KFPawn_MonsterBoss', Boss)
    {
        if(Boss.IsAliveAndWell())
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