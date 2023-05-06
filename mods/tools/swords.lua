--[[
SWORDS
--]]
minetest.register_tool("tools:sword_rusted", {
	description = "Rusted Sword",
	inventory_image = "tools_sword_rusted.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[2]=0.60, [3]=0.30}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=6},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {sword = 1}
})
--copper
minetest.register_tool("tools:sword_copper", {
	description = "Copper Sword",
	inventory_image = "tools_sword_copper.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[2]=0.60, [3]=0.30}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=6},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {sword = 1}
})
--bronze
minetest.register_tool("tools:sword_bronze", {
	description = "Bronze Sword",
	inventory_image = "tools_sword_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[2]=0.50, [3]=0.25}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=8},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {sword = 1}
})
--iron
minetest.register_tool("tools:sword_iron", {
	description = "Iron Sword",
	inventory_image = "tools_sword_iron.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[2]=0.40, [3]=0.20}, uses=90, maxlevel=1},
		},
		damage_groups = {fleshy=10},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {sword = 1}
})
--steel
minetest.register_tool("tools:sword_steel", {
	description = "Steel Sword",
	inventory_image = "tools_sword_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			snappy = {times={[1]=0.60, [2]=0.30, [3]=0.10}, uses=100, maxlevel=1},
		},
		damage_groups = {fleshy=14},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {sword = 1}
})