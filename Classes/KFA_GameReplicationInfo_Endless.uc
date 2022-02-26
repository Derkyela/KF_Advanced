class KFA_GameReplicationInfo_Endless extends KFGameReplicationInfo_Endless;

var protected KFA_Endless KFGI;
var protected bool CheckForObjectiveCompletion;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    KFGI = KFA_Endless(WorldInfo.Game);
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