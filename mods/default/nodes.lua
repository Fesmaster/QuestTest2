

--[[
INDEX




]]



--BEGIN stone
qts.register_shaped_node("default:cement", {
	description = "Cement",
	tiles = {"default_cement.png"},
	groups = {cracky=3, explode_resistance=10},
	sounds = qtcore.node_sound_stone(),
})



--BEGIN grey
qts.register_shaped_node("default:stone", {
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:stone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:stone",{
	description = "Stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "grey_stone",
})
qts.register_shaped_node ("default:stone_cobble", {
	description = "Cobblestone",
	tiles = {"default_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, grey_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END grey

--BEGIN mossy
qts.register_shaped_node ("default:moss_stone", {
	description = "Mossy Stone",
	tiles = {"default_moss_stone.png"},
	groups = {cracky=3, stone=1, mossy_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:moss_stone",{
	description = "Mossy Stone",
	tiles = {"default_moss_stone.png"},
	groups = {cracky=3, stone=1, mossy_stone=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "mossy_stone",
})
qts.register_shaped_node ("default:moss_stone_cobble", {
	description = "Mossy Cobblestone",
	tiles = {"default_moss_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, mossy_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END mossy

--BEGIN understone
qts.register_shaped_node("default:understone", {
	description = "Understone",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, understone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:understone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:understone",{
	description = "Understone",
	tiles = {"default_understone.png"},
	groups = {cracky=3, stone=1, understone=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "understone",
})
qts.register_shaped_node ("default:understone_cobble", {
	description = "Cobble Understone",
	tiles = {"default_understone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, understone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END understone

--BEGIN red
qts.register_shaped_node ("default:red_stone", {
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1, red_stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:red_stone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:red_stone",{
	description = "Red Stone",
	tiles = {"default_red_stone.png"},
	groups = {cracky=3, stone=1, red_stone=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "red_stone",
})
qts.register_shaped_node ("default:red_stone_cobble", {
	description = "Red Cobblestone",
	tiles = {"default_red_stone.png^qt_cobble_overlay.png"},
	groups = {cracky=3, stone=1, red_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END red

--BEGIN sandstone
qts.register_shaped_node ("default:sandstone", {
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1, sand_stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:sandstone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:sandstone",{
	description = "Sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1, sand_stone=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "sand_stone",
})
qts.register_shaped_node ("default:sandstone_cobble", {
	description = "Sandstone Cobble",
	tiles = {"default_sandstone.png^qt_cobble_overlay.png"},
	groups = {cracky=3,stone=1, sand_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END sandstone

--BEGIN desert
qts.register_shaped_node ("default:desert_sandstone", {
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1, desert_stone=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:desert_sandstone_cobble",
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:desert_sandstone",{
	description = "Desert Sandstone",
	tiles = {"default_desert_sandstone.png"},
	groups = {cracky=3, stone=1, desert_stone=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "desert_stone",
})
qts.register_shaped_node ("default:desert_sandstone_cobble", {
	description = "Desert Sandstone Cobble",
	tiles = {"default_desert_sandstone.png^qt_cobble_overlay.png"},
	groups = {cracky=3,stone=1, desert_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END desert

--BEGIN obsidian
qts.register_shaped_node ("default:obsidian", {
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=1, obsidian=1},
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qtcore.register_artistic_nodes("default:obsidian",{
	description = "Obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=3, stone=1, obsidian=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "obsidian",
})
--END obsidian

--BEGIN brick
qts.register_shaped_node ("default:brick", {
	description = "Brick",
	tiles = {"default_brick.png"},
	groups = {cracky=3, bricks=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:brick_grey", {
	description = "Grey Brick",
	tiles = {"default_brick_grey.png"},
	groups = {cracky=3, bricks=1, grey_stone=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
--END brick
--END stone


--BEGIN soil
qts.register_shaped_node("default:clay", {
	description = "Clay Block",
	tiles = {"default_clay_block.png"},
	groups = {crumbly=3},
	sounds = qtcore.node_sound_stone(),
	drop = "default:clay_lump 4"
})

--BEGIN dirt
qts.register_shaped_node ("default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil=1},
	sounds = qtcore.node_sound_dirt(),
	drop = {
		max_items = 1,
		items = {
			{items = {"default:flint"},rarity = 32},
			{items = {"default:dirt"}}
		}
	}
})

minetest.register_node ("default:dirt_tilled", {
	description = "Dirt",
	drawtype = "nodebox",
	tiles = {"default_dirt_tilled.png", "default_dirt.png","default_dirt.png"},
	groups = {crumbly = 3, soil=1, farmland=1},
	sounds = qtcore.node_sound_dirt(),
	paramtype2 = "facedir",
	paramtype = 'light',
	drop = "default:dirt",
	node_box = {
        type = "fixed",
        fixed = {
			{ -8/16, -8/16, -8/16, 8/16, 7/16, 8/16, },
			{ -8/16, 7/16, -8/16, -6/16, 8/16, 8/16, },
			{ -1/16, 7/16, -8/16, 1/16, 8/16, 8/16, },
			{ 6/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
		}
    },
	collision_box = {
        type = "fixed",
        fixed = {
			{ -8/16, -8/16, -8/16, 8/16, 7/16, 8/16, },
		}
    },
	selection_box = {
        type = "fixed",
        fixed = {
			{ -8/16, -8/16, -8/16, 8/16, 7/16, 8/16, },
		}
    },
})

qts.register_shaped_node ("default:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})
--fix the sides of grass on the full node
minetest.override_item("default:dirt_with_grass", {
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_swamp_grass", {
	description = "Dirt with Swamp Grass",
	tiles = {"default_swamp_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_dirt(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})
minetest.override_item("default:dirt_with_swamp_grass", {
	tiles = {"default_swamp_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_swamp_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_prarie_grass", {
	description = "Dirt with Prarie Grass",
	tiles = {"default_prarie_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})
minetest.override_item("default:dirt_with_prarie_grass", {
	tiles = {"default_prarie_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_prarie_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_mushroom_grass", {
	description = "Dirt with Mycelium",
	tiles = {"default_mushroom_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})
minetest.override_item("default:dirt_with_mushroom_grass", {
	tiles = {"default_mushroom_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_mushroom_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_rainforest_grass", {
	description = "Dirt with Rainforest Grass",
	tiles = {"default_rainforest_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})
minetest.override_item("default:dirt_with_rainforest_grass", {
	tiles = {"default_rainforest_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_rainforest_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("default:dirt_with_snow", {
	description = "Dirt with Snow",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, soil=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:dirt"}
			}
		}
	}
})
minetest.override_item("default:dirt_with_snow", {
	tiles = {"default_snow.png", "default_dirt.png",
		{name = "default_dirt.png^default_snow_side.png",
			tileable_vertical = false}},
})
--END dirt

qts.register_shaped_node ("default:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {oddly_breakable_by_hand = 3, crumbly = 3, falling_node=1, sand=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 8,
				items = {"default:shell_pieces"},
			},
			{
				items = {"default:sand"}
			}
		}
	}
})

qts.register_shaped_node ("default:gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {oddly_breakable_by_hand = 2, crumbly = 2, falling_node=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 8,
				items = {"default:flint"},
			},
			{
				items = {"default:gravel"}
			}
		}
	}
})

qts.register_shaped_node ("default:desert_sand", {
	description = "Desert Sand",
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node=1, sand=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"default:flint"},
			},
			{
				items = {"default:desert_sand"}
			}
		}
	}
})

minetest.register_node("default:snow", {
	description = "Snow",
	tiles ={"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	groups = {crumbly=3, snow=1, falling_node=1, cooling = 1},
	drawtype = "nodebox",
	node_box = {
		type = "leveled",
		fixed = {{-1/2, -1/2, -1/2, 1/2, 1/2, 1/2}},
	},
	paramtype = "light",
	sunlight_propagates = true,
	leveled = 64,
	leveled_max = 64,
	paramtype2 = "leveled",
	sounds = qtcore.node_sound_defaults(),
	on_dig = function(pos, node, digger)
		local p2 = (minetest.get_node(pos).param2) / 8
		local l = minetest.node_dig(pos, node, digger)
		if (not l) then return false end
		if (qts.is_player_creative(digger:get_player_name()))then
			return l
		end
		p2 = p2 - 1
		if (p2 == -1)then p2 = 7 end -- param2 == 0 is full block too!
		if (p2 > 0) then
			local inv = digger:get_inventory()
			local i = ItemStack("default:snow")
			i:set_count(p2)
			i = inv:add_item("main", i)
			if (not i:is_empty()) then
				minetest.item_drop(i, digger, digger:get_pos())
			end
		end
		return true
	end,
	on_place = function(itemstack, placer, pointed_thing)
		local placed = false
		if (pointed_thing.under ~= nil) then
			local n = minetest.get_node(pointed_thing.under)
			if (n.name == "default:snow" and n.param2 < 64)then
				n.param2 = n.param2 + 8
				if (n.param2 == 8)then n.param2 = 16 end --fix for first level
				if (n.param2 % 8 == 0)then n.param2 = n.param2 - (n.param2 % 8) end --fix for odd things
				minetest.remove_node(pointed_thing.under)
				return minetest.item_place(itemstack, placer, pointed_thing, n.param2)
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing, 8)
	end,
})
--END soil


--BEGIN wood
qts.register_shaped_node ("default:oak_wood_planks", {
	description = "Oak Wood Planks",
	tiles = {"default_oak_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:oak_log", {
	description = "Oak Log",
	tiles = {"default_oak_top.png", "default_oak_top.png", "default_oak_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:rowan_wood_planks", {
	description = "Rowan Wood Planks",
	tiles = {"default_rowan_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:rowan_log", {
	description = "Rowan Log",
	tiles = {"default_rowan_top.png", "default_rowan_top.png", "default_rowan_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:apple_wood_planks", {
	description = "Apple Wood Planks",
	tiles = {"default_apple_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:apple_log", {
	description = "Apple Log",
	tiles = {"default_apple_top.png", "default_apple_top.png", "default_apple_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:aspen_wood_planks", {
	description = "Aspen Wood Planks",
	tiles = {"default_aspen_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:aspen_log", {
	description = "Aspen Log",
	tiles = {"default_aspen_top.png", "default_aspen_top.png", "default_aspen_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:lanternfruit_wood_planks", {
	description = "Lanternfruit Wood Planks",
	tiles = {{name = "default_lanternfruit_wood.png", align_style = "node"}},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:lanterfruit_log", {
	description = "Lanternfruit Log",
	tiles = {"default_lanternfruit_top.png", "default_lanternfruit_top.png", "default_lanternfruit_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:coffee_wood_planks", {
	description = "Coffee Wood Planks",
	tiles = {"default_coffee_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:coffee_log", {
	description = "Coffee Log",
	tiles = {"default_coffee_top.png", "default_coffee_top.png", "default_coffee_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:rosewood_wood_planks", {
	description = "Rosewood Planks",
	tiles = {"default_rosewood_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:rosewood_log", {
	description = "Rosewood Log",
	tiles = {"default_rosewood_top.png", "default_rosewood_top.png", "default_rosewood_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:mahogany_wood_planks", {
	description = "Mahogany Planks",
	tiles = {"default_mahogany_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})
qts.register_shaped_node ("default:mahogany_log", {
	description = "Mahogany Log",
	tiles = {"default_mahogany_top.png", "default_mahogany_top.png", "default_mahogany_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:palm_log", {
	description = "Palm Log",
	tiles = {"default_palm_top.png", "default_palm_top.png", "default_palm_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:pine_wood_planks", {
	description = "Pine Planks",
	tiles = {"default_pine_wood.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = qtcore.node_sound_wood(),
	paramtype2 = "color",
	palette = "default_palette_paint_light.png",
})

qts.register_shaped_node ("default:pine_log", {
	description = "Pine Log",
	tiles = {"default_pine_top.png", "default_pine_top.png", "default_pine_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:swamp_tree", {
	description = "Swamp Log",
	tiles = {
		"default_swamp_log_top.png",
		"default_swamp_log_top.png",
		"default_swamp_log_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, log=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.375, 0, 0.5, -0.0625}, -- NodeBox10
			{0.0625, -0.5, 0, 0.4375, 0.9375, 0.375}, -- NodeBox11
		}
	}
})
--END wood

--BEGIN shrooms
qts.register_shaped_node ("default:blue_mushroom_trunk", {
	description = "Blue Mushroom Trunk",
	tiles = {"default_mushroom_blue_top.png", "default_mushroom_blue_top.png", "default_mushroom_blue_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:blue_mushroom_cap", {
	description = "Blue Mushroom Cap",
	tiles = {"default_mushroom_blue_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_trunk", {
	description = "Golden Mushroom Trunk",
	tiles = {"default_mushroom_gold_top.png", "default_mushroom_gold_top.png", "default_mushroom_gold_side.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = qtcore.node_sound_wood(),
})

qts.register_shaped_node ("default:gold_mushroom_cap", {
	description = "Golden Mushroom Cap",
	tiles = {"default_mushroom_gold_cap.png"},
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:gold_shroom_spore", {
	description = "Golden Mushroom Spore",
	tiles = {"default_mushroom_gold_spore.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
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





--END shrooms

--BEGIN leaves
--[[
leaves use param2 to hold if they were placed by the player
to allow player-placed leaves to not decay
--]]

minetest.register_node("default:oak_leaves", {
	description = "Oak Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_oak_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:oak_sapling"}, rarity = 16},
			{items = {"default:oak_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:aspen_leaves", {
	description = "Aspen Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_aspen_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:aspen_sapling"}, rarity = 16},
			{items = {"default:aspen_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:apple_leaves", {
	description = "Apple Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:apple_sapling"}, rarity = 16},
			{items = {"default:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:apple_leaves_fruit", {
	description = "Apple Leaves with Apples",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_apple_leaves_fruit.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 2,
		items = {
			{items = {"default:apple"}},
			{items = {"default:apple_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:rowan_leaves", {
	description = "Rowan Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rowan_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:rowan_sapling"}, rarity = 16},
			{items = {"default:rowan_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:lanternfruit_leaves", {
	description = "Lanternfruit Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_lanternfruit_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:lanternfruit_sapling"}, rarity = 16},
			{items = {"default:lanternfruit_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:coffeetree_leaves", {
	description = "Coffee Tree Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_coffee_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:coffeetree_sapling"}, rarity = 16},
			{items = {"default:coffeetree_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:mahogany_leaves", {
	description = "Mahogany Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_mahogany_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:mahogany_sapling"}, rarity = 16},
			{items = {"default:mahogany_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:blackwood_leaves", {
	description = "Blackwood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_blackwood_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	--drop = {
	--	--TODO: finish leaf drops
	--},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})


minetest.register_node("default:rosewood_leaves", {
	description = "Rosewood Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_rosewood_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:rosewood_sapling"}, rarity = 16},
			{items = {"default:rosewood_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

minetest.register_node("default:palm_leaves", {
	description = "Palm Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_palm_leaves.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:palm_sapling"}, rarity = 16},
			{items = {"default:coconut"}, rarity = 16},
			{items = {"default:palm_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})




minetest.register_node("default:swamp_leaves", {
	description = "Swamp Leaves",
	tiles = {"default_swamp_leaves.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	waving = 1,
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
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

minetest.register_node("default:pine_leaves", {
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	waving = 1,
	tiles = {"default_pine_needles.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 16},
			{items = {"default:pine_leaves"}},
		}
	},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
})

--[[
minetest.register_node("default:palm_leaves", {
	description = "Palm Leaf",
	tiles = {
		"default_palm_leaves_hfaces.png",
		"default_palm_leaves_hfaces.png",
		"default_cement.png",
		"default_mahogany_top.png",
		"default_palm_leaves_rfaces.png",
		"default_palm_leaves_gfaces.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	walkable = false,
	climbable = true,
	sounds = qtcore.node_sound_grass(),
	after_place_node = qtcore.after_place_leaves;
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.3, -0.1875, 3.5, 0.0625, 0.25},
		}
	}
})
--]]
--END leaves


--BEGIN fruit
minetest.register_node("default:lantern_fruit", {
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
	groups = {snappy = 3, fruit = 1},
	sounds = qtcore.node_sound_stone(),
	light_source = 12,
})

qts.register_ingot("default:apple", {
	description = "Apple",
	inventory_image = "default_apple_fruit_item.png",
	tiles = {"default_apple_fruit_top.png", "default_apple_fruit.png", "default_apple_fruit.png"},
	groups = {cracky=3, fruit = 1},
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
--END fruit


--BEGIN crafting
minetest.register_node("default:workbench", {
	description = "Workbench",
	tiles = {
		"default_workbench_top.png",
		"default_workbench_bottom.png",
		"default_workbench_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, workbench=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.25, -0.5, 0.5, 0.4375, 0.5}, -- Top
			{-0.4375, -0.5, -0.4375, -0.25, 0.25, -0.25}, -- leg1
			{0.25, -0.5, -0.4375, 0.4375, 0.25, -0.25}, -- leg2
			{0.25, -0.5, 0.25, 0.4375, 0.25, 0.4375}, -- leg3
			{-0.4375, -0.5, 0.25, -0.25, 0.25, 0.4375}, -- leg4
			--{-0.3125, -0.25, -0.3125, 0.3125, -0.1875, 0.3125}, -- shelf
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:workbench_heavy", {
	description = "Heavy Workbench",
	tiles = {
		"default_workbench_heavy_top.png",
		"default_workbench_bottom.png",
		"default_workbench_heavy_side.png"
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, workbench=2, workbench_heavy=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.25, -0.5, 0.5, 0.4375, 0.5}, -- Top
			{-0.4375, -0.5, -0.4375, -0.25, 0.25, -0.25}, -- leg1
			{0.25, -0.5, -0.4375, 0.4375, 0.25, -0.25}, -- leg2
			{0.25, -0.5, 0.25, 0.4375, 0.25, 0.4375}, -- leg3
			{-0.4375, -0.5, 0.25, -0.25, 0.25, 0.4375}, -- leg4
			--{-0.3125, -0.25, -0.3125, 0.3125, -0.1875, 0.3125}, -- shelf
		}
	},
	sounds = qtcore.node_sound_wood(),
})

minetest.register_node("default:anvil", {
	description = "Steel Block",
	tiles = {"default_anvil.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.0625, -0.3125, 0.5, 0.375, 0.3125}, -- Head
			{-0.375, -0.5, -0.3125, 0.375, -0.3125, 0.3125}, -- Base
			{-0.3125, -0.3125, -0.25, 0.3125, -0.25, 0.25}, -- Base2
			{-0.1875, -0.375, -0.125, 0.1875, 0.125, 0.125}, -- Stem
			{-0.375, 0, -0.1875, 0.375, 0.0625, 0.1875}, -- Head2
		}
	},
	groups = {cracky=2, falling_node=1, anvil=1},
	sounds = qtcore.node_sound_metal(),
})
--END crafting

--BEGIN glass
minetest.register_node ("default:glass", {
	description = "Glass",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	use_texture_alpha = "clip",
	groups = {cracky=3, glass=1, oddly_breakable_by_hand=3},
	drawtype = "glasslike_framed_optional",
	is_ground_content = false,
	sounds = qtcore.node_sound_metal(),
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
})

qts.register_fencelike_node("default:glass_pane", {
	description = "Glass Pane",
	type = "pane",
	tiles = {"default_glass_pane_top.png","default_glass.png","default_glass_pane.png"},
	use_texture_alpha = "clip",
	groups = {cracky=3, glass=1, oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("default:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	use_texture_alpha = "blend",
	drawtype = "glasslike",
	paramtype = "light",
	groups = {cracky=3, ice=1, cooling=1, slippery=4},
	sounds = qtcore.node_sound_metal(),
})
--END glass

--BEGIN furnature
minetest.register_node("default:table", {
	description = "Table",
	tiles = {"default_oak_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2},
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

minetest.register_node("default:ladder", {
	description = "Ladder",
	tiles ={"default_oak_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = true,
	climbable = true,
	groups = {oddly_breakable_by_hand=3, choppy=2, flammable=2},
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
			minetest.item_place(itemstack, placer, pointed_thing, minetest.get_node(pointed_thing.under).param2)
		else
			minetest.item_place(itemstack, placer, pointed_thing)
		end
	end,
})
--END furnature
