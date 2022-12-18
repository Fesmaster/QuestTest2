--[[
    Armor definitions
]]
local colors = {"red", "orange", "yellow", "green", "cyan", "blue", "purple", "magenta", "white", "gray", "dark_gray", "black", "dark_green", "brown"}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

for _, color in ipairs(colors) do
    
    --robes
    minetest.register_tool("default:armor_robes_"..color, {
    	description = firstToUpper(color) .. " Robes",
    	inventory_image = "default_armor_robes_"..color.."_item.png",
    	skin_image = "default_armor_robes_"..color..".png",
    	groups = {cuirass=1,},
    	armor_groups = {fleshy=1},
    })

    --capes
    minetest.register_tool("default:armor_cape_"..color, {
    	description = firstToUpper(color) .. " Cape",
    	inventory_image = "default_armor_cape_"..color.."_item.png",
    	skin_image = "default_armor_cape_"..color..".png",
    	groups = {cloak=1,},
    	armor_groups = {fleshy=1},
    })

end