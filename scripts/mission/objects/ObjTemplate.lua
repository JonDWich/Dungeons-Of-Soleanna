--$ OBJECT TEMPLATE $--

Inventory = {itemLimit = 15, count = 0}
itemList = {count = 0}
Item = {}
function Item.constructor(_ARG_0_, buildTable, params)
  if itemList[params.itemName] ~= nil then
    printf("Object present. Returning.")
    return
  end
  printf("New object. Constructing.")
  buildTable.Name = params.itemName or "Generic"
  buildTable.Type = params.itemType or "Common"
  buildTable.Description = buildTable.Name .. "_Description"
  --buildTable.Rarity = SetRarity(_ARG_0_, params.Rarity)
  buildTable.OnPickup = search(_ARG_0_, buildTable, "OnItemGet") --Adds the search property for this function. Metatable behavior.
  buildTable.Setup = search(_ARG_0_, buildTable, "Setup")
  buildTable.Quantity = 0
  itemList[buildTable.Name] = buildTable
  itemList.count = itemList.count + 1
end

function SetRarity(_ARG_0_, value)
  if value ~= nil then
    if value.Legendary == nil then
	  return value
	end
    local rarityValue = math.random(1,100)
	if rarityValue <= value.Legendary then
	  return "Legendary"
	elseif rarityValue <= value.Rare then
	  return "Rare"
	elseif rarityValue <= value.Uncommon then
	  return "Uncommon"
	else
	  return "Common"
	end
  else
    local rarityValue = math.random(1,100)
	if rarityValue <= 20 then
	  return "Legendary"
	elseif rarityValue <= 45 then
	  return "Rare"
	elseif rarityValue <= 65 then
	  return "Uncommon"
	else
	  return "Common"
	end
  end
end

function Item.OnItemGet(_ARG_0_, itemRef)
  printf("Got item")
end

function Item.Setup(_ARG_0_, tabl)
  printf("Item setup")
end

function inherit(_ARG_0_, lookup)
  local proto = {_index = lookup}
  proto.new = function(_ARG_0_, Name, Type, Rarity)
    local newTable = {_index = proto}
	--printf("Type is: " .. type(search(_ARG_0_, newTable, "constructor")))
	search(_ARG_0_, newTable, "constructor")(_ARG_0_, newTable, {itemName = Name, itemType = Type, Rarity = Rarity})
	return newTable
  end
  return proto
end
function search(_ARG_0_, fTable, locate)
  if fTable[locate] then 
    return fTable[locate]
  elseif fTable._index then
    local nextLayer = fTable._index
	if nextLayer[locate] then
	  return nextLayer[locate]
	elseif nextLayer._index then
	  return search(_ARG_0_, nextLayer, locate)
	else
	  return false
	end
  end
end

baseItem = inherit(_ARG_0_, Item)
function baseItem.constructor(_ARG_0_, tabl, params)
  Item.constructor(_ARG_0_, tabl, params)
end

function baseItem.Setup(_ARG_0_, tabl)
  Item.Setup(_ARG_0_, tabl)
  printf("Setup base item")
end

Gem = inherit(_ARG_0_, baseItem)
script.reload("scripts/mission/objects/gem.lua")
function Initiate(_ARG_0_)
  Inventory = {itemLimit = 15, count = 0}
  itemList = {count = 0}
  --Apple = baseItem.new(_ARG_0_, "Apple", "Fruit", "Common")
  --Lemon = baseItem.new(_ARG_0_, "Lemon", "Fruit", "Common")
  Initiate_Gem(_ARG_0_)
  UnIDWeapon = baseItem.new(_ARG_0_, "Weapon", "Upgrade", "Rare")
  StunBlade = Gem.new(_ARG_0_, "StunBlade", "Upgrade", "Legendary")
  HeavyBand = Gem.new(_ARG_0_, "HeavyBand", "Upgrade", "Legendary")
  StunBlade.Setup(_ARG_0_, StunBlade, 13)
  HeavyBand.Setup(_ARG_0_, HeavyBand, 14)
  RegenAmulet = Gem.new(_ARG_0_, "RegenAmulet", "Upgrade", "Legendary")
  DamageAmulet = Gem.new(_ARG_0_, "DamageAmulet", "Upgrade", "Legendary")
  FatalAmulet = Gem.new(_ARG_0_, "FatalAmulet", "Upgrade", "Legendary")
  SolarisAmulet = Gem.new(_ARG_0_, "SolarisAmulet", "Upgrade", "Legendary")
  RegenAmulet.Setup(_ARG_0_, RegenAmulet, 15)
  DamageAmulet.Setup(_ARG_0_, DamageAmulet, 16)
  FatalAmulet.Setup(_ARG_0_, FatalAmulet, 17)
  SolarisAmulet.Setup(_ARG_0_, SolarisAmulet, 18)
  --Ring = baseItem.new(_ARG_0_, "Ring", "Collectable", "Common")
  --UnIDGem = baseItem.new(_ARG_0_, "Gem", "Collectable", "Rare")
  --[[on_object_grab(_ARG_0_, "Apple")
  on_object_grab(_ARG_0_, "Lemon")
  on_object_grab(_ARG_0_, "Lemon")
  on_object_grab(_ARG_0_, "Ring")
  inventory_setup(_ARG_0_, "Open_Inventory")]]
end

function on_object_grab(_ARG_0_, Pickup)
  g_message_setuped = ""
  if itemList[Pickup] then
    for i = 1, Inventory.count do
      if Inventory[i].Name == Pickup then
	    printf("Object in Inventory: " .. Pickup)
	    Inventory[i].Quantity = Inventory[i].Quantity + 1
        Inventory[i].OnPickup(_ARG_0_, Inventory[i])
	    return
	  end
    end
    if Inventory.count < Inventory.itemLimit then
	  printf("Object not found. Adding: " .. Pickup)
      Inventory[Inventory.count + 1] = itemList[Pickup]
	  Inventory.count = Inventory.count + 1
	  Inventory[Inventory.count].Quantity = 1
	  Inventory[Inventory.count].OnPickup(_ARG_0_, Inventory[Inventory.count])
    else
	  printf("No space for item: " .. Pickup)
	  return
    end
  else
    return false
  end
end

function inventory_check(itemName) -- Bit weak since this only checks for an item by name. This can be expanded, I just don't need to at the moment.
  for i = 1, Inventory.count do
    local name = Inventory[i].Name
	if name == itemName and Inventory[i].Quantity > 0 then
	  return true, Inventory[i]
	end
  end
  return false
end

EmptySlot = {
  name = "Empty",
  price = 1,
  explain = "EmptyDescription",
  event = "buy100"
}
function inventory_setup(_ARG_0_, msg)
  if msg == "Open_Inventory" or msg == "shop" then
    printf("Opening inventory")
	SetupItems = {count = 0}
    for i = 1, Inventory.count do
      index = SetupItems.count + 1
      SetupItems[index] = {}
	  SetupItems[index].name = Inventory[i].Name
	  SetupItems[index].price = Inventory[i].Quantity
	  SetupItems[index].explain = Inventory[i].Description
	  SetupItems[index].event = "buy100"
	  SetupItems.count = index
    end
    inventoryWindow  = {
      {
        message_first = "OpenInventory",
        message_agree = "UseCancelWindow",
        message_buy_item = "",
        message_cancel_item = "CancelUse",
        message_second = "InventorySecond",
        message_no_money = "UseAgree",
        message_soldout = "",
        message_end = "CloseInventory"
      },
	  SetupItems[1]  or EmptySlot,
	  SetupItems[2]  or EmptySlot,
	  SetupItems[3]  or EmptySlot,
	  SetupItems[4]  or EmptySlot,
      SetupItems[5]  or EmptySlot,
	  SetupItems[6]  or EmptySlot,
	  SetupItems[7]  or EmptySlot,
	  SetupItems[8]  or EmptySlot,
	  SetupItems[9]  or EmptySlot,
	  SetupItems[10] or EmptySlot,
	  SetupItems[11] or EmptySlot,
	  SetupItems[12] or EmptySlot,
	  SetupItems[13] or EmptySlot,
	  SetupItems[14] or EmptySlot,
	  SetupItems[15] or EmptySlot
    }
	g_message_setuped = ""
    OpenShop(_ARG_0_, "inventoryWindow")
	--return true
  else
    return false
  end
end

function setup_binds(_ARG_0_)
  bindSetup = {count = 1}
  for i = 1, Inventory.count do
    idx_A = bindSetup.count + 1
	if Inventory[i].Quantity > 0 and Inventory[i].Name ~= "Weapon" and Inventory[i].Name ~= "Gem" then
	  printf(Inventory[i].Name)
      bindSetup[i] = {}
	  bindSetup[i].name = Inventory[i].Name
	  bindSetup[i].price = 0
	  bindSetup[i].explain = Inventory[i].Description
	  bindSetup[i].event = Inventory[i].Name
	  bindSetup.count = bindSetup.count + 1
	end
  end
  bindWindow = {
    {
      message_first = "bind_open",
      message_agree = "bind_select",
      message_buy_item = "bind_confirm",
      message_cancel_item = "bind_UseCancel",
      message_second = "bind_UseCancel",
      message_no_money = "bind_UseCancel",
      message_soldout = "msg_shop_011",
      message_end = "bind_close"
    },
	{
	  name = "bind_info",
	  price = 1,
	  explain = "bind_info_2",
	  event = "buy100"
    },
	bindSetup[2] or EmptySlot,
	bindSetup[3] or EmptySlot,
	bindSetup[4] or EmptySlot,
	bindSetup[5] or EmptySlot,
	bindSetup[6] or EmptySlot,
	bindSetup[7] or EmptySlot,
	bindSetup[8] or EmptySlot,
	bindSetup[9] or EmptySlot,
	bindSetup[10] or EmptySlot,
	bindSetup[11] or EmptySlot,
	bindSetup[12] or EmptySlot,
	bindSetup[13] or EmptySlot,
	bindSetup[14] or EmptySlot,
	bindSetup[15] or EmptySlot,
	bindSetup[16] or EmptySlot
  }
  OpenShop(_ARG_0_, "bindWindow")
end

bindList = {
  ["StunBlade"] = {flagVal = 1},
  ["HeavyBand"] = {flagVal = 2},
  ["RegenAmulet"] = {flagVal = 3},
  ["DamageAmulet"] = {flagVal = 4},
  ["FatalAmulet"] = {flagVal = 5},
  ["SolarisAmulet"] = {flagVal = 6},
  ["BlueGem"] = {flagVal = 9},
  ["GreenGem"] = {flagVal = 7},
  ["YellowGem"] = {flagVal = 11},
  ["WhiteGem"] = {flagVal = 10},
  ["RedGem"] = {flagVal = 8}
}

function bind_event(_ARG_0_, event)
  if bindList[event] then
    SetGlobalFlag(_ARG_0_, 2, bindList[event].flagVal)
	return true
  else
    return false
  end
end