

minetest.register_craftitem("default:jem_ruby", {
	description = "Ruby Gemstone",
	inventory_image = "default_jem_ruby.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_ruby", {
	description = "Ruby in Stone",
	tiles = {"default_stone.png^default_stone_with_ruby.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_ruby",
})

minetest.register_craftitem("default:jem_fire_opal", {
	description = "Fire Opal Gemstone",
	inventory_image = "default_jem_fire_opal.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_fire_opal", {
	description = "Fire Opal in Stone",
	tiles = {"default_stone.png^default_stone_with_fire_opal.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_fire_opal",
})

minetest.register_craftitem("default:jem_citrine", {
	description = "Citrine Gemstone",
	inventory_image = "default_jem_citrine.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_citrine", {
	description = "Citrine in Stone",
	tiles = {"default_stone.png^default_stone_with_citrine.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_citrine",
})

minetest.register_craftitem("default:jem_emerald", {
	description = "Emerald Gemstone",
	inventory_image = "default_jem_emerald.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_emerald", {
	description = "Emerald in Stone",
	tiles = {"default_stone.png^default_stone_with_emerald.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_emerald",
})

minetest.register_craftitem("default:jem_diamond", {
	description = "Diamond Gemstone",
	inventory_image = "default_jem_diamond.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_diamond", {
	description = "Diamond in Stone",
	tiles = {"default_stone.png^default_stone_with_diamond.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_diamond",
})

minetest.register_craftitem("default:jem_sapphire", {
	description = "Sapphire Gemstone",
	inventory_image = "default_jem_sapphire.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_sapphire", {
	description = "Sapphire in Stone",
	tiles = {"default_stone.png^default_stone_with_sapphire.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_sapphire",
})

minetest.register_craftitem("default:jem_amathest", {
	description = "Amathest Gemstone",
	inventory_image = "default_jem_amathest.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_amathest", {
	description = "Amathest in Stone",
	tiles = {"default_stone.png^default_stone_with_amathest.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_amathest",
})

minetest.register_craftitem("default:jem_oynx", {
	description = "Oynx Gemstone",
	inventory_image = "default_jem_oynx.png",
	groups = {jem = 1,},
})

qts.register_shaped_node("default:stone_with_oynx", {
	description = "Oynx in Stone",
	tiles = {"default_stone.png^default_stone_with_oynx.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:jem_oynx",
})
