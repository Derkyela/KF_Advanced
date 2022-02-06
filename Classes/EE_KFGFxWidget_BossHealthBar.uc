class EE_KFGFxWidget_BossHealthBar extends KFGFxWidget_BossHealthBar;

var array<KFInterface_MonsterBoss> BossList;

function SetBossPawn(KFInterface_MonsterBoss NewBoss)
{
    BossList.AddItem(NewBoss);
}

function TickHud(float DeltaTime)
{
    local int i;
    if(BossPawn != none && !BossPawn.GetMonsterPawn().IsAliveAndWell())
    {
        i = BossList.Find(BossPawn);
        BossList.Remove(i, 1);
        RemoveArmorUI();
        BossPawn = none;
    }

    if(BossPawn == none && BossList.Length > 0)
    {
        BossPawn = BossList[0];
        SetBossName(BossPawn.GetMonsterPawn().static.GetLocalizedName());
        SetBossIcon();
        SetBattlePhase();

        if(BossPawn.GetMonsterPawn().ArmorInfo != none)
        {
            BossPawn.GetMonsterPawn().ArmorInfo.UpdateArmorUI();
        }
    }

    if(BossPawn != none && !BossPawn.GetMonsterPawn().IsDoingSpecialMove(SM_BossTheatrics))
    {
        SetVisible(true);
        UpdateBossHealth();
    } else {
        SetVisible(false);
    }
}

function Reset()
{
    BossPawn = none;
    BossList.Remove(0, BossList.Length - 1);
}

function RemoveFromBossList(KFInterface_MonsterBoss Boss)
{
    local int i;
    return;
    i = BossList.Find(Boss);
    BossList.Remove(i, 1);

    if(Boss == BossPawn)
    {
        BossPawn = none;
    }
}

function OnNamePlateHidden()
{

}

protected function SetBattlePhase()
{
    local KFPawn_MonsterBoss MonsterBoss;

    if(KFPawn_MonsterBoss(BossPawn) != none)
    {
        MonsterBoss = KFPawn_MonsterBoss(BossPawn);
        UpdateBossBattlePhase(MonsterBoss.GetCurrentBattlePhase());
    }
    else
    {
        UpdateBossBattlePhase(1);
    }
}