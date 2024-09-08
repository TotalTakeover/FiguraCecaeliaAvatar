-- Required scripts
require("lib.GSAnimBlend")
local parts   = require("lib.PartsAPI")
local lerp    = require("lib.LerpAPI")
local ground  = require("lib.GroundCheck")
local tail    = require("scripts.Tail")
local pose    = require("scripts.Posing")
local effects = require("scripts.SyncedVariables")

-- Animations setup
local anims = animations.Cecaelia

-- Config setup
config:name("Cecaelia")

function events.TICK()
	
end

function events.RENDER(delta, context)
	
end

-- GS Blending Setup
local blendAnims = {
}

-- Apply GS Blending
for _, blend in ipairs(blendAnims) do
	blend.anim:blendTime(table.unpack(blend.ticks)):onBlend("easeOutQuad")
end

--[[
local syncedVariables = require("scripts.SyncedVariables")
local ticksOutOfWater = require("scripts.TicksOutOfWater")

local model = models.Cecaelia.Player
local tail = model.Tail
local animation = animations.Cecaelia

-- Animation lengths
animation.elytra:length(2)

local posing = "None"
local velocity = vec(0, 0, 0)
local vehicle = false
local forwards = true

local firstPerson
function events.RENDER(delta)
  firstPerson = renderer:isFirstPerson() and not client.hasResource("firstperson:icon.png")
end

function events.TICK()
  -- Variables
  posing = player:getPose()
  velocity = player:getVelocity()
  vehicle = player:getVehicle()
  local movingState = player:isClimbing() or vehicle
  local jumpingState = velocity.y > 0 or velocity.y < 0
  local climb = player:isClimbing()
  
    -- States
  local idleState = not movingState and velocity.xz:length() == 0 and ((ticksOutOfWater.time > 15) or ((posing == "STANDING" or posing == "CROUCHING") and syncedVariables.ground))
  local moveState = not movingState and velocity.xz:length() ~= 0 and ((ticksOutOfWater.time > 15) or (syncedVariables.ground and not (posing == "SWIMMING")))
  local crouchState = posing == "CROUCHING"
  local swimState = (posing == "SWIMMING" or ((posing == "STANDING" or posing == "CROUCHING") and not syncedVariables.ground)) and (ticksOutOfWater.time <= 15) and not (posing == "FALL_FLYING")
  local crawlState = posing == "SWIMMING" and ticksOutOfWater.time > 15 or posing == "CRAWLING"
  local elytraState = posing == "FALL_FLYING"
  local tridentState = posing == "SPIN_ATTACK"
  local vehicleState = vehicle
  local sleepState = posing == "SLEEPING"
  local jumpState = not movingState and velocity.y > 0 and (ticksOutOfWater.time > 15) and not (posing == "FALL_FLYING")
  local fallState = not movingState and velocity.y < -.52 and not (posing == "FALL_FLYING")
  
  forwards = (player:getLookDir().x > 0 and velocity.x > 0) or (player:getLookDir().x < 0 and velocity.x < 0) or (player:getLookDir().z > 0 and velocity.z > 0) or (player:getLookDir().z < 0 and velocity.z < 0)
  
    -- Animation playing
  animation.idle:setPlaying((not swimState and not crawlState and not fallState and not sleepState and (idleState or climb)) or firstPerson)
  animation.move:setPlaying(not firstPerson and not swimState and not crawlState and not tridentState and not elytraState and not fallState and moveState)
  animation.crouch:setPlaying(not firstPerson and crouchState)
  animation.swim:setPlaying(not firstPerson and not vehicleState and not sleepState and not tridentState and swimState)
  animation.crawl:setPlaying(not firstPerson and crawlState)
  animation.spin:setPlaying(not firstPerson and tridentState)
  animation.elytra:setPlaying(not firstPerson and elytraState)
  animation.ride:setPlaying(not firstPerson and vehicleState)
  animation.sleep:setPlaying(not firstPerson and sleepState)
  animation.jump:setPlaying(not firstPerson and not tridentState and jumpState)
  animation.fall:setPlaying(not firstPerson and not swimState and fallState)
end

function events.RENDER(delta)
  -- Animation speed
  animation.move:speed(math.clamp(velocity.xz:length() * 10, 0, 5))
  animation.crawl:speed(velocity.xz:length() * 10)
  animation.elytra:speed(math.clamp(velocity:length() * 3, 0, 1.5))
  animation.fall:speed(math.clamp(-velocity.y * 2.5 + 0.5, 0, 3.5))
  
  animation.swim:speed(math.clamp(syncedVariables.ground and velocity:length() * 2 or velocity:length() * 1.5 + 0.5, 0, 1.25))
  
  -- Backwards movement
  if not forwards then
    animation.move:speed(-animation.move:getSpeed())
    animation.crawl:speed(-animation.crawl:getSpeed())
  end
end

do
  local bendCurrent = 0
  local bendNextTick = 0
  local bendTarget = 0
  local bendCurrentPos = 0
  
  local yawCurrent = 0
  local yawNextTick = 0
  local yawTarget = 0
  local yawCurrentPos = 0
  
  local rollCurrent = 0
  local rollNextTick = 0
  local rollTarget = 0
  local rollCurrentPos = 0
  
  -- Gradual Values
  function events.TICK()
    bendCurrent = bendNextTick
    bendNextTick = math.lerp(bendNextTick, bendTarget, 0.25)
    yawCurrent = yawNextTick
    yawNextTick = math.lerp(yawNextTick, yawTarget, 1)
    rollCurrent = rollNextTick
    rollNextTick = math.lerp(rollNextTick, rollTarget, 0.1)
  end
  
  local tentacles = {
    tail.Tentacle3,
    tail.Tentacle4,
    tail.Tentacle5,
    tail.Tentacle6,
    tail.Tentacle7, -- First 5 have special instructions
    tail.Tentacle8,
    tail.Tentacle1,
    tail.Tentacle2,
    
    tail.Tentacle1.T1_1,
    tail.Tentacle1.T1_1.T1_2,
    tail.Tentacle1.T1_1.T1_2.T1_3,
    tail.Tentacle1.T1_1.T1_2.T1_3.T1_4,
    tail.Tentacle1.T1_1.T1_2.T1_3.T1_4.T1_5,
    
    tail.Tentacle2.T2_1,
    tail.Tentacle2.T2_1.T2_2,
    tail.Tentacle2.T2_1.T2_2.T2_3,
    tail.Tentacle2.T2_1.T2_2.T2_3.T2_4,
    tail.Tentacle2.T2_1.T2_2.T2_3.T2_4.T2_5,
    
    tail.Tentacle3.T3_1,
    tail.Tentacle3.T3_1.T3_2,
    tail.Tentacle3.T3_1.T3_2.T3_3,
    tail.Tentacle3.T3_1.T3_2.T3_3.T3_4,
    tail.Tentacle3.T3_1.T3_2.T3_3.T3_4.T3_5,
    
    tail.Tentacle4.T4_1,
    tail.Tentacle4.T4_1.T4_2,
    tail.Tentacle4.T4_1.T4_2.T4_3,
    tail.Tentacle4.T4_1.T4_2.T4_3.T4_4,
    tail.Tentacle4.T4_1.T4_2.T4_3.T4_4.T4_5,
    
    tail.Tentacle5.T5_1,
    tail.Tentacle5.T5_1.T5_2,
    tail.Tentacle5.T5_1.T5_2.T5_3,
    tail.Tentacle5.T5_1.T5_2.T5_3.T5_4,
    tail.Tentacle5.T5_1.T5_2.T5_3.T5_4.T5_5,
    
    tail.Tentacle6.T6_1,
    tail.Tentacle6.T6_1.T6_2,
    tail.Tentacle6.T6_1.T6_2.T6_3,
    tail.Tentacle6.T6_1.T6_2.T6_3.T6_4,
    tail.Tentacle6.T6_1.T6_2.T6_3.T6_4.T6_5,
    
    tail.Tentacle7.T7_1,
    tail.Tentacle7.T7_1.T7_2,
    tail.Tentacle7.T7_1.T7_2.T7_3,
    tail.Tentacle7.T7_1.T7_2.T7_3.T7_4,
    tail.Tentacle7.T7_1.T7_2.T7_3.T7_4.T7_5,
    
    tail.Tentacle8.T8_1,
    tail.Tentacle8.T8_1.T8_2,
    tail.Tentacle8.T8_1.T8_2.T8_3,
    tail.Tentacle8.T8_1.T8_2.T8_3.T8_4,
    tail.Tentacle8.T8_1.T8_2.T8_3.T8_4.T8_5
  }
  
  local bodyYaw   = 0
  local staticYaw = 0
  local twirlYaw  = 0
  function events.ENTITY_INIT()
    bodyYaw   = player:getBodyYaw()
    staticYaw = player:getBodyYaw()
    twirlYaw  = player:getBodyYaw()
  end
  
  local prevRoll  = 0
  local roll      = 0
  local rollLimit = 15
  function events.TICK()
    roll = math.lerp(prevRoll, bodyYaw, 0.05)
    if roll < bodyYaw - rollLimit then
      roll = bodyYaw - rollLimit
    elseif roll > bodyYaw + rollLimit then
      roll = bodyYaw + rollLimit
    end
    prevRoll = roll
  end
  
  local yawLimit = 40
  function events.RENDER(delta)
    local shouldBend = player:isInWater() and not syncedVariables.ground and not vehicle
    local standing   = (posing == "STANDING" or posing == "CROUCHING")
    
    bodyYaw          = player:getBodyYaw()
    local yawLimitL  = bodyYaw - yawLimit
    local yawLimitR  = bodyYaw + yawLimit
    
    if velocity.xz:length() ~= 0 or not standing or (player:isInWater() and not syncedVariables.ground) then
      staticYaw = bodyYaw
    elseif staticYaw < yawLimitL then
      staticYaw = yawLimitL
    elseif staticYaw > yawLimitR then
      staticYaw = yawLimitR
    end
    
    bendTarget      = math.clamp(forwards and shouldBend and standing and -velocity.xz:length() * 40 or shouldBend and standing and velocity.xz:length() * 40 or shouldBend and posing == "SWIMMING" and velocity.y * 120 * -(math.abs(player:getLookDir().y * 1.5) - 1) or 0, -30, 30)
    bendCurrentPos  = math.lerp(bendCurrent, bendNextTick, delta)
    yawTarget       = bodyYaw - staticYaw
    yawCurrentPos   = math.lerp(yawCurrent, yawNextTick, delta)
    rollTarget      = shouldBend and (roll - bodyYaw) / 2 or 0
    rollCurrentPos  = math.lerp(rollCurrent, rollNextTick, delta)
    
    tail:setOffsetRot(bendCurrentPos, 0, 0)
    
    for _, part in pairs(tentacles) do
      part:setOffsetRot(0, _ <= 5 and yawCurrentPos or 0, rollCurrentPos)
    end
    
  end
end

-- Fixing spyglass jank
function events.RENDER(delta)
  local rot = vanilla_model.HEAD:getOriginRot()
  rot.x = math.clamp(rot.x, -90, 30)
  model.Spyglass:setRot(rot)
  if (posing == "CROUCHING") and not (animation.crouch:getPlayState() == "PLAYING") then
    model.Spyglass:setPos(0, -4, 0)
  else
    model.Spyglass:setPos(0, 0, 0)
  end
end

require("lib.GSAnimBlend")

-- Animation blending
animation.idle:blendTime(4)
animation.move:blendTime(4)
animation.swim:blendTime(10)
animation.crawl:blendTime(10)
animation.elytra:blendTime(10)
animation.spin:blendTime(10)
animation.ride:blendTime(10)
animation.sleep:blendTime(10)
animation.jump:blendTime(4)
animation.fall:blendTime(10)

animation.idle:onBlend("easeOutQuad")
animation.move:onBlend("easeOutQuad")
animation.swim:onBlend("easeOutQuad")
animation.crawl:onBlend("easeOutQuad")
animation.elytra:onBlend("easeOutQuad")
animation.spin:onBlend("easeOutQuad")
animation.ride:onBlend("easeOutQuad")
animation.sleep:onBlend("easeOutQuad")
animation.jump:onBlend("easeOutQuad")
animation.fall:onBlend("easeOutQuad")
--]]