class KFA_Helper extends Object;

static function bool CheckBossesAlive(WorldInfo WorldInfo)
{
    local KFPawn_Monster Pawn;

    foreach WorldInfo.AllPawns(class'KFPawn_Monster', Pawn)
    {
        if(Pawn.IsABoss() && Pawn.IsAliveAndWell())
        {
            return true;
        }
    }

    return false;
}

static function class<KFPawn_Monster> ReplaceWithVersus(class<KFPawn_Monster> OriginalMonsterClass)
{
    switch(OriginalMonsterClass)
    {
        case class'KFPawn_ZedBloat':
            return class'KFPawn_ZedBloat_Versus';
        case class'KFPawn_ZedClot_Alpha':
            return class'KFPawn_ZedClot_Alpha_Versus';
        case class'KFPawn_ZedClot_AlphaKing':
            return class'KFPawn_ZedClot_AlphaKing_Versus';
        case class'KFPawn_ZedClot_Slasher':
            return class'KFPawn_ZedClot_Slasher_Versus';
        case class'KFPawn_ZedCrawler':
            return class'KFPawn_ZedCrawler_Versus';
        case class'KFPawn_ZedFleshpound':
            return class'KFPawn_ZedFleshpound_Versus';
        case class'KFPawn_ZedGorefast':
            return class'KFPawn_ZedGorefast_Versus';
        case class'KFPawn_ZedHusk':
            return class'KFA_KFPawn_ZedHusk_Versus';
        case class'KFPawn_ZedScrake':
            return class'KFPawn_ZedScrake_Versus';
        case class'KFPawn_ZedSiren':
            return class'KFA_KFPawn_ZedSiren_Versus';
        case class'KFPawn_ZedStalker':
            return class'KFPawn_ZedStalker_Versus';
        default:
            return OriginalMonsterClass;
    }
}

static function class<KFPawn_Monster> ReplaceBossClass(class<KFPawn_Monster> OriginalClass)
{
    switch(OriginalClass)
    {
        case class'KFGameContent.KFPawn_ZedHans':
            return class'KF_Advanced.KFA_Hans';
        case class'KFGameContent.KFPawn_ZedPatriarch':
            return class'KF_Advanced.KFA_Patriarch';
        case class'KFGameContent.KFPawn_ZedFleshpoundKing':
            return class'KF_Advanced.KFA_FleshpoundKing';
        case class'KFGameContent.KFPawn_ZedBloatKing':
            return class'KF_Advanced.KFA_BloatKing';
        case class'KFGameContent.KFPawn_ZedMatriarch':
            return class'KF_Advanced.KFA_Matriarch';
        default:
            return OriginalClass;
    }
}