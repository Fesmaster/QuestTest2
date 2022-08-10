--[[
    Stone and stonelike nodes
]]

--Regular Stone
qts.register_shaped_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1, gray_stone=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:stone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:stone",{
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1, gray_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "gray_stone",
})
qts.register_shaped_node ("default:stone_cobble", {
	description = "Cobblestone",
	tiles = {"default_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, gray_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

--Mossy Stone
qts.register_shaped_node ("default:moss_stone", {
	description = "Mossy Stone",
	tiles = {"default_moss_stone.png"},
	groups = {cracky=3, stone=1, mossy_stone=1, generation_ground=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:moss_stone",{
	description = "Mossy Stone",
	tiles = {"default_moss_stone.png"},
	groups = {cracky=3, stone=1, mossy_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "mossy_stone",
})
qts.register_shaped_node ("default:moss_stone_cobble", {
	description = "Mossy Cobblestone",
	tiles = {"default_moss_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, mossy_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

--Understone
qts.register_shaped_node("default:understone", {
	description = "Understone",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, understone=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:understone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:understone",{
	description = "Understone",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, understone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "understone",
})
qts.register_shaped_node ("default:understone_cobble", {
	description = "Cobble Understone",
	tiles = {"default_understone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, understone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})


--Red Stone
qts.register_shaped_node ("default:red_stone", {
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1, red_stone=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:red_stone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:red_stone",{
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1, red_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "red_stone",
})
qts.register_shaped_node ("default:red_stone_cobble", {
	description = "Red Cobblestone",
	tiles = {"default_red_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, red_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})


--Sandstone
qts.register_shaped_node ("default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1, sand_stone=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:sandstone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:sandstone",{
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1, sand_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "sand_stone",
})
qts.register_shaped_node ("default:sandstone_cobble", {
	description = "Sandstone Cobble",
	tiles = {"default_sandstone.png^qt_cobble_overlay.png"},
	groups = {cracky=3,stone=1, sand_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})


--Desert Sandstone
qts.register_shaped_node ("default:desert_sandstone", {
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1, desert_stone=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:desert_sandstone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:desert_sandstone",{
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1, desert_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "desert_stone",
})
qts.register_shaped_node ("default:desert_sandstone_cobble", {
	description = "Desert Sandstone Cobble",
	tiles = {"default_desert_sandstone.png^qt_cobble_overlay.png"},
	groups = {cracky=3,stone=1, desert_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

-- Obsidian
qts.register_shaped_node ("default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=3, stone=1, obsidian=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:obsidian",{
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=3, stone=1, obsidian=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "obsidian",
})

-- Marble
qts.register_shaped_node ("default:marble", {
	description = "Marble",
	tiles = {"default_marble.png"},
	groups = {cracky=3, stone=1, marble=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:marble",{
	description = "Marble",
	tiles = {"default_marble.png"},
	groups = {cracky=3, stone=1, marble=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "marble",
})


--Bricks
qts.register_shaped_node ("default:brick", {
	description = "Brick",
	tiles = {"default_brick.png"},
	groups = {cracky=3, bricks=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:brick_gray", {
	description = "Gray Brick",
	tiles = {"default_brick_gray.png"},
	groups = {cracky=3, bricks=1, stone=1, gray_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

--others
qts.register_shaped_node("default:cement", {
	description = "Cement",
	tiles = {"default_cement.png"},
	groups = {cracky=3, explode_resistance=10},
	sounds = qtcore.node_sound_stone(),
})