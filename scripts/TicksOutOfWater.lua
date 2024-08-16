local t = {}
t.time = 400
t.wet = 400

function events.TICK()
  t.time = t.time + 1
  t.wet = t.wet + 1
  if player:isInWater() then
    t.time = 0
  end
  if player:isWet() then
    t.wet = 0
  end
end

return t