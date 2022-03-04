class KFA_BloatKing extends KFPawn_ZedBloatKing;

simulated event DoSpecialMove(ESpecialMove NewMove, optional bool bForceMove, optional Pawn InInteractionPawn, optional INT InSpecialMoveFlags, optional bool bSkipReplication)
{
    local KFA_GameInfoInterface KFGI;
    KFGI = KFA_GameInfoInterface(WorldInfo.Game);

    //No intro thatric for extra bosses
    if(NewMove == SM_BossTheatrics && KFGI != none && !KFGI.GetShowBossCinematic()) {
        return;
    }

    KFGI.SetShowBossCinematic(false);

    super.DoSpecialMove(NewMove, bForceMove, InInteractionPawn, InSpecialMoveFlags, bSkipReplication);
}

function PlayBossMusic()
{
	//Only play the music from the initial boss
}

DefaultProperties
{
    ArmorInfoClass=class'KF_Advanced.KFA_KFZedArmorInfo_BloatKing';
    ZedBumpDamageScale=0.f;
}
