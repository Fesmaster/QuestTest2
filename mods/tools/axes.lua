--[[
AXES
--]]
--flint
minetest.register_tool("tools:axe_flint", {
	description = "Flint Axe",
	inventory_image = "default_axe_flint.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy = {times={[2]=0.50, [3]=0.30}, uses=30, maxlevel=1},
		},
		damage_groups = {fleshy=5},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {axe = 1}
})
minetest.register_tool("tools:axe_rusted", {
	description = "Rusted Axe",
	inventory_image = "default_axe_rusted.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy = {times={[2]=0.80, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=5},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {axe = 1}
})
--copper
minetest.register_tool("tools:axe_copper", {
	description = "Copper Axe",
	inventory_image = "default_axe_copper.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy = {times={[2]=0.80, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=5},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {axe = 1}
})
--bronze
minetest.register_tool("tools:axe_bronze", {
	description = "Bronze Axe",
	inventory_image = "default_axe_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy = {times={[2]=0.60, [3]=0.45}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=6},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {axe = 1}
})
--iron
minetest.register_tool("tools:axe_iron", {
	description = "Iron Axe",
	inventory_image = "default_axe_iron.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy = {times={[2]=0.50, [3]=0.40}, uses=90, maxlevel=1},
		},
		damage_groups = {fleshy=7},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {axe = 1}
})
--steel
minetest.register_tool("tools:axe_steel", {
	description = "Steel Axe",
	inventory_image = "default_axe_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy = {times={[1]=0.80, [2]=0.40, [3]=0.30}, uses=100, maxlevel=1},
		},
		damage_groups = {fleshy=8},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {axe = 1}
})