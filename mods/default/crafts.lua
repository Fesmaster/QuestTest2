
--wood permutations
local names = {"swamp", "rosewood", "pine", "oak", "mahogany", "lanternfruit", "coffee", "aspen", "apple", "rowan"}
for i, n in ipairs(names) do
	
	--crates
	qts.register_craft({
		ingredients = {"default:"..n.."_wood_planks 4"},
		results = {"default:crate_"..n},
		near = {"group:workbench"},
	})
	--bookshelf
	qts.register_craft({
		ingredients = {"default:"..n.."_wood_planks 3", "default:book 3"},
		results = {"default:bookshelf_"..n},
		near = {"group:workbench"},
	})
end

qts.register_craft({
	ingredients = {"default:herb_milfoil 2"},
	results = {"default:poltice_milfoil"},
})

qts.register_craft({
	ingredients = {"default:herb_flax 6"},
	results = {"default:textile_flax"},
})


--toolrepair
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})


