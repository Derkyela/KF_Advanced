class KFA_KFProj_Husk_Fireball_Versus extends KFProj_Husk_Fireball_Versus;

DefaultProperties
{
    Speed=4200.f
    MaxSpeed=4200.f

    Begin Object Name=ExploTemplate0
		Damage=23
		DamageRadius=591.5 //Custom calculated based on ShootFireball() assuming max strength
		DamageFalloffExponent=1.f //1.0
		DamageDelay=0.f

		// Damage Effects
		MyDamageType=class'KFDT_Fire_HuskFireball'
		MomentumTransferScale=60000.f
		KnockDownStrength=100
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		ExplosionEffects=KFImpactEffectInfo'FX_Impacts_ARCH.Explosions.HuskProjectile_Explosion'
		ExplosionSound=AkEvent'WW_ZED_Husk.ZED_Husk_SFX_Ranged_Shot_Impact'
		ExplosionEmitterScale=2.f

        // Dynamic Light
        ExploLight=ExplosionPointLight
        ExploLightStartFadeOutTime=0.0
        ExploLightFadeOutTime=0.5

		// Camera Shake
		CamShake=CameraShake'FX_CameraShake_Arch.Misc_Explosions.HuskFireball'
		CamShakeInnerRadius=450
		CamShakeOuterRadius=900
		CamShakeFalloff=1.f
		bOrientCameraShakeTowardsEpicenter=true
	End Object
	ExplosionTemplate=ExploTemplate0
}