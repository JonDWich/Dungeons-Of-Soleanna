--$ MAIN MISSION INSTANCE SCRIPT $--

g_mission_information = {
  mission_string = "msg_act_rogue",
  mission_area = "rogue/kdv",
  mission_terrain = "stage/boss/solaris_last/",
  mission_set_default = "placement/rogue/set_base.XML",
  mission_event_start = "",
  mission_event_end = "",
  mission_text = "text/msg_twn_sonic.mst",
  mission_is_battle = true
}

g_result_wvo = {
  id = 4,
  stagename = "TOWN",
  timebonus_base = 47000,
  timebonus_rate = 40,
  ringbonus_rate = 100,
  rank_s = 50000,
  rank_a = 45000,
  rank_b = 25000,
  rank_c = 5000,
  rank_d = 0,
  ringbonus_s = 3000,
  ringbonus_a = 2000,
  ringbonus_b = 1000,
  ringbonus_c = 800,
  ringbonus_d = 500,
  finish = "result_wvo_end"
}

script.reload("scripts/mission/objects/ObjTemplate.lua")

hasInit = true
currentRoom = 0
currentDoor = ""
hintListener = false
KeyHints = {
  BlueTri = "go",
  RedTri = "timesup",
  GreenTri = "true", --Waiting for new cast
  BlueSh = "finish",
  RedSh = "success",
  GreenSh = "goal",
  BlueCr = "miss",
  RedCr = "newrecord",
  GreenCr = "fail" --Doesn't appear. Using this for the blackout
}

KeyAddEvents = {
  add_bCrKey = "BlueCrescent",
  add_bTriKey = "BlueTriangle",
  add_bShKey = "BlueShield",
  add_rCrKey = "RedCrescent",
  add_rTriKey = "RedTriangle",
  add_rShKey = "RedShield",
  add_grCrKey = "GreenCrescent",
  add_grTriKey = "GreenTriangle",
  add_grShKey = "GreenShield"
}

KeySubEvents = {
  BlueCrescent = true,
  BlueTriangle = true,
  BlueShield = true,
  RedCrescent = true,
  RedTriangle = true,
  RedShield = true,
  GreenCrescent = true,
  GreenTriangle = true,
  GreenShield = true
}

ResetUnlocks = {
  13, 14, 15, 16, 17, 18, 6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6013, 6014, 6015, 6016, 6017, 6018, 6019, 6020, count = 25
}
attackLevel, skillLevel = 1, 1
expPoints = 0
expReqs = {
  attack = {
    [1] = {exp = 3, message = "UnlockPele"}, --Exp needed to attain the next level from the current level
	[2] = {exp = 6, message = "UnlockItem"},
	[3] = {exp = "max", message = "AttackMax"}
  },
  skill = {
    [1] = {exp = 3, message = "UnlockBound", flag = 6002},
	[2] = {exp = 6, message = "UnlockSlide", flag = 6001},
	[3] = {exp = "max", message = "SkillMax"}
  }
}

g_message_setuped = ""
g_message_icon = 0
g_name_setuped = ""
roomCheck = {in_room1 = 1, in_room2 = 2, in_room3 = 3, in_room4 = 4, in_room5 = 5, in_room6 = 6, in_room7 = 7, in_room8 = 8, in_room9 = 9}
script.reload("scripts/mission/puzzles/puzzles.lua")
InConvo = false
doOpen = false

function on_hint(_ARG_0_, hint)
  --printf("HINT RECEIVED: " .. hint)
  if on_object_grab(_ARG_0_, hint) then
    return
  end
  if hint == "BeginLoop" then
    g_message_setuped = ""
	puzzle_init(_ARG_0_)
    --MissionText(_ARG_0_, "missioncompleted", "LoopIt")
  Rooms = {
  [1] = {
    doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "LostWoods"
  },
  [2] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "Cooking"
  },
  [3] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "Rescue"
  },
  [4] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = ""
  },
  [5] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "Maze"
  },
  [6] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "Stealth"
  },
  [7] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "Levers"
  },
  [8] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = "Crystal"
  },
  [9] = {
	doors = {
	  North = {hint = "none"},
	  South = {hint = "none"},
	  West = {hint = "none"},
	  East = {hint = "none"}
	},
	puzzle = ""
  }
}
  elseif KeyHints[hint] then
    g_message_setuped = ""
	MissionText(_ARG_0_, KeyHints[hint])
  elseif hint == "UnlockItem" then
    on_object_grab(_ARG_0_, "RegenAmulet")
    g_message_setuped = hint
  elseif KeySubEvents[hint] then
    g_message_setuped = ""
    for i = 1, 9 do
	  if Rooms[i].doors.North.hint == hint then
	    Rooms[i].doors.North.hint = "unlocked"
		return
	  elseif Rooms[i].doors.South.hint == hint then
	    Rooms[i].doors.South.hint = "unlocked"
		return
	  elseif Rooms[i].doors.West.hint == hint then
	    Rooms[i].doors.West.hint = "unlocked"
		return
	  elseif Rooms[i].doors.East.hint == hint then
	    Rooms[i].doors.East.hint = "unlocked"
		return
	  end
	end
  elseif hint == "LoopDisplay" then
	--g_message_setuped = ""
    --MissionText(_ARG_0_, "missioncompleted")
  elseif hint == "AttackNotice" then
    g_message_setuped = "AttackNotice_" .. attackLevel
	OpenHint(_ARG_0_, g_message_setuped)
  elseif hint == "SkillNotice" then
    g_message_setuped = "SkillNotice_" .. skillLevel
	OpenHint(_ARG_0_, g_message_setuped)
  elseif hint == "EnemyIsDead" then
    expPoints = expPoints + 1
	OpenMedal(_ARG_0_, expPoints)
  elseif hint == "GotRandom" then
    local itemSel = math.random() <= 0.5 and "Gem" or "Weapon"
	g_message_setuped = itemSel .. "Gift"
	OpenHint(_ARG_0_, g_message_setuped)
	on_object_grab(_ARG_0_, itemSel)
  else
    g_message_setuped = hint
  end
end

delayedEvent = ""
timeB, timeC = true, 0
hasSpawnIntro = false
doMerge = false
bindTable = {
  13, 14, 15, 16, 17, 18, 6004, 6005, 6006, 6007, 6009
}

function main(_ARG_0_, delayedActiv)
  if not hasInit then
    currentPlayer = "Sonic"
	SetGlobalFlag(_ARG_0_, 4, 0) --Sonicman Swap status
    Initiate(_ARG_0_) --Initializes objects for the inventory/upgrades.
    GemUnlocks = { --These get set to true when a Gem is unlocked, so it needs to be undone each load.
	  [1] = {name = "GreenGem", flag = 6004, hasUnlocked = false}, --Green Gem
	  [2] = {name = "BlueGem", flag = 6006, hasUnlocked = false}, --Blue Gem
	  [3] = {name = "WhiteGem", flag = 6007, hasUnlocked = false}, --White Gem
	  [4] = {name = "YellowGem", flag = 6009, hasUnlocked = false}, --Yellow Gem
	  [5] = {name = "RedGem", flag = 6005, hasUnlocked = false}, --Red Gem
	  totalCount = 5
	}
	WeaponUnlocks = {
	  [1] = {name = "StunBlade", flag = 13, hasUnlocked = false}, --Chance to paralyze enemies on hit
	  [2] = {name = "HeavyBand", flag = 14, hasUnlocked = false}, --Chance to make enemies flinch on hit
	  [3] = {name = "RegenAmulet", flag = 15, hasUnlocked = false},
	  [4] = {name = "DamageAmulet", flag = 16, hasUnlocked = false},
	  [5] = {name = "FatalAmulet", flag = 17, hasUnlocked = false},
	  [6] = {name = "SolarisAmulet", flag = 18, hasUnlocked = false},
	  totalCount = 6
	}
    bindFlag = 0
    if GetGlobalFlag(_ARG_0_, 2) ~= 0 then
      bindFlag = bindTable[GetGlobalFlag(_ARG_0_, 2)]
	  for i = 1, GemUnlocks.totalCount do
	    if GemUnlocks[i].flag == bindFlag then
		  GemUnlocks[i].hasUnlocked = true
		  on_object_grab(_ARG_0_, GemUnlocks[i].name)
		  break
		end
	  end
	  for i = 1, WeaponUnlocks.totalCount do
	    if WeaponUnlocks[i].flag == bindFlag then
		  WeaponUnlocks[i].hasUnlocked = true
		  if WeaponUnlocks[i].name == "SolarisAmulet" then
			SetGlobalFlag(_ARG_0_, 15, 1)
		  end
		  on_object_grab(_ARG_0_, WeaponUnlocks[i].name)
		  break
		end
	  end
	end
    hasSpawnIntro = false --Guard intro dialogue
	doOpen = false --Preps viewing the inventory
	doBinds = false
	doMerge = false
	hasBindIntro = false
    hasInit = true
	attackLevel, skillLevel = 1, 1
	expPoints = 0
	for i = 1, ResetUnlocks.count do --Initially disables all upgrades aside from Light Dash.
	  local flag = ResetUnlocks[i]
	  if flag ~= bindFlag then
	    SetGlobalFlag(_ARG_0_, flag, 0)
	  end
	end
  end
  if not timeB and timeC < 1200 then
    timeC = timeC + 1
    if timeC >= 1200 then
	  timeC = 0
	  timeB = true
	  MissionText(_ARG_0_, "fail")
	end
  end
  if delayedActiv then
    delayedEvent = delayedActiv
  end
  if delayedEvent ~= "" and InConvo == false then
    on_event(_ARG_0_, delayedEvent)
	delayedEvent = ""
  end
end

function on_event(_ARG_0_, _ARG_1_)
  if on_puzzle_event(_ARG_0_, _ARG_1_) then
    return
  elseif bind_event(_ARG_0_, _ARG_1_) then
    return
  elseif InConvo then
    main(_ARG_0_, _ARG_1_)
	return
  elseif _ARG_1_ == "StartPlaying_Dungeon" then
    hasInit = false
	return
  elseif _ARG_1_ == "boss_is_dead" then
    if not WeaponUnlocks[4].hasUnlocked and not WeaponUnlocks[6].hasUnlocked then
	  on_object_grab(_ARG_0_, "DamageAmulet")
	  OpenHint(_ARG_0_, "DamageAmuletGet")
	end
  end
  if _ARG_1_ == "North" or _ARG_1_ == "South" or _ARG_1_ == "West" or _ARG_1_ == "East" then
    currentDoor = _ARG_1_
	printf("Door: " .. _ARG_1_)
    if Rooms[currentRoom].doors[_ARG_1_].hint ~= "none" and Rooms[currentRoom].doors[_ARG_1_].hint ~= "unlocked" then
	  printf("Open hint") -----------
	  OpenHint(_ARG_0_, Rooms[currentRoom].doors[_ARG_1_].hint .. "_Req")
	elseif Rooms[currentRoom].doors[_ARG_1_].hint == "none" then
	  --printf("Listener on")
	  --hintListener = true --This is important to prevent overriding after a door unlocks? I think?
	end
	return
  end
  if roomCheck[_ARG_1_] then
	currentRoom = roomCheck[_ARG_1_]
  elseif _ARG_1_ == "add_glass" then
    --Rooms[currentRoom].doors[currentDoor].hint = "GuardianDoor"
	--OpenHint(_ARG_0_, "GuardianDoor_Req")
  elseif _ARG_1_ == "AttackNotice" or _ARG_1_ == "SkillNotice" then
    on_hint(_ARG_0_, _ARG_1_)
  elseif _ARG_1_ == "add_cmn_barrel_b_a" then
    if Rooms[currentRoom].doors.North.hint == "GuardianDoor" then
	  Rooms[currentRoom].doors.North.hint = "unlocked"
	elseif Rooms[currentRoom].doors.South.hint == "GuardianDoor" then
	  Rooms[currentRoom].doors.South.hint = "unlocked"
	elseif Rooms[currentRoom].doors.East.hint == "GuardianDoor" then
	  Rooms[currentRoom].doors.East.hint = "unlocked"
	elseif Rooms[currentRoom].doors.West.hint == "GuardianDoor" then
	  Rooms[currentRoom].doors.West.hint = "unlocked"
	end
  elseif KeyAddEvents[_ARG_1_] then --Listener
    printf("Adding hint")
    --hintListener = false
    Rooms[currentRoom].doors[currentDoor].hint = KeyAddEvents[_ARG_1_] ----------------------
	OpenHint(_ARG_0_, KeyAddEvents[_ARG_1_] .. "_Req")
  elseif _ARG_1_ == "add_twn_domino" then --ATTACK
    expPoints = expPoints - expReqs.attack[attackLevel].exp
	OpenHint(_ARG_0_, expReqs.attack[attackLevel].message)
	OpenMedal(_ARG_0_, expPoints)
    attackLevel = attackLevel + 1
  elseif _ARG_1_ == "add_twn_notice" then --SKILL
    expPoints = expPoints - expReqs.skill[skillLevel].exp
	OpenHint(_ARG_0_, expReqs.skill[skillLevel].message)
	SetGlobalFlag(_ARG_0_, expReqs.skill[skillLevel].flag, 1)
	OpenMedal(_ARG_0_, expPoints)
    skillLevel = skillLevel + 1
  elseif _ARG_1_ == "UpgradeAttack" then
    if expReqs.attack[attackLevel].exp == "max" then
	  OpenHint(_ARG_0_, "AttackMax")
    elseif expPoints < expReqs.attack[attackLevel].exp then
	  OpenHint(_ARG_0_, "NeedExp_" .. expReqs.attack[attackLevel].exp)
	end
  elseif _ARG_1_ == "UpgradeSkill" then
	if expReqs.skill[skillLevel].exp == "max" then
	  OpenHint(_ARG_0_, "SkillMax")
	elseif expPoints < expReqs.skill[skillLevel].exp then
	  OpenHint(_ARG_0_, "NeedExp_" .. expReqs.skill[skillLevel].exp)
	end
  elseif _ARG_1_ == "goto_b" then
    g_mission_information.mission_terrain = "stage/wvo/b/"
    g_mission_information.mission_area = "wvo/sonic/b"
    g_mission_information.mission_set_default = "placement/wvo/set_wvoB_sonic.XML"
    g_mission_information.mission_is_battle = true
    ChangeArea(_ARG_0_, g_mission_information.mission_area)
  elseif _ARG_1_ == "result_wvo_end" then
    MissionClear(_ARG_0_, "complete")
  elseif _ARG_1_ == "accept" then
    --setup_binds(_ARG_0_)
    OpenWindow(_ARG_0_, "Prep_Binds")
	doBinds = true
  elseif _ARG_1_ == "deny" then
    OpenWindow(_ARG_0_, "binds_no")
  elseif _ARG_1_ == "accept_merge" then
    OpenWindow(_ARG_0_, "Amulet_Merge_yes1")
	doMerge = true
  elseif _ARG_1_ == "deny_merge" then
    OpenWindow(_ARG_0_, "Amulet_Merge_no")
  elseif _ARG_1_ == "accept_swap" then
    OpenWindow(_ARG_0_, "Sonicman_swap_accept")
	SetGlobalFlag(_ARG_0_, 4, 1)
  elseif _ARG_1_ == "deny_swap" then
    OpenWindow(_ARG_0_, "Sonicman_swap_deny")
	SetGlobalFlag(_ARG_0_, 4, 0)
  elseif _ARG_1_ == "ChangePlayerSonicman" then
    currentPlayer = "Sonicman"
  elseif _ARG_1_ == "LoopIt" then
    MissionText(_ARG_0_, "missioncompleted", "LoopIt")
  elseif _ARG_1_ == "OpenInv" then
    if not doOpen then
	  doOpen = true
	  OpenWindow(_ARG_0_, "Prep_Shop")
	end
    --inventory_setup(_ARG_0_, "Open_Inventory")
  elseif _ARG_1_ == "Run_ID" then
    local gem = inventory_check("Gem")
	local weapon = inventory_check("Weapon")
	if gem or weapon then
      OpenWindow(_ARG_0_, "ID_Material")
	  IdentifyObjects(_ARG_0_)
	else
	  OpenWindow(_ARG_0_, "No_Materials")
	end
  end
end

function IdentifyObjects(_ARG_0_)
  local hasGem, gems = inventory_check("Gem")
  local hasWeapon, weapons = inventory_check("Weapon")
  if hasGem then
    local gemCount = gems.Quantity
	for i = 1, gemCount do
	  local giveGem = math.random(1, GemUnlocks.totalCount)
	  local failsafe = 0
	  while GemUnlocks[giveGem].hasUnlocked do
	    giveGem = math.random(1, GemUnlocks.totalCount)
		failsafe = failsafe + 1
		if failsafe >= 100 then
		  printf("ALL GEMS UNLOCKED")
		  gems.Quantity = 0
		  break
		end
	  end
	  if failsafe < 100 then
	    GemUnlocks[giveGem].hasUnlocked = true
	    on_object_grab(_ARG_0_, GemUnlocks[giveGem].name)
	    gems.Quantity = gems.Quantity - 1
	  end
	end
  end
  if hasWeapon then
    local weaponCount = weapons.Quantity
	for i = 1, weaponCount do
	  local giveWeapon = math.random(2)
	  local eyeChance = math.random()
	  if eyeChance <= 0.1 then
	    giveWeapon = 5
	  end
	  local failsafe = 0
	  while WeaponUnlocks[giveWeapon].hasUnlocked do
	    giveWeapon = math.random(2)
		failsafe = failsafe + 1
		if failsafe >= 100 then
		  printf("ALL WEAPONS UNLOCKED")
		  weapons.Quantity = 0
		  break
	    end
	  end
	  if failsafe < 100 then
	    WeaponUnlocks[giveWeapon].hasUnlocked = true
	    on_object_grab(_ARG_0_, WeaponUnlocks[giveWeapon].name)
	    weapons.Quantity = weapons.Quantity - 1
	  end
	end
  end
end

function on_talk_icon(_ARG_0_, _ARG_1_)
  if on_puzzle_icon(_ARG_0_, _ARG_1_) then
    return
  else
    g_message_icon = 1
  end
end

function on_talk_setup(_ARG_0_, _ARG_1_)
  --InConvo = true
  if on_puzzle_setup(_ARG_0_, _ARG_1_) then
    return
  elseif inventory_setup(_ARG_0_, _ARG_1_) then
    return
  end
  if _ARG_1_ == "SpawnMan" then
    g_name_setuped = "spawn_name"
    if doOpen then
	  doOpen = false
	  inventory_setup(_ARG_0_, "Open_Inventory")
	elseif not hasSpawnIntro then
	  g_message_setuped = "spawn_intro"
	  hasSpawnIntro = true
	else
	  g_message_setuped = "spawn_inv_id"
	  g_talk_reuse = 1
	end
  elseif _ARG_1_ == "BindMan" then
    g_name_setuped = "spawn_name"
	local Light, lQ = inventory_check("RegenAmulet")
	local Chaos, cQ = inventory_check("DamageAmulet")
	local Flame, fQ = inventory_check("FatalAmulet")
	if Light and Chaos and Flame then
	  if not doMerge then
	    g_message_setuped = "Amulet_Merge"
		g_talk_reuse = 1
	  else
	    on_object_grab(_ARG_0_, "SolarisAmulet")
	    g_message_setuped = "Amulet_Merge_yes2"
		lQ.Quantity = lQ.Quantity - 1
		cQ.Quantity = cQ.Quantity - 1
		fQ.Quantity = fQ.Quantity - 1
		doMerge = false
	  end
	elseif doBinds then
	  doBinds = false
	  g_message_setuped = ""
	  setup_binds(_ARG_0_)
	  --OpenShop(_ARG_0_, "bindWindow")
	else
	  if not hasBindIntro and GetGlobalFlag(_ARG_0_, 2) == 0 then
	    g_message_setuped = "binds"
		hasBindIntro = true
	  else
	    g_message_setuped = "binds_return"
	  end
	  g_talk_reuse = 1
	end
  elseif _ARG_1_ == "Sonicman_puzzle" then
    g_name_setuped = "msg_m1013_n013"
	local flagStatus = GetGlobalFlag(_ARG_0_, 1013)
	local manStatus = GetGlobalFlag(_ARG_0_, 3)
	if manStatus == 0 then --Has not rescued
	  if flagStatus == 0 then --Hasn't raced Sonic Man
	    g_message_setuped = "Sonicman_puzzle_normal"
	  elseif flagStatus == 1 then --Has raced Sonic Man
	    g_message_setuped = "Sonicman_puzzle_real"
	  end
	elseif manStatus == 1 then --Has rescued
	  if currentPlayer == "Sonic" then
	    g_message_setuped = "Sonicman_puzzle_repeat"
	  elseif currentPlayer == "Sonicman" then
	    g_message_setuped = "Sonicman_puzzle_dupe"
	  end
	end
  elseif _ARG_1_ == "Sonicman_swap" then
    g_name_setuped = "msg_m1013_n013"
	g_message_setuped = "Sonicman_swap_open"
	g_talk_reuse = 1
  end
end

select_spawn = {
  {
    name = "Inventory",
    event = "OpenInv"
  },
  {
    name = "Identify",
    event = "Run_ID"
  }
}

function on_talk_close(_ARG_0_, _ARG_1_)
  --InConvo = false
  if on_puzzle_close(_ARG_0_, _ARG_1_) then
    return
  end
  if _ARG_1_ == "spawn_inv_id" then
    OpenSelect(_ARG_0_, "select_spawn")
  elseif _ARG_1_ == "binds" or _ARG_1_ == "binds_return" then
    select_general[1].event = "accept"
	select_general[2].event = "deny"
    OpenSelect(_ARG_0_, "select_general")
  elseif _ARG_1_ == "Amulet_Merge" then
    select_general[1].event = "accept_merge"
	select_general[2].event = "deny_merge"
	OpenSelect(_ARG_0_, "select_general")
  elseif _ARG_1_ == "Sonicman_puzzle_normal" or _ARG_1_ == "Sonicman_puzzle_real" then
    SetGlobalFlag(_ARG_0_, 3, 1)
  elseif _ARG_1_ == "Sonicman_swap_open" then
    select_general[1].event = "accept_swap"
	select_general[2].event = "deny_swap"
	OpenSelect(_ARG_0_, "select_general")
  end
  InConvo = false
end
function on_goal(_ARG_0_)
  Result(_ARG_0_, "g_result_wvo")
end
