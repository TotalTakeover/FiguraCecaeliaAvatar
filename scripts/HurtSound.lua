--Plays a sound and shoots ink when damage is taken
local lastHealth = -1
local died = false
local deathTimer = 0
local t = {}
t.amount = 0

function events.TICK()
  local health = player:getHealth()
  t.amount = 0
  if health < lastHealth then
    if health == 0 then
      sounds:playSound("minecraft:entity.squid.death", player:getPos())
      died = true
    else
      sounds:playSound("minecraft:entity.squid.hurt", player:getPos())
      t.amount = math.random(5,10)
    end
  end
  if died then
    deathTimer = 10
    died = false
  end
  if deathTimer > 0 then
    t.amount = math.random(3,5)
    deathTimer = deathTimer - 1
  end
  lastHealth = health
end

return t