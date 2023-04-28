--[[
    Stone and stonelike nodes
]]

--Understone

qtcore.register_artistic_nodes("caverealm:understone",{
	description = "Understone",
	cobble_desc = "Understone Cobble",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, understone=1, generation_artificial=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "understone",
})
