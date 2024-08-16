--The script that connects various actions accross many scripts into pages.

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

mainPage:setAction( -1, require("scripts.WhirlpoolEffect"))
mainPage:setAction( -1, require("scripts.Emissive"))
mainPage:setAction( -1, require("scripts.GlowingEyes"))
mainPage:setAction( -1, require("scripts.FlopSound"))
mainPage:setAction( -1, require("scripts.ArmToggle"))

--Enable/Disable Armor page
mainPage:setAction( -1, require("scripts.Armor"))
