
--Wood planks
qts.register_craft({
	ingredients = {"default:oak_log 1"},
	results = {"default:oak_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:rowan_log 1"},
	results = {"default:rowan_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:apple_log 1"},
	results = {"default:apple_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:aspen_log 1"},
	results = {"default:aspen_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:lanterfruit_log 1"},
	results = {"default:lanternfruit_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:coffee_log 1"},
	results = {"default:coffee_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:rosewood_log"},
	results = {"default:rosewood_wood_planks 4"},
})
qts.register_craft({
	ingredients = {"default:mahogany_log 1"},
	results = {"default:mahogany_wood_planks 4"},
})

--fences
qts.register_craft({
	ingredients = {"default:oak_wood_planks 2"},
	results = {"default:oak_wood_fence 4"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:rowan_wood_planks 2"},
	results = {"default:rowan_wood_fence 4"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:apple_wood_planks 2"},
	results = {"default:apple_wood_fence 4"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:aspen_wood_planks 2"},
	results = {"default:aspen_wood_fence 4"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:lanternfruit_wood_planks 2"},
	results = {"default:lanternfruit_wood_fence 4"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:coffee_wood_planks 2"},
	results = {"default:coffee_wood_fence 4"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"default:rosewood_wood_planks 2"},
	results = {"default:rosewood_wood_fence 4"},
	near = {"group:workbench"},
})


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
	ingredients = {"group:wood 4"},
	results = {"default:crate"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:brick_single 4"},
	results = {"default:brick"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:calcium_oxide", "group:sand 4"},
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
	ingredients = {"group:wood", "group:coal"},
	results = {"default:torch 4",},
})

qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"default:workbench",},
})

qts.register_craft({
	ingredients = {"default:workbench", "default:iron_bar 4"},
	results = {"default:workbench_heavy",},
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
	output = "default:calcium_oxide",
	recipe = "default:shell_peices",
})

minetest.register_craft({
	type = "cooking",
	output = "default:brick_single",
	recipe = "default:clay_lump",
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
