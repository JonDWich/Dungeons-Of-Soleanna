--$ UPGRADE ITEM TEMPLATE $--

function Gem.constructor(_ARG_0_, table, params)
  baseItem.constructor(_ARG_0_, table, params)
end

function Gem.Setup(_ARG_0_, table, myFlag)
  baseItem.Setup(_ARG_0_, table)
  table.flag = myFlag
end

function Gem.OnItemGet(_ARG_0_, itemRef)
  printf("Got gem")
  SetGlobalFlag(_ARG_0_, itemRef.flag, 1)
end

function Initiate_Gem(_ARG_0_)
  UnIDGem = baseItem.new(_ARG_0_, "Gem", "Collectable", "Rare")
  BlueGem = Gem.new(_ARG_0_, "BlueGem", "Upgrade", "Rare")
  BlueGem.Setup(_ARG_0_, BlueGem, 6006)
  GreenGem = Gem.new(_ARG_0_, "GreenGem", "Upgrade", "Rare")
  GreenGem.Setup(_ARG_0_, GreenGem, 6004)
  RedGem = Gem.new(_ARG_0_, "RedGem", "Upgrade", "Rare")
  RedGem.Setup(_ARG_0_, RedGem, 6005)
  YellowGem = Gem.new(_ARG_0_, "YellowGem", "Upgrade", "Rare")
  YellowGem.Setup(_ARG_0_, YellowGem, 6009)
  WhiteGem = Gem.new(_ARG_0_, "WhiteGem", "Upgrade", "Rare")
  WhiteGem.Setup(_ARG_0_, WhiteGem, 6007)
end