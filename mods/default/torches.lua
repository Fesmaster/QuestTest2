

qts.register_torch("default:torch", {
	description = "Testing Torch",
	tiles = {{
		name = "default_torch.png",
		animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, length = 1.5}
	}},
	walkable = false,
	light_source = 12,
	groups = {choppy=2, dig_immediate=3, flammable=1, attached_node=1},
	sounds = qtcore.node_sound_wood(),
})