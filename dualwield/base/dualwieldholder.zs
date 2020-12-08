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
			return holding[LEFT] ? holding[LEFT].DepleteAmmo(false, checkEnough, ammouse) : false;
			
		return holding[RIGHT] ? holding[RIGHT].DepleteAmmo(false, checkEnough, ammouse) : false;
	}
	
	override bool CheckAmmo(int fireMode, bool autoSwitch, bool requireAmmo, int ammocount)
	{
		if (fireMode == EitherFire)
		{
			bool left = holding[LEFT] ? holding[LEFT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount) : false;
			bool right = holding[RIGHT] ? holding[RIGHT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount) : false;
			return left || right;
		}
			
		if (fireMode == PrimaryFire)
			return holding[LEFT] ? holding[LEFT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount) : false;
			
		return holding[RIGHT] ? holding[RIGHT].CheckAmmo(PrimaryFire, false, requireAmmo, ammocount) : false;
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
				owner.player.SetPSPrite(PSP_LEFTFLASH, null);
			}
			else
			{
				Ammo1 = holding[LEFT].Ammo1;
				let psp = owner.player.FindPSprite(PSP_LEFTWEAPON);
				if (psp)
					psp.bAddBob = holding[LEFT].weaponState & WF_WEAPONBOBBING;
					
				psp = owner.player.FindPSprite(PSP_LEFTFLASH);
				if (psp)
					psp.bAddBob = holding[LEFT].weaponState & WF_WEAPONBOBBING;
			}
		}
		
		if (holding[RIGHT])
		{
			if (!holding[RIGHT].owner)
			{
				holding[RIGHT].bDualWielded = false;
				holding[RIGHT] = null;
				owner.player.SetPSprite(PSP_RIGHTWEAPON, null);
				owner.player.SetPSprite(PSP_RIGHTFLASH, null);
			}
			else
			{
				Ammo2 = holding[RIGHT].Ammo1;
				let psp = owner.player.FindPSprite(PSP_RIGHTWEAPON);
				if (psp)
					psp.bAddBob = holding[RIGHT].weaponState & WF_WEAPONBOBBING;
					
				psp = owner.player.FindPSprite(PSP_RIGHTFLASH);
				if (psp)
					psp.bAddBob = holding[RIGHT].weaponState & WF_WEAPONBOBBING;
			}
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