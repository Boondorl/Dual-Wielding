class MPPistol : MPWeapon replaces Pistol
{
	Default
	{
		Weapon.Kickback 100;
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Clip";
		Obituary "$OB_MPPISTOL";
		Inventory.Pickupmessage "$PICKUP_PISTOL_DROPPED";
		Tag "$TAG_PISTOL";
	}
	
	States
	{
		Ready:
			PISG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
			PISG A 1 A_DualWeaponReady;
			Loop;
			
		RightReady:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			PISG A 1 A_DualWeaponReady;
			Wait;
			
		Deselect:
			PISG A 1 A_Lower;
			Loop;
			
		LeftDeselect:
			PISG A 1 A_DualLower;
			Loop;
			
		RightDeselect:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			PISG A 1 A_DualLower;
			Wait;
			
		Select:
			PISG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			PISG A 1 Offset(-64,0) A_DualRaise;
			Loop;
			
		RightSelect:
			TNT1 A 0 Offset(-64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			PISG A 1 A_DualRaise;
			Wait;
			
		Fire:
			TNT1 A 0 A_FireBullets(5.6, 0, 1, 5);
			TNT1 A 0 A_StartSound("weapons/pistol", CHAN_WEAPON, CHANF_OVERLAP);
			PISG B 6 A_GunFlash;
			PISG C 4;
			PISG B 5;
			TNT1 A 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			TNT1 A 0 A_DualFireBullets(5.6, 0, 1, 5);
			TNT1 A 0 A_StartSound("weapons/pistol", CHAN_WEAPON, CHANF_OVERLAP);
			PISG B 6 A_DualGunFlash;
			PISG C 4;
			PISG B 5;
			TNT1 A 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			TNT1 A 0 A_DualFireBullets(5.6, 0, 1, 5);
			TNT1 A 0 A_StartSound("weapons/pistol", CHAN_WEAPON, CHANF_OVERLAP);
			PISG B 6 A_DualGunFlash;
			PISG C 4;
			PISG B 5;
			TNT1 A 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			PISF A 6 Bright A_Light1;
			Goto LightDone;
			
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(-64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			Goto Flash;
			
		Spawn:
			PIST A -1;
			Stop;
	}
}