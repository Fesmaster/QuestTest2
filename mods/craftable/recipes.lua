
qts.register_craft({
	ingredients = {"group:wood"},
	results = {"craftable:tinder 4"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:wood"},
	results = {"craftable:stick 16"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:leaves"},
	results = {"craftable:tinder"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:underbrush"},
	results = {"craftable:tinder"},
	held = {"group:knife"},
})

--tinderbox
qts.register_craft({
	ingredients = {"group:wood", "craftable:tinder", "overworld:flint"},
	results = {"craftable:tinderbox"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"group:wood 5"},
	results = {"craftable:campfire"},
})

qts.register_craft({
	ingredients = {"craftable:lime", "group:sand 4"},
	results = {"craftable:cement 4"},
})

--paper and books
qts.register_craft({
	ingredients = {"overworld:reeds 2"},
	results = {"craftable:paper"},
})

qts.register_craft({
	ingredients = {"craftable:paper 2"},
	results = {"craftable:book"},
})

--torch
qts.register_craft({
	ingredients = {"group:wood", "group:coal"},
	results = {"craftable:torch 4",},
})

--sifter
qts.register_craft({
	ingredients = {"group:wood 4", "overworld:underbrush_item 4"},
	results = {"craftable:sifter"},
	near = {"group:workbench"},
})


--workbenches
qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"craftable:workbench",},
})

qts.register_craft({
	ingredients = {"craftable:workbench", "overworld:iron_bar 4"},
	results = {"craftable:workbench_heavy",},
})

--bricks
qts.register_craft({
	ingredients = {"group:stone"},
	results = {"craftable:brick_gray"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"craftable:brick_item 4"},
	results = {"craftable:brick"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"craftable:brick"},
	results = {"craftable:brick_wall"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"craftable:brick_gray"},
	results = {"craftable:brick_gray_wall"},
	near = {"group:workbench_heavy"},
})

--furnace
qts.register_craft({
	ingredients = {"craftable:brick"},
	results = {"craftable:furnace_brick"},
	near = {"group:workbench_heavy"},
})

qts.register_craft({
	ingredients = {"craftable:brick_gray"},
	results = {"craftable:furnace_brick_gray"},
	near = {"group:workbench_heavy"},
})

--smelting
minetest.register_craft({
	type = "cooking",
	output = "craftable:charcoal 4",
	recipe = "group:log",
})

minetest.register_craft({
	type = "cooking",
	output = "craftable:charcoal", "alchemy:potash",
	recipe = "group:wood",
})

minetest.register_craft({
	type = "cooking",
	output = "craftable:lime", "alchemy:potash",
	recipe = "overworld:shell_pieces",
})

minetest.register_craft({
	type = "cooking",
	output = "craftable:lime 16", "alchemy:potash",
	recipe = "overworld:marble",
})

minetest.register_craft({
	type = "cooking",
	output = "craftable:brick_item", "alchemy:potash",
	recipe = "overworld:clay_lump",
})

minetest.register_craft({
	type = "cooking",
	output = "alchemy:potash",
	recipe = "group:leaves",
})

minetest.register_craft({
	type = "cooking",
	output = "alchemy:potash",
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
	recipe = "overworld:bamboo",
	burntime = 8,
})

minetest.register_craft({
	type = "fuel",
	recipe = "overworld:bamboo_slats",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:coal",
	burntime = 128,
})

minetest.register_craft({
	type = "fuel",
	recipe = "overworld:peat",
	burntime = 32,
})

--dyes
qts.register_craft({
	ingredients = {"craftable:charcoal 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_black", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"craftable:charcoal 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_black", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_chicory 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_blue", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_chicory 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_blue", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_kniphofia 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_red", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_kniphofia 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_red", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_bloodbulb 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_red", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_bloodbulb 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_red", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_iris 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_white", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_iris 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_white", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_milfoil 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_white", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_milfoil 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_white", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_violet 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_purple", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:flower_violet 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_purple", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_wolfshood 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_purple", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_wolfshood 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_purple", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:mureux_fruit", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_purple", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"overworld:mureux_fruit", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_purple", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"group:leaves 2", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_green", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"group:leaves 2", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_green", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_red", "craftable:dye_green"},
	results = {"craftable:dye_yellow 2"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_kingscrown", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_yellow", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_kingscrown", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_yellow", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_blue", "craftable:dye_green"},
	results = {"craftable:dye_cyan 2"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_blue", "craftable:dye_red"},
	results = {"craftable:dye_magenta 2"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_sapweed", "tools:bucket_wood_overworld_water"},
	results = {"craftable:dye_magenta", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"farmworks:herb_sapweed", "tools:bucket_wood_overworld_river_water"},
	results = {"craftable:dye_magenta", "tools:bucket_wood"},
	near = {"group:furnace", "group:cookware", "group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_white", "craftable:dye_black"},
	results = {"craftable:dye_dark_gray 2"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_dark_green", "craftable:dye_red"},
	results = {"craftable:dye_orange 2"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_green 2", "craftable:dye_black"},
	results = {"craftable:dye_dark_green 3"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_white 2", "craftable:dye_black"},
	results = {"craftable:dye_gray 3"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_red 2", "craftable:dye_green"},
	results = {"craftable:dye_orange 3"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_blue 2", "craftable:dye_red"},
	results = {"craftable:dye_purple 3"},
	near = {"group:table"}
})

qts.register_craft({
	ingredients = {"craftable:dye_cyan", "craftable:dye_yellow", "craftable:dye_magenta"},
	results = {"craftable:dye_brown 3"},
	near = {"group:table"}
})

--Solas Blocks
qts.register_craft({
	ingredients = {"craftable:dye_blue", "craftable:glass", "overworld:mureux_fruit"},
	results = {"craftable:solas_block_blue"},
	near = {"group:table", "alchemy:equipment_basic"}
})

qts.register_craft({
	ingredients = {"craftable:dye_white", "craftable:glass", "overworld:mureux_fruit"},
	results = {"craftable:solas_block_white"},
	near = {"group:table", "alchemy:equipment_basic"}
})

qts.register_craft({
	ingredients = {"craftable:dye_red", "craftable:glass", "overworld:mureux_fruit"},
	results = {"craftable:solas_block_red"},
	near = {"group:table", "alchemy:equipment_basic"}
})

qts.register_craft({
	ingredients = {"craftable:dye_green", "craftable:glass", "overworld:mureux_fruit"},
	results = {"craftable:solas_block_green"},
	near = {"group:table", "alchemy:equipment_basic"}
})

qts.register_craft({
	ingredients = {"craftable:dye_purple", "craftable:glass", "overworld:mureux_fruit"},
	results = {"craftable:solas_block_purple"},
	near = {"group:table", "alchemy:equipment_basic"}
})

qts.register_craft({
	ingredients = {"craftable:dye_orange", "craftable:glass", "overworld:mureux_fruit"},
	results = {"craftable:solas_block_orange"},
	near = {"group:table", "alchemy:equipment_basic"}
})

--candle
qts.register_craft({
	ingredients = {"alchemy:wax_palm", "farmworks:herb_flax"},
	results = {"craftable:candle_palm"},
	near = {"group:workbench", "group:furnace"},
})

--storage pots
qts.register_craft({
	ingredients = {"overworld:clay_lump 4"},
	results = {"craftable:storage_pot_greenware"},
	near = {"group:workbench"},
})

minetest.register_craft({
	type = "cooking",
	output = "craftable:storage_pot_clay",
	recipe = "craftable:storage_pot_greenware",
})

--textiles
qts.register_craft({
	ingredients = {"farmworks:herb_flax 6"},
	results = {"craftable:textile_flax"},
})
