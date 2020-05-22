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