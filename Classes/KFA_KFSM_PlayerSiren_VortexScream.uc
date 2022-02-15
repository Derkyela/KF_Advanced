class KFA_KFSM_PlayerSiren_VortexScream extends KFSM_PlayerSiren_VortexScream;

function Timer_CheckVortex()
{
	local KFPawn KFP, BestTarget;
	local vector CameraNormal, Projection, TraceStart, GrabLocation;
	local float FOV;
	local float DistSQ, BestDistSQ;

    CameraNormal = vector(KFPOwner.Rotation);

	// Our trace origin
	TraceStart = KFPOwner.Location + ( KFPOwner.BaseEyeHeight * vect(0,0,1) );

	foreach KFPOwner.WorldInfo.AllPawns( class'KFPawn', KFP )
	{
		if( KFP.GetTeamNum() != KFPOwner.GetTeamNum() && CanInteractWithPawn(KFP) )
		{
			Projection = KFP.Location - TraceStart;
			DistSQ = VSizeSQ( Projection );

			if( DistSQ <= MaxRangeSQ )
			{
				FOV = CameraNormal dot Normal( Projection );

				if( FOV > MinGrabTargetFOV )
				{
					// Need both an extent and zero extent trace!
					// Note: Unreal 3 is weird. -MattF
					GrabLocation = KFP.Location + ( KFP.BaseEyeHeight * vect(0,0,1) );
					if( IsPawnPathClear(KFPOwner, KFP, GrabLocation, TraceStart, vect(2,2,2),, true)
						&& IsPawnPathClear(KFPOwner, KFP, GrabLocation, TraceStart,,, true) )
					{
						if( BestTarget == none || DistSQ < BestDistSQ )
						{
							BestDistSQ = DistSQ;
							BestTarget = KFP;
						}
					}
				}
			}
		}
	}

	if( BestTarget != none )
	{
		// Set our attach time
		FollowerAttachTime = KFPOwner.WorldInfo.TimeSeconds;

		// Add follower to specialmove
		KFPOwner.DoSpecialMove( KFPOwner.SpecialMove, true, BestTarget );

		// Damage immediately, set damage timer
		Timer_DamageFollower();
		KFPOwner.SetTimer( 1.f, true, nameOf(Timer_DamageFollower), self );

		// Stop trace
		KFPOwner.ClearTimer( nameOf(Timer_CheckVortex), self );
	}
}