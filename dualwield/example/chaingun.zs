class MPChaingun : MPWeapon replaces Chaingun
{
	Default
	{
		Weapon.SelectionOrder 700;
		Weapon.SlotNumber 4;
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
			CHGG A 16;
			Stop;
			
		Select:
			CHGG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			TNT1 A 0 Offset(-64,0);
			CHGG A 16;
			Goto LeftReady;
			
		RightSelect:
			TNT1 A 0 Offset(64,0);
			CHGG A 16;
			Goto RightReady;
			
		Fire:
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			CHGG A 4 A_FireBullets(5.6,0,1,5);
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			CHGG B 4 A_FireBullets(5.6,0,1,5);
			CHGG B 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			CHGG A 4 A_FireBullets(5.6,0,1,5);
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			CHGG B 4 A_FireBullets(5.6,0,1,5);
			CHGG B 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			CHGG A 4 A_FireBullets(5.6,0,1,5);
			TNT1 A 0 A_StartSound("weapons/chngun", CHAN_WEAPON);
			CHGG B 4 A_FireBullets(5.6,0,1,5);
			CHGG B 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			CHGF A 5 Bright A_Light1;
			Goto LightDone;
			
		Spawn:
			MGUN A -1;
			Stop;
	}
}