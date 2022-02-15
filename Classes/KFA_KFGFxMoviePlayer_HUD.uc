class KFA_KFGFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

DefaultProperties
{
    WidgetBindings.Remove((WidgetName="bossHealthBar", WidgetClass=class'KFGFxWidget_BossHealthBar'))
    WidgetBindings.Add((WidgetName="bossHealthBar", WidgetClass=class'KF_Advanced.KFA_KFGFxWidget_BossHealthBar'))
}