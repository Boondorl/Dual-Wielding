class MPShotgun : MPWeapon replaces Shotgun
{
	Default
	{
		Weapon.Kickback 100;
		Weapon.SelectionOrder 1300;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN";
		Obituary "$OB_MPSHOTGUN";
		Tag "$TAG_SHOTGUN";
	}
	
	States
	{
		Ready:
			SHTG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
			SHTG A 1 A_DualWeaponReady;
			Loop;
			
		RightReady:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHTG A 1 A_DualWeaponReady;
			Wait;
			
		Deselect:
			SHTG A 1 A_Lower;
			Loop;
			
		LeftDeselect:
			SHTG A 1 A_DualLower;
			Loop;
			
		RightDeselect:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHTG A 1 A_DualLower;
			Wait;
			
		Select:
			SHTG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			SHTG A 1 Offset(-64,0) A_DualRaise;
			Loop;
			
		RightSelect:
			TNT1 A 0 Offset(-64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHTG A 1 A_DualRaise;
			Wait;
			
		Fire:
			SHTG A 0 A_FireBullets(5.6, 0, 7, 5);
			SHTG A 0 A_StartSound("weapons/shotgf", CHAN_WEAPON, CHANF_OVERLAP);
			SHTG A 7 A_GunFlash;
			SHTG BC 5;
			SHTG D 4;
			SHTG CB 5;
			TNT1 A 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			SHTG A 0 A_FireBullets(5.6, 0, 7, 5);
			SHTG A 0 A_StartSound("weapons/shotgf", CHAN_WEAPON, CHANF_OVERLAP);
			SHTG A 7 A_DualGunFlash;
			SHTG AAAAAA 1 A_OverlayOffset(OverlayID(),0,16, WOF_ADD);
			TNT1 A 21;
			SHTG AAAAAA 1 A_OverlayOffset(OverlayID(),0,-16, WOF_ADD);
			TNT1 A 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHTG A 0 A_FireBullets(5.6, 0, 7, 5);
			SHTG A 0 A_StartSound("weapons/shotgf", CHAN_WEAPON, CHANF_OVERLAP);
			SHTG A 7 A_DualGunFlash;
			SHTG AAAAAA 1 A_OverlayOffset(OverlayID(),0,16, WOF_ADD);
			TNT1 A 21;
			SHTG AAAAAA 1 A_OverlayOffset(OverlayID(),0,-16, WOF_ADD);
			TNT1 A 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			SHTF A 4 Bright A_Light1;
			SHTF B 3 Bright A_Light2;
			Goto LightDone;
			
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(-64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			Goto Flash;
			
		Spawn:
			SHOT A -1;
			Stop;
	}
}