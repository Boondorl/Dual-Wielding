class DWPlayerPawn : PlayerPawn
{
	private Weapon prevPending;
	
	override void FireWeapon(State stat)
	{
		let dwh = DualWieldHolder(player.ReadyWeapon);
		if (!dwh)
		{
			super.FireWeapon(stat);
			return;
		}
			
		let wpn = dwh.holding[LEFT];
		if (!wpn || !wpn.CheckAmmo(Weapon.PrimaryFire,false) || !wpn.DepleteAmmo(false))
			return;

		wpn.weaponState &= ~WF_WEAPONBOBBING;
		PlayAttacking();
		wpn.bAltFire = false;
		dwh.bAltFire = false;
		if (!stat)
			stat = wpn.GetLeftAtkState(!!player.refire);
		
		// DO NOT use SetPSprite; this will reset the caller to the ReadyWeapon and break things
		let psp = player.GetPSprite(PSP_LEFTWEAPON);
		if (psp)
		{
			psp.caller = wpn;
			psp.SetState(stat);
		}
			
		if (!wpn.bNoAlert)
			SoundAlert(self, false);
	}
	
	override void FireWeaponAlt(State stat)
	{
		let dwh = DualWieldHolder(player.ReadyWeapon);
		if (!dwh)
		{
			super.FireWeaponAlt(stat);
			return;
		}
			
		let wpn = dwh.holding[RIGHT];
		if (!wpn || !wpn.CheckAmmo(Weapon.PrimaryFire,false) || !wpn.DepleteAmmo(false))
			return;

		wpn.weaponState &= ~WF_WEAPONBOBBING;
		PlayAttacking();
		wpn.bAltFire = false;
		dwh.bAltFire = true;
		if (!stat)
			stat = wpn.GetRightAtkState(!!player.refire);
		
		// DO NOT use SetPSprite; this will reset the caller to the ReadyWeapon and break things
		let psp = player.GetPSprite(PSP_RIGHTWEAPON);
		if (psp)
		{
			psp.caller = wpn;
			psp.SetState(stat);
		}
		
		if (!wpn.bNoAlert)
			SoundAlert(self, false);
	}
	
	override Weapon PickNextWeapon()
	{
		let wpn = DualWieldHolder(player.ReadyWeapon);
		if (!wpn)
			return super.PickNextWeapon();
			
		player.ReadyWeapon = wpn.holding[RIGHT];
		if (!player.ReadyWeapon)
			player.ReadyWeapon = wpn.holding[LEFT];
			
		let next = super.PickNextWeapon();
		if (next == player.ReadyWeapon)
			next = wpn;
			
		player.ReadyWeapon = wpn;
		
		return next;
	}

	override Weapon PickPrevWeapon()
	{
		let wpn = DualWieldHolder(player.ReadyWeapon);
		if (!wpn)
			return super.PickPrevWeapon();
			
		player.ReadyWeapon = wpn.holding[RIGHT];
		if (!player.ReadyWeapon)
			player.ReadyWeapon = wpn.holding[LEFT];
			
		let prev = super.PickPrevWeapon();
		if (prev == player.ReadyWeapon)
			prev = wpn;
			
		player.ReadyWeapon = wpn;
		
		return prev;
	}
	
	override void TickPSprites()
	{
		CheckPendingWeapon();
		
		let pspr = player.psprites;
		while (pspr)
		{
			if (!pspr.caller ||
				(pspr.caller is "Inventory" && Inventory(pspr.caller).owner != pspr.owner.mo))
			{
				pspr.Destroy();
			}
			else
			{
				let dwh = DualWieldHolder(pspr.owner.ReadyWeapon);
				if (dwh)
				{
					// Ensure the right caller is set at all times
					if (pspr.id == PSP_LEFTWEAPON || pspr.id == PSP_LEFTFLASH)
						pspr.caller = dwh.holding[LEFT];
					else if (pspr.id == PSP_RIGHTWEAPON || pspr.id == PSP_RIGHTFLASH)
						pspr.caller = dwh.holding[RIGHT];
						
					if (!pspr.caller)
						pspr.Destroy();
					else
						pspr.Tick();
				}
				else if (pspr.caller is "Weapon" && pspr.caller != pspr.owner.ReadyWeapon)
					pspr.Destroy();
				else
					pspr.Tick();
			}

			pspr = pspr.Next;
		}
		
		ModifyWeaponState();
		
		if (health > 0 || (player.ReadyWeapon && !player.ReadyWeapon.bNoDeathInput))
		{
			if (!player.ReadyWeapon)
			{
				if (player.PendingWeapon != WP_NOCHANGE)
					player.mo.BringUpWeapon();
			}
			else
			{
				CheckWeaponChange();
				if (player.ReadyWeapon is "DualWieldHolder")
					CheckDualWeaponFire();
				else if (player.WeaponState & (WF_WEAPONREADY|WF_WEAPONREADYALT))
					CheckWeaponFire();
					
				CheckWeaponButtons();
			}
		}
	}
	
	void CheckPendingWeapon()
	{
		if (!prevPending)
			prevPending = WP_NOCHANGE;
			
		let dwwpn = DWWeapon(player.PendingWeapon);
		if (!dwwpn || !dwwpn.bDualWielded)
		{
			prevPending = player.PendingWeapon;
			return;
		}
		
		for (let probe = inv; probe; probe = probe.inv)
		{
			let holder = DualWieldHolder(probe);
			if (!holder || (dwwpn != holder.holding[LEFT] && dwwpn != holder.holding[RIGHT]))
				continue;
			
			if (dwwpn != holder.holding[RIGHT])
				holder.bSwapWeapons = true;
						
			if (player.ReadyWeapon == holder)
			{
				if (holder.bSwapWeapons)
					player.PendingWeapon = holder;
				else
				{
					bool found;
					int slot, startIndex;
					[found, slot, startIndex] = player.weapons.LocateWeapon(dwwpn.GetClass());
					
					if (found)
					{
						Weapon next;
						int index = startIndex;
						
						do
						{
							if (--index < 0)
								index = player.weapons.SlotSize(slot) - 1;
							
							if (index == startIndex)
								break;
							
							next = Weapon(FindInventory(player.weapons.GetWeapon(slot,index)));
							if (next && !next.CheckAmmo(Weapon.EitherFire,false))
								next = null;
						} while (!next);
						
						if (next)
							player.PendingWeapon = next;
						else
							player.PendingWeapon = prevPending;
					}
					else
						player.PendingWeapon = prevPending;
				}
			}
			else
				player.PendingWeapon = holder;
						
			break;
		}
		
		prevPending = player.PendingWeapon;
	}
	
	void ModifyWeaponState()
	{
		let dwh = DualWieldHolder(player.ReadyWeapon);
		if (!dwh)
			return;
			
		int state1 = dwh.holding[LEFT] ? dwh.holding[LEFT].weaponState : 0;
		int state2 = dwh.holding[RIGHT] ? dwh.holding[RIGHT].weaponState : 0;
		int newState = state1 | state2;
		if (!(state1 & WF_WEAPONSWITCHOK) || !(state2 & WF_WEAPONSWITCHOK))
			newState &= ~WF_WEAPONSWITCHOK;
			
		player.WeaponState = newState;
	}
	
	// Allows both primary and alt fires to be used at the same time
	void CheckDualWeaponFire()
	{
		let wpn = DualWieldHolder(player.ReadyWeapon);
		if (!wpn)
			return;
		
		int state1 = wpn.holding[LEFT] ? wpn.holding[LEFT].weaponState : 0;
		int state2 = wpn.holding[RIGHT] ? wpn.holding[RIGHT].weaponState : 0;
		
		if (state1 & WF_WEAPONREADY)
		{
			if (player.cmd.buttons & BT_ATTACK)
			{
				if (!wpn.holding[LEFT].attackdown || !wpn.holding[LEFT].bNoAutofire)
				{
					wpn.holding[LEFT].attackdown = true;
					FireWeapon(null);
				}
			}
			else
				wpn.holding[LEFT].attackdown = false;
		}
		
		if (state2 & WF_WEAPONREADYALT)
		{
			if (player.cmd.buttons & BT_ALTATTACK)
			{
				if (!wpn.holding[RIGHT].attackdown || !wpn.holding[RIGHT].bNoAutofire)
				{
					wpn.holding[RIGHT].attackdown = true;
					FireWeaponAlt(null);
				}
			}
			else
				wpn.holding[RIGHT].attackdown = false;
		}
		
		bool attack1 = wpn.holding[LEFT] ? wpn.holding[LEFT].attackdown : false;
		bool attack2 = wpn.holding[RIGHT] ? wpn.holding[RIGHT].attackdown : false;
		player.attackdown = attack1 || attack2;
	}
}