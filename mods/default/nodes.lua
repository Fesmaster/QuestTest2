

--[[
INDEX




]]



--stone
qts.register_shaped_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:cobble"
})

qts.register_shaped_node ("default:stone_cobble", {
	description = "Cobblestone",
	tiles = {"default_stone_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})
minetest.register_alias("default:cobble", "default:stone_cobble")

qts.register_shaped_node ("default:stone_brick", {
	description = "Stone Brick",
	tiles = {"default_stone_brick.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:stone_block", {
	description = "Stone Block",
	tiles = {"default_stone_block.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})
	
qts.register_shaped_node ("default:stone_cobble_mossy", {
	description = "Mossy Cobblestone",
	tiles = {"default_stone_cobble_mossy.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:stone_brick_mossy", {
	description = "Mossy Stone Brick",
	tiles = {"default_stone_brick_mossy.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

--desert_stone
qts.register_shaped_node ("default:red_stone", {
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:red_stone_cobble"
})

qts.register_shaped_node ("default:red_stone_cobble", {
	description = "Red Cobblestone",
	tiles = {"default_red_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:red_stone_brick", {
	description = "Red Stone Brick",
	tiles = {"default_red_stone_brick.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:red_stone_block", {
	description = "Red Stone Block",
	tiles = {"default_red_stone_block.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})


--sandstone
qts.register_shaped_node ("default:sandstone", {
	description = "sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:sandstone_cobble"
})

qts.register_shaped_node ("default:sandstone_cobble", {
	description = "Sandstone Cobble",
	tiles = {"default_sandstone_cobble.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:sandstone_brick", {
	description = "Sandstone Brick",
	tiles = {"default_sandstone_brick.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:sandstone_block", {
	description = "Sandstone Block",
	tiles = {"default_sandstone_block.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:desert_sandstone", {
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:desert_sandstone_cobble"
})

qts.register_shaped_node ("default:desert_sandstone_cobble", {
	description = "Desert Sandstone Cobble",
	tiles = {"default_desert_sandstone_cobble.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:desert_sandstone_brick", {
	description = "Desert Sandstone Brick",
	tiles = {"default_desert_sandstone_brick.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

qts.register_shaped_node ("default:desert_sandstone_block", {
	description = "Desert Sandstone Block",
	tiles = {"default_desert_sandstone_block.png"},
	groups = {cracky=3,stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
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
})

qts.register_shaped_node ("default:brick_grey", {
	description = "Grey Brick",
	tiles = {"default_brick_grey.png"},
	groups = {cracky=3, bricks=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

--soils and the like

qts.register_shaped_node ("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil=1},
	sounds = qtcore.node_sound_dirt(),
})

qts.register_shaped_node ("default:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = "default:dirt"
})

--fix the sides of grass on the full node
minetest.override_item("default:dirt_with_grass", {
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_swamp_grass", {
	description = "Swamp Dirt with Grass",
	tiles = {"default_swamp_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = "default:dirt"
})

minetest.override_item("default:dirt_with_swamp_grass", {
	tiles = {"default_swamp_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_swamp_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_prarie_grass", {
	description = "Prarie Dirt with Grass",
	tiles = {"default_prarie_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = "default:dirt"
})

minetest.override_item("default:dirt_with_prarie_grass", {
	tiles = {"default_prarie_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_prarie_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_mushroom_grass", {
	description = "Dirt with Decaying Matter",
	tiles = {"default_mushroom_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = "default:dirt"
})

minetest.override_item("default:dirt_with_mushroom_grass", {
	tiles = {"default_mushroom_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_mushroom_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:sand", {
	description = "sand",
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node=1, sand=1},
	sounds = qtcore.node_sound_sand(),
})

qts.register_shaped_node ("default:desert_sand", {
	description = "desert_sand",
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node=1, sand=1},
	sounds = qtcore.node_sound_sand(),
})

--wood and the like

qts.register_shaped_node ("default:wood_planks", {
	description = "Wood Planks",
	tiles = {"default_wood.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
})











--fences and the like
qts.register_fencelike_node("default:wood_fence", {
	description = "Wood Fance",
	type = "fence",
	texture = "default_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_fencelike_node("default:wood_rail", {
	description = "Wood Rail",
	type = "rail",
	texture = "default_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_fencelike_node("default:stone_brick_wall", {
	description = "Stone Brick Wall",
	type = "wall",
	texture = "default_stone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})