--[[
    Armor definitions
]]

local colorstring_from_dye_node_name = {
	["craftable:dye_red"]		= "red",
	["craftable:dye_orange"]	= "orange",
	["craftable:dye_yellow"]	= "yellow",
	["craftable:dye_green"]		= "green",
	["craftable:dye_cyan"]		= "cyan",
	["craftable:dye_blue"]		= "blue",
	["craftable:dye_purple"]	= "purple",
	["craftable:dye_magenta"]	= "magenta",
	["craftable:dye_white"]		= "white",
	["craftable:dye_gray"]		= "gray",
	["craftable:dye_dark_gray"] = "dark_gray",
	["craftable:dye_black"] 	= "black",
	["craftable:dye_dark_green"]= "dark_green",
	["craftable:dye_brown"]		= "brown",
}


local function armor_place(itemstack, placer, pointed_thing)
	if (pointed_thing and pointed_thing.under) then
		local node = minetest.get_node_or_nil(pointed_thing.under)
		if (node and minetest.get_item_group(node.name, "dye") ~= 0) then
			--its a dye node
			local color = colorstring_from_dye_node_name[node.name]
			local meta = itemstack:get_meta()
			meta:set_string("colorstring", color)
			meta:set_string("description", itemstack:get_short_description() .. "\n" .. color)
			meta:set_string("color", qtcore.colors[color])
			minetest.log("action", "Player dyed a piece of armor. Item: " .. itemstack:to_string())
		end
	end
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
minetest.register_tool("tools:cloth_armor_robes", {
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
minetest.register_tool("tools:cloth_armor_cape", {
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
minetest.register_tool("tools:cloth_armor_hood", {
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
minetest.register_tool("tools:cloth_armor_gloves", {
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
minetest.register_tool("tools:cloth_armor_boots", {
	description = "Boots",
	inventory_image = texturetable.boots.item,
	skin_image = function(entity, itemstack)
		return textures_for_item(itemstack).boots.entity
	end,
	groups = {boots=1,},
	armor_groups = {fleshy=1},
	on_place = armor_place,
})


--[[
    Armor for each utility metal.
]]



qtcore.for_all_materials("metal", function (fields_metal)
    if fields_metal.name and fields_metal.desc and fields_metal.ingot and fields_metal.utility_metal and fields_metal.craft_groups and fields_metal.quality then
        do
            local helmetname = "overworld:armor_"..fields_metal.name.."_helmet"
            local flesh = fields_metal.quality * 5
            minetest.register_craftitem(helmetname, {
                description = fields_metal.desc .." Helmet",
                inventory_image = "tools_armor_"..fields_metal.name.."_helmet_item.png",
                armor_image = "tools_armor_"..fields_metal.name.."_helmet.png",
                groups = {helmet=1,},
                stack_max=1,
                armor_groups = {fleshy=flesh},
            })       

            qts.register_craft({
                ingredients = {fields_metal.ingot.." 4"},
                results = {helmetname},
                near = fields_metal.craft_groups,
            })
       end

       do
        local cuirassname = "overworld:armor_"..fields_metal.name.."_cuirass"
        local flesh = fields_metal.quality * 15
        minetest.register_craftitem(cuirassname, {
            description = fields_metal.desc .." Cuirass",
            inventory_image = "tools_armor_"..fields_metal.name.."_cuirass_item.png",
            armor_image = "tools_armor_"..fields_metal.name.."_cuirass.png",
            groups = {cuirass=1,},
            stack_max=1,
            armor_groups = {fleshy=flesh},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 12"},
            results = {cuirassname},
            near = fields_metal.craft_groups,
        })
       end


       do
        local mailname = "overworld:armor_"..fields_metal.name.."_mail"
        local flesh = fields_metal.quality * 10
        minetest.register_craftitem(mailname, {
            description = fields_metal.desc .." Mail",
            inventory_image = "tools_armor_"..fields_metal.name.."_mail_item.png",
            armor_image = "tools_armor_"..fields_metal.name.."_mail.png",
            groups = {cuirass=1,},
            stack_max=1,
            armor_groups = {fleshy=flesh},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 8"},
            results = {cuirassname},
            near = fields_metal.craft_groups,
        })
       end

       do
        local glovesname = "overworld:armor_"..fields_metal.name.."_gloves"
        local flesh = fields_metal.quality * 2
        minetest.register_craftitem(glovesname, {
            description = fields_metal.desc .." Gloves",
            inventory_image = "tools_armor_"..fields_metal.name.."_gloves_item.png",
            armor_image = "tools_armor_"..fields_metal.name.."_gloves.png",
            groups = {gloves=1,},
            stack_max=1,
            armor_groups = {fleshy=flesh},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 2"},
            results = {glovesname},
            near = fields_metal.craft_groups,
        })
       end

       do
        local bootsname = "overworld:armor_"..fields_metal.name.."_boots"
        local flesh = fields_metal.quality * 2
        minetest.register_craftitem(bootsname, {
            description = fields_metal.desc .." Boots",
            inventory_image = "tools_armor_"..fields_metal.name.."_boots_item.png",
            armor_image = "tools_armor_"..fields_metal.name.."_boots.png",
            groups = {boots=1,},
            stack_max=1,
            armor_groups = {fleshy=flesh},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 4"},
            results = {bootsname},
            near = fields_metal.craft_groups,
        })
       end

       do
        local shieldname = "overworld:armor_"..fields_metal.name.."_sheild"
        local flesh = fields_metal.quality * 15
        minetest.register_craftitem(shieldname, {
            description = fields_metal.desc .." Shield",
            inventory_image = "tools_armor_"..fields_metal.name.."_sheild_item.png",
            armor_image = "tools_armor_"..fields_metal.name.."_sheild.png",
            groups = {shield=1,},
            stack_max=1,
            armor_groups = {fleshy=flesh},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 2", "group:wood 2"},
            results = {shieldname},
            near = fields_metal.craft_groups,
        })
       end
    end
end)
