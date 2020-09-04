

--[[
INDEX




]]



--stone
qts.register_shaped_node("default:cement", {
	description = "Cement",
	tiles = {"default_cement.png"},
	groups = {cracky=3},
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:stone_cobble", {
	description = "Cobblestone",
	tiles = {"default_stone_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
minetest.register_alias("default:cobble", "default:stone_cobble")--TODO: remove backwards compatability

qts.register_shaped_node ("default:stone_brick", {
	description = "Stone Brick",
	tiles = {"default_stone_brick.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:stone_block", {
	description = "Stone Block",
	tiles = {"default_stone_block.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
	
qts.register_shaped_node ("default:stone_cobble_mossy", {
	description = "Mossy Cobblestone",
	tiles = {"default_stone_cobble_mossy.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:stone_brick_mossy", {
	description = "Mossy Stone Brick",
	tiles = {"default_stone_brick_mossy.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

--desert_stone
qts.register_shaped_node ("default:red_stone", {
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:red_stone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:red_stone_cobble", {
	description = "Red Cobblestone",
	tiles = {"default_red_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:red_stone_brick", {
	description = "Red Stone Brick",
	tiles = {"default_red_stone_brick.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:red_stone_block", {
	description = "Red Stone Block",
	tiles = {"default_red_stone_block.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})


--sandstone
qts.register_shaped_node ("default:sandstone", {
	description = "sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:sandstone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:sandstone_cobble", {
	description = "Sandstone Cobble",
	tiles = {"default_sandstone_cobble.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:sandstone_brick", {
	description = "Sandstone Brick",
	tiles = {"default_sandstone_brick.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:sandstone_block", {
	description = "Sandstone Block",
	tiles = {"default_sandstone_block.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:desert_sandstone", {
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:desert_sandstone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:desert_sandstone_cobble", {
	description = "Desert Sandstone Cobble",
	tiles = {"default_desert_sandstone_cobble.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:desert_sandstone_brick", {
	description = "Desert Sandstone Brick",
	tiles = {"default_desert_sandstone_brick.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:desert_sandstone_block", {
	description = "Desert Sandstone Block",
	tiles = {"default_desert_sandstone_block.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})


qts.register_shaped_node ("default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=1, obsidian=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:obsidian_brick", {
	description = "Obsidian Brick",
	tiles = {"default_obsidian_brick.png"},
	groups = {cracky=1, obsidian=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:obsidian_block", {
	description = "Obsidian Block",
	tiles = {"default_obsidian_block.png"},
	groups = {cracky=1, obsidian=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})


qts.register_shaped_node ("default:brick", {
	description = "Brick",
	tiles = {"default_brick.png"},
	groups = {cracky=3, bricks=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:brick_grey", {
	description = "Grey Brick",
	tiles = {"default_brick_grey.png"},
	groups = {cracky=3, bricks=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

--soils and the like

qts.register_shaped_node("default:clay", {
	description = "Clay Block",
	tiles = {"default_clay_block.png"},
	groups = {crumbly=3},
	sounds = qtcore.node_sound_stone(),
	drop = "default:clay_lump 4"
})


qts.register_shaped_node ("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil=1},
	sounds = qtcore.node_sound_dirt(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})

qts.register_shaped_node ("default:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})

--fix the sides of grass on the full node
minetest.override_item("default:dirt_with_grass", {
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_swamp_grass", {
	description = "Dirt with Swamp Grass",
	tiles = {"default_swamp_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})

minetest.override_item("default:dirt_with_swamp_grass", {
	tiles = {"default_swamp_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_swamp_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_prarie_grass", {
	description = "Dirt with Prarie Grass",
	tiles = {"default_prarie_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})

minetest.override_item("default:dirt_with_prarie_grass", {
	tiles = {"default_prarie_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_prarie_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_mushroom_grass", {
	description = "Dirt with Mycelium",
	tiles = {"default_mushroom_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})

minetest.override_item("default:dirt_with_mushroom_grass", {
	tiles = {"default_mushroom_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_mushroom_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_rainforest_grass", {
	description = "Dirt with Rainforest Grass",
	tiles = {"default_rainforest_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})

minetest.override_item("default:dirt_with_rainforest_grass", {
	tiles = {"default_rainforest_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_rainforest_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {oddly_breakable_by_hand = 3, crumbly = 3, falling_node=1, sand=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 8,
				items = {"default:shell_peices"},
			},
			{
				items = {"default:sand"}
			}
		}
	}
})

qts.register_shaped_node ("default:gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {oddly_breakable_by_hand = 2, crumbly = 2, falling_node=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 8,
				items = {"default:flint"},
			},
			{
				items = {"default:gravel"}
			}
		}
	}
})

qts.register_shaped_node ("default:desert_sand", {
	description = "Desert Sand",
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node=1, sand=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:desert_sand"}
			}
		}
	}
})

--wood and the like

qts.register_shaped_node ("default:oak_wood_planks", {
	description = "Oak Wood Planks",
	tiles = {"default_oak_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
minetest.register_alias("default:wood_planks", "default:oak_wood_planks") --TODO: remove backwards compatability

qts.register_shaped_node ("default:oak_log", {
	description = "Oak Log",
	tiles = {"default_oak_top.png", "default_oak_top.png", "default_oak_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:rowan_wood_planks", {
	description = "Rowan Wood Planks",
	tiles = {"default_rowan_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:rowan_log", {
	description = "Rowan Log",
	tiles = {"default_rowan_top.png", "default_rowan_top.png", "default_rowan_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:apple_wood_planks", {
	description = "Apple Wood Planks",
	tiles = {"default_apple_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:apple_log", {
	description = "Apple Log",
	tiles = {"default_apple_top.png", "default_apple_top.png", "default_apple_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:aspen_wood_planks", {
	description = "Aspen Wood Planks",
	tiles = {"default_aspen_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:aspen_log", {
	description = "Aspen Log",
	tiles = {"default_aspen_top.png", "default_aspen_top.png", "default_aspen_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:lanternfruit_wood_planks", {
	description = "Lanternfruit Wood Planks",
	tiles = {{name = "default_lanternfruit_wood.png", align_style = "node"}},
	paramtype2 = "facedir",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:lanterfruit_log", {
	description = "Lanternfruit Log",
	tiles = {"default_lanternfruit_top.png", "default_lanternfruit_top.png", "default_lanternfruit_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:coffee_wood_planks", {
	description = "Coffee Wood Planks",
	tiles = {"default_coffee_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:coffee_log", {
	description = "Coffee Log",
	tiles = {"default_coffee_top.png", "default_coffee_top.png", "default_coffee_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:rosewood_wood_planks", {
	description = "Rosewood Planks",
	tiles = {"default_rosewood_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:rosewood_log", {
	description = "Rosewood Log",
	tiles = {"default_rosewood_top.png", "default_rosewood_top.png", "default_rosewood_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:mahogany_wood_planks", {
	description = "Mahogany Planks",
	tiles = {"default_mahogany_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:mahogany_log", {
	description = "Mahogany Log",
	tiles = {"default_mahogany_top.png", "default_mahogany_top.png", "default_mahogany_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:swamp_tree", {
	description = "Swamp Log",
	tiles = {
		"default_swamp_log_top.png",
		"default_swamp_log_bottom.png",
		"default_swamp_log_side.png",
		"default_swamp_log_side.png",
		"default_swamp_log_side.png",
		"default_swamp_log_side.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.375, 0, 0.5, -0.0625}, -- NodeBox10
			{0.0625, -0.5, 0, 0.4375, 0.9375, 0.375}, -- NodeBox11
		}
	}
})



qts.register_shaped_node ("default:blue_mushroom_trunk", {
	description = "Blue Mushroom Trunk",
	tiles = {"default_b_shroom_top.png", "default_b_shroom_top.png", "default_b_shroom_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:blue_mushroom_cap", {
	description = "Blue Mushroom Cap",
	tiles = {"default_b_shroom_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_trunk", {
	description = "Blue Mushroom Trunk",
	tiles = {"default_g_shroom_top.png", "default_g_shroom_top.png", "default_g_shroom_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_cap", {
	description = "Blue Mushroom Cap",
	tiles = {"default_g_shroom_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:g_shroom_spore", {
	description = "Golden Mushroom Spore",
	tiles = {
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	node_box = {
		type = "fixed",
		fixed = {
		}
	}
})

minetest.register_node("default:g_shroom_spore", {
	description = "Golden Mushroom Spore",
	tiles = {
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png",
		"default_g_shroom_spore.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
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


minetest.register_node("default:small_shroom", {
	description = "A Small Edible Mushroom",
	tiles = {
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	
	groups = {snappy = 3, flammable = 2, leaves = 1},node_box = {
		type = "fixed",
		fixed = {
		}
	}
})

minetest.register_node("default:small_shroom", {
	description = "A Small Edible Mushroom",
	tiles = {
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png",
		"default_small_shroom.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
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
	}
})
--leaves
--[[
leaves use param2 to hold if they were placed by the player
to allow player-placed leaves to not decay
--]]

minetest.register_node("default:swamp_leaves", {
	description = "Swamp Leaves",
	tiles = {
		"default_swamp_leaves.png",
		"default_swamp_leaves.png",
		"default_swamp_leaves.png",
		"default_swamp_leaves.png",
		"default_swamp_leaves.png",
		"default_swamp_leaves.png"
	},
	drawtype = "nodebox",
	waving = 1,
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
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


minetest.register_node("default:oak_leaves", {
	description = "Oak Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_oak_leaves.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
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
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:blackwood_leaves", {
	description = "Blackwood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_blackwood_leaves.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})


minetest.register_node("default:rosewood_leaves", {
	description = "Rosewood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rosewood_leaves.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})


--fruit

minetest.register_node("default:lantern_fruit", {
	description = "Lantern Fruit",
	tiles ={"default_lantern_fruit_top.png", "default_lantern_fruit_bottom.png", 
		"default_lantern_fruit_side.png"},
	drawtype = "nodebox",
	node_box = qtcore.nb_lantern_fruit(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 3, fruit = 1},
	sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

minetest.register_node("default:oak_sapling", {
	description = "Oak Sapling",
	tiles ={"default_oak_leaves.png", "default_oak_leaves.png", 
		"default_oak_leaves.png^[lowpart:37:default_oak_side.png"},
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

minetest.register_node("default:apple_sapling", {
	description = "Apple Sapling",
	tiles ={"default_apple_leaves.png", "default_apple_leaves.png", 
		"default_apple_leaves.png^[lowpart:37:default_apple_side.png"},
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

minetest.register_node("default:aspen_sapling", {
	description = "Aspen Sapling",
	tiles ={"default_aspen_leaves.png", "default_aspen_leaves.png", 
		"default_aspen_leaves.png^[lowpart:37:default_aspen_side.png"},
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

minetest.register_node("default:rowan_sapling", {
	description = "Rowan Sapling",
	tiles ={"default_rowan_leaves.png", "default_rowan_leaves.png", 
		"default_rowan_leaves.png^[lowpart:37:default_rowan_side.png"},
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

minetest.register_node("default:table", {
	description = "A Table",
	tiles = {
		"default_oak_wood.png",
		"default_oak_wood.png",
		"default_oak_wood.png",
		"default_oak_wood.png",
		"default_oak_wood.png",
		"default_oak_wood.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	node_box = {
		type = "fixed",
		fixed = {
			{0.0625, -0.25, 0.0625, 0.1875, 0.0625, 0.1875}, -- NodeBox1
			{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox2
			{-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox3
			{-0.1875, -0.25, -0.1875, -0.0625, 0.0625, -0.0625}, -- NodeBox4
			{0.0625, -0.25, -0.1875, 0.1875, 0.0625, -0.0625}, -- NodeBox5
			{-0.1875, -0.25, 0.0625, -0.0625, 0.0625, 0.1875}, -- NodeBox6
			{-0.125, 0.0625, -0.125, 0.125, 0.3125, 0.125}, -- NodeBox7
			{-0.1875, 0.3125, -0.4375, 0.1875, 0.4375, 0.4375}, -- NodeBox8
			{-0.375, 0.3125, -0.125, 0.4375, 0.4375, 0.125}, -- NodeBox9
		}
	}
})

minetest.register_node("default:swamp_plant", {
	description = "A Strange Plant that lives in the swamp",
	tiles = {"default_swamp_temp_plant.png"},
	drawtype = "plantlike",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=2, flammable=2},

})

