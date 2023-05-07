--[[
	Map Generation Calls
--]]

--[[
{

	nodes = {} or string			--list of possible nodename
	replace = {} or nil or string	--list of nodes that can be replaced, nil or {} to ignore
	above = {} or nil or string		--list of nodes that must be above, nil or {} to ignore
	below = {} or nil or string 	--list of nodes that must be below, nil or {} to ignore
	beside = {} or nil or string	--list of nodes that must be next to, nil or {} to ignore
	biomes = {} or nil or string	--list of the allowed biomes. nil or {} to ignore
	beside_count = 1-4 [1]			--how many of the beside nodes must be in the category. defaults to 1
	chance = number [100]			--one in x chance of placing this node. defaults to 100.
	stage = one of: ("pre-structre", "post-structure", "post-plant", "post-ore")
}
]]

qts.worldgen.register_scatter("lake-grassy", {
	nodes = {"dungeon:lake_generator"},
	replace = {"air"},
	below = {"overworld:dirt_with_grass"},
	chance = 5000,
	stage = "pre-structure",
})

qts.worldgen.register_scatter("camp-plains", {
	nodes = {"dungeon:camp_generator_plains"},
	replace = {"air"},
	below = {"overworld:dirt_with_grass"},
	chance = 6000,
	stage = "pre-structure",
})

qts.worldgen.register_scatter("camp-prarie", {
	nodes = {"dungeon:camp_generator_prarie"},
	replace = {"air"},
	below = {"overworld:dirt_with_prarie_grass"},
	chance = 6000,
	stage = "pre-structure",
})