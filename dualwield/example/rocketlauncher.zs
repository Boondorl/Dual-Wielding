class MPRocketLauncher : MPWeapon replaces RocketLauncher
{
	Default
	{
		Weapon.SelectionOrder 2500;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "RocketAmmo";
		Inventory.PickupMessage "$GOTLAUNCHER";
		Tag "$TAG_ROCKETLAUNCHER";
	}
	
	States
	{
		Ready:
			MISG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
		RightReady:
			MISG A 1 A_DualWeaponReady;
			Loop;
			
		Deselect:
			MISG A 1 A_Lower;
			Loop;
			
		LeftDeselect:
		RightDeselect:
			MISG A 1 A_DualLower;
			Loop;
			
		Select:
			MISG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			MISG A 1 Offset(-64,0) A_DualRaise;
			Loop;
			
		RightSelect:
			MISG A 1 Offset(64,0) A_DualRaise;
			Loop;
			
		Fire:
			MISG B 8 A_GunFlash;
			MISG B 12 A_FireMissile;
			MISG B 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			MISG B 8 A_DualGunFlash;
			MISG B 12 A_FireMissile;
			MISG B 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			MISG B 8 A_DualGunFlash;
			MISG B 12 A_FireMissile;
			MISG B 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			MISF A 3 Bright A_Light1;
			MISF B 4 Bright;
			MISF CD 4 Bright A_Light2;
			Goto LightDone;
			
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(64,0);
			Goto Flash;
			
		Spawn:
			LAUN A -1;
			Stop;
	}
}