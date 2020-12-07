local nodeboxes = {
		{-0.5, -0.5, 0.1875, 0.125, -0.3125, 0.4375}, -- NodeBox45
		{-0.5, -0.5, -0.125, 0.125, -0.3125, 0.125}, -- NodeBox46
		{-0.5, -0.5, -0.4375, 0.125, -0.3125, -0.1875}, -- NodeBox49
		{-0.5, -0.3125, -0.3125, 0.125, -0.125, -0.0624999}, -- NodeBox51
		{-0.5, -0.3125, 0.0625, 0.125, -0.125, 0.3125}, -- NodeBox52
		{-0.5, -0.125, -0.125, 0.125, 0.0625, 0.125}, -- NodeBox53
		{0.1875, -0.5, -0.375, 0.4375, -0.3125, 0.25}, -- NodeBox54
		{0.125, -0.3125, -0.25, 0.3125, -0.0625, 0.375}, -- NodeBox55
	}

--[[ Alloy Only Metals ]]

--TIN
qts.register_ingot("default:tin_bar", {
	description = "Tin Bar",
	inventory_image = "default_tin_ingot.png",
	tiles = {"default_tin_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:tin_block", {
	description = "Tin Block",
	tiles = {"default_tin_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("default:stone_with_tin", {
	description = "Tin Ore",
	tiles = {"default_stone.png^default_stone_with_tin.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
})

--ZINC
qts.register_ingot("default:zinc_bar", {
	description = "Zinc Bar",
	inventory_image = "default_zinc_ingot.png",
	tiles = {"default_zinc_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:zinc_block", {
	description = "ZInc Block",
	tiles = {"default_zinc_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("default:stone_with_zinc", {
	description = "Zinc Ore",
	tiles = {"default_stone.png^default_stone_with_zinc.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
})

--[[ INDUSTRIAL METALS ]]

--copper
qts.register_ingot("default:copper_bar", {
	description = "Copepr Bar",
	inventory_image = "default_copper_ingot.png",
	tiles = {"default_copper_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:copper_block", {
	description = "Copper Block",
	tiles = {"default_copper_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("default:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"default_stone.png^default_stone_with_copper.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
})


--bronze
qts.register_ingot("default:bronze_bar", {
	description = "Bronze Bar",
	inventory_image = "default_bronze_ingot.png",
	tiles = {"default_bronze_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:bronze_block", {
	description = "Bronze Block",
	tiles = {"default_bronze_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_craftitem("default:bronze_alloy", {
	description = "Bronze Alloy Mixture",
	inventory_image = "default_bronze_alloy.png",
	groups = {alloy = 1,},
})

qts.register_craft({
	ingredients = {"default:copper_bar", "default:tin_bar"},
	results = {"default:bronze_alloy 2"},
})

--IRON
qts.register_ingot("default:iron_bar", {
	description = "Iron Bar",
	inventory_image = "default_iron_ingot.png",
	tiles = {"default_iron_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:iron_block", {
	description = "Iron Block",
	tiles = {"default_iron_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

qts.register_shaped_node("default:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_stone.png^default_stone_with_iron.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
})

--STEEL
qts.register_ingot("default:steel_bar", {
	description = "Steel Bar",
	inventory_image = "default_steel_ingot.png",
	tiles = {"default_steel_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:steel_block", {
	description = "Steel Block",
	tiles = {"default_steel_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_craftitem("default:steel_alloy", {
	description = "Steel Alloy Mixture",
	inventory_image = "default_steel_alloy.png",
	groups = {alloy = 1,},
})

qts.register_craft({
	ingredients = {"default:iron_bar", "default:coal"},
	results = {"default:steel_alloy 2"},
})

--[[ WEALTH METALS ]]

--brass
qts.register_ingot("default:brass_bar", {
	description = "Brass Bar",
	inventory_image = "default_brass_ingot.png",
	tiles = {"default_brass_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:brass_block", {
	description = "Brass Block",
	tiles = {"default_brass_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_craftitem("default:brass_alloy", {
	description = "Brass Alloy Mixture",
	inventory_image = "default_brass_alloy.png",
	groups = {alloy = 1,},
})

qts.register_craft({
	ingredients = {"default:copper_bar", "default:zinc_bar"},
	results = {"default:brass_alloy 2"},
})

--gold
qts.register_ingot("default:gold_bar", {
	description = "Gold Bar",
	inventory_image = "default_gold_ingot.png",
	tiles = {"default_gold_ingot_stack.png"},
	groups = {cracky=3, iron = 1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("default:gold_block", {
	description = "Gold Block",
	tiles = {"default_gold_block.png"},
	groups = {cracky=2},
	sounds = qtcore.node_sound_metal(),
})