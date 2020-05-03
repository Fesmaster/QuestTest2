
--Wood planks
minetest.register_craft({
	output = "default:oak_wood_planks 4",
	recipe = {
		{"default:oak_log"},
	}
})

minetest.register_craft({
	output = "default:rowan_wood_planks 4",
	recipe = {
		{"default:rowan_log"},
	}
})

minetest.register_craft({
	output = "default:apple_wood_planks 4",
	recipe = {
		{"default:apple_log"},
	}
})

minetest.register_craft({
	output = "default:aspen_wood_planks 4",
	recipe = {
		{"default:aspen_log"},
	}
})

minetest.register_craft({
	output = "default:lanternfruit_wood_planks 4",
	recipe = {
		{"default:lanterfruit_log"},
	}
})

minetest.register_craft({
	output = "default:coffee_wood_planks 4",
	recipe = {
		{"default:coffee_log"},
	}
})

minetest.register_craft({
	output = "default:rosewood_wood_planks 4",
	recipe = {
		{"default:rosewood_log"},
	}
})

--stick
minetest.register_craft({
	output = "default:stick 4",
	recipe = {
		{"group:wood"},
	}
})



--fences
minetest.register_craft({
	output = "default:oak_wood_fence 4",
	recipe = {
		{ "default:oak_wood_planks", 'group:stick', "default:oak_wood_planks" },
		{ "default:oak_wood_planks", 'group:stick', "default:oak_wood_planks" },
	}
})

minetest.register_craft({
	output = "default:rowan_wood_fence 4",
	recipe = {
		{ "default:rowan_wood_planks", 'group:stick', "default:rowan_wood_planks" },
		{ "default:rowan_wood_planks", 'group:stick', "default:rowan_wood_planks" },
	}
})
minetest.register_craft({
	output = "default:apple_wood_fence 4",
	recipe = {
		{ "default:apple_wood_planks", 'group:stick', "default:apple_wood_planks" },
		{ "default:apple_wood_planks", 'group:stick', "default:apple_wood_planks" },
	}
})
minetest.register_craft({
	output = "default:aspen_wood_fence 4",
	recipe = {
		{ "default:aspen_wood_planks", 'group:stick', "default:aspen_wood_planks" },
		{ "default:aspen_wood_planks", 'group:stick', "default:aspen_wood_planks" },
	}
})
minetest.register_craft({
	output = "default:lanternfruit_wood_fence 4",
	recipe = {
		{ "default:lanternfruit_wood_planks", 'group:stick', "default:lanternfruit_wood_planks" },
		{ "default:lanternfruit_wood_planks", 'group:stick', "default:lanternfruit_wood_planks" },
	}
})
minetest.register_craft({
	output = "default:coffee_wood_fence 4",
	recipe = {
		{ "default:coffee_wood_planks", 'group:stick', "default:coffee_wood_planks" },
		{ "default:coffee_wood_planks", 'group:stick', "default:coffee_wood_planks" },
	}
})
minetest.register_craft({
	output = "default:rosewood_wood_fence 4",
	recipe = {
		{ "default:rosewood_wood_planks", 'group:stick', "default:rosewood_wood_planks" },
		{ "default:rosewood_wood_planks", 'group:stick', "default:rosewood_wood_planks" },
	}
})


--toolrepair
minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})


--smelting

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:stone_cobble",
})

--fuel
minetest.register_craft({
	type = "fuel",
	recipe = "group:log",
	burntime = 30,
})
