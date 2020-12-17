


--[[
name - type name
def contains - {
	block_tiles = {}, --tiles of the casting block
	volume = 1, --default volume of metal to cast
	description = "human readable description"
	
}
]]
--[[
foundry.register_casting_type("pick", {
	description = "Pick",
	volume = 3,
	block_tiles = {"foundry_pick_mold.png"},
})

foundry.register_casting_type("axe", {
	description = "Axe",
	volume = 3,
	block_tiles = {"foundry_axe_mold.png"},
})

foundry.register_casting_type("shovel", {
	description = "Shovel",
	volume = 3,
	block_tiles = {"foundry_shovel_mold.png"},
})

foundry.register_casting_type("sword", {
	description = "Sword",
	volume = 3,
	block_tiles = {"foundry_sword_mold.png"},
})

]]

foundry.register_casting_type("anvil", {
	description = "Anvil",
	volume = 12,
	block_tiles = {"foundry_anvil_mold.png"},
})

foundry.register_casting_recepie("anvil", {
	metal = "steel",
	result = "default:anvil 1",
})

qts.register_craft({
	ingredients = {"default:sand", "default:clay_lump"},
	results = {"foundry:anvil_mold",},
})

--[[
rtype = "recepie type" 
def = {
	metal = "metal name",
	volume = 1, --overrides the volume given in recepie type
	result = "itemstring"
}
]]

--[[
--pick
foundry.register_casting_recepie("pick", {
	metal = "copper",
	result = "default:pick_head_copper 1",
})

foundry.register_casting_recepie("pick", {
	metal = "bronze",
	result = "default:pick_head_bronze 1",
})

foundry.register_casting_recepie("pick", {
	metal = "iron",
	result = "default:pick_head_iron 1",
})

foundry.register_casting_recepie("pick", {
	metal = "steel",
	result = "default:pick_head_steel 1",
})



--axe
foundry.register_casting_recepie("axe", {
	metal = "copper",
	result = "default:axe_head_copper 1",
})

foundry.register_casting_recepie("axe", {
	metal = "bronze",
	result = "default:axe_head_bronze 1",
})

foundry.register_casting_recepie("axe", {
	metal = "iron",
	result = "default:axe_head_iron 1",
})

foundry.register_casting_recepie("axe", {
	metal = "steel",
	result = "default:axe_head_steel 1",
})


--shovel
foundry.register_casting_recepie("shovel", {
	metal = "copper",
	result = "default:shovel_head_copper 1",
})

foundry.register_casting_recepie("shovel", {
	metal = "bronze",
	result = "default:shovel_head_bronze 1",
})

foundry.register_casting_recepie("shovel", {
	metal = "iron",
	result = "default:shovel_head_iron 1",
})

foundry.register_casting_recepie("shovel", {
	metal = "steel",
	result = "default:shovel_head_steel 1",
})


--sword
foundry.register_casting_recepie("sword", {
	metal = "copper",
	result = "default:sword_blade_copper 1",
})

foundry.register_casting_recepie("sword", {
	metal = "bronze",
	result = "default:sword_blade_bronze 1",
})

foundry.register_casting_recepie("sword", {
	metal = "iron",
	result = "default:sword_blade_iron 1",
})

foundry.register_casting_recepie("sword", {
	metal = "steel",
	result = "default:sword_blade_steel 1",
})

--]]
