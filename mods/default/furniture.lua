--all furniture nodes and crafting here

--BEGIN Nodes


--BEGIN benches
minetest.register_node("default:bench_pine", {
	description = "Pine Bench",
	tiles = {"default_pine_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -2/16, -16/16, 4/16, -1/16, 16/16, },
			{ 3/16, -8/16, 15/16, 4/16, 8/16, 16/16, },
			{ -3/16, -8/16, 15/16, -2/16, -2/16, 16/16, },
			{ -3/16, -8/16, -16/16, -2/16, -2/16, -15/16, },
			{ 3/16, -8/16, -16/16, 4/16, 8/16, -15/16, },
			{ 3/16, 5/16, -15/16, 4/16, 7/16, 15/16, },
			{ 3/16, 1/16, -15/16, 4/16, 3/16, 15/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

--END benches
--BEGIN chests
local woodpng={"default_oak_wood.png", "default_apple_wood.png", "default_aspen_wood.png", "default_coffee_wood.png", "default_mahogany_wood.png", "default_rosewood_wood.png", "default_pine_wood.png", "default_lanternfruit_wood.png", "default_swamp_wood.png",}
local woodtypes={"oak", "apple", "aspen", "coffee", "mahogany", "rosewood", "pine", "lanternfruit", "swamp",}
local woodnames={"Oak", "Apple", "Aspen", "Coffee", "Mahogany", "Rosewood", "Pine", "Lanternfruit", "Swamp Wood",}
local metaltypes={"bronze", "copper", "iron", "steel"}
local metalnames={"Bronze", "Copper", "Iron", "Steel"}

for i, n in ipairs(woodtypes) do
	for j, k in ipairs(metaltypes) do
		qts.register_chest("default:chest_"..n.."_"..k, {
			description = woodnames[i].." and "..metalnames[j].." Chest",
			tiles = {
				woodpng[i].."^default_chest_"..k.."_top_overlay.png",
				woodpng[i].."^default_chest_"..k.."_top_overlay.png",
				woodpng[i].."^default_chest_"..k.."_side_overlay.png",
				woodpng[i].."^default_chest_"..k.."_side_overlay.png",
				woodpng[i].."^default_chest_"..k.."_back_overlay.png",
				woodpng[i].."^default_chest_"..k.."_front_overlay.png"
				
			},
			groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{ -8/16, -8/16, -5/16, 8/16, 0/16, 5/16, },
					{ -8/16, -8/16, -4/16, 8/16, 1/16, 4/16, },
					{ -8/16, -8/16, -3/16, 8/16, 2/16, 3/16, },
					{ -6/16, 1/16, -4/16, -4/16, 2/16, 4/16, },
					{ 4/16, 1/16, -4/16, 6/16, 2/16, 4/16, },
					{ 4/16, 0/16, -5/16, 6/16, 1/16, 5/16, },
					{ -6/16, 0/16, -5/16, -4/16, 1/16, 5/16, },
					{ 4/16, 2/16, -3/16, 6/16, 3/16, 3/16, },
					{ -6/16, 2/16, -3/16, -4/16, 3/16, 3/16, },
					{ -6/16, -8/16, -6/16, -4/16, 0/16, 6/16, },
					{ 4/16, -8/16, -6/16, 6/16, 0/16, 6/16, },
					{ -1/16, -4/16, -6/16, 1/16, -1/16, -5/16, },
					},
				},
			is_ground_content = false,
			sounds = qtcore.node_sound_wood(),
			
			invsize = 8*4,
			get_chest_formspec = qtcore.get_default_chest_formspec,
		})
		
		
		if k == "copper" then
			qts.register_craft({
				ingredients = {"default:"..n.."_wood_planks", "default:"..k.."_bar 2"},
				results = {"default:chest_"..n.."_"..k},
				near = {"group:workbench"},
				})
				
		elseif k == "bronze" then
			qts.register_craft({
				ingredients = {"default:"..n.."_wood_planks", "default:"..k.."_bar 2"},
				results = {"default:chest_"..n.."_"..k},
				near = {"group:workbench"},
				})
		else
			qts.register_craft({
				ingredients = {"default:"..n.."_wood_planks", "default:"..k.."_bar 2"},
				results = {"default:chest_"..n.."_"..k},
				near = {"group:anvil", "group:furnace"},
				})
		end
	end
end

--END chests

--BEGIN beds
--highly experimental

minetest.register_node("default:bedroll_flax", {
	description = "Flaxen Badroll",
	tiles = {
			"default_textile_flax_top.png", "default_textile_flax_top.png", "default_textile_flax_side.png", "default_textile_flax_side.png",  "default_textile_flax_end.png",  
		},
	drawtype = "nodebox",
	--inventory_image = "default_textile_flax_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 2/16, -7/16, -8/16, 7/16, -3/16, 8/16, },
			{ 2/16, -8/16, -8/16, 6/16, -2/16, 8/16, },
			{ 1/16, -7/16, -8/16, 6/16, -3/16, 8/16, },
			{ -24/16, -8/16, -8/16, 6/16, -7/16, 8/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

--END beds

--BEGIN lights

minetest.register_node("default:candle_palm", {
	description = "Palm Wax Candle",
	tiles = {
		"default_candle_palm_side.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -1/16, -8/16, -1/16, 1/16, -4/16, 1/16, },
			{ 0/16, -4/16, -1/16, 0/16, -3/16, 1/16, },
			{ -1/16, -4/16, 0/16, 1/16, -3/16, 0/16, },
		}
	},
	--sounds = qtcore.node_sound_wood(),
	light_source = 12,
})

--end lights

--BEGIN Tables
minetest.register_node("default:table_oak", {
	description = "Oak Table",
	tiles = {"default_oak_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{0.0625, -0.25, 0.0625, 0.1875, 0.0625, 0.1875}, -- NodeBox1
			{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox2
			{-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox3
			{-0.1875, -0.25, -0.1875, -0.0625, 0.0625, -0.0625}, -- NodeBox4
			{0.0625, -0.25, -0.1875, 0.1875, 0.0625, -0.0625}, -- NodeBox5
			{-0.1875, -0.25, 0.0625, -0.0625, 0.0625, 0.1875}, -- NodeBox6
			{-0.125, 0.0625, -0.125, 0.125, 0.3125, 0.125}, -- NodeBox7
			{-0.1875, 0.3125, -0.4375, 0.1875, 0.4375, 0.4375}, -- NodeBox8
			{-0.375, 0.3125, -0.125, 0.4375, 0.4375, 0.125}, -- NodeBox9
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_pine", {
	description = "Pine Table",
	tiles = {"default_pine_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
			{ -7/16, 5/16, -7/16, 7/16, 7/16, 7/16, },
			{ 5/16, -8/16, -7/16, 7/16, 5/16, -5/16, },
			{ -7/16, -8/16, 5/16, -5/16, 5/16, 7/16, },
			{ 5/16, -8/16, 5/16, 7/16, 5/16, 7/16, },
			{ -7/16, -8/16, -7/16, -5/16, 5/16, -5/16, },
			{ -6/16, -3/16, -6/16, 6/16, -2/16, 6/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_apple", {
	description = "Apple Table",
	tiles = {"default_apple_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
			{ 4/16, -4/16, -3/16, 6/16, 7/16, 3/16, },
			{ -6/16, -4/16, -3/16, -4/16, 7/16, 3/16, },
			{ -6/16, -6/16, -4/16, -4/16, -4/16, -1/16, },
			{ 4/16, -6/16, -4/16, 6/16, -4/16, -1/16, },
			{ -6/16, -6/16, 1/16, -4/16, -4/16, 4/16, },
			{ 4/16, -6/16, 1/16, 6/16, -4/16, 4/16, },
			{ 4/16, -8/16, 2/16, 6/16, -6/16, 5/16, },
			{ 4/16, -8/16, -5/16, 6/16, -6/16, -2/16, },
			{ -6/16, -8/16, -5/16, -4/16, -6/16, -2/16, },
			{ -6/16, -8/16, 2/16, -4/16, -6/16, 5/16, },
			{ -4/16, -2/16, -3/16, 4/16, -1/16, 3/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_swamp", {
	description = "Swamp Table",
	tiles = {"default_swamp_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
				{ -8/16, 6/16, -8/16, 8/16, 8/16, 8/16, },
				{ -7/16, -8/16, -7/16, -5/16, 6/16, -5/16, },
				{ -7/16, -8/16, 5/16, -5/16, 6/16, 7/16, },
				{ 5/16, -8/16, 5/16, 7/16, 6/16, 7/16, },
				{ 5/16, -8/16, -7/16, 7/16, 6/16, -5/16, },
				{ 3/16, -4/16, -6/16, 6/16, -3/16, -3/16, },
				{ 1/16, -4/16, -4/16, 4/16, -3/16, -1/16, },
				{ -4/16, -4/16, 1/16, -1/16, -3/16, 4/16, },
				{ 2/16, -4/16, -5/16, 5/16, -3/16, -2/16, },
				{ -5/16, -4/16, 2/16, -2/16, -3/16, 5/16, },
				{ -6/16, -4/16, 3/16, -3/16, -3/16, 6/16, },
				{ -6/16, -4/16, -6/16, -3/16, -3/16, -3/16, },
				{ -5/16, -4/16, -5/16, -2/16, -3/16, -2/16, },
				{ -4/16, -4/16, -4/16, -1/16, -3/16, -1/16, },
				{ 3/16, -4/16, 3/16, 6/16, -3/16, 6/16, },
				{ 2/16, -4/16, 2/16, 5/16, -3/16, 5/16, },
				{ 1/16, -4/16, 1/16, 4/16, -3/16, 4/16, },
				{ -3/16, -4/16, -3/16, 3/16, -3/16, 3/16, },

		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_rowan", {
	description = "Rowan Table",
	tiles = {"default_rowan_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
				{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
				{ -2/16, 0/16, -2/16, 2/16, 4/16, 2/16, },
				{ -3/16, -7/16, -3/16, 3/16, -5/16, 3/16, },
				{ -4/16, -8/16, -4/16, 4/16, -7/16, 4/16, },
				{ 1/16, 4/16, 1/16, 4/16, 5/16, 4/16, },
				{ -4/16, 4/16, 1/16, -1/16, 5/16, 4/16, },
				{ -4/16, 4/16, -4/16, -1/16, 5/16, -1/16, },
				{ 1/16, 4/16, -4/16, 4/16, 5/16, -1/16, },
				{ 2/16, 5/16, -5/16, 5/16, 6/16, -2/16, },
				{ 3/16, 6/16, -6/16, 6/16, 7/16, -3/16, },
				{ 3/16, 6/16, 3/16, 6/16, 7/16, 6/16, },
				{ -6/16, 6/16, 3/16, -3/16, 7/16, 6/16, },
				{ -6/16, 6/16, -6/16, -3/16, 7/16, -3/16, },
				{ -5/16, 5/16, -5/16, -2/16, 6/16, -2/16, },
				{ -5/16, 5/16, 2/16, -2/16, 6/16, 5/16, },
				{ 2/16, 5/16, 2/16, 5/16, 6/16, 5/16, },
				{ -2/16, -5/16, -2/16, -1/16, 0/16, -1/16, },
				{ 1/16, -5/16, -2/16, 2/16, 0/16, -1/16, },
				{ 1/16, -5/16, 1/16, 2/16, 0/16, 2/16, },
				{ -2/16, -5/16, 1/16, -1/16, 0/16, 2/16, },

		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_lanternfruit", {
	description = "Lanterfruit Table",
	tiles = {"default_lanternfruit_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
			{ -8/16, 5/16, -8/16, 8/16, 6/16, 8/16, },
			{ -8/16, 5/16, -8/16, -7/16, 8/16, -7/16, },
			{ -2/16, -8/16, -2/16, 2/16, 5/16, 2/16, },
			{ -8/16, 5/16, 7/16, -7/16, 8/16, 8/16, },
			{ 7/16, 5/16, 7/16, 8/16, 8/16, 8/16, },
			{ 7/16, 5/16, -8/16, 8/16, 8/16, -7/16, },
			{ -6/16, 4/16, -5/16, 6/16, 5/16, 5/16, },
			{ -5/16, -8/16, -5/16, 5/16, -7/16, 5/16, },
			{ -3/16, -7/16, -3/16, 3/16, -5/16, 3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_mahogany", {
	description = "Mahogany Table",
	tiles = {"default_mahogany_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
					{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
					{ -6/16, -8/16, -6/16, -5/16, 7/16, -5/16, },
					{ -6/16, -8/16, 5/16, -5/16, 7/16, 6/16, },
					{ 5/16, -8/16, 5/16, 6/16, 7/16, 6/16, },
					{ 5/16, -8/16, -6/16, 6/16, 7/16, -5/16, },
					{ 3/16, -1/16, -6/16, 6/16, 0/16, -3/16, },
					{ 1/16, -1/16, -4/16, 4/16, 0/16, -1/16, },
					{ -4/16, -1/16, 1/16, -1/16, 0/16, 4/16, },
					{ 2/16, -1/16, -5/16, 5/16, 0/16, -2/16, },
					{ -5/16, -1/16, 2/16, -2/16, 0/16, 5/16, },
					{ -6/16, -1/16, 3/16, -3/16, 0/16, 6/16, },
					{ -6/16, -1/16, -6/16, -3/16, 0/16, -3/16, },
					{ -5/16, -1/16, -5/16, -2/16, 0/16, -2/16, },
					{ -4/16, -1/16, -4/16, -1/16, 0/16, -1/16, },
					{ 3/16, -1/16, 3/16, 6/16, 0/16, 6/16, },
					{ 2/16, -1/16, 2/16, 5/16, 0/16, 5/16, },
					{ 1/16, -1/16, 1/16, 4/16, 0/16, 4/16, },
					{ -3/16, -1/16, -3/16, 3/16, 0/16, 3/16, },
					{ -1/16, -8/16, -1/16, 1/16, 7/16, 1/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_coffee", {
	description = "Coffee Table",
	tiles = {"default_coffee_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
			{ -1/16, 2/16, -2/16, 1/16, 5/16, 2/16, },
			{ -3/16, -7/16, -3/16, 3/16, -6/16, 3/16, },
			{ -4/16, -8/16, -4/16, 4/16, -7/16, 4/16, },
			{ -3/16, 5/16, -3/16, 3/16, 6/16, 3/16, },
			{ 1/16, 6/16, 1/16, 4/16, 7/16, 4/16, },
			{ 1/16, 6/16, -4/16, 4/16, 7/16, -1/16, },
			{ -4/16, 6/16, -4/16, -1/16, 7/16, -1/16, },
			{ -4/16, 6/16, 1/16, -1/16, 7/16, 4/16, },
			{ -2/16, -6/16, -2/16, 2/16, -4/16, 2/16, },
			{ 1/16, -4/16, 1/16, 3/16, 1/16, 3/16, },
			{ 1/16, -4/16, -3/16, 3/16, 1/16, -1/16, },
			{ -3/16, -4/16, -3/16, -1/16, 1/16, -1/16, },
			{ -3/16, -4/16, 1/16, -1/16, 1/16, 3/16, },
			{ -4/16, 1/16, -4/16, 4/16, 2/16, 4/16, },
			{ -2/16, 2/16, -1/16, 2/16, 5/16, 1/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_rosewood", {
	description = "Rosewood Table",
	tiles = {"default_rosewood_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/16, 7/16, -4/16, 6/16, 8/16, 4/16, },
			{ -5/16, 7/16, -5/16, 5/16, 8/16, 5/16, },
			{ -4/16, 7/16, -6/16, 4/16, 8/16, 6/16, },
			{ -3/16, 7/16, -7/16, 3/16, 8/16, 7/16, },
			{ -2/16, 7/16, -8/16, 2/16, 8/16, 8/16, },
			{ -7/16, 7/16, -3/16, 7/16, 8/16, 3/16, },
			{ -8/16, 7/16, -2/16, 8/16, 8/16, 2/16, },
			{ -2/16, -5/16, -2/16, 2/16, 5/16, 2/16, },
			{ -3/16, -7/16, -3/16, 3/16, -5/16, 3/16, },
			{ -4/16, -8/16, -4/16, 4/16, -7/16, 4/16, },
			{ -3/16, 5/16, -3/16, 3/16, 6/16, 3/16, },
			{ 1/16, 6/16, 1/16, 4/16, 7/16, 4/16, },
			{ 1/16, 6/16, -4/16, 4/16, 7/16, -1/16, },
			{ -4/16, 6/16, -4/16, -1/16, 7/16, -1/16, },
			{ -4/16, 6/16, 1/16, -1/16, 7/16, 4/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_aspen", {
	description = "Aspen Table",
	tiles = {"default_aspen_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/16, 7/16, -5/16, 6/16, 8/16, 5/16, },
			{ -5/16, 7/16, -6/16, 5/16, 8/16, 6/16, },
			{ -4/16, 7/16, -7/16, 4/16, 8/16, 7/16, },
			{ -3/16, 7/16, -8/16, 3/16, 8/16, 8/16, },
			{ -7/16, 7/16, -4/16, 7/16, 8/16, 4/16, },
			{ -8/16, 7/16, -3/16, 8/16, 8/16, 3/16, },
			{ -5/16, 6/16, -5/16, 5/16, 7/16, 5/16, },
			{ 4/16, -8/16, 4/16, 5/16, 7/16, 5/16, },
			{ 4/16, -8/16, -5/16, 5/16, 7/16, -4/16, },
			{ -5/16, -8/16, 4/16, -4/16, 7/16, 5/16, },
			{ -5/16, -8/16, -5/16, -4/16, 7/16, -4/16, },
			{ -4/16, -2/16, 4/16, 4/16, 0/16, 5/16, },
			{ -4/16, -2/16, -5/16, 4/16, 0/16, -4/16, },
			{ 4/16, -2/16, -4/16, 5/16, 0/16, 4/16, },
			{ -5/16, -2/16, -4/16, -4/16, 0/16, 4/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_bamboo", {
	description = "Bamboo Table",
	tiles = {
			"default_bamboo_table_top.png",
			"default_bamboo_table_top.png",
			"default_bamboo_log_side.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/16, 7/16, -6/16, 6/16, 8/16, 6/16, },
			{ -6/16, 6/16, -8/16, 6/16, 8/16, -6/16, },
			{ -6/16, 6/16, 6/16, 6/16, 8/16, 8/16, },
			{ 6/16, 6/16, -6/16, 8/16, 8/16, 6/16, },
			{ -8/16, 6/16, -6/16, -6/16, 8/16, 6/16, },
			{ 6/16, -8/16, -8/16, 8/16, 8/16, -6/16, },
			{ -8/16, -8/16, 6/16, -6/16, 8/16, 8/16, },
			{ 6/16, -8/16, 6/16, 8/16, 8/16, 8/16, },
			{ -8/16, -8/16, -8/16, -6/16, 8/16, -6/16, },
			{ -8/16, -3/16, -6/16, -6/16, -1/16, 6/16, },
			{ 6/16, -3/16, -6/16, 8/16, -1/16, 6/16, },
			{ -6/16, -3/16, 6/16, 6/16, -1/16, 8/16, },
			{ -6/16, -3/16, -8/16, 6/16, -1/16, -6/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_blue_mushroom", {
	description = "Blue Mushroom Table",
	tiles = {"default_mushroom_blue_slats.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/16, 6/16, -6/16, 6/16, 7/16, 6/16, },
			{ -6/16, 6/16, -7/16, 6/16, 8/16, -6/16, },
			{ -6/16, 6/16, 6/16, 6/16, 8/16, 7/16, },
			{ 6/16, 6/16, -6/16, 7/16, 8/16, 6/16, },
			{ -7/16, 6/16, -6/16, -6/16, 8/16, 6/16, },
			{ 6/16, -8/16, -8/16, 8/16, 8/16, -6/16, },
			{ -8/16, -8/16, 6/16, -6/16, 8/16, 8/16, },
			{ 6/16, -8/16, 6/16, 8/16, 8/16, 8/16, },
			{ -8/16, -8/16, -8/16, -6/16, 8/16, -6/16, },
			{ -8/16, -2/16, -6/16, -7/16, 0/16, 6/16, },
			{ 7/16, -2/16, -6/16, 8/16, 0/16, 6/16, },
			{ -6/16, -2/16, 7/16, 6/16, 0/16, 8/16, },
			{ -6/16, -2/16, -8/16, 6/16, 0/16, -7/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_brown_mushroom", {
	description = "Brown Mushroom Table",
	tiles = {"default_mushroom_brown_slats.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -6/16, 7/16, -6/16, 6/16, 8/16, 6/16, },
			{ -6/16, 6/16, -7/16, 6/16, 8/16, -6/16, },
			{ -6/16, 6/16, 6/16, 6/16, 8/16, 7/16, },
			{ 6/16, 6/16, -6/16, 7/16, 8/16, 6/16, },
			{ -7/16, 6/16, -6/16, -6/16, 8/16, 6/16, },
			{ -2/16, -3/16, -2/16, 2/16, 7/16, 2/16, },
			{ -4/16, -8/16, -4/16, 4/16, -6/16, 4/16, },
			{ -3/16, -6/16, -3/16, 3/16, -3/16, 3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:table_gold_mushroom", {
	description = "Gold Mushroom Table",
	tiles = {"default_mushroom_gold_slats.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, ttable=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
			{ -2/16, -8/16, -8/16, 2/16, 7/16, -6/16, },
			{ -8/16, 6/16, 7/16, -7/16, 9/16, 8/16, },
			{ 7/16, 6/16, 7/16, 8/16, 9/16, 8/16, },
			{ -8/16, 6/16, -8/16, -7/16, 9/16, -7/16, },
			{ 7/16, 6/16, -8/16, 8/16, 9/16, -7/16, },
			{ -2/16, -2/16, -6/16, 2/16, -1/16, 6/16, },
			{ -2/16, -8/16, 6/16, 2/16, 7/16, 8/16, },
			{ -2/16, 6/16, -6/16, 2/16, 7/16, 6/16, },
			{ -8/16, -2/16, -2/16, 8/16, -1/16, 2/16, },
			{ -8/16, -8/16, -2/16, -6/16, 7/16, 2/16, },
			{ 6/16, -8/16, -2/16, 8/16, 7/16, 2/16, },
			{ -8/16, 6/16, -2/16, 8/16, 7/16, 2/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})
--END tables

--BEGIN Chairs
minetest.register_node("default:chair_oak", {
	description = "Oak Chair",
	tiles = {"default_oak_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 10/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 10/16, -3/16, },
			{ -3/16, 0/16, -4/16, -1/16, 2/16, -3/16, },
			{ -3/16, 5/16, -4/16, -1/16, 7/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ 1/16, 5/16, -4/16, 3/16, 7/16, -3/16, },
			{ -1/16, 6/16, -4/16, 1/16, 8/16, -3/16, },
			{ 1/16, 0/16, -4/16, 3/16, 2/16, -3/16, },
			{ -1/16, 1/16, -4/16, 1/16, 3/16, -3/16, },
			{ -4/16, 1/16, -3/16, -3/16, 2/16, 4/16, },
			{ 3/16, 1/16, -3/16, 4/16, 2/16, 4/16, },
			{ -4/16, -1/16, 2/16, -3/16, 1/16, 3/16, },
			{ 3/16, -1/16, 2/16, 4/16, 1/16, 3/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_pine", {
	description = "Pine Chair",
	tiles = {"default_pine_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 6/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 6/16, -3/16, },
			{ -3/16, 0/16, -4/16, 3/16, 2/16, -3/16, },
			{ -3/16, 3/16, -4/16, 3/16, 5/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_apple", {
	description = "Apple Chair",
	tiles = {"default_apple_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 1/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 1/16, -3/16, },
			{ -4/16, 1/16, -4/16, 4/16, 2/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ -4/16, 1/16, -3/16, -3/16, 2/16, 4/16, },
			{ 3/16, 1/16, -3/16, 4/16, 2/16, 4/16, },
			{ -4/16, -1/16, 2/16, -3/16, 1/16, 3/16, },
			{ 3/16, -1/16, 2/16, 4/16, 1/16, 3/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_swamp", {
	description = "Swamp Chair",
	tiles = {"default_swamp_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, -2/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, -2/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
			{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
			{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
			{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_rowan", {
	description = "Rowan Chair",
	tiles = {"default_rowan_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 9/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 9/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
			{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
			{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
			{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
			{ -1/16, -1/16, -4/16, 1/16, 11/16, -3/16, },
			{ -3/16, 0/16, -4/16, 3/16, 2/16, -3/16, },
			{ -3/16, 3/16, -4/16, 3/16, 5/16, -3/16, },
			{ -3/16, 6/16, -4/16, 3/16, 8/16, -3/16, },
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_lanternfruit", {
	description = "Lanterfruit Chair",
	tiles = {"default_lanternfruit_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, 0/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 6/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 6/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, 0/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
			{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
			{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
			{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
			{ -1/16, -1/16, -4/16, 1/16, 7/16, -3/16, },
			{ -3/16, 0/16, -4/16, 3/16, 2/16, -3/16, },
			{ -3/16, 3/16, -4/16, 3/16, 5/16, -3/16, },
			{ -4/16, 0/16, -4/16, -3/16, 1/16, 4/16, },
			{ 3/16, 0/16, -4/16, 4/16, 1/16, 4/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_mahogany", {
	description = "Mahogany Chair",
	tiles = {"default_mahogany_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, 0/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 9/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 9/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, 0/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ -1/16, -1/16, -4/16, 1/16, 7/16, -3/16, },
			{ -3/16, 0/16, -4/16, 3/16, 2/16, -3/16, },
			{ -3/16, 3/16, -4/16, 3/16, 5/16, -3/16, },
			{ -4/16, 0/16, -4/16, -3/16, 1/16, 4/16, },
			{ 3/16, 0/16, -4/16, 4/16, 1/16, 4/16, },
			{ 2/16, 6/16, -4/16, 3/16, 8/16, -3/16, },
			{ -3/16, 6/16, -4/16, -2/16, 8/16, -3/16, },
			{ -2/16, 5/16, -4/16, -1/16, 7/16, -3/16, },
			{ 1/16, 5/16, -4/16, 2/16, 7/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_coffee", {
	description = "Coffee Chair",
	tiles = {"default_coffee_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, 1/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 7/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 7/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, 1/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ 1/16, -1/16, -4/16, 2/16, 5/16, -3/16, },
			{ -3/16, 2/16, -4/16, 3/16, 3/16, -3/16, },
			{ -3/16, 4/16, -4/16, 3/16, 5/16, -3/16, },
			{ -4/16, 1/16, -4/16, -3/16, 2/16, 4/16, },
			{ 3/16, 1/16, -4/16, 4/16, 2/16, 4/16, },
			{ -2/16, -1/16, -4/16, -1/16, 5/16, -3/16, },
			{ -3/16, 0/16, -4/16, 3/16, 1/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_rosewood", {
	description = "Rosewood Chair",
	tiles = {"default_rosewood_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, 1/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 6/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 6/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, 1/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ 1/16, 3/16, -4/16, 3/16, 5/16, -3/16, },
			{ -1/16, 1/16, -4/16, 1/16, 3/16, -3/16, },
			{ -3/16, 3/16, -4/16, -1/16, 5/16, -3/16, },
			{ -4/16, 1/16, -4/16, -3/16, 2/16, 4/16, },
			{ 3/16, 1/16, -4/16, 4/16, 2/16, 4/16, },
			{ -3/16, -1/16, -4/16, -1/16, 1/16, -3/16, },
			{ 1/16, -1/16, -4/16, 3/16, 1/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_aspen", {
	description = "Aspen Chair",
	tiles = {"default_aspen_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, 3/16, 4/16, 1/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 6/16, -3/16, },
			{ -4/16, -8/16, -4/16, -3/16, 6/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, 1/16, 4/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ 1/16, 6/16, -4/16, 3/16, 7/16, -3/16, },
			{ -1/16, 7/16, -4/16, 1/16, 8/16, -3/16, },
			{ -3/16, 6/16, -4/16, -1/16, 7/16, -3/16, },
			{ -4/16, 1/16, -4/16, -3/16, 2/16, 4/16, },
			{ 3/16, 1/16, -4/16, 4/16, 2/16, 4/16, },
			{ -2/16, -1/16, -4/16, -1/16, 6/16, -3/16, },
			{ 1/16, -1/16, -4/16, 2/16, 6/16, -3/16, },
			{ -3/16, 3/16, -4/16, 3/16, 4/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_bamboo", {
	description = "bamboo Chair",
	tiles = {
			"default_bamboo_chair_top.png",  "default_bamboo_chair_bottom.png", "default_bamboo_chair_side.png", "default_bamboo_chair_side.png", "default_bamboo_chair_front.png", "default_bamboo_chair_front.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 7/16, -3/16, },
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ -4/16, -8/16, -4/16, -3/16, 7/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
			{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
			--{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
			{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
			{ -3/16, -1/16, -4/16, 3/16, 6/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_blue_mushroom", {
	description = "Blue Mushroom Chair",
	tiles = {"default_mushroom_blue_slats.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ 3/16, -8/16, -4/16, 4/16, 7/16, -3/16, },
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ -4/16, -8/16, -4/16, -3/16, 7/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
			{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
			{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
			{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
			{ -2/16, 1/16, -4/16, 2/16, 5/16, -3/16, },
			{ 1/16, 4/16, -4/16, 3/16, 6/16, -3/16, },
			{ 1/16, 0/16, -4/16, 3/16, 2/16, -3/16, },
			{ -3/16, 0/16, -4/16, -1/16, 2/16, -3/16, },
			{ -3/16, 4/16, -4/16, -1/16, 6/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_gold_mushroom", {
	description = "Gold Mushroom Chair",
	tiles = {"default_mushroom_gold_slats.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 3/16, -8/16, -4/16, 4/16, 7/16, -3/16, },
			{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
			{ -4/16, -8/16, -4/16, -3/16, 7/16, -3/16, },
			{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
			{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
			{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
			{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
			{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
			{ -1/16, -1/16, -4/16, 1/16, 9/16, -3/16, },
			{ 1/16, -1/16, -4/16, 3/16, 8/16, -3/16, },
			{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
			{ -3/16, -1/16, -4/16, -1/16, 8/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:chair_brown_mushroom", {
	description = "Brown Mushroom Chair",
	tiles = {"default_mushroom_brown_slats.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
				{ 3/16, -8/16, -4/16, 4/16, -2/16, -3/16, },
				{ 3/16, -8/16, 3/16, 4/16, -2/16, 4/16, },
				{ -4/16, -8/16, -4/16, -3/16, -2/16, -3/16, },
				{ -4/16, -8/16, 3/16, -3/16, -2/16, 4/16, },
				{ 3/16, -5/16, -3/16, 4/16, -4/16, 3/16, },
				{ -3/16, -5/16, 3/16, 3/16, -4/16, 4/16, },
				{ -3/16, -5/16, -4/16, 3/16, -4/16, -3/16, },
				{ -4/16, -5/16, -3/16, -3/16, -4/16, 3/16, },
				{ -4/16, -2/16, -4/16, 4/16, -1/16, 4/16, },
				{ -3/16, -1/16, -4/16, 3/16, 8/16, -3/16, },
				{ -4/16, -1/16, -4/16, -3/16, 8/16, -2/16, },
				{ 3/16, -1/16, -4/16, 4/16, 8/16, -2/16, },
				{ 3/16, -1/16, -2/16, 4/16, 2/16, 4/16, },
				{ -4/16, -1/16, -2/16, -3/16, 2/16, 4/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})
--END chairs

--BEGIN ladders
minetest.register_node("default:ladder", {
	description = "Ladder",
	tiles ={"default_oak_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = true,
	climbable = true,
	groups = {oddly_breakable_by_hand=3, choppy=2, flammable=2, generation_artificial=1},
	node_box = {
		type="fixed",
		fixed = {
			{-0.5, -0.4375, -0.375, 0.5, -0.375, -0.3125}, -- NodeBox8
			{-0.5, -0.4375, -0.125, 0.5, -0.375, -0.0625}, -- NodeBox9
			{-0.375, -0.5, -0.5, -0.3125, -0.4375, 0.5}, -- NodeBox10
			{0.3125, -0.5, -0.5, 0.375, -0.4375, 0.5}, -- NodeBox13
			{-0.5, -0.4375, 0.125, 0.5, -0.375, 0.1875}, -- NodeBox14
			{-0.5, -0.4375, 0.375, 0.5, -0.375, 0.4375}, -- NodeBox15
		}
	},
	selection_box = {
		type="fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.375000, 0.5}
		},
	},
	collision_box = {
		type="fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.375000, 0.5}
		},
	},
	sounds = qtcore.node_sound_wood(),
	on_place = function(itemstack, placer, pointed_thing)
		if (pointed_thing.under ~= nil and minetest.get_node(pointed_thing.under).name == "default:ladder") then
			--place with same rotation as under
			return minetest.item_place(itemstack, placer, pointed_thing, minetest.get_node(pointed_thing.under).param2)
		else
			return minetest.item_place(itemstack, placer, pointed_thing)
		end
	end,
})
--END ladders

--BEGIN bookshelves
local names = {"swamp", "rosewood", "pine", "oak", "mahogany", "lanternfruit", "coffee", "aspen", "apple", "rowan"}
local defs = {"Swamp Wood", "Rosewood", "Pine", "Oak", "Mahopgany", "Lanternfruit Wood", "Coffee Wood", "Aspen", "Applewood", "Rowan"}

for i, n in ipairs(names) do
	local woodname = "default_"..n.."_wood.png"
    minetest.register_node ("default:bookshelf_"..n, {
    	description = defs[i] .. " Bookshelf",
    	drawtype="nodebox",
		paramtype = "light",
		tiles = {{name = woodname, align_style = "node"}, {name = woodname, align_style = "node"}, 
		woodname, woodname, woodname.."^default_bookshelf.png", woodname.."^default_bookshelf.png"},
    	paramtype2 = "facedir",
    	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, bookshelf=1, generation_artificial=1},
    	sounds = qtcore.node_sound_wood(),
		node_box = {
			type = "fixed",
			fixed = {
				{ -8/16, -8/16, -8/16, 8/16, -7/16, 8/16, },
				{ -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
				{ 7/16, -7/16, -8/16, 8/16, 7/16, 8/16, },
				{ -8/16, -7/16, -8/16, -7/16, 7/16, 8/16, },
				{ -7/16, -7/16, -6/16, 7/16, 7/16, 6/16, },
				{ -7/16, -1/16, -8/16, 7/16, 1/16, 8/16, },
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -8/16, -8/16, -8/16, 8/16, 8/16, 8/16, },
			}
		},
    })
end
--END bookshelves





-- BEGIN Crafting
--BEGIN Tables
qts.register_craft({
	ingredients = {"default:oak_wood_planks"},
	results = {"default:table_oak"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:apple_wood_planks"},
	results = {"default:table_apple"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:aspen_wood_planks"},
	results = {"default:table_aspen"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:coffee_wood_planks"},
	results = {"default:table_coffee"},
	near = {"group:workbench"}
})

	qts.register_craft({
	ingredients = {"default:lanternfruit_wood_planks"},
	results = {"default:table_lanternfruit"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:swamp_wood_planks"},
	results = {"default:table_swamp"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:rosewood_wood_planks"},
	results = {"default:table_rosewood"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:mahogany_wood_planks"},
	results = {"default:table_mahogany"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:pine_wood_planks"},
	results = {"default:table_pine"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:rowan_wood_planks"},
	results = {"default:table_rowan"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:bamboo 2"},
	results = {"default:table_bamboo"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:blue_mushroom_slats"},
	results = {"default:table_blue_mushroom"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:brown_mushroom_slats"},
	results = {"default:table_brown_mushroom"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:gold_mushroom_slats"},
	results = {"default:table_gold_mushroom"},
	near = {"group:workbench"},
})
--END tables
--BEGIN Chairs
qts.register_craft({
	ingredients = {"default:oak_wood_planks"},
	results = {"default:chair_oak 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:apple_wood_planks"},
	results = {"default:chair_apple 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:aspen_wood_planks"},
	results = {"default:chair_aspen 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:coffee_wood_planks"},
	results = {"default:chair_coffee 2"},
	near = {"group:workbench"}
})

	qts.register_craft({
	ingredients = {"default:lanternfruit_wood_planks"},
	results = {"default:chair_lanternfruit 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:swamp_wood_planks"},
	results = {"default:chair_swamp 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:rosewood_wood_planks"},
	results = {"default:chair_rosewood 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:mahogany_wood_planks"},
	results = {"default:chair_mahogany 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:pine_wood_planks"},
	results = {"default:chair_pine 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:rowan_wood_planks"},
	results = {"default:chair_rowan 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:bamboo"},
	results = {"default:chair_bamboo"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:blue_mushroom_slats"},
	results = {"default:chair_blue_mushroom 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:brown_mushroom_slats"},
	results = {"default:chair_brown_mushroom 2"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:gold_mushroom_slats"},
	results = {"default:chair_gold_mushroom 2"},
	near = {"group:workbench"},
})
--END Chairs
--BEGIN ladders
qts.register_craft({
	ingredients = {"group:wood"},
	results = {"default:ladder 8"},
})
--END ladders
qts.register_craft({
	ingredients = {"default:textile_flax 2"},
	results = {"default:bedroll_flax"},
	near = {"group:workbench"},
})
--BEGIN beds

--END beds

-- bookshelves crafting can be found in crafts.lua under "wood permutations"



--[[BEGIN unused content pertaining to furniture

minetest.register_node("default:food_table", {
	description = "Cooking Table",
	tiles = {
			"default_food_table_top.png",
			"default_oak_wood.png",
			"default_food_table_side.png"
		},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -8/16, 1/16, -8/16, 8/16, 3/16, 8/16, },
		{ -7/16, -8/16, -7/16, -5/16, 1/16, -5/16, },
		{ 5/16, -8/16, -7/16, 7/16, 1/16, -5/16, },
		{ 5/16, -8/16, 5/16, 7/16, 1/16, 7/16, },
		{ -7/16, -8/16, 5/16, -5/16, 1/16, 7/16, },
		{ -2/16, 3/16, -4/16, 2/16, 4/16, 0/16, },
		{ -1/16, 3/16, 2/16, 2/16, 4/16, 5/16, },
		{ 2/16, 4/16, 1/16, 3/16, 5/16, 6/16, },
		{ -2/16, 4/16, 1/16, -1/16, 5/16, 6/16, },
		{ -2/16, 4/16, 1/16, 3/16, 5/16, 2/16, },
		{ -2/16, 4/16, 5/16, 3/16, 5/16, 6/16, },
		{ 3/16, 3/16, -6/16, 6/16, 7/16, -3/16, },
		{ 4/16, 7/16, -5/16, 5/16, 8/16, -4/16, },
		{ -2/16, 3/16, -4/16, -1/16, 7/16, 0/16, },
		{ 1/16, 3/16, -4/16, 2/16, 7/16, 0/16, },
		{ -2/16, 3/16, -4/16, 2/16, 7/16, -3/16, },
		{ -2/16, 3/16, -1/16, 2/16, 7/16, 0/16, },
		},
	},
	sounds = qtcore.node_sound_wood(),
})
]]--