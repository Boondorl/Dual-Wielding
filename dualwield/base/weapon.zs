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
		
		if ((flags & WRF_NOFIRE) != WRF_NOFIRE)
		{
			let psp = player.FindPSprite(OverlayID());
			State st = OverlayID() == PSP_LEFTWEAPON ? invoker.FindState("LeftReady") : invoker.FindState("RightReady");
			if (invoker.ReadySound && psp && psp.curState == st
				&& (!invoker.bReadySndHalf || random[WpnReadySnd]() < 128))
			{
				player.mo.A_StartSound(invoker.ReadySound, CHAN_WEAPON, CHANF_OVERLAP);
			}
		}
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
	
	action void A_DualClearReFire()
	{
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
	
	action State A_DualCheckReload(StateLabel sl = null)
	{
		if(!invoker.CheckAmmo(PrimaryFire,false))
		{
			State st;
			if (sl)
				st = invoker.FindState(sl);
			else
				st = OverlayID() == PSP_LEFTWEAPON ? invoker.GetLeftReadyState() : invoker.GetRightReadyState();
				
			return st;
		}
		
		return null;
	}
	
	action void A_DualRaise(int raisespeed = 6)
	{
		if (player.PendingWeapon != WP_NOCHANGE)
		{
			player.mo.DropWeapon();
			return;
		}
		
		if (!player.ReadyWeapon)
			return;
			
		let psp = player.FindPSprite(OverlayID());
		if (!psp)
			return;

		if (psp.y <= WEAPONBOTTOM - WEAPONTOP)
			ResetPSprite(psp);
			
		psp.y -= raisespeed;
		if (psp.y > 0)
			return;
			
		psp.y = 0;
		psp.SetState(OverlayID() == PSP_LEFTWEAPON ? invoker.GetLeftReadyState() : invoker.GetRightReadyState());
	}
	
	action void A_DualLower(int lowerspeed = 6)
	{
		if (!player.ReadyWeapon)
		{
			player.mo.BringUpWeapon();
			return;
		}
		
		let psp = player.FindPSprite(OverlayID());
		if (!psp)
			return;
		
		int diff = WEAPONBOTTOM - WEAPONTOP;
		if (player.morphTics || (player.cheats & CF_INSTANTWEAPSWITCH))
			psp.y = diff;
		else
			psp.y += lowerspeed;
			
		if (psp.y < diff)
			return;
			
		ResetPSprite(psp);
		
		if (player.playerstate == PST_DEAD)
		{
			player.SetPSprite(OverlayID() == PSP_LEFTWEAPON ? PSP_LEFTFLASH : PSP_RIGHTFLASH, null);
			psp.SetState(invoker.FindState('DeadLowered'));
			return;
		}
		
		player.SetPSprite(OverlayID() == PSP_LEFTWEAPON ? PSP_LEFTFLASH : PSP_RIGHTFLASH, null);
		psp.Destroy();
	}
	
	action State A_DualJumpIfNoAmmo(StateLabel sl)
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		State st = A_JumpIfNoAmmo(sl);
		
		player.ReadyWeapon = rw;
		return st;
	}
	
	action State A_DualCheckForReload(int count, StateLabel jump, bool dontincrement = false)
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		State st = A_CheckForReload(count, jump, dontincrement);
		
		player.ReadyWeapon = rw;
		return st;
	}
	
	action void A_DualResetReloadCounter()
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		A_ResetReloadCounter();
		
		player.ReadyWeapon = rw;
	}
	
	action void A_DualFireBullets(double spread_xy, double spread_z, int numbullets, int damageperbullet, class<Actor> pufftype = "BulletPuff", int flags = 1, double range = 0, class<Actor> missile = null, double Spawnheight = 32, double Spawnofs_xy = 0)
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		A_FireBullets(spread_xy, spread_z, numbullets, damageperbullet, pufftype, flags, range, missile, Spawnheight, Spawnofs_xy);
		
		player.ReadyWeapon = rw;
	}
	
	action Actor A_DualFireProjectile(class<Actor> missiletype, double angle = 0, bool useammo = true, double spawnofs_xy = 0, double spawnheight = 0, int flags = 0, double pitch = 0)
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		let missile = A_FireProjectile(missiletype, angle, useammo, spawnofs_xy, spawnheight, flags, pitch);
		
		player.ReadyWeapon = rw;
		return missile;
	}
	
	action void A_DualCustomPunch(int damage, bool norandom = false, int flags = CPF_USEAMMO, class<Actor> pufftype = "BulletPuff", double range = 0, double lifesteal = 0, int lifestealmax = 0, class<BasicArmorBonus> armorbonustype = "ArmorBonus", sound MeleeSound = 0, sound MissSound = "")
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		A_CustomPunch(damage, norandom, flags, pufftype, range, lifesteal, lifestealmax, armorbonustype, MeleeSound, MissSound);
		
		player.ReadyWeapon = rw;
	}
	
	action void A_DualRailAttack(int damage, int spawnofs_xy = 0, bool useammo = true, color color1 = 0, color color2 = 0, int flags = 0, double maxdiff = 0, class<Actor> pufftype = "BulletPuff", double spread_xy = 0, double spread_z = 0, double range = 0, int duration = 0, double sparsity = 1.0, double driftspeed = 1.0, class<Actor> spawnclass = "none", double spawnofs_z = 0, int spiraloffset = 270, int limit = 0)
	{
		let rw = player.ReadyWeapon;
		player.ReadyWeapon = invoker;
		
		A_RailAttack(damage, spawnofs_xy, useammo, color1, color2, flags, maxdiff, pufftype, spread_xy, spread_z, range, duration, sparsity, driftspeed, spawnclass, spawnofs_z, spiraloffset, limit);
		
		player.ReadyWeapon = rw;
	}
	
	action int GetAccuracy()
	{
		return invoker.refire ? -1 : 0;
	}
	
	override void Tick()
	{
		super.Tick();
		
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