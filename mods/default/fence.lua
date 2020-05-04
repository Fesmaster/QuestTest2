
--fences and the like
qts.register_fencelike_node("default:oak_wood_fence", {
	description = "Oak Wood Fance",
	type = "fence",
	texture = "default_oak_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:oak_wood_rail", 
})

qts.register_fencelike_node("default:oak_wood_rail", {
	description = "Oak Wood Rail",
	type = "rail",
	texture = "default_oak_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:oak_wood_fence", 
	drop = "default:oak_wood_fence",
})

qts.register_fencelike_node("default:rowan_wood_fence", {
	description = "Rowan Wood Fance",
	type = "fence",
	texture = "default_rowan_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rowan_wood_rail", 
})

qts.register_fencelike_node("default:rowan_wood_rail", {
	description = "Rowan Wood Rail",
	type = "rail",
	texture = "default_rowan_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rowan_wood_fence", 
	drop = "default:rowan_wood_fence",
})

qts.register_fencelike_node("default:apple_wood_fence", {
	description = "Apple Wood Fance",
	type = "fence",
	texture = "default_apple_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:apple_wood_rail", 
})

qts.register_fencelike_node("default:apple_wood_rail", {
	description = "Apple Wood Rail",
	type = "rail",
	texture = "default_apple_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:apple_wood_fence", 
	drop = "default:apple_wood_fence",
})

qts.register_fencelike_node("default:aspen_wood_fence", {
	description = "Aspen Wood Fance",
	type = "fence",
	texture = "default_aspen_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:aspen_wood_rail", 
})

qts.register_fencelike_node("default:aspen_wood_rail", {
	description = "Aspen Wood Rail",
	type = "rail",
	texture = "default_aspen_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:aspen_wood_fence",
	drop = "default:aspen_wood_fence",	
})

qts.register_fencelike_node("default:lanternfruit_wood_fence", {
	description = "Lanternfruit Wood Fance",
	type = "fence",
	texture = "default_lanternfruit_wood_fence.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:lanternfruit_wood_rail", 
})

qts.register_fencelike_node("default:lanternfruit_wood_rail", {
	description = "Lanternfruit Wood Rail",
	type = "rail",
	texture = "default_lanternfruit_wood_rail.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:lanternfruit_wood_fence", 
	drop = "default:lanternfruit_wood_fence",
})

qts.register_fencelike_node("default:coffee_wood_fence", {
	description = "Coffee Wood Fance",
	type = "fence",
	texture = "default_coffee_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:coffee_wood_rail", 
})

qts.register_fencelike_node("default:coffee_wood_rail", {
	description = "Coffee Wood Rail",
	type = "rail",
	texture = "default_coffee_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:coffee_wood_fence", 
	drop = "default:coffee_wood_fence",
})

qts.register_fencelike_node("default:rosewood_wood_fence", {
	description = "Rosewood Wood Fance",
	type = "fence",
	texture = "default_rosewood_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rosewood_wood_rail", 
})

qts.register_fencelike_node("default:rosewood_wood_rail", {
	description = "Rosewood Wood Rail",
	type = "rail",
	texture = "default_rosewood_wood.png",
	groups = {choppy=3, oddly_breakable_by_hand=2, wood=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rosewood_wood_fence", 
	drop = "default:rosewood_wood_fence",
})

--stone walls
qts.register_fencelike_node("default:stone_wall", {
	description = "Stone Wall",
	type = "wall",
	texture = "default_stone.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:stone_cobble_wall", {
	description = "Cobblestone Wall",
	type = "wall",
	texture = "default_stone_cobble.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:stone_brick_wall", {
	description = "Stone Brick Wall",
	type = "wall",
	texture = "default_stone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:stone_cobble_mossy_wall", {
	description = "Mossy Cobblestone Wall",
	type = "wall",
	texture = "default_stone_cobble_mossy.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:stone_brick_mossy_wall", {
	description = "Mossy Stone Brick Wall",
	type = "wall",
	texture = "default_stone_brick_mossy.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})


qts.register_fencelike_node("default:red_stone_wall", {
	description = "Red Stone Wall",
	type = "wall",
	texture = "default_red_stone.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:red_stone_cobble_wall", {
	description = "Red Cobblestone Wall",
	type = "wall",
	texture = "default_red_cobble.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:red_stone_brick_wall", {
	description = "Red Stone Brick Wall",
	type = "wall",
	texture = "default_red_stone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})


qts.register_fencelike_node("default:sandstone_wall", {
	description = "Sandstone Wall",
	type = "wall",
	texture = "default_sandstone.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:sandstone_cobble_wall", {
	description = "Sandstone Cobble Wall",
	type = "wall",
	texture = "default_sandstone_cobble.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:sandstone_brick_wall", {
	description = "Sandstone Brick Wall",
	type = "wall",
	texture = "default_sandstone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})


qts.register_fencelike_node("default:desert_sandstone_wall", {
	description = "Desert Sandstone Wall",
	type = "wall",
	texture = "default_desert_sandstone.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:desert_sandstone_cobble_wall", {
	description = "Desert Sandstone Cobble Wall",
	type = "wall",
	texture = "default_desert_sandstone_cobble.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})

qts.register_fencelike_node("default:desert_sandstone_brick_wall", {
	description = "Desert Sandstone Brick Wall",
	type = "wall",
	texture = "default_desert_sandstone_brick.png",
	groups = {cracky=3, stone=1},
	sounds = qtcore.node_sound_stone(),
})