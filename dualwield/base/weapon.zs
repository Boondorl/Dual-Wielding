class DWWeapon : Weapon
{
	bool bDualWielded;
	int weaponState;
	int refire;
	
	private State prevState;
	
	bool DualWielding()
	{
		return bDualWielded;
	}
	
	action void A_DualWeaponReady(int flags = 0)
	{
		int prevState = player.WeaponState;
		A_WeaponReady(flags);
		invoker.weaponState = player.WeaponState;
		player.WeaponState = prevState;
	}
	
	action void A_DualReFire(StateLabel sl = null)
	{
		int prevReFire = player.refire;
		A_ReFire(sl);
		invoker.refire += player.refire - prevReFire;
		player.refire = prevReFire;
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