class KFA_Endless extends KFGameInfo_Endless
    config(Advanced);

var	transient array< class<KFPawn_Monster> > ExtraBossClassList;

var config bool ForceOutbreakWaves;
var config bool ForceSpecialWaves;
var config bool ForceObjectiveCompletion;
var config bool AllowVersus;
var config byte StartVersusWave;
var config bool UseCustomOutbreaks;
var config int ConfigVersion;

event InitGame( string Options, out string ErrorMessage )
{
    Super.InitGame( Options, ErrorMessage );
    SetupConfig(Options);
}

protected function SetupConfig(string Options)
{
    if(ConfigVersion < 1)
    {
        ForceOutbreakWaves = true;
        ForceSpecialWaves = true;
        ForceObjectiveCompletion = true;
        AllowVersus = true;
        StartVersusWave = 11;
        UseCustomOutbreaks = true;
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

    if(HasOption(Options, "AllowVersus"))
    {
        AllowVersus = bool(ParseOption(Options, "AllowVersus"));
    }

    if(HasOption(Options, "StartVersusWave"))
    {
        StartVersusWave = Byte(ParseOption(Options, "StartVersusWave"));
    }

    if(HasOption(Options, "UseCustomOutbreaks"))
    {
        UseCustomOutbreaks = bool(ParseOption(Options, "UseCustomOutbreaks"));
    }


    SaveConfig();
}

function CreateOutbreakEvent()
{
	if (UseCustomOutbreaks)
	{
		OutbreakEventClass = class'KF_Advanced.KFA_KFOutbreakEvent_Endless';
	}

    super.CreateOutbreakEvent();
}

function StartWave()
{
    //Only relevant for first wave otherwise it will be set on WaveEnded()
    TrySetNextWaveSpecial();

    //This is important so the outbreak/weekly scaling applies
    if (KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode != INDEX_NONE)
	{
		OutbreakEvent.SetActiveEvent(KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode);
	}

    super.StartWave();
}

function WaveStarted()
{
    super.WaveStarted();

    if(MyKFGRI.IsBossWave())
    {
        SetTimer(15, false, 'AddExtraBosses');
    }
}

protected function ForceSpecialOrOutbreakIfConfigured()
{
    if(!bForceOutbreakWave && !bForceSpecialWave)
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

/**
 * This overwrite is important to let the wave after the boss be special and to avoid 
 * having a special and outbreak wave at the same time.
 */
function bool TrySetNextWaveSpecial()
{
    local float OutbreakPct, SpecialWavePct;
    local int OutbreakEventIdx;

    if(KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode != INDEX_NONE || KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentSpecialMode != INDEX_NONE || MyKFGRI.IsBossWaveNext())
    {
        return false;
    }

    ForceSpecialOrOutbreakIfConfigured();

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
        bForceSpecialWave = false;
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
		bForceOutbreakWave = false;
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

function AddExtraBosses()
{
    local int AmountBosses, I;

    AmountBosses = FCeil(float(MyKFGRI.WaveNum + 1) / 10);

    for(I = 1; I < AmountBosses; I++)
    {
        AddRandomBoss();
    }
}

private function int AddRandomBoss()
{
    local array< class<KFPawn_Monster> > ExtraBosses;

    ExtraBosses.AddItem(ExtraBossClassList[Rand(ExtraBossClassList.Length)]);

    return SpawnManager.SpawnSquad(ExtraBosses);;
}

function BossDied(Controller Killer, optional bool bCheckWaveEnded = true)
{
    local KFPawn_Monster Pawn;
    
    DramaticEvent(1);

    foreach WorldInfo.AllPawns(class'KFPawn_Monster', Pawn)
    {
        if(Pawn.IsABoss() && Pawn.IsAliveAndWell())
        {
            return;
        }
    }

    super.BossDied(Killer, bCheckWaveEnded);
}

function bool CheckRelevance(Actor Other)
{
    local KFDroppedPickup Weapon;

	if(KFDroppedPickup(Other) != None)
	{
        if(!Weapon.bEmptyPickup)
        {
            Weapon = KFDroppedPickup(Other);
		    Weapon.Lifespan = 86400;
        }
	}

    return super.CheckRelevance(Other);;
}

function class<KFPawn_Monster> GetAISpawnType(EAIType AIType)
{
    local class<KFPawn_Monster> MonsterClass;

    MonsterClass = super.GetAISpawnType(AIType);

    if(ReplaceWithVersus())
    {
        return class'KF_Advanced.KFA_Helper'.static.ReplaceWithVersus(MonsterClass);
    }

    return MonsterClass;
}

protected function bool ReplaceWithVersus()
{
    return AllowVersus && MyKFGRI.WaveNum >= StartVersusWave && bool(Rand(2));
}

DefaultProperties
{
    DefaultPawnClass=class'KF_Advanced.KFA_KFPawn_Human';
    PlayerControllerClass=class'KF_Advanced.KFA_KFPlayerController';
    SpawnManagerClasses(0)=class'KF_Advanced.KFA_KFAISpawnManager_Endless';
    GameReplicationInfoClass=class'KF_Advanced.KFA_KFGameReplicationInfo_Endless';
    HUDType=class'KF_Advanced.KFA_KFGFXHudWrapper';

    ExtraBossClassList(BAT_Hans)=class'KF_Advanced.KFA_Hans';
    ExtraBossClassList(BAT_Patriarch)=class'KF_Advanced.KFA_Patriarch';
    ExtraBossClassList(BAT_KingFleshpound)=class'KF_Advanced.KFA_FleshpoundKing';
    ExtraBossClassList(BAT_KingBloat)=class'KF_Advanced.KFA_BloatKing';
    ExtraBossClassList(BAT_Matriarch)=class'KF_Advanced.KFA_Matriarch';
}