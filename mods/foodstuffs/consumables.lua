--[[

]]


--bread
qts.register_ingot("foodstuffs:bread", {
	description = "Bread",
	inventory_image = "default_bread.png",
	tiles = {
			"default_bread_top.png",
			"default_bread_bottom.png",
			"default_bread_side.png"
		},
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = {
        { -5/16, -8/16, -6/16, 6/16, -5/16, -1/16, },
        { -5/16, -8/16, 2/16, 6/16, -5/16, 6/16, },
        { -5/16, -5/16, -2/16, 6/16, -2/16, 3/16, },
    },
	on_use = qts.item_eat(4),
	levels = 3,
})

minetest.register_craftitem("foodstuffs:mushroom_stew", {
	description = "Mushroom Stew",
	inventory_image = "default_mushroom_stew.png",
	on_use = minetest.item_eat(6),
})