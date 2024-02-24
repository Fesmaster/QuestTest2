--
-- Aliases for map generator outputs
--

--[[
	DEAL WITH THESE:

	NodeResolver: failed to resolve node name 'default:palm_leaves'.
	NodeResolver: failed to resolve node name 'default:palm_log'.
	NodeResolver: failed to resolve node name 'default:natural_coconut'.
	NodeResolver: failed to resolve node name 'default:coffeetree_leaves'.
	NodeResolver: failed to resolve node name 'default:lantern_fruit'.
	NodeResolver: failed to resolve node name 'default:lantern_fruit'.
]]

qts.worldgen.set_mapgen_defaults("overworld:granite", "overworld:water_source", "overworld:river_water_source")

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
	humidity_point = 70,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = nil,
	surface = "overworld:dirt_with_grass",
	fill = "overworld:dirt",
	stone = "overworld:granite",
	plant = {"overworld:grass_tall", "overworld:grass_short", "overworld:flower_kniphofia", "overworld:flower_chicory"},
	plant_freq = 10,
	surface_depth = 1,
	fill_depth = 2,
	stone_depth = 0,
})

qts.worldgen.register_biome("woods", {
	heat_point = 30,
	humidity_point = 40,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = nil,
	surface = "overworld:dirt_with_grass",
	fill = "overworld:dirt",
	stone = "overworld:granite",
	plant = {"overworld:grass_tall", "overworld:grass_short", "overworld:flower_violet", "overworld:bonewort"},
	plant_freq = 10,
	surface_depth = 1,
	fill_depth = 2,
	stone_depth = 0,
})

qts.worldgen.register_biome("prarie", {
	heat_point = 60,
	humidity_point = 60,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = nil,
	surface = "overworld:dirt_with_prarie_grass",
	fill = "overworld:dirt",
	stone = "overworld:granite",
	plant = {"overworld:grass_dry_tall", "overworld:grass_dry_short"},
	plant_freq = 10,
	surface_depth = 1,
	fill_depth = 3,
	stone_depth = 0,
})

qts.worldgen.register_biome("swamp", {
	heat_point = 25,
	humidity_point = 90,
	min_ground_height = 5,
	max_ground_height = 30,
	min_light = 9,--half
	min_air = 50,
	dust = nil,
	surface = {"overworld:dirt_with_swamp_grass"},
	fill = {"overworld:dirt_swamp"},
	stone = {"overworld:granite"},
	plant = {"overworld:swamp_plant", "overworld:flower_iris"},
	plant_freq = 10,
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
	surface = {"overworld:dirt_with_rainforest_grass"},
	fill = "overworld:dirt",
	stone = "overworld:granite",
	plant = {"overworld:underbrush_short","overworld:underbrush_tall","overworld:mureux_plant_ripe", "overworld:bonewort"},
	plant_freq = 2,
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
	surface = {"overworld:loam_with_mushroom_grass"},
	fill = {"overworld:loam"},
	stone = {"overworld:granite"},
	plant = {"overworld:small_mushroom"},
	plant_freq = 7,
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
	surface = "overworld:desert_sand",
	fill = {"overworld:desert_sand", "overworld:sandstone"},
	stone = "overworld:sandstone",
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
	dust = "overworld:snow",
	surface = {"overworld:dirt", "overworld:granite"}, --TODO:replace with gravel and add pines?
	fill = "overworld:dirt",
	stone = "overworld:granite",
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
	surface = "overworld:sandstone",
	fill = {"overworld:sandstone", "overworld:sandstone"},
	stone = "overworld:sandstone",
	plant = nil,
	plant_freq = 0,
	surface_depth = 0,
	fill_depth = 0,
	stone_depth = 50,
})

qts.worldgen.register_biome("beach", {
	heat_point = 25,
	humidity_point = 50,
	min_ground_height = 0,
	max_ground_height = 5,
	min_light = 0,--half
	min_air = 10,
	surface = "overworld:sand",
	fill = {"overworld:sand","overworld:limestone"},
	stone = "overworld:limestone",
	plant = {"overworld:beach_grass"},
	plant_freq = 20,
	underwater = "overworld:sand",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})

qts.worldgen.register_biome("underwater", {
	heat_point = 50,
	humidity_point = 50,
	min_ground_height = -300,
	max_ground_height = 0,
	min_light = 0,--half
	min_air = 10,
	underwater = "overworld:sand",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})

qts.worldgen.register_biome("snow", {
	heat_point = 10,
	humidity_point = 40,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = "overworld:snow",
	surface = "overworld:dirt_with_snow",
	fill = "overworld:dirt",
	stone = "overworld:granite",
	plant = nil,
	plant_freq = 0,
	surface_depth = 1,
	fill_depth = 2,
	stone_depth = 0,
})

qts.worldgen.register_biome("snow_beach", {
	heat_point = 10,
	humidity_point = 50,
	min_ground_height = 0,
	max_ground_height = 5,
	min_light = 0,--half
	min_air = 10,
	dust = {"overworld:snow"},
	surface = "overworld:sand",
	fill = {"overworld:sand","overworld:limestone"},
	stone = "overworld:limestone",
	underwater = "overworld:sand",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})

--[[
ORES
--]]

minetest.register_ore({
	ore_type        = "blob",
	ore             = "overworld:clay",
	wherein         = {"overworld:sand"},
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

minetest.register_ore({
	ore_type        = "blob",
	ore             = "overworld:peat",
	wherein         = {"overworld:dirt_swamp"},
	clust_scarcity  = 7 * 7 * 7,
	clust_size      = 5,
	y_max           = 20,
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

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "overworld:river_water_source",
	wherein        = {"overworld:dirt_swamp", "overworld:peat"},
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 8,
	clust_size     = 5,
	y_max          = 20,
	y_min          = -15,
})

minetest.register_ore({
	ore_type        = "blob",
	ore             = "overworld:obsidian",
	wherein         = {"overworld:granite"},
	clust_scarcity  = 24 * 24 * 24,
	clust_size      = 6,
	y_max           = 128,
	y_min           = -512,
	noise_threshold = 0.0,
	noise_params    = {
		offset = 0.5,
		scale = 0.2,
		spread = {x = 5, y = 5, z = 5},
		seed = 789345,
		octaves = 1,
		persist = 0.0
	},
})

minetest.register_ore({
	ore_type        = "blob",
	ore             = "overworld:marble",
	wherein         = {"overworld:granite"},
	clust_scarcity  = 24 * 24 * 24,
	clust_size      = 6,
	y_max           = 128,
	y_min           = -512,
	noise_threshold = 0.0,
	noise_params    = {
		offset = 0.5,
		scale = 0.2,
		spread = {x = 5, y = 5, z = 5},
		seed = 9405687,
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

