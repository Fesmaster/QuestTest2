--[[
INDEX




]]
--BEGIN light blocks
qts.register_shaped_node("default:solas_block_white", {
	description = "White Solas Block",
	tiles ={
		"default_solas_block_white.png"
		},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	walkable = true,
	groups = {cracky = 3, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

qts.register_shaped_node("default:solas_block_blue", {
	description = "Blue Solas Block",
	tiles ={
		"default_solas_block_blue.png"
		},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	walkable = true,
	groups = {cracky = 3, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

qts.register_shaped_node("default:solas_block_green", {
	description = "Green Solas Block",
	tiles ={
		"default_solas_block_green.png"
		},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	walkable = true,
	groups = {cracky = 3, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

qts.register_shaped_node("default:solas_block_red", {
	description = "Red Solas Block",
	tiles ={
		"default_solas_block_red.png"
		},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	walkable = true,
	groups = {cracky = 3, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

qts.register_shaped_node("default:solas_block_purple", {
	description = "Purple Solas Block",
	tiles ={
		"default_solas_block_purple.png"
		},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	walkable = true,
	groups = {cracky = 3, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

qts.register_shaped_node("default:solas_block_orange", {
	description = "Orange Solas Block",
	tiles ={
		"default_solas_block_orange.png"
		},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	walkable = true,
	groups = {cracky = 3, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})
--BEGIN fruit
minetest.register_node("default:lantern_fruit", {
	description = "Lantern Fruit",
	tiles ={
		"default_lantern_fruit_top.png", 
		"default_lantern_fruit_bottom.png",
		"default_lantern_fruit_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	node_box = qtcore.nb_lantern_fruit(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 3, fruit = 1, generation_trees=1, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})


--END fruit


--BEGIN crafting
minetest.register_node("default:workbench", {
	description = "Workbench",
	tiles = {
		"default_workbench_top.png",
		"default_workbench_bottom.png",
		"default_workbench_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, workbench=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 5/16, -8/16, 8/16, 8/16, 8/16, },
			{ -7/16, -8/16, -7/16, -4/16, 6/16, -4/16, },
			{ 4/16, -8/16, -7/16, 7/16, 6/16, -4/16, },
			{ 4/16, -8/16, 4/16, 7/16, 6/16, 7/16, },
			{ -7/16, -8/16, 4/16, -4/16, 6/16, 7/16, },
			--[[{-0.5, 0.25, -0.5, 0.5, 0.4375, 0.5}, -- Top
			{-0.4375, -0.5, -0.4375, -0.25, 0.25, -0.25}, -- leg1
			{0.25, -0.5, -0.4375, 0.4375, 0.25, -0.25}, -- leg2
			{0.25, -0.5, 0.25, 0.4375, 0.25, 0.4375}, -- leg3
			{-0.4375, -0.5, 0.25, -0.25, 0.25, 0.4375}, -- leg4
			--{-0.3125, -0.25, -0.3125, 0.3125, -0.1875, 0.3125}, -- shelf]]
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:workbench_heavy", {
	description = "Heavy Workbench",
	tiles = {
		"default_workbench_heavy_top.png",
		"default_workbench_bottom.png",
		"default_workbench_heavy_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, workbench=2, workbench_heavy=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 5/16, -8/16, 8/16, 8/16, 8/16, },
			{ -7/16, -8/16, -7/16, -4/16, 6/16, -4/16, },
			{ 4/16, -8/16, -7/16, 7/16, 6/16, -4/16, },
			{ 4/16, -8/16, 4/16, 7/16, 6/16, 7/16, },
			{ -7/16, -8/16, 4/16, -4/16, 6/16, 7/16, },
--[[			{-0.5, 0.25, -0.5, 0.5, 0.4375, 0.5}, -- Top
			{-0.4375, -0.5, -0.4375, -0.25, 0.25, -0.25}, -- leg1
			{0.25, -0.5, -0.4375, 0.4375, 0.25, -0.25}, -- leg2
			{0.25, -0.5, 0.25, 0.4375, 0.25, 0.4375}, -- leg3
			{-0.4375, -0.5, 0.25, -0.25, 0.25, 0.4375}, -- leg4
			--{-0.3125, -0.25, -0.3125, 0.3125, -0.1875, 0.3125}, -- shelf--]]--
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:anvil", {
	description = "Steel Block",
	tiles = {"default_anvil.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.0625, -0.3125, 0.5, 0.375, 0.3125}, -- Head
			{-0.375, -0.5, -0.3125, 0.375, -0.3125, 0.3125}, -- Base
			{-0.3125, -0.3125, -0.25, 0.3125, -0.25, 0.25}, -- Base2
			{-0.1875, -0.375, -0.125, 0.1875, 0.125, 0.125}, -- Stem
			{-0.375, 0, -0.1875, 0.375, 0.0625, 0.1875}, -- Head2
		}
	},
	groups = {cracky=2, falling_node=1, anvil=1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})
--END crafting

--BEGIN glass
minetest.register_node ("default:glass", {
	description = "Glass",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	use_texture_alpha = "clip",
	groups = {cracky=3, glass=1, oddly_breakable_by_hand=3, generation_artificial=1},
	drawtype = "glasslike_framed_optional",
	is_ground_content = false,
	sounds = qtcore.node_sound_metal(),
	paramtype = "light",
	sunlight_propagates = true,
})

qts.register_fencelike_node("default:glass_pane", {
	description = "Glass Pane",
	type = "pane",
	tiles = {"default_glass_pane_top.png","default_glass.png","default_glass_pane.png"},
	use_texture_alpha = "clip",
	groups = {cracky=3, glass=1, oddly_breakable_by_hand=3, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

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

--BEGIN furnature
--BEGIN tables (group:ttable)

--END furnature

--Begin placeable items

minetest.register_node("default:storage_pot_greenware", {
	description = "Greenware Storage Pot",
	tiles = {
		"default_dishes_clay_greenware.png",
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -3/16, -7/16, -3/16, -2/16, -6/16, 3/16, },
			{ 2/16, -7/16, -3/16, 3/16, -6/16, 3/16, },
			{ -3/16, -7/16, -3/16, 3/16, -6/16, -2/16, },
			{ -3/16, -7/16, 2/16, 3/16, -6/16, 3/16, },
			{ -4/16, -6/16, -4/16, 4/16, -1/16, -3/16, },
			{ 3/16, -6/16, -4/16, 4/16, -1/16, 4/16, },
			{ -4/16, -6/16, 3/16, 4/16, -1/16, 4/16, },
			{ -4/16, -6/16, -4/16, -3/16, -1/16, 4/16, },
			{ -3/16, -1/16, 2/16, 3/16, 0/16, 3/16, },
			{ -3/16, -1/16, -3/16, 3/16, 0/16, -2/16, },
			{ 2/16, -1/16, -3/16, 3/16, 0/16, 3/16, },
			{ -3/16, -1/16, -3/16, -2/16, 0/16, 3/16, },
			{ -2/16, -1/16, -2/16, -1/16, 3/16, 2/16, },
			{ 1/16, -1/16, -2/16, 2/16, 3/16, 2/16, },
			{ -2/16, -1/16, -2/16, 2/16, 3/16, -1/16, },
			{ -2/16, -1/16, 1/16, 2/16, 3/16, 2/16, },
			{ -3/16, 3/16, -3/16, -1/16, 4/16, 3/16, },
			{ 1/16, 3/16, -3/16, 3/16, 4/16, 3/16, },
			{ -3/16, 3/16, -3/16, 3/16, 4/16, -1/16, },
			{ -3/16, 3/16, 1/16, 3/16, 4/16, 3/16, },
			},
		},
})

minetest.register_node("default:alchemy_equipment_basic", {
	description = "Basic Alchemy Equipment",
	tiles = {
		"default_alchemy_equipment_basic_top.png",  
		"default_dishes_clay.png", 
		"default_alchemy_equipment_basic_side.png",
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
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:alchemy_equipment_advanced", {
	description = "Advanced Alchemy Equipment",
	tiles = {
		"default_alchemy_equipment_advanced_top.png",  
		"default_dishes_clay.png", 
		"default_alchemy_equipment_advanced_side.png",
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
	sounds = qtcore.node_sound_stone(),
})

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

qts.register_ingot("default:wax_palm", {
	description = "Palm Wax",
	inventory_image = "default_wax_palm_item.png",
	tiles = {
		"default_wax_palm_ingot.png"
	},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = {
			{ -6/16, -8/16, 1/16, -3/16, -6/16, 6/16, },
			{ -2/16, -8/16, 1/16, 1/16, -6/16, 6/16, },
			{ 2/16, -8/16, 1/16, 5/16, -6/16, 6/16, },
			{ -6/16, -8/16, -6/16, -3/16, -6/16, -1/16, },
			{ -2/16, -8/16, -6/16, 1/16, -6/16, -1/16, },
			{ 2/16, -8/16, -6/16, 5/16, -6/16, -1/16, },
			{ 0/16, -6/16, -2/16, 3/16, -4/16, 3/16, },
			{ -4/16, -6/16, -3/16, -1/16, -4/16, 2/16, },
			},
	levels = 8,
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

--BEGIN dyes

minetest.register_node("default:dye_black", {
	description = "Black Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_black_bottom.png",
		"default_dye_black_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_black.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
			},
		},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_blue", {
	description = "Blue Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_blue_bottom.png",
		"default_dye_blue_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_black.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
			},
		},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_brown", {
	description = "Brown Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_brown_bottom.png",
		"default_dye_brown_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_blrown.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
			},
		},
	sounds = qtcore.node_sound_glass(),
})


minetest.register_node("default:dye_cyan", {
	description = "Cyan Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_cyan_bottom.png",
		"default_dye_cyan_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_cyan.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_dark_gray", {
	description = "Dark Gray Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_dark_gray_bottom.png",
		"default_dye_dark_gray_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_dark_gray.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_dark_green", {
	description = "Dark Green Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_dark_green_bottom.png",
		"default_dye_dark_green_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_dark_green.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_gray", {
	description = "Gray Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_gray_bottom.png",
		"default_dye_gray_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_gray.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass()
})

minetest.register_node("default:dye_green", {
	description = "Green Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_green_bottom.png",
		"default_dye_green_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_green.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_magenta", {
	description = "Magenta Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_magenta_bottom.png",
		"default_dye_magenta_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_magenta.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_orange", {
	description = "Orange Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_orange_bottom.png",
		"default_dye_orange_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_orange.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_purple", {
	description = "Purple Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_purple_bottom.png",
		"default_dye_purple_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_purple.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_red", {
	description = "Red Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_red_bottom.png",
		"default_dye_red_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_red.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_white", {
	description = "White Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_white_bottom.png",
		"default_dye_white_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_white.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
})

minetest.register_node("default:dye_yellow", {
	description = "Yellow Dye",
	tiles = {
		"default_dye_top.png",
		"default_dye_yellow_bottom.png",
		"default_dye_yellow_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_dye_yellow.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dye = 1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -3/16, 3/16, -2/16, 3/16, },
			{ -1/16, -6/16, -1/16, 1/16, 1/16, 1/16, },
			{ -2/16, -5/16, -2/16, 2/16, -1/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_glass(),
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