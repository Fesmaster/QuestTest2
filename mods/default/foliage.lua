--holds plants and underbrush


minetest.register_node("default:swamp_plant", {
	description = "A Strange Plant that lives in the swamp",
	tiles = {"default_swamp_temp_plant.png"},
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {oddly_breakable_by_hand=2, flammable=2, snappy=3, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
})

minetest.register_node("default:small_shroom", {
	description = "A Small Edible Mushroom",
	tiles = {"default_small_shroom.png"},
	drawtype = "nodebox",
	paramtype = "light",
	walkable = false,
	groups = {snappy = 3, flammable = 2, snappy=3, attached_node=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, 0.125, -0.125, -0.3125, 0.1875}, -- NodeBox5
			{-0.25, -0.3125, 0.0625, -0.0625, -0.25, 0.25}, -- NodeBox6
			{-0.25, -0.375, 0, -0.0625, -0.3125, 0.3125}, -- NodeBox7
			{-0.3125, -0.375, 0.0625, 0, -0.3125, 0.25}, -- NodeBox8
			{0.125, -0.5, -0.1875, 0.1875, -0.4375, -0.125}, -- NodeBox9
			{0.0625, -0.4375, -0.25, 0.25, -0.375, -0.0625}, -- NodeBox10
		}
	},
	sounds = qtcore.node_sound_defaults(),
})



minetest.register_node("default:grass_short", {
	description = "Grass Node",
	tiles ={"default_grass_short.png"},
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, grass = 1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
})

minetest.register_node("default:grass_tall", {
	description = "Grass Node",
	tiles ={"default_grass_tall.png"},
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, grass = 1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
})

minetest.register_node("default:grass_dry_short", {
	description = "Dry Grass Node",
	tiles ={"default_dry_grass_short.png"},
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, grass = 1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
})

minetest.register_node("default:grass_dry_tall", {
	description = "Dry Grass Node",
	tiles ={"default_dry_grass_tall.png"},
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, grass = 1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
})

minetest.register_node("default:underbrush_short", {
	description = "Underbrush",
	tiles ={"default_underbrush.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	--selection_box = qtcore.nb_level1(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.3125, 0.5, -0.0625, 0.375}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.0625, -0.1875, 0.5}, -- NodeBox3
			{-0.375, -0.5, -0.5, 0.25, 0.0625, 2.98023e-008}, -- NodeBox4
		}
	},
	groups = {snappy=3, flammable = 2, grass = 1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	--on_place = qtcore.place_random_plantlike,
})
minetest.register_node("default:underbrush_tall", {
	description = "Underbrush",
	tiles ={"default_underbrush.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	--selection_box = qtcore.nb_level1(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.1875, 0.4375, 0.5, 0.5}, -- NodeBox2
			{-0.5, -0.5, -0.375, 0.0625, 0.25, 0.3125}, -- NodeBox3
			{-0.125, -0.5, -0.5, 0.5, 0.0625, 1.49012e-008}, -- NodeBox4
			{-0.25, -0.5, -0.4375, 0.375, 0.375, -0.125}, -- NodeBox5
			{-0.4375, -0.5, 0.125, 0, 0.1875, 0.4375}, -- NodeBox6
		}
	},
	groups = {snappy=3, flammable = 2, grass = 1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	--on_place = qtcore.place_random_plantlike,
})

minetest.register_lbm({
	label = "Legacy grass replacement",
	name = "default:grass_5",
	run_at_every_load = true,
	action = function(pos, node)
		minetest.set_node(pos, {name = "default:grass_tall", param2 = qtcore.get_random_meshdata()})
	end
})

--[[
--grow_timer = 1,
	--grow_timer_random = 0,
	--on_grow = function(pos)
	--	minetest.log("Grass Grown")
	--	minetest.set_node(pos, {name = "default:grass_5", param2 = qtcore.get_random_meshdata()})
	--	--minetest.log("Grass should be placed")
	--end,
--]]