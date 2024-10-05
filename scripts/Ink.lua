-- Required scripts
local parts = require("lib.PartsAPI")
local tail  = require("scripts.Tail")
local s, color = pcall(require, "scripts.ColorProperties")
if not s then color = {ink = vectors.vec3()} end

-- Disables code if script cannot find `parts.group.Ink` or related groups
local inkPart = table.unpack(parts:createTable(function(part) return part:getName():find("Ink") end, 1))
if not inkPart then return {} end

-- Variables
local active = false
local cooldown = false
local maxInk = 0
local remainingInk = 0
local cooldownTimer = 0

-- Shoots ink
local function shootInk(x)
	
	-- Variables
	x = x or 1
	local pos = inkPart:partToWorldMatrix():apply()
	local blockPos = world.getBlockState(pos)
	if #blockPos:getFluidTags() == 0 then return end
	
	-- Find color
	local calcColor = (color.ink * inkPart:getSecondaryColor() * 1.25):applyFunc(function(x) return math.clamp(x, 0, 1) end)
	
	for i = 1, x do
		
		-- Find angle with variation
		local ang = inkPart:partToWorldMatrix()
			:applyDir(
				math.random() * 6 - 3,
				math.random() * 6 - 6.25,
				math.random() * 6 - 3
			)
		
		-- Create particle
		particles["glow_squid_ink"]
			:pos(pos)
			:velocity(ang)
			:scale(math.random() * 1.5 + 1)
			:color(calcColor)
			:lifetime(math.random(100, 300))
			:physics(true)
			:gravity(0.025)
			:spawn()
		
	end
	
	-- Subtract used from amount left
	remainingInk = math.clamp(remainingInk - x, 0, maxInk)
	
end

function events.ENTITY_INIT()
	
	-- On init, set variables
	maxInk = math.min(player:getExperienceLevel(), 50) * 15
	remainingInk = maxInk
	
end

function events.TICK()
	
	-- Maximum ink the player can hold
	maxInk = math.min(player:getExperienceLevel(), 50) * 15
	
	-- Tail scale
	local largeTail = tail.large >= tail.swap
	
	if active and largeTail and not cooldown then
		
		-- How much ink is used each tick, decreasing based on how much is left
		local calc = math.ceil(remainingInk / 50)
		shootInk(calc)
		
	elseif cooldownTimer == 0 then
		
		-- Gradually increase ink when not using it
		remainingInk = math.clamp(remainingInk + 1, 0, maxInk)
		cooldown = false
		
	end
	
	-- If no ink, activate cooldown
	if remainingInk == 0 and maxInk ~= 0 and not cooldown then
		
		cooldown = true
		active   = false
		
		cooldownTimer = 100
		
	end
	
	-- Reduce cooldown timer
	cooldownTimer = math.max(cooldownTimer - 1, 0)
	
end

function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, cat, path)
	
	-- Don't trigger if the sound was played by Figura (prevent potential infinite loop)
	if not path then return end
	
	-- Don't do anything if the user isn't loaded
	if not player:isLoaded() then return end
	
	-- Make sure the sound is (most likely) played by the user
	if (player:getPos() - pos):length() > 0.05 then return end
	
	-- If sound contains ".hurt", play an additional hurt sound along side it
	if id:find(".hurt") then
		
		-- How much ink is used, decreasing based on how much is left
		local calc = math.ceil(remainingInk / 50)
		shootInk(calc)
		
		-- Subtract used from amount left
		remainingInk = math.clamp(remainingInk - calc, 0, maxInk)
		
	end
	
end

-- Toggle ink
function pings.inkKey(x)
	
	active = x
	
end

-- Host only instructions
if not host:isHost() then return end

-- Required scripts
local lerp      = require("lib.LerpAPI")
local itemCheck = require("lib.ItemCheck")

-- Lerp tables
local fadeLerp = lerp:new(0.2, 0)
local barLerp  = lerp:new(0.2, 0)

-- Variables
local pMaxInk = maxInk
local wasMax, isMax = true, true
local fadeTimer = 100

function events.TICK()
	
	-- Variables
	isMax = remainingInk == maxInk
	
	-- Adjust timer based on active
	fadeTimer = (active or pMaxInk ~= maxInk or wasMax ~= isMax or cooldownTimer ~= 0) and 0 or math.min(fadeTimer + 1, 100)
	
	-- If timer reaches 100, fade out, otherwise fade in
	fadeLerp.target = fadeTimer == 100 and 0 or 1
	
	-- Lerp bar scale
	barLerp.target = fadeLerp.target * (maxInk / 20)
	
	-- Store previous variables
	pMaxInk = maxInk
	wasMax  = isMax
	
end

function events.RENDER(delta, context)
	
	-- Variables
	local screen = client:getScaledWindowSize()
	local inkLeft = remainingInk / maxInk
	local redBar = math.clamp(inkLeft / 0.5, 0, 1) * 0.5 + 0.5
	
	-- Position Gui parts, set scale, opacity, and color
	parts.group.Gui
		:pos(-screen.x * 0.975, -screen.y * 0.5)
		:scale(2.5)
		:opacity(fadeLerp.currPos)
		:color(1, redBar, redBar)
	
	-- Position middle bar to bottom, scale to top
	parts.group.Bar
		:pos(0, -barLerp.currPos / 2)
		:scale(1, barLerp.currPos + 1, 1)
	
	parts.group.Bar.Glass
		:setUVMatrix(matrices.mat3():scale(1, barLerp.currPos + 1, 1))
	
	parts.group.Bar.Ink
		:scale(1, inkLeft, 1)
		:color(color.ink)
		:setUVMatrix(matrices.mat3():scale(1, (barLerp.currPos + 1) * inkLeft, 1))
	
	-- Position cap to top
	parts.group.Top:pos(0, barLerp.currPos / 2)
	
	-- Position cap to bottom
	parts.group.Bottom:pos(0, -barLerp.currPos / 2)
	
end

-- Ink keybind
local inkBind   = config:load("InkKeybind") or "key.keyboard.i"
local setInkKey = keybinds:newKeybind("Ink")
	:onPress(function() pings.inkKey(true) end)
	:onRelease(function() pings.inkKey(false) end)
	:key(inkBind)

-- Keybind updater
function events.TICK()
	
	local key = setInkKey:getKey()
	if key ~= inkBind then
		inkBind = key
		config:save("InkKeybind", key)
	end
	
end