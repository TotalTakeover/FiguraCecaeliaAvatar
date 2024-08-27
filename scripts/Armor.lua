--Script that handles registering parts to the ArmorAPI and it's modules

--Change this if you change the model's name
local model = models.Cecaelia
--Minor optimization. sames like 20 instructions
local modelRoot = model.Player

--Register parts that act as armor
local kattArmor = require("lib.KattArmor")()
kattArmor.Armor.Helmet:addParts(modelRoot.Head.Helmet.Helmet)
kattArmor.Armor.Chestplate:addParts(
  modelRoot.Body.Chestplate,
  modelRoot.RightArm.RightChestplate,
  modelRoot.LeftArm.LeftChestplate
)
kattArmor.Armor.Leggings:setLayer(1):addParts(
  modelRoot.Body.LeggingsBelt.Leggings,
  modelRoot.Tail.Leggings,
  modelRoot.Tail.Tentacle1.Leggings,
  modelRoot.Tail.Tentacle1.T1_1.Leggings,
  modelRoot.Tail.Tentacle2.Leggings,
  modelRoot.Tail.Tentacle2.T2_1.Leggings,
  modelRoot.Tail.Tentacle3.Leggings,
  modelRoot.Tail.Tentacle3.T3_1.Leggings,
  modelRoot.Tail.Tentacle4.Leggings,
  modelRoot.Tail.Tentacle4.T4_1.Leggings,
  modelRoot.Tail.Tentacle5.Leggings,
  modelRoot.Tail.Tentacle5.T5_1.Leggings,
  modelRoot.Tail.Tentacle6.Leggings,
  modelRoot.Tail.Tentacle6.T6_1.Leggings,
  modelRoot.Tail.Tentacle7.Leggings,
  modelRoot.Tail.Tentacle7.T7_1.Leggings,
  modelRoot.Tail.Tentacle8.Leggings,
  modelRoot.Tail.Tentacle8.T8_1.Leggings
)
kattArmor.Armor.Boots:addParts(
  modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.Boots,
  modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.Boots,
  modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.Boots,
  modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.Boots,
  modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.Boots,
  modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.Boots,
  modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.Boots,
  modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.Boots
)

kattArmor.Materials.leather
    :setTexture(textures["textures.armor.leatherArmor"] or textures["Cecaelia.leather"])
    :addParts(kattArmor.Armor.Helmet,
      modelRoot.Head.Helmet.HelmetLeather
    )
    :addParts(kattArmor.Armor.Leggings,
      modelRoot.Body.LeggingsBelt.LeggingsLeather,
      modelRoot.Tail.Tentacle1.LeggingsLeather,
      modelRoot.Tail.Tentacle2.LeggingsLeather,
      modelRoot.Tail.Tentacle3.LeggingsLeather,
      modelRoot.Tail.Tentacle4.LeggingsLeather,
      modelRoot.Tail.Tentacle5.LeggingsLeather,
      modelRoot.Tail.Tentacle6.LeggingsLeather,
      modelRoot.Tail.Tentacle7.LeggingsLeather,
      modelRoot.Tail.Tentacle8.LeggingsLeather
    )
    :addParts(kattArmor.Armor.Boots,
      modelRoot.Tail.Tentacle1.T1_1.T1_2.T1_3.BootsLeather,
      modelRoot.Tail.Tentacle2.T2_1.T2_2.T2_3.BootsLeather,
      modelRoot.Tail.Tentacle3.T3_1.T3_2.T3_3.BootsLeather,
      modelRoot.Tail.Tentacle4.T4_1.T4_2.T4_3.BootsLeather,
      modelRoot.Tail.Tentacle5.T5_1.T5_2.T5_3.BootsLeather,
      modelRoot.Tail.Tentacle6.T6_1.T6_2.T6_3.BootsLeather,
      modelRoot.Tail.Tentacle7.T7_1.T7_2.T7_3.BootsLeather,
      modelRoot.Tail.Tentacle8.T8_1.T8_2.T8_3.BootsLeather
    )
kattArmor.Materials.chainmail:setTexture(textures["textures.armor.chainmailArmor"] or textures["Cecaelia.chainmail"])
kattArmor.Materials.iron:setTexture(textures["textures.armor.iron"] or textures["Cecaelia.iron"])
kattArmor.Materials.golden:setTexture(textures["textures.armor.golden"] or textures["Cecaelia.golden"])
kattArmor.Materials.diamond:setTexture(textures["textures.armor.diamond"] or textures["Cecaelia.diamond"])
kattArmor.Materials.netherite:setTexture(textures["textures.armor.netherite"] or textures["Cecaelia.netherite"])
kattArmor.Materials.turtle:setTexture(textures["textures.armor.turtle"] or textures["Cecaelia.turtle"])

local armorPage = action_wheel:newPage()

local armorActions = {}
pings["Katt$setArmorVisible"] = function(part, bool)
  if part ~= "All" then
    kattArmor.Armor[part]:setMaterial(not bool or nil)
    return
  end
  for partID, action in pairs(armorActions) do
    action:toggled(bool)
    kattArmor.Armor[partID]:setMaterial(not bool or nil)
  end
end
for partID, _ in pairs(kattArmor.Armor) do
  armorActions[partID] = armorPage:newAction()
      :toggled(true)
      :title("Toggle " .. partID)
      :item("minecraft:chainmail_" .. partID:lower())
      :toggleItem("minecraft:diamond_" .. partID:lower())
      :onToggle(function(state)
        pings["Katt$setArmorVisible"](partID, state)
      end)
end

local prevPage

armorPage:newAction()
    :title("Go Back")
    :item("minecraft:barrier")
    :onLeftClick(function()
      action_wheel:setPage(prevPage)
    end)

return action_wheel:newAction()
    :title("Toggle Armor"):toggled(true)
    :item("minecraft:chainmail_chestplate")
    :toggleItem("minecraft:netherite_chestplate")
    :onToggle(function(toggle)
      pings["Katt$setArmorVisible"]("All", toggle)
    end)
    :onRightClick(function()
      prevPage = action_wheel:getCurrentPage()
      action_wheel:setPage(armorPage)
    end)