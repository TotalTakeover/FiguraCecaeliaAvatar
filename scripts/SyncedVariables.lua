--script1.lua
local t = {}
t.ground = true
t.dG = false
t.nV = false

local wasGround = t.ground
function pings.groundPing(boolean)
  t.ground = boolean
end

if host:isHost() then
  function events.TICK()
    t.ground = player:isOnGround()
    if t.ground ~= wasGround then
      pings.groundPing(t.ground)
    end
    wasGround = t.ground
  end
end

if require("Config").glowingEyes == nil then
  local wasNV = t.nV
  function pings.nVPing(boolean)
    t.nV = boolean
  end
  
  if host:isHost() then
    function events.TICK()
      t.nV = false
      for _, effect in ipairs(host:getStatusEffects()) do
        if effect.name == "effect.minecraft.night_vision" then
          t.nV = true
        end
      end
      if t.nV ~= wasNV then
        pings.nVPing(t.nV)
      end
      wasNV = t.nV
    end
  end
end

if require("Config").whirlPoolEffect == nil then
  local wasDG = t.dG
  function pings.dGPing(boolean)
    t.dG = boolean
  end
  
  if host:isHost() then
    function events.TICK()
      t.dG = false
      for _, effect in ipairs(host:getStatusEffects()) do
        if effect.name == "effect.minecraft.dolphins_grace" then
          t.dG = true
        end
      end
      if t.dG ~= wasDG then
        pings.dGPing(t.dG)
      end
      wasDG = t.dG
    end
  end
end

return t