class KFA_KFPawn_ZedSiren_Versus extends KFPawn_ZedSiren_Versus;

DefaultProperties
{
    Begin Object Name=SpecialMoveHandler_0
		SpecialMoveClasses(SM_SonicAttack)=class'KF_Advanced.KFA_KFSM_PlayerSiren_VortexScream'
	End Object

	ControllerClass=class'KF_Advanced.KFA_KFAIController_ZedSiren';
}