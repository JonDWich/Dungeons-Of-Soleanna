function ToMeter(_ARG_0_)
  return _ARG_0_ * 100
end
function GetRandomAppearRadius(_ARG_0_, _ARG_1_, _ARG_2_)
  return _ARG_1_ + (_ARG_2_ - _ARG_1_) * GetRandom(_ARG_0_)
end
Enemy.firstmefiress_test = {
  Phase = "omega",
  MaxUnits = 256,
  UnitHP = 1,
  MovableRadius,
  MinAppearRadius,
  MaxAppearRadius,
  LodNear,
  MoveSpeed,
  DodgeSpeed,
  ApproachSpeed,
  EscapeSpeed,
  CircularFlightSpeed,
  DeltaSpeed,
  MinSpringAppearHeight,
  MaxSpringAppearHeight,
  SpringSpeed,
  SpringG,
  SpringErrorRadius,
  SpringFailedTime,
  HoldErrorAngle,
  HoldSpace,
  MaxHoldUnits,
  HoldExplosionWaitTime,
  MinAttackAppearHeight,
  MaxAttackAppearHeight,
  MaxAttackHomingHeight,
  AttackSpeed,
  AttackHomingSpeed,
  AttackTime,
  MinEncirclementHeight,
  MaxEncirclementHeight,
  MinEncirclementRadius,
  MaxEncirclementRadius,
  TargetLostDistance,
  BlownSpeed,
  SmashBlownSpeed,
  BlownTime,
  ParalysisTime,
  DeathBallWaitTime,
  DeathBallLifeTime,
  DeathBallSpeed,
  DeathBallHomingRate,
  InitParameters = function(_ARG_0_)
    Enemy.firstmefiress_test.MinAppearRadius = 5
    Enemy.firstmefiress_test.MaxAppearRadius = 7.5
    Enemy.firstmefiress_test.LodNear = 15
    Enemy.firstmefiress_test.MoveSpeed = 5000 --10
    Enemy.firstmefiress_test.DodgeSpeed = 5000  --0.5
    Enemy.firstmefiress_test.ApproachSpeed = 5000 --9
    Enemy.firstmefiress_test.EscapeSpeed = 5000 --9
    Enemy.firstmefiress_test.CircularFlightSpeed = 5000 --25
    Enemy.firstmefiress_test.DeltaSpeed = 5000 --0.5
    Enemy.firstmefiress_test.MinSpringAppearHeight = 1
    Enemy.firstmefiress_test.MaxSpringAppearHeight = 2.5
    Enemy.firstmefiress_test.SpringSpeed = 5000 --5
    Enemy.firstmefiress_test.SpringG = 9.8
    Enemy.firstmefiress_test.SpringErrorRadius = 2
    Enemy.firstmefiress_test.SpringFailedTime = 0.25
    Enemy.firstmefiress_test.HoldErrorAngle = 15
    Enemy.firstmefiress_test.HoldSpace = 0.2
    Enemy.firstmefiress_test.MaxHoldUnits = 5
    Enemy.firstmefiress_test.HoldExplosionWaitTime = 2
    Enemy.firstmefiress_test.MinAttackAppearHeight = 2
    Enemy.firstmefiress_test.MaxAttackAppearHeight = 4
    Enemy.firstmefiress_test.MaxAttackHomingHeight = 10
    Enemy.firstmefiress_test.AttackSpeed = 7.5
    Enemy.firstmefiress_test.AttackHomingSpeed = 30
    Enemy.firstmefiress_test.AttackTime = 2.5
    Enemy.firstmefiress_test.AttackHomingTime = 1
    Enemy.firstmefiress_test.MinEncirclementHeight = 0.75
    Enemy.firstmefiress_test.MaxEncirclementHeight = 3.5
    Enemy.firstmefiress_test.MinEncirclementRadius = 8
    Enemy.firstmefiress_test.MaxEncirclementRadius = 16
    Enemy.firstmefiress_test.TargetLostDistance = 20
    Enemy.firstmefiress_test.BlownSpeed = 12
    Enemy.firstmefiress_test.SmashBlownSpeed = 12
    Enemy.firstmefiress_test.BlownTime = 0.25
    Enemy.firstmefiress_test.ParalysisTime = 5
    Enemy.firstmefiress_test.DeathBallWaitTime = 5
    Enemy.firstmefiress_test.DeathBallLifeTime = 10
    Enemy.firstmefiress_test.DeathBallSpeed = 6
    Enemy.firstmefiress_test.DeathBallHomingRate = 0.25
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  SwarmParameters = function(_ARG_0_)
    Enemy.firstmefiress_test.DodgeSpeed = 0.4
    Enemy.firstmefiress_test.ApproachSpeed = 6000
    Enemy.firstmefiress_test.EscapeSpeed = 6000
    Enemy.firstmefiress_test.MinEncirclementRadius = 8
    Enemy.firstmefiress_test.MaxEncirclementRadius = 14
    Enemy.firstmefiress_test.TargetLostDistance = 16
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  EscapeParameters = function(_ARG_0_)
    Enemy.firstmefiress_test.DodgeSpeed = 0.3
    Enemy.firstmefiress_test.ApproachSpeed = 5000
    Enemy.firstmefiress_test.EscapeSpeed = 10000
    Enemy.firstmefiress_test.MinEncirclementRadius = 10
    Enemy.firstmefiress_test.MaxEncirclementRadius = 20
    Enemy.firstmefiress_test.TargetLostDistance = 25
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  Appear = function(_ARG_0_)
    SetParameter(_ARG_0_, "FatalEvent", 0, 0.5)
    _UPVALUE0_ = 0
	puzzle_EnemyKills = 0
	maxGemCount = 4
	coolDown = 10
	currentGemCount = 0
	maxWeaponCount = 2
	currentWeaponCount = 0
	flag_bTri = true
	flag_rTri = true
	flag_grTri = true
	flag_bCr = true
	flag_rCr = true
	flag_grCr = true
	flag_bSh = true
	flag_rSh = true
	flag_grSh = true
    --math.randomseed(1)
	if not CheckGroupMemberExist(_ARG_0_, "SolarisUp") then
	  solarisMultiplier = 0.5
	else
	  solarisMultiplier = 0
	end
    Enemy.firstmefiress_test.InitParameters(_ARG_0_)
    Enemy.firstmefiress_test.SwarmParameters(_ARG_0_)
    CallMessage(_ARG_0_, "guard_on")
    WaitFixed(_ARG_0_, 0.1)
  end,
  Search = function(_ARG_0_)
    SearchPlayer(_ARG_0_, 0)
  end,
  Action = function(_ARG_0_)
	--CallPushState(_ARG_0_, "SpawnManagers")
	CallHintMessage(_ARG_0_, "BeginLoop")
	CallChangeAction(_ARG_0_, "KeyManager")
  end,
  RegenCheck = function(_ARG_0_)
    if not CheckGroupMemberExist(_ARG_0_, "RegenMeter") or not CheckGroupMemberExist(_ARG_0_, "SolarisUp") then
	  coolDown = coolDown - 1
	  if coolDown <= 0 then
	    CallChaosDrive(_ARG_0_, 10)
	    coolDown = 10
	  end
	end
  end,
  SpawnManagers = function(_ARG_0_)
    for i = 1, 1 do
	  FirstMefiress_SetPointGroup(_ARG_0_, "f" .. i)
	  FirstMefiress_RandomWarp(_ARG_0_, 9000)
	  WaitFixed(_ARG_0_, 0.1)
	  --CallCreateEnemyInNode(_ARG_0_, "Head", "eFlyer", "eFlyer_Door_Manager", 0, "placeholder" .. i, 0, 200, 0, true)
	end
	CallHintMessage(_ARG_0_, "BeginLoop")
	--CallHintMessage(_ARG_0_, "hint_bos04_e10_mf", false)
  end,
  KeyManager = function(_ARG_0_)
    bTri = CheckGroupMemberExist(_ARG_0_, "BlueTriangle")
	rTri = CheckGroupMemberExist(_ARG_0_, "RedTriangle")
	grTri = CheckGroupMemberExist(_ARG_0_, "GreenTriangle")
	bSh = CheckGroupMemberExist(_ARG_0_, "BlueShield")
	rSh = CheckGroupMemberExist(_ARG_0_, "RedShield")
	grSh = CheckGroupMemberExist(_ARG_0_, "GreenShield")	
	bCr = CheckGroupMemberExist(_ARG_0_, "BlueCrescent")
	rCr = CheckGroupMemberExist(_ARG_0_, "RedCrescent")
	grCr = CheckGroupMemberExist(_ARG_0_, "GreenCrescent")
	CallHintMessage(_ARG_0_, "LoopDisplay")
	if bTri then
	  if not CheckGroupMemberExist(_ARG_0_, "BlueTriangle1") then
	    CallHintMessage(_ARG_0_, "BlueTri") --Displays the UI element
		if flag_bTri then
		  flag_bTri = false
		  CallHintMessage(_ARG_0_, "BlueTriangle")
		end
	  end
	end
	if rTri then
	  if not CheckGroupMemberExist(_ARG_0_, "RedTriangle1") then
	    CallHintMessage(_ARG_0_, "RedTri")
		if flag_rTri then
		  flag_rTri = false
		  CallHintMessage(_ARG_0_, "RedTriangle")
		end
	  end
	end
	if grTri then
	  if not CheckGroupMemberExist(_ARG_0_, "GreenTriangle1") then
	    CallHintMessage(_ARG_0_, "GreenTri")
		if flag_grTri then
		  flag_grTri = false
		  CallHintMessage(_ARG_0_, "GreenTriangle")
		end
	  end
	end
	if bSh then
	  if not CheckGroupMemberExist(_ARG_0_, "BlueShield1") then
	    CallHintMessage(_ARG_0_, "BlueSh")
		if flag_bSh then
		  flag_bSh = false
		  CallHintMessage(_ARG_0_, "BlueShield")
		end
	  end
	end
	if rSh then
	  if not CheckGroupMemberExist(_ARG_0_, "RedShield1") then
	    CallHintMessage(_ARG_0_, "RedSh")
		if flag_rSh then
		  flag_rSh = false
		  CallHintMessage(_ARG_0_, "RedShield")
		end
	  end
	end
	if grSh then
	  if not CheckGroupMemberExist(_ARG_0_, "GreenShield1") then
	    CallHintMessage(_ARG_0_, "GreenSh")
		if flag_grSh then
		  flag_grSh = false
		  CallHintMessage(_ARG_0_, "GreenShield")
		end
	  end
	end
	if bCr then
	  if not CheckGroupMemberExist(_ARG_0_, "BlueCrescent1") then
	    CallHintMessage(_ARG_0_, "BlueCr")
		if flag_bCr then
		  flag_bCr = false
		  CallHintMessage(_ARG_0_, "BlueCrescent")
		end
	  end
	end
	if rCr then
	  if not CheckGroupMemberExist(_ARG_0_, "RedCrescent1") then
	    CallHintMessage(_ARG_0_, "RedCr")
		if flag_rCr then
		  flag_rCr = false
		  CallHintMessage(_ARG_0_, "RedCrescent")
		end
	  end
	end
	if grCr then
	  if not CheckGroupMemberExist(_ARG_0_, "GreenCrescent1") then
	    CallHintMessage(_ARG_0_, "GreenCr")
		if flag_grCr then
		  flag_grCr = false
		  CallHintMessage(_ARG_0_, "GreenCrescent")
		end
	  end
	end
	CallPushState(_ARG_0_, "RegenCheck")
	WaitFixed(_ARG_0_, 1)
  end,
  OnBeginTargetBoost = function(_ARG_0_)
  end,
  OnEndTargetBoost = function(_ARG_0_)
  end,
  OnDamage = function(_ARG_0_)
  end,
  OnFatal = function(_ARG_0_)
    if GetParameter(_ARG_0_, "FatalEventId") == 0 then
      CallMessage(_ARG_0_, "guard_on")
      WaitFixed(_ARG_0_, 1)
      CallMessage(_ARG_0_, "guard_off")
      CallSetCamera(_ARG_0_, "main", 1, 700, 0, 150, 0, -100, 0, 0.5, 100)
      CallHintMessage(_ARG_0_, "hint_bos04_e10_mf", false)
      FirstMefiress_DeathBall(_ARG_0_)
      CallResetCamera(_ARG_0_, "main")
      WaitFixed(_ARG_0_, 10)
    end
    CallMessage(_ARG_0_, "guard_on")
  end,
  OnStun = function(_ARG_0_)
    CallResetCamera(_ARG_0_, "main")
    CallMessage(_ARG_0_, "guard_off")
    if _UPVALUE0_ < 1 then
      DamageKnockBack(_ARG_0_)
      _UPVALUE0_ = _UPVALUE0_ + 1
    end
  end,
  OnDeathBallCancel = function(_ARG_0_)
    CallResetCamera(_ARG_0_, "main")
    CallMessage(_ARG_0_, "guard_off")
    if _UPVALUE0_ < 3 then
      FirstMefiress_Tired(_ARG_0_, 5)
      _UPVALUE0_ = _UPVALUE0_ + 1
    else
      CallMessage(_ARG_0_, "guard_on")
    end
  end,
  CreateTest = function(_ARG_0_)
   ThirdIblisCreatePhysicsObject(_ARG_0_, "WoodBox", -14993, -205, 14846)
   end,
  OnDead = function(_ARG_0_)
    CallMessage(_ARG_0_, "dead")
    WaitFixed(_ARG_0_, 9999)
  end
}
