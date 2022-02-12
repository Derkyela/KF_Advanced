class EE_Endless extends KFGameInfo_Endless
    config(Endless_Encore);

var	transient array< class<KFPawn_Monster> > ExtraBossClassList;

var config bool ForceOutbreakWaves;
var config bool ForceSpecialWaves;
var config bool ForceObjectiveCompletion;
var config bool AllowVersus;
var config byte StartVersusWave;
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


    SaveConfig();
}

function WaveStarted()
{
    if(KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode == INDEX_NONE && KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentSpecialMode == INDEX_NONE)
    {
        ForceSpecialOrOutbreakIfConfigured();
    }

	super.WaveStarted();

    bForceOutbreakWave = false;
    bForceSpecialWave = false;

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

function bool TrySetNextWaveSpecial()
{
    if(KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentWeeklyMode == INDEX_NONE && KFGameReplicationInfo_Endless(GameReplicationInfo).CurrentSpecialMode == INDEX_NONE)
    {
        ForceSpecialOrOutbreakIfConfigured();
    }

    return super.TrySetNextWaveSpecial();
}

function AddExtraBosses()
{
    local int BossesSpawned;
    local int AmountBosses;
    local array< class<KFPawn_Monster> > ExtraBosses;

    BossesSpawned = 1;

    AmountBosses = FCeil(float(MyKFGRI.WaveNum + 1) / 10);
    while(BossesSpawned < AmountBosses)
    {
        ExtraBosses.AddItem(ExtraBossClassList[Rand(ExtraBossClassList.Length)]);
        BossesSpawned += SpawnManager.SpawnSquad(ExtraBosses);
    }
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

DefaultProperties
{
    PlayerControllerClass=class'Endless_Encore.EE_KFPlayerController';
    SpawnManagerClasses(0)=class'Endless_Encore.EE_KFAISpawnManager_Endless';
    GameReplicationInfoClass=class'Endless_Encore.EE_GameReplicationInfo';
    HUDType=class'Endless_Encore.EE_KFGFXHudWrapper';
    OutbreakEventClass=class'Endless_Encore.EE_KFOutbreakEvent_Endless';

    ExtraBossClassList(BAT_Hans)=class'Endless_Encore.EE_Hans';
    ExtraBossClassList(BAT_Patriarch)=class'Endless_Encore.EE_Patriarch';
    ExtraBossClassList(BAT_KingFleshpound)=class'Endless_Encore.EE_FleshpoundKing';
    ExtraBossClassList(BAT_KingBloat)=class'Endless_Encore.EE_BloatKing';
    ExtraBossClassList(BAT_Matriarch)=class'Endless_Encore.EE_Matriarch';
}