

--[[
INDEX




]]



--stone
qts.register_shaped_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
	drop = "default:cobble"
})

qts.register_shaped_node ("default:stone_cobble", {
	description = "Cobblestone",
	tiles = {"default_stone_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})
minetest.register_alias("default:cobble", "default:stone_cobble")

qts.register_shaped_node ("default:stone_brick", {
	description = "Stone Brick",
	tiles = {"default_stone_brick.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:stone_block", {
	description = "Stone Block",
	tiles = {"default_stone_block.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})
	
qts.register_shaped_node ("default:stone_cobble_mossy", {
	description = "Mossy Cobblestone",
	tiles = {"default_stone_cobble_mossy.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:stone_brick_mossy", {
	description = "Mossy Stone Brick",
	tiles = {"default_stone_brick_mossy.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

--desert_stone
qts.register_shaped_node ("default:red_stone", {
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:red_stone_cobble", {
	description = "Red Cobblestone",
	tiles = {"default_red_cobble.png"},
	groups = {cracky=3, stone=1},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:red_stone_brick", {
	description = "Red Stone Brick",
	tiles = {"default_red_stone_brick.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:red_stone_block", {
	description = "Red Stone Block",
	tiles = {"default_red_stone_block.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})


--sandstone
qts.register_shaped_node ("default:sandstone", {
	description = "sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:sandstone_cobble", {
	description = "Sandstone Cobble",
	tiles = {"default_sandstone_cobble.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:sandstone_brick", {
	description = "Sandstone Brick",
	tiles = {"default_sandstone_brick.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:sandstone_block", {
	description = "Sandstone Block",
	tiles = {"default_sandstone_block.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:desert_sandstone", {
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:desert_sandstone_cobble", {
	description = "Desert Sandstone Cobble",
	tiles = {"default_desert_sandstone_cobble.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:desert_sandstone_brick", {
	description = "Desert Sandstone Brick",
	tiles = {"default_desert_sandstone_brick.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:desert_sandstone_block", {
	description = "Desert Sandstone Block",
	tiles = {"default_desert_sandstone_block.png"},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})



qts.register_shaped_node ("default:obsidian", {
	description = "obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:brick", {
	description = "Brick",
	tiles = {"default_brick.png"},
	groups = {cracky=3},
	sounds = default.node_sound_defaults(),
})
	
qts.register_shaped_node ("default:wood", {
	description = "Wood Planks",
	tiles = {"default_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {oddly_breakable_by_hand=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:sand", {
	description = "sand",
	tiles = {"default_sand.png"},
	groups = {oddly_breakable_by_hand=1, falling_node=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:desert_sand", {
	description = "desert_sand",
	tiles = {"default_desert_sand.png"},
	groups = {oddly_breakable_by_hand=1, falling_node=1},
	sounds = default.node_sound_defaults(),
})







qts.register_shaped_node ("default:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png"},
	groups = {oddly_breakable_by_hand=1},
	sounds = default.node_sound_defaults(),
})






--fences and the like
qts.register_fencelike_node("default:wood_fence", {
	description = "Wood Fance",
	type = "fence",
	texture = "default_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = default.node_sound_defaults(),
})

qts.register_fencelike_node("default:wood_rail", {
	description = "Wood Rail",
	type = "rail",
	texture = "default_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = default.node_sound_defaults(),
})

qts.register_fencelike_node("default:stone_brick_wall", {
	description = "Stone Brick Wall",
	type = "wall",
	texture = "default_stone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})