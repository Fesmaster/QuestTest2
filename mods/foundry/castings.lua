--[[
name - type name
def contains - {
	block_tiles = {}, --tiles of the casting block
	volume = 1, --default volume of metal to cast
	description = "human readable description"
	
}
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


