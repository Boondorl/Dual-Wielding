class DWPlayerPawn : PlayerPawn
{
	override void FireWeapon(State stat)
	{
		let wpnh = DualWieldHolder(player.ReadyWeapon);
		if (!wpnh)
		{
			super.FireWeapon(stat);
			return;
		}
			
		let wpn = wpnh.GetLeftWeapon();
		if (!wpn || !wpn.CheckAmmo(Weapon.PrimaryFire,false))
			return;

		wpn.weaponState &= ~WF_WEAPONBOBBING;
		PlayAttacking();
		wpn.bAltFire = false;
		wpnh.bAltFire = false;
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
		let wpnh = DualWieldHolder(player.ReadyWeapon);
		if (!wpnh)
		{
			super.FireWeaponAlt(stat);
			return;
		}
			
		let wpn = wpnh.GetRightWeapon();
		if (!wpn || !wpn.CheckAmmo(Weapon.PrimaryFire,false))
			return;

		wpn.weaponState &= ~WF_WEAPONBOBBING;
		PlayAttacking();
		wpn.bAltFire = false;
		wpnh.bAltFire = true;
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
	
	override void CheckWeaponChange()
	{
		if ((player.WeaponState & WF_DISABLESWITCH) || player.morphTics != 0)
			player.PendingWeapon = WP_NOCHANGE;

		if ((player.PendingWeapon != WP_NOCHANGE || player.health <= 0) &&
			player.WeaponState & WF_WEAPONSWITCHOK)
		{
			// Get the DualWieldHolder instead if it's dual wielding
			let dwwpn = DWWeapon(player.PendingWeapon);
			if (dwwpn && dwwpn.DualWielding())
			{
				for (let probe = inv; probe; probe = probe.inv)
				{
					let holder = DualWieldHolder(probe);
					if (holder && (dwwpn == holder.GetLeftWeapon() || dwwpn == holder.GetRightWeapon()))
					{
						// TODO: This should account for multiple weapons in a slot
						player.PendingWeapon = holder;
						break;
					}
				}
			}
			
			DropWeapon();
		}
	}
	
	override void TickPSprites()
	{
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
				let wpnh = DualWieldHolder(pspr.owner.ReadyWeapon);
				if (wpnh)
				{
					// Ensure the right caller is set at all times
					if (pspr.id == PSP_LEFTWEAPON)
						pspr.caller = wpnh.GetLeftWeapon();
					else if (pspr.id == PSP_RIGHTWEAPON)
						pspr.caller = wpnh.GetRightWeapon();
						
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
		int state1 = wpn.holding[LEFT].weaponState;
		int state2 = wpn.holding[RIGHT].weaponState;
		
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