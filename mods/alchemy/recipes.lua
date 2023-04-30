--[[

]]

qts.register_craft({
	ingredients = { "overworld:palm_log"},
	results = {"alchemy:wax_palm 4"},
	near = {"group:table", "group:dishes", "group:furnace"},
})

--soap
qts.register_craft({
	ingredients = { "alchemy:wax_palm", "alchemy:lye"},
	results = {"alchemy:soap"},
	near = {"group:table", "group:dishes", "group:furnace"},
})

qts.register_craft({
	ingredients = {"craftable:glass"},
	results = {"alchemy:flask_glass"},
	near = {"group:furnace"}
})


--water vessels
qts.register_craft({
	ingredients = {"alchemy:flask_glass", "tools:bucket_wood_overworld_water"},
	results = {"alchemy:flask_glass_water", "tools:bucket_wood"},
})

qts.register_craft({
	ingredients = {"alchemy:flask_glass", "tools:bucket_wood_overworld_river_water"},
	results = {"alchemy:flask_glass_water", "tools:bucket_wood"},
})


--lye crafting
qts.register_craft({
	ingredients = {"craftable:lime", "alchemy:potash", "tools:bucket_wood_overworld_water"},
	results = {"alchemy:lye", "tools:bucket_wood"},
	near = {"group:dishes", "group:table", "group:furnace"},
})
qts.register_craft({
	ingredients = {"craftable:lime 4", "alchemy:potash 4", "tools:bucket_wood_overworld_water"},
	results = {"alchemy:lye 4", "tools:bucket_wood"},
	near = {"group:dishes", "group:table", "group:furnace"},
})

qts.register_craft({
	ingredients = {"craftable:lime 16", "alchemy:potash 16", "tools:bucket_wood_overworld_water"},
	results = {"alchemy:lye 16", "tools:bucket_wood"},
	near = {"group:dishes", "group:table", "group:furnace"},
})

qts.register_craft({
	ingredients = {"craftable:lime", "alchemy:potash", "tools:bucket_wood_overworld_river_water"},
	results = {"alchemy:lye", "tools:bucket_wood"},
	near = {"group:dishes", "group:table", "group:furnace"},
})

qts.register_craft({
	ingredients = {"craftable:lime 4", "alchemy:potash 4", "tools:bucket_wood_overworld_river_water"},
	results = {"alchemy:lye 4", "tools:bucket_wood"},
	near = {"group:dishes", "group:table", "group:furnace"},
})

qts.register_craft({
	ingredients = {"craftable:lime 16", "alchemy:potash 16", "tools:bucket_wood_overworld_river_water"},
	results = {"alchemy:lye 16", "tools:bucket_wood"},
	near = {"group:dishes", "group:table", "group:furnace"},
})

--equipment crafting
qts.register_craft({
	ingredients = {"default:dishes_clay 2"},
	results = {"alchemy:equipment_basic"},
})

qts.register_craft({
	ingredients = {"default:dishes_clay", "overworld:steel_bar"},
	results = {"alchemy:equipment_advanced"},
	near = {"group:workbench", "group:anvil"},
})