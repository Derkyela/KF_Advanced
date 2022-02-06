class EE_Matriarch extends KFPawn_ZedMatriarch
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
    if (KFPC != none && KFPC.MyGFxHUD != none && KFPC.MyGFxHUD.bossHealthBar != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn.GetMonsterPawn() == self)
	{
		super.UpdateShieldUI();
	}
}

DefaultProperties
{
    ArmorInfoClass = class'Endless_Encore.EE_KFZedArmorInfo_Matriarch';
}