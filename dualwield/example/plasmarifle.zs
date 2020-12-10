class MPPlasmaRifle : MPWeapon replaces PlasmaRifle
{
	Default
	{
		Weapon.Kickback 100
		Weapon.SelectionOrder 100;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTPLASMA";
		Tag "$TAG_PLASMARIFLE";
	}
	
	States
	{
		Ready:
			PLSG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
		RightReady:
			PLSG A 1 A_DualWeaponReady;
			Loop;
			
		Deselect:
			PLSG A 1 A_Lower;
			Loop;
			
		LeftDeselect:
		RightDeselect:
			PLSG A 1 A_DualLower;
			Loop;
			
		Select:
			PLSG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			PLSG A 1 Offset(-64,0) A_DualRaise;
			Loop;
			
		RightSelect:
			PLSG A 1 Offset(64,0) A_DualRaise;
			Loop;
			
		Fire:
			TNT1 A 0 A_FireProjectile("PlasmaBall");
			PLSG A 3 A_GunFlash;
			TNT1 A 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			TNT1 A 0 A_FireProjectile("PlasmaBall");
			PLSG A 3 A_DualGunFlash;
			TNT1 A 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_FireProjectile("PlasmaBall");
			PLSG A 3 A_DualGunFlash;
			TNT1 A 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			PLSF A 2 Bright A_Light1;
			PLSF B 1 Bright;
			Goto LightDone;
		
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(64,0);
			Goto Flash;
			
		Spawn:
			PLAS A -1;
			Stop;
	}
}