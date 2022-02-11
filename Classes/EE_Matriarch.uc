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

function PlayBossMusic()
{
	//Only play the music from the initial boss
}

DefaultProperties
{
    ArmorInfoClass = class'Endless_Encore.EE_KFZedArmorInfo_Matriarch';
    ControllerClass = class'Endless_Encore.EE_KFAIController_ZedMatriarch';
}