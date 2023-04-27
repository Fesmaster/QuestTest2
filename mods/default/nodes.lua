--[[
INDEX
]]


qts.register_shaped_node("default:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	use_texture_alpha = "blend",
	drawtype = "glasslike",
	paramtype = "light",
	groups = {cracky=3, ice=1, cooling=1, slippery=4, generation_ground=1},
	sounds = qtcore.node_sound_metal(),
})
--END glass

--Begin placeable items

minetest.register_node("default:textile_flax", {
	description = "Flax Textiles",
	tiles = {
		"default_textile_flax_top.png", 
		"default_textile_flax_top.png", 
		"default_textile_flax_side.png", 
		"default_textile_flax_side.png",  
		"default_textile_flax_end.png",  
	},
	drawtype = "nodebox",
	inventory_image = "default_textile_flax_item.png",
	use_texture_alpha="clip",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -1/16, -8/16, -8/16, 6/16, -7/16, 8/16, },
			{ -5/16, -7/16, -8/16, 0/16, -6/16, 8/16, },
			{ -7/16, -8/16, -8/16, -3/16, -7/16, 8/16, },
			{ 2/16, -7/16, -8/16, 7/16, -3/16, 8/16, },
			{ 2/16, -8/16, -8/16, 6/16, -2/16, 8/16, },
			{ 1/16, -7/16, -8/16, 6/16, -3/16, 8/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:shell_pieces", {
	description = "Shell Pieces",
	tiles = {
		"default_shell_pieces_top.png",
		"default_oak_wood.png",
		"default_shell_pieces_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_shell_pieces.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})

minetest.register_alias("default:calcium_oxide", "default:lime")
minetest.register_node("default:lime", {
	description = "Lime",
	tiles = {
		"default_lime_top.png",
		"default_oak_wood.png",
		"default_lime_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_lime.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})


--doors


--[[
qts.register_trapdoor("dtools:testing_trapdoor", {
	description = "Testing Trapdoor",
	tiles = {"trapdoor_prototype.png"},
	groups = {oddly_breakable_by_hand=3},
})]]--

--[[minetest.register_node("default:bowl_clay_water", {
	description = "bowl of Water",
	tiles = {
			"default_vessel_water_top.png",
			"default_dishes_clay.png",
			"default_dishes_clay.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_vessel_water_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, vessels_water=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -3/16, -7/16, -3/16, 3/16, -6/16, 3/16, },
			{ -4/16, -6/16, 3/16, 4/16, -5/16, 4/16, },
			{ -4/16, -6/16, -4/16, 4/16, -5/16, -3/16, },
			{ 3/16, -6/16, -4/16, 4/16, -5/16, 4/16, },
			{ -4/16, -6/16, -4/16, -3/16, -5/16, 4/16, },
		},
	},
	sounds = qtcore.node_sound_stone(),
})

]]--
--END placable items