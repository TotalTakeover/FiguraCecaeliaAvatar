-- Required scripts
require("lib.GSAnimBlend")
require("lib.Molang")
local parts   = require("lib.PartsAPI")
local lerp    = require("lib.LerpAPI")
local ground  = require("lib.GroundCheck")
local tail    = require("scripts.Tail")
local pose    = require("scripts.Posing")
local effects = require("scripts.SyncedVariables")

-- Animations setup
local anims = animations.Cecaelia

-- Table setup
v = {}

-- Animation variables
v.strength = 1
v.pitch = 0
v.yaw   = 0
v.roll  = 0

v.scale = math.map(math.max(tail.scale, tail.legs), 0, 1, 1, 0)

-- Variables
local waterTimer = 0
local fallTimer = 0
local isSing = false

-- Parrot pivots
local parrots = {
	
	parts.group.LeftParrotPivot,
	parts.group.RightParrotPivot
	
}

-- Calculate parent's rotations
local function calculateParentRot(m)
	
	local parent = m:getParent()
	if not parent then
		return m:getTrueRot()
	end
	return calculateParentRot(parent) + m:getTrueRot()
	
end

-- Lerps
local strength = lerp:new(1)
local pitch = lerp:new(0.1)
local yaw   = lerp:new(1)
local roll  = lerp:new(0.1)

-- Spawns notes around a model part
local function notes(part, blocks)
	
	local pos   = part:partToWorldMatrix():apply()
	local range = blocks * 16
	particles["note"]
		:pos(pos + vec(math.random(-range, range)/16, math.random(-range, range)/16, math.random(-range, range)/16))
		:setColor(math.random(51,200)/150, math.random(51,200)/150, math.random(51,200)/150)
		:spawn()
	
end

-- Set staticYaw to Yaw on init
local staticYaw = 0
function events.ENTITY_INIT()
	
	staticYaw = player:getBodyYaw()
	
end

function events.TICK()
	
	-- Player variables
	local vel      = player:getVelocity()
	local dir      = player:getLookDir()
	local bodyYaw  = player:getBodyYaw()
	local onGround = ground()
	
	-- Timer settings
	if player:isInWater() or player:isInLava() then
		waterTimer = 20
	else
		waterTimer = math.max(waterTimer - 1, 0)
	end
	
	if onGround or vel.y >= 0 or pose.climb then
		fallTimer = 10
	else
		fallTimer = math.max(fallTimer - 1, 0)
	end
	
	-- Animation variables
	local largeTail = tail.large >= tail.swap
	local smallTail = tail.small >= tail.swap or tail.large <= tail.swap
	local groundAnim = (onGround or waterTimer == 0) and not (pose.swim or pose.crawl) and not pose.elytra and not pose.sleep and not player:getVehicle() and not effects.cF
	
	-- Directional velocity
	local fbVel = player:getVelocity():dot((dir.x_z):normalize())
	local lrVel = player:getVelocity():cross(dir.x_z:normalize()).y
	local udVel = player:getVelocity().y
	local diagCancel = math.abs(lrVel) - math.abs(fbVel)
	
	-- Static yaw
	staticYaw = math.clamp(staticYaw, bodyYaw - 45, bodyYaw + 45)
	staticYaw = math.lerp(staticYaw, bodyYaw, onGround and math.clamp(vel:length(), 0, 1) or 0.25)
	local yawDif = staticYaw - bodyYaw
	
	-- Speed control
	local speed = player:getVehicle() and 1 or math.min(vel:length() * 1.5, 3) + 0.5
	--local landSpeed = math.clamp(fbVel < -0.05 and math.min(fbVel, math.abs(lrVel)) * 6 - 0.5 or math.max(fbVel, math.abs(lrVel)) * 6 + 0.5, -6, 6)
	
	-- Animation speeds
	anims.swim:speed(speed)
	
	-- Axis controls
	-- X axis control
	if pose.elytra then
		
		-- When using elytra
		pitch.target = math.clamp(-udVel * 20 * (-math.abs(player:getLookDir().y) + 1), -30, 30)
		
	elseif pose.climb or not largeTail or pose.spin then
		
		-- Assumed climbing
		pitch.target = 0
		
	elseif (pose.swim or waterTimer == 0) and not effects.cF then
		
		-- While "swimming" or outside of water
		pitch.target = math.clamp(-udVel * 80 * -(math.abs(player:getLookDir().y * 2) - 1), -30, 30)
		
	else
		
		-- Assumed floating in water
		pitch.target = math.clamp((fbVel + math.max(-udVel, 0) + (math.abs(lrVel) * diagCancel) * 4) * 160, -30, 30)
		
	end
	
	-- Y axis control
	yaw.target = yawDif
	
	-- Z Axis control
	if effects.dG then
		
		-- Dolphin's grace applied
		roll.target = 0
		
	elseif pose.elytra then
		
		-- When using an elytra
		roll.target = math.clamp((-lrVel * 40) - (yawDif * math.clamp(fbVel, -1, 1)), -30, 30)
		
	else
		
		-- Assumed floating in water
		roll.target = math.clamp((-lrVel * diagCancel * 160) - (yawDif * math.clamp(fbVel, -1, 1)), -30, 30)
		
	end
	
	-- Animation states
	local idle  = largeTail and groundAnim and fallTimer ~= 0
	local walk  = largeTail and groundAnim and vel.xz:length() ~= 0
	local swim  = largeTail and not groundAnim
	local fall  = largeTail and groundAnim and fallTimer == 0
	local small = smallTail and not largeTail
	local sing  = isSing and not pose.sleep
	
	-- Animations
	anims.idle:playing(idle)
	anims.walk:playing(walk)
	anims.swim:playing(swim)
	anims.fall:playing(fall)
	anims.small:playing(small)
	anims.sing:playing(sing)
	
	-- Spawns notes around head while singing
	if isSing and world.getTime() % 5 == 0 then
		notes(parts.group.Head, 1)
	end
	
end

function events.RENDER(delta, context)
	
	-- Store animation variables
	v.strength = strength.currPos
	v.pitch    = pitch.currPos
	v.yaw      = yaw.currPos
	v.roll     = roll.currPos
	
	v.scale = math.map(math.max(tail.scale, tail.legs), 0, 1, 1, 0)
	
	-- Parrot rot offset
	for _, parrot in pairs(parrots) do
		parrot:rot(-calculateParentRot(parrot:getParent()) - vanilla_model.BODY:getOriginRot())
	end
	
end

-- GS Blending Setup
local blendAnims = {
	{ anim = anims.idle,  ticks = {7,7} },
	{ anim = anims.walk,  ticks = {7,7} },
	{ anim = anims.swim,  ticks = {7,7} },
	{ anim = anims.fall,  ticks = {7,7} },
	{ anim = anims.small, ticks = {7,7} },
	{ anim = anims.sing,  ticks = {3,3} }
}

-- Apply GS Blending
for _, blend in ipairs(blendAnims) do
	blend.anim:blendTime(table.unpack(blend.ticks)):onBlend("easeOutQuad")
end

-- Fixing spyglass jank
function events.RENDER(delta, context)
	
	local rot = vanilla_model.HEAD:getOriginRot()
	rot.x = math.clamp(rot.x, -90, 30)
	parts.group.Spyglass:offsetRot(rot)
		:pos(pose.crouch and vec(0, -4, 0) or nil)
	
end

-- Singing anim toggle
function pings.setAnimSing(boolean)
	
	isSing = boolean
	
end

-- Sync variables
function pings.syncAnims(a)
	
	isSing = a
	
end

-- Host only instructions
if not host:isHost() then return end

-- Required scripts
local itemCheck = require("lib.ItemCheck")
local s, color = pcall(require, "scripts.ColorProperties")
if not s then color = {} end

-- Sing keybind
local singBind   = config:load("AnimSingKeybind") or "key.keyboard.keypad.7"
local setSingKey = keybinds:newKeybind("Singing Animation"):onPress(function() pings.setAnimSing(not isSing) end):key(singBind)

-- Keybind updaters
function events.TICK()
	
	local singKey  = setSingKey:getKey()
	if singKey ~= singBind then
		singBind = singKey
		config:save("AnimSingKeybind", singKey)
	end
	
end

-- Sync on tick
function events.TICK()
	
	if world.getTime() % 200 == 0 then
		pings.syncAnims(isSing)
	end
	
end

-- Table setup
local t = {}

-- Action
t.singAct = action_wheel:newAction()
	:item(itemCheck("music_disc_blocks"))
	:toggleItem(itemCheck("music_disc_cat"))
	:onToggle(pings.setAnimSing)

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		t.singAct
			:title(toJson
				{text = "Play Singing animation", bold = true, color = color.primary}
			)
			:toggled(isSing)
		
		for _, page in pairs(t) do
			page:hoverColor(color.hover):toggleColor(color.active)
		end
		
	end
	
end

-- Returns actions
return t

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
--]]