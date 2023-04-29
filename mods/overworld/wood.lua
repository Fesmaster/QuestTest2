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
		tiles = {"default_"..wood.name.."_wood.png"},
		paramtype2 = "colorfacedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1, },
		sounds = qtcore.node_sound_wood(),
		palette = "default_palette_paint_light.png",
	})

	--log
	qts.register_shaped_node ("overworld:"..wood.name.."_log", {
		description = wood.desc.." Log",
		tiles = {
			"default_"..wood.name.."_top.png", 
			"default_"..wood.name.."_top.png", 
			"default_"..wood.name.."_side.png"
		},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1, },
		sounds = qtcore.node_sound_wood(),
	})
	
	--stripped logs
	qts.register_shaped_node("overworld:stripped_"..wood.name.."_log", {
		description = "Stripped "..wood.desc.." Log",
		tiles = {
			"default_stripped_"..wood.name.."_top.png",
			"default_stripped_"..wood.name.."_top.png",
			"default_stripped_"..wood.name.."_side.png",
		},
		paramtype2 = "colorfacedir",
		groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable=2, log = 1, generation_artificial=1, },
		sounds = qtcore.node_sound_wood(),
		palette = "default_palette_paint_light.png",
	})

	--bark
	minetest.register_craftitem("overworld:bark_"..wood.name, {
		description = wood.desc.." Bark",
		inventory_image = "default_bark_"..wood.name..".png",
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
		tiles = {"default_"..wood.name.."_leaves.png"},
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
		tiles ={"default_"..wood.name.."_leaves.png", "default_"..wood.name.."_leaves.png", 
			"default_"..wood.name.."_leaves.png^[lowpart:37:default_"..wood.name.."_side.png"},
		use_texture_alpha = "clip",
		groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
		sounds = qtcore.node_sound_stone(),
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
		tiles = {"default_"..wood.name.."_wood.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..wood.name.."_wood_rail",
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	
	--rail
	qts.register_fencelike_node("overworld:"..wood.name.."_wood_rail", {
		description = wood.desc.." Wood Rail",
		type = "rail",
		tiles = {"default_"..wood.name.."_wood.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..wood.name.."_wood_fence", 
		drop = "overworld:"..wood.name.."_wood_fence",
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
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

		plank_texture = "default_"..wood.name.."_wood.png",
	})

end

--lanternfruit early misspelling fix for tree backcompatablility
qts.register_shapeed_alias("default:lanterfruit_log", "overworld:lanternfruit_log")

--lanternfruit fruit
minetest.register_node("overworld:lantern_fruit", {
	description = "Lantern Fruit",
	tiles ={
		"default_lantern_fruit_top.png", 
		"default_lantern_fruit_bottom.png",
		"default_lantern_fruit_side.png"
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

--fruit-bearing apple leaves:
minetest.register_node("overworld:apple_leaves_fruit", {
	description = "Apple Leaves with Apples",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves_fruit.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 2,
		items = {
			{items = {"default:apple"}},
			{items = {"overworld:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})
--worldgen alias
minetest.register_alias("default:apple_leaves_fruit", 			"overworld:apple_leaves_fruit")

--palm, swamp, and bamboo are a bit special.

--palm: has no planks or stripped version. Plam is a completely useless wood
qts.register_shaped_node ("overworld:palm_log", {
	description = "Palm Log",
	tiles = {"default_palm_top.png", "default_palm_top.png", "default_palm_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("overworld:palm_leaves", {
	description = "Palm Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_palm_leaves.png"},
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

qts.register_growable_node("overworld:palm_sapling", {
	description = "Palm Sapling",
	tiles ={"default_palm_leaves.png", "default_palm_leaves.png", 
		"default_palm_leaves.png^[lowpart:37:default_palm_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","A Palm tree has grown at "..minetest.pos_to_string(pos))
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
	tiles = {{name = "default_swamp_wood.png", align_style = "node"}},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})

minetest.register_node("overworld:swamp_log", {
	description = "Swamp Log",
	tiles = {
		"default_swamp_log_top.png",
		"default_swamp_log_top.png",
		"default_swamp_log_side.png"
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

minetest.register_node("overworld:stripped_swamp_log", {
	description = "Stripped Swamp Log",
	tiles = {
		"default_swamp_log_top.png",
		"default_swamp_log_top.png",
		"default_stripped_swamp_side.png"
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
	tiles = {"default_swamp_leaves.png"},
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

qtcore.register_material("wood", {
	name="swamp",
	desc = "Swamp",
	planks="overworld:swamp_wood_planks",
	log="overworld:swamp_log",
	log_stripped="overworld:stripped_swamp_log",
	leaves="overworld:swamp_leaves",
	plank_texture = "default_swamp_wood.png",
--	sapling="overworld:palm_sapling",
})

--bamboo has a nodebox for trunk and leaves, and also no stripped version
qts.register_shaped_node ("overworld:bamboo_planks", {
	description = "Bamboo Slats",
	tiles = {"default_bamboo_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("overworld:bamboo", {
	description = "Bamboo",
	tiles = {
		"default_bamboo_log_top.png",
		"default_bamboo_log_top.png",
		"default_bamboo_log_side.png"
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

minetest.register_node("overworld:bamboo_leaves", {
	description = "Bamboo Leaves",
	tiles = {
			"default_bamboo_leaves_top.png", "default_bamboo_leaves_side.png",
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

qts.register_fencelike_node("overworld:bamboo_fence", {
	description = "Bamboo Fence",
	type = "fence",
	tiles = {"default_bamboo_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "overworld:bamboo_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("overworld:bamboo_rail", {
	description = "Bamboo Rail",
	type = "rail",
	tiles = {"default_bamboo_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "overworld:bamboo_fence", 
	drop = "overworld:bamboo_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qtcore.register_material("wood", {
	name="bamboo",
	desc="Bamboo",
	planks="overworld:bamboo_planks",
	log="overworld:bamboo",
	leaves="overworld:bamboo_leaves",
	fence="overworld:bamboo_fence",
	rail="overworld:bamboo_rail",
	plank_texture = "default_bamboo_slats.png",
})

--Mushrooms
local mushroom_names = {"blue", "gold", "brown"}
local mushroom_descs = {"Blue", "Gold", "Brown"}
for i, name in ipairs(mushroom_names) do
	local desc = mushroom_descs[i]

	--trunk
	qts.register_shaped_node ("overworld:"..name.."_mushroom_trunk", {
		description = desc.." Mushroom Trunk",
		tiles = {"default_mushroom_"..name.."_top.png", "default_mushroom_"..name.."_top.png", "default_mushroom_"..name.."_side.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
		sounds = qtcore.node_sound_wood(),
	})

	--cap (leaves)
	qts.register_shaped_node ("overworld:"..name.."_mushroom_cap", {
		description = desc.." Mushroom Cap",
		tiles = {"default_mushroom_"..name.."_cap.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
		sounds = qtcore.node_sound_wood(),
	})
	
	--slats (planks)
	qts.register_shaped_node ("overworld:"..name.."_mushroom_slats", {
		description = desc.." Mushroom Slats",
		tiles = {"default_mushroom_"..name.."_slats.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
	})
	
	--tiles
	qts.register_shaped_node ("overworld:"..name.."_mushroom_plates", {
		description = desc.." Mushroom Plates",
		tiles = {"default_mushroom_"..name.."_plates.png"},
		paramtype2 = "facedir",
		groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
	})

	--fence
	qts.register_fencelike_node("overworld:"..name.."_mushroom_fence", {
		description = desc.." Mushroom Fence",
		type = "fence",
		tiles = {"default_mushroom_"..name.."_slats.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..name.."_wood_rail",
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	
	--rail
	qts.register_fencelike_node("overworld:"..name.."_mushroom_rail", {
		description = desc.." Wood Rail",
		type = "rail",
		tiles = {"default_mushroom_"..name.."_slats.png"},
		groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
		sounds = qtcore.node_sound_wood(),
		fence_alt = "overworld:"..name.."_mushroom_fence", 
		drop = "overworld:"..name.."_mushroom_fence",
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
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
		plank_texture = "default_mushroom_"..name.."_slats.png"
	})
end

minetest.register_node("overworld:gold_mushroom_spore", {
	description = "Golden Mushroom Spore",
	tiles = {"default_mushroom_gold_spore.png"},
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
			ingredients = {"default:mycelium", fields.leaves},
			results = {fields.plates.." 2"},
		})
	end
end)

--Old individual registrations
--[[
qts.register_shaped_node ("overworld:oak_wood_planks", {
	description = "Oak Wood Planks",
	tiles = {"default_oak_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:oak_log", {
	description = "Oak Log",
	tiles = {"default_oak_top.png", "default_oak_top.png", "default_oak_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:rowan_wood_planks", {
	description = "Rowan Wood Planks",
	tiles = {"default_rowan_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:rowan_log", {
	description = "Rowan Log",
	tiles = {"default_rowan_top.png", "default_rowan_top.png", "default_rowan_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:apple_wood_planks", {
	description = "Apple Wood Planks",
	tiles = {"default_apple_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:apple_log", {
	description = "Apple Log",
	tiles = {"default_apple_top.png", "default_apple_top.png", "default_apple_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:aspen_wood_planks", {
	description = "Aspen Wood Planks",
	tiles = {"default_aspen_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:aspen_log", {
	description = "Aspen Log",
	tiles = {"default_aspen_top.png", "default_aspen_top.png", "default_aspen_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:lanternfruit_wood_planks", {
	description = "Lanternfruit Wood Planks",
	tiles = {{name = "default_lanternfruit_wood.png", align_style = "node"}},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:lanternfruit_log", {
	description = "Lanternfruit Log",
	tiles = {"default_lanternfruit_top.png", "default_lanternfruit_top.png", "default_lanternfruit_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})
--for shematic legacy reasons
minetest.register_alias("overworld:lanterfruit_log", "overworld:lanternfruit_log")
minetest.register_alias("overworld:lanterfruit_log_stair", "overworld:lanternfruit_log_stair")
minetest.register_alias("overworld:lanterfruit_log_stair_inner", "overworld:lanternfruit_log_stair_inner")
minetest.register_alias("overworld:lanterfruit_log_stair_outer", "overworld:lanternfruit_log_stair_outer")
minetest.register_alias("overworld:lanterfruit_log_slant", "overworld:lanternfruit_log_slant")
minetest.register_alias("overworld:lanterfruit_log_slant_inner", "overworld:lanternfruit_log_slant_inner")
minetest.register_alias("overworld:lanterfruit_log_slant_outer", "overworld:lanternfruit_log_slant_oute")
minetest.register_alias("overworld:lanterfruit_log_slab", "overworld:lanternfruit_log_slab")

qts.register_shaped_node ("overworld:coffee_wood_planks", {
	description = "Coffee Wood Planks",
	tiles = {"default_coffee_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:coffee_log", {
	description = "Coffee Log",
	tiles = {"default_coffee_top.png", "default_coffee_top.png", "default_coffee_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:rosewood_wood_planks", {
	description = "Rosewood Planks",
	tiles = {"default_rosewood_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:rosewood_log", {
	description = "Rosewood Log",
	tiles = {"default_rosewood_top.png", "default_rosewood_top.png", "default_rosewood_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:mahogany_wood_planks", {
	description = "Mahogany Planks",
	tiles = {"default_mahogany_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("overworld:mahogany_log", {
	description = "Mahogany Log",
	tiles = {"default_mahogany_top.png", "default_mahogany_top.png", "default_mahogany_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:pine_wood_planks", {
	description = "Pine Planks",
	tiles = {"default_pine_wood.png"},
	paramtype2 = "colorfacedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("overworld:pine_log", {
	description = "Pine Log",
	tiles = {"default_pine_top.png", "default_pine_top.png", "default_pine_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})
]]

--[[
minetest.register_node("overworld:oak_leaves", {
	description = "Oak Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_oak_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:oak_sapling"}, rarity = 16},
			{items = {"overworld:oak_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:aspen_leaves", {
	description = "Aspen Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_aspen_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:aspen_sapling"}, rarity = 16},
			{items = {"overworld:aspen_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:apple_leaves", {
	description = "Apple Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:apple_sapling"}, rarity = 16},
			{items = {"overworld:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:apple_leaves_fruit", {
	description = "Apple Leaves with Apples",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves_fruit.png"},
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

minetest.register_node("overworld:rowan_leaves", {
	description = "Rowan Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rowan_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:rowan_sapling"}, rarity = 16},
			{items = {"overworld:rowan_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:lanternfruit_leaves", {
	description = "Lanternfruit Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_lanternfruit_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:lanternfruit_sapling"}, rarity = 16},
			{items = {"overworld:lanternfruit_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:coffeetree_leaves", {
	description = "Coffee Tree Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_coffee_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:coffee_beans 2"}, rarity = 8},
			{items = {"overworld:coffeetree_sapling"}, rarity = 16},
			{items = {"overworld:coffeetree_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:mahogany_leaves", {
	description = "Mahogany Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_mahogany_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:mahogany_sapling"}, rarity = 16},
			{items = {"overworld:mahogany_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:rosewood_leaves", {
	description = "Rosewood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rosewood_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:rosewood_sapling"}, rarity = 16},
			{items = {"overworld:rosewood_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("overworld:pine_leaves", {
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_pine_needles.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, generation_trees=1},
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:pine_sapling"}, rarity = 16},
			{items = {"overworld:pine_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})
]]

--[[
qts.register_shaped_node ("overworld:blue_mushroom_trunk", {
	description = "Blue Mushroom Trunk",
	tiles = {"default_mushroom_blue_top.png", "default_mushroom_blue_top.png", "default_mushroom_blue_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:blue_mushroom_cap", {
	description = "Blue Mushroom Cap",
	tiles = {"default_mushroom_blue_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:blue_mushroom_slats", {
	description = "Blue Mushroom Slats",
	tiles = {"default_mushroom_blue_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:blue_mushroom_plates", {
	description = "Blue Mushroom Plates",
	tiles = {"default_mushroom_blue_plates.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:gold_mushroom_trunk", {
	description = "Golden Mushroom Trunk",
	tiles = {"default_mushroom_gold_top.png", "default_mushroom_gold_top.png", "default_mushroom_gold_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:gold_mushroom_cap", {
	description = "Golden Mushroom Cap",
	tiles = {"default_mushroom_gold_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:gold_mushroom_slats", {
	description = "Gold Mushroom Slats",
	tiles = {"default_mushroom_gold_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:gold_mushroom_plates", {
	description = "Gold Mushroom Plates",
	tiles = {"default_mushroom_gold_plates.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})


minetest.register_alias("overworld:gold_shroom_spore", "overworld:gold_mushroom_spore")

qts.register_shaped_node ("overworld:brown_mushroom_trunk", {
	description = "Brown Mushroom Trunk",
	tiles = {"default_mushroom_brown_top.png", "default_mushroom_brown_top.png", "default_mushroom_brown_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})


qts.register_shaped_node ("overworld:brown_mushroom_cap", {
	description = "Brown Mushroom Cap",
	tiles = {"default_mushroom_brown_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_trees=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:brown_mushroom_slats", {
	description = "Brown Mushroom Slats",
	tiles = {"default_mushroom_brown_slats.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("overworld:brown_mushroom_plates", {
	description = "Brown Mushroom Plates",
	tiles = {"default_mushroom_brown_plates.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, mushroom=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})
]]

--[[
Fences

qts.register_fencelike_node("default:oak_wood_fence", {
	description = "Oak Wood Fence",
	type = "fence",
	tiles = {"default_oak_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:oak_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:oak_wood_rail", {
	description = "Oak Wood Rail",
	type = "rail",
	tiles = {"default_oak_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:oak_wood_fence", 
	drop = "default:oak_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rowan_wood_fence", {
	description = "Rowan Wood Fence",
	type = "fence",
	tiles = {"default_rowan_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rowan_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rowan_wood_rail", {
	description = "Rowan Wood Rail",
	type = "rail",
	tiles = {"default_rowan_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rowan_wood_fence", 
	drop = "default:rowan_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:apple_wood_fence", {
	description = "Apple Wood Fence",
	type = "fence",
	tiles = {"default_apple_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:apple_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:apple_wood_rail", {
	description = "Apple Wood Rail",
	type = "rail",
	tiles = {"default_apple_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:apple_wood_fence", 
	drop = "default:apple_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:aspen_wood_fence", {
	description = "Aspen Wood Fence",
	type = "fence",
	tiles = {"default_aspen_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:aspen_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:aspen_wood_rail", {
	description = "Aspen Wood Rail",
	type = "rail",
	tiles = {"default_aspen_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:aspen_wood_fence",
	drop = "default:aspen_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:lanternfruit_wood_fence", {
	description = "Lanternfruit Wood Fence",
	type = "fence",
	tiles = {"default_lanternfruit_wood_fence.png"}, 
	no_tile_transform=true,
		--this flags the fence texture for no transform.
		--this transform normally rotates a section so the fence column has correctly-alligned
		--grain. This texture does that manually.
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:lanternfruit_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:lanternfruit_wood_rail", {
	description = "Lanternfruit Wood Rail",
	type = "rail",
	tiles = {"default_lanternfruit_wood_rail.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:lanternfruit_wood_fence", 
	drop = "default:lanternfruit_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:coffee_wood_fence", {
	description = "Coffee Wood Fence",
	type = "fence",
	tiles = {"default_coffee_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:coffee_wood_rail",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:coffee_wood_rail", {
	description = "Coffee Wood Rail",
	type = "rail",
	tiles = {"default_coffee_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:coffee_wood_fence", 
	drop = "default:coffee_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rosewood_wood_fence", {
	description = "Rosewood Wood Fence",
	type = "fence",
	tiles = {"default_rosewood_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rosewood_wood_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:rosewood_wood_rail", {
	description = "Rosewood Wood Rail",
	type = "rail",
	tiles = {"default_rosewood_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:rosewood_wood_fence", 
	drop = "default:rosewood_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:mahogany_wood_fence", {
	description = "Mahogany Wood Fence",
	type = "fence",
	tiles = {"default_mahogany_wood_fence.png"},
	no_tile_transform=true,
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:mahogany_wood_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:mahogany_wood_rail", {
	description = "Mahogany Wood Rail",
	type = "rail",
	tiles = {"default_mahogany_wood_rail.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:mahogany_wood_fence", 
	drop = "default:mahogany_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:pine_wood_fence", {
	description = "Pine Wood Fence",
	type = "fence",
	tiles = {"default_pine_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:pine_wood_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:pine_wood_rail", {
	description = "Pine Wood Rail",
	type = "rail",
	tiles = {"default_pine_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:pine_wood_fence", 
	drop = "default:pine_wood_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:blue_mushroom_fence", {
	description = "Blue Mushroom Fence",
	type = "fence",
	tiles = {"default_mushroom_blue_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:blue_mushroom_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:blue_mushroom_rail", {
	description = "Blue Mushroom Rail",
	type = "rail",
	tiles = {"default_mushroom_blue_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:blue_mushroom_fence", 
	drop = "default:blue_mushroom_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:brown_mushroom_fence", {
	description = "Brown Mushroom Fence",
	type = "fence",
	tiles = {"default_mushroom_brown_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:brown_mushroom_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:brown_mushroom_rail", {
	description = "Brown Mushroom Rail",
	type = "rail",
	tiles = {"default_mushroom_brown_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:brown_mushroom_fence", 
	drop = "default:brown_mushroom_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:gold_mushroom_fence", {
	description = "Gold Mushroom Fence",
	type = "fence",
	tiles = {"default_mushroom_gold_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:gold_mushroom_rail", 
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_fencelike_node("default:gold_mushroom_rail", {
	description = "Gold Mushroom Rail",
	type = "rail",
	tiles = {"default_mushroom_gold_slats.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, fence=1, not_in_creative_inventory=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
	fence_alt = "default:gold_mushroom_fence", 
	drop = "default:gold_mushroom_fence",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
]]

--[[
--bark crafting (temp)
local woodtypes={"oak", "apple", "aspen", "coffee", "mahogany", "rosewood", "pine", "lanternfruit", "rowan"}
local woodnames={"Oak", "Apple", "Aspen", "Coffee", "Mahogany", "Rosewood", "Pine", "Lanternfruit", "Rowan"}

for i, wood in ipairs(woodtypes) do
	qts.register_craft({
		ingredients = {"default:"..wood.."_log"},
		results = {"default:stripped_"..wood.."_log", "default:bark_"..wood.. " 4"},
		near = {"group:workbench"},
--		held = {"group:knife"},
	})
end
]]

--[[
qts.register_craft({
	ingredients = {"default:bamboo"},
	results = {"default:bamboo_slats 2"},
})

qts.register_craft({
		ingredients = {"default:bamboo_slats 2"},
		results = {"default:bamboo_fence 4"},
		near = {"group:workbench"},
	})

--mushroom derivatives
qts.register_craft({
	ingredients = {"default:mycelium", "default:blue_mushroom_cap"},
	results = {"default:blue_mushroom_plates 2"},
})

qts.register_craft({
	ingredients = {"default:blue_mushroom_trunk"},
	results = {"default:blue_mushroom_slats 4"},
})

qts.register_craft({
		ingredients = {"default:blue_mushroom_slats 2"},
		results = {"default:blue_mushroom_fence 4"},
		near = {"group:workbench"},
	})

qts.register_craft({
	ingredients = {"default:mycelium", "default:gold_mushroom_cap"},
	results = {"default:gold_mushroom_plates 2"},
})

qts.register_craft({
	ingredients = {"default:gold_mushroom_trunk"},
	results = {"default:gold_mushroom_slats 4"},
})

qts.register_craft({
		ingredients = {"default:gold_mushroom_slats 2"},
		results = {"default:gold_mushroom_fence 4"},
		near = {"group:workbench"},
	})

qts.register_craft({
	ingredients = {"default:mycelium", "default:brown_mushroom_cap"},
	results = {"default:brown_mushroom_plates 2"},
})

qts.register_craft({
	ingredients = {"default:brown_mushroom_trunk"},
	results = {"default:brown_mushroom_slats 4"},
})

qts.register_craft({
		ingredients = {"default:brow_mushroom_slats 2"},
		results = {"default:brown_mushroom_fence 4"},
		near = {"group:workbench"},
	})
]]
--[[
	--planks
	qts.register_craft({
		ingredients = {"default:"..n.."_log 1"},
		results = {"default:"..n.."_wood_planks 4"},
	})
	
	qts.register_craft({
		ingredients = {"default:stripped_"..n.."_log 1"},
		results = {"default:"..n.."_wood_planks 4"},
	})
	--fences
	qts.register_craft({
		ingredients = {"default:"..n.."_wood_planks 2"},
		results = {"default:"..n.."_wood_fence 4"},
		near = {"group:workbench"},
	})
	]]

	--[[
local TREE_TIME = 390
local TREE_VAR = 30

qts.register_growable_node("default:oak_sapling", {
	description = "Oak Sapling",
	tiles ={"default_oak_leaves.png", "default_oak_leaves.png", 
		"default_oak_leaves.png^[lowpart:37:default_oak_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Oak tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_oak_tree(pos)
	end,
})

qts.register_growable_node("default:aspen_sapling", {
	description = "Aspen Sapling",
	tiles ={"default_aspen_leaves.png", "default_aspen_leaves.png", 
		"default_aspen_leaves.png^[lowpart:37:default_aspen_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Aspen tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_aspen_tree(pos)
	end,
})

qts.register_growable_node("default:apple_sapling", {
	description = "Apple Sapling",
	tiles ={"default_apple_leaves.png", "default_apple_leaves.png", 
		"default_apple_leaves.png^[lowpart:37:default_apple_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Apple tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_apple_tree(pos)
	end,
})



qts.register_growable_node("default:rowan_sapling", {
	description = "Rowan Sapling",
	tiles ={"default_rowan_leaves.png", "default_rowan_leaves.png", 
		"default_rowan_leaves.png^[lowpart:37:default_rowan_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Rowan tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_rowan_tree(pos)
	end,
})

qts.register_growable_node("default:lanternfruit_sapling", {
	description = "Lanternfruit Sapling",
	tiles ={"default_lanternfruit_leaves.png", "default_lanternfruit_leaves.png", 
		"default_lanternfruit_leaves.png^[lowpart:37:default_lanternfruit_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Lanternfruit tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_lantern_tree(pos)
	end,
})

qts.register_growable_node("default:coffeetree_sapling", {
	description = "Coffeetree Sapling",
	tiles ={"default_coffee_leaves.png", "default_coffee_leaves.png", 
		"default_coffee_leaves.png^[lowpart:37:default_coffee_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Coffeetree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_coffee_tree(pos)
	end,
})

qts.register_growable_node("default:mahogany_sapling", {
	description = "Mahogany Sapling",
	tiles ={"default_mahogany_leaves.png", "default_mahogany_leaves.png", 
		"default_mahogany_leaves.png^[lowpart:37:default_mahogany_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Mahogany tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_mahogany_tree(pos)
	end,
})



qts.register_growable_node("default:rosewood_sapling", {
	description = "Rosewood Sapling",
	tiles ={"default_rosewood_leaves.png", "default_rosewood_leaves.png", 
		"default_rosewood_leaves.png^[lowpart:37:default_rosewood_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","A Rosewood tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_rosewood_tree(pos)
	end,
})

qts.register_growable_node("default:palm_sapling", {
	description = "Palm Sapling",
	tiles ={"default_palm_leaves.png", "default_palm_leaves.png", 
		"default_palm_leaves.png^[lowpart:37:default_palm_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","A Palm tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_palm_tree(pos)
	end,
})

qts.register_growable_node("default:pine_sapling", {
	description = "Pine Sapling",
	tiles ={"default_pine_needles.png", "default_pine_needles.png", 
		"default_pine_needles.png^[lowpart:37:default_pine_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1, generation_replacable=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","A pine tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_pine_tree(pos)
	end,
})
]]