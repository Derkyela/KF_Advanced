class EE_KFGFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

DefaultProperties
{
    WidgetBindings.Remove((WidgetName="bossHealthBar", WidgetClass=class'KFGFxWidget_BossHealthBar'))
    WidgetBindings.Add((WidgetName="bossHealthBar", WidgetClass=class'Endless_Encore.EE_KFGFxWidget_BossHealthBar'))
}