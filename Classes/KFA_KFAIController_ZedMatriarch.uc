class KFA_KFAIController_ZedMatriarch extends KFAIController_ZedMatriarch;

event Possess( Pawn inPawn, bool bVehicleTransition )
{
    super.Possess( inPawn, bVehicleTransition );

    MyMatPawn.ActivateShield();
}