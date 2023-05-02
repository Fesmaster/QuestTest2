--[[
    Ingredients that are not directly consumable
]]


minetest.register_node("foodstuffs:coffee_grounds", {
	description = "Coffee Grounds",
	tiles = {
		"default_coffee_grounds_top.png",
		"overworld_oak_wood.png",
		"default_coffee_grounds_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_coffee_grounds_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})

minetest.register_node("foodstuffs:sugar", {
	description = "Sugar",
	tiles = {
		"default_sugar_top.png",
		"overworld_oak_wood.png",
		"default_sugar_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_sugar_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})



minetest.register_craftitem("foodstuffs:coffee_beans", {
	description = "Coffee Beans",
	inventory_image = "default_coffee_beans.png",
})