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


