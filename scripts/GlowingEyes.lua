local model = models.OctopusMerling.Player.Head
local eyeParts = {
  model.Eyes,
}

local syncedVariables = require("scripts.SyncedVariables")
function pings.setEyeRenderType(boolean)
  local type = boolean and "EYES" or "NONE"
  for _, part in pairs(eyeParts) do
    part:setSecondaryRenderType(type)
  end
end

local glowingEyes = require("Config").glowingEyes
local getPowerData = require("lib.OriginsAPI").getPowerData
if glowingEyes == nil then
  function events.TICK()
    for _, part in pairs(eyeParts) do
      part:setSecondaryRenderType((syncedVariables.nV or getPowerData(player, "origins:water_vision") == 1) and "EYES" or "NONE")
    end
  end
else
  for _, part in pairs(eyeParts) do
    part:setSecondaryRenderType(glowingEyes and "EYES" or "NONE")
  end
  return action_wheel:newAction()
      :title("Toggle Glowing Eyes")
      :item("minecraft:prismarine_bricks")
      :toggleItem("minecraft:sea_lantern")
      :onToggle(pings.setEyeRenderType)
      :toggled(glowingEyes)
end
