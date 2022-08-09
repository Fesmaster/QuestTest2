--[[
    Wood and Tree bits live here
]]


--Planks and Logs
qts.register_shaped_node ("default:oak_wood_planks", {
	description = "Oak Wood Planks",
	tiles = {"default_oak_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:oak_log", {
	description = "Oak Log",
	tiles = {"default_oak_top.png", "default_oak_top.png", "default_oak_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:rowan_wood_planks", {
	description = "Rowan Wood Planks",
	tiles = {"default_rowan_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:rowan_log", {
	description = "Rowan Log",
	tiles = {"default_rowan_top.png", "default_rowan_top.png", "default_rowan_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:apple_wood_planks", {
	description = "Apple Wood Planks",
	tiles = {"default_apple_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:apple_log", {
	description = "Apple Log",
	tiles = {"default_apple_top.png", "default_apple_top.png", "default_apple_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:aspen_wood_planks", {
	description = "Aspen Wood Planks",
	tiles = {"default_aspen_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:aspen_log", {
	description = "Aspen Log",
	tiles = {"default_aspen_top.png", "default_aspen_top.png", "default_aspen_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:lanternfruit_wood_planks", {
	description = "Lanternfruit Wood Planks",
	tiles = {{name = "default_lanternfruit_wood.png", align_style = "node"}},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:lanternfruit_log", {
	description = "Lanternfruit Log",
	tiles = {"default_lanternfruit_top.png", "default_lanternfruit_top.png", "default_lanternfruit_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})
--for shematic legacy reasons
minetest.register_alias("default:lanterfruit_log", "default:lanternfruit_log")
minetest.register_alias("default:lanterfruit_log_stair", "default:lanternfruit_log_stair")
minetest.register_alias("default:lanterfruit_log_stair_inner", "default:lanternfruit_log_stair_inner")
minetest.register_alias("default:lanterfruit_log_stair_outer", "default:lanternfruit_log_stair_outer")
minetest.register_alias("default:lanterfruit_log_slant", "default:lanternfruit_log_slant")
minetest.register_alias("default:lanterfruit_log_slant_inner", "default:lanternfruit_log_slant_inner")
minetest.register_alias("default:lanterfruit_log_slant_outer", "default:lanternfruit_log_slant_oute")
minetest.register_alias("default:lanterfruit_log_slab", "default:lanternfruit_log_slab")

qts.register_shaped_node ("default:coffee_wood_planks", {
	description = "Coffee Wood Planks",
	tiles = {"default_coffee_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:coffee_log", {
	description = "Coffee Log",
	tiles = {"default_coffee_top.png", "default_coffee_top.png", "default_coffee_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:rosewood_wood_planks", {
	description = "Rosewood Planks",
	tiles = {"default_rosewood_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:rosewood_log", {
	description = "Rosewood Log",
	tiles = {"default_rosewood_top.png", "default_rosewood_top.png", "default_rosewood_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:mahogany_wood_planks", {
	description = "Mahogany Planks",
	tiles = {"default_mahogany_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:mahogany_log", {
	description = "Mahogany Log",
	tiles = {"default_mahogany_top.png", "default_mahogany_top.png", "default_mahogany_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:palm_log", {
	description = "Palm Log",
	tiles = {"default_palm_top.png", "default_palm_top.png", "default_palm_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:pine_wood_planks", {
	description = "Pine Planks",
	tiles = {"default_pine_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:pine_log", {
	description = "Pine Log",
	tiles = {"default_pine_top.png", "default_pine_top.png", "default_pine_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:swamp_wood_planks", {
	description = "Swamp Wood Planks",
	tiles = {{name = "default_swamp_wood.png", align_style = "node"}},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})

minetest.register_node("default:swamp_log", {
	description = "Swamp Log",
	tiles = {
		"default_swamp_log_top.png",
		"default_swamp_log_top.png",
		"default_swamp_log_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.375, 0, 0.5, -0.0625}, -- NodeBox10
			{0.0625, -0.5, 0, 0.4375, 0.9375, 0.375}, -- NodeBox11
		}
	}
})

qts.register_shaped_node ("default:bamboo_slats", {
	description = "Bamboo Slats",
	tiles = {"default_bamboo_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:bamboo", {
	description = "Bamboo",
	tiles = {
		"default_bamboo_log_top.png",
		"default_bamboo_log_top.png",
		"default_bamboo_log_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=2, log=1, generation_trees=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -6/16, -1/16, 8/16, -4/16, },
			{ -6/16, -8/16, 3/16, -3/16, 8/16, 6/16, },
			{ 4/16, -8/16, 1/16, 6/16, 8/16, 3/16, },
			{ 1/16, -8/16, -4/16, 4/16, 8/16, -1/16, },
		}
	}
})


--alias for worldgen purposes
minetest.register_alias("default:swamp_tree", "default:swamp_log")
--END wood



--Mushrooms
qts.register_shaped_node ("default:blue_mushroom_trunk", {
	description = "Blue Mushroom Trunk",
	tiles = {"default_mushroom_blue_top.png", "default_mushroom_blue_top.png", "default_mushroom_blue_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:blue_mushroom_cap", {
	description = "Blue Mushroom Cap",
	tiles = {"default_mushroom_blue_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:blue_mushroom_slats", {
	description = "Blue Mushroom Slats",
	tiles = {"default_mushroom_blue_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:blue_mushroom_plates", {
	description = "Blue Mushroom Plates",
	tiles = {"default_mushroom_blue_plates.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_trunk", {
	description = "Golden Mushroom Trunk",
	tiles = {"default_mushroom_gold_top.png", "default_mushroom_gold_top.png", "default_mushroom_gold_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_cap", {
	description = "Golden Mushroom Cap",
	tiles = {"default_mushroom_gold_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_slats", {
	description = "Gold Mushroom Slats",
	tiles = {"default_mushroom_gold_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_plates", {
	description = "Gold Mushroom Plates",
	tiles = {"default_mushroom_gold_plates.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:gold_mushroom_spore", {
	description = "Golden Mushroom Spore",
	tiles = {"default_mushroom_gold_spore.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, spore = 1, generation_replacable=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.4375, 0, -0.3125, -0.1875}, -- NodeBox1
			{0.0625, -0.5, -0.25, 0.4375, -0.25, 0.125}, -- NodeBox2
			{-0.25, -0.5, -0.0625, -0.125, -0.375, 0.0625}, -- NodeBox3
			{-0.3125, -0.5, 0.125, 0.0625, -0.1875, 0.4375}, -- NodeBox4
		}
	}
})
minetest.register_alias("default:gold_shroom_spore", "default:gold_mushroom_spore")

qts.register_shaped_node ("default:brown_mushroom_trunk", {
	description = "Brown Mushroom Trunk",
	tiles = {"default_mushroom_brown_top.png", "default_mushroom_brown_top.png", "default_mushroom_brown_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})


qts.register_shaped_node ("default:brown_mushroom_cap", {
	description = "Brown Mushroom Cap",
	tiles = {"default_mushroom_brown_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:brown_mushroom_slats", {
	description = "Brown Mushroom Slats",
	tiles = {"default_mushroom_brown_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:brown_mushroom_plates", {
	description = "Brown Mushroom Plates",
	tiles = {"default_mushroom_brown_plates.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})



--Leaves
--[[
leaves use param2 to hold if they were placed by the player
to allow player-placed leaves to not decay
--]]

minetest.register_node("default:oak_leaves", {
	description = "Oak Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_oak_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:oak_sapling"}, rarity = 16},
			{items = {"default:oak_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:aspen_leaves", {
	description = "Aspen Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_aspen_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:aspen_sapling"}, rarity = 16},
			{items = {"default:aspen_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:apple_leaves", {
	description = "Apple Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:apple_sapling"}, rarity = 16},
			{items = {"default:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:apple_leaves_fruit", {
	description = "Apple Leaves with Apples",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves_fruit.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 2,
		items = {
			{items = {"default:apple"}},
			{items = {"default:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:rowan_leaves", {
	description = "Rowan Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rowan_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:rowan_sapling"}, rarity = 16},
			{items = {"default:rowan_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:lanternfruit_leaves", {
	description = "Lanternfruit Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_lanternfruit_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:lanternfruit_sapling"}, rarity = 16},
			{items = {"default:lanternfruit_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:coffeetree_leaves", {
	description = "Coffee Tree Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_coffee_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:coffee_beans 2"}, rarity = 8},
			{items = {"default:coffeetree_sapling"}, rarity = 16},
			{items = {"default:coffeetree_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:mahogany_leaves", {
	description = "Mahogany Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_mahogany_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:mahogany_sapling"}, rarity = 16},
			{items = {"default:mahogany_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

--[[minetest.register_node("default:blackwood_leaves", {
	description = "Blackwood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_blackwood_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})
]]--

minetest.register_node("default:rosewood_leaves", {
	description = "Rosewood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rosewood_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:rosewood_sapling"}, rarity = 16},
			{items = {"default:rosewood_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:palm_leaves", {
	description = "Palm Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_palm_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:palm_sapling"}, rarity = 16},
			{items = {"default:palm_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})




minetest.register_node("default:swamp_leaves", {
	description = "Swamp Leaves",
	tiles = {"default_swamp_leaves.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	waving = 1,
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
	node_box = {
		type = "fixed",
		fixed = {
			{-0.625, -0.5, -0.625, 0.625, 0.6875, 0.625}, -- NodeBox12
			{-0.0625, 0.125, 0.1875, 0.75, 0.9375, 0.875}, -- NodeBox13
			{-0.9375, -0.75, -1, -0.125, 0, -0.125}, -- NodeBox14
		}
	}
})

minetest.register_node("default:bamboo_leaves", {
	description = "Bamboo Leaves",
	tiles = {
			"default_bamboo_leaves_top.png", "default_bamboo_leaves_side.png",
		},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	waving = 1,
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	walkable = false,
	climbable = false,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -6/16, -1/16, 8/16, -4/16, },
			{ -6/16, -8/16, 3/16, -3/16, 8/16, 6/16, },
			{ 4/16, -8/16, 1/16, 6/16, 8/16, 3/16, },
			{ 1/16, -8/16, -4/16, 4/16, 8/16, -1/16, },
			{ 6/16, -10/16, 6/16, 10/16, -6/16, 10/16, },
			{ -1/16, -5/16, 7/16, 1/16, 7/16, 9/16, },
			{ -9/16, -5/16, 6/16, -6/16, 3/16, 9/16, },
			{ -9/16, -1/16, -1/16, -7/16, 5/16, 1/16, },
			{ -10/16, 6/16, -10/16, -6/16, 10/16, -6/16, },
			{ -1/16, 6/16, -10/16, 1/16, 10/16, 3/16, },
			{ 6/16, -2/16, -10/16, 10/16, 2/16, -6/16, },
			{ 0/16, -9/16, -1/16, 9/16, 2/16, 1/16, },
			{ -8/16, -8/16, -8/16, 8/16, 8/16, 8/16, },
		}
	}
})

minetest.register_node("default:pine_leaves", {
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_pine_needles.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 16},
			{items = {"default:pine_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

