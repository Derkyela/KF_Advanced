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