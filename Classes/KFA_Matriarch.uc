class KFA_Matriarch extends KFPawn_ZedMatriarch
    implements(KFA_BossInterface);

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
    ArmorInfoClass = class'KF_Advanced.KFA_KFZedArmorInfo_Matriarch';
    ControllerClass = class'KF_Advanced.KFA_KFAIController_ZedMatriarch';
}