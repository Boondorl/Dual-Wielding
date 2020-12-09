class DWFist : DWWeapon
{
	Default
	{
		Weapon.SelectionOrder 3700;
		Weapon.Kickback 100;
		Obituary "$OB_MPFIST";
		Tag "$TAG_FIST";
		
		+WEAPON.MELEEWEAPON
	}
	
	States
	{
		Ready:
			PUNG A 1 A_WeaponReady;
			Loop;
			
		LeftReady:
			TNT1 A 1 A_DualWeaponReady;
			Loop;
			
		RightReady:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, false);
			PUNG A 1 A_DualWeaponReady;
			Wait;
			
		Deselect:
			PUNG A 1 A_Lower;
			Loop;
			
		LeftDeselect:
			TNT1 A 0 A_DualLower;
			Loop;
			
		RightDeselect:
			PUNG A 1 A_DualLower;
			Loop;
			
		Select:
			PUNG A 1 A_Raise;
			Loop;
			
		LeftSelect:
			TNT1 A 1 A_DualRaise;
			Loop;
			
		RightSelect:
			PUNG A 1 A_DualRaise;
			Loop;
			
		Fire:
			PUNG B 4;
			PUNG C 4 A_Punch;
			PUNG D 5;
			PUNG C 4;
			PUNG B 5 A_ReFire;
			Goto Ready;
			
		LeftFire:
			PUNG B 4;
			PUNG C 4 A_Punch;
			PUNG D 5;
			PUNG C 4;
			PUNG B 5 A_DualReFire;
			Goto LeftReady;
			
		RightFire:
			TNT1 A 0 A_OverlayFlags(OverlayID(), PSPF_FLIP|PSPF_MIRROR, true);
			PUNG B 4;
			PUNG C 4 A_Punch;
			PUNG D 5;
			PUNG C 4;
			PUNG B 5 A_DualReFire;
			Goto RightReady;
	}
}

class DualFist : DualWieldHolder
{
	override void AttachToOwner(Actor other)
	{
		super.AttachToOwner(other);
		
		if (!owner || !owner.player)
			return;
			
		let fist1 = DWWeapon(Spawn("DWFist"));
		if (fist1)
		{
			fist1.bDualWielded = true;
			fist1.AttachToOwner(owner);
		}
			
		let fist2 = DWWeapon(Spawn("DWFist"));
		if (fist2)
		{
			fist2.bDualWielded = true;
			fist2.AttachToOwner(owner);
		}
		
		holding[LEFT] = fist1;
		holding[RIGHT] = fist2;
	}
}