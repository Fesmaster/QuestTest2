--[[
	Liquids
]]

qts.register_liquid("overworld:water", {
	description = "Water",
	tiles = qtcore.liquid_texture("overworld_water_source_animated.png", 2.0),
	special_tiles = qtcore.liquid_texture("overworld_water_flowing_animated.png", 1.5),
	bucket_image = "overworld_bucket_water.png",
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cooling = 1},
	sounds = qtcore.node_sound_water(),
	liquid_renewable = false,
})

qts.register_liquid("overworld:river_water", {
	description = "River Water",
	tiles = qtcore.liquid_texture("overworld_river_water_source_animated.png", 2.0),
	special_tiles = qtcore.liquid_texture("overworld_river_water_flowing_animated.png", 1.5),
	bucket_image = "overworld_bucket_river_water.png",
	post_effect_color = {a = 103, r = 57, g = 149, b = 213},
	groups = {water = 3, liquid = 3, cooling = 1},
	sounds = qtcore.node_sound_water(),
	liquid_range = 6,
	liquid_renewable = false,
})

qts.register_liquid("overworld:lava", {
	description = "Lava",
	tiles = qtcore.liquid_texture("overworld_lava_source_animated.png", 5),
	special_tiles = qtcore.liquid_texture("overworld_lava_flowing_animated.png", 3),
	bucket_image = "overworld_bucket_lava.png",
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {liquid = 3, lava = 1, coolable = 1},
	sounds = qtcore.node_sound_water(),
	liquid_viscosity = 1,
	liquid_range = 2,
	liquid_renewable = false,
	light_source = 13,
	damage_per_second=7,
	--alpha = 255,
	on_cool = function(pos, node)
		minetest.sound_play("sounds_cooling_hiss", {gain = 1.0, pos = pos})
		if (node.name == "overworld:lava_source") then
			minetest.set_node(pos, {name = "overworld:obsidian"})
		else
			minetest.set_node(pos, {name = "overworld:stone"})
		end
	end
})

qts.register_element("cool", function(pos, node)
	minetest.log("warning","ELEMENT: Node cooled at ".. minetest.pos_to_string(pos) .. " without a callback function.")
end)

