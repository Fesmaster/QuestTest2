--
-- Aliases for map generator outputs
--


minetest.register_alias("mapgen_stone", "default:stone")
minetest.register_alias("mapgen_dirt", "default:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
minetest.register_alias("mapgen_sand", "default:sand")
minetest.register_alias("mapgen_water_source", "air")
minetest.register_alias("mapgen_river_water_source", "air")
minetest.register_alias("mapgen_lava_source", "air")
minetest.register_alias("mapgen_gravel", "default:default")

minetest.register_alias("mapgen_tree", "default:default")
minetest.register_alias("mapgen_leaves", "default:default")
minetest.register_alias("mapgen_apple", "default:default")
minetest.register_alias("mapgen_junglegrass", "default:default")

minetest.register_alias("mapgen_cobble", "default:cobble")
minetest.register_alias("mapgen_stair_cobble", "default:cobble_stair")
minetest.register_alias("mapgen_mossycobble", "default:default")

minetest.clear_registered_biomes()
minetest.clear_registered_decorations()

minetest.register_biome({
	name = "default:grasslands",
	--node_dust = "",
	node_top = "default:dirt_with_grass",
	depth_top = 1,
	node_filler = "default:dirt",
	depth_filler = 1,
	--node_stone = "",
	--node_water_top = "",
	--depth_water_top = ,
	--node_water = "",
	y_min = 5,
	y_max = 31000,
	heat_point = 50,
	humidity_point = 50,
})
--
--minetest.register_biome({
--	name = "default:grassland_ocean",
--	--node_dust = "",
--	node_top = "default:default",
--	depth_top = 1,
--	node_filler = "default:default",
--	depth_filler = 2,
--	--node_stone = "",
--	--node_water_top = "",
--	--depth_water_top = ,
--	--node_water = "",
--	y_min = -31000,
--	y_max = 4,
--	heat_point = 50,
--	humidity_point = 50,
--})

