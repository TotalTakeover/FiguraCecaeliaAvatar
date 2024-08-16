local defaultFlopSound = require("Config").flopSound or false
local syncedVariables = require("scripts.SyncedVariables")
local ticksOutOfWater = require("scripts.TicksOutOfWater")

local flopSound = defaultFlopSound

local wasInAir = false
function events.TICK()
  if flopSound and wasInAir and syncedVariables.ground and (player:getVelocity().y < 0) and ((ticksOutOfWater.wet < 400 and not player:isInWater()) or ticksOutOfWater.time > 0) then
    local volume = math.clamp((math.abs(-player:getVelocity().y + 1) * ((400 + -ticksOutOfWater.wet) / 400)) / 2, 0, 1)
    sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos(), volume, 0.75)
  end
  wasInAir = not syncedVariables.ground
end

local function setFlopSound(boolean)
  flopSound = boolean
  if player:isLoaded() then
    sounds:playSound("minecraft:entity.puffer_fish.flop", player:getPos())
  end
end

pings.setFlopSound = setFlopSound

setFlopSound(defaultFlopSound)
return action_wheel:newAction()
    :title("Toggle Floping Sound\n\n (Gradually gets quieter until after 20 seconds;\n no longer makes noise until player reenters water, resets.)")
    :item("minecraft:salmon")
    :toggleItem("minecraft:tropical_fish")
    :onToggle(pings.setFlopSound)
    :toggled(defaultFlopSound)