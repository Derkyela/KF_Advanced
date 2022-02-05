class EE_BloatKing extends KFPawn_ZedBloatKing
    implements(EE_BossInterface);

simulated event PreBeginPlay()
{
    //ArmorInfoClass = class'Endless_Encore.EE_KFZedArmorInfo_BloatKing';
    super.PreBeginPlay();
}

simulated event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove, optional Pawn InInteractionPawn, optional INT InSpecialMoveFlags, optional bool bSkipReplication)
{
    //No intro thatric for extra bosses
    if(NewMove == SM_BossTheatrics) {
        return;
    }

    super.DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags, bSkipReplication);
}
