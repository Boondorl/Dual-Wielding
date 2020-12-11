class MPChainsaw : MPWeapon replaces Chainsaw
{
	Default
	{
		Weapon.Kickback 0;
		Weapon.SelectionOrder 2200;
		Weapon.UpSound "weapons/sawup";
		Weapon.ReadySound "weapons/sawidle";
		Inventory.PickupMessage "$GOTCHAINSAW";
		Obituary "$OB_MPCHAINSAW";
		Tag "$TAG_CHAINSAW";
		
		+WEAPON.MELEEWEAPON		
	}
	
	States
	{
		Ready:
			SAWG CD 4 A_WeaponReady;
			Loop;
			
		LeftReady:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SAWG CCCCDDDD 1 A_DualWeaponReady;
			Loop;
			
		RightReady:
			SAWG CCCCDDDD 1 A_DualWeaponReady;
			Loop;
			
		Deselect:
			SAWG C 1 A_Lower;
			Loop;
			
		LeftDeselect:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SAWG C 1 A_DualLower;
			Wait;
			
		RightDeselect:
			SAWG C 1 A_DualLower;
			Loop;
			
		Select:
			SAWG C 1 A_Raise;
			Loop;
			
		LeftSelect:
			TNT1 A 0 Offset(64,0) A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SAWG C 1 A_DualRaise;
			Wait;
			
		RightSelect:
			SAWG C 1 Offset(64,0) A_DualRaise;
			Loop;
			
		Fire:
			SAWG AB 4 A_Saw;
			SAWG B 0 A_ReFire;
			Goto Ready;
			
		LeftFire:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			SAWG AB 4 A_Saw;
			SAWG B 0 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			SAWG AB 4 A_Saw;
			SAWG B 0 A_DualReFire;
			Goto RightReady;
			
		Spawn:
			CSAW A -1;
			Stop;
	}
}