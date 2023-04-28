--[[
Pickaxes
--]]
--rusted
minetest.register_tool("tools:pick_rusted", {
	description = "Rusted Pickaxe",
	inventory_image = "default_pick_rusted.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=1.00, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {pickaxe = 1}
})
--copper
minetest.register_tool("tools:pick_copper", {
	description = "Copper Pickaxe",
	inventory_image = "default_pick_copper.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=1.00, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {pickaxe = 1}
})
--bronze
minetest.register_tool("tools:pick_bronze", {
	description = "Bronze Pickaxe",
	inventory_image = "default_pick_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=0.80, [3]=0.45}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {pickaxe = 1}
})
--iron
minetest.register_tool("tools:pick_iron", {
	description = "Iron Pickaxe",
	inventory_image = "default_pick_iron.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=0.80, [3]=0.40}, uses=90, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {pickaxe = 1}
})
--steel
minetest.register_tool("tools:pick_steel", {
	description = "Steel Pickaxe",
	inventory_image = "default_pick_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=1.20, [2]=0.70, [3]=0.30}, uses=100, maxlevel=1},
		},
		damage_groups = {fleshy=5},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {pickaxe = 1}
})