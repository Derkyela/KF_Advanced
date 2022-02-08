class EE_KFAISpawnManager_Endless extends KFAISpawnManager_Endless
    within EE_Endless
    config(Endless_Encore);

function GetSpawnListFromSquad(byte SquadIdx, out array< KFAISpawnSquad > SquadsList, out array< class<KFPawn_Monster> >  AISpawnList)
{
	local KFAISpawnSquad Squad;
	local EAIType AIType;
	local int i, j, RandNum;
	local ESquadType LargestMonsterSquadType;
    local array<class<KFPawn_Monster> > TempSpawnList;
	local class<KFPawn_Monster> ForcedPawnClass;
	local int RandBossIndex;
	
	Squad = SquadsList[SquadIdx];

	// Start with the smallest size, and the crank it up if the squad is larger
	LargestMonsterSquadType = EST_Crawler;

	for ( i = 0; i < Squad.MonsterList.Length; i++ )
	{
		for ( j = 0; j < Squad.MonsterList[i].Num; j++ )
		{
			if( Squad.MonsterList[i].CustomClass != None )
			{
				TempSpawnList.AddItem(Squad.MonsterList[i].CustomClass);
			}
			else
			{
				AIType = Squad.MonsterList[i].Type;
				if( AIType == AT_BossRandom )
				{
`if(`notdefined(ShippingPC))
                    if( ForcedBossNum >= 0 )
                    {
                        if (ForcedBossNum < AIBossClassList.Length)
                        {
							ForcedPawnClass = AIBossClassList[ForcedBossNum];
                        }
                        else if ((ForcedBossNum - AIBossClassList.Length) < AITestBossClassList.Length)
                        {
							ForcedPawnClass = AITestBossClassList[ForcedBossNum - AIBossClassList.Length];
                        }

						//If we've forced the class we don't greatly care about the memory results, preload content now
						ForcedPawnClass.static.PreloadContent();
						TempSpawnList.AddItem(ForcedPawnClass);
                    }
                    else
`endif
                    //Always have the squad type be a boss if we're spawning one in case of override
					if (OutbreakEvent.ActiveEvent.bBossRushMode)
					{
						RandBossIndex = Rand(BossRushEnemies.length);
						TempSpawnList.AddItem( default.AIBossClassList[BossRushEnemies[RandBossIndex]]);
						BossRushEnemies.Remove(RandBossIndex, 1);
					}
					else
					{
						TempSpawnList.AddItem(GetBossAISpawnType());
					}

                    LargestMonsterSquadType = EST_Boss;
				}
				else
				{
					TempSpawnList.AddItem(GetAISpawnType(AIType));
				}
			}

			if( TempSpawnList[TempSpawnList.Length - 1].default.MinSpawnSquadSizeType < LargestMonsterSquadType )
            {
                LargestMonsterSquadType = TempSpawnList[TempSpawnList.Length - 1].default.MinSpawnSquadSizeType;
            }
		}
	}
	if( TempSpawnList.Length > 0 )
	{
        // Shuffle spawn list
        while( TempSpawnList.Length > 0 )
        {
            RandNum = Rand( TempSpawnList.Length );

            if(ReplaceWithVersus())
            { 
                AISpawnList.AddItem( GetReplacement(TempSpawnList[RandNum]) );
            }
            else
            {
                AISpawnList.AddItem( TempSpawnList[RandNum] );
            }

            TempSpawnList.Remove( RandNum, 1 );
        }

		DesiredSquadType = Squad.MinVolumeType;

		if( LargestMonsterSquadType < DesiredSquadType )
        {
            DesiredSquadType = LargestMonsterSquadType;
            //`log("adjusted largest squad for squad "$Squad$" to "$GetEnum(enum'ESquadType',DesiredSquadType));
        }
	}
}

protected function bool ReplaceWithVersus()
{
    return AllowVersus && MyKFGRI.WaveNum >= StartVersusWave && bool(Rand(2));
}

protected function class<KFPawn_Monster> GetReplacement(class<KFPawn_Monster> OriginalMonsterClass)
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
            return class'KFPawn_ZedHusk_Versus';
        case class'KFPawn_ZedScrake':
            return class'KFPawn_ZedScrake_Versus';
        case class'KFPawn_ZedSiren':
            return class'KFPawn_ZedSiren_Versus';
        case class'KFPawn_ZedStalker':
            return class'KFPawn_ZedStalker_Versus';
        default:
            return OriginalMonsterClass;
    }
}