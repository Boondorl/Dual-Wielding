// TODO: Weapon switching
class DWPlayerPawn : PlayerPawn
{
	override void FireWeapon(State stat)
	{
		let dwh = DualWieldHolder(player.ReadyWeapon);
		if (!dwh)
		{
			super.FireWeapon(stat);
			return;
		}
			
		let wpn = dwh.holding[LEFT];
		if (!wpn || !wpn.CheckAmmo(Weapon.PrimaryFire,false))
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
		if (!wpn || !wpn.CheckAmmo(Weapon.PrimaryFire,false))
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
	
	override void TickPSprites()
	{
		// Get the DualWieldHolder instead if it's dual wielding
		let dwwpn = DWWeapon(player.PendingWeapon);
		if (dwwpn && dwwpn.bDualWielded)
		{
			for (let probe = inv; probe; probe = probe.inv)
			{
				let holder = DualWieldHolder(probe);
				if (holder && (dwwpn == holder.holding[LEFT] || dwwpn == holder.holding[RIGHT]))
				{
					if (holder == player.ReadyWeapon)
					{
						bool found;
						int slot;
						[found, slot] = player.weapons.LocateWeapon(dwwpn.GetClass());
						if (found && player.weapons.SlotSize(slot) > 2)
						{
							let cur = player.ReadyWeapon;
							player.ReadyWeapon = dwwpn;
							player.PendingWeapon = PickPrevWeapon();
							player.ReadyWeapon = cur;
						}
						else
							player.PendingWeapon = null;
					}
					else
						player.PendingWeapon = holder;
						
					break;
				}
			}
		}
			
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
	
	// Allows both primary and alt fires to be used at the same time
	void CheckDualWeaponFire()
	{
		let wpn = DualWieldHolder(player.ReadyWeapon);
		if (!wpn)
			return;
		
		bool fired;
		int state1 = wpn.holding[LEFT] ? wpn.holding[LEFT].weaponState : 0;
		int state2 = wpn.holding[RIGHT] ? wpn.holding[RIGHT].weaponState : 0;
		
		if ((state1 & WF_WEAPONREADY) && (player.cmd.buttons & BT_ATTACK))
		{
			if (!player.attackdown || !wpn.bNoAutofire)
			{
				player.attackdown = true;
				fired = true;
				FireWeapon(null);
			}
		}
		
		if ((state2 & WF_WEAPONREADYALT) && (player.cmd.buttons & BT_ALTATTACK))
		{
			if (!player.attackdown || !wpn.bNoAutofire)
			{
				player.attackdown = true;
				fired = true;
				FireWeaponAlt(null);
			}
		}
		
		if (!fired)
			player.attackdown = false;
	}
}