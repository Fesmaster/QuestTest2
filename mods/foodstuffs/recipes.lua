--[[

]]
qts.register_craft({
	ingredients = {"farmworks:herb_potatoe"},
	results = {"farmworks:seeds_potatoe"},
})

qts.register_craft({
	ingredients = {"foodstuffs:coffee_beans"},
	results = {"foodstuffs:coffee_grounds 2"},
	near = {"group:table", "group:dishes"},
})

qts.register_craft({
	ingredients = {"overworld:reeds 2"},
	results = {"foodstuffs:sugar"},
	near = {"group:table", "group:dishes", "group:furnace"},
})

qts.register_craft({
	ingredients = {"overworld:small_mushroom 2", "foodstuffs:dishes_clay"},
	results = {"foodstuffs:mushroom_stew", "foodstuffs:cup_clay"},
})

qts.register_craft({
	ingredients = {"overworld:small_mushroom 2", "foodstuffs:bowl_clay"},
	results = {"foodstuffs:mushroom_stew"},
	near = {"group:furnace", "group:cookware"}
})


--cookware
qts.register_craft({
	ingredients = {"overworld:iron_bar 3"},
	results = {"foodstuffs:cookware_iron"},
	near = {"group:furnace", "default:anvil"},
})

qts.register_craft({
	ingredients = {"overworld:copper_bar 3"},
	results = {"foodstuffs:cookware_copper"},
	near = {"group:furnace", "group:workbench"},
})
