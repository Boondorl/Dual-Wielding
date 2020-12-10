class MPBFG9000 : MPWeapon replaces BFG9000
{
	Default
	{
		Weapon.Kickback 100
		Weapon.SelectionOrder 2800;
		Weapon.AmmoUse 40;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Inventory.PickupMessage "$GOTBFG9000";
		Tag "$TAG_BFG9000";
	}
	
	States
	{
		Ready:
			BFGG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
		RightReady:
			BFGG A 1 A_DualWeaponReady;
			Loop;
			
		Deselect:
			BFGG A 1 A_Lower;
			Loop;
			
		LeftDeselect:
		RightDeselect:
			BFGG A 1 A_DualLower;
			Loop;
			
		Select:
			BFGG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			BFGG A 1 Offset(-64,0) A_DualRaise;
			Loop;
			
		RightSelect:
			BFGG A 1 Offset(64,0) A_DualRaise;
			Loop;
			
		Fire:
			BFGG A 20 A_StartSound("weapons/bfgf", CHAN_WEAPON, CHANF_OVERLAP);
			BFGG B 10 A_GunFlash;
			BFGG B 10 A_FireBFG;
			BFGG B 20 A_ReFire;
			Goto Ready;
			
		LeftFire:
			BFGG A 20 A_StartSound("weapons/bfgf", CHAN_WEAPON, CHANF_OVERLAP);
			BFGG B 10 A_DualGunFlash;
			BFGG B 10 A_FireBFG;
			BFGG B 20 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			BFGG A 20 A_StartSound("weapons/bfgf", CHAN_WEAPON, CHANF_OVERLAP);
			BFGG B 10 A_DualGunFlash;
			BFGG B 10 A_FireBFG;
			BFGG B 20 A_DualReFire;
			Goto RightReady;
			
		Flash:
			BFGF A 11 Bright A_Light1;
			BFGF B 6 Bright A_Light2;
			Goto LightDone;
			
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(64,0);
			Goto Flash;
			
		Spawn:
			BFUG A -1;
			Stop;
	}
}