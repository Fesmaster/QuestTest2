--[[
    Wood and Tree bits live here

	Most woods and Mushrooms are registered in large tables. This makes the code more condense, and,
	if a universal feature neesd to change, its easy to do it.
]]


--Planks and Logs
local TREE_TIME = qts.config("TREE_GROWTH_TIME", 390, "The time it takes for a tree to grow from a sapling", {loadtime=true})
local TREE_VAR = qts.config("TREE_GROWTH_TIME_VARIANCE", 30, "The variance in time it takes for a tree to grow from a sapling", {loadtime=true})

--common wood types
---@type {name:string, desc:string, grow_func:function}[]
local woods = {
	{name="oak",  			desc="Oak",  		grow_func=qtcore.grow_oak_tree,},
	{name="apple",  		desc="Apple",  		grow_func=qtcore.grow_apple_tree,},
	{name="aspen",  		desc="Aspen",  		grow_func=qtcore.grow_aspen_tree,},
	{name="coffee",  		desc="Coffee",  	grow_func=qtcore.grow_coffee_tree,},
	{name="mahogany",  		desc="Mahogany",  	grow_func=qtcore.grow_mahogany_tree,},
	{name="rosewood",  		desc="Rosewood",  	grow_func=qtcore.grow_rosewood_tree,},
	{name="pine",  			desc="Pine",  		grow_func=qtcore.grow_pine_tree,},
	{name="lanternfruit", 	desc="Lanternfruit",grow_func=qtcore.grow_lantern_tree,},
	{name="rowan", 			desc="Rowan", 		grow_func=qtcore.grow_rowan_tree,},
}

--The large loop for all the common woods
for i, wood in ipairs(woods) do
	--planks
	qts.register_shaped_node ("overworld:"..wood.name.."_wood_planks", {
		description = wood.desc.." Wood Planks",
		tiles = {"overworld_"..wood.name.."_wood.png"},
		paramtype2 = "colorfacedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1, },
		sounds = qtcore.node_sound_wood(),
		palette = "qt_palette_paint_light.png",
	})

	--log
	qts.register_shaped_node ("overworld:"..wood.name.."_log", {
		description = wood.desc.." Log",
		tiles = {
			"overworld_"..wood.name.."_top.png", 
			"overworld_"..wood.name.."_top.png", 
			"overworld_"..wood.name.."_side.png"
		},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1, },
		sounds = qtcore.node_sound_wood(),
		on_place = qtcore.pillar_place,
	})
	
	--stripped logs
	qts.register_shaped_node("overworld:stripped_"..wood.name.."_log", {
		description = "Stripped "..wood.desc.." Log",
		tiles = {
			"overworld_stripped_"..wood.name.."_top.png",
			"overworld_stripped_"..wood.name.."_top.png",
			"overworld_stripped_"..wood.name.."_side.png",
		},
		paramtype2 = "colorfacedir",
		groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable=2, log = 1, generation_artificial=1, },
		sounds = qtcore.node_sound_wood(),
		palette = "qt_palette_paint_light.png",
		on_place = qtcore.pillar_place, 
	})

	--bark
	minetest.register_craftitem("overworld:bark_"..wood.name, {
		description = wood.desc.." Bark",
		inventory_image = "overworld_bark_"..wood.name..".png",
		groups = {bark = 1,},
		sounds = qtcore.node_sound_wood(),
	})

	--Leaves
	--[[
	leaves use param2 to hold if they were placed by the player
	to allow player-placed leaves to not decay
	--]]
	minetest.register_node("overworld:"..wood.name.."_leaves", {
		description = wood.desc.." Leaves",
		drawtype = "allfaces_optional",
		waving = 1,
		tiles = {"overworld_"..wood.name.."_leaves.png"},
		use_texture_alpha = "clip",
		paramtype = "light",
		groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
		drop = {
			max_items = 1,
			items = {
				{items = {"overworld:"..wood.name.."_sapling"}, rarity = 16},
				{items = {"overworld:"..wood.name.."_leaves"}},
			}
		},
		walkable = false,
		climbable = true,
		sounds = qtcore.node_sound_grass(),
		after_place_node = qtcore.after_place_leaves;
	})

	--sapling
	qts.register_growable_node("overworld:"..wood.name.."_sapling", {
		description = wood.desc.." Sapling",
		tiles ={"overworld_"..wood.name.."_leaves.png", "overworld_"..wood.name.."_leaves.png", 
			"overworld_"..wood.name.."_leaves.png^[lowpart:37:overworld_"..wood.name.."_side.png"},
		use_texture_alpha = "clip",
		groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
		sounds = qtcore.node_sound_grass(),
		drawtype = "nodebox",
		paramtype = "light",
		node_box = qtcore.nb_sapling(),
		paramtype2 = "facedir",
		growable_nodes = {"group:soil"},
		grow_timer = TREE_TIME.get(),
		grow_timer_random = TREE_VAR.get(),
		on_grow = function(pos --[[@type Vector]])
			minetest.log("info","An Oak tree has grown at "..minetest.pos_to_string(pos))
			minetest.set_node(pos, {name = "air"})
			wood.grow_func(pos)
		end,
	})

	--fence
	qts.register_fencelike_node("overworld:"..wood.name.."_wood_fence", {
		description = wood.desc.." Wood Fence",
		type = "fence",
		tiles = {"overworld_"..wood.name.."_wood.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..wood.name.."_wood_rail",
		paramtype2 = "color",
		palette = "qt_palette_paint_light.png",
	})
	
	--rail
	qts.register_fencelike_node("overworld:"..wood.name.."_wood_rail", {
		description = wood.desc.." Wood Rail",
		type = "rail",
		tiles = {"overworld_"..wood.name.."_wood.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..wood.name.."_wood_fence", 
		drop = "overworld:"..wood.name.."_wood_fence",
		paramtype2 = "color",
		palette = "qt_palette_paint_light.png",
	})

	--default aliases for tree backcompatablility
	qts.register_shapeed_alias("default:"..wood.name.."_log", "overworld:"..wood.name.."_log")
	minetest.register_alias("default:"..wood.name.."_sapling", 			"overworld:"..wood.name.."_sapling")
	minetest.register_alias("default:"..wood.name.."_leaves", 			"overworld:"..wood.name.."_leaves")


	qtcore.register_material("wood", {
		name=wood.name,
		desc = wood.desc,
		planks="overworld:"..wood.name.."_wood_planks",
		log="overworld:"..wood.name.."_log",
		log_stripped="overworld:stripped_"..wood.name.."_log",
		bark="overworld:bark_"..wood.name,
		leaves="overworld:"..wood.name.."_leaves",
		sapling="overworld:"..wood.name.."_sapling",
		fence="overworld:"..wood.name.."_wood_fence",
		rail="overworld:"..wood.name.."_wood_rail",

		plank_texture = "overworld_"..wood.name.."_wood.png",
	})

	if wood == woods[1] then
		inventory.register_exemplar_item("wood", "overworld:"..wood.name.."_wood_planks")
		inventory.register_exemplar_item("log", "overworld:"..wood.name.."_log")
		inventory.register_exemplar_item("leaves", "overworld:"..wood.name.."_leaves")
		inventory.register_exemplar_item("bark", "overworld:bark_"..wood.name)
	end

end

minetest.register_alias("default:coffeetree_leaves", "overworld:coffee_leaves")

--lanternfruit early misspelling fix for tree backcompatablility
qts.register_shapeed_alias("default:lanterfruit_log", "overworld:lanternfruit_log")

--lanternfruit fruit
minetest.register_node("overworld:lantern_fruit", {
	description = "Lantern Fruit",
	tiles ={
		"overworld_lantern_fruit_top.png", 
		"overworld_lantern_fruit_bottom.png",
		"overworld_lantern_fruit_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	node_box = qtcore.nb_lantern_fruit(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	groups = {snappy = 3, fruit = 1, generation_trees=1, generation_artificial=1},
	--sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

--[[
	fix lanternfruit wood fence, as it uses a special texture.
]]
minetest.override_item("overworld:lanternfruit_wood_fence", {
	tiles = {"overworld_lanternfruit_wood_fence.png"},
})

minetest.register_alias("default:lantern_fruit", "overworld:lantern_fruit")

--fruit-bearing apple leaves:
minetest.register_node("overworld:apple_leaves_fruit", {
	description = "Apple Leaves with Apples",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"overworld_apple_leaves_fruit.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 2,
		items = {
			{items = {"overworld:apple"}},
			{items = {"overworld:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})
--worldgen alias
minetest.register_alias("default:apple_leaves_fruit", "overworld:apple_leaves_fruit")

--palm, swamp, and bamboo are a bit special.

--palm: has no planks or stripped version. palm is a completely useless wood
qts.register_shaped_node ("overworld:palm_log", {
	description = "Palm Log",
	tiles = {"overworld_palm_top.png", "overworld_palm_top.png", "overworld_palm_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
	on_place = qtcore.pillar_place, 
})

qts.register_shapeed_alias("default:palm_log", "overworld:palm_log")

minetest.register_node("overworld:palm_leaves", {
	description = "Palm Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"overworld_palm_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:palm_sapling"}, rarity = 16},
			{items = {"overworld:palm_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})
minetest.register_alias("default:palm_leaves", "overworld:palm_leaves")

qts.register_growable_node("overworld:palm_sapling", {
	description = "Palm Sapling",
	tiles ={"overworld_palm_leaves.png", "overworld_palm_leaves.png", 
		"overworld_palm_leaves.png^[lowpart:37:overworld_palm_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_grass(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	growable_nodes = {"group:sand"},
	grow_timer = TREE_TIME.get(),
	grow_timer_random = TREE_VAR.get(),
	on_grow = function(pos --[[@type Vector]])
		minetest.log("info","An palm tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_palm_tree(pos)
	end,
})

qtcore.register_material("wood", {
	name="palm",
	desc="Palm",
	log="overworld:palm_log",
	leaves="overworld:palm_leaves",
	sapling="overworld:palm_sapling",
})

--swamp wood. has a nodebox for the log and leaves
qts.register_shaped_node ("overworld:swamp_wood_planks", {
	description = "Swamp Wood Planks",
	tiles = {{name = "overworld_swamp_wood.png", align_style = "node"}},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "qt_palette_paint_light.png",
})

minetest.register_node("overworld:swamp_log", {
	description = "Swamp Log",
	tiles = {
		"overworld_swamp_log_top.png",
		"overworld_swamp_log_top.png",
		"overworld_swamp_log_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.375, 0, 0.5, -0.0625}, -- NodeBox10
			{0.0625, -0.5, 0, 0.4375, 0.9375, 0.375}, -- NodeBox11
		}
	}
})
minetest.register_alias("default:swamp_log", "overworld:swamp_log")

minetest.register_node("overworld:stripped_swamp_log", {
	description = "Stripped Swamp Log",
	tiles = {
		"overworld_swamp_log_top.png",
		"overworld_swamp_log_top.png",
		"overworld_stripped_swamp_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.375, 0, 0.5, -0.0625}, -- NodeBox10
			{0.0625, -0.5, 0, 0.4375, 0.9375, 0.375}, -- NodeBox11
		}
	}
})

minetest.register_node("overworld:swamp_leaves", {
	description = "Swamp Leaves",
	tiles = {"overworld_swamp_leaves.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	waving = 1,
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
	node_box = {
		type = "fixed",
		fixed = {
			{-0.625, -0.5, -0.625, 0.625, 0.6875, 0.625}, -- NodeBox12
			{-0.0625, 0.125, 0.1875, 0.75, 0.9375, 0.875}, -- NodeBox13
			{-0.9375, -0.75, -1, -0.125, 0, -0.125}, -- NodeBox14
		}
	}
})
minetest.register_alias("default:swamp_leaves", "overworld:swamp_leaves")

--fence
qts.register_fencelike_node("overworld:swamp_wood_fence", {
	description = "Swamp Wood Fence",
	type = "fence",
	tiles = {"overworld_swamp_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "overworld:swamp_wood_rail",
	paramtype2 = "color",
	palette = "qt_palette_paint_light.png",
})

--rail
qts.register_fencelike_node("overworld:swamp_wood_rail", {
	description = "Swamp Wood Rail",
	type = "rail",
	tiles = {"overworld_swamp_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "overworld:swamp_wood_fence", 
	drop = "overworld:swamp_wood_fence",
	paramtype2 = "color",
	palette = "qt_palette_paint_light.png",
})

qtcore.register_material("wood", {
	name="swamp",
	desc = "Swamp",
	planks="overworld:swamp_wood_planks",
	log="overworld:swamp_log",
	log_stripped="overworld:stripped_swamp_log",
	leaves="overworld:swamp_leaves",
	plank_texture = "overworld_swamp_wood.png",
	fence="overworld:swamp_wood_fence",
	rail="overworld:swamp_wood_rail",
--	sapling="overworld:palm_sapling",
})

--bamboo has a nodebox for trunk and leaves, and also no stripped version
qts.register_shaped_node ("overworld:bamboo_planks", {
	description = "Bamboo Slats",
	tiles = {"overworld_bamboo_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("overworld:bamboo", {
	description = "Bamboo",
	tiles = {
		"overworld_bamboo_log_top.png",
		"overworld_bamboo_log_top.png",
		"overworld_bamboo_log_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=1, flammable=2, log=1, generation_trees=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -6/16, -1/16, 8/16, -4/16, },
			{ -6/16, -8/16, 3/16, -3/16, 8/16, 6/16, },
			{ 4/16, -8/16, 1/16, 6/16, 8/16, 3/16, },
			{ 1/16, -8/16, -4/16, 4/16, 8/16, -1/16, },
		}
	}
})
minetest.register_alias("default:bamboo", "overworld:bamboo")

minetest.register_node("overworld:bamboo_leaves", {
	description = "Bamboo Leaves",
	tiles = {
			"overworld_bamboo_leaves_top.png", "overworld_bamboo_leaves_side.png",
		},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	waving = 1,
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	walkable = false,
	climbable = false,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -6/16, -1/16, 8/16, -4/16, },
			{ -6/16, -8/16, 3/16, -3/16, 8/16, 6/16, },
			{ 4/16, -8/16, 1/16, 6/16, 8/16, 3/16, },
			{ 1/16, -8/16, -4/16, 4/16, 8/16, -1/16, },
			{ 6/16, -10/16, 6/16, 10/16, -6/16, 10/16, },
			{ -1/16, -5/16, 7/16, 1/16, 7/16, 9/16, },
			{ -9/16, -5/16, 6/16, -6/16, 3/16, 9/16, },
			{ -9/16, -1/16, -1/16, -7/16, 5/16, 1/16, },
			{ -10/16, 6/16, -10/16, -6/16, 10/16, -6/16, },
			{ -1/16, 6/16, -10/16, 1/16, 10/16, 3/16, },
			{ 6/16, -2/16, -10/16, 10/16, 2/16, -6/16, },
			{ 0/16, -9/16, -1/16, 9/16, 2/16, 1/16, },
			{ -8/16, -8/16, -8/16, 8/16, 8/16, 8/16, },
		}
	}
})
minetest.register_alias("default:bamboo_leaves", "overworld:bamboo_leaves")

qts.register_fencelike_node("overworld:bamboo_fence", {
	description = "Bamboo Fence",
	type = "fence",
	tiles = {"overworld_bamboo_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "overworld:bamboo_rail", 
	paramtype2 = "color",
	palette = "qt_palette_paint_light.png",
})

qts.register_fencelike_node("overworld:bamboo_rail", {
	description = "Bamboo Rail",
	type = "rail",
	tiles = {"overworld_bamboo_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "overworld:bamboo_fence", 
	drop = "overworld:bamboo_fence",
	paramtype2 = "color",
	palette = "qt_palette_paint_light.png",
})

qtcore.register_material("wood", {
	name="bamboo",
	desc="Bamboo",
	planks="overworld:bamboo_planks",
	log="overworld:bamboo",
	leaves="overworld:bamboo_leaves",
	fence="overworld:bamboo_fence",
	rail="overworld:bamboo_rail",
	plank_texture = "overworld_bamboo_slats.png",
})

--Mushrooms
local mushroom_names = {"blue", "gold", "brown"}
local mushroom_descs = {"Blue", "Gold", "Brown"}
for i, name in ipairs(mushroom_names) do
	local desc = mushroom_descs[i]

	--trunk
	qts.register_shaped_node ("overworld:"..name.."_mushroom_trunk", {
		description = desc.." Mushroom Trunk",
		tiles = {
			"overworld_mushroom_"..name.."_top.png", 
			"overworld_mushroom_"..name.."_top.png", 
			"overworld_mushroom_"..name.."_side.png"
		},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
		sounds = qtcore.node_sound_wood(),
		on_place = qtcore.pillar_place, 
	})

	--cap (leaves)
	qts.register_shaped_node ("overworld:"..name.."_mushroom_cap", {
		description = desc.." Mushroom Cap",
		tiles = {"overworld_mushroom_"..name.."_cap.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
		sounds = qtcore.node_sound_wood(),
	})
	
	--slats (planks)
	qts.register_shaped_node ("overworld:"..name.."_mushroom_slats", {
		description = desc.." Mushroom Slats",
		tiles = {"overworld_mushroom_"..name.."_slats.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
	})
	
	--tiles
	qts.register_shaped_node ("overworld:"..name.."_mushroom_plates", {
		description = desc.." Mushroom Plates",
		tiles = {"overworld_mushroom_"..name.."_plates.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
	})

	--fence
	qts.register_fencelike_node("overworld:"..name.."_mushroom_fence", {
		description = desc.." Mushroom Fence",
		type = "fence",
		tiles = {"overworld_mushroom_"..name.."_slats.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..name.."_mushroom_rail",
		paramtype2 = "color",
		palette = "qt_palette_paint_light.png",
	})
	
	--rail
	qts.register_fencelike_node("overworld:"..name.."_mushroom_rail", {
		description = desc.." Wood Rail",
		type = "rail",
		tiles = {"overworld_mushroom_"..name.."_slats.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..name.."_mushroom_fence", 
		drop = "overworld:"..name.."_mushroom_fence",
		paramtype2 = "color",
		palette = "qt_palette_paint_light.png",
	})

	--worldgen aliases
	qts.register_shapeed_alias("default:"..name.."_mushroom_trunk", "overworld:"..name.."_mushroom_trunk")
	qts.register_shapeed_alias("default:"..name.."_mushroom_cap", "overworld:"..name.."_mushroom_cap")

	qtcore.register_material("wood", {
		name = name..'_mushroom',
		desc = desc.." Mushroom",
		class="mushroom", --mushrooms are a bit different sometimes
		planks="overworld:"..name.."_mushroom_slats",
		log="overworld:"..name.."_mushroom_trunk",
		plates="overworld:"..name.."_mushroom_plates",
		leaves="overworld:"..name.."_mushroom_cap",
		fence="overworld:"..name.."_mushroom_fence",
		rail="overworld:"..name.."_mushroom_rail",
		plank_texture = "overworld_mushroom_"..name.."_slats.png"
	})
end

minetest.register_node("overworld:gold_mushroom_spore", {
	description = "Golden Mushroom Spore",
	tiles = {"overworld_mushroom_gold_spore.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, spore = 1, generation_replacable=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.4375, 0, -0.3125, -0.1875}, -- NodeBox1
			{0.0625, -0.5, -0.25, 0.4375, -0.25, 0.125}, -- NodeBox2
			{-0.25, -0.5, -0.0625, -0.125, -0.375, 0.0625}, -- NodeBox3
			{-0.3125, -0.5, 0.125, 0.0625, -0.1875, 0.4375}, -- NodeBox4
		}
	}
})

--alias for tree backcompatablility
minetest.register_alias("default:gold_shroom_spore", "overworld:gold_mushroom_spore")


--do this for every wood, including ones registered in other mods
qtcore.for_all_materials("wood", function(fields)
	--logs to planks
	if fields.log and fields.planks then
		qts.register_craft({
			ingredients = {fields.log.." 1"},
			results = {fields.planks.." 4"},
		})
	end

	--stripped logs to planks
	if fields.log_stripped and fields.planks then
		qts.register_craft({
			ingredients = {fields.log_stripped.." 1"},
			results = {fields.planks.." 4"},
		})
	end

	--logs to stripped logs
	if fields.log and fields.log_stripped then
		qts.register_craft({
			ingredients = {fields.log},
			results = {fields.log_stripped, qts.select(fields.bark~=nil, function() return fields.bark .. " 4" end, nil)},
			near = {"group:workbench"},
	--		held = {"group:knife"},
		})
	end

	--fences
	if fields.planks and fields.fence then
		qts.register_craft({
			ingredients = {fields.planks.." 2"},
			results = {fields.fence.." 4"},
			near = {"group:workbench"},
		})
	end

	--mushroom plates
	if fields.class == "mushroom" and fields.plates and fields.leaves then
		qts.register_craft({
			ingredients = {"overworld:mycelium", fields.leaves},
			results = {fields.plates.." 2"},
		})
	end
end)
