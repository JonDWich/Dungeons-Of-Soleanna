function ToMeter(_ARG_0_)
  return _ARG_0_ * 100
end
function GetRandomAppearRadius(_ARG_0_, _ARG_1_, _ARG_2_)
  return _ARG_1_ + (_ARG_2_ - _ARG_1_) * GetRandom(_ARG_0_)
end
CutscenePoints = {
    [1] = {X = -3112, Y = 1010, Z = -24779}, --Player movement points
	Attack = {
	  [1] = {X = -5418, Y = 1110, Z = -23689}, --Bomb attack points
	  [2] = {X = -5418, Y = 1110, Z = -26069}
	},
	Teleport = {
	  [1] = {X = -6470, Y = 1562, Z = -23963}, --Left
	  [2] = {X = -6470, Y = 1562, Z = -24779}, --Middle
	  [3] = {X = -6470, Y = 1562, Z = -25585}, --Right
	  Camera = {X = -11597, Y = 1562, Z = -24779}
	}
}
--9-14, 5, 6, 15, 3, 4, 15
AttackPoints = {
  [1] = {X = -5418, Y = 1110, Z = -23689},
  [2] = {X = -3312, Y = 1110, Z = -24779},
  [3] = {X = -5445, Y = 1110, Z = -24779},
  [4] = {X = -2176, Y = 1110, Z = -24779},
  [5] = {X = -3502, Y = 1110, Z = -23642},
  [6] = {X = -3502, Y = 1110, Z = -25862},
  [7] = {X = -5946, Y = 1110, Z = -23642},
  [8] = {X = -5946, Y = 1110, Z = -25862},
  ----------------------------------------
  ----------CarpetBomb starts here--------
  [9] = {X = -1797, Y = 1110, Z = -23962}, --b_warp_R
  [10] = {X = -1797, Y = 1110, Z = -24779}, --b_warp_m
  [11] = {X = -1797, Y = 1110, Z = -25585}, --b_warp_L
  [12] = {X = -6470, Y = 1110, Z = -23963}, --f_warp_L
  [13] = {X = -6470, Y = 1110, Z = -24779}, --f_warp_m
  [14] = {X = -6470, Y = 1110, Z = -25585}, --f_warp_R
  [15] = {X = -4215, Y = 1110, Z = -24940}, --Mephiles_Center
  [16] = {X = -3947, Y = 1110, Z = -24992}, --Player_Center
  [17] = {X = -4625, Y = 1110, Z = -23963}, --alt_FL
  [18] = {X = -4625, Y = 1110, Z = -24779}, --alt_FM
  [19] = {X = -4625, Y = 1110, Z = -25585}, --alt_FR
  maxPoints = 19
}
TelePoints = {
  [1] = {"f_warp_L", "SpecialPoint1", "f_warp_R", camX = -11597, camY = 1562, camZ = -24779},
  [2] = {"m_1L", "m_1U", "m_1R", camX = 0, camY = 0, camZ = 0},
  [3] = {"b_warp_L", "b_warp_m", "b_warp_R", camX = 1279, camY = 1562, camZ = -24779}
}
ArrowPoints = {  -- -7053   -6470  -6470
  [1] = {X = -5445, Y = 1113, Z = -24779, camX = -11597, camY = 1562, camZ = -24779, visual_axis = "n_X"},
  [2] = {X = -5445, Y = 1113, Z = -23963, camX = -11597, camY = 1562, camZ = -24779, visual_axis = "n_X"},
  [3] = {X = -5445, Y = 1113, Z = -25585, camX = -11597, camY = 1562, camZ = -24779, visual_axis = "n_X"}
}
function SpawnBomb(_ARG_0_, PointRef, isCutscene, seqPoints)
  local t = {}
  local WaitTime = 0
  local useSeq = "AttackPoints"
  if PointRef then
    if isCutscene then
	  if seqPoints then
	    useSeq = "CutscenePoints"
		WaitTime = seqPoints.wait or WaitTime
	  else
	    t.X = CutscenePoints.Attack[PointRef].X
	    t.Y = CutscenePoints.Attack[PointRef].Y
	    t.Z = CutscenePoints.Attack[PointRef].Z
	  end
	else
	  if seqPoints then
	    useSeq = "AttackPoints"
		WaitTime = seqPoints.wait or WaitTime
	  else
	    t.X = AttackPoints[PointRef].X
	    t.Y = AttackPoints[PointRef].Y
	    t.Z = AttackPoints[PointRef].Z
	  end
	end
  else
    local randomPoint = math.random(1, AttackPoints.maxPoints)
	t.X = AttackPoints[randomPoint].X
	t.Y = AttackPoints[randomPoint].Y
	t.Z = AttackPoints[randomPoint].Z
  end
  if seqPoints then
    local t = {}
	if useSeq == "AttackPoints" then
	  t = AttackPoints
	elseif useSeq == "CutscenePoints" then
	  t = CutscenePoints.Attack
	end
    for i = 1, seqPoints.points do
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "appear_visual", t[seqPoints[i]].X, t[seqPoints[i]].Y + 50, t[seqPoints[i]].Z)
	  WaitFixed(_ARG_0_, 0.25)
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "stained", 0, 0, 0)
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "Indicator", t[seqPoints[i]].X, t[seqPoints[i]].Y-90, t[seqPoints[i]].Z)
      ThirdIblisCreatePhysicsObject(_ARG_0_, "delay_Indicator", t[seqPoints[i]].X, t[seqPoints[i]].Y + 50, t[seqPoints[i]].Z)
	  WaitFixed(_ARG_0_, WaitTime)
	end
  else
    ThirdIblisCreatePhysicsObject(_ARG_0_, "appear_visual", t.X, t.Y + 50, t.Z)
    WaitFixed(_ARG_0_, 0.25)
	ThirdIblisCreatePhysicsObject(_ARG_0_, "stained", 0, 0, 0)
    ThirdIblisCreatePhysicsObject(_ARG_0_, "Indicator", t.X, t.Y-90, t.Z)
    ThirdIblisCreatePhysicsObject(_ARG_0_, "delay_Indicator", t.X, t.Y + 50, t.Z)
  end
end
function SpawnRingTrap(_ARG_0_, PointRef, seqPoints)
  local t = AttackPoints
  local WaitTime = 0
  if PointRef and not seqPoints then
    t.X = t[PointRef].X
	t.Y = t[PointRef].Y
	t.Z = t[PointRef].Z
  else
    if not seqPoints then
      local randomPoint = math.random(1, AttackPoints.maxPoints)
	  t.X = AttackPoints[randomPoint].X
	  t.Y = AttackPoints[randomPoint].Y
	  t.Z = AttackPoints[randomPoint].Z
	elseif seqPoints.random then
	  local randomPoint = math.random(1, seqPoints.points)
	  t.X = AttackPoints[seqPoints[randomPoint]].X
	  t.Y = AttackPoints[seqPoints[randomPoint]].Y
	  t.Z = AttackPoints[seqPoints[randomPoint]].Z
	end
  end
  if seqPoints and not seqPoints.random then
    WaitTime = seqPoints.wait or 0
    for i = 1, seqPoints.points do
	  local X, Y, Z = t[seqPoints[i]].X, t[seqPoints[i]].Y, t[seqPoints[i]].Z
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "i_Indicator", X, Y-90, Z)
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "i_Blast", X, Y, Z)
	  --WaitFixed(_ARG_0_, 0.5)
	  for ringTrap = 1, 10 do
	    ThirdIblisCreatePhysicsObject(_ARG_0_, "i_Sap", X, Y, Z)
	  end
	  WaitFixed(_ARG_0_, WaitTime)
	end
  else
    local X, Y, Z = t.X, t.Y, t.Z
	ThirdIblisCreatePhysicsObject(_ARG_0_, "i_Indicator", X, Y-90, Z)
	ThirdIblisCreatePhysicsObject(_ARG_0_, "i_Blast", X, Y, Z)
	--WaitFixed(_ARG_0_, 0.5)
	for ringTrap = 1, 10 do
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "i_Sap", X, Y, Z)
	end
  end
end
Enemy.firstmefiress_Rogue = {
  Phase = "shadow2",
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
    Enemy.firstmefiress_Rogue.MinAppearRadius = 5
    Enemy.firstmefiress_Rogue.MaxAppearRadius = 7.5
    Enemy.firstmefiress_Rogue.LodNear = 15
    Enemy.firstmefiress_Rogue.MoveSpeed = 10
    Enemy.firstmefiress_Rogue.DodgeSpeed = 0.5
    Enemy.firstmefiress_Rogue.ApproachSpeed = 9
    Enemy.firstmefiress_Rogue.EscapeSpeed = 9
    Enemy.firstmefiress_Rogue.CircularFlightSpeed = 25
    Enemy.firstmefiress_Rogue.DeltaSpeed = 0.5
    Enemy.firstmefiress_Rogue.MinSpringAppearHeight = 10.75
    Enemy.firstmefiress_Rogue.MaxSpringAppearHeight = 12.9
    Enemy.firstmefiress_Rogue.SpringSpeed = 5 --5
    Enemy.firstmefiress_Rogue.SpringG = 9.8 --Negative makes it heavier
    Enemy.firstmefiress_Rogue.SpringErrorRadius = 2 --Bigger number higher "fail" variation
    Enemy.firstmefiress_Rogue.SpringFailedTime = 0.25
    Enemy.firstmefiress_Rogue.HoldErrorAngle = 15
    Enemy.firstmefiress_Rogue.HoldSpace = 0.2 --Distance away from the player's body when latched on
    Enemy.firstmefiress_Rogue.MaxHoldUnits = 1 --5
    Enemy.firstmefiress_Rogue.HoldExplosionWaitTime = 2
    Enemy.firstmefiress_Rogue.MinAttackAppearHeight = 12
    Enemy.firstmefiress_Rogue.MaxAttackAppearHeight = 15
    Enemy.firstmefiress_Rogue.MaxAttackHomingHeight = 15
    Enemy.firstmefiress_Rogue.AttackSpeed = 7.5 --Initial dive speed?
    Enemy.firstmefiress_Rogue.AttackHomingSpeed = 30 --How quickly they track (pretty slow)
    Enemy.firstmefiress_Rogue.AttackTime = 5.0 --How long they will try to attack for.
    Enemy.firstmefiress_Rogue.AttackHomingTime = 2.5 --How long they will home for.
    Enemy.firstmefiress_Rogue.MinEncirclementHeight = 10.75
    Enemy.firstmefiress_Rogue.MaxEncirclementHeight = 12.9
    Enemy.firstmefiress_Rogue.MinEncirclementRadius = 8
    Enemy.firstmefiress_Rogue.MaxEncirclementRadius = 16
    Enemy.firstmefiress_Rogue.TargetLostDistance = 20
    Enemy.firstmefiress_Rogue.BlownSpeed = 12
    Enemy.firstmefiress_Rogue.SmashBlownSpeed = 12
    Enemy.firstmefiress_Rogue.BlownTime = 0.25
    Enemy.firstmefiress_Rogue.ParalysisTime = 5
    Enemy.firstmefiress_Rogue.DeathBallWaitTime = 5
    Enemy.firstmefiress_Rogue.DeathBallLifeTime = 10
    Enemy.firstmefiress_Rogue.DeathBallSpeed = 6
    Enemy.firstmefiress_Rogue.DeathBallHomingRate = 0.25
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  Phase1Parameters = function(_ARG_0_)
    Enemy.firstmefiress_Rogue.DeathBallWaitTime = 3
    Enemy.firstmefiress_Rogue.DeathBallLifeTime = 3.5
    Enemy.firstmefiress_Rogue.DeathBallSpeed = 12
    Enemy.firstmefiress_Rogue.DeathBallHomingRate = 0.5
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  Phase2Parameters = function(_ARG_0_)
    Enemy.firstmefiress_Rogue.DeathBallWaitTime = 1.5
    Enemy.firstmefiress_Rogue.DeathBallLifeTime = 3.5
    Enemy.firstmefiress_Rogue.DeathBallSpeed = 12
    Enemy.firstmefiress_Rogue.DeathBallHomingRate = 0.5
	Enemy.firstmefiress_Rogue.SpringSpeed = 15
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  Cutscene2Params = function(_ARG_0_)
    Enemy.firstmefiress_Rogue.DeathBallWaitTime = 1.5
    Enemy.firstmefiress_Rogue.DeathBallLifeTime = 0.1
    Enemy.firstmefiress_Rogue.DeathBallSpeed = 0
    Enemy.firstmefiress_Rogue.DeathBallHomingRate = 0.5
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  SwarmParameters = function(_ARG_0_)
    Enemy.firstmefiress_Rogue.DodgeSpeed = 0.4
    Enemy.firstmefiress_Rogue.ApproachSpeed = 6
    Enemy.firstmefiress_Rogue.EscapeSpeed = 6
    Enemy.firstmefiress_Rogue.MinEncirclementRadius = 8
    Enemy.firstmefiress_Rogue.MaxEncirclementRadius = 14
    Enemy.firstmefiress_Rogue.TargetLostDistance = 16
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  EscapeParameters = function(_ARG_0_)
    Enemy.firstmefiress_Rogue.DodgeSpeed = 0.3
    Enemy.firstmefiress_Rogue.ApproachSpeed = 5
    Enemy.firstmefiress_Rogue.EscapeSpeed = 10
    Enemy.firstmefiress_Rogue.MinEncirclementRadius = 10
    Enemy.firstmefiress_Rogue.MaxEncirclementRadius = 20
    Enemy.firstmefiress_Rogue.TargetLostDistance = 25
    FirstMefiress_UpdateParameters(_ARG_0_)
  end,
  Appear = function(_ARG_0_)
    FirstMefiress_Warp(_ARG_0_, -4322, 213, -24936, 2000)
	WaitFixed(_ARG_0_, 0.21)
    SetParameter(_ARG_0_, "FatalEvent", 0, 0.5)
    _UPVALUE0_ = 0
	CloneVal = 0
	CallMessage(_ARG_0_, "guard_on")
	myPhase = 0
	delayTime = 7.5
	platCheck = 1
	TrueGuard = true
	IsGlide = false
	hasAppeared = false
	TempVuln = false
	FreshPhase = true
	hasHint1 = false
	specialAttack = 0
	--FirstMefiress_Embody(_ARG_0_, 1)
	--FirstMefiress_Disembody(_ARG_0_)
    --math.randomseed(1)
    Enemy.firstmefiress_Rogue.InitParameters(_ARG_0_)
    --Enemy.firstmefiress_Rogue.SwarmParameters(_ARG_0_)
    --CallMessage(_ARG_0_, "guard_on")
    WaitFixed(_ARG_0_, 0.1)
  end,
  Search = function(_ARG_0_)
    SearchPlayer(_ARG_0_, 0)
  end,
  OnFind = function(_ARG_0_)
  end,
  HealthCheck = function(_ARG_0_)
    hp = GetHP(_ARG_0_)
	if hp >= 0.69 then
	  --CallChangeAction(_ARG_0_, "Action")
	elseif hp >= 0.36 then
	  CallChangeAction(_ARG_0_, "Phase2")
	else
	  CallChangeAction(_ARG_0_, "Phase3")
	end
  end,
  DelayPlayer = function(_ARG_0_)
    CallPlayerStop(_ARG_0_, delayTime)
  end,
  SetTempVuln = function(_ARG_0_)
    TempVuln = not TempVuln
  end,
  SetFreshPhase = function(_ARG_0_)
    FreshPhase = not FreshPhase
  end,
  Phase2Vulcan = function(_ARG_0_)
    if GetRandom(_ARG_0_) <= 0.25 and playerName == "sonic" then
	  CallHintMessage(_ARG_0_, "hint_all05_a11_sn")
	end
    for i = 1, 3 do
      local actionPoint = math.random(5,8)
	  actionPoint = AttackPoints[actionPoint]
	  FirstMefiress_Warp(_ARG_0_, actionPoint.X, actionPoint.Y + 400, actionPoint.Z, 30)
	  CallSetCamera(_ARG_0_, "main", 1, 700, 0, 150, 0, -100, 0, 0.5, 100)
	  WaitFixed(_ARG_0_, 0.75)
	  ShotVulcan(_ARG_0_, "DeathVulcan", 1.5)
	  ActionRotate(_ARG_0_, 1, 0.5)
	  WaitFixed(_ARG_0_, 0.5)
	  CallMessage(_ARG_0_, "guard_on")
	  WaitAnimation(_ARG_0_, "command")
	  CallMessage(_ARG_0_, "guard_off")
	  DieExplosion(_ARG_0_, "DarkBombLL")
	  WaitFixed(_ARG_0_, 0.75)
	end
	CallResetCamera(_ARG_0_, "main")
  end,
  CarpetBomb = function(_ARG_0_)
    ---3947.1  1038  -24992.9
	FirstMefiress_SetPointGroup(_ARG_0_, "SpecialPoint1")
	FirstMefiress_RandomWarp(_ARG_0_, 200)
	CallPointCamera(_ARG_0_, "main", 0, 800, 0, 300, 0, -150, 0, 0.1, -11597, 1562, -24779)
	WaitFixed(_ARG_0_, 0.4)
	CallResetCamera(_ARG_0_, "main")
    CallPointCamera(_ARG_0_, "main", 0, -6500, 0, 6200, -6000, -150, 0, 0.15, -3900, 1562, -24779)
	WaitFixed(_ARG_0_, 0.5)
	CallPointCamera(_ARG_0_, "main2", 0, -6500, 0, 6200, -6000, -150, 0, 1000.15, -3900, 1562, -24779)
	CallResetCamera(_ARG_0_, "main")
	WaitFixed(_ARG_0_, 2)
	--9-14, 5, 6, 15, 3, 4, 15    10    13
	--SpawnBomb(_ARG_0_, 1, false, {5, 6, 3, 4, 16, 9, 11, 12, 14, 13, 10, points = 11, wait = 0.15})
	SpawnBomb(_ARG_0_, 1, false, {5, 6, 3, 4, 16, points = 5, wait = 0.15})
	SpawnRingTrap(_ARG_0_, 0, {15, 10, 3, 13, points = 4, wait = 0.25})
	SpawnBomb(_ARG_0_, 1, false, {9, 11, 12, 14, 10, points = 5, wait = 0.15})
	--for i = 1, 12 do
	  --SpawnRingTrap(_ARG_0_)
	  --SpawnBomb(_ARG_0_)
	--end
	WaitFixed(_ARG_0_, 5)
	CallResetCamera(_ARG_0_, "main2")
	CallPushState(_ARG_0_, "LightArrow")
  end,
  Gun = function(_ARG_0_)
	DieExplosion(_ARG_0_, "TestMAB")
	ThirdIblisCreatePhysicsObject(_ARG_0_, "Arrow", -4215, 1263, -24940)
	WaitFixed(_ARG_0_, 2)
	ShotVulcan(_ARG_0_, "LaserSolaris_t", 2)
	ActionRotate(_ARG_0_, 1, 1)
  end,
  Special3 = function(_ARG_0_)
    TrueGuard = true
	CallMessage(_ARG_0_, "guard_on")
    --CallMoveTargetPos(_ARG_0_, -3947.1, 1038, -24992.9, 4)
	CallMoveTargetPos(_ARG_0_, -2812, 1010, -24779, 4)
	FirstMefiress_Warp(_ARG_0_, -5245, 1213, -24779, 60)
	CallHintMessage(_ARG_0_, "hint_bos05_e04_mf")
	--ThirdIblisCreatePhysicsObject(_ARG_0_, "DarkWall", -6066, 2931, -24801)
	delayTime = 4.5
	WaitFixed(_ARG_0_, 3.9)
	CallPushState(_ARG_0_, "DelayPlayer")
	--ThirdIblisCreatePhysicsObject(_ARG_0_, "DarkWall", -6066, 2931, -24801)
	--CallPushState(_ARG_0_, "CarpetBomb")
	CallPointCamera(_ARG_0_, "main", 0, 1800, 0, 300, 0, -150, 0, 0.5, -9288, 1900, -20044)
	ThirdIblisCreatePhysicsObject(_ARG_0_, "Warp_Break", 0, 0, 0)
	local aP = ArrowPoints[1]
	local X, Y, Z = aP.X-90, aP.Y+50, aP.Z
	ThirdIblisCreatePhysicsObject(_ARG_0_, "Arrow", X, Y+100, Z)
	WaitRotate(_ARG_0_, 2)
	--ThirdIblisCreatePhysicsObject(_ARG_0_, "DarkWall", -6066, 2931, -24801)
	ShotVulcan(_ARG_0_, "LaserSolaris_t", 2)
	ActionRotate(_ARG_0_, 1, 1)
	ThirdIblisCreatePhysicsObject(_ARG_0_, "tpj_obj_board", 0, 0, 0)
	--ThirdIblisCreatePhysicsObject(_ARG_0_, "DarkWall", -6066, 2931, -24801)
	CallResetCamera(_ARG_0_, "main")
	WaitFixed(_ARG_0_, 1)
	if playerName == "sonic" then
	  CallHintMessage(_ARG_0_, "hint_bos08_e00_sn")
	end
  end, --1931
  LightArrow = function(_ARG_0_)
    if GetRandom(_ARG_0_) <= 0.25 then
	  CallHintMessage(_ARG_0_, "EyeHint")
	end
    ThirdIblisCreatePhysicsObject(_ARG_0_, "DarkWall", -6066, 2931, -24801)
	CallPushState(_ARG_0_, "ObjCheck")
    local aP = math.random(1,3)
	aP = ArrowPoints[aP]
	local X, Y, Z = aP.X, aP.Y + 0, aP.Z
	local vfx_X, vfx_Y, vfx_Z = X, Y, Z
	local camX, camY, camZ, axis = aP.camX, aP.camY, aP.camZ, aP.visual_axis
	local visual_sub_table = {
	  ["n_X"] = -90,
	  ["X"] = 90,
	  ["n_Z"] = -90,
	  ["Z"] = 90
	}
	if axis == ("n_X" or "X") then
	  vfx_X = vfx_X + visual_sub_table[axis]
	elseif aP.axis == ("n_Z" or "Z") then
	  vfx_Z = vfx_Z + visual_sub_table[axis]
	end
	FirstMefiress_Warp(_ARG_0_, X, Y, Z, 30)
	CallMessage(_ARG_0_, "guard_on")
	CallPushState(_ARG_0_, "ObjCheck")
	WaitFixed(_ARG_0_, 0.1)
	CallPointCamera(_ARG_0_, "main", 0, 800, 0, 300, 0, -150, 0, 0.5, camX, camY, camZ)
	ThirdIblisCreatePhysicsObject(_ARG_0_, "Arrow", vfx_X, vfx_Y + 50, vfx_Z)
	--ThirdIblisCreatePhysicsObject(_ARG_0_, "stained", 0, 0, 0)
	WaitFixed(_ARG_0_, 2)
	CallPushState(_ARG_0_, "ObjCheck")
	ShotVulcan(_ARG_0_, "LaserSolaris_t", 2)
	ActionRotate(_ARG_0_, 1, 1)
	CallPushState(_ARG_0_, "ObjCheck")
	--WaitFixed(_ARG_0_, 2)
	--CallResetCamera(_ARG_0_, "main")
	--WaitFixed(_ARG_0_, 20)
	FirstMefiress_Warp(_ARG_0_, -6470, 1113, -24779, 30)
	CallMessage(_ARG_0_, "guard_on")
	ThirdIblisCreatePhysicsObject(_ARG_0_, "DarkWall", -6066, 2931, -24801)
	CallPushState(_ARG_0_, "ObjCheck")
	for i = 1, 3 do
	  SpawnRingTrap(_ARG_0_, 0, {4, 5, 6, 9, 10, 11, 15, 16, 17, 18, 19, points = 11, random = true})
	end
	WaitFixed(_ARG_0_, 0.5)
  end,
  TeleportAttack = function(_ARG_0_)
    CallMessage(_ARG_0_, "guard_on")
	if FreshPhase then
	  CallPushState(_ARG_0_, "SetFreshPhase")
	end
	TrueGuard = true
    local rng = GetRandom(_ARG_0_)
	local direction
	if rng <= 0.33 then
	  direction = 1
	elseif rng <= 0.66 then
	  direction = 2
	else
	  direction = 3
	end
	local p1, p2, p3 = math.random(1,3), math.random(1,3), math.random(1,3)
	while p1 == p2 or p1 == p3 or p2 == p3 do
	  p1 = math.random(1,3)
	  p2 = math.random(1,3)
	  p3 = math.random(1,3)
	end
	local pointTable = {p1, p2, p3}
	local X, Y, Z = TelePoints[direction].camX, TelePoints[direction].camY, TelePoints[direction].camZ
	local finalPoint = TelePoints[direction][math.random(1,3)]
	--CallMessage(_ARG_0_, "guard_on")
    FirstMefiress_Disembody(_ARG_0_)
	CallResetCamera(_ARG_0_, "main")
	CallPointCamera(_ARG_0_, "main", 0, 1800, 0, 300, 0, -150, 0, 1, X, Y, Z)
	for i = 1, 3 do
	  FirstMefiress_SetPointGroup(_ARG_0_, TelePoints[direction][pointTable[i]])
	  FirstMefiress_RandomWarp(_ARG_0_, 2000)
	  CallMessage(_ARG_0_, "guard_on")
	  WaitFixed(_ARG_0_, 0.75)
	  if TelePoints[direction][pointTable[i]] == finalPoint then
	    finalPoint = pointTable[i]
	    DieExplosion(_ARG_0_, "outstrain")
		DieExplosion(_ARG_0_, "outstrain")
	  else
	    DieExplosion(_ARG_0_, "instrain")
		DieExplosion(_ARG_0_, "instrain")
	  end
	  PlaySeEnemy(_ARG_0_, "EnemyMonster", "chaos_ImpactL")
	end
	WaitFixed(_ARG_0_, 0.75)
	for i = 1, 3 do
	  if pointTable[i] ~= finalPoint then
	    FirstMefiress_SetPointGroup(_ARG_0_, TelePoints[direction][pointTable[i]])
	    FirstMefiress_RandomWarp(_ARG_0_, 6000)
	    FirstMefiress_DoCommand(_ARG_0_, "illusion")
	  end
	end
	FirstMefiress_SetPointGroup(_ARG_0_, TelePoints[direction][finalPoint])
	FirstMefiress_RandomWarp(_ARG_0_, 2000)
	CallResetCamera(_ARG_0_, "main")
	FirstMefiress_Embody(_ARG_0_)
	CallPushState(_ARG_0_, "GuardOff")
	CallPushState(_ARG_0_, "SetTempVuln")
	WaitFixed(_ARG_0_, 0.5)
	CallPushState(_ARG_0_, "SetTempVuln")
	FirstMefiress_DeathBall(_ARG_0_, 3)
	WaitFixed(_ARG_0_, 1)
	--FirstMefiress_DoCommand(_ARG_0_, "spring", 20, GetRandomAppearRadius(_ARG_0_, Enemy.firstmefiress_Rogue.MinAppearRadius, Enemy.firstmefiress_Rogue.MaxAppearRadius), 2.5, 0.5, 0)
	--WaitFixed(_ARG_0_, 1)
  end,
  Action = function(_ARG_0_)
    --if true then specialAttack = 2 CallChangeAction(_ARG_0_, "Phase3") return end
	--if true then CallMessage(_ARG_0_, "guard_off")  CallChangeAction(_ARG_0_, "Phase3") return end --ThirdIblisCreatePhysicsObject(_ARG_0_, "Box2", -3112, 1351, -24779)
    --print("UNIT: " .. tostring(GetParameter(_ARG_0_, "NumUnit")))
	--print("KILLED: " .. tostring(GetParameter(_ARG_0_, "NumKilledUnit")))
	--print("KYO: " .. tostring(GetParameter(_ARG_0_, "NumKyozoress")))
	if not hasAppeared then
	  hasAppeared = true
	  playerName = GetTargetPlayerName(_ARG_0_)
	  CallSetCamera(_ARG_0_, "main", 1, -1800, 0, 300, 0, -100, 0, 1.25, 100)
	  FirstMefiress_Warp(_ARG_0_, -4322, 1203, -24936, 5)
	  CallPlayerStop(_ARG_0_, 5)
	  --DieExplosion(_ARG_0_, "DarkBombLL")
	  WaitFixed(_ARG_0_, 1)
	  if playerName == "sonic" then
	    CallHintMessage(_ARG_0_, "hint_bos04_e01_mf")
	  else
	    CallHintMessage(_ARG_0_, "hint_bos04_e12_mf")
	  end
	  WaitAnimation(_ARG_0_, "shwait")
	  CallResetCamera(_ARG_0_, "main")
	  return
	end
	if GetParameter(_ARG_0_, "NumKilledUnit") <= 35 then --<= 54
	  if GetParameter(_ARG_0_, "NumKyozoress") == 0 then
	    CallPointCamera(_ARG_0_, "main", 0, 1800, 10, 300, 10, -150, 0, 1, 0, 0, 0)
	    CallMessage(_ARG_0_, "guard_on")
		TrueGuard = true
	    FirstMefiress_SetPointGroup(_ARG_0_, "KyoF")
        FirstMefiress_DoCommand(_ARG_0_, "summon", 0)
		if GetParameter(_ARG_0_, "NumKilledUnit") < 18 then
	      FirstMefiress_SetPointGroup(_ARG_0_, "KyoB")
          FirstMefiress_DoCommand(_ARG_0_, "summon", 0)
		end
		if not hasHint1 then
		  hasHint1 = true
		  WaitFixed(_ARG_0_, 1.5)
		  if playerName == "sonic" then
		    CallHintMessage(_ARG_0_, "hint_bos07_e00_sn")
		  end
		end
		--CallPushState(_ARG_0_, "GuardOff")
	  end
	  CloneVal = 0
	  CallMessage(_ARG_0_, "guard_on")
	  TrueGuard = true
	  FirstMefiress_SetPointGroup(_ARG_0_, "m_1L")
	  CallPushState(_ARG_0_, "KyoAttacks")
	  FirstMefiress_SetPointGroup(_ARG_0_, "m_1R")
	  CallPushState(_ARG_0_, "KyoAttacks")
	  FirstMefiress_SetPointGroup(_ARG_0_, "m_1U")
	  CallPushState(_ARG_0_, "KyoAttacks")
	  return
	end
	myPhase = 1
	CallResetCamera(_ARG_0_, "main")
	if specialAttack == 0 then
	  specialAttack = 1
	  CloneVal = 0
	  CallPushState(_ARG_0_, "Special1")
	  CallPushState(_ARG_0_, "GuardOff")
	end
	CallResetCamera(_ARG_0_, "fix_1")
	CallResetCamera(_ARG_0_, "fix_2")
	CallPushState(_ARG_0_, "GuardCheck")
	WaitFixed(_ARG_0_, 1)
	FirstMefiress_SetPointGroup(_ARG_0_, "AtkPoints")
	FirstMefiress_RandomWarp(_ARG_0_, 30)
	ShotVulcan(_ARG_0_, "DeathVulcan", 1.5)
	ActionRotate(_ARG_0_, 1, 0.5)
	MoveHeight(_ARG_0_, 250, false)
	FirstMefiress_DoCommand(_ARG_0_, "illusion")
	CallPushState(_ARG_0_, "GuardCheck")
	CloneVal = CloneVal + 1
	WaitFixed(_ARG_0_, 0.5)
	CallPushState(_ARG_0_, "ChargeOrShadow")
	if CloneVal >= 3 then
	  CloneVal = 0
	  Enemy.firstmefiress_Rogue.Phase1Parameters(_ARG_0_)
	  MoveHeight(_ARG_0_, 250, false)
	  FirstMefiress_DeathBall(_ARG_0_)
	end
	SpawnBomb(_ARG_0_)
	CallPushState(_ARG_0_, "GuardCheck")
  end,
  GuardCheck = function(_ARG_0_)
    if GetParameter(_ARG_0_, "NumUnit") >= 3 then
	  CallMessage(_ARG_0_, "guard_on")
	  if GetRandom(_ARG_0_) <= 0.25 then
	    CallHintMessage(_ARG_0_, "ShieldHint")
	  end
	  --TrueGuard = true
	else
	  CallPushState(_ARG_0_, "GuardOff")
	end
  end,
  ChargeOrShadow = function(_ARG_0_)
    local distance = GetDistance(_ARG_0_)
    if distance <= 500 then
	  CallMessage(_ARG_0_, "guard_on")
	  --TrueGuard = true
	  if GetRandom(_ARG_0_) <= 0.5 then
	    CallHintMessage(_ARG_0_, "hint_bos04_e08_mf")
	  end
      FirstMefiress_DoCommand(_ARG_0_, "attack", 5, 5, 0.35, 1)
	else
	  CallMessage(_ARG_0_, "guard_on")
	  MoveHeight(_ARG_0_, 0, true)
	  if distance >= 1000 then
	    CallSetCamera(_ARG_0_, "main", 1, 700, 0, 150, 0, -100, 0, 0.5, 100)
	  end
	  TurnTarget(_ARG_0_)
	  if distance >= 1000 then
	    CallSetCamera(_ARG_0_, "fix_1", 1, 1800, 0, 150, 0, -100, 0, 100, 100) --Slower camera that gets locked in place
	    CallSetCamera(_ARG_0_, "fix_2", 1, 1800, 0, 150, 0, -100, 0, 0.1, 100) --Snaps the camera to the correct position
	  end
	  CallResetCamera(_ARG_0_, "main")
	  WaitFixed(_ARG_0_, 0.25)
	  CallResetCamera(_ARG_0_, "fix_2")
	  if GetRandom(_ARG_0_) <= 0.5 then
	    CallHintMessage(_ARG_0_, "hint_bos04_e05_mf")
	  elseif GetRandom(_ARG_0_) <= 0.6 then
	    if playerName == "sonic" then
	      CallHintMessage(_ARG_0_, "hint_all05_a10_sn")
		end
	  end
	  CallPushState(_ARG_0_, "PreGlide") --Should fix an issue related to bonking
	  ChargeAttack(_ARG_0_, math.max(3500, GetDistance(_ARG_0_) + 1000), 6000, 0.5)
	  CallPushState(_ARG_0_, "GuardCheck")
	  CallResetCamera(_ARG_0_, "fix_1")
	end
  end,
  Phase2 = function(_ARG_0_)
    Enemy.firstmefiress_Rogue.Phase2Parameters(_ARG_0_)
    myPhase = 2
    if specialAttack == 1 then
	  specialAttack = 2
	  CloneVal = 0
	  CallResetCamera(_ARG_0_, "main")
	  CallResetCamera(_ARG_0_, "fix_1")
	  CallResetCamera(_ARG_0_, "fix_2")
	  CallPushState(_ARG_0_, "Special2")
	  CallPushState(_ARG_0_, "GuardOff")
	  return
	end
	if FreshPhase then
	  CallPushState(_ARG_0_, "TeleportAttack")
	end
	FirstMefiress_Disembody(_ARG_0_)
	FirstMefiress_DoCommand(_ARG_0_, "spring", 20, GetRandomAppearRadius(_ARG_0_, Enemy.firstmefiress_Rogue.MinAppearRadius, Enemy.firstmefiress_Rogue.MaxAppearRadius), 2.5, 0.5, 0)
    WaitFixed(_ARG_0_, 3)
	FirstMefiress_Embody(_ARG_0_)
	--CallPushState(_ARG_0_, "TeleportAttack")
	CallPushState(_ARG_0_, "GuardCheck")
	CallPushState(_ARG_0_, "Phase2Vulcan")
	CallPushState(_ARG_0_, "GuardCheck")
	CallPushState(_ARG_0_, "SetFreshPhase")
  end,
  Phase3 = function(_ARG_0_)
    myPhase = 3
	if specialAttack <= 2 then
	  TrueGuard = true
	  specialAttack = 3
	  CloneVal = 0
	  CallResetCamera(_ARG_0_, "main")
	  CallPushState(_ARG_0_, "Special3")
	  CallPushState(_ARG_0_, "GuardOff")
	  return
	end
	if platCheck == 5 then
	  if hasHint1 then
	    hasHint1 = false
		if playerName == "sonic" then
		  CallHintMessage(_ARG_0_, "hint_bos07_e03_sn")
		end
	  end
	  CallMessage(_ARG_0_, "guard_off")
	  CallResetCamera(_ARG_0_, "main")
	  TrueGuard = false
	  FirstMefiress_Tired(_ARG_0_, 5)
	  return
	end
	CallPushState(_ARG_0_, "LightArrow")
	CallPushState(_ARG_0_, "ObjCheck")
    WaitFixed(_ARG_0_, 1)
  end,
  KyoAttacks = function(_ARG_0_)
    if GetParameter(_ARG_0_, "NumKyozoress") == 0 then
	  CallInterruptState(_ARG_0_, "Action")
	  return
	end
	FirstMefiress_RandomWarp(_ARG_0_, 30)
	CloneVal = CloneVal + 1
	if CloneVal >= 3 then
	  TurnTarget(_ARG_0_)
	  FirstMefiress_DeathBall(_ARG_0_)
	else
      ShotVulcan(_ARG_0_, "DeathVulcan", 0.75)
	  ActionRotate(_ARG_0_, 3, 3)
	end
	if CloneVal < 3 then
	  FirstMefiress_DoCommand(_ARG_0_, "illusion")
	  WaitFixed(_ARG_0_, 1)
	end
	MoveHeight(_ARG_0_, 0, true)
	TurnTarget(_ARG_0_)
	ChargeAttack(_ARG_0_, 3000, 6000, 0.5)
	CallMessage(_ARG_0_, "guard_on") --Guard gets disabled somewhere. Might be from Charge Attack. This is for safety.
	MoveHeight(_ARG_0_, 250, false)
	TurnTarget(_ARG_0_)
	--MoveFront(_ARG_0_, 500, 0.5, 0.5, 0, 5)
	CallPushState(_ARG_0_, "PreGlide") --Guard needs to be disabled so that Meph can bonk if the glide hits a wall. PostGlide isn't needed.
	GlidingAttack(_ARG_0_, 2500)
	CallMessage(_ARG_0_, "guard_on")
  end,
  PreGlide = function(_ARG_0_)
    CallMessage(_ARG_0_, "guard_off")
	IsGlide = true
  end,
  PostGlide = function(_ARG_0_)
    CallMessage(_ARG_0_, "guard_on")
	IsGlide = false
  end,
  Special1 = function(_ARG_0_)
	CallMoveTargetPos(_ARG_0_, CutscenePoints[1].X, CutscenePoints[1].Y, CutscenePoints[1].Z, 2)
	WaitFixed(_ARG_0_, 2)
	CallResetCamera(_ARG_0_, "main")
	CallSetCamera(_ARG_0_, "main", 0, -1800, 0, 300, 0, -150, 0, 0.5, 0)
	CallPushState(_ARG_0_, "DelayPlayer")
	FirstMefiress_SetPointGroup(_ARG_0_, "SpecialPoint1")
	FirstMefiress_RandomWarp(_ARG_0_, 60)
	TurnTarget(_ARG_0_)
	--CallResetCamera(_ARG_0_, "main")
	--CallSetCamera(_ARG_0_, "main", 0, -1800, 0, 300, 0, -150, 0, 0.5, 0)
	WaitAnimation(_ARG_0_, "smile")
	CallSetCamera(_ARG_0_, "main2", 0, -100, 0, 300, 0, -150, 0, 0.25, 0)
	WaitFixed(_ARG_0_, 0.5)
	--ThirdIblisCreatePhysicsObject(_ARG_0_, "appear_visual", -5418, 1110, -23689)
	SpawnBomb(_ARG_0_, 1, true, {1, 2, points = 2})
	--SpawnBomb(_ARG_0_, 2, true)
	WaitFixed(_ARG_0_, 3)
	CallResetCamera(_ARG_0_, "main")
	CallResetCamera(_ARG_0_, "main2")
	CallPointCamera(_ARG_0_, "post", 0, 1000, 0, 300, 0, -150, 0, 0.15, -6470, 1562, -24779)
	WaitFixed(_ARG_0_, 0.25)
	CallResetCamera(_ARG_0_, "post")
	SpawnBomb(_ARG_0_, 2)
  end,
  Special2 = function(_ARG_0_)
    delayTime = 11.5
    local p = {CutscenePoints.Teleport[2], CutscenePoints.Teleport[1], CutscenePoints.Teleport[3]}
	Enemy.firstmefiress_Rogue.Cutscene2Params(_ARG_0_)
    CallMoveTargetPos(_ARG_0_, CutscenePoints[1].X, CutscenePoints[1].Y, CutscenePoints[1].Z, 2)
	WaitFixed(_ARG_0_, 2.5)
	CallPushState(_ARG_0_, "DelayPlayer")
	CallPointCamera(_ARG_0_, "main", 0, -1800, 0, 300, 0, -150, 0, 1, CutscenePoints.Teleport.Camera.X, CutscenePoints.Teleport.Camera.Y, CutscenePoints.Teleport.Camera.Z)
	FirstMefiress_Warp(_ARG_0_, p[1].X, p[1].Y, p[1].Z, 30)
	CallHintMessage(_ARG_0_, "hint_bos05_e06_mf")
	FirstMefiress_Disembody(_ARG_0_)
	for i = 1, 3 do
	  local X, Y, Z = p[i].X, p[i].Y, p[i].Z
	  FirstMefiress_Warp(_ARG_0_, X, Y, Z, 2000)
	  WaitFixed(_ARG_0_, 0.75)
	  if i == 1 then
	    DieExplosion(_ARG_0_, "outstrain")
		DieExplosion(_ARG_0_, "outstrain")
	  else
	    DieExplosion(_ARG_0_, "instrain")
		DieExplosion(_ARG_0_, "instrain")
	  end
	  PlaySeEnemy(_ARG_0_, "EnemyMonster", "chaos_ImpactL")
	end
	WaitFixed(_ARG_0_, 0.75)
	for i = 2, 3 do
	  local X, Y, Z = p[i].X, p[i].Y, p[i].Z
	  FirstMefiress_Warp(_ARG_0_, X, Y, Z, 6000)
	  FirstMefiress_DoCommand(_ARG_0_, "illusion")
	end
	FirstMefiress_Warp(_ARG_0_, p[1].X, p[1].Y, p[1].Z, 2000)
	FirstMefiress_Embody(_ARG_0_)
	WaitAnimation(_ARG_0_, "shwait")
	FirstMefiress_DeathBall(_ARG_0_)
	WaitFixed(_ARG_0_, 2)
	CallResetCamera(_ARG_0_, "main")
	Enemy.firstmefiress_Rogue.Phase2Parameters(_ARG_0_)
  end,
  GuardOff = function(_ARG_0_)
    TrueGuard = false
	CallMessage(_ARG_0_, "guard_off")
  end,
  ShadowPush = function(_ARG_0_)
    CallMessage(_ARG_0_, "guard_on")
	--TrueGuard = true
    FirstMefiress_DoCommand(_ARG_0_, "attack", 10, 5, 0.35, 1)
	--CallPushState(_ARG_0_, "GuardOff")
  end,
  OnBeginTargetBoost = function(_ARG_0_)
    --FirstMefiress_Disembody(_ARG_0_)
	--[[FirstMefiress_Disembody(_ARG_0_)
	DieExplosion(_ARG_0_, "instrain")
	PlaySeEnemy(_ARG_0_, "EnemyMonster", "chaos_ImpactL")
	--SecondMefiress_Darkin(_ARG_0_, 9, 9.8 * 4.5, 3)
	FirstMefiress_DoCommand(_ARG_0_, "attack", 30, 5, 0.5, 1)
	DieExplosion(_ARG_0_, "instrain")
	PlaySeEnemy(_ARG_0_, "EnemyMonster", "chaos_ImpactL")
	PlaySeEnemy(_ARG_0_, "Mefires01", "peel")
	FirstMefiress_Embody(_ARG_0_, 1)
	WaitFixed(_ARG_0_, 5)
	--WaitFixed(_ARG_0_, 1)
	TurnTarget(_ARG_0_)]]
  end,
  OnEndTargetBoost = function(_ARG_0_)
  end,
  OnGuardBreak = function(_ARG_0_)
    if not TrueGuard then
	  CallMessage(_ARG_0_, "guard_off")
      PlaySeEnemy(_ARG_0_, "EnemyMonster", "monster_guardbreak")
	  DamageKnockBack(_ARG_0_)
	  if myPhase == 2 then
	    DamageKnockBack(_ARG_0_) --This doesn't actually play the animation twice, but it does delay him slightly without re-enabling an OnDamage call.
	  end
	  CallPushState(_ARG_0_, "GuardCheck")
	  --CallPushState(_ARG_0_, "HealthCheck")
	  CallResetCamera(_ARG_0_, "fix_1")
	  CallResetCamera(_ARG_0_, "fix_2")
	end
  end,
  OnDamage = function(_ARG_0_)
	hp = GetHP(_ARG_0_)
	if hp >= 0.69 then
	  --CallChangeAction(_ARG_0_, "Action")
	elseif hp >= 0.36 and myPhase ~= 2 then
	  CallChangeAction(_ARG_0_, "Phase2")
	elseif hp < 0.36 and myPhase ~= 3 then
	  CallChangeAction(_ARG_0_, "Phase3")
	end
	if TempVuln then
	  TempVuln = false
	  TrueGuard = false
	  CallMessage(_ARG_0_, "guard_on")
	  DamageKnockBack(_ARG_0_)
	end
	_UPVALUE0_ = _UPVALUE0_ + 1
	if _UPVALUE0_ >= 3 then
	  _UPVALUE0_ = 0
	  --CallInterruptState(_ARG_0_, "ShadowPush")
	end
	DamageCall(_ARG_0_, true)
  end,
  OnSmash = function(_ARG_0_)
    DamageCall(_ARG_0_, true)
  end,
  OnFatal = function(_ARG_0_)
    if GetParameter(_ARG_0_, "FatalEventId") == 5 then
      CallMessage(_ARG_0_, "guard_on")
      WaitFixed(_ARG_0_, 1)
      CallMessage(_ARG_0_, "guard_off")
      CallSetCamera(_ARG_0_, "main", 1, 700, 0, 150, 0, -100, 0, 0.5, 100)
      CallHintMessage(_ARG_0_, "hint_bos04_e10_mf", false)
      FirstMefiress_DeathBall(_ARG_0_)
      CallResetCamera(_ARG_0_, "main")
      WaitFixed(_ARG_0_, 10)
    end
    --CallMessage(_ARG_0_, "guard_on")
  end,
  OnStun = function(_ARG_0_)
    --CallResetCamera(_ARG_0_, "main")
	--CallMessage(_ARG_0_, "guard_on")
	if IsGlide then
	  CallMessage(_ARG_0_, "guard_on")
	  IsGlide = false
	end
	if _UPVALUE0_ < 1 then
	  _UPVALUE0_ = _UPVALUE0_ + 1
	  DamageKnockBack(_ARG_0_)
	else
	  DamageKnockBack(_ARG_0_)
    end
	--CallMessage(_ARG_0_, "guard_on")
  end,
  OnDeathBallCancel = function(_ARG_0_)
  end,
  CreateTest = function(_ARG_0_)
   ThirdIblisCreatePhysicsObject(_ARG_0_, "WoodBox", -14993, -205, 14846)
   end,
  ObjCheck = function(_ARG_0_)
    local plat1, plat2, plat3, plat4 = CheckGroupMemberExist(_ARG_0_, "Warp_b2"), CheckGroupMemberExist(_ARG_0_, "Warp_b3"), CheckGroupMemberExist(_ARG_0_, "Warp_b4"), CheckGroupMemberExist(_ARG_0_, "Warp_b5")
    if not plat1 and platCheck == 1 then
	  platCheck = 2
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "tpj_obj_board", 0, 0, 0)
    elseif not plat2 and platCheck == 2 then
	  platCheck = 3
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "tpj_obj_board", 0, 0, 0)
    elseif not plat3 and platCheck == 3 then
	  platCheck = 4
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "tpj_obj_board", 0, 0, 0)
    elseif not plat4 and platCheck == 4 then
	  platCheck = 5
	  ThirdIblisCreatePhysicsObject(_ARG_0_, "tpj_obj_board", 0, 0, 0)
    end
  end,
  OnDead = function(_ARG_0_)
    if playerName == "sonic" then
      CallHintMessage(_ARG_0_, "hint_bos09_e08_sn")
	end
	DieExplosion(_ARG_0_, "DieChaosLarge")
	FirstMefiress_Warp(_ARG_0_, 0, 0, 0, 2000)
	WaitFixed(_ARG_0_, 2)
	CallMessage(_ARG_0_, "dead")
    WaitFixed(_ARG_0_, 9999)
  end
}