require("lib.GSAnimBlend")
local ticksOutOfWater = require("scripts.TicksOutOfWater")

local model = models.Cecaelia.Player
local animation = animations.Cecaelia
local leftPivotPoint = model.Tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5.LeftItemPivot2
local rightPivotPoint = model.Tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5.RightItemPivot2

-- Not Enough Animations Check
local nEA = client.hasResource("notenoughanimations:icon.png")

-- Animation blending
animation.crossbowLeft:blendTime(5)
animation.crossbowRight:blendTime(5)
animation.drinkLeft:blendTime(5)
animation.drinkRight:blendTime(5)
animation.eatLeft:blendTime(5)
animation.eatRight:blendTime(5)
animation.drinkLeftNEA:blendTime(5)
animation.drinkRightNEA:blendTime(5)
animation.eatLeftNEA:blendTime(5)
animation.eatRightNEA:blendTime(5)
animation.blockLeft:blendTime(5)
animation.blockRight:blendTime(5)
animation.bowLeft:blendTime(5)
animation.bowRight:blendTime(5)
animation.tridentLeft:blendTime(5)
animation.tridentRight:blendTime(5)
animation.spyglassLeft:blendTime(5)
animation.spyglassRight:blendTime(5)
animation.hornLeft:blendTime(5)
animation.hornRight:blendTime(5)
animation.loadingLeft:blendTime(5)
animation.loadingRight:blendTime(5)

-- Grabing priority
animation.startHeldItemLeft:priority(4)
animation.startHeldItemRight:priority(4)

-- Action priority
animation.crossbowLeft:priority(1)
animation.crossbowRight:priority(1)
animation.drinkLeft:priority(3)
animation.drinkRight:priority(3)
animation.eatLeft:priority(2)
animation.eatRight:priority(2)
animation.drinkLeftNEA:priority(3)
animation.drinkRightNEA:priority(3)
animation.eatLeftNEA:priority(2)
animation.eatRightNEA:priority(2)
animation.blockLeft:priority(2)
animation.blockRight:priority(2)
animation.bowLeft:priority(4)
animation.bowRight:priority(4)
animation.tridentLeft:priority(2)
animation.tridentRight:priority(2)
animation.spyglassLeft:priority(2)
animation.spyglassRight:priority(2)
animation.hornLeft:priority(2)
animation.hornRight:priority(2)
animation.loadingLeft:priority(2)
animation.loadingRight:priority(2)

function events.RENDER(delta)
  -- Variables
  local posing = player:getPose()
  local handedness = player:isLeftHanded()
  local leftActive = not handedness and "OFF_HAND" or "MAIN_HAND"
  local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
  local activeness = player:getActiveHand()
  local leftUsing = activeness == leftActive
  local rightUsing = activeness == rightActive
  local using = player:isUsingItem()
  local usingL = leftUsing and player:getHeldItem(not handedness):getUseAction()
  local usingR = rightUsing and player:getHeldItem(handedness):getUseAction()
  local leftItem = player:getHeldItem(not handedness)
  local rightItem = player:getHeldItem(handedness)
  local leftSwing = player:getSwingArm() == leftActive
  local rightSwing = player:getSwingArm() == rightActive
  local leftPlay = ((player:getSwingArm() == leftActive) or (leftItem.id ~= "minecraft:air")) and leftPivotPoint:getVisible()
  local rightPlay = ((player:getSwingArm() == rightActive) or (rightItem.id ~= "minecraft:air")) and rightPivotPoint:getVisible()
  local firstPerson = renderer:isFirstPerson() and not client.hasResource("firstperson:icon.png")
  local tentacleHeldItems = leftPivotPoint:getVisible()
  
  local idleTimer = world.getTime(delta)
  local movementState = (require("Config").armMovement == false) and ((ticksOutOfWater.time <= 15) and posing == "SWIMMING")
  
  -- States
  local crossL = leftItem.tag and leftItem.tag["Charged"] == 1
  local crossR = rightItem.tag and rightItem.tag["Charged"] == 1
  local drinkingL = using and usingL == "DRINK"
  local drinkingR = using and usingR == "DRINK"
  local eatingL = (using and usingL == "EAT") or (drinkingL and not animation.drinkingL)
  local eatingR = (using and usingR == "EAT") or (drinkingR and not animation.drinkingR)
  local blockingL = using and usingL == "BLOCK"
  local blockingR = using and usingR == "BLOCK"
  local bowingL = using and usingL == "BOW"
  local bowingR = using and usingR == "BOW"
  local spearL = using and usingL == "SPEAR"
  local spearR = using and usingR == "SPEAR"
  local spyglassL = using and usingL == "SPYGLASS"
  local spyglassR = using and usingR == "SPYGLASS"
  local hornL = using and usingL == "TOOT_HORN"
  local hornR = using and usingR == "TOOT_HORN"
  local loadingL = using and usingL == "CROSSBOW"
  local loadingR = using and usingR == "CROSSBOW"
  
  -- Item grabbing
  animation.startHeldItemLeft:setPlaying((leftPlay or crossR or bowingR or loadingR) and tentacleHeldItems)
  animation.startHeldItemRight:setPlaying((rightPlay or crossL or bowingL or loadingL) and tentacleHeldItems)
  animation.endHeldItemLeft:setPlaying(animation.startHeldItemLeft:getPlayState() == "STOPPED")
  animation.endHeldItemRight:setPlaying(animation.startHeldItemRight:getPlayState() == "STOPPED")
  
  -- Animation playing
  animation.crossbowLeft:setPlaying(crossL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.crossbowRight:setPlaying(crossR and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.blockLeft:setPlaying(blockingL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.blockRight:setPlaying(blockingR and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.bowLeft:setPlaying(bowingL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.bowRight:setPlaying(bowingR and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.tridentLeft:setPlaying(spearL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.tridentRight:setPlaying(spearR and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.spyglassLeft:setPlaying(spyglassL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.spyglassRight:setPlaying(spyglassR and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.hornLeft:setPlaying(hornL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.hornRight:setPlaying(hornR and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.loadingLeft:setPlaying(loadingL and tentacleHeldItems and not (posing == "SWIMMING"))
  animation.loadingRight:setPlaying(loadingR and tentacleHeldItems and not (posing == "SWIMMING"))
  
  -- nEA Specific Animations
  animation.drinkLeft:setPlaying(drinkingL and tentacleHeldItems and not (posing == "SWIMMING") and not nEA)
  animation.drinkRight:setPlaying(drinkingR and tentacleHeldItems and not (posing == "SWIMMING") and not nEA)
  animation.eatRight:setPlaying(eatingR and tentacleHeldItems and not (posing == "SWIMMING") and not nEA)
  animation.eatLeft:setPlaying(eatingL and tentacleHeldItems and not (posing == "SWIMMING") and not nEA)
  
  animation.drinkLeftNEA:setPlaying(drinkingL and tentacleHeldItems and not (posing == "SWIMMING") and nEA)
  animation.drinkRightNEA:setPlaying(drinkingR and tentacleHeldItems and not (posing == "SWIMMING") and nEA)
  animation.eatRightNEA:setPlaying(eatingR and tentacleHeldItems and not (posing == "SWIMMING") and nEA)
  animation.eatLeftNEA:setPlaying(eatingL and tentacleHeldItems and not (posing == "SWIMMING") and nEA)
  
  -- Arms
  if tentacleHeldItems then
    model.LeftArm:setRot(-math.deg(math.sin(idleTimer * 0.067) * 0.05), 0 + -vanilla_model.BODY:getOriginRot().y, -math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
    model.RightArm:setRot(math.deg(math.sin(idleTimer * 0.067) * 0.05), 0 + -vanilla_model.BODY:getOriginRot().y, math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
    model.LeftArm:setParentType("Body")
    model.RightArm:setParentType("Body")
  else
    if movementState and not leftSwing and not ((crossL or crossR) or (using and usingL ~= "NONE")) and not firstPerson then
      model.LeftArm:setParentType("Body")
      model.LeftArm:setRot(-math.deg(math.sin(idleTimer * 0.067) * 0.05), 0, -math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
    else
      model.LeftArm:setParentType("LeftArm")
      model.LeftArm:setRot(0, 0, 0)
    end
    if movementState and not rightSwing and not ((crossL or crossR) or (using and usingR ~= "NONE")) and not firstPerson then
      model.RightArm:setParentType("Body")
      model.RightArm:setRot(math.deg(math.sin(idleTimer * 0.067) * 0.05), 0, math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
    else
      model.RightArm:setParentType("RightArm")
      model.RightArm:setRot(0, 0, 0)
    end
  end
  
  -- Tentacles
  if tentacleHeldItems then
    if not leftSwing and not ((crossL or crossR) or (using and usingL ~= "NONE")) and not firstPerson then
      model.Tail.Tentacle8:setParentType("Body")
    else
      model.Tail.Tentacle8:setParentType("LeftArm")
    end
    if not rightSwing and not ((crossL or crossR) or (using and usingR ~= "NONE")) and not firstPerson then
      model.Tail.Tentacle2:setParentType("Body")
    else
      model.Tail.Tentacle2:setParentType("RightArm")
    end
    model.Body:setRot(0, -vanilla_model.BODY:getOriginRot().y, 0)
  else
    model.Tail.Tentacle8:setParentType("Body")
    model.Tail.Tentacle2:setParentType("Body")
    model.Body:setRot(0, 0, 0)
  end
  
  -- First Person / Crouch Check / Position & Rotation Reset
  if firstPerson then
    model.Tail.Tentacle8:setPos(0, 10, 5)
    model.Tail.Tentacle2:setPos(0, 10, 5)
    model.Tail.Tentacle8:setRot(100,90,90)
    model.Tail.Tentacle2:setRot(100,-90,-90)
  else
    if posing == "CROUCHING" then
      model.Tail.Tentacle8:setPos(0, 3, 0)
      model.Tail.Tentacle2:setPos(0, 3, 0)
      model.Tail.Tentacle8:setRot(120,45 + -vanilla_model.BODY:getOriginRot().y,0)
      model.Tail.Tentacle2:setRot(120,-45 + -vanilla_model.BODY:getOriginRot().y,0)
    else
      model.Tail.Tentacle8:setPos(0, 0, 0)
      model.Tail.Tentacle2:setPos(0, 0, 0)
      model.Tail.Tentacle8:setRot(90,45 + -vanilla_model.BODY:getOriginRot().y,0)
      model.Tail.Tentacle2:setRot(90,-45 + -vanilla_model.BODY:getOriginRot().y,0)
    end
  end
  
  -- Specific Item Holding
  if tentacleHeldItems then
    -- Left
    if leftItem.id ~= "minecraft:air" then 
      if leftItem.id == "minecraft:shield" then
        leftPivotPoint:setPos(1, -4, -1)
        leftPivotPoint:setRot(90, -90, -90)
      elseif leftItem.id == "minecraft:bow" then
        leftPivotPoint:setPos(3, -1, 2)
        leftPivotPoint:setRot(90, 120, -90)
      elseif leftItem.id == "minecraft:crossbow" then
        leftPivotPoint:setPos(0, 0, 0)
        leftPivotPoint:setRot(90, 90, -90)
      elseif leftItem.id == "minecraft:spyglass" then
        leftPivotPoint:setPos(0, 0, 1)
        leftPivotPoint:setRot(270, 0, 90)
      else
        leftPivotPoint:setPos(0, 0, 0)
        leftPivotPoint:setRot(90, 0, -90)
      end
    end
    -- Right
    if rightItem.id ~= "minecraft:air" then
      if rightItem.id == "minecraft:shield" then
        rightPivotPoint:setPos(0, -4, -1)
        rightPivotPoint:setRot(90, 90, 90)
      elseif rightItem.id == "minecraft:bow" then
        rightPivotPoint:setPos(-2, -2, 1)
        rightPivotPoint:setRot(90, 240, 90)
      elseif rightItem.id == "minecraft:crossbow" then
        rightPivotPoint:setPos(0, 0, 0)
        rightPivotPoint:setRot(90, -90, 90)
      elseif rightItem.id == "minecraft:spyglass" then
        rightPivotPoint:setPos(0, 0, 1)
        rightPivotPoint:setRot(270, 0, -90)
      else
        rightPivotPoint:setPos(0, 0, 0)
        rightPivotPoint:setRot(90, 0, 90)
      end
    end
  end
end