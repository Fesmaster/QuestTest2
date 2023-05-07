--[[
    Knives
--]]

minetest.register_tool("tools:knife_flint", {
	description = "Flint Knife",
	inventory_image = "tools_knife_flint.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.60, [2]=0.30, [3]=0.10}, uses=100, maxlevel=1},
		},
		damage_groups = {fleshy=7},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {knife = 1}
})
inventory.register_exemplar_item("knife", "tools:knife_flint")

minetest.register_tool("tools:knife_rusted", {
	description = "Rusted Knife",
	inventory_image = "tools_knife_rusted.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.50, [2]=0.25, [3]=0.10}, uses=150, maxlevel=1},
		},
		damage_groups = {fleshy=8},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {knife = 1}
})

minetest.register_tool("tools:knife_copper", {
	description = "Copper Knife",
	inventory_image = "tools_knife_copper.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.50, [2]=0.25, [3]=0.10}, uses=150, maxlevel=1},
		},
		damage_groups = {fleshy=8},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {knife = 1}
})

minetest.register_tool("tools:knife_bronze", {
	description = "Bronze Knife",
	inventory_image = "tools_knife_bronze.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.45, [2]=0.20, [3]=0.10}, uses=150, maxlevel=1},
		},
		damage_groups = {fleshy=9},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {knife = 1}
})

minetest.register_tool("tools:knife_iron", {
	description = "Iron Knife",
	inventory_image = "tools_knife_iron.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.40, [2]=0.15, [3]=0.10}, uses=175, maxlevel=1},
		},
		damage_groups = {fleshy=10},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {knife = 1}
})

minetest.register_tool("tools:knife_steel", {
	description = "Steel Knife",
	inventory_image = "tools_knife_steel.png",
	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.35, [2]=0.10, [3]=0.10}, uses=200, maxlevel=1},
		},
		damage_groups = {fleshy=11},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {knife = 1}
})
