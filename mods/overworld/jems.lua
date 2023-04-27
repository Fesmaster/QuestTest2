--[[

]]

local jems = {
	{name="ruby", desc="Ruby"},
	{name="fire_opal", desc="Fire Opal"},
	{name="citrine", desc="Citrine"},
	{name="emerald", desc="Emerald"},
	{name="diamond", desc="Diamond"},
	{name="sapphire", desc="Sapphire"},
	{name="amathest", desc="Amathest"},
	{name="oynx", desc="Oynx"},
}

for i, jem in ipairs(jems) do
	
	minetest.register_craftitem("overworld:jem_"..jem.name, {
		description = jem.desc.." Gemstone",
		inventory_image = "default_jem_"..jem.name..".png",
		groups = {jem = 1,},
	})
	
	qts.register_shaped_node("overworld:stone_with_"..jem.name, {
		description = jem.desc.." in Stone",
		tiles = {"default_stone.png^default_stone_with_"..jem.name..".png"},
		groups = {cracky=3, stone=1, ore=1},
		sounds = qtcore.node_sound_stone(),
		drop = "overworld:jem_"..jem.name,
	})

	qtcore.register_material("jem", {
		name=jem.name,
		desc = jem.desc,
		item = "overworld:jem_"..jem.name,
		ore = "overworld:stone_with_"..jem.name,
	})

end 

--Coal
--While not a traditional gemstone, Coal has no other logical place to go

minetest.register_craftitem("overworld:coal", {
	description = "Coal Lump",
	inventory_image = "default_coal.png",
	groups = {coal = 1,},
})

qts.register_shaped_node("overworld:stone_with_coal", {
	description = "Coal in Stone",
	tiles = {"default_stone.png^default_stone_with_coal.png"},
	groups = {cracky=3, stone=1, ore=1},
	sounds = qtcore.node_sound_stone(),
	drop = "overworld:coal",
})

--Traditional Gemstones
--[[
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
]]