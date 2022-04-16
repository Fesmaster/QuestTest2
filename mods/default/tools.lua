--[[
Special tools

--]]
minetest.register_tool("default:knife_flint", {
	description = "Flint Knife",
	inventory_image = "default_knife_flint.png",
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

--[[
Hammers
--]]
qts.register_hammer("default:hammer_stone", {
	description = "Stone Hammer",
	inventory_image = "default_hammer_stone.png",
	wield_image = "default_hammer_stone.png",
	range = 7,
	groups = {hammer=1},
	max_uses = 100,
})

qts.register_hammer("default:hammer_steel", {
	description = "Steel Hammer",
	inventory_image = "default_hammer_steel.png",
	wield_image = "default_hammer_steel.png",
	range = 7,
	groups = {hammer=1, level=1},
	max_uses = 500,
})
--[[
Pickaxes
--]]
--rusted
minetest.register_tool("default:pick_rusted", {
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
minetest.register_tool("default:pick_copper", {
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
minetest.register_tool("default:pick_bronze", {
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
minetest.register_tool("default:pick_iron", {
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
minetest.register_tool("default:pick_steel", {
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

--[[
AXES
--]]
--flint
minetest.register_tool("default:axe_flint", {
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
--copper
minetest.register_tool("default:axe_copper", {
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
minetest.register_tool("default:axe_bronze", {
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
minetest.register_tool("default:axe_iron", {
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
minetest.register_tool("default:axe_steel", {
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

--[[
SHOVELS
--]]
--copper
minetest.register_tool("default:shovel_copper", {
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
minetest.register_tool("default:shovel_bronze", {
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
minetest.register_tool("default:shovel_iron", {
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
minetest.register_tool("default:shovel_steel", {
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

--[[
SWORDS
--]]
--copper
minetest.register_tool("default:sword_copper", {
	description = "Copper Sword",
	inventory_image = "default_sword_copper.png",
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
minetest.register_tool("default:sword_bronze", {
	description = "Bronze Sword",
	inventory_image = "default_sword_bronze.png",
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
minetest.register_tool("default:sword_iron", {
	description = "Iron Sword",
	inventory_image = "default_sword_iron.png",
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
minetest.register_tool("default:sword_steel", {
	description = "Steel Sword",
	inventory_image = "default_sword_steel.png",
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

--Hoes
--copper

minetest.register_tool("default:hoe_copper", {
	description = "Copper Hoe",
	inventory_image = "default_hoe_copper.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=1.00, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1}
})

--bronze
minetest.register_tool("default:hoe_bronze", {
	description = "Bronze Hoe",
	inventory_image = "default_hoe_bronze.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=1.00, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1}
})

--iron
minetest.register_tool("default:hoe_iron", {
	description = "Iron Hoe",
	inventory_image = "default_hoe_iron.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=1.00, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1}
})

--steel
minetest.register_tool("default:hoe_steel", {
	description = "Steel Hoe",
	inventory_image = "default_hoe_steel.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[2]=1.00, [3]=0.50}, uses=60, maxlevel=1},
		},
		damage_groups = {fleshy=4},
	},
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1}
})