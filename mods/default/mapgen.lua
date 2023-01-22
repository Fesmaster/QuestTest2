--
-- Aliases for map generator outputs
--


qts.worldgen.set_mapgen_defaults("default:stone", "default:water_source", "default:river_water_source")

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
	surface = "default:dirt_with_grass",
	fill = "default:dirt",
	stone = "default:stone",
	plant = {"default:grass_tall", "default:grass_short", "default:flower_kniphofia", "default:flower_chicory"},
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
	surface = "default:dirt_with_grass",
	fill = "default:dirt",
	stone = "default:stone",
	plant = {"default:grass_tall", "default:grass_short", "default:flower_violet"},
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
	surface = "default:dirt_with_prarie_grass",
	fill = "default:dirt",
	stone = "default:stone",
	plant = {"default:grass_dry_tall", "default:grass_dry_short"},
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
	surface = {"default:dirt_with_swamp_grass"},
	fill = {"default:dirt_swamp"}, --TODO: add peat?
	stone = {"default:stone"},
	plant = {"default:swamp_plant", "default:flower_iris"},
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
	surface = {"default:dirt_with_rainforest_grass"},
	fill = "default:dirt",
	stone = "default:stone",
	plant = {"default:underbrush_short","default:underbrush_tall","default:herb_mureux_ripe"},
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
	surface = {"default:dirt_with_mushroom_grass"},
	fill = {"default:dirt"},
	stone = {"default:stone"},
	plant = {"default:small_mushroom"},
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
	dust = "default:snow",
	surface = {"default:dirt", "default:stone"}, --TODO:replace with gravel and add pines?
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
	heat_point = 25,
	humidity_point = 50,
	min_ground_height = 0,
	max_ground_height = 5,
	min_light = 0,--half
	min_air = 10,
	--dust = "air",
	surface = "default:sand",
	fill = {"default:sand","default:sandstone"},
	stone = "default:sandstone",
	plant = {"default:beach_grass"},
	plant_freq = 20,
	underwater = "default:sand",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})
---[[
qts.worldgen.register_biome("underwater", {
	heat_point = 50,
	humidity_point = 50,
	min_ground_height = -300,
	max_ground_height = 0,
	min_light = 0,--half
	min_air = 10,
	--dust = "air",
	underwater = "default:sand",
	--fill = {"default:sand","default:sandstone"},
	--stone = "default:sandstone",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})
--]]
qts.worldgen.register_biome("caverealm", {
	heat_point = 50,
	humidity_point = 50,
	min_ground_height = -31000,
	max_ground_height = -300,
	min_light = 0,
	min_air = 1,
	--dust = "air",
	surface = "default:understone",
	underwater = "default:understone",
	--fill = "default:understone",
	plant = {"default:cave_crystal_blue", "default:cave_crystal_green", "default:cave_crystal_purple"},
	plant_freq = 10,
	stone = "default:understone",
	surface_depth = 12,
	fill_depth = 12,
	stone_depth = 0,
})

qts.worldgen.register_biome("snow", {
	heat_point = 10,
	humidity_point = 40,
	min_ground_height = 5,
	max_ground_height = 94,
	min_light = 7,--half
	min_air = 10,
	dust = "default:snow",
	surface = "default:dirt_with_snow",
	fill = "default:dirt",
	stone = "default:stone",
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
	dust = {"default:snow"},
	--dust = nil,
	surface = "default:sand",
	fill = {"default:sand","default:sandstone"},
	stone = "default:sandstone",
	underwater = "default:sand",
	surface_depth = 2,
	fill_depth = 4,
	stone_depth = 10,
})

--[[
ORES
--]]

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

minetest.register_ore({
	ore_type        = "blob",
	ore             = "default:peat",
	wherein         = {"default:dirt_swamp"},
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
	ore            = "default:river_water_source",
	wherein        = "default:dirt_swamp",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 8,
	clust_size     = 5,
	y_max          = 20,
	y_min          = -15,
})

minetest.register_ore({
	ore_type        = "blob",
	ore             = "default:obsidian",
	wherein         = {"default:stone"},
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
	ore             = "default:marble",
	wherein         = {"default:stone"},
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

--Coal
--[[
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 9,
	clust_size     = 3,
	y_max          = 31000,
	y_min          = 1025,
})
--]]
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 8,
	clust_size     = 3,
	y_max          = 64,
	y_min          = -127,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 16,
	clust_size     = 5,
	y_max          = -128,
	y_min          = -31000,
})
--]]

-- Tin
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_tin",
	wherein        = "default:stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 1025,
	y_min          = -64,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_tin",
	wherein        = "default:stone",
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 6,
	clust_size     = 3,
	y_max          = -64,
	y_min          = -127,
})
--[[
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_tin",
	wherein        = "default:stone",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = -128,
	y_min          = -31000,
})
--]]

-- Copper
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 1025,
	y_min          = -64,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 8,
	clust_size     = 4,
	y_max          = -64,
	y_min          = -127,
})
--[[
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = 9 * 9 * 9,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = -128,
	y_min          = -31000,
})
--]]

-- Iron
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 7 * 7 * 7,
	clust_num_ores = 10,
	clust_size     = 3,
	y_max          = -64,
	y_min          = -127,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_iron",
	wherein        = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 20,
	clust_size     = 5,
	y_max          = -128,
	y_min          = -384,
})

--gold
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_gold",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 20,
	clust_size     = 5,
	y_max          = -128,
	y_min          = -1024,
})

--silver
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_silver",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 20,
	clust_size     = 5,
	y_max          = -128,
	y_min          = -1024,
})


--jems
local jems = {
	"default:stone_with_ruby",
	"default:stone_with_fire_opal",
	"default:stone_with_citrine",
	"default:stone_with_emerald",
	"default:stone_with_diamond",
	"default:stone_with_sapphire",
	"default:stone_with_amathest",
	"default:stone_with_oynx",
}
for key, jem in ipairs(jems) do
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = jem,
		wherein        = "default:stone",
		clust_scarcity = 30 * 30 * 30,
		clust_num_ores = 4,
		clust_size     = 2,
		y_max          = -256,
		y_min          = -1024,
	})
end


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
