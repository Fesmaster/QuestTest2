--[[
    crafting recipes for tools
]]

--knives
qts.register_craft({
	ingredients = {"overworld:flint", "group:wood"},
	results = {"tools:knife_flint"},
})

qts.register_craft({
	ingredients = {"overworld:copper_bar", "group:wood"},
	results = {"tools:knife_copper"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:bronze_bar", "group:wood"},
	results = {"tools:knife_bronze"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:iron_bar", "group:wood"},
	results = {"tools:knife_iron"},
	near = {"group:anvil", "group:furnace"},
})

qts.register_craft({
	ingredients = {"overworld:steel_bar", "group:wood"},
	results = {"tools:knife_steel"},
	near = {"group:anvil", "group:furnace"},
})

--picks
qts.register_craft({
	ingredients = {"group:wood", "overworld:copper_bar 3"},
	results = {"tools:pick_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:bronze_bar 3"},
	results = {"tools:pick_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:iron_bar 3"},
	results = {"tools:pick_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:steel_bar 3"},
	results = {"tools:pick_steel"},
	near = {"group:anvil", "group:furnace"},
})
--axes
qts.register_craft({
	ingredients = {"group:wood", "overworld:flint 3"},
	results = {"tools:axe_flint"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:copper_bar 3"},
	results = {"tools:axe_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:bronze_bar 3"},
	results = {"tools:axe_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:iron_bar 3"},
	results = {"tools:axe_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:steel_bar 3"},
	results = {"tools:axe_steel"},
	near = {"group:anvil", "group:furnace"},
})

--shovels
qts.register_craft({
	ingredients = {"group:wood", "overworld:copper_bar 3"},
	results = {"tools:shovel_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:bronze_bar 3"},
	results = {"tools:shovel_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:iron_bar 3"},
	results = {"tools:shovel_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:steel_bar 3"},
	results = {"tools:shovel_steel"},
	near = {"group:anvil", "group:furnace"},
})

--swords
qts.register_craft({
	ingredients = {"group:wood", "overworld:copper_bar 3"},
	results = {"tools:sword_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:bronze_bar 3"},
	results = {"tools:sword_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:iron_bar 3"},
	results = {"tools:sword_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:steel_bar 3"},
	results = {"tools:sword_steel"},
	near = {"group:anvil", "group:furnace"},
})

--hoes
qts.register_craft({
	ingredients = {"group:wood", "overworld:copper_bar 3"},
	results = {"tools:hoe_copper"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:bronze_bar 3"},
	results = {"tools:hoe_bronze"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:iron_bar 3"},
	results = {"tools:hoe_iron"},
	near = {"group:anvil", "group:furnace"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:steel_bar 3"},
	results = {"tools:hoe_steel"},
	near = {"group:anvil", "group:furnace"},
})

--hammers
qts.register_craft({
	ingredients = {"group:wood", "group:stone 5"},
	results = {"tools:hammer_stone"},
	near = {"group:workbench"},
})
qts.register_craft({
	ingredients = {"group:wood", "overworld:steel_bar 5"},
	results = {"tools:hammer_steel"},
	near = {"group:anvil", "group:furnace"},
})

--bows
qts.register_craft({
	ingredients = {"group:wood", "overworld:flint 16", "group:bark 16"},
	results = {"tools:arrow 16"},
	held = {"group:knife"},
})

qts.register_craft({
	ingredients = {"group:wood", "farmworks:herb_flax"},
	results = {"tools:bow"},
	near = {"group:workbench"},
})

--buckets
qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"tools:bucket_wood"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"group:wood", "farmworks:herb_flax 8"},
	results = {"tools:paintbrush"},
	near = {"group:workbench"},
})