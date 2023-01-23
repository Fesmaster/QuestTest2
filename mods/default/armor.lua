--[[
    Armor definitions
]]
local colors = {"red", "orange", "yellow", "green", "cyan", "blue", "purple", "magenta", "white", "gray", "dark_gray", "black", "dark_green", "brown"}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

for _, color in ipairs(colors) do
    
	local texturetable = qtcore.armor_cloth_textures(qtcore.colors[color], 79)

    --robes
    minetest.register_tool("default:armor_robes_"..color, {
    	description = firstToUpper(color) .. " Robes",
    	inventory_image = texturetable.robe.item,
    	skin_image = texturetable.robe.entity,
    	groups = {cuirass=1,},
    	armor_groups = {fleshy=1},
    })

    --capes
    minetest.register_tool("default:armor_cape_"..color, {
    	description = firstToUpper(color) .. " Cape",
    	inventory_image = texturetable.cloak.item,
    	skin_image = texturetable.cloak.entity,
    	groups = {cloak=1,},
    	armor_groups = {fleshy=1},
    })

	--hood
    minetest.register_tool("default:armor_hood_"..color, {
    	description = firstToUpper(color) .. " Hood",
    	inventory_image = texturetable.hood.item,
    	skin_image = texturetable.hood.entity,
    	groups = {helmet=1,},
    	armor_groups = {fleshy=1},
    })

	--glove
    minetest.register_tool("default:armor_gloves_"..color, {
    	description = firstToUpper(color) .. " Gloves",
    	inventory_image = texturetable.gloves.item,
    	skin_image = texturetable.gloves.entity,
    	groups = {gloves=1,},
    	armor_groups = {fleshy=1},
    })

	--boots
    minetest.register_tool("default:armor_boots_"..color, {
    	description = firstToUpper(color) .. " Boots",
    	inventory_image = texturetable.boots.item,
    	skin_image = texturetable.boots.entity,
    	groups = {boots=1,},
    	armor_groups = {fleshy=1},
    })
end