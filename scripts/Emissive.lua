local model = models.OctopusMerling.Player
local tail = model.Tail
local emissive = {
  tail.LowerBody_Glow,
  tail.LowerBodyLayer_Glow,
  -- Tentacle 1
  tail.Tentacle1.Limb_Glow,
  tail.Tentacle1.Layer_Glow,
  tail.Tentacle1.T1_1.Limb_Glow,
  tail.Tentacle1.T1_1.Layer_Glow,
  tail.Tentacle1.T1_1.T1_2.Limb_Glow,
  tail.Tentacle1.T1_1.T1_2.Layer_Glow,
  tail.Tentacle1.T1_1.T1_2.T1_3.Limb_Glow,
  tail.Tentacle1.T1_1.T1_2.T1_3.Layer_Glow,
  tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.Limb_Glow,
  tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.Layer_Glow,
  tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.T1_5.Limb_Glow,
  tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.T1_5.Layer_Glow,
  -- Tentacle 2
  tail.Tentacle2.Limb_Glow,
  tail.Tentacle2.Layer_Glow,
  tail.Tentacle2.T2_1.Limb_Glow,
  tail.Tentacle2.T2_1.Layer_Glow,
  tail.Tentacle2.T2_1.T2_2.Limb_Glow,
  tail.Tentacle2.T2_1.T2_2.Layer_Glow,
  tail.Tentacle2.T2_1.T2_2.T2_3.Limb_Glow,
  tail.Tentacle2.T2_1.T2_2.T2_3.Layer_Glow,
  tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.Limb_Glow,
  tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.Layer_Glow,
  tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5.Limb_Glow,
  tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5.Layer_Glow,
  -- Tentacle 3
  tail.Tentacle3.Limb_Glow,
  tail.Tentacle3.Layer_Glow,
  tail.Tentacle3.T3_1.Limb_Glow,
  tail.Tentacle3.T3_1.Layer_Glow,
  tail.Tentacle3.T3_1.T3_2.Limb_Glow,
  tail.Tentacle3.T3_1.T3_2.Layer_Glow,
  tail.Tentacle3.T3_1.T3_2.T3_3.Limb_Glow,
  tail.Tentacle3.T3_1.T3_2.T3_3.Layer_Glow,
  tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.Limb_Glow,
  tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.Layer_Glow,
  tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.T3_5.Limb_Glow,
  tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.T3_5.Layer_Glow,
  -- Tentacle 4
  tail.Tentacle4.Limb_Glow,
  tail.Tentacle4.Layer_Glow,
  tail.Tentacle4.T4_1.Limb_Glow,
  tail.Tentacle4.T4_1.Layer_Glow,
  tail.Tentacle4.T4_1.T4_2.Limb_Glow,
  tail.Tentacle4.T4_1.T4_2.Layer_Glow,
  tail.Tentacle4.T4_1.T4_2.T4_3.Limb_Glow,
  tail.Tentacle4.T4_1.T4_2.T4_3.Layer_Glow,
  tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.Limb_Glow,
  tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.Layer_Glow,
  tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.T4_5.Limb_Glow,
  tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.T4_5.Layer_Glow,
  -- Tentacle 5
  tail.Tentacle5.Limb_Glow,
  tail.Tentacle5.Layer_Glow,
  tail.Tentacle5.T5_1.Limb_Glow,
  tail.Tentacle5.T5_1.Layer_Glow,
  tail.Tentacle5.T5_1.T5_2.Limb_Glow,
  tail.Tentacle5.T5_1.T5_2.Layer_Glow,
  tail.Tentacle5.T5_1.T5_2.T5_3.Limb_Glow,
  tail.Tentacle5.T5_1.T5_2.T5_3.Layer_Glow,
  tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.Limb_Glow,
  tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.Layer_Glow,
  tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.T5_5.Limb_Glow,
  tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.T5_5.Layer_Glow,
  -- Tentacle 6
  tail.Tentacle6.Limb_Glow,
  tail.Tentacle6.Layer_Glow,
  tail.Tentacle6.T6_1.Limb_Glow,
  tail.Tentacle6.T6_1.Layer_Glow,
  tail.Tentacle6.T6_1.T6_2.Limb_Glow,
  tail.Tentacle6.T6_1.T6_2.Layer_Glow,
  tail.Tentacle6.T6_1.T6_2.T6_3.Limb_Glow,
  tail.Tentacle6.T6_1.T6_2.T6_3.Layer_Glow,
  tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.Limb_Glow,
  tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.Layer_Glow,
  tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.T6_5.Limb_Glow,
  tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.T6_5.Layer_Glow,
  -- Tentacle 7
  tail.Tentacle7.Limb_Glow,
  tail.Tentacle7.Layer_Glow,
  tail.Tentacle7.T7_1.Limb_Glow,
  tail.Tentacle7.T7_1.Layer_Glow,
  tail.Tentacle7.T7_1.T7_2.Limb_Glow,
  tail.Tentacle7.T7_1.T7_2.Layer_Glow,
  tail.Tentacle7.T7_1.T7_2.T7_3.Limb_Glow,
  tail.Tentacle7.T7_1.T7_2.T7_3.Layer_Glow,
  tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.Limb_Glow,
  tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.Layer_Glow,
  tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.T7_5.Limb_Glow,
  tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.T7_5.Layer_Glow,
  -- Tentacle 8
  tail.Tentacle8.Limb_Glow,
  tail.Tentacle8.Layer_Glow,
  tail.Tentacle8.T8_1.Limb_Glow,
  tail.Tentacle8.T8_1.Layer_Glow,
  tail.Tentacle8.T8_1.T8_2.Limb_Glow,
  tail.Tentacle8.T8_1.T8_2.Layer_Glow,
  tail.Tentacle8.T8_1.T8_2.T8_3.Limb_Glow,
  tail.Tentacle8.T8_1.T8_2.T8_3.Layer_Glow,
  tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.Limb_Glow,
  tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.Layer_Glow,
  tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5.Limb_Glow,
  tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5.Layer_Glow,
}

local Config = require("Config")
local glowing = Config.emissive or false
local function setGlowing(boolean)
  glowing = boolean
  local type = boolean and "EYES" or "NONE"
  for _, part in ipairs(emissive) do
    part:setSecondaryRenderType(type)
  end
  if player:isLoaded() then
    sounds:playSound("minecraft:entity.glow_squid.ambient", player:getPos(), 0.5)
  end
end

pings.setGlowing = setGlowing

local prevLightLevel = 255
function events.TICK()
  if glowing and (Config.lightLevel or false) then
    local lightLevel = world.getLightLevel(player:getPos()) * 17
    local calc = math.lerp(prevLightLevel, lightLevel, 0.025)
    local range = math.clamp(math.floor(calc + 1), 1, 255)
    local rgb = vec(range, range, range)
    
    for _, part in pairs(emissive) do
      part:setColor(rgb)
    end
    
    prevLightLevel = calc
  end
end

local defaultGlowing = Config.emissive or false
setGlowing(defaultGlowing)
return action_wheel:newAction()
    :title("Toggle Glowing")
    :item("minecraft:ink_sac")
    :toggleItem("minecraft:glow_ink_sac")
    :onToggle(pings.setGlowing)
    :toggled(defaultGlowing)