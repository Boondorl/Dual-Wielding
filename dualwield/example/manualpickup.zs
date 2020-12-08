class MPWeapon : DWWeapon
{
	override void Touch(Actor toucher)
	{
		if (toucher.player && !(toucher.player.cmd.buttons & BT_USER1))
			return;
			
		super.Touch(toucher);
	}
	
	override bool HandlePickup(Inventory item)
	{
		if (!(item is GetClass()))
			return false;
			
		let wpn = DWWeapon(owner.FindInventory(item.GetClass()));
		if (!wpn || (self == owner.player.ReadyWeapon && !bDualWielded))
			return false;
		
		return super.HandlePickup(item);
	}
	
	override void AttachToOwner(Actor other)
	{
		super.AttachToOwner(other);
		
		if (!owner || !owner.player)
			return;
		
		let wpn = DWWeapon(owner.player.ReadyWeapon);
		if (wpn && !wpn.bDualWielded)
		{
			let holder = DualWieldHolder(Spawn("DualWieldHolder", (0,0,0), ALLOW_REPLACE));
			if (holder)
			{
				holder.AttachToOwner(owner);
				
				holder.holding[RIGHT] = DWWeapon(self);
				holder.holding[LEFT] = wpn;
				
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