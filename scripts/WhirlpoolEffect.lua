-- Required scripts
local parts   = require("lib.PartsAPI")
local effects = require("scripts.SyncedVariables")
local pose    = require("scripts.Posing")

-- Config setup
config:name("Cecaelia")
local bubbles       = config:load("WhirlpoolBubbles")
local dolphinsGrace = config:load("WhirlpoolDolphinsGrace") or false
if bubbles == nil then bubbles = true end

-- Bubble spawner locations
local whirlpoolParts = parts:createTable(function(part) return part:getName():find("Bubble") end)

function events.TICK()
	
	if dolphinsGrace and not effects.dG then return end
	
	if avatar:getPermissionLevel() ~= "MAX" then
		
		local time = world.getTime() % 2
		if time == 0 then return end
		
	end
	
	if pose.swim and bubbles and player:isInWater() then
		for _, part in ipairs(whirlpoolParts) do
			particles["bubble"]
				:pos(part:partToWorldMatrix():apply())
				:spawn()
		end
	end
	
end

-- Bubbles toggle
function pings.setWhirlpoolBubbles(boolean)
	
	bubbles = boolean
	config:save("WhirlpoolBubbles", bubbles)
	if host:isHost() and player:isLoaded() and bubbles then
		sounds:playSound("block.bubble_column.upwards_inside", player:getPos(), 0.35)
	end
	
end

-- Dolphins Grace toggle
function pings.setWhirlpoolDolphinsGrace(boolean)
	
	dolphinsGrace = boolean
	config:save("WhirlpoolDolphinsGrace", dolphinsGrace)
	if host:isHost() and player:isLoaded() and dolphinsGrace then
		sounds:playSound("entity.dolphin.ambient", player:getPos(), 0.35)
	end
	
end

-- Sync variables
function pings.syncWhirlpool(a, b)
	
	bubbles        = a
	dolphinsGrace  = b
	
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
		pings.syncWhirlpool(bubbles, dolphinsGrace)
	end
	
end

-- Table setup
local t = {}

-- Actions
t.bubbleAct = action_wheel:newAction()
	:item(itemCheck("soul_sand"))
	:toggleItem(itemCheck("magma_block"))
	:onToggle(pings.setWhirlpoolBubbles)
	:toggled(bubbles)

t.dolphinsGraceAct = action_wheel:newAction()
	:item(itemCheck("egg"))
	:toggleItem(itemCheck("dolphin_spawn_egg"))
	:onToggle(pings.setWhirlpoolDolphinsGrace)
	:toggled(dolphinsGrace)

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		t.bubbleAct
			:title(toJson
				{"",
				{text = "Whirlpool Effect Toggle\n\n", bold = true, color = color.primary},
				{text = "Toggles the whirlpool created while swimming.", color = color.secondary}}
			)
		
		t.dolphinsGraceAct
			:title(toJson
				{"",
				{text = "Dolphin\'s Grace Toggle\n\n", bold = true, color = color.primary},
				{text = "Toggles the whirlpool based on having the Dolphin\'s Grace Effect.", color = color.secondary}}
			)
		
		for _, act in pairs(t) do
			act:hoverColor(color.hover):toggleColor(color.active)
		end
		
	end
	
end

-- Return actions
return t