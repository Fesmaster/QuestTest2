--[[
	Metals
]]

local nodeboxes = {
	{-0.5, -0.5, 0.1875, 0.125, -0.3125, 0.4375},
	{-0.5, -0.5, -0.125, 0.125, -0.3125, 0.125},
	{-0.5, -0.5, -0.4375, 0.125, -0.3125, -0.1875},
	{-0.5, -0.3125, -0.3125, 0.125, -0.125, -0.0624999},
	{-0.5, -0.3125, 0.0625, 0.125, -0.125, 0.3125},
	{-0.5, -0.125, -0.125, 0.125, 0.0625, 0.125},
	{0.1875, -0.5, -0.375, 0.4375, -0.3125, 0.25},
	{0.125, -0.3125, -0.25, 0.3125, -0.0625, 0.375},
}

--[[ Alloy Only Metals ]]

--TIN
qts.register_ingot("overworld:tin_bar", {
	description = "Tin Bar",
	inventory_image = "default_tin_ingot.png",
	tiles = {"default_tin_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:tin_block", {
	description = "Tin Block",
	tiles = {"default_tin_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("overworld:stone_with_tin", {
	description = "Tin Ore",
	tiles = {"default_stone.png^default_stone_with_tin.png"},
	groups = {cracky=3, stone=1, ore=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
})

qtcore.register_material("metal", {
	name="tin",
	desc = "Tin",
	ingot = "overworld:tin_bar",
	block = "overworld:tin_block",
	ore = "overworld:stone_with_tin",
	utility_metal=false,
	wealth_metal=true,
})


--[[ INDUSTRIAL METALS ]]

--copper
qts.register_ingot("overworld:copper_bar", {
	description = "Copper Bar",
	inventory_image = "default_copper_ingot.png",
	tiles = {"default_copper_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:copper_block", {
	description = "Copper Block",
	tiles = {"default_copper_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("overworld:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"default_stone.png^default_stone_with_copper.png"},
	groups = {cracky=3, stone=1, ore=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
})

qtcore.register_material("metal", {
	name="copper",
	desc = "Copper",
	ingot = "overworld:copper_bar",
	block = "overworld:copper_block",
	ore = "overworld:stone_with_copper",
	utility_metal=true,
	wealth_metal=true,
})


--bronze
qts.register_ingot("overworld:bronze_bar", {
	description = "Bronze Bar",
	inventory_image = "default_bronze_ingot.png",
	tiles = {"default_bronze_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:bronze_block", {
	description = "Bronze Block",
	tiles = {"default_bronze_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_craftitem("overworld:bronze_alloy", {
	description = "Bronze Alloy Mixture",
	inventory_image = "default_bronze_alloy.png",
	groups = {alloy = 1,},
})


qts.register_craft({
	ingredients = {"overworld:copper_bar 3", "overworld:tin_bar 1"},
	results = {"overworld:bronze_alloy 4"},
})

qtcore.register_material("metal", {
	name="bronze",
	desc = "Bronze",
	ingot = "overworld:bronze_bar",
	block = "overworld:bronze_block",
	alloy = "overworld:bronze_alloy",
	utility_metal=true,
	wealth_metal=false,
})


--IRON
qts.register_ingot("overworld:iron_bar", {
	description = "Iron Bar",
	inventory_image = "default_iron_ingot.png",
	tiles = {"default_iron_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:iron_block", {
	description = "Iron Block",
	tiles = {"default_iron_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("overworld:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_stone.png^default_stone_with_iron.png"},
	groups = {cracky=3, stone=1, ore=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
})

qtcore.register_material("metal", {
	name="iron",
	desc = "Iron",
	ingot = "overworld:iron_bar",
	block = "overworld:iron_block",
	ore = "overworld:stone_with_iron",
	utility_metal=true,
	wealth_metal=false,
})

--STEEL
qts.register_ingot("overworld:steel_bar", {
	description = "Steel Bar",
	inventory_image = "default_steel_ingot.png",
	tiles = {"default_steel_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:steel_block", {
	description = "Steel Block",
	tiles = {"default_steel_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_craftitem("overworld:steel_alloy", {
	description = "Steel Alloy Mixture",
	inventory_image = "default_steel_alloy.png",
	groups = {alloy = 1,},
})

qts.register_craft({
	ingredients = {"overworld:iron_bar", "overworld:coal"},
	results = {"overworld:steel_alloy"},
})

qtcore.register_material("metal", {
	name="steel",
	desc = "Steel",
	ingot = "overworld:steel_bar",
	block = "overworld:steel_block",
	alloy = "overworld:steel_alloy",
	utility_metal=true,
	wealth_metal=false,
})

--[[ WEALTH METALS ]]

--silver
qts.register_ingot("overworld:silver_bar", {
	description = "Silver Bar",
	inventory_image = "default_silver_ingot.png",
	tiles = {"default_silver_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, silver = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:silver_block", {
	description = "Silver Block",
	tiles = {"default_silver_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("overworld:stone_with_silver", {
	description = "Silver Ore",
	tiles = {"default_stone.png^default_stone_with_silver.png"},
	groups = {cracky=3, stone=1, ore=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
})

qtcore.register_material("metal", {
	name="silver",
	desc = "Silver",
	ingot = "overworld:silver_bar",
	block = "overworld:silver_block",
	ore = "overworld:stone_with_silver",
	utility_metal=false,
	wealth_metal=true,
})

--gold
qts.register_ingot("overworld:gold_bar", {
	description = "Gold Bar",
	inventory_image = "default_gold_ingot.png",
	tiles = {"default_gold_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, gold = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:gold_block", {
	description = "Gold Block",
	tiles = {"default_gold_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("overworld:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"default_stone.png^default_stone_with_gold.png"},
	groups = {cracky=3, stone=1, ore=1, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
})

qtcore.register_material("metal", {
	name="gold",
	desc = "Gold",
	ingot = "overworld:gold_bar",
	block = "overworld:gold_block",
	ore = "overworld:stone_with_gold",
	utility_metal=false,
	wealth_metal=true,
})
