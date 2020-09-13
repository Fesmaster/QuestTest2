--[[
Default (QuestTest Version)

THIS MOD IS NOT TO BE CONFUSED WITH DEFAULT FROM MINETEST_GAME

This mod loads most of the content of QuestTest
You will find almost all "regular" content from the overworld here,
unless it belongs to a specific system.

--]]
default = {}

dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/fence.lua")
dofile(minetest.get_modpath("default").."/crate.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafts.lua")
dofile(minetest.get_modpath("default").."/furnace.lua")
dofile(minetest.get_modpath("default").."/metals.lua")
dofile(minetest.get_modpath("default").."/jems.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/campfire.lua")
dofile(minetest.get_modpath("default").."/fire.lua")
dofile(minetest.get_modpath("default").."/torches.lua")
dofile(minetest.get_modpath("default").."/saplings.lua")
dofile(minetest.get_modpath("default").."/liquids.lua")

dofile(minetest.get_modpath("default").."/initial_items.lua")
-- Load other files



-- Register nodes

--Ancient default node, the first made in QuestTest2
minetest.register_node("default:default", {
	description = "Default Node",
	tiles ={"default.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
})



minetest.register_tool("default:testingHammer", {
	description = "Hammer",
	inventory_image = "default_hammer.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			if user:get_player_control().sneak then
				qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_FACE)
			else
				qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_TYPE)
			end		
		end
		
	end,
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			if user:get_player_control().sneak then
				qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_AXIS)
			else
				qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_STYLE)
			end
		end
		
	end
})


--[[
--this is how you would do panes
qts.register_fencelike_node("default:stone_brick_pane", {
	description = "Stone Brick Wall",
	type = "pane",
	texture = "default_stone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})
--]]

--[[
LIQUID TESTS
--]]




--for i=1,7 do
--	minetest.register_node("default:boxtest"..i, {
--		description = "BoxTest Node "..i,
--		tiles ={"default_testing.png"},
--		groups = {oddly_breakable_by_hand=3},
--		sounds = qtcore.node_sound_stone(),
--		drawtype = "nodebox",
--		paramtype = "light",
--		node_box = qtcore["nb_level"..i]()
--	})
--end

--NODEBOX TESTING NODE
minetest.register_node("default:boxtest", {
	description = "BoxTest Node",
	tiles ={"default_oak_leaves.png", "default_oak_leaves.png", 
		"default_oak_leaves.png^[lowpart:37:default_sapling_test_bottom.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	--on_place = function(itemstack, placer, pointed_thing)
	--	if pointed_thing.type ~= "node" then
	--		return itemstack
	--	end
	--	return qts.rotate_and_place(itemstack, placer, pointed_thing)
	--end,
})

--TESTING GRASS NODE
minetest.register_node("default:grass_5", {
	description = "Grass Node",
	tiles ={"default_grass_5.png"},
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, grass = 1, growable =1},
	sounds = qtcore.node_sound_stone(),
	on_place = qtcore.place_random_plantlike,
	
	--grow_timer = 1,
	--grow_timer_random = 0,
	--on_grow = function(pos)
	--	minetest.log("Grass Grown")
	--	minetest.set_node(pos, {name = "default:grass_5", param2 = qtcore.get_random_meshdata()})
	--	--minetest.log("Grass should be placed")
	--end,
})




--run mapgen
dofile(minetest.get_modpath("default").."/mapgen.lua")
