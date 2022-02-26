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