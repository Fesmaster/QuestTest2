--[[
    Craftitems
]]

qts.register_ingot("craftable:stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	tiles = {"overworld_oak_wood.png"},
	groups = {stick = 1, oddly_breakable_by_hand = 3},
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

minetest.register_craftitem("craftable:charcoal", {
	description = "Charcoal Lump",
	inventory_image = "default_charcoal.png",
	groups = {coal = 1,},
})

minetest.register_craftitem("craftable:refined_clay_lump", {
	description = "Refined Clay",
	inventory_image = "default_refined_clay_lump.png",
})

minetest.register_craftitem("craftable:tinder", {
	description = "Tinder",
	inventory_image = "default_tinder.png",
})

minetest.register_craftitem("craftable:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
})

--minetest.register_alias("craftable:brick_single", "craftable:brick_item")
minetest.register_craftitem("craftable:brick_item", {
	description = "Brick",
	inventory_image = "default_brick_item.png",
})

--TODO: Move to Farming mod
minetest.register_craftitem("craftable:poltice_milfoil", {
	description = "Milfoil Poltice",
	inventory_image = "default_poltice_milfoil.png",
	on_use = minetest.item_eat(2),
})