--apple
local path = minetest.get_modpath("qtcore") .. "\\schems\\"
local flags = "place_center_x,place_center_z"


qtcore.grow_apple_tree = function(pos)
	return minetest.place_schematic(pos, path .. "apple1.mts", random, nil, false, flags)
end

qtcore.grow_oak_tree = function(pos)
	return minetest.place_schematic(pos, path .. "oak" .. tostring(math.random(1,3)) .. ".mts", random, nil, false, flags)
end

qtcore.grow_coffee_tree = function(pos)
	return minetest.place_schematic(pos, path .. "coffee1.mts", random, nil, false, flags)
end

qtcore.grow_rowan_tree = function(pos)
	return minetest.place_schematic(pos, path .. "rowan1.mts", random, nil, false, flags)
end

qtcore.grow_aspen_tree = function(pos)
	--local name = {"aspen1","aspen2"}[math.random(1,2)]
	return minetest.place_schematic(pos, path .. "aspen" .. tostring(math.random(1,2)) .. ".mts", random, nil, false, flags)
end

qtcore.grow_mahogany_tree = function(pos)
	return minetest.place_schematic(pos, path .. "mahogany" .. tostring(math.random(1,2)) .. ".mts", random, nil, false, flags)
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

qts.worldgen.register_structure("tree_apple", {
	schematic = path .. "apple1.mts",
	chance = 20,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_oak1", {
	schematic = path .. "oak1.mts",
	chance = 30,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_oak2", {
	schematic = path .. "oak2.mts",
	chance = 30,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_oak3", {
	schematic = path .. "oak3.mts",
	chance = 30,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_aspen1", {
	schematic = path .. "aspen1.mts",
	chance = 30,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_aspen2", {
	schematic = path .. "aspen2.mts",
	chance = 30,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_rowan", {
	schematic = path .. "rowan1.mts",
	chance = 20,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_coffee", {
	schematic = path .. "coffee1.mts",
	chance = 20,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_mahogany1", {
	schematic = path .. "mahogany1.mts",
	chance = 30,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_mahogany2", {
	schematic = path .. "mahogany2.mts",
	chance = 30,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_lantern1", {
	schematic = path .. "lantern1.mts",
	chance = 30,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_lantern2", {
	schematic = path .. "lantern2.mts",
	chance = 30,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_rosewood1", {
	schematic = path .. "rosewood1.mts",
	chance = 30,
	biomes = {"prarie"},
	nodes = {"default:dirt_with_prarie_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_small_b_shroom", {
	schematic = path .. "small_b_shroom.mts",
	chance = 30,
	biomes = {"mushroom_forest"},
	nodes = {"default:dirt_with_mushroom_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_large_b_shroom", {
	schematic = path .. "large_b_shroom.mts",
	chance = 15,
	biomes = {"mushroom_forest"},
	nodes = {"default:dirt_with_mushroom_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})