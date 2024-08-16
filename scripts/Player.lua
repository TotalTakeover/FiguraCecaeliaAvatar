--Configures the ModelParts that mimic vanilla parts.

--Change this if you change the bbmodel's name
local model = models.OctopusMerling
--Minor optimization. Saves like 20 instructions lol
local modelRoot = model.Player

local vanillaSkinParts = {
  modelRoot.Head.Head,
  modelRoot.Head.Hat_Layer,

  modelRoot.Body.Body,
  modelRoot.Body.Body_Layer,

  modelRoot.RightArm.RightSteve,
  modelRoot.RightArm.RightSlim,

  modelRoot.LeftArm.LeftSteve,
  modelRoot.LeftArm.LeftSlim,
}
for _, part in pairs(vanillaSkinParts) do
  part:setPrimaryTexture(require("Config").usesPlayerSkin and "SKIN" or nil)
end

modelRoot.Body.Cape:setPrimaryTexture(require("Config").usesPlayerSkin and "CAPE" or nil)

--Sets the modelType of the avatar.
local slim = require("Config").isSlim or false
modelRoot.LeftArm.LeftSteve:setVisible(not slim and nil)
modelRoot.RightArm.RightSteve:setVisible(not slim and nil)

modelRoot.LeftArm.LeftSlim:setVisible(slim and nil)
modelRoot.RightArm.RightSlim:setVisible(slim and nil)

--Show/hide skin layers depending on Skin Customization settings
---@type table<PlayerAPI.skinLayer|string,ModelPart[]>
local layerParts = {
  HAT = {
    modelRoot.Head.Hat_Layer,
  },
  JACKET = {
    modelRoot.Body.Body_Layer,
  },
  RIGHT_SLEEVE = {
    modelRoot.RightArm.RightSteve.RightArmLayerSteve,
    modelRoot.RightArm.RightSlim.RightArmLayerSlim,
  },
  LEFT_SLEEVE = {
    modelRoot.LeftArm.LeftSteve.LeftArmLayerSteve,
    modelRoot.LeftArm.LeftSlim.LeftArmLayerSlim,
  },
  CAPE = {
    modelRoot.Body.Cape,
  },
  TAIL = {
    modelRoot.Tail.LowerBodyLayer,
    modelRoot.Tail.LowerBodyLayer_Glow,
    -- Tentacle 1
    modelRoot.Tail.Tentacle1.Layer,
    modelRoot.Tail.Tentacle1.Layer_Glow,
    modelRoot.Tail.Tentacle1.T1_1.Layer,
    modelRoot.Tail.Tentacle1.T1_1.Layer_Glow,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.Layer,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.Layer_Glow,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.Layer,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.Layer_Glow,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.Layer,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.Layer_Glow,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.T1_5.Layer,
    modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.T1_5.Layer_Glow,
    -- Tentacle 2
    modelRoot.Tail.Tentacle2.Layer,
    modelRoot.Tail.Tentacle2.Layer_Glow,
    modelRoot.Tail.Tentacle2.T2_1.Layer,
    modelRoot.Tail.Tentacle2.T2_1.Layer_Glow,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.Layer,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.Layer_Glow,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.Layer,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.Layer_Glow,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.Layer,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.Layer_Glow,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5.Layer,
    modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5.Layer_Glow,
    -- Tentacle 3
    modelRoot.Tail.Tentacle3.Layer,
    modelRoot.Tail.Tentacle3.Layer_Glow,
    modelRoot.Tail.Tentacle3.T3_1.Layer,
    modelRoot.Tail.Tentacle3.T3_1.Layer_Glow,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.Layer,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.Layer_Glow,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.Layer,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.Layer_Glow,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.Layer,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.Layer_Glow,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.T3_5.Layer,
    modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.T3_5.Layer_Glow,
    -- Tentacle 4
    modelRoot.Tail.Tentacle4.Layer,
    modelRoot.Tail.Tentacle4.Layer_Glow,
    modelRoot.Tail.Tentacle4.T4_1.Layer,
    modelRoot.Tail.Tentacle4.T4_1.Layer_Glow,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.Layer,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.Layer_Glow,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.Layer,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.Layer_Glow,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.Layer,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.Layer_Glow,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.T4_5.Layer,
    modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.T4_5.Layer_Glow,
    -- Tentacle 5
    modelRoot.Tail.Tentacle5.Layer,
    modelRoot.Tail.Tentacle5.Layer_Glow,
    modelRoot.Tail.Tentacle5.T5_1.Layer,
    modelRoot.Tail.Tentacle5.T5_1.Layer_Glow,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.Layer,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.Layer_Glow,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.Layer,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.Layer_Glow,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.Layer,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.Layer_Glow,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.T5_5.Layer,
    modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.T5_5.Layer_Glow,
    -- Tentacle 6
    modelRoot.Tail.Tentacle6.Layer,
    modelRoot.Tail.Tentacle6.Layer_Glow,
    modelRoot.Tail.Tentacle6.T6_1.Layer,
    modelRoot.Tail.Tentacle6.T6_1.Layer_Glow,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.Layer,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.Layer_Glow,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.Layer,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.Layer_Glow,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.Layer,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.Layer_Glow,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.T6_5.Layer,
    modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.T6_5.Layer_Glow,
    -- Tentacle 7
    modelRoot.Tail.Tentacle7.Layer,
    modelRoot.Tail.Tentacle7.Layer_Glow,
    modelRoot.Tail.Tentacle7.T7_1.Layer,
    modelRoot.Tail.Tentacle7.T7_1.Layer_Glow,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.Layer,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.Layer_Glow,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.Layer,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.Layer_Glow,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.Layer,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.Layer_Glow,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.T7_5.Layer,
    modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.T7_5.Layer_Glow,
    -- Tentacle 8
    modelRoot.Tail.Tentacle8.Layer,
    modelRoot.Tail.Tentacle8.Layer_Glow,
    modelRoot.Tail.Tentacle8.T8_1.Layer,
    modelRoot.Tail.Tentacle8.T8_1.Layer_Glow,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.Layer,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.Layer_Glow,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.Layer,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.Layer_Glow,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.Layer,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.Layer_Glow,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5.Layer,
    modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5.Layer_Glow,
  },
}
---@type table<string,PlayerAPI.skinLayer[]>
local customPartType = {
  TAIL = {
    "RIGHT_PANTS_LEG",
    "LEFT_PANTS_LEG",
  },
}
function events.TICK()
  for playerPart, parts in pairs(layerParts) do
    local enabled = true
    if customPartType[playerPart] then
      for _, layer in ipairs(customPartType[playerPart]) do
        enabled = enabled and player:isSkinLayerVisible(layer)
      end
    else
      enabled = player:isSkinLayerVisible(playerPart)
    end
    enabled = enabled and nil
    for _, part in ipairs(parts) do
      part:setVisible(enabled)
    end
  end
  modelRoot.Tail:setVisible(player:getGamemode() ~= "SPECTATOR")
end
