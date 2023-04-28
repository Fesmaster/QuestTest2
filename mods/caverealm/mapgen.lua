

qts.worldgen.register_biome("caverealm", {
	heat_point = 50,
	humidity_point = 50,
	min_ground_height = -31000, --TODO: when adding more layers to world, increase this
	max_ground_height = -300,
	min_light = 0,
	min_air = 1,
	surface = "caverealm:understone",
	underwater = "caverealm:understone",
	plant = {"caverealm:cave_crystal_blue", "caverealm:cave_crystal_green", "caverealm:cave_crystal_purple"},
	plant_freq = 10,
	stone = "caverealm:understone",
	surface_depth = 12,
	fill_depth = 12,
	stone_depth = 0,
})