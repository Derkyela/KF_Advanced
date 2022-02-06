class EE_FleshpoundKing extends KFPawn_ZedFleshpoundKing
    implements(EE_BossInterface);

simulated event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove, optional Pawn InInteractionPawn, optional INT InSpecialMoveFlags, optional bool bSkipReplication)
{
    //No intro thatric for extra bosses
    if(NewMove == SM_BossTheatrics) {
        return;
    }

    super.DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags, bSkipReplication);
}

simulated function UpdateShieldUI()
{
    if (IsBossPawnOfBossHealthBar())
	{
		super.UpdateShieldUI();
	}
}

function PlayBossMusic()
{
	//Only play the music from the initial boss
}

protected function bool IsBossPawnOfBossHealthBar()
{
    local KFPlayerController KFPC;
    KFPC = KFPlayerController(GetALocalPlayerController());

    return KFPC != none && KFPC.MyGFxHUD != none && KFPC.MyGFxHUD.bossHealthBar != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn.GetMonsterPawn() == self;
}