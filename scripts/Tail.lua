-- Required scripts
local parts   = require("lib.PartsAPI")
local lerp    = require("lib.LerpAPI")
local ground  = require("lib.GroundCheck")
local effects = require("scripts.SyncedVariables")

-- Config setup
config:name("Cecaelia")
local tailType  = config:load("TailType") or 4
local small     = config:load("TailSmall")
local dryTimer  = config:load("TailDryTimer") or 400
local fallSound = config:load("TailFallSound")
if small     == nil then small = true end
if fallSound == nil then fallSound = true end

-- Variables setup
local legsForm  = 0.5
local tailTimer = 0
local wasInAir  = false

-- Lerp variables
local scale = {
	tail  = lerp:new(0.2, tailType == 5 and 1 or 0),
	legs  = lerp:new(0.2, tailType ~= 5 and 1 or 0),
	small = lerp:new(0.2, small and 1 or 0)
}

-- Data sent to other scripts
local tailData = {
	scale = scale.tail.currPos * math.map(scale.small.currPos, 0, 1, 1, 0.5) + scale.small.currPos * 0.5,
	large = scale.tail.currPos,
	small = scale.small.currPos,
	legs  = scale.legs.currPos,
	dry   = dryTimer,
	swap  = legsForm
}

-- Check if a splash potion is broken near the player
local splash = false
function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, category, path)
	
	if player:isLoaded() then
		local atPos    = pos < player:getPos() + 2 and pos > player:getPos() - 2
		local splashID = id == "minecraft:entity.splash_potion.break" or id == "minecraft:entity.lingering_potion.break"
		splash = atPos and splashID and path
	end
	
end

function events.TICK()
	
	-- Arm variables
	local handedness  = player:isLeftHanded()
	local activeness  = player:getActiveHand()
	local leftActive  = not handedness and "OFF_HAND" or "MAIN_HAND"
	local rightActive = handedness and "OFF_HAND" or "MAIN_HAND"
	local leftItem    = player:getHeldItem(not handedness)
	local rightItem   = player:getHeldItem(handedness)
	local using       = player:isUsingItem()
	local drinkingL   = activeness == leftActive and using and leftItem:getUseAction() == "DRINK"
	local drinkingR   = activeness == rightActive and using and rightItem:getUseAction() == "DRINK"
	
	-- Check for if player has gone underwater
	local under = player:isUnderwater() or player:isInLava()
	
	-- Check for if player is in liquid
	local water = under or player:isInWater()
	
	-- Check for if player touches any liquid
	local wet = water or player:isWet() or ((drinkingL or drinkingR) and player:getActiveItemTime() > 20) or splash
	if wet then
		splash = false
	end
	
	-- Water state table
	local waterState = {
		false,
		under,
		water,
		wet,
		true
	}
	
	-- Control how fast drying occurs
	local dryRate = player:getItem(1).id == "minecraft:sponge" and 10 or 1
	
	-- Zero check
	local modDryTimer = math.max(dryTimer, 1)
	
	-- Adjust tail timer based on state
	if waterState[tailType] then
		tailTimer = modDryTimer
	elseif tailType == 1 then
		tailTimer = 0
	else
		tailTimer = math.clamp(tailTimer - 1 * dryRate, 0, modDryTimer)
	end
	
	-- Target
	scale.tail.target  = tailTimer / modDryTimer
	scale.legs.target  = tailTimer / modDryTimer <= legsForm and 1 or 0
	scale.small.target = small and 1 or 0
	
	-- Play sound if conditions are met
	if fallSound and wasInAir and ground() and scale.tail.currPos >= legsForm and not player:getVehicle() and not player:isInWater() and not effects.cF then
		local vel    = math.abs(-player:getVelocity().y + 1)
		local dry    = scale.tail.currPos
		local volume = math.clamp((vel * dry) / 2, 0, 1)
		
		if volume ~= 0 then
			sounds:playSound("entity.puffer_fish.flop", player:getPos(), volume, math.map(volume, 1, 0, 0.45, 0.65))
		end
	end
	wasInAir = not ground()
	
end

function events.RENDER(delta, context)
	
	-- Variables
	local tailApply = scale.tail.currPos * math.map(scale.small.currPos, 0, 1, 1, 0.4) + scale.small.currPos * 0.6
	local legsApply = scale.legs.currPos
	
	-- Apply tail
	parts.group.Octopus:scale(tailApply)
	
	-- Apply legs
	parts.group.LeftLeg:scale(legsApply)
	parts.group.RightLeg:scale(legsApply)
	
	-- Update tail data
	tailData.scale = tailApply
	tailData.large = scale.tail.currPos
	tailData.small = scale.small.currPos
	tailData.legs  = scale.legs.currPos
	tailData.dry   = dryTimer
	
end

-- Set sensitivity
local function setSensitivity(sen, i)
	
	sen = sen + i
	if sen > 5 then sen = 1 end
	if sen < 1 then sen = 5 end
	if player:isLoaded() and host:isHost() then
		sounds:playSound("ambient.underwater.enter", player:getPos(), 0.35)
	end
	
	return sen
	
end

-- Tail sensitivity
function pings.setTailType(i)
	
	tailType = setSensitivity(tailType, i)
	config:save("TailType", tailType)
	
end

-- Small toggle
function pings.setTailSmall(boolean)
	
	small = boolean
	config:save("TailSmall", small)
	
end

-- Set timer
local function setDryTimer(x)
	
	dryTimer = math.clamp(dryTimer + (x * 20), 0, 72000)
	config:save("TailDryTimer", dryTimer)
	
end

-- Sound toggle
function pings.setTailFallSound(boolean)

	fallSound = boolean
	config:save("TailFallSound", fallSound)
	if host:isHost() and player:isLoaded() and fallSound then
		sounds:playSound("entity.puffer_fish.flop", player:getPos(), 0.35, 0.6)
	end
	
end

-- Sync variables
function pings.syncTail(a, b, c, d)
	
	tailType  = a
	small     = b
	dryTimer  = c
	fallSound = d
	
end

-- Host only instructions, return tail data
if not host:isHost() then return tailData end

-- Required scripts
local itemCheck = require("lib.ItemCheck")
local s, color = pcall(require, "scripts.ColorProperties")
if not s then color = {} end

-- Tail Keybind
local tailBind   = config:load("TailTypeKeybind") or "key.keyboard.keypad.1"
local setTailKey = keybinds:newKeybind("Tail Sensitivity Type"):onPress(function() pings.setTailType(1) end):key(tailBind)

-- Small tail keybind
local smallBind   = config:load("TailSmallKeybind") or "key.keyboard.keypad.2"
local setSmallKey = keybinds:newKeybind("Small Tail Toggle"):onPress(function() pings.setTailSmall(not small) end):key(smallBind)

-- Keybind updaters
function events.TICK()
	
	local tailKey  = setTailKey:getKey()
	local smallKey = setSmallKey:getKey()
	if tailKey ~= tailBind then
		tailBind = tailKey
		config:save("TailTypeKeybind", tailKey)
	end
	if smallKey ~= smallBind then
		smallBind = smallKey
		config:save("TailSmallKeybind", smallKey)
	end
	
end

-- Sync on tick
function events.TICK()
	
	if world.getTime() % 200 == 0 then
		pings.syncTail(tailType, small, dryTimer, fallSound)
	end
	
end

-- Table setup
local t = {}

-- Actions
t.tailAct = action_wheel:newAction()
	:onLeftClick(function() pings.setTailType(1) end)
	:onRightClick(function() pings.setTailType(-1) end)
	:onScroll(pings.setTailType)

t.smallAct = action_wheel:newAction()
	:item(itemCheck("kelp"))
	:toggleItem(itemCheck("scute"))
	:onToggle(pings.setTailSmall)

t.dryAct = action_wheel:newAction()
	:onScroll(setDryTimer)
	:onLeftClick(function() dryTimer = 400 config:save("TailDryTimer", dryTimer) end)

t.soundAct = action_wheel:newAction()
	:item(itemCheck("bucket"))
	:toggleItem(itemCheck("water_bucket"))
	:onToggle(pings.setTailFallSound)
	:toggled(fallSound)

-- Water context info table
local waterInfo = {
	{
		title = {label = {text = "None", color = "red"}, text = "Cannot form."},
		item  = "glass_bottle",
		color = "FF5555"
	},
	{
		title = {label = {text = "Low", color = "yellow"}, text = "Reactive to being underwater."},
		item  = "potion",
		color = "FFFF55"
	},
	{
		title = {label = {text = "Medium", color = "green"}, text = "Reactive to being in water."},
		item  = "splash_potion",
		color = "55FF55"
	},
	{
		title = {label = {text = "High", color = "aqua"}, text = "Reactive to any form of water."},
		item  = "lingering_potion",
		color = "55FFFF"
	},
	{
		title = {label = {text = "Max", color = "blue"}, text = "Always active."},
		item  = "dragon_breath",
		color = "5555FF"
	}
}

-- Creates a clock string
local function timeStr(s)

	local min = s >= 60
		and ("%d Minute%s"):format(s / 60, s >= 120 and "s" or "")
		or nil
	
	local sec = ("%d Second%s"):format(s % 60, s % 60 == 1 and "" or "s")
	
	return min and (min.." "..sec) or sec
	
end

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		local actionSetup = waterInfo[tailType]
		t.tailAct
			:title(toJson
				{"",
				{text = "Tail Water Sensitivity\n\n", bold = true, color = color.primary},
				{text = "Determines how your tail should form in contact with water.\n\n", color = color.secondary},
				{text = "Current configuration: ", bold = true, color = color.secondary},
				{text = actionSetup.title.label.text, color = actionSetup.title.label.color},
				{text = " | "},
				{text = actionSetup.title.text, color = color.secondary}}
			)
			:color(vectors.hexToRGB(actionSetup.color))
			:item(itemCheck(actionSetup.item.."{CustomPotionColor:"..tostring(0x0094FF).."}"))
		
		t.smallAct
			:title(toJson
				{"",
				{text = "Toggle Small Tail\n\n", bold = true, color = color.primary},
				{text = "Toggles the appearence of the tail into a smaller tail, only if the tail cannot form.", color = color.secondary}}
			)
			:toggled(small)
		
		-- Timers
		local timers = {
			set  = dryTimer / 20,
			legs = math.max(math.ceil((tailTimer - (dryTimer * legsForm)) / 20), 0),
			tail = math.ceil(tailTimer / 20)
		}
		
		-- Countdowns
		local cD = {}
		for k, v in pairs(timers) do
			cD[k] = timeStr(v)
		end
		
		t.dryAct
			:title(toJson
				{"",
				{text = "Set Drying Timer\n\n", bold = true, color = color.primary},
				{text = "Scroll to adjust how long it takes for you to dry.\nLeft click resets timer to 20 seconds.\n\n", color = color.secondary},
				{text = "Drying timer:\n", bold = true, color = color.secondary},
				{text = cD.set.."\n\n"},
				{text = "Legs form:\n", bold = true, color = color.secondary},
				{text = cD.legs.."\n\n"},
				{text = "Tail fully dry:\n", bold = true, color = color.secondary},
				{text = cD.tail.."\n\n"},
				{text = "Hint: Holding a dry sponge will increase drying rate by x10!", color = "gray"}}
			)
			:item(itemCheck((timers.tail ~= 0 or timers.ears ~= 0) and "wet_sponge" or "sponge"))
		
		t.soundAct
			:title(toJson
				{"",
				{text = "Toggle Flop Sound\n\n", bold = true, color = color.primary},
				{text = "Toggles flopping sound effects when landing on the ground.\nIf tail can dry, volume will gradually decrease over time until dry.", color = color.secondary}}
			)
		
		for _, page in pairs(t) do
			page:hoverColor(color.hover):toggleColor(color.active)
		end
		
	end
	
end

-- Return tail data and actions
return tailData, t