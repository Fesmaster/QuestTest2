--food and dish items go here

--BEGIN NODES

--soups

local ingredient={"apple", "goard", "grain", "carrot", "onion", "potatoe"}
local soupname={"Apple", "Goard", "Grain", "Carrot", "Onion", "Potatoe"}

for i, n in ipairs(ingredient) do
	for j, k in ipairs(ingredient) do
		for h, l in ipairs(ingredient)do
			qts.register_chest("default:bowl_clay_soup_"..n.."_"..k.."_"..l, {
				description = soupname[i].." and "..soupname[j].." and "..soupname[h],
				tiles = {
					"default_soup_"..ingredient[i].."_top.png^default_bowl_clay_soup_top_overlay.png^default_soup_overlay_"..ingredient[j]..".png^default_soup_overlay_"..ingredient[h]..".png",
					"default_dishes_clay.png"
					
				},
				groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
				drawtype = "nodebox",
				inventory_image = "default_soup_"..ingredient[i].."_item.png^default_bowl_clay_soup_item_overlay.png",
				paramtype = "light",
				paramtype2 = "facedir",
				node_box = {
					type = "fixed",
					fixed = {
							{ -3/16, -8/16, -3/16, 3/16, -7/16, 3/16, },
							{ -4/16, -7/16, -4/16, 4/16, -6/16, 4/16, },
							{ 4/16, -6/16, -5/16, 5/16, -5/16, 5/16, },
							{ -5/16, -6/16, -5/16, 5/16, -5/16, -4/16, },
							{ -5/16, -6/16, 4/16, 5/16, -5/16, 5/16, },
							{ -5/16, -6/16, -5/16, -4/16, -5/16, 5/16, },
						},
					},
				sounds = qtcore.node_sound_stone(),
			})
			
			qts.register_craft({
				ingredients = {"default:herb_"..n, "default:herb_"..k, "default:herb_"..l, "default:vessels_water"},
				results = {"default:bowl_clay_soup_"..n.."_"..k.."_"..l},
				near = {"group:table", "group:furnace", "group:cookware"},
			})
		end
	end
end

--end soups

-- consumables
qts.register_ingot("default:apple", {
	description = "Apple",
	inventory_image = "default_apple_fruit_item.png",
	tiles = {"default_apple_fruit_top.png", "default_apple_fruit.png", "default_apple_fruit.png"},
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

--breads
local bread_nodeboxes = {
	{ -5/16, -8/16, -6/16, 6/16, -5/16, -1/16, },
	{ -5/16, -8/16, 2/16, 6/16, -5/16, 6/16, },
	{ -5/16, -5/16, -2/16, 6/16, -2/16, 3/16, },
}

qts.register_ingot("default:bread", {
	description = "Bread",
	inventory_image = "default_bread.png",
	tiles = {
			"default_bread_top.png",
			"default_bread_bottom.png",
			"default_bread_side.png"
		},
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = bread_nodeboxes,
	on_use = qts.item_eat(4),
	levels = 3,
})

qts.register_ingot("default:coconut", {
	description = "Coconut",
	inventory_image = "default_coconut.png",
	tiles = {"default_coconut_top.png", "default_coconut_side.png"},
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

minetest.register_node("default:cup_clay_coffee_turkish", {
	description = "Cup of Turkish Coffee",
	tiles = {
			"default_cup_clay_coffee_top.png",
			"default_dishes_clay.png",
			"default_dishes_clay.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_cup_clay_coffee_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -3/16, 2/16, },
			{ -2/16, -3/16, -2/16, 2/16, -2/16, -1/16, },
			{ -2/16, -3/16, 1/16, 2/16, -2/16, 2/16, },
			{ 1/16, -3/16, -2/16, 2/16, -2/16, 2/16, },
			{ -2/16, -3/16, -2/16, -1/16, -2/16, 2/16, },
		},
	},
	on_use = qts.item_eat(4),
	sounds = qtcore.node_sound_stone(),
})
--consumables

--Cooking items and stations
minetest.register_node("default:dishes_clay", {
	description = "Clay Dishes",
	tiles = {
			"default_dishes_clay.png",
		},
	drawtype = "nodebox",
	inventory_image = "default_dishes_clay_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dishes=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 1/16, -5/16, -6/16, 5/16, },
		{ -1/16, -7/16, 1/16, 0/16, -6/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 1/16, },
		{ -6/16, -7/16, 5/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -7/16, -2/16, },
		{ 2/16, -7/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -7/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -7/16, -5/16, 3/16, -2/16, -3/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:dishes_greenware", {
	description = "Greenware Dishes",
	tiles = {
			"default_dishes_greenware.png",
		},
	drawtype = "nodebox",
	inventory_image = "default_dishes_greenware_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 1/16, -5/16, -6/16, 5/16, },
		{ -1/16, -7/16, 1/16, 0/16, -6/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 1/16, },
		{ -6/16, -7/16, 5/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -7/16, -2/16, },
		{ 2/16, -7/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -7/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -7/16, -5/16, 3/16, -2/16, -3/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:vessels_water", {
	description = "Water Vessel",
	tiles = {
			"default_vessel_water_top.png",
			"default_dishes_clay.png",
			"default_dishes_clay.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_vessel_water_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, vessels_water=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -3/16, -2/16, },
		{ 2/16, -3/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -3/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -3/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -3/16, -5/16, 3/16, -2/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:vessels_oil_coconut", {
	description = "Coconut Oil Vessel",
	tiles = {
			"default_vessel_oil_coconut_top.png",
			"default_dishes_clay.png",
			"default_dishes_clay.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_vessel_oil_coconut_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -3/16, -2/16, },
		{ 2/16, -3/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -3/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -3/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -3/16, -5/16, 3/16, -2/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:flour_bowl", {
	description = "Flour Bowl",
	tiles = {
			"default_flour_bowl_top.png",
			"default_dishes_clay.png",
			"default_flour_bowl_side.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_flour_bowl_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -3/16, -7/16, -4/16, 4/16, -5/16, 3/16, },
		{ -4/16, -6/16, -4/16, -3/16, -5/16, 3/16, },
		{ 4/16, -6/16, -4/16, 5/16, -5/16, 3/16, },
		{ -4/16, -6/16, 3/16, 5/16, -5/16, 4/16, },
		{ -4/16, -6/16, -5/16, 5/16, -5/16, -4/16, },
		{ -2/16, -8/16, -3/16, 3/16, -4/16, 2/16, },
		{ -1/16, -4/16, -2/16, 2/16, -3/16, 1/16, },
		},
	},
})

minetest.register_node("default:cup_clay", {
	description = "Clay Cup",
	tiles = {
			"default_dishes_clay.png",
		},
	drawtype = "nodebox",
	inventory_image = "default_cup_clay_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -2/16, -8/16, 1/16, 2/16, -3/16, 2/16, },
			{ -2/16, -8/16, -2/16, 2/16, -3/16, -1/16, },
			{ -2/16, -8/16, -2/16, -1/16, -3/16, 2/16, },
			{ 1/16, -8/16, -2/16, 2/16, -3/16, 2/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:bowl_clay", {
	description = "Clay Bowl",
	tiles = {
			"default_dishes_clay.png",
		},
	drawtype = "nodebox",
	inventory_image = "default_bowl_clay_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -3/16, -7/16, -3/16, -2/16, -6/16, 3/16, },
			{ 2/16, -7/16, -3/16, 3/16, -6/16, 3/16, },
			{ -3/16, -7/16, -3/16, 3/16, -6/16, -2/16, },
			{ -3/16, -7/16, 2/16, 3/16, -6/16, 3/16, },
			{ -4/16, -6/16, 3/16, 4/16, -5/16, 4/16, },
			{ -4/16, -6/16, -4/16, 4/16, -5/16, -3/16, },
			{ 3/16, -6/16, -4/16, 4/16, -5/16, 4/16, },
			{ -4/16, -6/16, -4/16, -3/16, -5/16, 4/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:cookware_iron", {
	description = "Cast Iron Cookware",
	tiles = {
			"default_cookware_iron.png",
		},
	drawtype = "nodebox",
	inventory_image = "default_cookware_iron_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, cookware=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, 2/16, -2/16, -7/16, 5/16, },
			{ -2/16, -7/16, 1/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -5/16, -6/16, 6/16, },
			{ -6/16, -7/16, 5/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -1/16, -6/16, 2/16, },
			{ -4/16, -7/16, -3/16, -3/16, -6/16, 1/16, },
			{ -5/16, -7/16, 0/16, -2/16, -6/16, 1/16, },
			{ 1/16, -8/16, -5/16, 5/16, -7/16, -1/16, },
			{ 0/16, -7/16, -1/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
			{ 5/16, -7/16, -6/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 1/16, -2/16, 0/16, },
			{ 2/16, -4/16, -1/16, 4/16, -3/16, 1/16, },
			{ 2/16, -4/16, -7/16, 4/16, -3/16, -5/16, },

		},
	},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_node("default:cookware_copper", {
	description = "Copper Cookware",
	tiles = {
			"default_cookware_copper.png",
		},
	drawtype = "nodebox",
	inventory_image = "default_cookware_copper_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, cookware=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, 2/16, -2/16, -7/16, 5/16, },
			{ -2/16, -7/16, 1/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -5/16, -6/16, 6/16, },
			{ -6/16, -7/16, 5/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -1/16, -6/16, 2/16, },
			{ -4/16, -7/16, -3/16, -3/16, -6/16, 1/16, },
			{ -5/16, -7/16, 0/16, -2/16, -6/16, 1/16, },
			{ 1/16, -8/16, -5/16, 5/16, -7/16, -1/16, },
			{ 0/16, -7/16, -1/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
			{ 5/16, -7/16, -6/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 1/16, -2/16, 0/16, },
			{ 2/16, -4/16, -1/16, 4/16, -3/16, 1/16, },
			{ 2/16, -4/16, -7/16, 4/16, -3/16, -5/16, },

		},
	},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_node("default:coffee_grounds", {
	description = "Coffee Grounds",
	tiles = {
			"default_coffee_grounds_top.png",
			"default_oak_wood.png",
			"default_coffee_grounds_side.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_coffee_grounds_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})
--END NODES

--BEGIN craftitems
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

minetest.register_craftitem("default:coffee_beans", {
	description = "Coffee Beans",
	inventory_image = "default_coffee_beans.png",
})