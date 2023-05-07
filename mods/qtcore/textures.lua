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

---@type table<string, ColorSpec> List of supported dye colors. Iterate with pairs() not ipairs()
qtcore.colors = {
	red = "#a40000",--"#ff0000", --
	orange = "#ff7f00", --"#a45200",--
	yellow = "#ffff00", --"#c6a900",--
	green = "#3fa400",--"#00ff00", --
	cyan = "#00a4a4",--"#00ffff", --
	blue = "#0000ff", --"#0000a4",--
	purple = "#5200a4",--"#7f00ff", --
	magenta = "#a400a4",--"#ff00ff", --
	white = "#e4e4e4",--"#ffffff", --
	gray = "#6d6d6d",--"#aaaaaa", --
	dark_gray = "#363636",--"#545454", --
	black = "#1f1f1f",
	dark_green = "#005200",--"#007f00", --
	brown = "#443200",--"#332704", --
}