--[[
Default (QuestTest Version)

THIS MOD IS NOT TO BE CONFUSED WITH DEFAULT FROM MINETEST_GAME

This mod loads most of the content of QuestTest
You will find almost all "regular" content from the overworld here,
unless it belongs to a specific system.

--]]
default = {}

dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/stone.lua")
--dofile(minetest.get_modpath("default").."/soil.lua")
--dofile(minetest.get_modpath("default").."/wood.lua")
dofile(minetest.get_modpath("default").."/fence.lua")
dofile(minetest.get_modpath("default").."/rope.lua")
dofile(minetest.get_modpath("default").."/crate.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafts.lua")
dofile(minetest.get_modpath("default").."/furnace.lua")
dofile(minetest.get_modpath("default").."/metals.lua")
dofile(minetest.get_modpath("default").."/jems.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/bows.lua")
dofile(minetest.get_modpath("default").."/campfire.lua")
--dofile(minetest.get_modpath("default").."/fire.lua")
dofile(minetest.get_modpath("default").."/torches.lua")
dofile(minetest.get_modpath("default").."/saplings.lua")
dofile(minetest.get_modpath("default").."/liquids.lua")
dofile(minetest.get_modpath("default").."/foliage.lua")
dofile(minetest.get_modpath("default").."/farming.lua")
dofile(minetest.get_modpath("default").."/book.lua")
dofile(minetest.get_modpath("default").."/sifter.lua")
dofile(minetest.get_modpath("default").."/furniture.lua")
dofile(minetest.get_modpath("default").."/food.lua")
dofile(minetest.get_modpath("default").."/alchemy.lua")
dofile(minetest.get_modpath("default").."/armor.lua")

dofile(minetest.get_modpath("default").."/functions.lua")

dofile(minetest.get_modpath("default").."/exemplar.lua")
dofile(minetest.get_modpath("default").."/initial_items.lua")
-- Load other files

minetest.register_tool("default:tinderbox", {
	description = "Tinderbox",
	inventory_image = "default_tinder_box.png",
	sound = qtcore.tool_sounds_default(),
	groups = {tinderbox = 1},
	on_use = function(itemstack, user, pointed_thing)
		
		if (pointed_thing.type == "node") then
			--remove item from inv
			local inv = user:get_inventory()
			local removed = inv:remove_item("main", "default:tinder 1")
			if (ItemStack(removed):is_empty()) then return end
		
			qts.ignite(pointed_thing.under)
		end
	end
})



--run mapgen
--dofile(minetest.get_modpath("default").."/mapgen.lua")
