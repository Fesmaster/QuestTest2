
--wood permutations
local names = {"swamp", "rosewood", "pine", "oak", "mahogany", "lanternfruit", "coffee", "aspen", "apple", "rowan"}
for i, n in ipairs(names) do
	--planks
	qts.register_craft({
		ingredients = {"default:"..n.."_log 1"},
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


--knife recipies
qts.register_craft({
	ingredients = {"default:flint", "group:wood"},
	results = {"default:knife_flint"},
})

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
	ingredients = {"group:wood"},
	results = {"default:ladder 8"},
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
	ingredients = {"default:clay_lump"},
	results = {"default:dishes_greenware"},
	near = {"group:workbench"},
})


qts.register_craft({
	ingredients = {"default:dishes_clay", "group:wood 3"},
	results = {"default:food_table"},
	near = {"group:workbench"},
})


qts.register_craft({
	ingredients = {"default:dishes_clay", "default:herb_grain 4"},
	results = {"default:flour_bowl"},
	near = {"default:food_table"},
})


qts.register_craft({
	ingredients = {"default:herb_milfoil 2"},
	results = {"default:poltice_milfoil"},
})

qts.register_craft({
	ingredients = {"default:flour_bowl"},
	results = {"default:bread"},
	near = {"default:food_table", "group:furnace"},
})
--not working b/c default:bucket_water not defined
qts.register_craft({
	ingredients = {"default:dishes_clay", "default:bucket_default_water"},
	results = {"default:water_vessels", "default:bucket"},
})

qts.register_craft({
	ingredients = {"group:wood", "group:coal"},
	results = {"default:torch 4",},
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

qts.register_craft({
	ingredients = {"default:reeds 2"},
	results = {"default:paper"},
})

qts.register_craft({
	ingredients = {"default:paper 2"},
	results = {"default:book"},
})

--weapons and tools

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

qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"default:bucket"},
	near = {"group:workbench"},
})


qts.register_craft({
	ingredients = {"default:brick"},
	results = {"default:furnace_brick"},
	near = {"group:workbench_heavy"},
})

qts.register_craft({
	ingredients = {"default:brick_grey"},
	results = {"default:furnace_brick_grey"},
	near = {"group:workbench_heavy"},
})

--stone and stone walls
--grey stone
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_cobble"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:brick_grey"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
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
	output = "default:charcoal",
	recipe = "group:wood",
})

minetest.register_craft({
	type = "cooking",
	output = "default:lime",
	recipe = "default:shell_pieces",
})

minetest.register_craft({
	type = "cooking",
	output = "default:brick_item",
	recipe = "default:clay_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "default:dishes_clay",
	recipe = "default:dishes_greenware",
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
	recipe = "group:coal",
	burntime = 128,
})

--Other Crafting
