--[[

]]


qts.register_ingot("alchemy:wax_palm", {
	description = "Palm Wax",
	inventory_image = "default_wax_palm_item.png",
	tiles = {
		"default_wax_palm_ingot.png"
	},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = {
			{ -6/16, -8/16, 1/16, -3/16, -6/16, 6/16, },
			{ -2/16, -8/16, 1/16, 1/16, -6/16, 6/16, },
			{ 2/16, -8/16, 1/16, 5/16, -6/16, 6/16, },
			{ -6/16, -8/16, -6/16, -3/16, -6/16, -1/16, },
			{ -2/16, -8/16, -6/16, 1/16, -6/16, -1/16, },
			{ 2/16, -8/16, -6/16, 5/16, -6/16, -1/16, },
			{ 0/16, -6/16, -2/16, 3/16, -4/16, 3/16, },
			{ -4/16, -6/16, -3/16, -1/16, -4/16, 2/16, },
			},
	levels = 8,
})

qts.register_ingot("alchemy:soap", {
	description = "Soap",
	inventory_image = "default_soap_item.png",
	tiles = {
		"default_soap_ingot.png"
	},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = {
			{ -6/16, -8/16, 1/16, -3/16, -6/16, 6/16, },
			{ -2/16, -8/16, 1/16, 1/16, -6/16, 6/16, },
			{ 2/16, -8/16, 1/16, 5/16, -6/16, 6/16, },
			{ -6/16, -8/16, -6/16, -3/16, -6/16, -1/16, },
			{ -2/16, -8/16, -6/16, 1/16, -6/16, -1/16, },
			{ 2/16, -8/16, -6/16, 5/16, -6/16, -1/16, },
			{ 0/16, -6/16, -2/16, 3/16, -4/16, 3/16, },
			{ -4/16, -6/16, -3/16, -1/16, -4/16, 2/16, },
			},
	levels = 8,
})

minetest.register_node("alchemy:potash", {
	description = "Potash",
	tiles = {
		"default_potash_top.png",
		"overworld_oak_wood.png",
		"default_potash_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_potash.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})

minetest.register_node("alchemy:lye", {
	description = "Lye",
	tiles = {
		"default_lye_top.png",
		"overworld_oak_wood.png",
		"default_lye_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_lye.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})