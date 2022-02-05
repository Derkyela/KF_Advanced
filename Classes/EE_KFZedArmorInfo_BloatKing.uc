class EE_KFZedArmorInfo_BloatKing extends KFZedArmorInfo_BloatKing;

simulated function UpdateArmorUI()
{
    local KFPlayerController KFPC;

    KFPC = KFPlayerController(GetALocalPlayerController());
    if (KFPC.MyGFxHUD != none && KFPC.MyGFxHUD.bossHealthBar != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn != none && KFPC.MyGFxHUD.bossHealthBar.BossPawn.GetMonsterPawn().ArmorInfo == self)
	{
		super.UpdateArmorUI();
	}
}