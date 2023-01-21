
--wood permutations
local names = {"swamp", "rosewood", "pine", "oak", "mahogany", "lanternfruit", "coffee", "aspen", "apple", "rowan"}
for i, n in ipairs(names) do
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
	--crates
	qts.register_craft({
		ingredients = {"default:"..n.."_wood_planks 4"},
		results = {"default:crate_"..n},
		near = {"group:workbench"},
	})
	--bookshelf
	qts.register_craft({
		ingredients = {"default:"..n.."_wood_planks 3", "default:book 3"},
		results = {"default:bookshelf_"..n},
		near = {"group:workbench"},
	})
end

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

--knife recipies


qts.register_craft({
	ingredients = {"group:wood"},
	results = {"default:tinder 4"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:wood"},
	results = {"default:stick 16"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:leaves"},
	results = {"default:tinder"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:underbrush"},
	results = {"default:tinder"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:tinder", "default:flint"},
	results = {"default:tinderbox"},
	near = {"group:workbench"},
})



--various other
qts.register_craft({
	ingredients = {"group:wood 5"},
	results = {"default:campfire"},
})

qts.register_craft({
	ingredients = {"default:brick_item 4"},
	results = {"default:brick"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:lime", "group:sand 4"},
	results = {"default:cement 4"},
})

qts.register_craft({
	ingredients = {"default:clay_lump 4"},
	results = {"default:clay"},
})

qts.register_craft({
	ingredients = {"default:clay"},
	results = {"default:clay_lump 4"},
})

qts.register_craft({
	ingredients = {"default:herb_milfoil 2"},
	results = {"default:poltice_milfoil"},
})



qts.register_craft({
	ingredients = {"default:herb_flax 6"},
	results = {"default:textile_flax"},
})



qts.register_craft({
	ingredients = {"group:wood", "group:coal"},
	results = {"default:torch 4",},
})

qts.register_craft({
	ingredients = {"default:reeds 2"},
	results = {"default:paper"},
})

qts.register_craft({
	ingredients = {"default:paper 2"},
	results = {"default:book"},
})

qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"default:workbench",},
})

qts.register_craft({
	ingredients = {"group:wood 4", "default:underbrush_item 4"},
	results = {"default:sifter"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:workbench", "default:iron_bar 4"},
	results = {"default:workbench_heavy",},
})

--weapons and tools

--knives
qts.register_craft({
	ingredients = {"default:flint", "group:wood"},
	results = {"default:knife_flint"},
})

qts.register_craft({
	ingredients = {"default:copper_bar", "group:wood"},
	results = {"default:knife_copper"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:bronze_bar", "group:wood"},
	results = {"default:knife_bronze"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:iron_bar", "group:wood"},
	results = {"default:knife_iron"},
	near = {"group:anvil", "group:furnace"},
})

qts.register_craft({
	ingredients = {"default:steel_bar", "group:wood"},
	results = {"default:knife_steel"},
	near = {"group:anvil", "group:furnace"},
})

--picks
qts.register_craft({
	ingredients = {"group:wood", "default:copper_bar 3"},
	results = {"default:pick_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:bronze_bar 3"},
	results = {"default:pick_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:iron_bar 3"},
	results = {"default:pick_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:steel_bar 3"},
	results = {"default:pick_steel"},
	near = {"group:anvil", "group:furnace"},
})
--axes
qts.register_craft({
	ingredients = {"group:wood", "default:flint 3"},
	results = {"default:axe_flint"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:copper_bar 3"},
	results = {"default:axe_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:bronze_bar 3"},
	results = {"default:axe_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:iron_bar 3"},
	results = {"default:axe_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:steel_bar 3"},
	results = {"default:axe_steel"},
	near = {"group:anvil", "group:furnace"},
})

--shovels
qts.register_craft({
	ingredients = {"group:wood", "default:copper_bar 3"},
	results = {"default:shovel_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:bronze_bar 3"},
	results = {"default:shovel_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:iron_bar 3"},
	results = {"default:shovel_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:steel_bar 3"},
	results = {"default:shovel_steel"},
	near = {"group:anvil", "group:furnace"},
})

--swords
qts.register_craft({
	ingredients = {"group:wood", "default:copper_bar 3"},
	results = {"default:sword_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:bronze_bar 3"},
	results = {"default:sword_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:iron_bar 3"},
	results = {"default:sword_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:steel_bar 3"},
	results = {"default:sword_steel"},
	near = {"group:anvil", "group:furnace"},
})

--hoes
qts.register_craft({
	ingredients = {"group:wood", "default:copper_bar 3"},
	results = {"default:hoe_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:bronze_bar 3"},
	results = {"default:hoe_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:iron_bar 3"},
	results = {"default:hoe_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:steel_bar 3"},
	results = {"default:hoe_steel"},
	near = {"group:anvil", "group:furnace"},
})
--hammers
qts.register_craft({
	ingredients = {"group:wood", "group:stone 5"},
	results = {"default:hammer_stone"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:steel_bar 5"},
	results = {"default:hammer_steel"},
	near = {"group:anvil", "group:furnace"},
})


--bucket
qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"default:bucket"},
	near = {"group:workbench"},
})

--bows

qts.register_craft({
	ingredients = {"group:wood", "default:flint 16", "group:bark 16"},
	results = {"default:arrow 16"},
	held = {"group:knife"},
})

qts.register_craft({
	ingredients = {"group:wood", "default:herb_flax"},
	results = {"default:bow"},
	near = {"group:workbench"},
})



--craftitems

qts.register_craft({
	ingredients = {"default:brick"},
	results = {"default:furnace_brick"},
	near = {"group:workbench_heavy"},
})

qts.register_craft({
	ingredients = {"default:brick_gray"},
	results = {"default:furnace_brick_gray"},
	near = {"group:workbench_heavy"},
})

--stone and stone walls (and bricks)
--gray stone
qts.register_craft({
	ingredients = {"group:gray_stone"},
	results = {"default:stone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:gray_stone"},
	results = {"default:stone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:gray_stone"},
	results = {"default:brick_gray"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:gray_stone"},
	results = {"default:stone_cobble_wall"},
	near = {"group:workbench_heavy"},
})
--moss stone
qts.register_craft({
	ingredients = {"group:mossy_stone"},
	results = {"default:moss_stone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:mossy_stone"},
	results = {"default:moss_stone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:mossy_stone"},
	results = {"default:moss_stone_cobble_wall"},
	near = {"group:workbench_heavy"},
})
--understone
qts.register_craft({
	ingredients = {"group:understone"},
	results = {"default:understone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:understone"},
	results = {"default:understone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:understone"},
	results = {"default:understone_cobble_wall"},
	near = {"group:workbench_heavy"},
})
--red stone
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_cobble_wall"},
	near = {"group:workbench_heavy"},
})
--sandstone
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_cobble_wall"},
	near = {"group:workbench_heavy"},
})
--desert sandstone
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_cobble_wall"},
	near = {"group:workbench_heavy"},
})
--obsidian
qts.register_craft({
	ingredients = {"group:obsidian"},
	results = {"default:obsidian"},
	near = {"group:workbench_heavy"},
})

--brick
qts.register_craft({
	ingredients = {"group:brick"},
	results = {"default:brick"},
	near = {"group:workbench_heavy"},
})

qts.register_craft({
	ingredients = {"default:brick"},
	results = {"default:brick_wall"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"default:brick_gray"},
	results = {"default:brick_gray_wall"},
	near = {"group:workbench_heavy"},
})


--toolrepair
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})


--smelting

minetest.register_craft({
	type = "cooking",
	output = "default:charcoal 4",
	recipe = "group:log",
})

minetest.register_craft({
	type = "cooking",
	output = "default:charcoal", "default:potash",
	recipe = "group:wood",
})

minetest.register_craft({
	type = "cooking",
	output = "default:lime", "default:potash",
	recipe = "default:shell_pieces",
})

minetest.register_craft({
	type = "cooking",
	output = "default:lime 16", "default:potash",
	recipe = "default:marble",
})

minetest.register_craft({
	type = "cooking",
	output = "default:brick_item", "default:potash",
	recipe = "default:clay_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "default:potash",
	recipe = "group:leaves",
})

minetest.register_craft({
	type = "cooking",
	output = "default:potash",
	recipe = "group:underbrush",
})
--fuel
minetest.register_craft({
	type = "fuel",
	recipe = "group:log",
	burntime = 32,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:mushroom",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bamboo",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "default:bamboo_slats",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:coal",
	burntime = 128,
})

--Other Crafting

--DYES
qts.register_craft({
	ingredients = {"default:charcoal 2", "default:bucket_default_water"},
	results = {"default:dye_black", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:charcoal 2", "default:bucket_default_river_water"},
	results = {"default:dye_black", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_chicory 2", "default:bucket_default_water"},
	results = {"default:dye_blue", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_chicory 2", "default:bucket_default_river_water"},
	results = {"default:dye_blue", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_kniphofia 2", "default:bucket_default_water"},
	results = {"default:dye_red", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_kniphofia 2", "default:bucket_default_river_water"},
	results = {"default:dye_red", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_bloodbulb 2", "default:bucket_default_water"},
	results = {"default:dye_red", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_bloodbulb 2", "default:bucket_default_river_water"},
	results = {"default:dye_red", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_iris 2", "default:bucket_default_water"},
	results = {"default:dye_white", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_iris 2", "default:bucket_default_river_water"},
	results = {"default:dye_white", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_milfoil 2", "default:bucket_default_water"},
	results = {"default:dye_white", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_milfoil 2", "default:bucket_default_river_water"},
	results = {"default:dye_white", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_violet 2", "default:bucket_default_water"},
	results = {"default:dye_purple", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_violet 2", "default:bucket_default_river_water"},
	results = {"default:dye_purple", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_wolfshood 2", "default:bucket_default_water"},
	results = {"default:dye_purple", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:flower_wolfshood 2", "default:bucket_default_river_water"},
	results = {"default:dye_purple", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_mureux_fruit", "default:bucket_default_water"},
	results = {"default:dye_purple", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_mureux_fruit", "default:bucket_default_river_water"},
	results = {"default:dye_purple", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"group:leaves 2", "default:bucket_default_water"},
	results = {"default:dye_green", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"group:leaves 2", "default:bucket_default_river_water"},
	results = {"default:dye_green", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_red", "default:dye_green"},
	results = {"default:dye_yellow 2"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_kingscrown", "default:bucket_default_water"},
	results = {"default:dye_yellow", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_kingscrown", "default:bucket_default_river_water"},
	results = {"default:dye_yellow", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_blue", "default:dye_green"},
	results = {"default:dye_cyan 2"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_blue", "default:dye_red"},
	results = {"default:dye_magenta 2"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_sapweed", "default:bucket_default_water"},
	results = {"default:dye_magenta", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:herb_sapweed", "default:bucket_default_river_water"},
	results = {"default:dye_magenta", "default:bucket"},
	near = {"group:furnace", "group:cookware", "group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_white", "default:dye_black"},
	results = {"default:dye_dark_gray 2"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_dark_green", "default:dye_red"},
	results = {"default:dye_orange 2"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_green 2", "default:dye_black"},
	results = {"default:dye_dark_green 3"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_white 2", "default:dye_black"},
	results = {"default:dye_gray 3"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_red 2", "default:dye_green"},
	results = {"default:dye_orange 3"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_blue 2", "default:dye_red"},
	results = {"default:dye_purple 3"},
	near = {"group:ttable"}
})

qts.register_craft({
	ingredients = {"default:dye_cyan", "default:dye_yello", "default:dye_magenta"},
	results = {"default:dye_brown 3"},
	near = {"group:ttable"}
})

--Solas Blocks
qts.register_craft({
	ingredients = {"default:dye_blue", "default:glass", "default:herb_mureux_fruit"},
	results = {"default:solas_block_blue"},
	near = {"group:ttable", "default:alchemy_equipment_basic"}
})

qts.register_craft({
	ingredients = {"default:dye_white", "default:glass", "default:herb_mureux_fruit"},
	results = {"default:solas_block_white"},
	near = {"group:ttable", "default:alchemy_equipment_basic"}
})

qts.register_craft({
	ingredients = {"default:dye_red", "default:glass", "default:herb_mureux_fruit"},
	results = {"default:solas_block_red"},
	near = {"group:ttable", "default:alchemy_equipment_basic"}
})

qts.register_craft({
	ingredients = {"default:dye_green", "default:glass", "default:herb_mureux_fruit"},
	results = {"default:solas_block_green"},
	near = {"group:ttable", "default:alchemy_equipment_basic"}
})

qts.register_craft({
	ingredients = {"default:dye_purple", "default:glass", "default:herb_mureux_fruit"},
	results = {"default:solas_block_purple"},
	near = {"group:ttable", "default:alchemy_equipment_basic"}
})

qts.register_craft({
	ingredients = {"default:dye_orange", "default:glass", "default:herb_mureux_fruit"},
	results = {"default:solas_block_orange"},
	near = {"group:ttable", "default:alchemy_equipment_basic"}
})

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