--[[
	Metals

	This file registers the ingots, blocks, alloy mixtures, and ores.
	Actual smelting of these is found in the Foundry mod.
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


----------------------------------------------------
---------------Alloy Only Metals--------------------
----------------------------------------------------

--[[
	Tin
	First, register the bars. This creates the item, as well as the various 
	nodes for the stack placed in the world.

	This one will have more documentation than the others as an example, but they all follow this pattern.
]]
qts.register_ingot("overworld:tin_bar", {
	description = "Tin Bar",
	inventory_image = "overworld_tin_ingot.png",
	tiles = {"overworld_tin_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, tin = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

--[[
	Next, create the full block. It's a shaped node.
]]
qts.register_shaped_node("overworld:tin_block", {
	description = "Tin Block",
	tiles = {"overworld_tin_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

--[[
	For every stone, we want to make the ore.
	This requires a function for all materials
]]
qtcore.for_all_materials("stone", function(fields)
	if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then

		--[[
			Create the ore, specific to the stone.
		]]
		qts.register_shaped_node("overworld:"..fields.name.."_with_tin", {
			description = "Tin Ore In " .. fields.desc,
			tiles = {fields.base_img.."^overworld_stone_with_tin.png"},
			groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
			sounds = qtcore.node_sound_stone(),
		})

		--[[
			Then, create the ore registrations.
		]]
		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_tin",
			wherein        = fields.base_item,
			clust_scarcity = 16 * 16 * 16,
			clust_num_ores = 5,
			clust_size     = 3,
			y_max          = 1025,
			y_min          = -64,
		})

		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_tin",
			wherein        = fields.base_item,
			clust_scarcity = 13 * 13 * 13,
			clust_num_ores = 6,
			clust_size     = 3,
			y_max          = -64,
			y_min          = -127,
		})
	end
end)

--[[
	Finally, create the metal materials for future reference
]]
qtcore.register_material("metal", {
	name="tin",
	desc = "Tin",
	ingot = "overworld:tin_bar",
	block = "overworld:tin_block",
	utility_metal=false,
	wealth_metal=true,
	ingot_image="overworld_tin_ingot_stack.png",
	craft_groups = {"group:workbench"},
})


----------------------------------------------------
-----------------Utility Metals---------------------
----------------------------------------------------

--[[
	Copper
]]
qts.register_ingot("overworld:copper_bar", {
	description = "Copper Bar",
	inventory_image = "overworld_copper_ingot.png",
	tiles = {"overworld_copper_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:copper_block", {
	description = "Copper Block",
	tiles = {"overworld_copper_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qtcore.for_all_materials("stone", function(fields)
	if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then
		qts.register_shaped_node("overworld:"..fields.name.."_with_copper", {
			description = "Copper Ore In "..fields.desc,
			tiles = {fields.base_img.."^overworld_stone_with_copper.png"},
			groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
			sounds = qtcore.node_sound_stone(),
		})

		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_copper",
			wherein        = fields.base_item,
			clust_scarcity = 12 * 12 * 12,
			clust_num_ores = 5,
			clust_size     = 3,
			y_max          = 1025,
			y_min          = -64,
		})
		
		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_copper",
			wherein        = fields.base_item,
			clust_scarcity = 12 * 12 * 12,
			clust_num_ores = 8,
			clust_size     = 4,
			y_max          = -64,
			y_min          = -127,
		})
	end
end)

qtcore.register_material("metal", {
	name="copper",
	desc = "Copper",
	ingot = "overworld:copper_bar",
	block = "overworld:copper_block",
	utility_metal=true,
	wealth_metal=true,
	ingot_image="overworld_copper_ingot_stack.png",
	craft_groups = {"group:workbench"},
})


--[[
	bronze

	As this one is an alloy, its a bit different. Those are highlited.
]]
qts.register_ingot("overworld:bronze_bar", {
	description = "Bronze Bar",
	inventory_image = "overworld_bronze_ingot.png",
	tiles = {"overworld_bronze_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:bronze_block", {
	description = "Bronze Block",
	tiles = {"overworld_bronze_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

--The alloy mixture is a craftitem that is made to be melted into the metal
minetest.register_craftitem("overworld:bronze_alloy", {
	description = "Bronze Alloy Mixture",
	inventory_image = "overworld_bronze_alloy.png",
	groups = {alloy = 1,},
})

--crafting recipe for the alloy mixture
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
	ingot_image="overworld_bronze_ingot_stack.png",
	craft_groups = {"group:workbench"},
})


--[[
	Iron
]]

qts.register_ingot("overworld:iron_bar", {
	description = "Iron Bar",
	inventory_image = "overworld_iron_ingot.png",
	tiles = {"overworld_iron_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:iron_block", {
	description = "Iron Block",
	tiles = {"overworld_iron_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qtcore.for_all_materials("stone", function(fields)
	if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then
		qts.register_shaped_node("overworld:"..fields.name.."_with_iron", {
			description = "Iron Ore In "..fields.desc,
			tiles = {fields.base_img.."^overworld_stone_with_iron.png"},
			groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
			sounds = qtcore.node_sound_stone(),
		})

		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_iron",
			wherein        = fields.base_item,
			clust_scarcity = 7 * 7 * 7,
			clust_num_ores = 10,
			clust_size     = 3,
			y_max          = -64,
			y_min          = -127,
		})
		
		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_iron",
			wherein        = fields.base_item,
			clust_scarcity = 12 * 12 * 12,
			clust_num_ores = 20,
			clust_size     = 5,
			y_max          = -128,
			y_min          = -384,
		})
	end
end)

qtcore.register_material("metal", {
	name="iron",
	desc = "Iron",
	ingot = "overworld:iron_bar",
	block = "overworld:iron_block",
	utility_metal=true,
	wealth_metal=false,
	ingot_image="overworld_iron_ingot_stack.png",
	craft_groups = {"group:anvil", "group:furnace"},
})


--[[
	Steel

	Another alloy
]]
qts.register_ingot("overworld:steel_bar", {
	description = "Steel Bar",
	inventory_image = "overworld_steel_ingot.png",
	tiles = {"overworld_steel_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, iron = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:steel_block", {
	description = "Steel Block",
	tiles = {"overworld_steel_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_craftitem("overworld:steel_alloy", {
	description = "Steel Alloy Mixture",
	inventory_image = "overworld_steel_alloy.png",
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
	ingot_image="overworld_steel_ingot_stack.png",
	craft_groups = {"group:anvil", "group:furnace"},
})


----------------------------------------------------
-----------------Wealth Metals----------------------
----------------------------------------------------

--[[
	silver
]]
qts.register_ingot("overworld:silver_bar", {
	description = "Silver Bar",
	inventory_image = "overworld_silver_ingot.png",
	tiles = {"overworld_silver_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, silver = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:silver_block", {
	description = "Silver Block",
	tiles = {"overworld_silver_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qtcore.for_all_materials("stone", function(fields)
	if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then
		qts.register_shaped_node("overworld:"..fields.name.."_with_silver", {
			description = "Iron Ore In "..fields.desc,
			tiles = {fields.base_img.."^overworld_stone_with_silver.png"},
			groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
			sounds = qtcore.node_sound_stone(),
		})

		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_silver",
			wherein        = fields.base_item,
			clust_scarcity = 20 * 20 * 20,
			clust_num_ores = 20,
			clust_size     = 5,
			y_max          = -128,
			y_min          = -1024,
		})
	end
end)

qtcore.register_material("metal", {
	name="silver",
	desc = "Silver",
	ingot = "overworld:silver_bar",
	block = "overworld:silver_block",
	ore = "overworld:stone_with_silver",
	utility_metal=false,
	wealth_metal=true,
	ingot_image="overworld_silver_ingot_stack.png",
	craft_groups = {"group:workbench_heavy"},
})


--[[
	gold
]]
qts.register_ingot("overworld:gold_bar", {
	description = "Gold Bar",
	inventory_image = "overworld_gold_ingot.png",
	tiles = {"overworld_gold_ingot_stack.png"},
	groups = {cracky=3, oddly_breakable_by_hand=3, gold = 1, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
	nodeboxes = nodeboxes,
	levels = 8,
})

qts.register_shaped_node("overworld:gold_block", {
	description = "Gold Block",
	tiles = {"overworld_gold_block.png"},
	groups = {cracky=2, generation_artificial=1},
	sounds = qtcore.node_sound_metal(),
})

qtcore.for_all_materials("stone", function(fields)
	if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then
		qts.register_shaped_node("overworld:"..fields.name.."_with_gold", {
			description = "Iron Ore In "..fields.desc,
			tiles = {fields.base_img.."^overworld_stone_with_gold.png"},
			groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
			sounds = qtcore.node_sound_stone(),
		})

		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_gold",
			wherein        = fields.base_item,
			clust_scarcity = 20 * 20 * 20,
			clust_num_ores = 20,
			clust_size     = 5,
			y_max          = -128,
			y_min          = -1024,
		})
	end
end)

qtcore.register_material("metal", {
	name="gold",
	desc = "Gold",
	ingot = "overworld:gold_bar",
	block = "overworld:gold_block",
	ore = "overworld:stone_with_gold",
	utility_metal=false,
	wealth_metal=true,
	ingot_image="overworld_gold_ingot_stack.png",
	craft_groups = {"group:workbench_heavy"},
})

