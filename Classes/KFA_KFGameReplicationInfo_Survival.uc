class KFA_KFGameReplicationInfo_Survival extends KFGameReplicationInfo;

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