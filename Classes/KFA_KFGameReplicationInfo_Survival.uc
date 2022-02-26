class KFA_KFGameReplicationInfo_Survival extends KFGameReplicationInfo;

var protected KFA_Survival KFGI;
var protected bool CheckForObjectiveCompletion;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    KFGI = KFA_Survival(WorldInfo.Game);
}

function ActivateObjective(KFInterface_MapObjective NewObjective, bool bUseEndlessSpawning = false)
{
    if(KFGI.ForceObjectiveCompletion)
    {
        bUseEndlessSpawning = true;
        SetTimer(0.1, true, 'DisableEndlessSpawningIfComplete');
    }

    super.ActivateObjective(NewObjective, bUseEndlessSpawning);
}

function DisableEndlessSpawningIfComplete()
{
    if(ObjectiveInterface != none && KFGI.SpawnManager.bTemporarilyEndless && ObjectiveInterface.IsComplete())
    {
        KFGI.SpawnManager.bTemporarilyEndless = false;
        bWaveIsEndless = false;
        ClearTimer('DisableEndlessSpawningIfComplete');
    }
}

simulated function bool ShouldSetBossCamOnBossDeath()
{
    if(!IsBossWave())
    {
        return false;
    }

    if(class'KF_Advanced.KFA_Helper'.static.CheckBossesAlive(WorldInfo))
    {
        return false;
    }

	return true;
}