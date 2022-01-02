class EE_KFGFxHudWrapper extends KFGFxHudWrapper;

var transient protected EE_Endless KFGI;
var array <Color> BattlePhaseColors;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    KFGI = EE_Endless(WorldInfo.Game);
    BattlePhaseColors.AddItem(MakeColor(0, 184, 98, 255));//green
    BattlePhaseColors.AddItem(MakeColor(255, 176, 0, 255));//yellow
    BattlePhaseColors.AddItem(MakeColor(255, 96, 0, 255));//orange
    BattlePhaseColors.AddItem(MakeColor(173, 22, 17, 255));//red
    BattlePhaseColors.AddItem(MakeColor(0, 0, 0, 255));
}

event DrawHUD() {
    super.DrawHUD();

    DrawExtraBossHealtBars();
}

protected function DrawExtraBossHealtBars()
{
    local float XL, YL, YOffset;
    local KFPawn_Monster Pawn;
    local KFPawn_MonsterBoss Boss;
    local KFPawn_ZedFleshpoundKing KingFP;
    local KFPawn_ZedMatriarch Matriarch;
    local KFPawn_ZedHans Hans;
    local Color BarColor;

    YOffset = 450;
    foreach WorldInfo.AllPawns(class'KFPawn_Monster', Pawn)
    {
        if(Pawn.IsABoss() && Pawn.IsAliveAndWell())
        {   
            XL = 0;
            YL = 0;
            BarColor = NonPlayerHealth;

            if(KFPawn_MonsterBoss(Pawn) != none)
            {
                Boss = KFPawn_MonsterBoss(Pawn);
                BarColor = BattlePhaseColors[Max(Boss.GetCurrentBattlePhase() - 1, 0)];
            }
            else if(KFPawn_ZedFleshpoundKing(Pawn) != none) {
                KingFP = KFPawn_ZedFleshpoundKing(Pawn);
                BarColor = BattlePhaseColors[Max(KingFP.CurrentPhase - 1, 0)];
            }

            Canvas.SetDrawColorStruct(ConsoleColor);
            Canvas.StrLen(Pawn.GetLocalizedName(), XL, YL);
            Canvas.SetPos(20, YOffset);
            YOffset = YOffset + YL + 10;
            Canvas.DrawText(Pawn.GetLocalizedName());

            DrawKFBar(Pawn.GetHealthPercentage(), 400, 20, 20, YOffset, BarColor);

            if(KFPawn_ZedMatriarch(Pawn) != none)
            {
                Matriarch = KFPawn_ZedMatriarch(Pawn);
                if(Matriarch.bShieldUp)
                {
                    Canvas.SetDrawColorStruct(ArmorColor);
	                Canvas.SetPos(20, YOffset + 1);
	                Canvas.DrawTile(PlayerStatusBarBGTexture, (400 - 2.0) * ByteToFloat(Matriarch.ShieldHealthPctByte), 20 - 2.0, 0, 0, 32, 32);
                }
            }
            else if(KFPawn_ZedHans(Pawn) != none)
            {
                Hans = KFPawn_ZedHans(Pawn);
                if(Hans.bInHuntAndHealMode)
                {
                    Canvas.SetDrawColorStruct(ArmorColor);
	                Canvas.SetPos(20, YOffset + 1);
	                Canvas.DrawTile(PlayerStatusBarBGTexture, (400 - 2.0) * ByteToFloat(Hans.ShieldHealthPctByte), 20 - 2.0, 0, 0, 32, 32);
                }
            }
            else if(KingFP != none && KingFP.ShieldHealth > 0)
            {
                Canvas.SetDrawColorStruct(ArmorColor);
                Canvas.SetPos(20, YOffset + 1);
                Canvas.DrawTile(PlayerStatusBarBGTexture, (400 - 2.0) * ByteToFloat(KingFP.ShieldHealthPctByte), 20 - 2.0, 0, 0, 32, 32);
            }

            YOffset = YOffset + 20 + 20;

            Boss = none;
            KingFP = none;
            Matriarch = none;
            Hans = none;
        }
    }
}
