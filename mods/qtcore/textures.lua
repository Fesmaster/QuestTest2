--[[
This file is for creating texture strings and texture tables for various needs

]]


function qtcore.liquid_texture(name, speed)
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

function qtcore.armor_cloth_textures(basecolor, shadowstrength)
	return {
		cloak = {
			entity = "(qt_armor_cape_cloth_base.png^[multiply:"..basecolor..")^(qt_armor_cape_cloth_shadow.png^[opacity:"..shadowstrength..")^qt_armor_cape_cloth_trim.png",
			item = "(qt_armor_cape_cloth_base_item.png^[multiply:"..basecolor..")^(qt_armor_cape_cloth_shadow_item.png^[opacity:"..shadowstrength..")^qt_armor_cape_cloth_trim_item.png",
		},
		robe = {
			entity = "(qt_armor_robe_cloth_base.png^[multiply:"..basecolor..")^(qt_armor_robe_cloth_shadow.png^[opacity:"..shadowstrength..")^qt_armor_robe_cloth_trim.png",
			item = "(qt_armor_robe_cloth_base_item.png^[multiply:"..basecolor..")^(qt_armor_robe_cloth_shadow_item.png^[opacity:"..shadowstrength..")^qt_armor_robe_cloth_trim_item.png",
		},
		hood = {
			entity = "(qt_armor_hood_cloth_base.png^[multiply:"..basecolor..")^(qt_armor_hood_cloth_shadow.png^[opacity:"..shadowstrength..")^qt_armor_hood_cloth_trim.png",
			item = "(qt_armor_hood_cloth_base_item.png^[multiply:"..basecolor..")^(qt_armor_hood_cloth_shadow_item.png^[opacity:"..shadowstrength..")^qt_armor_hood_cloth_trim_item.png",
		},
		gloves = {
			entity = "(qt_armor_glove_cloth_base.png^[multiply:"..basecolor..")^(qt_armor_glove_cloth_shadow.png^[opacity:"..shadowstrength..")^qt_armor_glove_cloth_trim.png",
			item = "(qt_armor_glove_cloth_base_item.png^[multiply:"..basecolor..")^(qt_armor_glove_cloth_shadow_item.png^[opacity:"..shadowstrength..")^qt_armor_glove_cloth_trim_item.png",
		},
		boots = {
			entity = "(qt_armor_boot_cloth_base.png^[multiply:"..basecolor..")^(qt_armor_boot_cloth_shadow.png^[opacity:"..shadowstrength..")^qt_armor_boot_cloth_trim.png",
			item = "(qt_armor_boot_cloth_base_item.png^[multiply:"..basecolor..")^(qt_armor_boot_cloth_shadow_item.png^[opacity:"..shadowstrength..")^qt_armor_boot_cloth_trim_item.png",
		},
	}
end

qtcore.colors = {
	red = "#a40000",
	orange = "#a45200",
	yellow = "#c6a900",
	green = "#3fa400",
	cyan = "#00a4a4",
	blue = "#0000a4",
	purple = "#5200a4",
	magenta = "#a400a4",
	white = "#e4e4e4",
	gray = "#6d6d6d",
	dark_gray = "#363636",
	black = "#1f1f1f",
	dark_green = "#005200",
	brown = "#443200",
}