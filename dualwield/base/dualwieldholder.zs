struct DualWeaponInfo play
{
	int kickback;
	double yAdjust;
	Ammo Ammo1, Ammo2;
	int bobStyle;
	double bobSpeed;
	double bobRangeX, bobRangeY;
	double FOVScale;
	double lookScale;
	int crosshair;
	
	bool bDontBob;
	bool bAxeBlood;
	bool bStaffKickback;
	bool bNoAutoAim;
	
	void Reset()
	{
		kickback = 0;
		yAdjust = 0;
		Ammo1 = Ammo2 = null;
		bobStyle = Bob_Normal;
		bobSpeed = 1;
		bobRangeX = bobRangeY = 1;
		FOVScale = 1;
		lookScale = 1;
		crosshair = 0;
		
		bDontBob = bAxeBlood = bStaffKickback = bNoAutoAim = false;
	}
	
	void UpdateWeaponInfo(Weapon left, Weapon right)
	{
		bool hadRight = right != null;
		int lKick, rKick;
		double lYAdjust, rYAdjust;
		
		if (right)
		{
			bobStyle = right.bobStyle;
			bobSpeed = right.bobSpeed;
			bobRangeX = right.bobRangeX;
			bobRangeY = right.bobRangeY;
			FOVScale = right.FOVScale;
			lookScale = right.lookScale;
			crosshair = right.crosshair;
			
			bDontBob = right.bDontBob;
			bAxeBlood = right.bAxeBlood;
			bStaffKickback = right.bStaff2_Kickback;
			bNoAutoAim = right.bNoAutoAim;
			
			rKick = right.kickback;
			rYAdjust = right.yAdjust;
			Ammo1 = right.Ammo1;
		}
		
		if (left)
		{
			if (!hadRight)
			{
				bobStyle = left.bobStyle;
				bobSpeed = left.bobSpeed;
				bobRangeX = left.bobRangeX;
				bobRangeY = left.bobRangeY;
				FOVScale = left.FOVScale;
				lookScale = left.lookScale;
				crosshair = left.crosshair;
				
				bDontBob = left.bDontBob;
				bAxeBlood = left.bAxeBlood;
				bStaffKickback = left.bStaff2_Kickback;
				bNoAutoAim = left.bNoAutoAim;
			}
			
			lKick = left.kickback;
			lYAdjust = left.yAdjust;
			Ammo2 = left.Ammo1;
		}
		
		if (left && right)
		{
			kickback = min(lKick, rKick);
			yAdjust = max(lYAdjust, rYAdjust);
		}
		else if (left)
		{
			kickback = lKick;
			yAdjust = lYAdjust;
		}
		else if (right)
		{
			kickback = rKick;
			yAdjust = rYAdjust;
		}
	}
	
	void SetWeaponInfo(Weapon weap)
	{
		if (!weap)
			return;
			
		weap.kickback = kickback;
		weap.yAdjust = yAdjust;
		weap.Ammo1 = Ammo1;
		weap.Ammo2 = Ammo2;
		weap.bobStyle = bobStyle;
		weap.bobSpeed = bobSpeed;
		weap.bobRangeX = bobRangeX;
		weap.bobRangeY = bobRangeY;
		weap.FOVScale = FOVScale;
		weap.lookScale = lookScale;
		weap.crosshair = crosshair;
		
		weap.bDontBob = bDontBob;
		weap.bAxeBlood = bAxeBlood;
		weap.bStaff2_Kickback = bStaffKickback;
		weap.bNoAutoAim = bNoAutoAim;
	}
}

class DualWieldHolder : Weapon
{
	DWWeapon holding[2];
	bool bSwapWeapons;
	DualWeaponInfo weapInfo;
	
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
		Deselect:
		Fire:
		Ready:
			TNT1 A -1;
			Stop;
			
		Reload:
			TNT1 A 1 SetReload();
			Goto Ready;
			
		Zoom:
			TNT1 A 1 SetZoom();
			Goto Ready;
	}
	
	action void SetReload()
	{
		let left = invoker.holding[LEFT];
		if (left && (left.weaponState & WF_WEAPONRELOADOK))
		{
			let psp = player.FindPSprite(PSP_LEFTWEAPON);
			if (psp)
				psp.SetState(left.FindState("LeftReload"));
		}
		
		let right = invoker.holding[RIGHT];
		if (right && (right.weaponState & WF_WEAPONRELOADOK))
		{
			let psp = player.FindPSprite(PSP_RIGHTWEAPON);
			if (psp)
				psp.SetState(right.FindState("RightReload"));
		}
	}
	
	action void SetZoom()
	{
		int state1 = invoker.holding[LEFT] ? invoker.holding[LEFT].weaponState : 0;
		int state2 = invoker.holding[RIGHT] ? invoker.holding[RIGHT].weaponState : 0;
		
		if ((state1 & WF_WEAPONZOOMOK) && (state2 & WF_WEAPONZOOMOK))
		{
			let psp = player.FindPSprite(PSP_LEFTWEAPON);
			if (psp)
				psp.SetState(invoker.holding[LEFT].FindState("LeftZoom"));
				
			psp = player.FindPSprite(PSP_RIGHTWEAPON);
			if (psp)
				psp.SetState(invoker.holding[RIGHT].FindState("RightZoom"));
		}
	}
	
	private void SwitchWeapons()
	{
		let temp = holding[LEFT];
		holding[LEFT] = holding[RIGHT];
		holding[RIGHT] = temp;
		
		bSwapWeapons = false;
	}
	
	override State GetReadyState()
	{
		if (bSwapWeapons)
			SwitchWeapons();
			
		let wpn = owner.player.GetPSprite(PSP_WEAPON);
		if (wpn)
		{
			wpn.x = 0;
			wpn.y = WEAPONTOP;
		}
		
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
		if (bSwapWeapons)
			SwitchWeapons();
			
		let wpn = owner.player.GetPSprite(PSP_WEAPON);
		if (wpn)
		{
			wpn.x = 0;
			wpn.y = WEAPONTOP;
		}
		
		if (holding[LEFT])
		{
			let psp = owner.player.GetPSprite(PSP_LEFTWEAPON);
			if (psp)
			{
				psp.caller = holding[LEFT];
				psp.y = WEAPONBOTTOM - WEAPONTOP;
				psp.SetState(holding[LEFT].GetLeftUpState());
			}
		}
		
		if (holding[RIGHT])
		{
			let psp = owner.player.GetPSprite(PSP_RIGHTWEAPON);
			if (psp)
			{
				psp.caller = holding[RIGHT];
				psp.y = WEAPONBOTTOM - WEAPONTOP;
				psp.SetState(holding[RIGHT].GetRightUpState());
			}
		}
		
		return super.GetUpState();
	}

	override Inventory CreateTossable(int amt)
	{
		Inventory tossed;
		if (holding[LEFT])
			tossed = holding[LEFT].CreateTossable(amt);
		
		if (!tossed && holding[RIGHT])
			tossed = holding[RIGHT].CreateTossable(amt);
			
		return tossed;
	}
	
	override void PlayUpSound(Actor origin)
	{
		let left = holding[LEFT];
		if (left && left.upSound)
			origin.A_StartSound(left.upSound, CHAN_WEAPON, CHANF_OVERLAP);
			
		let right = holding[RIGHT];
		if (right && right.upSound)
			origin.A_StartSound(right.upSound, CHAN_WEAPON, CHANF_OVERLAP);
	}
	
	override bool DepleteAmmo(bool altFire, bool checkEnough, int ammouse)
	{
		return true;
	}
	
	override bool CheckAmmo(int fireMode, bool autoSwitch, bool requireAmmo, int ammocount)
	{
		return true;
	}
	
	override void DoEffect()
	{
		if (!owner || !owner.player)
		{
			Destroy();
			return;
		}
		
		if (holding[LEFT])
		{
			if (!holding[LEFT].owner)
			{
				holding[LEFT].bDualWielded = false;
				holding[LEFT] = null;
				
				if (owner.player.ReadyWeapon == self)
				{
					owner.player.SetPSprite(PSP_LEFTWEAPON, null);
					owner.player.SetPSprite(PSP_LEFTFLASH, null);
				}
			}
			else
			{
				if (owner.player.ReadyWeapon == self)
				{
					let psp = owner.player.FindPSprite(PSP_LEFTWEAPON);
					if (psp)
						psp.bAddBob = holding[LEFT].weaponState & WF_WEAPONBOBBING;
						
					psp = owner.player.FindPSprite(PSP_LEFTFLASH);
					if (psp)
						psp.bAddBob = holding[LEFT].weaponState & WF_WEAPONBOBBING;
				}
			}
		}
		
		if (holding[RIGHT])
		{
			if (!holding[RIGHT].owner)
			{
				holding[RIGHT].bDualWielded = false;
				holding[RIGHT] = null;
				
				if (owner.player.ReadyWeapon == self)
				{
					owner.player.SetPSprite(PSP_RIGHTWEAPON, null);
					owner.player.SetPSprite(PSP_RIGHTFLASH, null);
				}
			}
			else
			{
				if (owner.player.ReadyWeapon == self)
				{
					let psp = owner.player.FindPSprite(PSP_RIGHTWEAPON);
					if (psp)
						psp.bAddBob = holding[RIGHT].weaponState & WF_WEAPONBOBBING;
						
					psp = owner.player.FindPSprite(PSP_RIGHTFLASH);
					if (psp)
						psp.bAddBob = holding[RIGHT].weaponState & WF_WEAPONBOBBING;
				}
			}
		}
		
		if (!holding[LEFT] || !holding[RIGHT])
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
			
			if (owner.player.ReadyWeapon == self)
				owner.player.PendingWeapon = pending;
			
			Destroy();
			return;
		}
		else if (owner.player.ReadyWeapon == self && owner.player.PendingWeapon != WP_NOCHANGE
				&& !owner.player.FindPSprite(PSP_LEFTWEAPON) && !owner.player.FindPSprite(PSP_RIGHTWEAPON))
		{
			owner.player.mo.BringUpWeapon();
			return;
		}
		
		weapInfo.Reset();
		weapInfo.UpdateWeaponInfo(holding[LEFT], holding[RIGHT]);
		weapInfo.SetWeaponInfo(self);
	}
	
	override void Tick() {}
}