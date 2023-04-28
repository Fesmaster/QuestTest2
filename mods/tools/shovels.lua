--[[
SHOVELS
--]]
minetest.register_tool("tools:shovel_rusted", {
	description = "Rusted Shovel",
	inventory_image = "default_shovel_rusted.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[2]=0.80, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {shovel = 1}
})
--copper
minetest.register_tool("tools:shovel_copper", {
	description = "Copper Shovel",
	inventory_image = "default_shovel_copper.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[2]=0.80, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {shovel = 1}
})
--bronze
minetest.register_tool("tools:shovel_bronze", {
	description = "Bronze Shovel",
	inventory_image = "default_shovel_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[2]=0.60, [3]=0.45}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {shovel = 1}
})
--iron
minetest.register_tool("tools:shovel_iron", {
	description = "Iron Shovel",
	inventory_image = "default_shovel_iron.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[2]=0.50, [3]=0.40}, uses=90, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {shovel = 1}
})
--steel
minetest.register_tool("tools:shovel_steel", {
	description = "Steel Shovel",
	inventory_image = "default_shovel_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=0.80, [2]=0.40, [3]=0.30}, uses=100, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {shovel = 1}
})