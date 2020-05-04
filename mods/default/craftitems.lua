--ingot type object
qts.register_ingot("default:iron_bar", {
	description = "Iron Bar",
	inventory_image = "default_iron_ingot.png",
	tiles = {"default_iron_block.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = {
		{-0.5, -0.5, 0.1875, 0.125, -0.3125, 0.4375}, -- NodeBox45
		{-0.5, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox46
		{-0.5, -0.5, -0.4375, 0.125, -0.3125, -0.1875}, -- NodeBox49
		{-0.5, -0.3125, -0.3125, 0.125, -0.125, -0.0624999}, -- NodeBox51
		{-0.5, -0.3125, 0.0625, 0.125, -0.125, 0.3125}, -- NodeBox52
		{-0.5, -0.125, -0.125, 0.125, 0.0625, 0.125}, -- NodeBox53
		{0.1875, -0.5, -0.375, 0.4375, -0.3125, 0.25}, -- NodeBox54
		{0.125, -0.3125, -0.25, 0.3125, -0.0625, 0.375}, -- NodeBox55
	},
	levels = 8,
})

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