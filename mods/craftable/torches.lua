--[[
	Torches.
]]

qts.register_torch("craftable:torch", {
	description = "Torch",
	inventory_image = "craftable_torch_inv.png",
	wield_image = "craftable_torch_inv.png",
	tiles = {{
		name = "craftable_torch.png",
		animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 1.5}
	}},
	walkable = false,
	light_source = 12,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1, generation_artificial=1},
	sounds = qtcore.node_sound_wood(),
})


