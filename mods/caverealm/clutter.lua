--holds plants and underbrush



local colors = {"blue", "green", "purple"}
local colorCap = {"Blue", "Green", "Purple"}

for k, color in ipairs(colors) do
	minetest.register_node("caverealm:cave_crystal_"..color, {
		description = colorCap[k].." Cave Crystal",
		drawtype = "mesh",
		tiles = {"default_cave_crystal_"..color..".png"},
		mesh = "cave_crystal.obj",
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		buildable_to = true,
		use_texture_alpha = "blend",
		sunlight_propagates = true,
		on_rotate = false,
		selection_box = qtcore.nb_level1(),
		light_source = 10,
		groups = {cracky=3, crystal = 1, attached_node = 1, generation_replacable=1},
		sounds = qtcore.node_sound_stone(),
	})
end


