----$Character upgrade logic$----
attackLevel = 1
skillLevel = 1
expPoints = 0
defaultSmash = false
expTable = {
  attack = {
	[1] = {expReq = 0, award = ""},
	[2] = {expReq = 3, award = "Pele"},
	[3] = {expReq = 6, award = ""}
  },
  skill = {
	[1] = {expReq = 0, award = ""},
	[2] = {expReq = 3, award = "Bound"},
	[3] = {expReq = 6, award = "Slide"}
  }
}

function UpgradeAttack()
  if attackLevel >= table.getn(expTable.attack) then
    Game.Log("Attack level is max!!!")
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "system", id = "cannot_deside"})
	return
  end
  local exp_to_level = expTable.attack[attackLevel + 1].expReq
  local unlock = expTable.attack[attackLevel + 1].award
  if exp_to_level > expPoints then
    Game.Log("Insufficient experience...")
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "system", id = "cannot_deside"})
	return
  else
    expPoints = expPoints - exp_to_level
	attackLevel = attackLevel + 1
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn", id = "mission_timesup"})
	Game.StartEntityByName("AttackUp" .. attackLevel) -- Notifies the Mission script to increase the needed exp. Used for displaying messages.
  end
  if unlock == "Pele" then -- Unlocks Pele, the beloved dog, as a companion for the rest of the run.
    Game.StartEntityByName("PeleSpawn")
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn_voice", id = "dog_bark"})
	ambientSFX[6].enabled = true -- Table is contained in game.lua
  end
end
function UpgradeSkill()
  if skillLevel >= table.getn(expTable.skill) then
    Game.Log("Skill level is max!!!")
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "system", id = "cannot_deside"})
	return
  end
  local exp_to_level = expTable.skill[skillLevel + 1].expReq
  local unlock = expTable.skill[skillLevel + 1].award
  if exp_to_level > expPoints then
    Game.Log("Insufficient experience...")
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "system", id = "cannot_deside"})
	return
  else
    expPoints = expPoints - exp_to_level
	skillLevel = skillLevel + 1
	Game.ProcessMessage("LEVEL", "PlaySE", {bank = "stage_twn", id = "mission_timesup"})
	Game.StartEntityByName("SkillUp" .. skillLevel) -- Notifies the Mission script to increase the needed exp. Used for displaying messages.
  end
end