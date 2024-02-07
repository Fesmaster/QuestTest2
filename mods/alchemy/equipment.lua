--[[

]]


minetest.register_node("alchemy:equipment_basic", {
	description = "Basic Alchemy Equipment",
	tiles = {
		"alchemy_equipment_basic_top.png",  
		"foodstuffs_dishes_clay.png", 
		"alchemy_equipment_basic_side.png",
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, -4/16, -2/16, -3/16, -1/16, },
			{ -4/16, -3/16, -3/16, -3/16, -2/16, -2/16, },
			{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
			{ -5/16, -8/16, 1/16, -1/16, -3/16, 2/16, },
			{ -5/16, -8/16, 4/16, -1/16, -3/16, 5/16, },
			{ -2/16, -8/16, 1/16, -1/16, -3/16, 5/16, },
			{ -5/16, -8/16, 1/16, -4/16, -3/16, 5/16, },
			{ 1/16, -8/16, -4/16, 3/16, -7/16, -2/16, },
			{ 0/16, -7/16, -2/16, 4/16, -6/16, -1/16, },
			{ 0/16, -7/16, -5/16, 4/16, -6/16, -4/16, },
			{ 0/16, -7/16, -5/16, 1/16, -6/16, -1/16, },
			{ 3/16, -7/16, -5/16, 4/16, -6/16, -1/16, },
			{ 4/16, -6/16, -6/16, 5/16, -5/16, 0/16, },
			{ -1/16, -6/16, -6/16, 0/16, -5/16, 0/16, },
			{ -1/16, -6/16, -1/16, 5/16, -5/16, 0/16, },
			{ -1/16, -6/16, -6/16, 5/16, -5/16, -5/16, },
			{ 6/16, -8/16, -1/16, 7/16, -7/16, 2/16, },

		},
	},
	selection_box = {
		type= "fixed",
		fixed = {
			{ -5/16, -8/16, -6/16, 7/16, -2/16, 5/16, },
		}
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("alchemy:equipment_advanced", {
	description = "Advanced Alchemy Equipment",
	tiles = {
		"alchemy_equipment_advanced_top.png",  
		"foodstuffs_dishes_clay.png", 
		"alchemy_equipment_advanced_side.png",
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, 2/16, -2/16, -4/16, 3/16, },
			{ -2/16, -8/16, 1/16, -1/16, -3/16, 2/16, },
			{ -2/16, -8/16, 3/16, -1/16, -3/16, 4/16, },
			{ -4/16, -8/16, 3/16, -3/16, -3/16, 4/16, },
			{ -4/16, -8/16, 1/16, -3/16, -3/16, 2/16, },
			{ -4/16, -3/16, 1/16, -1/16, -2/16, 4/16, },
			{ -4/16, -8/16, 1/16, -1/16, -6/16, 4/16, },
			{ -4/16, -2/16, 0/16, -1/16, -1/16, 1/16, },
			{ -4/16, -2/16, 4/16, -1/16, -1/16, 5/16, },
			{ -1/16, -2/16, 1/16, 0/16, -1/16, 4/16, },
			{ -5/16, -2/16, 1/16, -4/16, -1/16, 4/16, },
			{ -4/16, -8/16, -5/16, -2/16, -7/16, -3/16, },
			{ -4/16, -7/16, -6/16, -2/16, -6/16, -5/16, },
			{ -4/16, -7/16, -3/16, -2/16, -6/16, -2/16, },
			{ -2/16, -7/16, -5/16, -1/16, -6/16, -3/16, },
			{ -5/16, -7/16, -5/16, -4/16, -6/16, -3/16, },

		},
	},
	selection_box = {
		type= "fixed",
		fixed = {
			{ -5/16, -8/16, -6/16, 0/16, -1/16, 5/16, },
		}
	},
	sounds = qtcore.node_sound_stone(),
})


--flasks
minetest.register_node("alchemy:flask_glass", {
	description = "Glass Flask",
	tiles = {
		"alchemy_flask_glass_top.png",
		"alchemy_flask_glass_bottom.png",
		"alchemy_flask_glass_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "alchemy_flask_glass_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -4/16, 2/16, },
			{ -1/16, -4/16, -1/16, 1/16, -1/16, 1/16, },
		},
	},
	selection_box = {
		type= "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -1/16, 2/16, },
		}
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("alchemy:flask_glass_water", {
	description = "Glass Water Flask",
	tiles = {
		"alchemy_flask_glass_top.png",
		"alchemy_flask_glass_bottom.png",
		"alchemy_flask_glass_water_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "alchemy_flask_glass_water_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -4/16, 2/16, },
			{ -1/16, -4/16, -1/16, 1/16, -1/16, 1/16, },
		},
	},
	selection_box = {
		type= "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -1/16, 2/16, },
		}
	},
	sounds = qtcore.node_sound_glass(),
})