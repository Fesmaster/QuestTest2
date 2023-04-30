--[[
    Stone and stonelike nodes
]]

--Understone

qtcore.register_artistic_nodes("caverealm:slate",{
	description = "Slate",
	cobble_desc = "Slate Cobble",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, slate=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "slate",
})

qtcore.register_artistic_nodes("caverealm:slate_moss",{
	description = "Mossy Slate",
	cobble_desc = "Mossy Slate Cobble",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, slate=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "slate",
	overlay_image = "qt_moss_{TITLE}_overlay.png",
})

