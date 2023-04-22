--[[
    Stone and stonelike nodes
]]

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
