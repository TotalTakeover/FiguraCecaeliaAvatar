local Config = require("Config")
--local hurt = require("scripts.HurtSound")
local model = models.Cecaelia.Player.Tail

-- Shoots ink
local inkColor
local prevLightLevel = 0
function shootInk(x)
  if player:isInWater() then
    local ang = model:partToWorldMatrix():applyDir(0,-1,0)
    local loc = model:partToWorldMatrix():apply(0, -8, 0)
    if model.LowerBody_Glow:getSecondaryRenderType() == "EMISSIVE" then
      if Config.lightLevel then
        local lightLevel = -world.getLightLevel(player:getPos()) / 15 + 2
        local calc = math.lerp(prevLightLevel, lightLevel, 0.025)
        inkColor = Config.inkRGB * math.clamp(calc, 1, 2)
        prevLightLevel = calc
      else
        inkColor = Config.inkRGB * 2
      end
    else
      inkColor = Config.inkRGB
    end
    for i = 1,x do
      particles["glow_squid_ink"]
          :color(math.min(inkColor.x, 1), math.min(inkColor.y, 1), math.min(inkColor.z, 1))
          :scale(math.random(25,90)/100)
          :lifetime(math.random(25,75))
          :physics(true)
          :velocity(ang.x + math.random(-50,50)/1000, ang.y + math.random(-50,50)/1000, ang.z + math.random(-50,50)/1000)
          :power(math.random(50,125)/100)
          :pos(loc)
          :spawn()
    end
  end
end

local inkKeyActive = false
-- Ink Keybind Ping
function pings.inkKeyPressed(x)
  inkKeyActive = x
end

-- Ink Kebind
local inkKey = keybinds:newKeybind("Shoot Ink", "key.keyboard."..Config.inkKeybind)
function inkKey.press()
  pings.inkKeyPressed(true)
end
function inkKey.release()
  pings.inkKeyPressed(false)
end

-- Ink Cooldown for keybind
local inkCooldown = 0
local onCooldown = false
function events.TICK()
  --shootInk(hurt.amount)
  if inkKeyActive and not onCooldown then
    shootInk(math.random(10,15))
    inkCooldown = inkCooldown + 1
  elseif inkCooldown > 0 then
    inkCooldown = inkCooldown - 0.5
    if inkCooldown <= 0 then
      onCooldown = false
    end
  end
  if inkCooldown >= 60 then
    onCooldown = true
  end
end