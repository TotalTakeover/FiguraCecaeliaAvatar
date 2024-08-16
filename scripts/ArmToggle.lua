local model = models.OctopusMerling.Player

local tentacleHeldItems = require("Config").tentacleHeldItems or false
local function setTentacleHeldItems(boolean)
  tentacleHeldItems = boolean
  
  model.LeftArm.LeftItemPivot:setVisible(not boolean)
  model.Tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5.LeftItemPivot2:setVisible(boolean)
  model.RightArm.RightItemPivot:setVisible(not boolean)
  model.Tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5.RightItemPivot2:setVisible(boolean)
  
  if player:isLoaded() then
    sounds:playSound("minecraft:item.armor.equip_generic", player:getPos())
  end
end

pings.setTentacleHeldItems = setTentacleHeldItems

setTentacleHeldItems(tentacleHeldItems)
return action_wheel:newAction()
    :title("Toggle Tentacle Item Holding")
    :item("minecraft:red_dye")
    :toggleItem("minecraft:ink_sac")
    :onToggle(pings.setTentacleHeldItems)
    :toggled(tentacleHeldItems)