local model = models.OctopusMerling.Player
local headY = 0
local dir = 0
function events.RENDER(delta)
  headY = model:getAnimPos().y / 16
  dir = player:getLookDir()
  nameplate.ENTITY:pos((player:getPose() == "STANDING" or player:getPose() == "CROUCHING") and vec(0, headY, 0) or dir.xyz * headY)
end

local Config = require("Config")
if Config.matchCamera == true then
  local scale = 1
  function events.RENDER(delta)
    local nbt = player:getNbt()
    scale = (nbt["pehkui:scale_data_types"] and nbt["pehkui:scale_data_types"]["pehkui:base"] and nbt["pehkui:scale_data_types"]["pehkui:base"]["scale"]) and player:getNbt()["pehkui:scale_data_types"]["pehkui:base"]["scale"] or 1
    
    renderer:offsetCameraPivot((player:getPose() == "STANDING" or player:getPose() == "CROUCHING") and vec(0, headY * scale, 0) or dir.xyz * headY)
  end
end