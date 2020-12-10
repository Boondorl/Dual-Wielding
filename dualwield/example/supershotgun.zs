class MPSuperShotgun : MPWeapon replaces SuperShotgun
{
	Default
	{
		Weapon.Kickback 100
		Weapon.SelectionOrder 400;
		Weapon.AmmoUse 2;
		Weapon.AmmoGive 8;
		Weapon.AmmoType "Shell";
		Inventory.PickupMessage "$GOTSHOTGUN2";
		Obituary "$OB_MPSSHOTGUN";
		Tag "$TAG_SUPERSHOTGUN";
	}
	
	States
	{
		Ready:
			SHT2 A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
			SHT2 A 1 A_DualWeaponReady;
			Loop;
			
		RightReady:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHT2 A 1 A_DualWeaponReady;
			Wait;
			
		Deselect:
			SHT2 A 1 A_Lower;
			Loop;
			
		LeftDeselect:
			SHT2 A 1 A_DualLower;
			Loop;
			
		RightDeselect:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHT2 A 1 A_DualLower;
			Wait;
			
		Select:
			SHT2 A 1 A_Raise;
			Loop;
			
		LeftSelect:
			TNT1 A 0 Offset(-64,0);
			SHT2 A 1 A_DualRaise;
			Wait;
			
		RightSelect:
			TNT1 A 0 Offset(-64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHT2 A 1 A_DualRaise;
			Wait;
			
		Fire:
			SHT2 A 0 A_FireBullets(11.2, 7.1, 20, 5);
			SHT2 A 0 A_StartSound("weapons/sshotf", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 A 7 A_GunFlash;
			SHT2 B 7;
			SHT2 C 7 A_CheckReload;
			SHT2 D 7 A_StartSound("weapons/sshoto", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 E 7;
			SHT2 F 7 A_StartSound("weapons/sshotl", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 G 6;
			SHT2 H 6 A_StartSound("weapons/sshotc", CHAN_WEAPON, CHANF_OVERLAP);
			TNT1 A 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			SHT2 A 0 A_FireBullets(11.2, 7.1, 20, 5);
			SHT2 A 0 A_StartSound("weapons/sshotf", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 A 7 A_DualGunFlash;
			SHT2 B 7;
			TNT1 A 0 A_DualCheckReload;
			SHT2 AAAAAA 1 A_OverlayOffset(OverlayID(),0,16, WOF_ADD);
			TNT1 A 21 A_StartSound("weapons/sshoto", CHAN_WEAPON, CHANF_OVERLAP);
			TNT1 A 19 A_StartSound("weapons/sshotl", CHAN_WEAPON, CHANF_OVERLAP);
			TNT1 A 0 A_StartSound("weapons/sshotc", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 AAAAAA 1 A_OverlayOffset(OverlayID(),0,-16, WOF_ADD);
			TNT1 A 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SHT2 A 0 A_FireBullets(11.2, 7.1, 20, 5);
			SHT2 A 0 A_StartSound("weapons/sshotf", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 A 7 A_DualGunFlash;
			SHT2 B 7;
			TNT1 A 0 A_DualCheckReload;
			SHT2 AAAAAA 1 A_OverlayOffset(OverlayID(),0,16, WOF_ADD);
			TNT1 A 21 A_StartSound("weapons/sshoto", CHAN_WEAPON, CHANF_OVERLAP);
			TNT1 A 19 A_StartSound("weapons/sshotl", CHAN_WEAPON, CHANF_OVERLAP);
			TNT1 A 0 A_StartSound("weapons/sshotc", CHAN_WEAPON, CHANF_OVERLAP);
			SHT2 AAAAAA 1 A_OverlayOffset(OverlayID(),0,-16, WOF_ADD);
			TNT1 A 0 A_DualReFire;
			Goto RightReady;
			
		Flash:
			SHT2 I 4 Bright A_Light1;
			SHT2 J 3 Bright A_Light2;
			Goto LightDone;
			
		LeftFlash:
			TNT1 A 0 Offset(-64,0);
			Goto Flash;
			
		RightFlash:
			TNT1 A 0 Offset(-64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			Goto Flash;
			
		Spawn:
			SGN2 A -1;
			Stop;
	}
}