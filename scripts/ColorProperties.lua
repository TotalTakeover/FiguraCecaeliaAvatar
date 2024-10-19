-- Avatar color
avatar:color(vectors.hexToRGB("C35444"))

-- Host only instructions
if not host:isHost() then return end

-- Table setup
local t = {}

-- Action variables
t.hover     = vectors.hexToRGB("9A3A3E")
t.active    = vectors.hexToRGB("C35444")
t.primary   = "#C35444"
t.secondary = "#9A3A3E"

-- Return variables
return t