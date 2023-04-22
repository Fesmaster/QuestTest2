--[[
    Soil nodes live here
]]

--Dirt
qts.register_shaped_node ("overworld:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_dirt(),
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:flint"},rarity = 32},
			{items = {"overworld:dirt"}}
		}
	}
})

minetest.register_node ("overworld:dirt_tilled", {
	description = "Dirt",
	drawtype = "nodebox",
	tiles = {"default_dirt_tilled.png", "default_dirt.png","default_dirt.png"},
	groups = {crumbly = 3, soil=1, farmland=1, erodeable=1, generation_artificial=1},
	sounds = qtcore.node_sound_dirt(),
	paramtype2 = "facedir",
	paramtype = 'light',
	drop = "overworld:dirt",
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



qts.register_shaped_node ("overworld:dirt_with_grass", {
	description = "Dirt with Grass",
	tiles = {"default_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:dirt"}
			}
		}
	}
})

--fix the sides of grass on the full node
minetest.override_item("overworld:dirt_with_grass", {
	tiles = {"default_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("overworld:dirt_with_swamp_grass", {
	description = "Dirt with Swamp Grass",
	tiles = {"default_swamp_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_dirt(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:dirt"}
			}
		}
	}
})
minetest.override_item("overworld:dirt_with_swamp_grass", {
	tiles = {"default_swamp_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_swamp_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("overworld:peat", {
	description = "Peat",
	tiles = {"default_peat.png"},
	groups = {crumbly = 3, soil=1},
	sounds = qtcore.node_sound_dirt(),
	drop = "overworld:peat_chunk 4"
})

qts.register_shaped_node ("overworld:dirt_swamp", {
	description = "You Shouldn't Have This",
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil=1, generation_ground=1, not_in_creative_inventory = 1},
	sounds = qtcore.node_sound_dirt(),
	drop = {
		max_items = 1,
		items = {
			{items = {"overworld:flint"},rarity = 32},
			{items = {"overworld:dirt"}}
		}
	}
})

qts.register_shaped_node ("overworld:dirt_with_prarie_grass", {
	description = "Dirt with Prarie Grass",
	tiles = {"default_prarie_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:dirt"}
			}
		}
	}
})
minetest.override_item("overworld:dirt_with_prarie_grass", {
	tiles = {"default_prarie_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_prarie_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("overworld:dirt_with_mushroom_grass", {
	description = "Dirt with Mycelium",
	tiles = {"default_mushroom_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:dirt", "overworld:mycelium"}
			}

		}
	}
})
minetest.override_item("overworld:dirt_with_mushroom_grass", {
	tiles = {"default_mushroom_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_mushroom_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("overworld:dirt_with_rainforest_grass", {
	description = "Dirt with Rainforest Grass",
	tiles = {"default_rainforest_grass.png"},
	groups = {crumbly = 3, soil=1, spreading_dirt_type=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:dirt"}
			}
		}
	}
})
minetest.override_item("overworld:dirt_with_rainforest_grass", {
	tiles = {"default_rainforest_grass.png", "default_dirt.png",
		{name = "default_dirt.png^default_rainforest_grass_side.png",
			tileable_vertical = false}},
})

qts.register_shaped_node ("overworld:dirt_with_snow", {
	description = "Dirt with Snow",
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, soil=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_grass(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:dirt"}
			}
		}
	}
})
minetest.override_item("overworld:dirt_with_snow", {
	tiles = {"default_snow.png", "default_dirt.png",
		{name = "default_dirt.png^default_snow_side.png",
			tileable_vertical = false}},
})


--Sand
qts.register_shaped_node ("overworld:sand", {
	description = "Sand",
	tiles = {"default_sand.png"},
	groups = {oddly_breakable_by_hand = 3, crumbly = 3, falling_node=1, sand=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 8,
				items = {"overworld:shell_pieces"},
			},
			{
				items = {"overworld:sand"}
			}
		}
	}
})

qts.register_shaped_node ("overworld:desert_sand", {
	description = "Desert Sand",
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node=1, sand=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 32,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:desert_sand"}
			}
		}
	}
})

--gravel
qts.register_shaped_node ("overworld:gravel", {
	description = "Gravel",
	tiles = {"default_gravel.png"},
	groups = {oddly_breakable_by_hand = 2, crumbly = 2, falling_node=1, gravel=1, erodeable=1, generation_ground=1},
	sounds = qtcore.node_sound_sand(),
	drop = {
		max_items = 1,
		items = {
			{
				rarity = 8,
				items = {"overworld:flint"},
			},
			{
				items = {"overworld:gravel"}
			}
		}
	}
})


--Others
minetest.register_node("overworld:snow", {
	description = "Snow",
	tiles ={"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	groups = {crumbly=3, snow=1, falling_node=1, cooling = 1, erodeable=1, generation_replacable=1},
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
			local i = ItemStack("overworld:snow")
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
			if (n.name == "overworld:snow" and n.param2 < 64)then
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


qts.register_shaped_node("overworld:clay", {
	description = "Clay Block",
	tiles = {"default_clay_block.png"},
	groups = {crumbly=3, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	drop = "overworld:clay_lump 4"
})