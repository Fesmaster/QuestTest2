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
dofile(minetest.get_modpath("default").."/foliage.lua")

dofile(minetest.get_modpath("default").."/exemplar.lua")
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
--[[
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
--]]




--run mapgen
dofile(minetest.get_modpath("default").."/mapgen.lua")
