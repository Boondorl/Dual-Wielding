// TODO: Weird ammo consumption while firing
class DWWeapon : Weapon
{
	bool bDualWielded;
	int weaponState;
	int refire;
	bool attackdown;
	
	action void A_DualWeaponReady(int flags = 0)
	{
		int prevState = player.WeaponState;
		A_WeaponReady(flags);
		invoker.weaponState = player.WeaponState;
		player.WeaponState = prevState;
	}
	
	action void A_DualReFire(StateLabel sl = null)
	{
		let wpn = DualWieldHolder(player.ReadyWeapon);
		if (!wpn)
			return;
			
		bool pending = player.PendingWeapon != WP_NOCHANGE && (player.WeaponState & WF_REFIRESWITCHOK);
		bool fired;
		if (!pending && player.health > 0)
		{
			if ((player.cmd.buttons & BT_ATTACK) && wpn.holding[LEFT] == invoker)
			{
				++invoker.refire;
				player.mo.FireWeapon(invoker.FindState(sl));
				fired = true;
			}
			
			if ((player.cmd.buttons & BT_ALTATTACK) && wpn.holding[RIGHT] == invoker)
			{
				++invoker.refire;
				player.mo.FireWeaponAlt(invoker.FindState(sl));
				fired = true;
			}
		}
		
		if (!fired)
			invoker.refire = 0;
	}
	
	action void A_DualGunFlash(StateLabel sl = null, int flags = 0)
	{
		let wpn = DualWieldHolder(player.ReadyWeapon);
		if (!wpn)
			return;

		if (!(flags & GFF_NOEXTCHANGE))
			player.mo.PlayAttacking2();
			
		State flash;
		if (!sl)
		{
			if (wpn.holding[LEFT] == invoker)
				flash = invoker.FindState("LeftFlash");
			else
				flash = invoker.FindState("RightFlash");
		}
		else
			flash = invoker.FindState(sl);
			
		let psp = player.GetPSprite(wpn.holding[LEFT] == invoker ? PSP_LEFTFLASH : PSP_RIGHTFLASH);
		if (psp)
		{
			psp.caller = invoker;
			psp.SetState(flash);
		}
	}
	
	action double GetAccuracy(int shots)
	{
		if (shots == 1)
			return invoker.refire ? -1 : 0;
			
		return shots;
	}
	
	override void DoEffect()
	{
		weaponState = 0;
	}
	
	virtual State GetRightAtkState(bool hold)
	{
		State s;
		if (hold)
			s = FindState("RightHold");
			
		if (!s)
			s = FindState("RightFire");
			
		return s;
	}
	
	virtual State GetLeftAtkState(bool hold)
	{
		State s;
		if (hold)
			s = FindState("LeftHold");
			
		if (!s)
			s = FindState("LeftFire");
			
		return s;
	}
	
	virtual State GetRightReadyState()
	{
		return FindState("RightReady");
	}
	
	virtual State GetLeftReadyState()
	{
		return FindState("LeftReady");
	}
	
	virtual State GetRightUpState()
	{
		return FindState("RightSelect");
	}
	
	virtual State GetLeftUpState()
	{
		return FindState("LeftSelect");
	}
	
	virtual State GetRightDownState()
	{
		return FindState("RightDeselect");
	}
	
	virtual State GetLeftDownState()
	{
		return FindSTate("LeftDeselect");
	}
}