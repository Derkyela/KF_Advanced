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

        if(BossPawn.GetMonsterPawn().ArmorInfo != none)
        {
            BossPawn.GetMonsterPawn().ArmorInfo.UpdateArmorUI();
        }
    }

    if(BossPawn != none && !BossPawn.GetMonsterPawn().IsDoingSpecialMove(SM_BossTheatrics))
    {
        SetVisible(true);
        UpdateShield();
        UpdateBossHealth();
        SetBattlePhase();
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

function UpdateBossBattlePhase(int BattlePhase)
{
}

protected function SetBattlePhase()
{
    local int BattlePhase;
    local KFPawn_MonsterBoss MonsterBoss;

    BattlePhase = 1;

    if(KFPawn_MonsterBoss(BossPawn) != none && KFPawn_ZedFleshpoundKing(BossPawn) == none && KFPawn_ZedBloatKing(BossPawn) == none)
    {
        MonsterBoss = KFPawn_MonsterBoss(BossPawn);
        BattlePhase = MonsterBoss.GetCurrentBattlePhase();
    }

    SetInt( "currentBattlePhaseColor", BattlePhaseColors[Max(BattlePhase - 1, 0)] );
}

function UpdateBossShield(float NewShieldPercect)
{
}

protected function UpdateShield()
{
    local KFPawn_ZedHans Hans;
    local KFPawn_ZedFleshpoundKing KingFp;
    local KFPawn_ZedMatriarch Matriarch;

    if(KFPawn_ZedHans(BossPawn) != none)
    {
        Hans = KFPawn_ZedHans(BossPawn);
        if(Hans.bInHuntAndHealMode)
        {
            SetFloat( "currentShieldPercecntValue", ByteToFloat(Hans.ShieldHealthPctByte));
        }
        else
        {
            SetFloat( "currentShieldPercecntValue", 0.f);
        }
        
    }
    else if(KFPawn_ZedFleshpoundKing(BossPawn) != none)
    {
        KingFp = KFPawn_ZedFleshpoundKing(BossPawn);
        if(ByteToFloat(KingFp.ShieldHealthPctByte) > 0.f)
        {
            SetFloat( "currentShieldPercecntValue", ByteToFloat(KingFp.ShieldHealthPctByte));
        }
        else
        {
            SetFloat( "currentShieldPercecntValue", 0.f);
        }
    }
    else if(KFPawn_ZedMatriarch(BossPawn) != none)
    {
        Matriarch = KFPawn_ZedMatriarch(BossPawn);
        if(Matriarch.bShieldUp)
        {
            SetFloat( "currentShieldPercecntValue", ByteToFloat(Matriarch.ShieldHealthPctByte));
        }
        else
        {
            SetFloat( "currentShieldPercecntValue", 0.f);
        }
    }
    else
    {
        SetFloat( "currentShieldPercecntValue", 0.f);
    }
}