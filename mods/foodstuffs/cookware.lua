--[[
    Cookware is the nodes used to craft food items
]]


minetest.register_node("foodstuffs:cookware_iron", {
	description = "Cast Iron Cookware",
	tiles = {"default_cookware_iron.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_cookware_iron_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, cookware=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, 2/16, -2/16, -7/16, 5/16, },
			{ -2/16, -7/16, 1/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -5/16, -6/16, 6/16, },
			{ -6/16, -7/16, 5/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -1/16, -6/16, 2/16, },
			{ -4/16, -7/16, -3/16, -3/16, -6/16, 1/16, },
			{ -5/16, -7/16, 0/16, -2/16, -6/16, 1/16, },
			{ 1/16, -8/16, -5/16, 5/16, -7/16, -1/16, },
			{ 0/16, -7/16, -1/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
			{ 5/16, -7/16, -6/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 1/16, -2/16, 0/16, },
			{ 2/16, -4/16, -1/16, 4/16, -3/16, 1/16, },
			{ 2/16, -4/16, -7/16, 4/16, -3/16, -5/16, },

		},
	},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_node("foodstuffs:cookware_copper", {
	description = "Copper Cookware",
	tiles = {"default_cookware_copper.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_cookware_copper_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, cookware=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, 2/16, -2/16, -7/16, 5/16, },
			{ -2/16, -7/16, 1/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -5/16, -6/16, 6/16, },
			{ -6/16, -7/16, 5/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -1/16, -6/16, 2/16, },
			{ -4/16, -7/16, -3/16, -3/16, -6/16, 1/16, },
			{ -5/16, -7/16, 0/16, -2/16, -6/16, 1/16, },
			{ 1/16, -8/16, -5/16, 5/16, -7/16, -1/16, },
			{ 0/16, -7/16, -1/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
			{ 5/16, -7/16, -6/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 1/16, -2/16, 0/16, },
			{ 2/16, -4/16, -1/16, 4/16, -3/16, 1/16, },
			{ 2/16, -4/16, -7/16, 4/16, -3/16, -5/16, },

		},
	},
	sounds = qtcore.node_sound_metal(),
})