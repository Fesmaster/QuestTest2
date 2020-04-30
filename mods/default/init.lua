-- default (Minetest 0.4 mod)
-- Most default stuff

-- The API documentation in here was moved into doc/lua_api.txt

-- Definitions made by this mod that other mods can use too
default = {}
function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=1.0}
	table.dug = table.dug or
			{name="default_dug_node", gain=1.0}
	return table
end

dofile(minetest.get_modpath("default").."/nodes.lua")
-- Load other files






-- Default node sounds



-- Register nodes

minetest.register_node("default:default", {
	description = "Default Node",
	tiles ={"default.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
})



minetest.register_tool("default:testingHammer", {
	description = "Testing Hammer",
	inventory_image = "qts_testing_tool.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool used")
		if pointed_thing.under then
			if user:get_player_control().sneak then
				qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_FACE)
			else
				qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_TYPE)
			end		
		end
		
	end,
	on_place = function(itemstack, user, pointed_thing)
	minetest.log("QTS Testing Tool placed")
		if pointed_thing.under then
			if user:get_player_control().sneak then
				qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_AXIS)
			else
				qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_STYLE)
			end
		end
		
	end
})

--register materials here





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
--bucket
qts.register_bucket("default:bucket", {
	description = "Bucket",
	inventory_image = "bucket.png",
	groups= {bucket_level = 1},
})

--liquid nodes
qts.register_liquid("default:water", {
	description = "Water",
	tiles = qtcore.liquid_texture("default_water_source_animated.png", 2.0),
	special_tiles = qtcore.liquid_texture("default_water_flowing_animated.png", 0.5),
	bucket_image = "bucket_water.png",
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1},
	sounds = qtcore.node_sound_water(),
})

--ingot type object
qts.register_ingot("default:iron_bar", {
	description = "Iron Bar",
	inventory_image = "default_iron_ingot.png",
	tiles = {"default_iron_block.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = {
		{-0.5, -0.5, 0.1875, 0.125, -0.3125, 0.4375}, -- NodeBox45
		{-0.5, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox46
		{-0.5, -0.5, -0.4375, 0.125, -0.3125, -0.1875}, -- NodeBox49
		{-0.5, -0.3125, -0.3125, 0.125, -0.125, -0.0624999}, -- NodeBox51
		{-0.5, -0.3125, 0.0625, 0.125, -0.125, 0.3125}, -- NodeBox52
		{-0.5, -0.125, -0.125, 0.125, 0.0625, 0.125}, -- NodeBox53
		{0.1875, -0.5, -0.375, 0.4375, -0.3125, 0.25}, -- NodeBox54
		{0.125, -0.3125, -0.25, 0.3125, -0.0625, 0.375}, -- NodeBox55
	},
	levels = 8,
})

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
minetest.register_node("default:boxtest", {
	description = "BoxTest Node",
	tiles ={"default_oak_leaves.png", "default_oak_leaves.png", 
		"default_oak_leaves.png^[lowpart:37:default_sapling_test_bottom.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			--{-0.1875, -0.5, -0.1875, 0.1875, -0.4375, 0.1875}, -- NodeBox1
			--{-0.125, -0.4375, -0.125, 0.125, -0.375, 0.125}, -- NodeBox2
			{-0.0625, -0.5, -0.0625, 0.0625, 0.1875, 0.0625}, -- NodeBox3
			{-0.25, -0.125, -0.25, 0.25, 0.4375, 0.25}, -- NodeBox4
			{-0.3125, 0.25, -0.3125, -0.0625, 0.5, -0.0624999}, -- NodeBox5
			{0.0625, 0.125, -0.25, 0.3125, 0.375, 7.45058e-008}, -- NodeBox6
			{-0.25, -0.0625, 0.0625, 1.49012e-008, 0.1875, 0.3125}, -- NodeBox7
		}
	},
	
	paramtype2 = "facedir",
	--on_place = function(itemstack, placer, pointed_thing)
	--	if pointed_thing.type ~= "node" then
	--		return itemstack
	--	end
	--	return qts.rotate_and_place(itemstack, placer, pointed_thing)
	--end,
})

qts.register_growable_node("default:grass_5", {
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
	
	grow_timer = 1,
	grow_timer_random = 0,
	on_grow = function(pos)
		minetest.log("Grass Grown")
		minetest.set_node(pos, {name = "default:grass_5", param2 = qtcore.get_random_meshdata()})
		--minetest.log("Grass should be placed")
	end,
})




--run mapgen
dofile(minetest.get_modpath("default").."/mapgen.lua")