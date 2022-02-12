class EE_KFOutbreakEvent_Endless extends KFOutbreakEvent_Endless;

DefaultProperties
{
    SetEvents[3]={(
                    EventDifficulty=2,
                    GameLength=GL_Normal,
                    WaveAICountScale=(0.4, 0.4, 0.4, 0.4, 0.4, 0.4),
                    WeeklyOutbreakId=4,
					SpawnReplacementList={(
                                            (SpawnEntry=AT_Clot,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_SlasherClot,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_AlphaClot,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_Crawler,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_GoreFast,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_Stalker,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundmini')),
                                            (SpawnEntry=AT_Scrake,NewClass=(class'KFGameContent.KFPawn_ZedFleshpound')),
                                            (SpawnEntry=AT_Bloat,NewClass=(class'KFGameContent.KFPawn_ZedFleshpound')),
                                            (SpawnEntry=AT_Siren,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_Husk,NewClass=(class'KFGameContent.KFPawn_ZedFleshpound')),
                                            (SpawnEntry=AT_EliteClot,NewClass=(class'KFGameContent.KFPawn_ZedFleshpound')),
                                            (SpawnEntry=AT_EliteCrawler,NewClass=(class'KFGameContent.KFPawn_ZedFleshpound')),
                                            (SpawnEntry=AT_EliteGoreFast,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_EDAR_EMP,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_EDAR_Laser,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini')),
                                            (SpawnEntry=AT_EDAR_Rocket,NewClass=(class'KFGameContent.KFPawn_ZedFleshpoundMini'))
                    )},
                    BossSpawnReplacementList={(
                                            (SpawnEntry=BAT_Hans,NewClass=class'KFGameContent.KFPawn_ZedFleshpoundKing'),
                                            (SpawnEntry=BAT_Patriarch,NewClass=class'KFGameContent.KFPawn_ZedFleshpoundKing'),
                                            (SpawnEntry=BAT_Matriarch,NewClass=class'KFGameContent.KFPawn_ZedFleshpoundKing'),
											(SpawnEntry=BAT_KingBloat,NewClass=class'KFGameContent.KFPawn_ZedFleshpoundKing')
                    )},
                    ZedsToAdjust={(
                                    //(ClassToAdjust=class'KFGameContent.KFPawn_ZedFleshpoundKing',HealthScale=1.0,bStartEnraged=true) //3.45
                    )}
    )}
}