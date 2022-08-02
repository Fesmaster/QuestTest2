--apple
local path = minetest.get_modpath("qtcore") .. "/schems/"
local flags = "place_center_x,place_center_z"

qtcore.grow_oak_tree = function(pos)
	return minetest.place_schematic(pos, path .. "oak" .. tostring(math.random(1,3)) .. ".mts", 'random', nil, false, flags)
end

qtcore.grow_aspen_tree = function(pos)
	--local name = {"aspen1","aspen2"}[math.random(1,2)]
	return minetest.place_schematic(pos, path .. "aspen" .. tostring(math.random(1,2)) .. ".mts", 'random', nil, false, flags)
end

qtcore.grow_apple_tree = function(pos)
	return minetest.place_schematic(pos, path .. "apple1.mts", 'random', nil, false, flags)
end

qtcore.grow_rowan_tree = function(pos)
	return minetest.place_schematic(pos, path .. "rowan1.mts", 'random', nil, false, flags)
end

qtcore.grow_lantern_tree = function(pos)
	return minetest.place_schematic(pos, path .. "lantern" .. tostring(math.random(1,2)) .. ".mts", 'random', nil, false, flags)
end

qtcore.grow_coffee_tree = function(pos)
	return minetest.place_schematic(pos, path .. "coffee1.mts", 'random', nil, false, flags)
end

qtcore.grow_mahogany_tree = function(pos)
	return minetest.place_schematic(pos, path .. "mahogany" .. tostring(math.random(1,2)) .. ".mts", 'random', nil, false, flags)
end

--blackwood?

qtcore.grow_rosewood_tree = function(pos)
	return minetest.place_schematic(pos, path .. "rosewood1.mts", 'random', nil, false, flags)
end



qtcore.grow_swamp_tree = function(pos)
	return minetest.place_schematic(pos, path .. "swamp_tree1.mts", 'random', nil, false, flags)
end

qtcore.grow_blue_mushroom = function(pos)
	return minetest.place_schematic(pos, path .. "blue_shroom" .. tostring(math.random(1,2)) .. ".mts", 'random', nil, false, flags)
end

qtcore.grow_gold_mushroom = function(pos)
	return minetest.place_schematic(pos, path .. "tree_gold_shroom1.mts", 'random', nil, false, flags)
end

qtcore.grow_pine_tree = function(pos)
	return minetest.place_schematic(pos, path .. "pine_tree1.mts", 'random', nil, false, flags)
end

qtcore.grow_palm_tree = function(pos)
	return minetest.place_schematic(pos, path .. "palm_tree1.mts", 'random', nil, false, flags)
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
	chance = 80,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_oak1", {
	schematic = path .. "oak1.mts",
	chance = 70,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_oak2", {
	schematic = path .. "oak2.mts",
	chance = 70,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_oak3", {
	schematic = path .. "oak3.mts",
	chance = 70,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_aspen1", {
	schematic = path .. "aspen1.mts",
	chance = 70,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_aspen2", {
	schematic = path .. "aspen2.mts",
	chance = 70,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_rowan", {
	schematic = path .. "rowan1.mts",
	chance = 80,
	biomes = {"woods"},
	nodes = {"default:dirt_with_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_coffee", {
	schematic = path .. "coffee1.mts",
	chance = 80,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_mahogany1", {
	schematic = path .. "mahogany1.mts",
	chance = 70,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_mahogany2", {
	schematic = path .. "mahogany2.mts",
	chance = 70,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_lantern1", {
	schematic = path .. "lantern1.mts",
	chance = 70,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_lantern2", {
	schematic = path .. "lantern2.mts",
	chance = 70,
	biomes = {"rainforest"},
	nodes = {"default:dirt_with_rainforest_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_rosewood1", {
	schematic = path .. "rosewood1.mts",
	chance = 70,
	biomes = {"prarie"},
	nodes = {"default:dirt_with_prarie_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_swamp", {
	schematic = path .. "swamp_tree1.mts",
	chance = 70,
	biomes = {"swamp"},
	nodes = {"default:dirt_with_swamp_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_small_blue_shroom", {
	schematic = path .. "blue_shroom2.mts",
	chance = 70,
	biomes = {"mushroom_forest"},
	nodes = {"default:dirt_with_mushroom_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_large_blue_shroom", {
	schematic = path .. "blue_shroom2.mts",
	chance = 85,
	biomes = {"mushroom_forest"},
	nodes = {"default:dirt_with_mushroom_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_brown_shroom", {
	schematic = path .. "brown_shroom1.mts",
	chance = 2000,
	biomes = {"mushroom_forest"},
	nodes = {"default:dirt_with_mushroom_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_gold_shroom_1", {
	schematic = path .. "gold_shroom1.mts",
	chance = 93,
	biomes = {"mushroom_forest"},
	nodes = {"default:dirt_with_mushroom_grass"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_palm", {
	schematic = path .. "palm_tree1.mts",
	chance = 200,
	biomes = {"beach"},
	nodes = {"default:sand"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})

qts.worldgen.register_structure("tree_pine", {
	schematic = path .. "pine_tree1.mts",
	chance = 90,
	biomes = {"snow"},
	nodes = {"default:dirt_with_snow"},
	force_place = false,
	rotate = true,
	flags = qts.worldgen.centers(true, false, true),
})