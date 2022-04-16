


qtcore.liquid_texture = function(name, speed)
	return {
		{
			name = name,
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = speed,
			},
		},
		{
			name = name,
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = speed,
			},
		},
	}
end