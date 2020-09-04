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

minetest.register_craftitem("default:clay_lump", {
	description = ("Clay"),
	inventory_image = "default_clay_lump.png",
})

minetest.register_craftitem("default:coal", {
	description = "Coal Lump",
	inventory_image = "default_coal.png",
	groups = {coal = 1,},
})

minetest.register_craftitem("default:flint", {
	description = ("Flint"),
	inventory_image = "default_flint.png",
})

minetest.register_craftitem("default:tinder", {
	description = ("Tinder"),
	inventory_image = "default_tinder.png",
})

minetest.register_craftitem("default:shell_peices", {
	description = ("Shell Peices found in sand"),
	inventory_image = "default_shell_peices.png",
})

minetest.register_craftitem("default:calcium_oxide", {
	description = ("Calcium Oxide Dust made from backing shells"),
	inventory_image = "default_calcium_oxide.png",
})

minetest.register_craftitem("default:brick_single", {
	description = ("A Brick"),
	inventory_image = "default_brick_single.png",
})

minetest.register_craftitem("default:sword_template", {
	description = ("A Wooden Sword Template"),
	inventory_image = "default_sword_template.png",
})

minetest.register_craftitem("default:axe_template", {
	description = ("A Wooden Axe Template"),
	inventory_image = "default_axe_tem,plate.png",
})

minetest.register_craftitem("default:pickaxe_template", {
	description = ("A Wooden Pickaxe Template"),
	inventory_image = "default_pickaxe_template.png",
})

minetest.register_craftitem("default:shovel_template", {
	description = ("A Wooden Shovel Template"),
	inventory_image = "default_shovel_template.png",
})