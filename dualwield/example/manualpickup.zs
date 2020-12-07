class MPWeapon : DWWeapon
{
	override void Touch(Actor toucher)
	{
		if (!toucher.player || !(toucher.player.cmd.buttons & BT_USER1))
			return;
			
		super.Touch(toucher);
	}
	
	override bool HandlePickup(Inventory item)
	{
		return false;
	}
	
	override void AttachToOwner(Actor other)
	{
		super.AttachToOwner(other);
		
		if (!owner || !owner.player)
			return;
		
		let wpn = DWWeapon(owner.player.ReadyWeapon);
		if (wpn && !wpn.bDualWielded)
		{
			let holder = DualWieldHolder(Spawn("DualWieldHolder"));
			if (holder)
			{
				holder.AttachToOwner(owner);
				
				holder.holding[RIGHT] = wpn;
				holder.holding[LEFT] = DWWeapon(self);
				
				wpn.bDualWielded = true;
				bDualWielded = true;
				
				if (owner.player.PendingWeapon == self)
				{
					owner.player.PendingWeapon = holder;
					owner.player.ReadyWeapon = null;
				}
			}
		}
	}
}