class KFA_KFAISpawnManager_Endless extends KFAISpawnManager_Endless
    within KFA_Endless;

function int GetMaxMonsters()
{
	if(OutbreakEvent.ActiveEvent.WeeklyOutbreakId == 4 && UseCustomOutbreaks)
    {   
        return super.GetMaxMonsters() * 0.5;
    }
    else
    {
        return super.GetMaxMonsters();
    }
}
