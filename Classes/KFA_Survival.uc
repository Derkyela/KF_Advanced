class KFA_Survival extends KFGameInfo_Survival
    config(Advanced);

var config bool AllowVersus;
var config bool ForceObjectiveCompletion;
var config int ConfigVersion;

struct native ExtraBossWaveInfo
{
    /** All the waves*/
    var array<byte> Waves;
};

var array< ExtraBossWaveInfo > ExtraBossWaveSettings;
var	array< class<KFPawn_Monster> > ExtraBossClassList;
var array< class<KFPawn_Monster> > BossesToSpawn;
var array<int> StartVersusWave;
var() NumPlayerMods OverrideAmmoRespawnTime;

event InitGame( string Options, out string ErrorMessage )
{
    Super.InitGame( Options, ErrorMessage );
    SetupConfig(Options);
}

protected function SetupConfig(string Options)
{
    if(ConfigVersion < 1)
    {
        AllowVersus = true;
        ForceObjectiveCompletion = false;
        ConfigVersion = 1;
    }

    if(HasOption(Options, "AllowVersus"))
    {
        AllowVersus = bool(ParseOption(Options, "AllowVersus"));
    }

    if(HasOption(Options, "ForceObjectiveCompletion"))
    {
        ForceObjectiveCompletion = bool(ParseOption(Options, "ForceObjectiveCompletion"));
    }

    SaveConfig();
}

function StartWave()
{
    local float TimerDelay;

    super.StartWave();

    if(BossesToSpawn.Length > 0)
    {
        if(!MyKFGRI.IsBossWave())
        {
            // first spawn is delayed by five seconds see super method
            TimerDelay = 5;
        }
        else
        {
            // 15 seconds is after the boss theatrics
            TimerDelay = 15;
        }

        SetTimer(TimerDelay, false, 'StartTrySpawnBossTimer');
    }
}

private function StartTrySpawnBossTimer()
{
    SetTimer(1, true, 'TrySpawnBoss');
}

protected function TrySpawnBoss()
{
    local float PctChanceToSpawn;
    
    PctChanceToSpawn = FClamp(1.0f - (Float(MyKFGRI.AIRemaining) / Float(SpawnManager.WaveTotalAI)), 0.1f, 1.0f);
    

    if(BossesToSpawn.Length > 0)
    {
        if(FRand() <= PctChanceToSpawn || MyKFGRI.AIRemaining <= 1 || MyKFGRI.IsBossWave())
        {
            SpawnBoss();
        }
    }
    else
    {
        ClearTimer('TrySpawnBoss');
    }
}

private function SpawnBoss()
{
    local int AmountSpawned;
    local class<KFPawn_Monster> BossToSpawn;
    local array< class<KFPawn_Monster> > BossToSpawnArray;

    BossToSpawn = BossesToSpawn[Rand(BossesToSpawn.Length)];
    BossToSpawnArray.AddItem(BossToSpawn);

    do
    {
        AmountSpawned = SpawnManager.SpawnSquad(BossToSpawnArray);
    } until (AmountSpawned > 0);

    BossesToSpawn.RemoveItem(BossToSpawn);
}

function WaveStarted()
{
    local int AmountBosses, I;
    local ExtraBossWaveInfo WaveInfo;
    local EBossAIType BossType;
    local array<EBossAIType> AvailableBossTypes;

    AvailableBossTypes.AddItem(BAT_Hans);
    AvailableBossTypes.AddItem(BAT_Patriarch);
    AvailableBossTypes.AddItem(BAT_KingFleshpound);
    AvailableBossTypes.AddItem(BAT_KingBloat);
    AvailableBossTypes.AddItem(BAT_Matriarch);

    if(MyKFGRI.IsBossWave())
    {
        AvailableBossTypes.Remove(MyKFGRI.BossIndex, 1);
    }

    WaveInfo = ExtraBossWaveSettings[GameLength];
	AmountBosses = WaveInfo.Waves[WaveNum - 1];

    for(I = 0; I < AmountBosses; I++)
    {
        BossType = AvailableBossTypes[Rand(AvailableBossTypes.Length)];
        BossesToSpawn.AddItem(ExtraBossClassList[BossType]);
        AvailableBossTypes.RemoveItem(BossType);
    }

    super.WaveStarted();
}

function BossDied(Controller Killer, optional bool bCheckWaveEnded = true)
{
    local KFPawn_Monster Pawn;
    
    DramaticEvent(1);

    if(!MyKFGRI.IsBossWave())
    {
        CheckWaveEnd();
        return;
    }

    foreach WorldInfo.AllPawns(class'KFPawn_Monster', Pawn)
    {
        if(Pawn.IsABoss() && Pawn.IsAliveAndWell())
        {
            return;
        }
    }

    super.BossDied(Killer, bCheckWaveEnded);
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
    return AllowVersus && MyKFGRI.WaveNum >= StartVersusWave[GameLength] && Rand(3) == 2;
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
function ResetPickups( array<KFPickupFactory> PickupList, int NumPickups )
{
    local ExtraBossWaveInfo WaveInfo;
    WaveInfo = ExtraBossWaveSettings[GameLength];

    if(KFPickupFactory_Ammo(PickupList[0]) != none && WaveInfo.Waves[WaveNum - 1] > 0)
    {
        NumPickups = AmmoPickups.Length;
    }

    super.ResetPickups(PickupList, NumPickups);
}

function CreateDifficultyInfo(string Options)
{
    super.CreateDifficultyInfo(Options);

    DifficultyInfo.NumPlayers_AmmoPickupRespawnTime = OverrideAmmoRespawnTime;
}

DefaultProperties
{
    DefaultPawnClass=class'KF_Advanced.KFA_KFPawn_Human';
    PlayerControllerClass=class'KF_Advanced.KFA_KFPlayerController';
    HUDType=class'KF_Advanced.KFA_KFGFXHudWrapper';
    GameReplicationInfoClass=class'KF_Advanced.KFA_KFGameReplicationInfo_Survival';

    ExtraBossClassList(BAT_Hans)=class'KF_Advanced.KFA_Hans';
    ExtraBossClassList(BAT_Patriarch)=class'KF_Advanced.KFA_Patriarch';
    ExtraBossClassList(BAT_KingFleshpound)=class'KF_Advanced.KFA_FleshpoundKing';
    ExtraBossClassList(BAT_KingBloat)=class'KF_Advanced.KFA_BloatKing';
    ExtraBossClassList(BAT_Matriarch)=class'KF_Advanced.KFA_Matriarch';

    StartVersusWave(GL_Short) = 2;
    StartVersusWave(GL_Normal) = 3;
    StartVersusWave(GL_Long) = 3;

    OverrideAmmoRespawnTime={(
                                PlayersMod[0]=25.000000,
                                PlayersMod[1]=12.000000,
                                PlayersMod[2]=8.000000,
                                PlayersMod[3]=5.000000,
                                PlayersMod[4]=4.000000,
                                PlayersMod[5]=3.000000,
                                ModCap=1.000000
                    )};

    //Just 4 on the boss wave because one will be spawned from the normal SpawnManager
    ExtraBossWaveSettings[GL_Short] = {(Waves[0]=0,
                              	       Waves[1]=1,
                              	       Waves[2]=2,
                              	       Waves[3]=3,
                              	       Waves[4]=4)};

    ExtraBossWaveSettings[GL_Normal] = {(Waves[0]=0,
                              	       Waves[1]=0,
                              	       Waves[2]=0,
                              	       Waves[3]=1,
                              	       Waves[4]=2,
                              	       Waves[5]=3,
                              	       Waves[6]=4,
                              	       Waves[7]=4)};

    ExtraBossWaveSettings[GL_Long] = {(Waves[0]=0,
                                       Waves[1]=0,
                                       Waves[2]=0,
                                       Waves[3]=0,
                                       Waves[4]=1,
                                       Waves[5]=1,
                                       Waves[6]=2,
                                       Waves[7]=2,
                                       Waves[8]=3,
                                       Waves[9]=4,
                                       Waves[10]=4)};
}