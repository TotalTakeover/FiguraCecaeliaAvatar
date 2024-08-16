local spawnBubbles = require("Config").whirlPoolEffect
local syncedVariables = require("scripts.SyncedVariables")
function pings.setBubbles(boolean)
  spawnBubbles = boolean
  if player:isLoaded() then
    sounds:playSound("minecraft:block.bubble_column.upwards_inside", player:getPos())
  end
end

local numBubbles = 6
function events.TICK()
  if player:getPose() == "SWIMMING" and spawnBubbles and player:isInWater() then
    local worldMatrix = models:partToWorldMatrix()
    for i = 1, numBubbles do
      particles:newParticle("minecraft:bubble",
        (worldMatrix * matrices.rotation4(0, world.getTime() * 10 - 360/numBubbles * i)):apply(12.5)
      )
    end
  end
end

if spawnBubbles == nil then
  function events.TICK()
    spawnBubbles = syncedVariables.dG
  end
else
  return action_wheel:newAction()
      :title("Toggle Whirlpool Effect")
      :item("minecraft:potion{\"CustomPotionColor\":" .. tostring(0xFF0000) .. "}")
      :toggleItem("minecraft:potion{\"CustomPotionColor\":" .. tostring(0x00FF00) .. "}")
      :onToggle(pings.setBubbles)
      :toggled(spawnBubbles)
end