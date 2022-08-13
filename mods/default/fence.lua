
--fences and the like
qts.register_fencelike_node("default:oak_wood_fence", {
	description = "Oak Wood Fence",
	type = "fence",
	tiles = {"default_oak_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:oak_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:oak_wood_rail", {
	description = "Oak Wood Rail",
	type = "rail",
	tiles = {"default_oak_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:oak_wood_fence", 
	drop = "default:oak_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rowan_wood_fence", {
	description = "Rowan Wood Fence",
	type = "fence",
	tiles = {"default_rowan_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rowan_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rowan_wood_rail", {
	description = "Rowan Wood Rail",
	type = "rail",
	tiles = {"default_rowan_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rowan_wood_fence", 
	drop = "default:rowan_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:apple_wood_fence", {
	description = "Apple Wood Fence",
	type = "fence",
	tiles = {"default_apple_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:apple_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:apple_wood_rail", {
	description = "Apple Wood Rail",
	type = "rail",
	tiles = {"default_apple_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:apple_wood_fence", 
	drop = "default:apple_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:aspen_wood_fence", {
	description = "Aspen Wood Fence",
	type = "fence",
	tiles = {"default_aspen_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:aspen_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:aspen_wood_rail", {
	description = "Aspen Wood Rail",
	type = "rail",
	tiles = {"default_aspen_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:aspen_wood_fence",
	drop = "default:aspen_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:lanternfruit_wood_fence", {
	description = "Lanternfruit Wood Fence",
	type = "fence",
	tiles = {"default_lanternfruit_wood_fence.png"}, 
	no_tile_transform=true,
		--this flags the fence texture for no transform.
		--this transform normally rotates a section so the fence column has correctly-alligned
		--grain. This texture does that manually.
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:lanternfruit_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:lanternfruit_wood_rail", {
	description = "Lanternfruit Wood Rail",
	type = "rail",
	tiles = {"default_lanternfruit_wood_rail.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:lanternfruit_wood_fence", 
	drop = "default:lanternfruit_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:coffee_wood_fence", {
	description = "Coffee Wood Fence",
	type = "fence",
	tiles = {"default_coffee_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:coffee_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:coffee_wood_rail", {
	description = "Coffee Wood Rail",
	type = "rail",
	tiles = {"default_coffee_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:coffee_wood_fence", 
	drop = "default:coffee_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rosewood_wood_fence", {
	description = "Rosewood Wood Fence",
	type = "fence",
	tiles = {"default_rosewood_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rosewood_wood_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rosewood_wood_rail", {
	description = "Rosewood Wood Rail",
	type = "rail",
	tiles = {"default_rosewood_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rosewood_wood_fence", 
	drop = "default:rosewood_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:mahogany_wood_fence", {
	description = "Mahogany Wood Fence",
	type = "fence",
	tiles = {"default_mahogany_wood_fence.png"},
	no_tile_transform=true,
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:mahogany_wood_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:mahogany_wood_rail", {
	description = "Mahogany Wood Rail",
	type = "rail",
	tiles = {"default_mahogany_wood_rail.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:mahogany_wood_fence", 
	drop = "default:mahogany_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:pine_wood_fence", {
	description = "Pine Wood Fence",
	type = "fence",
	tiles = {"default_pine_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:pine_wood_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:pine_wood_rail", {
	description = "Pine Wood Rail",
	type = "rail",
	tiles = {"default_pine_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:pine_wood_fence", 
	drop = "default:pine_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:bamboo_fence", {
	description = "Bamboo Fence",
	type = "fence",
	tiles = {"default_bamboo_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:bamboo_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:bamboo_rail", {
	description = "Bamboo Rail",
	type = "rail",
	tiles = {"default_bamboo_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:bamboo_fence", 
	drop = "default:bamboo_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:blue_mushroom_fence", {
	description = "Blue Mushroom Fence",
	type = "fence",
	tiles = {"default_mushroom_blue_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:blue_mushroom_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:blue_mushroom_rail", {
	description = "Blue Mushroom Rail",
	type = "rail",
	tiles = {"default_mushroom_blue_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:blue_mushroom_fence", 
	drop = "default:blue_mushroom_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:brown_mushroom_fence", {
	description = "Brown Mushroom Fence",
	type = "fence",
	tiles = {"default_mushroom_brown_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:brown_mushroom_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:brown_mushroom_rail", {
	description = "Brown Mushroom Rail",
	type = "rail",
	tiles = {"default_mushroom_brown_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:brown_mushroom_fence", 
	drop = "default:brown_mushroom_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:gold_mushroom_fence", {
	description = "Gold Mushroom Fence",
	type = "fence",
	tiles = {"default_mushroom_gold_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:gold_mushroom_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:gold_mushroom_rail", {
	description = "Gold Mushroom Rail",
	type = "rail",
	tiles = {"default_mushroom_gold_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:gold_mushroom_fence", 
	drop = "default:gold_mushroom_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--stone walls


qts.register_fencelike_node("default:stone_cobble_wall", {
	description = "Cobblestone Wall",
	type = "wall",
	tiles = {"default_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, fence=1, grey_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:moss_stone_cobble_wall", {
	description = "Mossy Cobblestone Wall",
	type = "wall",
	tiles = {"default_moss_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, fence=1, grey_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:understone_cobble_wall", {
	description = "Cobble Understone Wall",
	type = "wall",
	tiles = {"default_understone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, fence=1, understone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:red_stone_cobble_wall", {
	description = "Red Cobblestone Wall",
	type = "wall",
	tiles = {"default_red_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, fence=1, red_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:sandstone_cobble_wall", {
	description = "Sandstone Cobble Wall",
	type = "wall",
	tiles = {"default_sandstone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, fence=1, sand_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:desert_sandstone_cobble_wall", {
	description = "Desert Sandstone Cobble Wall",
	type = "wall",
	tiles = {"default_desert_sandstone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, fence=1, desert_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:brick_wall", {
	description = "Brick Wall",
	type = "wall",
	tiles = {"default_brick.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("default:brick_gray_wall", {
	description = "Gray Brick Wall",
	type = "wall",
	tiles = {"default_brick_gray.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})