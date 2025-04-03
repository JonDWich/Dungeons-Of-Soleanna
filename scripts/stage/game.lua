--$ MAIN GAME LOGIC $--

DoorEventListener = false
BoxToNumber = {
  add_twn_numberbox00 = 0,
  add_twn_numberbox01 = 1,
  add_twn_numberbox02 = 2,
  add_twn_numberbox03 = 3,
  add_twn_numberbox04 = 4,
  add_twn_numberbox05 = 5,
  add_twn_numberbox06 = 6,
  add_twn_numberbox07 = 7,
  add_twn_numberbox08 = 8,
  add_twn_numberbox09 = 9
}
FloorSignaler = {}
idToName = {
  "NorthDoor1", "SouthDoor1", "WestDoor1", "EastDoor1", "NorthDoor2", "SouthDoor2", "WestDoor2", "EastDoor2", 
  "NorthDoor3", "SouthDoor3", "WestDoor3", "EastDoor3", "NorthDoor4", "SouthDoor4", "WestDoor4", "EastDoor4", 
  "NorthDoor5", "SouthDoor5", "WestDoor5", "EastDoor5", "NorthDoor6", "SouthDoor6", "WestDoor6", "EastDoor6", 
  "NorthDoor7", "SouthDoor7", "WestDoor7", "EastDoor7", "NorthDoor8", "SouthDoor8", "WestDoor8", "EastDoor8", 
  "NorthDoor9", "SouthDoor9", "WestDoor9", "EastDoor9"
}

function SetupPuzzle(puzzleRef)
  Game.Log("PUZZLE REF: " .. tostring(puzzleRef.puzzleType))
  puzzleRef.custom_track = puzzleRef.ExtraData.bgm
  puzzleRef.custom_lighting = puzzleRef.ExtraData.lighting
  puzzleRef = puzzleRef.ExtraData
  if puzzleRef.puzzleType == "Cooking" then
    local recipeChoice = math.random(1, table.getn(puzzleRef.Recipes.possibleRecipes))
	recipeChoice = puzzleRef.Recipes.possibleRecipes[recipeChoice]
	puzzleRef.AssignedRecipe = recipeChoice
	Game.Log("Assigned Recipe: " .. puzzleRef.AssignedRecipe)
	table.insert(startList, "particle:" .. recipeChoice)
	Game.Signal("particle:AppleGate")
	Game.Signal("particle:LemonGate")
	Game.Signal("particle:WaterGate")
  elseif puzzleRef.puzzleType == "LostWoods" then
    local directions = {"north", "south", "east", "west"}
	for i = 1, 4 do
	  local correctDir = math.random(1,4)
	  local failSeq = {north = true, south = true, west = true, east = true}
	  correctDir = directions[correctDir]
	  failSeq[correctDir] = false
	  table.insert(startList, "particle:w_portal_" .. correctDir .. i)
	  table.insert(startList, "particle:w_music_" .. correctDir .. i)
	  --Game.Log("LOOP: " .. i .. " DIRECTION: " .. correctDir)
	  for k, v in pairs(failSeq) do
	    if v then
		  table.insert(startList, "particle:" .. k .. "_fail" .. i)
		end
	  end
	end
  elseif puzzleRef.puzzleType == "Rescue" then
    local events = {"Rescue1", "Rescue2", "Rescue3", "Rescue4"}
	local correctPattern = {progress = 0}
	for i = 1, 4 do
	  local patternChoice = math.random(4)
	  table.insert(correctPattern, events[patternChoice])
	end
	puzzleRef.AssignedPattern = correctPattern
  end
end

function ExtraEventHandler(tableRef, evID)
  local function PuzzleCleared()
    Game.Log("CLEARING PUZZLE...")
	usePuzzleTimer = false
	puzzleTimer = 0
	Game.StartEntityByName("particle:PuzzleCleared" .. currentRoom)
    for i = 1, 4 do
	  if RoomTable[currentRoom].doors[i].status ~= false then
	    Game.Log("UNLOCKED DOOR: " .. RoomTable[currentRoom].doors[i].name)
	    RoomTable[currentRoom].doors[i].doorType = "Unlocked"
	  end
	end
	tableRef.hasClear = true
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "obj_common", id = "key_get"})
  end
  local specificEvent = tableRef.relevantEvents[evID]
  if tableRef.puzzleType == "Cooking" then
    if tableRef.Ingredients[specificEvent] then
	  if tableRef.Ingredients.held < tableRef.Ingredients.maxNum then
	    tableRef.Ingredients[specificEvent] = tableRef.Ingredients[specificEvent] + 1
		tableRef.Ingredients.held = tableRef.Ingredients.held + 1
		Game.Log("Got item: " .. specificEvent)
	  else
	    Game.Log("Inventory full!!!")
	  end
	elseif evID == "deposit_item" then
	  if tableRef.Ingredients.held >= 4 then
	    local recipeRef = tableRef.Recipes[tableRef.AssignedRecipe]
	    local appleCount, lemonCount, waterCount = recipeRef.Apple, recipeRef.Lemon, recipeRef.Water
		if tableRef.Ingredients.Apple == appleCount and tableRef.Ingredients.Lemon == lemonCount and tableRef.Ingredients.Water == waterCount then
		  PuzzleCleared()
		end
	    for k, v in pairs(tableRef.Ingredients) do
		  if k ~= "maxNum" then
		    tableRef.Ingredients[k] = 0
		  end
		end
		Game.Log("Inventory: " .. tableRef.Ingredients.held)
	  end
	end
  elseif tableRef.puzzleType == "Maze" then
    if evID == "enter_maze" then
	  if not tableRef.hasClear and currentLight == "" then
	    Game.ProcessMessage("particle:Light_Orange", "ON")
	  end
	elseif evID == "get_maze_key" then
	  tableRef.total_keys = tableRef.total_keys + 1
	  tableRef.maze_key_count = tableRef.maze_key_count + 1
	  local m_KeyCount = tableRef.total_keys
	  if m_KeyCount == 1 then
		lastLight = "Light_Orange"
		currentLight = "Light_DarkB"
		changeLighting = true
	    ambientSFX[1].enabled = true
		ambientSFX[2].enabled = true
		ambientSFX[5].enabled = true
	  elseif m_KeyCount == 2 then
	    ambientSFX[2].interval = 2.5
	  elseif m_KeyCount == 3 then
	    ambientSFX[2].interval = 1.25
		lastLight = "Light_DarkB"
		currentLight = "Light_DarkA"
		changeLighting = true
	  elseif m_KeyCount == 4 then
	    ambientSFX[2].enabled = false
		ambientSFX[3].enabled = true
		ambientSFX[4].enabled = true
	  end
	elseif evID == "add_maze_key" then
	  while tableRef.maze_key_count > 0 do -- Let the flames begin
	    for i = 1, 5 do
		  if not tableRef.activeFlames[i] then
	        Game.StartEntityByName("particle:maze_flame" .. i)
		    tableRef.activeFlames[i] = true
		    tableRef.maze_key_count = tableRef.maze_key_count - 1
			Game.ProcessMessage("LEVEL", "PlaySE", {bank = "enemy_ct", id = "flame_on"})
		    break
		  end
		end
	  end
	  if tableRef.activeFlames[5] then
	    ambientSFX[1].enabled = false
		ambientSFX[2].enabled = false
		ambientSFX[3].enabled = false
		ambientSFX[4].enabled = false
		ambientSFX[5].enabled = false
		Game.ProcessMessage("particle:Light_Orange", "OFF")
	    Game.ProcessMessage("particle:Light_DarkA", "OFF")
	    Game.ProcessMessage("particle:Light_DarkB", "OFF")
	    PuzzleCleared()
		tableRef.activeFlames[5] = false -- Disables the clear behavior from running again when passing back by the flames.
	  end
	elseif evID == "exit_maze" then
	  Game.ProcessMessage("particle:Light_Orange", "OFF")
	  Game.ProcessMessage("particle:Light_DarkA", "OFF")
	  Game.ProcessMessage("particle:Light_DarkB", "OFF")
	end
  elseif tableRef.puzzleType == "LostWoods" then
    if evID == "PuzzleClear" then
	  Game.Signal("particle:g_LostWoods1")
	  Game.Signal("particle:g_LostWoods2")
	  Game.Signal("particle:g_LostWoods3")
	  Game.Signal("particle:g_LostWoods4")
	  Game.ProcessMessage("particle:HaltEntry", "ON")
	  PuzzleCleared()
	end
  elseif tableRef.puzzleType == "Stealth" then
    if evID == "PlayerFound" then
	  Game.Signal("particle:StealthGroupFloor")
	  Game.StartEntityByName("particle:Stealth_KeyCage")
	  RoomTable[currentRoom].threat_level = 6
	  BGM_Handler(0, true)
	elseif evID == "AllKilled" then
	  Game.Signal("particle:Stealth_KeyCage")
	  RoomTable[currentRoom].threat_level = 0
	  ThreatManager()
	elseif evID == "PuzzleClear" then
	  PuzzleCleared()
	end
  elseif tableRef.puzzleType == "Levers" then
    if evID == "PuzzleClear" then
	  PuzzleCleared()
	end
  elseif tableRef.puzzleType == "Crystal" then
    if evID == "InsideRoom" then
	  curPuzzle = "Crystal"
    elseif evID == "add_WoodBox_Test" then
	  if not usePuzzleTimer then
	    usePuzzleTimer = true
	  end
	  tableRef.TEV.SimulCount = tableRef.TEV.SimulCount + 1
	  Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn", id = "passring_pass_0" .. tableRef.TEV.SimulCount})
	  if tableRef.TEV.SimulCount >= 4 then
	    PuzzleCleared()
		Game.Signal("particle:CrystalActive")
	  end
	end
  elseif tableRef.puzzleType == "Rescue" then
    local progress = tableRef.AssignedPattern.progress + 1
	if progress <= 4 then
	  if evID == tableRef.AssignedPattern[progress] then
	    Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn", id = "passring_pass_0" .. progress})
	    tableRef.AssignedPattern.progress = tableRef.AssignedPattern.progress + 1
	    if tableRef.AssignedPattern.progress >= 4 then
	      Game.Signal("particle:RescueCage")
		  PuzzleCleared()
	    end
	  else
	    Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn", id = "wrong"})
		tableRef.AssignedPattern.progress = 0
	  end
	end
  end
  if tableRef.PuzzleSounds[evID] then
    local sbk, sfx = tableRef.PuzzleSounds[evID].sbk, tableRef.PuzzleSounds[evID].sfx
    Game.ProcessMessage("LEVEL", "PlaySE", {bank = sbk, id = sfx})
  end
end 

lastLight = ""
currentLight = ""
changeLighting = false
lightTimer = 0
ambientSFX = {
  {enabled = false, bank = "boss_mefiress", id = "zakoress_appear", timer = 0, interval = 45}, --laugh
  {enabled = false, bank = "enemy_monster_common", id = "explode_small", timer = 0, interval = 5}, --thud
  {enabled = false, bank = "boss_solaris", id = "appear_voice", timer = 0, interval = 4.5, oneshot = true},
  {enabled = false, bank = "stage_twn", id = "rock_brk", timer = 0, interval = 3, oneshot = true},
  {enabled = false, bank = "boss_mefiress", id = "kyozoress_dead", timer = 0, interval = 50, oneshot = true},
  {enabled = false, bank = "stage_twn_voice", id = "dog_wait", timer = 0, interval = 15} --Pele
}
function ambient_handler(delta) --This seems reasonably performant
  for k, v in pairs(ambientSFX) do
    if v.enabled then
	  v.timer = v.timer + delta
	  if v.timer >= v.interval then
	    Game.ProcessMessage("LEVEL", "PlaySE", {bank = v.bank, id = v.id})
	    v.timer = 0
		if v.oneshot then
		  v.enabled = false
		end
	  end
	end
  end
end

local doSFX = false
local b_sfxTimer1 = 0
local b_sfxTimer2 = 0
function BossSounds(delta)
  if doSFX then
    b_sfxTimer1 = b_sfxTimer1 + delta
    b_sfxTimer2 = b_sfxTimer2 + delta
  end
  if b_sfxTimer1 >= 0.35 and b_sfxTimer2 <= 2.25 then
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "obj_common", id = "magnet_on"})
	b_sfxTimer1 = 0
  else
    if b_sfxTimer2 >= 2.25 then
	  b_sfxTimer2 = 0
      doSFX = false
	end
  end
end

currentTrack, trackTimer, trackLength, trackPause = "", 0, 0, false
trackDelay = 0
BGM_Tracks = {
  Combat = {
    {name = "desolo_3", duration = 114},
	{name = "desolo_9", duration = 157},
	{name = "adorno_3", duration = 164},
	{name = "adorno_9", duration = 229}
  },
  Ambient = {
    {name = "ambient_calm", duration = 40}, --Furn_Amb
	{name = "ambient_exploration", duration = 75}, --17161
	{name = "ambient_abandoned", duration = 90}, --16132
	{name = "ambient_exploration_2", duration = 67} --10475
	--{name = "ambient_occult", duration = 102} --14023 Not using
  }
}
function BGM_Handler(delta, isCombat)
  if isBossFight then return end
  if isCombat and not trackPause then
    trackPause = true
	Game.StopBGM()
	trackTimer = 0
	local selection = math.random(1, table.getn(BGM_Tracks.Combat))
	Game.PlayBGM(BGM_Tracks.Combat[selection].name)
	Game.Log("Playing BGM: " .. BGM_Tracks.Combat[selection].name)
  end
  if not trackPause then
    trackTimer = trackTimer + delta
    if trackTimer >= trackLength then
	  Game.StopBGM()
	  if trackTimer >= trackLength + trackDelay then
	    local selection = math.random(1, table.getn(BGM_Tracks.Ambient))
	    while BGM_Tracks.Ambient[selection].name == currentTrack do
	      selection = math.random(1, table.getn(BGM_Tracks.Ambient))
	    end
	    trackTimer = 0
	    currentTrack = BGM_Tracks.Ambient[selection].name
	    trackLength = BGM_Tracks.Ambient[selection].duration
	    Game.PlayBGM(currentTrack)
		Game.Log("Playing BGM: " .. currentTrack)
	  end
	end
  end
end

puzzleTimer = 0
usePuzzleTimer = false
curPuzzle = ""
function puzzle_time_handler(delta)
    if not usePuzzleTimer then
	  return
	end
    puzzleTimer = puzzleTimer + delta
	local puzzle = PuzzleTable[curPuzzle].TEV
	if puzzleTimer >= puzzle.timer then
	  puzzleTimer = 0
	  puzzle_time_event(puzzle, puzzle.event)
	end
end

function puzzle_time_event(puzzle, event)
  if event == "crystal" then
    usePuzzleTimer = false
	Game.Log("SIMULCOUNTTTT: " .. puzzle.SimulCount)
	puzzle.SimulCount = 0
  end
end

function OpenDoorEnemy() -- Old implementation for opening doors w/o eventboxes. Thankfully unused
  local doorName = 0
  if FloorSignaler[2] ~= nil then
    FloorSignaler[1] = FloorSignaler[1] * 10
	doorName = FloorSignaler[1] + FloorSignaler[2]
  else
    doorName = FloorSignaler[1]
  end
  local room = math.ceil(doorName/10)
  Game.Log("Room is: " .. room)
  doorName = idToName[doorName]
  FloorSignaler = {}
  if doorName == nil then
    Game.Log("NIL FOUND")
	FloorSignaler = {}
	return
  end
  Game.Log("Opening door: " .. tostring(doorName))
  --Game.Signal(doorName)
  for i = 1, 9 do -- Iterate through each room, then each door in the room
    for i2 = 1, 4 do
	  local iDoor = RoomTable[i].doors[i2]
	  if iDoor.name == doorName then
	    if iDoor.doorType ~= "Unlocked" then
		  OpenDoorCondition(iDoor)
		  return
		else
		  Game.Log("Door: " .. doorName .. " is already unlocked")
		  return
		end
	  end
	end
  end
end

function OpenDoorCondition(doorRef)
  if doorRef.doorType == "Guardian" then
    Game.Log("Guardian Door")
	if RoomTable[currentRoom].threat_level > 0 then
	  if not hallwayOpen then
	    if currentPlayer == "Sonicman" then
		  Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn_voice", id = "youngman_sad"})
		else
	      Game.ProcessMessage("LEVEL", "PlaySE", {bank = "obj_common", id = "guardian_door"})
		end
	  end
	else
	  doorRef.doorType = "Unlocked"
	  Game.Signal(doorRef.name)
	  Game.Signal(doorRef.ID)
	end
  elseif KeyTable.AvailableKeys[doorRef.doorType] ~= nil then
    Game.Log("Key Door")
	local checkKey = doorRef.doorType
	if KeyTable.AvailableKeys[checkKey] == true then --If the key is in your possession, unlock the door
	  Game.Log("Unlocking door")
	  KeyTable.AvailableKeys[checkKey] = false
	  Game.Signal(doorRef.name)
	  Game.Signal(doorRef.ID)
	  Game.Signal(checkKey)
	  doorRef.doorType = "Unlocked"
	else
	  Game.StartEntityByName(checkKey .. "Key") --Hint message. Spawns the objectphysics in a collider, mission script checks nearest door.
	  Game.Log("Missing key: " .. doorRef.doorType)
	end
  elseif doorRef.doorType == "Puzzle" then
    Game.Log("Puzzle Door")
	-- Puzzle doors are unlocked in the PuzzleCleared function
  elseif doorRef.doorType == "Boss" then
    if table.getn(uniqueRooms) < 5 then
	  if not hasVisitedBossDoor then
	    local sbk = currentPlayer == "Sonicman" and "stage_twn_voice" or "obj_common"
	    local sfx = CurrentPlayer == "Sonicman" and "middleman_angry" or "boss_door"
	    hasVisitedBossDoor = true
		Game.ProcessMessage("LEVEL", "PlaySE", {bank = sbk, id = sfx})
	  end
	end
	Game.Signal(doorRef.name)
  elseif doorRef.doorType == "Unlocked" then
    Game.Signal(doorRef.name)
  end
end

function GetKey()
  local myKey = ""
  myKey = RoomTable[currentRoom].assignedKey
  Game.Log("Grabbed key: " .. myKey)
  KeyTable.AvailableKeys[myKey] = true
  Game.Signal(myKey .. "1")
end

function ThreatManager()
  local roomRef = RoomTable[currentRoom]
  roomRef.threat_level = roomRef.threat_level - 1
  expPoints = expPoints + 1
  doorKillCount = doorKillCount + 1
  if roomRef.threat_level <= 0 then
    Game.StartEntityByName("barrel" .. barrelCount)
    trackPause = false
	trackTimer = trackLength + 20
  end
end

local warpID = 0
function BossEvent(firstSpawn)
  if firstSpawn then
    warpID = 1
    Game.StartEntityByName("Warp1")
    Game.ProcessMessage("BossStopCol", "ON")
  else
    warpID = warpID + 1
    Game.StartEntityByName("Warp" .. warpID)
    if warpID > 5 then
      warpID = 6
      Game.ProcessMessage("BossStopCol", "OFF")
    end
  end
end

function Step(delta) -- Update function, called each frame.
  if changeLighting then
    lightTimer = lightTimer + delta
    if lightTimer >= 0.9 then -- 06 completely resets lighting when swapping ChangeLights too quickly. This delay helps avoid that
	  Game.ProcessMessage("particle:" .. lastLight, "OFF")
	  Game.ProcessMessage("particle:" .. currentLight, "ON")
	  lightTimer = 0
	  changeLighting = false
    end
  end
  BossSounds(delta)
  BGM_Handler(delta)
  ambient_handler(delta)
  puzzle_time_handler(delta)
end

currentRoom = 0
currentDoor = {}
lastDir = ""
hallwayOpen = false --Ensures you only force open a door if you're coming from the hallway.
hasVoiced = false
RoomSwap = {in_room1 = 1, in_room2 = 2, in_room3 = 3, in_room4 = 4, in_room5 = 5, in_room6 = 6, in_room7 = 7, in_room8 = 8, in_room9 = 9}
uniqueRooms = {}
function ProcessMessage(msg, ...)
    if msg == "CallEvent" then
	  local evID = arg[1].eventID
	  Game.Log("EV ID: " .. evID)
	  if evID == "add_WoodBox_Prime" then
	    ThreatManager()
	  elseif evID == "ChangePlayerSonicman" then
	    currentPlayer = "Sonicman"
	  elseif evID == "StartBoss" then
	    isBossFight = true
	    Game.StartEntityByName("BossMeph")
		Game.StopBGM()
		Game.PlayBGM("Raksha")
	  elseif evID == "add_tpj_obj_board" then
	    BossEvent()
	  elseif evID == "add_Warp_Break" then
	    BossEvent(true)
	  elseif evID == "add_stained" then
	    if not doSFX then
		  doSFX = true
		end
	  elseif evID == "boss_is_dead" then
	    Game.StartEntityByName("EndGoal")
		Game.Signal("BossDoor_Out")
		Game.ProcessMessage("BossStopCol", "OFF")
		if currentPlayer == "Sonicman" then
		  Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn_voice", id = "sonicman03"})
		end
		Game.StopBGM()
		isBossFight = false
	  elseif evID == "UpgradeAttack" then
	    UpgradeAttack()
	  elseif evID == "UpgradeSkill" then
	    UpgradeSkill()
	  elseif evID == "add_wvo_table" then
	    Game.ProcessMessage("LEVEL", "PlaySE", {bank = "obj_common", id = "item_get"})
	  end
	  if RoomSwap[evID] then
		currentRoom = RoomSwap[evID]
		checkAddIndex(uniqueRooms, currentRoom, "v")
		if not hasVoiced then
		  Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn_voice", id = "youngman_call"})
		  hasVoiced = true
		end
		if RoomTable[currentRoom].custom_lighting ~= "" then
		  changeLighting = true
		  currentLight = RoomTable[currentRoom].custom_lighting
		end
		if RoomTable[currentRoom].custom_track ~= "" then
		  trackTimer = 0
		  trackPause = true
		  Game.StopBGM()
		  Game.PlayBGM(RoomTable[currentRoom].custom_track)
		elseif RoomTable[currentRoom].threat_level > 0 then
		  BGM_Handler(0, true)
		else
		  if trackPause then
		    trackTimer = trackLength + 20
		    trackPause = false
		  end
		end
	  elseif currentRoom ~= 0 and RoomTable[currentRoom].ExtraData.relevantEvents ~= nil and RoomTable[currentRoom].ExtraData.relevantEvents[evID] then
	    ExtraEventHandler(RoomTable[currentRoom].ExtraData, evID)
	  elseif evID == "in_hallway" then
	    hallwayOpen = true
		Game.ProcessMessage("particle:Light_Orange", "OFF")
	    Game.ProcessMessage("particle:Light_DarkA", "OFF")
	    Game.ProcessMessage("particle:Light_DarkB", "OFF")
	  elseif evID == "North" or evID == "South" or evID == "West" or evID == "East" then
		for i = 1, 4 do
		  if RoomTable[currentRoom].doors[i].dir == evID then
			currentDoor = RoomTable[currentRoom].doors[i]
			Game.Log("Checking door: " .. currentDoor.name)
			lastDir = evID
			OpenDoorCondition(currentDoor)
			break
		  end
		end
		hallwayOpen = false
	  elseif evID == "force_open_door" and hallwayOpen then
	    local doorRef
		local nearDoor = GetLinkedDirection(lastDir) .. "Door" .. currentRoom
	    for i = 1, 4 do
		  doorRef = RoomTable[currentRoom].doors[i]
		  if nearDoor == doorRef.name then
		    break
		  end
		end
		local keyCheck = doorRef.doorType
		if KeyTable.AvailableKeys[keyCheck] == nil then --and keyCheck ~= "Boss" then --and keyCheck ~= "Guardian" then --------------------
		  Game.Signal(nearDoor)
		end
	  elseif DoorEventListener then
	    if BoxToNumber[evID] then
		  table.insert(FloorSignaler, BoxToNumber[evID])
		elseif evID == "add_IronBox_Vs" then
		  DoorEventListener = false
		  OpenDoorEnemy()
		end
	  elseif evID == "add_IronBox_Vs" then
	    DoorEventListener = true
	  elseif evID == "GetKey" then
	    local dbgStat, err =  pcall(GetKey)
		if not dbgStat then
		  Game.Log(err)
		end
	  end
	end
end

RoomTable = {}
Bors = {
  top = {
    [7] = true,
    [8] = true,
    [9] = true
  },
  bottom = {
    [1] = true,
    [2] = true,
    [3] = true
  }
}
--1, 6, 7 LEFT   Returns 1 or 2    1, 2.75, 0.5
--2, 5, 8 MIDDLE  Returns 2        2, 1.75, 1.5
--3, 4, 9 RIGHT  Returns 0 or 1    3, 0.75, 2.5
function GetPosition(roomNo) -- Truly terrible way of calculating position
  local determine = math.mod(roomNo, 3.25)
  if determine == 1 or determine == 2.75 or determine == 0.5 then
    return "left"
  elseif determine == 2 or determine == 1.75 or determine == 1.5 then
    return "middle"
  elseif determine == 3 or determine == 0.75 or determine == 2.5 then
    return "right"
  end
end

function SetBorders(position, roomNo)
  local superPos = ""
  if Bors.top[roomNo] then
    superPos = "top"
  elseif Bors.bottom[roomNo] then
    superPos = "bottom"
  else
    superPos = "middle"
  end
  local pos = {}
  if superPos == "bottom" then
    if position == "left" then
      pos.North = roomNo + 5
      pos.South = "void"
      pos.West = "void"
      pos.East = roomNo + 1
    elseif position == "middle" then
      pos.North = roomNo + 3
      pos.South = "void"
      pos.West = roomNo - 1
      pos.East = roomNo + 1
    elseif position == "right" then
      pos.North = roomNo + 1
      pos.South = "void"
      pos.West = roomNo - 1
      pos.East = "void"
    end
  elseif superPos == "middle" then
    if position == "left" then
      pos.North = roomNo + 1
      pos.South = roomNo - 5
      pos.West = "void"
      pos.East = roomNo - 1
    elseif position == "middle" then
      pos.North = roomNo + 3
      pos.South = roomNo - 3
      pos.West = roomNo + 1
      pos.East = roomNo - 1
    elseif position == "right" then
      pos.North = roomNo + 5
      pos.South = roomNo - 1
      pos.West = roomNo + 1
      pos.East = "void"
    end
  elseif superPos == "top" then
    if position == "left" then
      pos.North = "void"
      pos.South = roomNo - 1
      pos.West = "void"
      pos.East = roomNo + 1
    elseif position == "middle" then
      pos.North = "void"
      pos.South = roomNo - 3
      pos.West = roomNo - 1
      pos.East = roomNo + 1
    elseif position == "right" then
      pos.North = "void"
      pos.South = roomNo - 5
      pos.West = roomNo - 1
      pos.East = "void"
    end
  end
  return pos
end

doorAvailable = false
function GetLinkedDirection(dir)
  if dir == "North" then
    return "South"
  elseif dir == "South" then 
    return "North"
  elseif dir == "East" then
    return "West"
  elseif dir == "West" then
    return "East"
  end
end

function DoorWallChoice(dir, num, adj)
  local coinflip = math.random(1, 100)
  local blockName, doorName, boxName = dir .. "Block" .. num, dir .. "Door" .. num, dir .. "Box" .. num
  local oppositeBlock, oppositeDoor = GetLinkedDirection(dir) .. "Block" .. adj, GetLinkedDirection(dir) .. "Door" .. adj
  local attachedNum = RoomTable[num].borders[GetLinkedDirection(dir)]
  if DoorTable[doorName] == "force_on" then
	table.insert(startList, doorName)
	table.insert(startList, boxName)
	Game.Log("BOX NAME: " .. boxName)
	return
  end
  if coinflip <= 50 then
	table.insert(startList, blockName)
	table.insert(startList, oppositeBlock)
	DoorTable[doorName] = false
	DoorTable[oppositeDoor] = false
  else
    if DoorTable[doorName] ~= false then
	  table.insert(startList, doorName)
	  table.insert(startList, boxName)
	  Game.Log("BOX NAME: " .. boxName)
	  DoorTable[oppositeDoor] = "force_on" --Forces the connection
	  doorAvailable = true
	end
  end
end

function SpawnDoors()
  for i = 1, 9 do
    doorAvailable = false --Ensures at least 1 connection is made
    for k, v in pairs(RoomTable[i].borders) do
      if v == "void" then
		table.insert(startList, k .. "Block" .. i)
		local door = k .. "Door" .. i
		DoorTable[door] = false
	  else
		DoorWallChoice(k, i, v)
	  end
    end
	if not doorAvailable then --Panic spawn
	  local doBreak = 1
	  for k, v in pairs(RoomTable[i].borders) do
	    if v ~= "void" then 
		  local oppositeDoor, oppositeBlock = GetLinkedDirection(k) .. "Door" .. v, GetLinkedDirection(k) .. "Block" .. v
		  table.insert(signalList, k .. "Block" .. i)
		  table.insert(startList, k .. "Door" .. i)
		  table.insert(startList, k .. "Box" .. i)
		  table.insert(startList, oppositeDoor)
		  table.insert(startList, GetLinkedDirection(k) .. "Box" .. v)
		  table.insert(signalList, oppositeBlock)
		  DoorTable[oppositeDoor] = "force_on"
		  DoorTable[k .. "Door" .. i] = true --Might fix it
		  if RoomTable[i].position ~= "middle" and doBreak ~= 2 then --Forces middle rooms to have 2 connections.
		    doBreak = 1
		    break
		  else
		    doBreak = doBreak + 1
		  end
		end
	  end
	end
  end
end

DoorTable = {} --Tracks which doors in a room can be selected for generation
KeyTable = {
  Color = {"Red", "Blue", "Green"},
  Shape = {"Triangle", "Shield", "Crescent"},
  PossibleKeys = {}, --All key permutations, indexed as an array
  AvailableKeys = {}, --List of keys spawned in the dungeon, indexed as a dictionary where each value is True or False
  aKeysCopy = {}, --A copy of AvailableKeys but indexed as an array. Used to set up AvailableKeys (pulls a random value from here, removes it)
  findSequence = {
    hasFound = {},
	foundOrder = {}
  },
  actualSpawns = {}
}
function SpawnKeys(numSpawn)
  for i = 1, numSpawn do --Generates possible key reqs
    local keyCount = table.getn(KeyTable.PossibleKeys)
    local rng = math.random(1,keyCount)
    local activateKey = KeyTable.PossibleKeys[rng]
	table.remove(KeyTable.PossibleKeys, rng)
	Game.Log("Inserted key: " .. activateKey)
	KeyTable.AvailableKeys[activateKey] = false
	table.insert(KeyTable.aKeysCopy, activateKey)
  end
  for i = 1, 9 do --Sets the door to a specific key req
    for k, v in ipairs(RoomTable[i].doors) do
	  if v.doorType == "LockedDoor" and v.status ~= false then
	    local chosenKey = math.random(1, table.getn(KeyTable.aKeysCopy)) --I need to check how many keys ACTUALLY get used 
		v.doorType = KeyTable.aKeysCopy[chosenKey]
		Game.Log("doorType set to: " .. KeyTable.aKeysCopy[chosenKey])
		Game.Log("DoorNum is: " .. v.name)
		table.remove(KeyTable.aKeysCopy, chosenKey)
	  end
	end
  end
end

function GetDoorStatus(doorCheck)
  local status = DoorTable[doorCheck]
  if status == true or status == "force_on" then 
    return true
  else
    return false
  end
end

function SetRoomType()
  spawnRoom, bossRoom = math.random(1,9), math.random(1,9)
  while bossRoom == spawnRoom or bossRoom == 5 do
    bossRoom = math.random(1,9)
  end
  Game.Log("sRoom: " .. spawnRoom)
  Game.Log("bRoom: " .. bossRoom)
  for i = 1, 9 do
    if i == spawnRoom then
	  RoomTable[i].roomType = "Spawn"
	  table.insert(startList, "pathobj:sp_" .. i)
	  table.insert(startList, "pathobj:g_spawn_" .. i)
	elseif i == bossRoom then
	  RoomTable[i].roomType = "Boss"
	  table.insert(startList, "BossGate" .. i)
	  table.insert(startList, "BossHint" .. i)
	else
	  local chance = math.random(1,100)
	  if chance <= 45 and PuzzleTable.currentPuzzles < PuzzleTable.maxPuzzles and not PuzzleTable.invalidRooms[RoomTable[i].number] then --45
	    RoomTable[i].roomType = "Puzzle"
		PuzzleTable.currentPuzzles = PuzzleTable.currentPuzzles + 1
		local chosenPuzzle = math.random(1, table.getn(PuzzleTable.validPuzzles))
		chosenPuzzle = PuzzleTable.validPuzzles[chosenPuzzle]
		while not checkAddIndex(PuzzleTable[chosenPuzzle].ValidRooms, i, "v", true) do
		  chosenPuzzle = math.random(1, table.getn(PuzzleTable.validPuzzles))
		  chosenPuzzle = PuzzleTable.validPuzzles[chosenPuzzle]
		end
		local _, idx = checkAddIndex(PuzzleTable.validPuzzles, chosenPuzzle, "kv", true) --Finds the index of the puzzle
		table.remove(PuzzleTable.validPuzzles, idx) --Removes this puzzle type from consideration
		PuzzleTable[chosenPuzzle].AssignedRoom = i
		RoomTable[i].ExtraData = PuzzleTable[chosenPuzzle]
		table.insert(startList, "particle:" .. RoomTable[i].ExtraData.ObjectSet .. i)
		SetupPuzzle(RoomTable[i]) --RoomTable[i].ExtraData
	  else
	    RoomTable[i].roomType = "Standard"
		LoadRoomLayout(RoomTable[i])
	  end
	end
	Game.Log("Set room_" .. i .. ": " .. RoomTable[i].roomType)
  end
end

DesignTable = {
  [1] = {"r1_d1", "r1_d2", "r1_d3", "r1_d4", threat = {4, 0, 4, 4} },
  [2] = {"r2_d1", "r2_d2", "r2_d3", threat = {4, 4, 3} },
  [3] = {"r3_d1", "r3_d2", "r3_d3", threat = {0, 4, 4} },
  [4] = {"r4_d1", "r4_d2", "r4_d3", threat = {4, 5, 3} },
  [5] = {"r5_d1", "r5_d2", "r5_d3", threat = {4, 8, 4} },
  [6] = {"r6_d1", "r6_d2", "r6_d3", threat = {3, 8, 0} },
  [7] = {"r7_d1", "r7_d2", "r7_d3", threat = {4, 4, 0} },
  [8] = {"r8_d1", "r8_d2", "r8_d3", threat = {3, 6, 4} },
  [9] = {"r9_d1", "r9_d2", "r9_d3", threat = {8, 0, 4} }
}
function LoadRoomLayout(roomRef)
  local rng = math.random(1, table.getn(DesignTable[roomRef.number]))
  local layout = DesignTable[roomRef.number][rng]
  local threat_level = DesignTable[roomRef.number].threat[rng]
  table.insert(startList, "design:" .. layout)
  roomRef.threat_level = threat_level
end

lockedCount = 0
function SetDoorType(roomType)
  if roomType == "Spawn" then
    return "Unlocked"
  elseif roomType == "Boss" then
    return "Boss"
  elseif roomType == "Puzzle" then
    return "Puzzle"
  elseif roomType == "Standard" then
    local chance = math.random(1,100)
	if chance <= 75 then --45
	  return "Guardian"
	else
	  chance = math.random(1,100)
	  if chance <= 60 and lockedCount < 7 then --30, 6
	    lockedCount = lockedCount + 1
		--Game.Log("Made a locked door")
		return "LockedDoor" --Counts number of doors that need keys. Will iterate over this later to set individual locks.
	  else
	    if roomType ~= "Boss" then
	      return "Unlocked"
		else
		  return "Guardian"
		end
	  end
	end
  end
end

function copyTable(t1, t2) -- Shallow copy
  local copy = t2 or {}
  for k, v in pairs(t1) do
    copy[k] = v
  end
  return copy
end

function SetSelfDoors()
  local floorCounter = 1
  for i = 1, 9 do --Establishes a room's own doors and the associated aqa_floors (previously used for opening doors)
    local nDoor, sDoor, wDoor, eDoor = "NorthDoor" .. i, "SouthDoor" .. i, "WestDoor" .. i, "EastDoor" .. i
	local rType = RoomTable[i].roomType
    RoomTable[i].doors[1] = {name = nDoor, ID = "f" .. floorCounter, doorType = SetDoorType(rType), status = GetDoorStatus(nDoor), dir = "North"}
	floorCounter = floorCounter + 1
	RoomTable[i].doors[2] = {name = sDoor, ID = "f" .. floorCounter, doorType = SetDoorType(rType), status = GetDoorStatus(sDoor), dir = "South"}
	floorCounter = floorCounter + 1
	RoomTable[i].doors[3] = {name = wDoor, ID = "f" .. floorCounter, doorType = SetDoorType(rType), status = GetDoorStatus(wDoor), dir = "West"}
	floorCounter = floorCounter + 1
	RoomTable[i].doors[4] = {name = eDoor, ID = "f" .. floorCounter, doorType = SetDoorType(rType), status = GetDoorStatus(eDoor), dir = "East"}
	floorCounter = floorCounter + 1
  end
  for rI = 1, 9 do
    for dI = 1, 4 do
	  if not RoomTable[rI].doors[dI].status then 
	    -- Destroys the aqa_floor if a door doesn't exist in that location. Need to break Void as well.
		table.insert(signalList, RoomTable[rI].doors[dI].ID)
		--Game.Log("Killed floor: " .. tostring(RoomTable[rI].doors[dI].ID))
	  else
	    --RoomTable[rI].doors.validBorderCount = RoomTable[rI].doors.validBorderCount + 1 --Not currently using this
	  end
	end
  end
  SpawnKeys(lockedCount)
end

-- Pass in a table, ID to check for, and whether it's a Key or Value. If checkOnly is false/nil, add the missing
-- ID to the table.
function checkAddIndex(tbl, idx, kv, checkOnly)
  for k, v in pairs(tbl) do
    if kv == "k" then -- If checking for a key existing, return the key
	  if k == idx then
	    return true, k
	  end
	elseif kv == "v" then -- If checking for a value existing, return the value
	  if v == idx then
	    return true, v
	  end
	elseif kv == "kv" then -- Return both the key and the value
	  if k == idx or v == idx then
	    return true, k, v
	  end
	end
  end
  if not checkOnly then
    --Game.Log("Inserted: " .. idx .. " to: " .. tostring(tbl))
    table.insert(tbl, idx)
  end
  return false
end

PathArray = {}
PathBlacklist = {}
DoorsWithKeys = {} --List of doors that have had their key generated
--[[
	Send in a table containing room numbers, your current room (if you would like to remove it from consideration), 
	and the door you'd like to check 
]]
function keyCreate(numToCheck, currentDoor, validKeyRooms)
    local _, idx = checkAddIndex(validKeyRooms, numToCheck, "k", true) -- Check if this room is a valid spawn. If yes, don't generate there again.
	table.remove(validKeyRooms, idx)
	if table.getn(validKeyRooms) == 0 then
      Game.Log("VALID KEYS EMPTY!!! Inserting spawn room")
	  panicCount = 1
      table.insert(validKeyRooms, spawnRoom)
    end
	local keySpawnRoomIDX = math.random(1, table.getn(validKeyRooms))
	local keySpawnRoomVAL = validKeyRooms[keySpawnRoomIDX]
	while RoomTable[keySpawnRoomVAL].assignedKey ~= "" and table.getn(validKeyRooms) > 1 do
	  table.remove(validKeyRooms, keySpawnRoomIDX)
	  keySpawnRoomIDX = math.random(1, table.getn(validKeyRooms))
	  keySpawnRoomVAL = validKeyRooms[keySpawnRoomIDX]
	end
	if table.getn(validKeyRooms) == 0 then
	  Game.Log("ERROR: OUT OF VALID KEY ROOMS!!!")
	  isGen = false --Bit of a hacky fix. Rerolls the dungeon layout.
	  return
	end
	Game.Log("Generated KEY in: " .. keySpawnRoomVAL)
	RoomTable[keySpawnRoomVAL].assignedKey = currentDoor.doorType
	table.insert(startList, "Key" .. keySpawnRoomVAL)
	table.remove(validKeyRooms, keySpawnRoomIDX)
end

function ReportKeys(myRoom, newRoom)
  local checkMyDoor, checkConnectingDoor = "", ""
  local myNum, newNum = myRoom.number, newRoom.number
  local validKeyRooms = copyTable(PathArray)
  for k, v in ipairs(validKeyRooms) do
    if v == bossRoom then
	  table.remove(validKeyRooms, k)
	  break
	end
  end
  for k, v in pairs(myRoom.borders) do
    if v == newNum then
	  checkMyDoor = k .. "Door" .. myNum
	  checkConnectingDoor = GetLinkedDirection(k) .. "Door" .. newNum
	  break
	end
  end
  for i = 1, 4 do
    local currentDoor, nextDoor = myRoom.doors[i], newRoom.doors[i]
	if currentDoor.name == checkMyDoor and checkAddIndex(KeyTable.AvailableKeys, currentDoor.doorType, "k", true) then
	  Game.Log("MyDoor: " .. checkMyDoor)
	  if not checkAddIndex(DoorsWithKeys, checkMyDoor, "v") then
	    keyCreate(myNum, currentDoor, validKeyRooms)
	  end
	end
	if nextDoor.name == checkConnectingDoor and checkAddIndex(KeyTable.AvailableKeys, nextDoor.doorType, "k", true) then
	  Game.Log("Con. Door: " .. checkConnectingDoor)
	  if not checkAddIndex(DoorsWithKeys, checkConnectingDoor, "v") then
	    keyCreate(newNum, nextDoor, validKeyRooms)
	  end
	end
  end
end

function MakeRemainingKeys()
  local validKeyRooms = copyTable(PathArray)
  for vit = 1, 9 do
    local myRoom = RoomTable[vit]
	for i = 1, 4 do
	  local myDoor = myRoom.doors[i]
	  if checkAddIndex(KeyTable.AvailableKeys, myDoor.doorType, "k", true) and not checkAddIndex(DoorsWithKeys, myDoor.name, "v") then
	    keyCreate(myRoom.number, myDoor, validKeyRooms)
	  end
	end
  end
end

exDebug = 0
addExtraPath = false
doorKillCount = 0
function PathFind(curRoom, lastRoom, newDestination)
  exDebug = exDebug + 1
  if exDebug >= 50 then
    Game.Log("EX HIT!!!!!!!!!")
	isGen = false -- Took too many steps to find a route through, likely an unbeatable layout. Reroll.
	return
  end
  local myNum, bossNum = curRoom, newDestination or bossRoom
  local compareRooms = CheckBorders(RoomTable[myNum], lastRoom)
  if table.getn(compareRooms) == 0 then
    Game.Log("NO ENTRIES!!!!")
	isGen = false -- Generation failed, reroll.
	return
  end
  local lowestNum = 99
  local stepCount = 99
  local branchCheck = {}
  local presentCheck, maxCheck = 0, table.getn(compareRooms)
  if maxCheck == 1 then
    Game.Log("1 border. Forcing Blacklist: " .. myNum)
    checkAddIndex(PathBlacklist, myNum, "v")
	RoomTable[myNum].blacklist = true
  end
  for k, v in ipairs(compareRooms) do
    if checkAddIndex(PathArray, v, "v", true) then
	  presentCheck = presentCheck + 1
	end
    if checkAddIndex(PathBlacklist, v, "v", true) == true then
	  Game.Log("The comparison, " .. v .. " is a Blacklist")
	  if maxCheck == 1 then
	    if v == lastRoom then
	      lowestNum = lastRoom
		else
		  lowestNum = v
		end
	  end
    elseif v == bossNum then
	  lowestNum = v -- Found boss room
	  break
	elseif math.abs(bossNum - v) <= stepCount then --and v ~= lastRoom
	  local check = math.abs(bossNum - v)
	  if maxCheck == 1 then
		if v == lastRoom then
		  lowestNum = lastRoom
		else
		  lowestNum = v
		end
	  elseif v ~= lastRoom then
	    if check < stepCount then
		  if checkAddIndex(PathArray, v, "v", true) then -- Bias towards unvisited rooms.
		    local prevR, nextR = compareRooms[k-1], compareRooms[k+1]
			if nextR ~= nil then
			  lowestNum = checkAddIndex(PathArray, nextR, "v", true) and prevR or nextR
			  break -- If next possible border has been visited, go to the previous border. Otherwise, go to that new border.
			else
			  lowestNum = not checkAddIndex(PathArray, prevR, "v", true) and prevR or v
			  break -- If the next border doesn't exist, and the previous border hasn't been visited, go to that border.
			end
		  end
	      stepCount = math.abs(bossNum - v)
	      lowestNum = v
	    elseif check == stepCount then
	      branchCheck[1] = lowestNum
		  branchCheck[2] = v
		  lowestNum = CheckBranches(branchCheck, bossNum)
		  --return
		end
	  else
	    if maxCheck <= 1 then
	      lowestNum = v -- Basically a failsafe
		end
	  end
	end
	if presentCheck >= maxCheck then
	  Game.Log("ALL ROOMS BLACKLISTED: " .. myNum)
	  checkAddIndex(PathBlacklist, myNum, "v")
	  RoomTable[myNum].blacklist = true
	end
  end
  Game.Log("Moving to room: " .. lowestNum)
  if lowestNum ~= 99 then
    checkAddIndex(PathArray, lowestNum, "v")
	--table.insert(PathArray, lowestNum)
  else
    Game.Log("STEPCOUNT: " .. stepCount)
    Game.Log("It's 99")
	return
  end
  if lowestNum == bossNum then
    Game.Log("Found boss")
	if table.getn(PathArray) < 5 then -- Attempt to force 5 minimum rooms (including boss, excluding spawn) in the Crit Path
	  Game.Log("<<<Time to get funky>>>")
	  --VVV SANITY CHECK VVV--
	  RoomTable[bossRoom].blacklist = true
	  checkAddIndex(PathBlacklist, bossRoom, "v")
	  --^^^ SANITY CHECK ^^^--
	  local newDest = math.random(1,9)
	  while checkAddIndex(PathArray, newDest, "v", true) do
	    newDest = math.random(1,9)
	  end
	  Game.Log("!!! PATHING TO: " .. newDest .. " !!!")
	  addExtraPath = true
	  ReportKeys(RoomTable[myNum], RoomTable[lowestNum])
	  return PathFind(myNum, lowestNum, newDest) -- Adding these backwards so that it doesn't try to path through the boss room.
	end
	for k, v in pairs(PathArray) do -- Previously this just said "Found boss" and printed the path
	  Game.Log("PATH TAKEN: " .. v)
	end
	addExtraPath = false
	return MakeRemainingKeys()
  elseif addExtraPath and table.getn(PathArray) >= 5 then
    ReportKeys(RoomTable[myNum], RoomTable[lowestNum])
    --Game.Log("Ending extra pathfind...")
	addExtraPath = false
	for k, v in pairs(PathArray) do
	  Game.Log("PATH TAKEN: " .. v)
	end
	return MakeRemainingKeys()
  end
  --Game.Log("lastRoom is: " .. myNum)
  ReportKeys(RoomTable[myNum], RoomTable[lowestNum])
  if addExtraPath then
    return PathFind(lowestNum, myNum, newDestination) --Even this is extra. Previously, it just did the return PathFind(lowest, my)
  else
    return PathFind(lowestNum, myNum)
  end
end

dirToNum = {
  North = 1,
  South = 2,
  West = 3,
  East = 4
}
function CheckBranches(bCheck, bRoom) 
  Game.Log("Checking Branches :D")
  local room1, room2 = bCheck[1], bCheck[2]
  Game.Log("R1 is: " .. room1)
  Game.Log("R2 is: " .. room2)
  Game.Log("Boss value: " .. bRoom)
  for k, v in pairs(RoomTable[room1].borders) do
    --Game.Log("Room 1 border value: " .. v)
    if v == bRoom then
	  local dirNumRef = dirToNum[k]
	  if RoomTable[room1].doors[dirNumRef].status ~= false then
	    return room1
	  end
	end
  end
  for k, v in pairs(RoomTable[room2].borders) do
    --Game.Log("Room 2 border value: " .. v)
    if v == bRoom then
	  local dirNumRef = dirToNum[k]
	  if RoomTable[room2].doors[dirNumRef].status ~= false then
	    return room2
	  end
	end
  end
  Game.Log("It's no use")
  return math.random() < 0.5 and room1 or room2
end

function CheckBorders(myRoom, lNum)
  local validRooms = {}
  local compareRooms = {}
  for i = 1, 4 do
	if myRoom.doors[i].status ~= false then
	  table.insert(validRooms, myRoom.doors[i].dir)
	end
  end
  if table.getn(validRooms) == 0 then
    Game.Log("VALID ROOMS IS 0")
	return compareRooms
  end
  for i = 1, table.getn(validRooms) do
    local border = validRooms[i]
    if type(myRoom.borders[border]) == "number" then 
	  local borderRoom = myRoom.borders[border]
	  if RoomTable[borderRoom].blacklist == false then
	    --Game.Log("Added: " .. myRoom.borders[border])
	    table.insert(compareRooms, myRoom.borders[border]) --Indices are numeric indices for RoomTable. Rooms, basically
	  end
	end
  end
  return compareRooms
end

signalList = {}
startList = {}
isGen = true
function Generate()
  isGen = true -- Flags the generation as viable. Rerolls the dungeon if this is false at the end of generation.
  isBossFight = false
  spawnRoom = 1 -- Default value, gets overwritten in SetRoomType
  attackLevel = 1 -- Used in the level_handler file.
  skillLevel = 1
  expPoints = 0
  defaultSmash = false -- Makes enemies sustain "Smash" damage (heavy KB, different on_damage behavior) when hit by regular attacks.
  signalList = {} -- ObjNames to run Game.Signal on if generation succeeds
  startList = {} -- ObjNames to run Game.StartEntityByName on if generation succeeds
  for i = 1, 9 do
    RoomTable[i] = {
      name = "Room_" .. i,
      number = i,
	  roomType = "",
      position = GetPosition(i),
	  doors = {},
      borders = SetBorders(GetPosition(i), i),
	  blacklist = false,
	  assignedKey = "",
	  threat_level = 0,
	  custom_track = "",
	  custom_lighting = "",
	  ExtraData = {}
    }
	DoorTable["NorthDoor" .. i] = true
	DoorTable["SouthDoor" .. i] = true
	DoorTable["EastDoor" .. i] = true
	DoorTable["WestDoor" .. i] = true
  end
    KeyTable = {
	  Color = {"Red", "Blue", "Green"},
	  Shape = {"Triangle", "Shield", "Crescent"},
	  PossibleKeys = {}, --All key permutations, indexed as an array
	  AvailableKeys = {}, --List of keys spawned in the dungeon, indexed as a dictionary where each value is True or False
	  aKeysCopy = {}, --A copy of AvailableKeys but indexed as an array. Used to set up AvailableKeys (pulls a random value from here, removes it)
	  findSequence = {
		hasFound = {},
		foundOrder = {}
	  }
	}
  for _, color in pairs(KeyTable.Color) do
    for _, shape in pairs(KeyTable.Shape) do
	  table.insert(KeyTable.PossibleKeys, color .. shape)
	end
  end
  local _, idx = checkAddIndex(KeyTable.PossibleKeys, "GreenTriangle", "kv", true) -- These two keys shouldn't be used
  table.remove(KeyTable.PossibleKeys, idx)
  _, idx = checkAddIndex(KeyTable.PossibleKeys, "GreenCrescent", "kv", true)
  table.remove(KeyTable.PossibleKeys, idx)
PuzzleTable = {
  currentPuzzles = 0,
  maxPuzzles = 7,
  invalidRooms = {[4] = true, [9] = true}, -- Rooms that do not currently have any possible puzzle assigned to them
  validPuzzles = {"Cooking", "Maze", "LostWoods", "Stealth", "Levers", "Crystal", "Rescue"}, -- Choose one of these at random
  Cooking = {
    puzzleType = "Cooking",
    ObjectSet = "pzl_Cook_", -- Group name to activate. Concatenate with AssignedRoom.
	AssignedRoom = 0, -- Room that generated this puzzle
	ValidRooms = {2}, -- Rooms in which this puzzle can spawn
	AssignedRecipe = "",
	relevantEvents = {get_lemon = "Lemon", get_apple = "Apple", get_water = "Water", deposit_item = "ClearCheck"}, -- Pass the assigned ingredient on event
	Ingredients = {Apple = 0, Lemon = 0, Water = 0, held = 0, maxNum = 4}, -- Ingredients currently held along with the max you can hold.
	Recipes = { -- Choose one of these at random for the item requirement.
	  Apple = {Apple = 3, Lemon = 0, Water = 1},
	  Lemon = {Apple = 0, Lemon = 3, Water = 1},
	  Water = {Apple = 0, Lemon = 0, Water = 4},
	  Mixed = {Apple = 2, Lemon = 2, Water = 0},
	  possibleRecipes = {"Apple", "Lemon", "Water", "Mixed"} -- Allows picking a recipe at random
	},
	PuzzleSounds = { -- Play these when a relevantEvent is called
	  get_lemon = {sbk = "enemy_monster_common", sfx = "monster_collision"},
	  get_apple = {sbk = "enemy_monster_common", sfx = "monster_collision"},
	  get_water = {sbk = "stage_twn", sfx = "gondola_go"},
	  deposit_item = {sbk = "enemy_monster_common", sfx = "monster_collision"}
	},
	hasClear == false,
	bgm = "",
	lighting = "",
	ClearEvent = {}
  },
  Maze = {
    puzzleType = "Maze",
	ObjectSet = "pzl_Maze_",
	AssignedRoom = 0,
	ValidRooms = {5},
	relevantEvents = {enter_maze = true, exit_maze = true, get_maze_key = true, add_maze_key = true},
	maze_key_count = 0,
	total_keys = 0,
	activeFlames = {false, false, false, false, false},
	PuzzleSounds = {
	  enter_maze = {sbk = "boss_mefiress", sfx = "zakoress_fly"},
	  get_maze_key = {sbk = "boss_mefiress", sfx = "zakoress_fly"}
	},
	bgm = "ambient_maze", --W13
	lighting = "",
	hasClear = false
  },
  LostWoods = {
    puzzleType = "LostWoods",
	ObjectSet = "pzl_LostWoods_",
	AssignedRoom = 0,
	ValidRooms = {1},
	relevantEvents = {PuzzleClear = true},
	PuzzleSounds = {},
	bgm = "none",
	lighting = "",
	hasClear = false
  },
  Stealth = {
    puzzleType = "Stealth",
	ObjectSet = "pzl_Stealth_",
	AssignedRoom = 0,
	ValidRooms = {6},
	relevantEvents = {PlayerFound = true, PuzzleClear = true, AllKilled = true},
	PuzzleSounds = {
	  PlayerFound = {sbk = "obj_common", sfx = "laser_gate"}
	},
	bgm = "",
	lighting = "Light_Orange",
	hasClear = false
  },
  Levers = {
    puzzleType = "Levers",
	ObjectSet = "pzl_Levers_",
	AssignedRoom = 0,
	ValidRooms = {7},
	relevantEvents = {PuzzleClear = true},
	PuzzleSounds = {},
	bgm = "",
	lighting = "",
	hasClear = false
  },
  Crystal = {
	puzzleType = "Crystal",
	ObjectSet = "pzl_Crystal_",
	AssignedRoom = 0,
	ValidRooms = {8},
	relevantEvents = {add_WoodBox_Test = true, InsideRoom = true},
	TEV = {event = "crystal", timer = 1.25, SimulCount = 0},
	PuzzleSounds = {},
	bgm = "",
	lighting = "",
	hasClear = false
  },
  Rescue = {
    puzzleType = "Rescue",
	ObjectSet = "pzl_Rescue_",
	AssignedRoom = 0,
	ValidRooms = {3},
	relevantEvents = {Rescue1 = true, Rescue2 = true, Rescue3 = true, Rescue4 = true},
	AssignedPattern = {progress = 0},
	PuzzleSounds = {},
	bgm = "",
	lighting = "",
	hasClear = false
  }
}
ambientSFX = {
  {enabled = false, bank = "boss_mefiress", id = "zakoress_appear", timer = 0, interval = 45}, --laugh
  {enabled = false, bank = "enemy_monster_common", id = "explode_small", timer = 0, interval = 5}, --thud
  {enabled = false, bank = "boss_solaris", id = "appear_voice", timer = 0, interval = 4.5, oneshot = true},
  {enabled = false, bank = "stage_twn", id = "rock_brk", timer = 0, interval = 3, oneshot = true},
  {enabled = false, bank = "boss_mefiress", id = "kyozoress_dead", timer = 0, interval = 50, oneshot = true},
  {enabled = false, bank = "stage_twn_voice", id = "dog_wait", timer = 0, interval = 15} --Pele
}
  SpawnDoors()
  SetRoomType()
  SetSelfDoors()
  PathArray = {}
  PathBlacklist = {}
  DoorsWithKeys = {}
  doorKillCount = 0 -- Unused
  currentPlayer = "Sonic"
  uniqueRooms = {} -- Unique rooms visited during this attempt
  exDebug = 0
  barrelCount = 0 -- (Unused) Meant for clearing guardian door hints
  lockedCount = 0
  addExtraPath = false
  hasVisitedBossDoor = false
  lastLight = ""
  currentLight = ""
  changeLighting = false
  lightTimer = 0
  puzzleTimer = 0
  doSFX = false
  b_sfxTimer1 = 0
  b_sfxTimer2 = 0
  warpID = 0
  usePuzzleTimer = false
  hasVoiced = false
  curPuzzle = ""
  currentTrack, trackTimer, trackLength, trackPause = "", 10, 0, false
  trackDelay = 5 + math.random(1, 5)
  lastDir = ""
  hallwayOpen = false
  local dbgStat, err = pcall(PathFind, spawnRoom, 0)
  Game.Log("ERROR CHECKING: " .. tostring(err))
  if not dbgStat then
    Game.Log("Nope")
  end
  if not isGen then
    return Generate()
  end
  for k, v in ipairs(startList) do
    Game.StartEntityByName(v)
  end
  for k, v in ipairs(signalList) do
    Game.Signal(v)
  end
end