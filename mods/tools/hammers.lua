--[[
Hammers
--]]
qts.register_hammer("tools:hammer_stone", {
	description = "Stone Hammer",
	inventory_image = "default_hammer_stone.png",
	wield_image = "default_hammer_stone.png",
	range = 7,
	groups = {hammer=1 --[[level=0]]},
	max_uses = 100,
})

qts.register_hammer("tools:hammer_steel", {
	description = "Steel Hammer",
	inventory_image = "default_hammer_steel.png",
	wield_image = "default_hammer_steel.png",
	range = 7,
	groups = {hammer=1, level=1},
	max_uses = 500,
})