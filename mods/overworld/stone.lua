--[[
    Overworld stone types.

    The reason stones are not stuck in a loop is that the names are annoyingly custom (IE, Sandstone being one word)
]]


qtcore.register_artistic_nodes("overworld:stone",{
	description = "Stone",
	cobble_desc = "Cobblestone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1, gray_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "gray_stone",
})

qtcore.register_artistic_nodes("overworld:moss_stone",{
	description = "Mossy Stone",
    cobble_desc = "Mossy Cobblestone",
	tiles = {"default_moss_stone.png"},
	groups = {cracky=3, stone=1, mossy_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "mossy_stone",
})

qtcore.register_artistic_nodes("overworld:red_stone",{
	description = "Red Stone",
    cobble_desc = "Red Cobblestone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1, red_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "red_stone",
})

qtcore.register_artistic_nodes("overworld:sandstone",{
	description = "Sandstone",
    cobble_desc = "Sandstone Cobble",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1, sand_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "sand_stone",
})

qtcore.register_artistic_nodes("overworld:desert_sandstone",{
	description = "Desert Sandstone",
    cobble_desc = "Desert Sandstone Cobble",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1, desert_stone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "desert_stone",
})

-- Obsidian
qtcore.register_artistic_nodes("overworld:obsidian",{
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=3, stone=1, obsidian=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "obsidian",
    no_cobble=true,
})

-- Marble
qtcore.register_artistic_nodes("overworld:marble",{
	description = "Marble",
	tiles = {"default_marble.png"},
	groups = {cracky=3, stone=1, marble=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "marble",
    no_cobble=true,
})


--Bricks
qts.register_shaped_node ("overworld:brick", {
	description = "Brick",
	tiles = {"default_brick.png"},
	groups = {cracky=3, bricks=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("overworld:brick_gray", {
	description = "Gray Brick",
	tiles = {"default_brick_gray.png"},
	groups = {cracky=3, bricks=1, stone=1, gray_stone=1, generation_artificial=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("overworld:brick_wall", {
	description = "Brick Wall",
	type = "wall",
	tiles = {"default_brick.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_fencelike_node("overworld:brick_gray_wall", {
	description = "Gray Brick Wall",
	type = "wall",
	tiles = {"default_brick_gray.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

--others
qts.register_shaped_node("overworld:cement", {
	description = "Cement",
	tiles = {"default_cement.png"},
	groups = {cracky=3, explode_resistance=10},
	sounds = qtcore.node_sound_stone(),
})


--[[

qts.register_shaped_node ("default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=3, stone=1, obsidian=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:marble", {
	description = "Marble",
	tiles = {"default_marble.png"},
	groups = {cracky=3, stone=1, marble=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

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
]]


