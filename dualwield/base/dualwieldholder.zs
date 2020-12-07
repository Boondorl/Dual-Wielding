class DualWieldHolder : Weapon
{
	DWWeapon holding[2];
	
	Default
	{
		+NOBLOCKMAP
		+NOSECTOR
		+INVENTORY.UNDROPPABLE
		+WEAPON.NO_AUTO_SWITCH
		+WEAPON.CHEATNOTWEAPON
	}
	
	States
	{
		Select:
			TNT1 A 1 A_Raise;
			Loop;
			
		Deselect:
			TNT1 A 1 A_Lower;
			Loop;
			
		Fire:
		Ready:
			TNT1 A 1 A_WeaponReady(WRF_NOFIRE);
			Loop;
	}
	
	DWWeapon GetRightWeapon()
	{
		return holding[RIGHT];
	}
	
	DWWeapon GetLeftWeapon()
	{
		return holding[LEFT];
	}
	
	override State GetReadyState()
	{
		if (holding[LEFT])
		{
			let psp = owner.player.GetPSprite(PSP_LEFTWEAPON);
			if (psp)
			{
				psp.caller = holding[LEFT];
				psp.SetState(holding[LEFT].GetLeftReadyState());
			}
		}
		
		if (holding[RIGHT])
		{
			let psp = owner.player.GetPSprite(PSP_RIGHTWEAPON);
			if (psp)
			{
				psp.caller = holding[RIGHT];
				psp.SetState(holding[RIGHT].GetRightReadyState());
			}
		}
		
		return super.GetReadyState();
	}
	
	override State GetDownState()
	{
		if (holding[LEFT])
		{
			let psp = owner.player.GetPSprite(PSP_LEFTWEAPON);
			if (psp)
			{
				psp.caller = holding[LEFT];
				psp.SetState(holding[LEFT].GetLeftDownState());
			}
		}
		
		if (holding[RIGHT])
		{
			let psp = owner.player.GetPSprite(PSP_RIGHTWEAPON);
			if (psp)
			{
				psp.caller = holding[RIGHT];
				psp.SetState(holding[RIGHT].GetRightDownState());
			}
		}
		
		return super.GetDownState();
	}
	
	override State GetUpState()
	{
		if (holding[LEFT])
		{
			let psp = owner.player.GetPSprite(PSP_LEFTWEAPON);
			if (psp)
			{
				psp.caller = holding[LEFT];
				psp.SetState(holding[LEFT].GetLeftUpState());
			}
		}
		
		if (holding[RIGHT])
		{
			let psp = owner.player.GetPSprite(PSP_RIGHTWEAPON);
			if (psp)
			{
				psp.caller = holding[RIGHT];
				psp.SetState(holding[RIGHT].GetRightUpState());
			}
		}
		
		return super.GetUpState();
	}

	override Inventory CreateTossable(int amt)
	{
		if (holding[LEFT])
			return holding[LEFT].CreateTossable(amt);
		
		if (holding[RIGHT])
			return holding[RIGHT].CreateTossable(amt);
			
		return null;
	}
	
	override bool DepleteAmmo(bool altFire, bool checkEnough, int ammouse)
	{
		if (!altFire)
			return holding[LEFT].DepleteAmmo(false, checkEnough, ammouse);
			
		return holding[RIGHT].DepleteAmmo(false, checkEnough, ammouse);
	}
	
	override bool CheckAmmo(int fireMode, bool autoSwitch, bool requireAmmo, int ammocount)
	{
		if (fireMode == EitherFire)
			return holding[LEFT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount) || holding[RIGHT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount);
			
		if (fireMode == PrimaryFire)
			return holding[LEFT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount);
			
		return holding[RIGHT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount);
	}
	
	override void DoEffect()
	{
		if (!owner || !owner.player)
			Destroy();
			
		if (holding[LEFT])
		{
			if (!holding[LEFT].owner)
			{
				holding[LEFT].bDualWielded = false;
				holding[LEFT] = null;
				owner.player.SetPSprite(PSP_LEFTWEAPON, null);
			}
			else
				Ammo1 = holding[LEFT].Ammo1;
		}
		
		if (holding[RIGHT])
		{
			if (!holding[RIGHT].owner)
			{
				holding[RIGHT].bDualWielded = false;
				holding[RIGHT] = null;
				owner.player.SetPSprite(PSP_RIGHTWEAPON, null);
			}
			else
				Ammo2 = holding[RIGHT].Ammo1;
		}
			
		if ((!holding[LEFT] || !holding[RIGHT]) && owner.player.ReadyWeapon == self)
		{
			Weapon pending;
			if (holding[RIGHT])
			{
				holding[RIGHT].bDualWielded = false;
				pending = holding[RIGHT];
			}
			else if (holding[LEFT])
			{
				holding[LEFT].bDualWielded = false;
				pending = holding[LEFT];
			}
			else
				pending = owner.player.mo.BestWeapon(null);
				
			owner.player.PendingWeapon = pending;
			Destroy();
		}
	}
	
	override void Tick() {}
}