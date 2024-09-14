-- Required scripts
local parts     = require("lib.PartsAPI")
local squapi    = require("lib.SquAPI")
local squAssets = require("lib.SquAssets")
local lerp      = require("lib.LerpAPI")
local tailScale = require("scripts.Tail")
local effects   = require("scripts.SyncedVariables")

-- Animation setup
local anims = animations.Cecaelia

--TEMP
v = {}

-- Force load before setting up animation variable
require("scripts.Anims")
v.bounce = 0

-- Config setup
config:name("Cecaelia")
local armsMove = config:load("SquapiArmsMove") or false

-- Lerp tables
local leftArmLerp  = lerp:new(0.5, armsMove and 1 or 0)
local rightArmLerp = lerp:new(0.5, armsMove and 1 or 0)

-- Tails table
local tailParts = {
	
	parts.group.Ten1Seg1,
	parts.group.Ten1Seg2,
	parts.group.Ten1Seg3,
	parts.group.Ten1Seg4,
	parts.group.Ten1Seg5,
	parts.group.Ten1Seg6
	
}

-- Squishy tail
local tail = squapi.tail:new(
	tailParts,
	7.5,   -- Intensity X (0)
	0,     -- Intensity Y (0)
	0.8,   -- Speed X (0)
	0,     -- Speed Y (0)
	0.5,   -- Bend (0.5)
	0,     -- Velocity Push (0)
	0,     -- Initial Offset (0)
	0,     -- Seg Offset (0)
	0.025, -- Stiffness (0.025)
	0.975, -- Bounce (0.975)
	15,    -- Fly Offset (25)
	-15,   -- Down Limit (-15)
	25     -- Up Limit (25)
)

-- Tail strength variables
local tailXIntense  = tail.idleXMovement
local tailXSpeed    = tail.idleXSpeed
local tailStrength  = tail.bendStrength
local tailFlyOffset = tail.flyingOffset

-- Squishy vanilla arms
local leftArm = squapi.arm:new(
	parts.group.LeftArm,
	1,     -- Strength (1)
	false, -- Right Arm (false)
	true   -- Keep Position (false)
)

local rightArm = squapi.arm:new(
	parts.group.RightArm,
	1,    -- Strength (1)
	true, -- Right Arm (true)
	true  -- Keep Position (false)
)

-- Arm strength variables
local leftArmStrength  = leftArm.strength
local rightArmStrength = rightArm.strength

local bounce = squAssets.BERP:new(0.05, 0.9)
bounce.target = 0

function events.TICK()
	
	-- Arm variables
	local handedness  = player:isLeftHanded()
	local activeness  = player:getActiveHand()
	local leftActive  = not handedness and "OFF_HAND" or "MAIN_HAND"
	local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
	local leftSwing   = player:getSwingArm() == leftActive
	local rightSwing  = player:getSwingArm() == rightActive
	local leftItem    = player:getHeldItem(not handedness)
	local rightItem   = player:getHeldItem(handedness)
	local using       = player:isUsingItem()
	local usingL      = activeness == leftActive and leftItem:getUseAction() or "NONE"
	local usingR      = activeness == rightActive and rightItem:getUseAction() or "NONE"
	local bow         = using and (usingL == "BOW" or usingR == "BOW")
	local crossL      = leftItem.tag and leftItem.tag["Charged"] == 1
	local crossR      = rightItem.tag and rightItem.tag["Charged"] == 1
	
	-- Arm movement overrides
	local armShouldMove = (not (player:isUnderwater() or player:isInLava()) and not effects.cF) or tailScale.large <= tailScale.swap or anims.crawl:isPlaying()
	
	-- Control targets based on variables
	leftArmLerp.target  = (armsMove or armShouldMove or leftSwing  or bow or ((crossL or crossR) or (using and usingL ~= "NONE"))) and 1 or 0
	rightArmLerp.target = (armsMove or armShouldMove or rightSwing or bow or ((crossL or crossR) or (using and usingR ~= "NONE"))) and 1 or 0
	
	-- Control the intensity of the tail function based on its scale
	local scale = tailScale.large <= tailScale.swap and 1 or 0
	tail.idleXMovement = scale * tailXIntense
	tail.idleXSpeed    = scale * tailXSpeed
	tail.bendStrength  = scale * tailStrength
	tail.flyingOffset  = scale * tailFlyOffset
	
	bounce.target = math.clamp(player:getVelocity().y * 80 - (player:getPose() == "CROUCHING" and 20 or 0), -60, 12.5)
	
end

function events.RENDER(delta, context)
	
	for _, part in ipairs(tailParts) do
		local rot = part:getOffsetRot()
		part:offsetRot(-rot.x, rot.y, rot.z)
	end
	
	for i = 2, 8 do
		for j, part in ipairs(tailParts) do
			parts.group["Ten"..i.."Seg"..j]:offsetRot(part:getOffsetRot())
		end
	end
	
	-- Variables
	local idleTimer   = world.getTime(delta)
	local idleRot     = vec(math.deg(math.sin(idleTimer * 0.067) * 0.05), 0, math.deg(math.cos(idleTimer * 0.09) * 0.05 + 0.05))
	local firstPerson = context == "FIRST_PERSON"
	
	-- Adjust arm strengths
	leftArm.strength  = leftArmStrength  * leftArmLerp.currPos
	rightArm.strength = rightArmStrength * rightArmLerp.currPos
	
	-- Adjust arm characteristics after applied by squapi
	parts.group.LeftArm
		:offsetRot(
			parts.group.LeftArm:getOffsetRot()
			+ ((-idleRot + (vanilla_model.BODY:getOriginRot() * 0.75)) * math.map(leftArmLerp.currPos, 0, 1, 1, 0))
			+ (parts.group.LeftArm:getAnimRot() * math.map(leftArmLerp.currPos, 0, 1, 0, -2))
		)
		:pos(parts.group.LeftArm:getPos() * vec(1, 1, -1))
		:visible(not firstPerson)
	
	parts.group.RightArm
		:offsetRot(
			parts.group.RightArm:getOffsetRot()
			+ ((idleRot + (vanilla_model.BODY:getOriginRot() * 0.75)) * math.map(rightArmLerp.currPos, 0, 1, 1, 0))
			+ (parts.group.RightArm:getAnimRot() * math.map(rightArmLerp.currPos, 0, 1, 0, -2))
		)
		:pos(parts.group.RightArm:getPos() * vec(1, 1, -1))
		:visible(not firstPerson)
	
	-- Set visible if in first person
	parts.group.LeftArmFP:visible(firstPerson)
	parts.group.RightArmFP:visible(firstPerson)
	
	v.bounce = bounce:berp(bounce.target, delta)
	
end

-- Arm movement toggle
function pings.setSquapiArmsMove(boolean)
	
	armsMove = boolean
	config:save("SquapiArmsMove", armsMove)
	
end

-- Sync variable
function pings.syncSquapi(a)
	
	armsMove = a
	
end

-- Host only instructions
if not host:isHost() then return end

-- Required scripts
local itemCheck = require("lib.ItemCheck")
local s, color = pcall(require, "scripts.ColorProperties")
if not s then color = {} end

-- Sync on tick
function events.TICK()
	
	if world.getTime() % 200 == 0 then
		pings.syncSquapi(armsMove)
	end
	
end

-- Table setup
local t = {}

-- Action
t.armsAct = action_wheel:newAction()
	:item(itemCheck("red_dye"))
	:toggleItem(itemCheck("rabbit_foot"))
	:onToggle(pings.setSquapiArmsMove)
	:toggled(armsMove)

-- Update action
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		t.armsAct
			:title(toJson
				{"",
				{text = "Arm Movement Toggle\n\n", bold = true, color = color.primary},
				{text = "Toggles the movement swing movement of the arms.\nActions are not effected.", color = color.secondary}}
			)
		
		for _, page in pairs(t) do
			page:hoverColor(color.hover):toggleColor(color.active)
		end
		
	end
	
end

-- Return action
return t