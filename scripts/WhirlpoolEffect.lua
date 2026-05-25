-- Required scripts
local parts   = require("lib.PartsAPI")
local sync    = require("lib.LetThatSyncFig")
local effects = require("scripts.SyncedVariables")
local pose    = require("scripts.Posing")

-- Synced variables setup
local bubbles       = sync.new("WhirlpoolBubbles", true):config()
local dolphinsGrace = sync.new("WhirlpoolDolphinsGrace", false):config()

-- Bubble spawner locations
local whirlpoolParts = parts:createTable(function(part) return part:getName():find("Bubble") end)

function events.TICK()
	
	if dolphinsGrace.curr and not effects.dG then return end
	
	if avatar:getPermissionLevel() ~= "MAX" then
		
		local time = world.getTime() % 2
		if time == 0 then return end
		
	end
	
	if pose.swim and bubbles.curr and player:isInWater() then
		for _, part in ipairs(whirlpoolParts) do
			particles["bubble"]
				:pos(part:partToWorldMatrix():apply())
				:spawn()
		end
	end
	
end

-- Host only instructions
if not host:isHost() then return end

-- Apply sound functions
bubbles:applyFunc(function()
	if player:isLoaded() and bubbles.curr then
		sounds:playSound("block.bubble_column.upwards_inside", player:getPos(), 0.35)
	end
end)
dolphinsGrace:applyFunc(function()
	if player:isLoaded() and dolphinsGrace.curr then
		sounds:playSound("entity.dolphin.ambient", player:getPos(), 0.35)
	end
end)

-- Required scripts
local s, wheel, c = pcall(require, "scripts.ActionWheel")
if not s then return end -- Kills script early if ActionWheel.lua isnt found
pcall(require, "scripts.Tail") -- Tries to find script, not required

-- Pages
local parentPage    = action_wheel:getPage("Octopus") or action_wheel:getPage("Main")
local whirlpoolPage = action_wheel:newPage("Whirlpool")

-- Actions table setup
local a = {}

-- Actions
a.pageAct = parentPage:newAction()
	:item("magma_block")
	:onLeftClick(function() wheel:descend(whirlpoolPage) end)

a.bubbleAct = whirlpoolPage:newAction()
	:item("soul_sand")
	:toggleItem("magma_block")
	:onToggle(function(bool)
		bubbles:update(bool)
	end)
	:toggled(bubbles.curr)

a.dolphinsGraceAct = whirlpoolPage:newAction()
	:item("egg")
	:toggleItem("dolphin_spawn_egg")
	:onToggle(function(bool)
		dolphinsGrace:update(bool)
	end)
	:toggled(dolphinsGrace.curr)

-- Update actions
function events.RENDER(delta, context)
	
	if action_wheel:isEnabled() then
		a.pageAct
			:title(toJson(
				{text = "Whirlpool Settings", bold = true, color = c.primary}
			))
		
		a.bubbleAct
			:title(toJson(
				{
					"",
					{text = "Whirlpool Effect Toggle\n\n", bold = true, color = c.primary},
					{text = "Toggles the whirlpool created while swimming.", color = c.secondary}
				}
			))
		
		a.dolphinsGraceAct
			:title(toJson(
				{
					"",
					{text = "Dolphin\'s Grace Toggle\n\n", bold = true, color = c.primary},
					{text = "Toggles the whirlpool based on having the Dolphin\'s Grace Effect.", color = c.secondary}
				}
			))
		
		for _, act in pairs(a) do
			act:hoverColor(c.hover):toggleColor(c.active)
		end
		
	end
	
end