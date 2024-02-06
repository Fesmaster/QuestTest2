--[[

]]


qts.register_ingot("alchemy:wax_palm", {
	description = "Palm Wax",
	inventory_image = "alchemy_wax_palm_item.png",
	tiles = {
		"alchemy_wax_palm_ingot.png"
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
	inventory_image = "alchemy_soap_item.png",
	tiles = {
		"alchemy_soap_ingot.png"
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
		"alchemy_potash_top.png",
		"overworld_oak_wood.png",
		"alchemy_potash_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "alchemy_potash.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
	selection_box = qtcore.nb_dustpile_selection(),
})

minetest.register_node("alchemy:lye", {
	description = "Lye",
	tiles = {
		"alchemy_lye_top.png",
		"overworld_oak_wood.png",
		"alchemy_lye_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "alchemy_lye.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
	selection_box = qtcore.nb_dustpile_selection(),
})

minetest.register_craftitem("alchemy:poltice_milfoil", {
	description = "Milfoil Poltice",
	inventory_image = "alchemy_poltice_milfoil.png",
	on_use = minetest.item_eat(2),
})