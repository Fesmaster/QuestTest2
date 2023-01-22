--[[
INDEX




]]
--Begin Equipment

minetest.register_node("default:storage_pot_greenware", {
	description = "Greenware Storage Pot",
	tiles = {
		"default_dishes_clay_greenware.png",
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -3/16, -7/16, -3/16, -2/16, -6/16, 3/16, },
			{ 2/16, -7/16, -3/16, 3/16, -6/16, 3/16, },
			{ -3/16, -7/16, -3/16, 3/16, -6/16, -2/16, },
			{ -3/16, -7/16, 2/16, 3/16, -6/16, 3/16, },
			{ -4/16, -6/16, -4/16, 4/16, -1/16, -3/16, },
			{ 3/16, -6/16, -4/16, 4/16, -1/16, 4/16, },
			{ -4/16, -6/16, 3/16, 4/16, -1/16, 4/16, },
			{ -4/16, -6/16, -4/16, -3/16, -1/16, 4/16, },
			{ -3/16, -1/16, 2/16, 3/16, 0/16, 3/16, },
			{ -3/16, -1/16, -3/16, 3/16, 0/16, -2/16, },
			{ 2/16, -1/16, -3/16, 3/16, 0/16, 3/16, },
			{ -3/16, -1/16, -3/16, -2/16, 0/16, 3/16, },
			{ -2/16, -1/16, -2/16, -1/16, 3/16, 2/16, },
			{ 1/16, -1/16, -2/16, 2/16, 3/16, 2/16, },
			{ -2/16, -1/16, -2/16, 2/16, 3/16, -1/16, },
			{ -2/16, -1/16, 1/16, 2/16, 3/16, 2/16, },
			{ -3/16, 3/16, -3/16, -1/16, 4/16, 3/16, },
			{ 1/16, 3/16, -3/16, 3/16, 4/16, 3/16, },
			{ -3/16, 3/16, -3/16, 3/16, 4/16, -1/16, },
			{ -3/16, 3/16, 1/16, 3/16, 4/16, 3/16, },
			},
		},
})

minetest.register_node("default:alchemy_equipment_basic", {
	description = "Basic Alchemy Equipment",
	tiles = {
		"default_alchemy_equipment_basic_top.png",  
		"default_dishes_clay.png", 
		"default_alchemy_equipment_basic_side.png",
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, -4/16, -2/16, -3/16, -1/16, },
			{ -4/16, -3/16, -3/16, -3/16, -2/16, -2/16, },
			{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
			{ -5/16, -8/16, 1/16, -1/16, -3/16, 2/16, },
			{ -5/16, -8/16, 4/16, -1/16, -3/16, 5/16, },
			{ -2/16, -8/16, 1/16, -1/16, -3/16, 5/16, },
			{ -5/16, -8/16, 1/16, -4/16, -3/16, 5/16, },
			{ 1/16, -8/16, -4/16, 3/16, -7/16, -2/16, },
			{ 0/16, -7/16, -2/16, 4/16, -6/16, -1/16, },
			{ 0/16, -7/16, -5/16, 4/16, -6/16, -4/16, },
			{ 0/16, -7/16, -5/16, 1/16, -6/16, -1/16, },
			{ 3/16, -7/16, -5/16, 4/16, -6/16, -1/16, },
			{ 4/16, -6/16, -6/16, 5/16, -5/16, 0/16, },
			{ -1/16, -6/16, -6/16, 0/16, -5/16, 0/16, },
			{ -1/16, -6/16, -1/16, 5/16, -5/16, 0/16, },
			{ -1/16, -6/16, -6/16, 5/16, -5/16, -5/16, },
			{ 6/16, -8/16, -1/16, 7/16, -7/16, 2/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:alchemy_equipment_advanced", {
	description = "Advanced Alchemy Equipment",
	tiles = {
		"default_alchemy_equipment_advanced_top.png",  
		"default_dishes_clay.png", 
		"default_alchemy_equipment_advanced_side.png",
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, 2/16, -2/16, -4/16, 3/16, },
			{ -2/16, -8/16, 1/16, -1/16, -3/16, 2/16, },
			{ -2/16, -8/16, 3/16, -1/16, -3/16, 4/16, },
			{ -4/16, -8/16, 3/16, -3/16, -3/16, 4/16, },
			{ -4/16, -8/16, 1/16, -3/16, -3/16, 2/16, },
			{ -4/16, -3/16, 1/16, -1/16, -2/16, 4/16, },
			{ -4/16, -8/16, 1/16, -1/16, -6/16, 4/16, },
			{ -4/16, -2/16, 0/16, -1/16, -1/16, 1/16, },
			{ -4/16, -2/16, 4/16, -1/16, -1/16, 5/16, },
			{ -1/16, -2/16, 1/16, 0/16, -1/16, 4/16, },
			{ -5/16, -2/16, 1/16, -4/16, -1/16, 4/16, },
			{ -4/16, -8/16, -5/16, -2/16, -7/16, -3/16, },
			{ -4/16, -7/16, -6/16, -2/16, -6/16, -5/16, },
			{ -4/16, -7/16, -3/16, -2/16, -6/16, -2/16, },
			{ -2/16, -7/16, -5/16, -1/16, -6/16, -3/16, },
			{ -5/16, -7/16, -5/16, -4/16, -6/16, -3/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})
--End Equipment

--Begin Items
qts.register_ingot("default:wax_palm", {
	description = "Palm Wax",
	inventory_image = "default_wax_palm_item.png",
	tiles = {
		"default_wax_palm_ingot.png"
	},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = {
			{ -6/16, -8/16, 1/16, -3/16, -6/16, 6/16, },
			{ -2/16, -8/16, 1/16, 1/16, -6/16, 6/16, },
			{ 2/16, -8/16, 1/16, 5/16, -6/16, 6/16, },
			{ -6/16, -8/16, -6/16, -3/16, -6/16, -1/16, },
			{ -2/16, -8/16, -6/16, 1/16, -6/16, -1/16, },
			{ 2/16, -8/16, -6/16, 5/16, -6/16, -1/16, },
			{ 0/16, -6/16, -2/16, 3/16, -4/16, 3/16, },
			{ -4/16, -6/16, -3/16, -1/16, -4/16, 2/16, },
			},
	levels = 8,
})

qts.register_ingot("default:soap", {
	description = "Soap",
	inventory_image = "default_soap_item.png",
	tiles = {
		"default_soap_ingot.png"
	},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = {
			{ -6/16, -8/16, 1/16, -3/16, -6/16, 6/16, },
			{ -2/16, -8/16, 1/16, 1/16, -6/16, 6/16, },
			{ 2/16, -8/16, 1/16, 5/16, -6/16, 6/16, },
			{ -6/16, -8/16, -6/16, -3/16, -6/16, -1/16, },
			{ -2/16, -8/16, -6/16, 1/16, -6/16, -1/16, },
			{ 2/16, -8/16, -6/16, 5/16, -6/16, -1/16, },
			{ 0/16, -6/16, -2/16, 3/16, -4/16, 3/16, },
			{ -4/16, -6/16, -3/16, -1/16, -4/16, 2/16, },
			},
	levels = 8,
})

minetest.register_node("default:potash", {
	description = "Potash",
	tiles = {
		"default_potash_top.png",
		"default_oak_wood.png",
		"default_potash_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_potash.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})

minetest.register_node("default:lye", {
	description = "Lye",
	tiles = {
		"default_lye_top.png",
		"default_oak_wood.png",
		"default_lye_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_lye.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})

minetest.register_node("default:flask_glass", {
	description = "Glass Flask",
	tiles = {
		"default_flask_glass_top.png",
		"default_flask_glass_bottom.png",
		"default_flask_glass_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_flask_glass_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -4/16, 2/16, },
			{ -1/16, -4/16, -1/16, 1/16, -1/16, 1/16, },
		},
	},
})

minetest.register_node("default:flask_glass_water", {
	description = "Glass Water Flask",
	tiles = {
		"default_flask_glass_top.png",
		"default_flask_glass_bottom.png",
		"default_flask_glass_water_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_flask_glass_water_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -4/16, 2/16, },
			{ -1/16, -4/16, -1/16, 1/16, -1/16, 1/16, },
		},
	},
})
--[[
minetest.register_craftitem("default:flask_glass", {
	description = "Glass Flask",
	inventory_image = "default_flask_glass.png",
})

minetest.register_craftitem("default:flask_glass_water", {
	description = "Flask of Water",
	inventory_image = "default_flask_glass_water.png",
})
]]--
--End Items

--Begin Crafting
--soap crafting from oil in with vessel registration for code condensation (in food.lua)

--craftitem crafting
qts.register_craft({
	ingredients = { "default:palm_log"},
	results = {"default:wax_palm 4"},
	near = {"group:ttable", "group:dishes", "group:furnace"},
})

--[[qts.register_craft({
	ingredients = { "default:wax_palm", "default:potash", "default:lime"},
	results = {"default:soap"},
	near = {"group:ttable", "group:dishes", "group:furnace"},
})]]--

qts.register_craft({
	ingredients = { "default:wax_palm", "default:lye"},
	results = {"default:soap"},
	near = {"group:ttable", "group:dishes", "group:furnace"},
})

qts.register_craft({
	ingredients = {"default:glass"},
	results = {"default:flask_glass"},
	near = {"group:furnace"}
})

qts.register_craft({
	ingredients = {"default:flask_glass", "default:bucket_default_water"},
	results = {"default:flask_glass_water", "default:bucket"},
})

qts.register_craft({
	ingredients = {"default:flask_glass", "default:bucket_default_river_water"},
	results = {"default:flask_glass_water", "default:bucket"},
})


--lye crafting
qts.register_craft({
	ingredients = {"default:lime", "default:potash", "default:bucket_default_water"},
	results = {"default:lye", "default:bucket"},
	near = {"group:dishes", "group:ttable", "group:furnace"},
})
qts.register_craft({
	ingredients = {"default:lime 4", "default:potash 4", "default:bucket_default_water"},
	results = {"default:lye 4", "default:bucket"},
	near = {"group:dishes"},
})

qts.register_craft({
	ingredients = {"default:lime 16", "default:potash 16", "default:bucket_default_water"},
	results = {"default:lye 16", "default:bucket"},
	near = {"group:dishes"},
})

qts.register_craft({
	ingredients = {"default:lime", "default:potash", "default:bucket_default_river_water"},
	results = {"default:lye", "default:bucket"},
	near = {"group:dishes"},
})

qts.register_craft({
	ingredients = {"default:lime 4", "default:potash 4", "default:bucket_default_river_water"},
	results = {"default:lye 4", "default:bucket"},
	near = {"group:dishes"},
})

qts.register_craft({
	ingredients = {"default:lime 16", "default:potash 16", "default:bucket_default_river_water"},
	results = {"default:lye 16", "default:bucket"},
	near = {"group:dishes"},
})

--equipment crafting
qts.register_craft({
	ingredients = {"default:dishes_clay 2"},
	results = {"default:alchemy_equipment_basic"},
})

qts.register_craft({
	ingredients = {"default:dishes_clay", "default:iron_bar"},
	results = {"default:alchemy_equipment_advanced"},
	near = {"group:workbench", "default:anvil"},
})

qts.register_craft({
	ingredients = {"default:dishes_clay", "default:steel_bar"},
	results = {"default:alchemy_equipment_advanced"},
	near = {"group:workbench", "default:anvil"},
})