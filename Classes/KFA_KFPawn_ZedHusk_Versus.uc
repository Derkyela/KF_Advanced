class KFA_KFPawn_ZedHusk_Versus extends KFPawn_ZedHusk_Versus;

/** Overwritten with the method form the base class KFPawn_ZedHusk */
simulated function ANIMNOTIFY_HuskFireballAttack()
{
	local KFAIController_ZedHusk HuskAIC;
	local KFSM_Husk_FireballAttack FireballSM;

	if( MyKFAIC != none )
	{
		FireballSM = KFSM_Husk_FireBallAttack( SpecialMoves[SpecialMove] );
		if( FireballSM != none )
		{
			FireballSM.NotifyFireballFired();
		}

		HuskAIC = KFAIController_ZedHusk(MyKFAIC);
		if( HuskAIC != none )
		{
			HuskAIC.ShootFireball( FireballClass, FireballSM.GetFireOffset() );
		}
	}

	SetFireLightEnabled( false );
}

/** Overwritten with the method form the base class KFPawn_ZedHusk */
simulated function ANIMNOTIFY_FlameThrowerOn()
{
    if( IsDoingSpecialMove(SM_HoseWeaponAttack) )
	{
		KFSM_Husk_FlameThrowerAttack(SpecialMoves[SpecialMove]).TurnOnFlamethrower();
	}
}

/** Overwritten with the method form the base class KFPawn_ZedHusk */
simulated function ESpecialMove GetSuicideSM()
{
	return SM_Suicide;
}

DefaultProperties
{
	FireballClass=class'KFA_KFProj_Husk_Fireball_Versus';
}