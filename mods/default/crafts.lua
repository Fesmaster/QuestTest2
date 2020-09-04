
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

minetest.register_craft({
	output = "default:mahogany_wood_planks 4",
	recipe = {
		{"default:mahogany_log"},
	}
})

--mahogany_wood_planks
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

--knife recipies

minetest.register_craft({
	output = "default:knife_flint",
	recipe = {
		{ "default:flint"},
		{ "default:stick"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:tinder",
	recipe = {
		 "default:knife_flint", 
		 "group:stick"
	},
	replacements = {
		{"default:knife_flint", "default:knife_flint"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:tinder 4",
	recipe = {
		"default:knife_flint", 
		'group:stick', 
		'group:stick', 
		'group:stick', 
		'group:stick'
	},
	replacements = {
		{"default:knife_flint", "default:knife_flint"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:tinder 8",
	recipe = {
		"default:knife_flint", 
		'group:stick', 
		'group:stick', 
		'group:stick', 
		'group:stick', 
		'group:stick', 
		'group:stick', 
		'group:stick', 
		'group:stick'
	},
	replacements = {
		{"default:knife_flint", "default:knife_flint"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:tinder",
	recipe = {
		 "default:knife_flint", 
		 "group:leaves"
	},
	replacements = {
		{"default:knife_flint", "default:knife_flint"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:tinder 4",
	recipe = {
		 "default:knife_flint", 
		 "group:leaves",
		 "group:leaves",
		 "group:leaves",
		 "group:leaves"
	},
	replacements = {
		{"default:knife_flint", "default:knife_flint"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:tinder 8",
	recipe = {
		 "default:knife_flint", 
		 "group:leaves",
		 "group:leaves",
		 "group:leaves",
		 "group:leaves",
		 "group:leaves",
		 "group:leaves",
		 "group:leaves",
		 "group:leaves"
	},
	replacements = {
		{"default:knife_flint", "default:knife_flint"}
	}
})

--various other

minetest.register_craft({
	output = "default:tinderbox",
	recipe = {
		{ "group:stick", 'group:stick', "group:stick" },
		{ "default:tinder", 'default:flint', "default:tinder" },
		{ "default:tinder", 'default:tinder', "default:tinder" },
	}
})

minetest.register_craft({
	output = "default:campfire",
	recipe = {
		{ "group:wood", "", "group:wood" },
		{ "", "group:wood", "" },
		{ "group:wood", "", "group:wood" },
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

minetest.register_craft({
	type = "cooking",
	output = "default:calcium_oxide",
	recipe = "default:shell_peices",
})

minetest.register_craft({
	type = "cooking",
	output = "default:brick_single",
	recipe = "default:clay_lump",
})


--fuel
minetest.register_craft({
	type = "fuel",
	recipe = "group:log",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 7,
})

minetest.register_craft({
	output = "default:crate",
	recipe = {
		{ "default:stick", 'group:stick', "default:stick" },
		{ "default:stick", '', "default:stick" },
		{ "default:stick", 'group:stick', "default:stick" },
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "foundry:spout",
	recipe = {
		 "default:cement", 
		 "default:clay_lump"
	},
})


minetest.register_craft({
	output = "foundry:foundry_inactive",
	recipe = {
		{ "", 'default:brick', "" },
		{ "default:brick", "default:cement", "default:brick" },
		{ "", 'default:brick', "" },
	}
})

minetest.register_craft({
	output = "default:brick",
	recipe = {
		{ "default:brick_single", 'default:brick_single', "" },
		{ "default:brick_single", "default:brick_single", "" },
		{ "", '', "" },
	}
})

minetest.register_craft({
	output = "default:cement 4",
	recipe = {
		{ "", 'group:sand', "" },
		{ "group:sand", "default:calcium_oxide", "group:sand" },
		{ "", 'group:sand', "" },
	}
})

minetest.register_craft({
	output = "default:clay",
	recipe = {
		{ "default:clay_lump", 'default:clay_lump', "" },
		{ "default:clay_lump", "default:clay_lump", "" },
		{ "", '', "" },
	}
})