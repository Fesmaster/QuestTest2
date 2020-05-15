--
-- Aliases for map generator outputs
--


qts.worldgen.set_mapgen_defaults("default:stone", "default:water_source")

--[[
	heat_point = number
	humidity_point = number
	min_ground_height = number --unlike regular biomes, this is NOT the node Y height, it is the ground default height
	max_ground_height	^^
	dust = "nodename"    -|
	surface = "nodename"  |
	fill = "nodename"     |- these SHOULD be able to be tables to get a random one, too
	stone = "nodename"   -|
	surface_depth = number
	fill_depth = number
	stone_depth = number
	--]]
qts.worldgen.register_biome("grasslands", {
	heat_point = 25,
	humidity_point = 50,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = nil,
	surface = "default:dirt_with_grass",
	fill = "default:dirt",
	stone = "default:stone",
	plant = "default:grass_5",
	plant_freq = 90,
	surface_depth = 1,
	fill_depth = 2,
	stone_depth = 0,
})

qts.worldgen.register_biome("prarie", {
	heat_point = 50,
	humidity_point = 50,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = nil,
	surface = "default:dirt_with_prarie_grass",
	fill = "default:dirt",
	stone = "default:stone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 1,
	fill_depth = 3,
	stone_depth = 0,
})

qts.worldgen.register_biome("swamp", {
	heat_point = 25,
	humidity_point = 95,
	min_ground_height = 5,
	max_ground_height = 30,
	min_light = 9,--half
	min_air = 50,
	dust = nil,
	surface = {"default:dirt_with_swamp_grass"},
	fill = "default:dirt", --TODO: add peat?
	stone = "default:stone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 1,
	fill_depth = 5,
	stone_depth = 0,
})

qts.worldgen.register_biome("rainforest", {
	heat_point = 70,
	humidity_point = 75,
	min_ground_height = 5,
	max_ground_height = 80,
	min_light = 4,--half
	min_air = 10,
	dust = nil,
	surface = {"default:dirt_with_rainforest_grass"},
	fill = "default:dirt", 
	stone = "default:stone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 1,
	fill_depth = 5,
	stone_depth = 0,
})

qts.worldgen.register_biome("mushroom_forest", {
	heat_point = 70,
	humidity_point = 110,
	min_ground_height = 3,
	max_ground_height = 10,
	min_light = 7,--half
	min_air = 10,
	dust = nil,
	surface = {"default:dirt_with_mushroom_grass"},
	fill = "default:dirt", 
	stone = "default:stone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 1,
	fill_depth = 5,
	stone_depth = 0,
})

qts.worldgen.register_biome("desert", {
	heat_point = 75,
	humidity_point = 25,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 2,
	dust = nil,
	surface = "default:desert_sand",
	fill = {"default:desert_sand", "default:desert_sandstone"},
	stone = "default:desert_sandstone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 5,
	fill_depth = 10,
	stone_depth = 20,
})

qts.worldgen.register_biome("mountain", {
	heat_point = 25,
	humidity_point = 50,
	min_ground_height = 95,
	max_ground_height = 1000000,
	min_light = 7,--half
	min_air = 2,
	dust = nil,
	surface = {"default:dirt", "default:stone"}, --TODO:replace with gravel
	fill = "default:dirt",
	stone = "default:stone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 2,
	fill_depth = 0,
	stone_depth = 0,
})

qts.worldgen.register_biome("desert_mountains", {
	heat_point = 75,
	humidity_point = 25,
	min_ground_height = 94,
	max_ground_height = 100000,
	min_light = 0,--half
	min_air = 0,
	dust = nil,
	surface = "default:desert_sandstone",
	fill = {"default:desert_sandstone", "default:desert_sandstone"},
	stone = "default:desert_sandstone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 0,
	fill_depth = 0,
	stone_depth = 50,
})

qts.worldgen.register_biome("beach", {
	heat_point = 50,
	humidity_point = 50,
	min_ground_height = -100000,
	max_ground_height = 5,
	min_light = 0,--half
	min_air = 10,
	dust = "air",
	surface = "default:sand",
	fill = {"default:sand","default:sandstone"},
	stone = "default:sandstone",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})

minetest.register_ore({
	ore_type        = "blob",
	ore             = "default:clay",
	wherein         = {"default:sand"},
	clust_scarcity  = 16 * 16 * 16,
	clust_size      = 5,
	y_max           = 0,
	y_min           = -15,
	noise_threshold = 0.0,
	noise_params    = {
		offset = 0.5,
		scale = 0.2,
		spread = {x = 5, y = 5, z = 5},
		seed = -316,
		octaves = 1,
		persist = 0.0
	},
})


--[[
def contains:
	schematic = "path to schematic.mts" --must contain ".mts", it is not added for you!!
	chance = (0-100) % chance of placing. math: math.random(100-freq) == 1
	biomes = {} or "name" (converted to table in register)
	nodes = {} or "name" (converted to table in register)
	force_place = false -- should the placement be forced?
	rotate = true - should the placed rotation be random?
	offset = vector or nil
	flags = flags for placing
--]]
--[[
qts.worldgen.register_structure("", {
	schematic = minetest.get_modpath("default") .. "/schems/strange.mts",
	chance = 30,
	biomes = {"grasslands"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(false, true, false),
})

--]]
--minetest.register_alias("mapgen_stone", "default:stone")
--minetest.register_alias("mapgen_dirt", "default:dirt")
--minetest.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
--minetest.register_alias("mapgen_sand", "default:sand")
--minetest.register_alias("mapgen_water_source", "default:water_source")
--minetest.register_alias("mapgen_river_water_source", "air")
--minetest.register_alias("mapgen_lava_source", "air")
--minetest.register_alias("mapgen_gravel", "default:default")
--
--minetest.register_alias("mapgen_tree", "default:default")
--minetest.register_alias("mapgen_leaves", "default:default")
--minetest.register_alias("mapgen_apple", "default:default")
--minetest.register_alias("mapgen_junglegrass", "default:default")
--
--minetest.register_alias("mapgen_cobble", "default:cobble")
--minetest.register_alias("mapgen_stair_cobble", "default:cobble_stair")
--minetest.register_alias("mapgen_mossycobble", "default:default")
--
--minetest.clear_registered_biomes()
--minetest.clear_registered_decorations()
--
--minetest.register_biome({
--	name = "default:grasslands",
--	--node_dust = "",
--	node_top = "default:dirt_with_grass",
--	depth_top = 1,
--	node_filler = "default:dirt",
--	depth_filler = 1,
--	--node_stone = "",
--	--node_water_top = "",
--	--depth_water_top = ,
--	--node_water = "",
--	y_min = 5,
--	y_max = 31000,
--	heat_point = 50,
--	humidity_point = 50,
--})
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

