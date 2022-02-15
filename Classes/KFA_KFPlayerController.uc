class KFA_KFPlayerController extends KFPlayerController;

function AddZedKill( class<KFPawn_Monster> MonsterClass, byte Difficulty, class<DamageType> DT, bool bKiller )
{
    if (bKiller && MonsterClass.default.bVersusZed)
	{
		ReceiveLocalizedMessage(Class'KFLocalMessage_PlayerKills', KMT_PLayerKillZed, PlayerReplicationInfo, none, MonsterClass);
	}

	super.AddZedKill( MonsterClass, Difficulty, DT, bKiller );
}
