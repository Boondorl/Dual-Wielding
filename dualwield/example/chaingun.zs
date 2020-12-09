class MPChaingun : MPWeapon replaces Chaingun
{
	Default
	{
		Weapon.SelectionOrder 700;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Inventory.PickupMessage "$GOTCHAINGUN";
		Obituary "$OB_MPCHAINGUN";
		Tag "$TAG_CHAINGUN";
	}
	
	States
	{
		Ready:
			CHGG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
		RightReady:
			CHGG A 1 A_DualWeaponReady;
			Loop;
			
		Deselect:
			CHGG A 1 A_Lower;
			Loop;
		
		LeftDeselect:
		RightDeselect:
			CHGG A 1 A_DualLower;
			Loop;
			
		Select:
			CHGG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			TNT1 A 0 Offset(-64,0);
			CHGG A 1 A_DualRaise;
			Wait;
			
		RightSelect:
			TNT1 A 0 Offset(64,0);
			CHGG A 1 A_DualRaise;
			Wait;
			
		Fire:
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			TNT1 A 0 A_GunFlash;
			CHGG A 2 A_FireBullets(5.6,0,-1,5);
			CHGG B 2;
			CHGG B 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			TNT1 A 0 A_DualGunFlash;
			CHGG A 2 A_FireBullets(8.4,0,-1,5);
			CHGG B 2;
			CHGG B 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			TNT1 A 0 A_DualGunFlash;
			CHGG A 2 A_FireBullets(8.4,0,-1,5);
			CHGG B 2;
			CHGG B 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			CHGF A 2 Bright A_Light1;
			CHGF B 2 Bright;
			Goto LightDone;
			
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(64,0);
			Goto Flash;
			
		Spawn:
			MGUN A -1;
			Stop;
	}
}