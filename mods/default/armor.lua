--[[
    Armor definitions
]]

local colorstring_from_dye_node_name = {
	["default:dye_red"] = "red",
	["default:dye_orange"] = "orange",
	["default:dye_yellow"] = "yellow",
	["default:dye_green"] = "green",
	["default:dye_cyan"] = "cyan",
	["default:dye_blue"] = "blue",
	["default:dye_purple"] = "purple",
	["default:dye_magenta"] = "magenta",
	["default:dye_white"] = "white",
	["default:dye_gray"] = "gray",
	["default:dye_dark_gray"] = "dark_gray",
	["default:dye_black"] = "black",
	["default:dye_dark_green"] = "dark_green",
	["default:dye_brown"] = "brown",
}


local function armor_place(itemstack, placer, pointed_thing)
	if (pointed_thing and pointed_thing.under) then
		local node = minetest.get_node_or_nil(pointed_thing.under)
		if (node and minetest.get_item_group(node.name, "dye") ~= 0) then
			--its a dye node
			minetest.log("warning", "Applying dye to a piece of armor")
			local color = colorstring_from_dye_node_name[node.name]
			local meta = itemstack:get_meta()
			meta:set_string("colorstring", color)
			meta:set_string("description", itemstack:get_short_description() .. "\n" .. color)
			meta:set_string("color", qtcore.colors[color])
		else
			minetest.log("warning", "armor not clicked against dye")
		end
	else
		minetest.log("warning", "armor not clicked valid pointed_thing")
	end
	minetest.log("warning", "armor meta: " ..dump(itemstack:get_meta():to_table()))
	return itemstack
end

local function textures_for_item(itemstack)
	local meta = itemstack:get_meta();
	local color = meta:get_string("colorstring")
	if (color == "") then
		color = meta:get_string("colorcode")
	else
		color = qtcore.colors[color]
	end
	if (color ~= "") then
		return qtcore.armor_cloth_textures(color, 79)
	else
		return qtcore.armor_cloth_textures(qtcore.colors.white, 79)
	end
end


    
local texturetable = qtcore.armor_cloth_textures(qtcore.colors.white, 79)

--robes
minetest.register_tool("default:armor_robes", {
	description = "Robes",
	inventory_image = texturetable.robe.item,
	skin_image = function(entity, itemstack)
		return textures_for_item(itemstack).robe.entity
	end,
	groups = {cuirass=1,},
	armor_groups = {fleshy=1},
	on_place = armor_place,
})

--capes
minetest.register_tool("default:armor_cape", {
	description = "Cape",
	inventory_image = texturetable.cloak.item,
	skin_image = function(entity, itemstack)
		return textures_for_item(itemstack).cloak.entity
	end,
	groups = {cloak=1,},
	armor_groups = {fleshy=1},
	on_place = armor_place,
})

--hood
minetest.register_tool("default:armor_hood", {
	description = "Hood",
	inventory_image = texturetable.hood.item,
	skin_image = function(entity, itemstack)
		return textures_for_item(itemstack).hood.entity
	end,
	groups = {helmet=1,},
	armor_groups = {fleshy=1},
	on_place = armor_place,
})

--glove
minetest.register_tool("default:armor_gloves", {
	description = "Gloves",
	inventory_image = texturetable.gloves.item,
	skin_image = function(entity, itemstack)
		return textures_for_item(itemstack).gloves.entity
	end,
	groups = {gloves=1,},
	armor_groups = {fleshy=1},
	on_place = armor_place,
})

--boots
minetest.register_tool("default:armor_boots", {
	description = "Boots",
	inventory_image = texturetable.boots.item,
	skin_image = function(entity, itemstack)
		return textures_for_item(itemstack).boots.entity
	end,
	groups = {boots=1,},
	armor_groups = {fleshy=1},
	on_place = armor_place,
})
