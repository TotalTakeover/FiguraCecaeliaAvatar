-- Avatar color
avatar:color(vectors.hexToRGB("A008E2"))

-- Table setup
local t = {}

-- Ink color
t.ink = vectors.hexToRGB("B33BEA")

-- Host only instructions
if not host:isHost() then return end

-- Action variables
t.hover     = vectors.hexToRGB("A008E2")
t.active    = vectors.hexToRGB("7A06CA")
t.primary   = "#7A06CA"
t.secondary = "#A008E2"

-- Return variables
return t