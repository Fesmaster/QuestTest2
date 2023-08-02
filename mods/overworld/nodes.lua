--[[
    misc. nodes from the overworld.
]]

minetest.register_node("overworld:shell_pieces", {
	description = "Shell Pieces",
	tiles = {
		"overworld_shell_pieces_top.png",
		"overworld_oak_wood.png",
		"overworld_shell_pieces_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "overworld_shell_pieces.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})

--foods that drop directly

--apple
qts.register_ingot("overworld:apple", {
	description = "Apple",
	inventory_image = "overworld_apple_fruit_item.png",
	tiles = {"overworld_apple_fruit_top.png", "overworld_apple_fruit.png", "overworld_apple_fruit.png"},
	groups = {oddly_breakable_by_hand=3, fruit = 1, generation_artificial=1},
	on_use = minetest.item_eat(2),
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	sounds = qtcore.node_sound_wood(),
	nodeboxes = {
		{-0.4375, -0.5, 0.1875, -0.1875, -0.25, 0.4375}, -- NodeBox1
		{-0.4375, -0.5, -0.125, -0.1875, -0.25, 0.125}, -- NodeBox2
		{-0.4375, -0.5, -0.4375, -0.1875, -0.25, -0.1875}, -- NodeBox3
		{-0.125, -0.5, 0.1875, 0.125, -0.25, 0.4375}, -- NodeBox4
		{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox5
		{-0.125, -0.5, -0.4375, 0.125, -0.25, -0.1875}, -- NodeBox6
		{0.1875, -0.5, 0.1875, 0.4375, -0.25, 0.4375}, -- NodeBox7
		{0.1875, -0.5, -0.125, 0.4375, -0.25, 0.125}, -- NodeBox8
		{0.1875, -0.5, -0.4375, 0.4375, -0.25, -0.1875}, -- NodeBox9
		{-0.3125, -0.25, 0.0625, -0.0624999, 2.23517e-08, 0.3125}, -- NodeBox10
		{-0.3125, -0.25, -0.3125, -0.0624999, -5.21541e-08, -0.0625001}, -- NodeBox11
		{0.0625, -0.25, 0.0625, 0.3125, 2.23517e-08, 0.3125}, -- NodeBox12
		{0.0625, -0.25, -0.3125, 0.3125, 2.23517e-08, -0.0625}, -- NodeBox13
		{-0.125, 0, -0.125, 0.125, 0.25, 0.125}, -- NodeBox14
	},
	levels = 14,
})


--coconut
qts.register_ingot("overworld:coconut", {
	description = "Coconut",
	inventory_image = "overworld_coconut.png",
	tiles = {"overworld_coconut_top.png", "overworld_coconut_side.png"},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3, fruit = 1, generation_artificial=1},
	on_use = minetest.item_eat(2),
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	sounds = qtcore.node_sound_wood(),
	nodeboxes = {
		{-0.4375, -0.5, 0.1875, -0.1875, -0.25, 0.4375}, -- NodeBox1
		{-0.4375, -0.5, -0.125, -0.1875, -0.25, 0.125}, -- NodeBox2
		{-0.4375, -0.5, -0.4375, -0.1875, -0.25, -0.1875}, -- NodeBox3
		{-0.125, -0.5, 0.1875, 0.125, -0.25, 0.4375}, -- NodeBox4
		{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox5
		{-0.125, -0.5, -0.4375, 0.125, -0.25, -0.1875}, -- NodeBox6
		{0.1875, -0.5, 0.1875, 0.4375, -0.25, 0.4375}, -- NodeBox7
		{0.1875, -0.5, -0.125, 0.4375, -0.25, 0.125}, -- NodeBox8
		{0.1875, -0.5, -0.4375, 0.4375, -0.25, -0.1875}, -- NodeBox9
		{-0.3125, -0.25, 0.0625, -0.0624999, 2.23517e-08, 0.3125}, -- NodeBox10
		{-0.3125, -0.25, -0.3125, -0.0624999, -5.21541e-08, -0.0625001}, -- NodeBox11
		{0.0625, -0.25, 0.0625, 0.3125, 2.23517e-08, 0.3125}, -- NodeBox12
		{0.0625, -0.25, -0.3125, 0.3125, 2.23517e-08, -0.0625}, -- NodeBox13
		{-0.125, 0, -0.125, 0.125, 0.25, 0.125}, -- NodeBox14
	},
	levels = 14,
})