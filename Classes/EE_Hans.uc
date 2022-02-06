class EE_Hans extends KFPawn_ZedHans
    implements(EE_BossInterface);

simulated event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove, optional Pawn InInteractionPawn, optional INT InSpecialMoveFlags, optional bool bSkipReplication)
{
    //No intro thatric for extra bosses
    if(NewMove == SM_BossTheatrics) {
        return;
    }

    super.DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags, bSkipReplication);
}

simulated function UpdateShieldUIOnLocalController(float ShieldPercent)
{
    if (IsBossPawnOfBossHealthBar())
	{
		super.UpdateShieldUIOnLocalController(ShieldPercent);
	}
}

simulated function UpdateBattlePhaseOnLocalPlayerUI()
{
    if (IsBossPawnOfBossHealthBar())
	{
		super.UpdateBattlePhaseOnLocalPlayerUI();
    }
	
}

function PlayBossMusic()
{
	//Only play the music from the initial boss
}

protected function bool IsBossPawnOfBossHealthBar()
{
    return KFPC != none && KFPC.MyGFxHUD != none && KFPC.MyGFxHUD.bossHealthBar != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn.GetMonsterPawn() == self;
}