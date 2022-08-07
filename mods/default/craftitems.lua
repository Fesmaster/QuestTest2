--ingot type object


qts.register_ingot("default:stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	tiles = {"default_oak_wood.png"},
	groups = {cracky=3, stick = 1},
	sounds = qtcore.node_sound_wood(),
	nodeboxes = {
		{-0.5, -0.5, -0.4375, 0.5, -0.375, -0.3125}, -- NodeBox1
		{-0.5, -0.5, -0.25, 0.5, -0.375, -0.125}, -- NodeBox2
		{-0.5, -0.5, -0.0625, 0.5, -0.375, 0.0625001}, -- NodeBox3
		{-0.5, -0.5, 0.125, 0.5, -0.375, 0.25}, -- NodeBox4
		{-0.5, -0.5, 0.3125, 0.5, -0.375, 0.4375}, -- NodeBox5
		{-0.5, -0.375, -0.375, 0.5, -0.25, -0.25}, -- NodeBox6
		{-0.5, -0.375, -0.125, 0.5, -0.25, -1.11759e-008}, -- NodeBox7
		{-0.5, -0.375, 0.1875, 0.5, -0.25, 0.3125}, -- NodeBox8
	},
	levels = 8,
})

minetest.register_craftitem("default:charcoal", {
	description = "Charcoal Lump",
	inventory_image = "default_charcoal.png",
	groups = {coal = 1,},
})

minetest.register_craftitem("default:clay_lump", {
	description = "Clay",
	inventory_image = "default_clay_lump.png",
})

minetest.register_craftitem("default:flint", {
	description = "Flint",
	inventory_image = "default_flint.png",
})

minetest.register_craftitem("default:tinder", {
	description = "Tinder",
	inventory_image = "default_tinder.png",
})

minetest.register_craftitem("default:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
})


minetest.register_craftitem("default:shell_pieces", {
	description = "Shell Pieces",
	inventory_image = "default_shell_peices.png",
})

minetest.register_alias("default:calcium_oxide", "default:lime")
minetest.register_craftitem("default:lime", {
	description = "Lime",
	inventory_image = "default_lime.png",
})
minetest.register_alias("default:brick_single", "default:brick_item")
minetest.register_craftitem("default:brick_item", {
	description = "Brick",
	inventory_image = "default_brick_item.png",
})

minetest.register_craftitem("default:coconut", {
	description = "Coconut",
	inventory_image = "default_coconut.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craftitem("default:mushroom_stew", {
	description = "Mushroom Stew",
	inventory_image = "default_mushroom_stew.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craftitem("default:flask_glass", {
	description = "Glass Flask",
	inventory_image = "default_flask_glass.png",
})

minetest.register_craftitem("default:flask_glass_water", {
	description = "Flask of Water",
	inventory_image = "default_flask_glass_water.png",
})

minetest.register_craftitem("default:poltice_milfoil", {
	description = "Milfoil Poltice",
	inventory_image = "default_poltice_milfoil.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craftitem("default:mycelium", {
	description = "Mycelium",
	inventory_image = "default_mycelium.png",
})

minetest.register_craftitem("default:coffee_beans", {
	description = "Coffee Beans",
	inventory_image = "default_coffee_beans.png",
})