
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
})
qts.register_craft({
	ingredients = {"default:rowan_wood_planks 2"},
	results = {"default:rowan_wood_fence 4"},
})
qts.register_craft({
	ingredients = {"default:apple_wood_planks 2"},
	results = {"default:apple_wood_fence 4"},
})
qts.register_craft({
	ingredients = {"default:aspen_wood_planks 2"},
	results = {"default:aspen_wood_fence 4"},
})
qts.register_craft({
	ingredients = {"default:lanternfruit_wood_planks 2"},
	results = {"default:lanternfruit_wood_fence 4"},
})
qts.register_craft({
	ingredients = {"default:coffee_wood_planks 2"},
	results = {"default:coffee_wood_fence 4"},
})
qts.register_craft({
	ingredients = {"default:rosewood_wood_planks 2"},
	results = {"default:rosewood_wood_fence 4"},
})



--knife recipies
qts.register_craft({
	ingredients = {"default:flint", "group:wood"},
	results = {"default:knife_flint"},
})

qts.register_craft({
	ingredients = {"group:wood"},
	results = {"default:tinder"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:leaves"},
	results = {"default:tinder"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:wood", "default:tinder", "default:flint"},
	results = {"default:tinderbox"},
})

--various other
qts.register_craft({
	ingredients = {"group:wood 5"},
	results = {"default:campfire"},
})

qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"default:crate"},
})

qts.register_craft({
	ingredients = {"default:brick_single 4"},
	results = {"default:brick"},
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

--stone and stone walls
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_cobble"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_brick"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_block"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:brick_grey"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_wall"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_cobble_wall"},
})
qts.register_craft({
	ingredients = {"group:grey_stone"},
	results = {"default:stone_brick_wall"},
})

qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_cobble"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_brick"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_block"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_wall"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_cobble_wall"},
})
qts.register_craft({
	ingredients = {"group:red_stone"},
	results = {"default:red_stone_brick_wall"},
})

qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_cobble"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_brick"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_block"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_wall"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_cobble_wall"},
})
qts.register_craft({
	ingredients = {"group:sand_stone"},
	results = {"default:sandstone_brick_wall"},
})

qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_cobble"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_brick"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_block"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_wall"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_cobble_wall"},
})
qts.register_craft({
	ingredients = {"group:desert_stone"},
	results = {"default:desert_sandstone_brick_wall"},
})

qts.register_craft({
	ingredients = {"group:obsidian"},
	results = {"default:obsidian"},
})
qts.register_craft({
	ingredients = {"group:obsidian"},
	results = {"default:obsidian_brick"},
})
qts.register_craft({
	ingredients = {"group:obsidian"},
	results = {"default:obsidian_block"},
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

