--$ PUZZLE EVENTS $--
-- Most puzzle behavior is handled in "scripts/stage/game.lua", but NPC interactions
-- for the Cooking puzzle need to be handled in the Mission instance.
-- Also displays hints when clearing the puzzle.

recipe = ""
invCount = 0
maze_key_count = 0
cook_status = 1 --1 for the initial request, 2 for the cook.
recipeIDRef = ""
currentRecipe = {count = 0}
select_general = {
  {
    name = "msg_m1000_001_01_1",
    event = "accept"
  },
  {
    name = "msg_m1000_002_01_1",
    event = "deny"
  }
}

NPCTable = {
  Cooking = {
    name = "cooking_name_2",
	icon = 4,
	animation = {action = "talk_aseri", sound = "normal"},
	animation2 = {action = "talk1", sound = "normal"},
	dialogue = {
	  ["cooking_intro"] = "cooking_intro",
	  ["cooking_lemon_1"] = "cooking_lemon_1",
	  ["cooking_apple_1"] = "cooking_apple_1",
	  ["cooking_water_1"] = "cooking_water_1",
	  ["cooking_mixed_1"] = "cooking_mixed_1",
	  ["recipe2"] = "cooking_solved_intro",
	  ["cooking_solved_intro"] = "cooking_solved_intro",
	  ["cooking_solved_accept"] = "cooking_solved_accept",
	  ["check_cook"] = "check_cook",
	  ["cooking_solved_bonus"] = "cooking_solved_bonus",
	  dialogue_state = "cooking_intro"
	}
  }
}

CookEventID = { --Pass when recipe gens
  add_twn_lemon = {"cooking_lemon_1", "cooking_lemon_recipe"},
  add_twn_apple = {"cooking_apple_1", "cooking_apple_recipe"},
  add_twn_gondola = {"cooking_water_1", "cooking_water_recipe"},
  add_twn_corn = {"cooking_mixed_1", "cooking_lemon_recipe"}
}

cooking_shop = {
  {
    message_first = "cooking_open",
    message_agree = "cooking_select",
    message_buy_item = "cooking_agree",
    message_cancel_item = "cooking_UseCancel",
    message_second = "cooking_UseCancel",
    message_no_money = "msg_shop_008",
    message_soldout = "msg_shop_011",
    message_end = "cooking_close"
  },
  {
	name = "Recipe",
	price = 0,
	explain = recipe,
	event = "buy_none"
  },
  {
    name = "Apple",
    price = 0,
    explain = "Apple_Description",
    event = "buy_apple"
  },
  {
    name = "Lemon",
    price = 0,
    explain = "Lemon_Description",
    event = "buy_lemon"
  },
  {
    name = "Water",
    price = 0,
    explain = "Water_Description",
    event = "buy_water"
  },
  {
    name = "Pound",
    price = 0,
    explain = "Pound_Description",
    event = "buy_pound"
  },
  {
    name = "Pray",
    price = 0,
    explain = "Pray_Description",
    event = "buy_pray"
  },
  {
    name = "Heat",
    price = 0,
    explain = "Heat_Description",
    event = "buy_heat"
  },
  {
    name = "Stir",
    price = 0,
    explain = "Stir_Description",
    event = "buy_stir"
  }
}

BakingEvents = {
  buy_apple = "Apple",
  buy_lemon = "Lemon",
  buy_water = "Water",
  buy_pound = "Pound",
  buy_pray = "Pray",
  buy_heat = "Heat",
  buy_stir = "Stir"
}

CookingHints = {
  get_apple = "Apple_Get",
  get_lemon = "Lemon_Get",
  get_water = "Water_Get"
}

RecipeTable = {
  cooking_lemon_recipe = {"Lemon", "Pound", "Water", "Stir", count = 4},
  cooking_apple_recipe = {"Apple", "Pound", "Water", "Pray", count = 4},
  cooking_water_recipe = {"Water", "Pray", "Pound", "Heat", count = 4}
}

function puzzle_init(_ARG_0_)
  currentRecipe = {count = 0}
  invCount = 0
  maze_key_count = 0
  NPCTable.Cooking.dialogue.dialogue_state = "cooking_intro"
  printf("PUZZLE INIT")
end

function on_puzzle_event(_ARG_0_, evID)
  printf("Received ev: " .. evID)
  if evID == "PuzzleClear" then
    printf("Received message: CLEAR")
	--printf("Room check: " .. type(Rooms[currentRoom].puzzle))
    if Rooms[currentRoom].puzzle == "Cooking" then
	  NPCTable.Cooking.dialogue.dialogue_state = "cooking_solved_intro"
	  OpenHint(_ARG_0_, "Cooking_Solved")
	  cook_status = 2
	elseif Rooms[currentRoom].puzzle == "Maze" then
	  OpenHint(_ARG_0_, "Maze_Solved")
	elseif Rooms[currentRoom].puzzle == "LostWoods" then
	  OpenHint(_ARG_0_, "Woods_Solved")
	elseif Rooms[currentRoom].puzzle == "Stealth" then
	  OpenHint(_ARG_0_, "Stealth_Solved")
	elseif Rooms[currentRoom].puzzle == "Levers" then
	  OpenHint(_ARG_0_, "Levers_Solved")
	elseif Rooms[currentRoom].puzzle == "Crystal" then
	  OpenHint(_ARG_0_, "Crystal_Solved")
	elseif Rooms[currentRoom].puzzle == "Rescue" then
	  OpenHint(_ARG_0_, "Rescue_Solved")
	end
	return true
  elseif evID == "get_maze_key" then
    maze_key_count = maze_key_count + 1
	if maze_key_count == 1 or maze_key_count == 3 then
      MissionText(_ARG_0_, "fail")
	end
  elseif CookingHints[evID] then
    if invCount < 4 then
      invCount = invCount + 1
	  OpenHint(_ARG_0_, CookingHints[evID])
	else
	  OpenHint(_ARG_0_, "Cooking_Full")
	end
	return true
  elseif evID == "deposit_item" then
    invCount = 0
	return true
  elseif CookEventID[evID] then
    cook_status = 1 --Updating here rather than in Init because this runs first.
    recipeIDRef = CookEventID[evID]
    recipe = CookEventID[evID][cook_status]
	return true
  elseif evID == "accept_help" then
    if cook_status == 2 then
	  OpenWindow(_ARG_0_, "cooking_solved_accept")
	  NPCTable.Cooking.dialogue.dialogue_state = "check_cook"
	else
      OpenWindow(_ARG_0_, recipe)
	  NPCTable.Cooking.dialogue.dialogue_state = recipeIDRef[cook_status]
	end
	return true
  elseif evID == "deny_help" then
    OpenWindow(_ARG_0_, "cooking_deny")
	--InConvo = false
	return true
  elseif evID == "deny_cook" then
    OpenWindow(_ARG_0_, "cooking_solved_deny")
	--InConvo = false
	return true
  elseif BakingEvents[evID] then
    local idx = currentRecipe.count
	NPCTable.Cooking.dialogue.dialogue_state = "check_cook2"
	if idx < 4 then
	  idx = idx + 1
	  currentRecipe.count = currentRecipe.count + 1
	  currentRecipe[idx] = BakingEvents[evID]
	end
	return true
  end
  return false
end

function on_puzzle_icon(_ARG_0_, npcMsg)
  if NPCTable[npcMsg] then
    g_message_icon = NPCTable[npcMsg].icon
    return true
  else
    return false
  end
end

function on_puzzle_setup(_ARG_0_, npcMsg)
  if not NPCTable[npcMsg] then
    return false
  end
  if NPCTable.Cooking.dialogue.dialogue_state == "check_cook" then
    recipe = recipeIDRef[cook_status]
	cooking_shop[2].explain = recipe
	SetAnimationTalkWith(_ARG_0_, "talk0", "joy")
	g_name_setuped = "cooking_name_2"
    OpenShop(_ARG_0_, "cooking_shop")
	g_message_setuped = ""
	return true
  end
  local convoTable = NPCTable[npcMsg].dialogue
  local convoState = convoTable.dialogue_state
  local animRef = NPCTable[npcMsg].animation
  if cook_status == 2 then
    animRef = NPCTable[npcMsg].animation2
  end
  SetAnimationTalkWith(_ARG_0_, animRef.action, animRef.sound)
  g_name_setuped = NPCTable[npcMsg].name
  if convoState == "check_cook2" then
    local recRef = RecipeTable[recipe]
    if currentRecipe[1] == recRef[1] and currentRecipe[2] == recRef[2] and currentRecipe[3] == recRef[3] and currentRecipe[4] == recRef[4] then
	  SetAnimationTalkWith(_ARG_0_, "talk_joy", "normal")
	  g_message_setuped = "cooking_solved_bonus"
	  convoTable.dialogue_state = "cooking_solved_bonus"
	else
	  currentRecipe = {count = 0}
	  SetAnimationTalkWith(_ARG_0_, "talk_sad", "normal")
	  g_message_setuped = "cooking_solved_fail"
	end
	return true
  else
    g_message_setuped = convoState
    convoTable.dialogue_state = convoTable[convoState]
	return true
  end
  return false
end

function on_puzzle_close(_ARG_0_, textbox)
  if textbox == "cooking_intro" then
    select_general[1].event = "accept_help"
	select_general[2].event = "deny_help"
    OpenSelect(_ARG_0_, "select_general")
	return true
  elseif textbox == "cooking_solved_intro" then
    select_general[1].event = "accept_help"
	select_general[2].event = "deny_cook"
    OpenSelect(_ARG_0_, "select_general")
	return true
  elseif textbox == "cooking_solved_fail" then
    NPCTable.Cooking.dialogue.dialogue_state = "cooking_solved_intro"
	return true
  elseif textbox == "cooking_solved_bonus" then
    on_object_grab(_ARG_0_, "Gem")
	return true
  end
  return false
end
