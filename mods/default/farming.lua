--[[
stuff related to farming
--]]

--this will need to change when stuff is added
local function SeedPlace(itemstack, placer, pointed_thing)
	return minetest.item_place(itemstack, placer, pointed_thing)
end

minetest.register_node("default:seed_wheat", {
	description = "Wheat Seeds",
	inventory_image = "default_seeds_wheat_item.png",
	wield_image = "default_seeds_wheat_item.png",
	tiles = {"default_seeds_wheat_top.png", "default_oak_wood.png", "default_seeds_wheat_side.png"},
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {attached_node=1, seeds=1, oddly_breakable_by_hand=3, dig_immediate=1},
	sounds = qtcore.node_sound_defaults(),
	node_box = qtcore.nb_dustpile(),
	on_place = SeedPlace,
})

---[[
minetest.register_node("default:seed_milfoil", {
	description = "Milfoil Seeds",
	inventory_image = "default_seeds_milfoil_item.png",
	wield_image = "default_seeds_milfoil_item.png",
	tiles = {"default_seeds_milfoil_top.png", "default_oak_wood.png", "default_seeds_milfoil_side.png"},
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {attached_node=1, seeds=1, oddly_breakable_by_hand=3, dig_immediate=1},
	sounds = qtcore.node_sound_defaults(),
	node_box = qtcore.nb_dustpile(),
	on_place = SeedPlace,
})

minetest.register_node("default:seed_bloodbulb", {
	description = "Bloodbulb Seeds",
	inventory_image = "default_seeds_bloodbulb_item.png",
	wield_image = "default_seeds_bloodbulb_item.png",
	tiles = {"default_seeds_bloodbulb_top.png", "default_oak_wood.png", "default_seeds_bloodbulb_side.png"},
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {attached_node=1, seeds=1, oddly_breakable_by_hand=3, dig_immediate=1},
	sounds = qtcore.node_sound_defaults(),
	node_box = qtcore.nb_dustpile(),
	on_place = SeedPlace,
})

minetest.register_node("default:seed_wolfshood", {
	description = "Wolfshood Seeds",
	inventory_image = "default_seeds_wolfshood_item.png",
	wield_image = "default_seeds_wolfshood_item.png",
	tiles = {"default_seeds_wolfshood_top.png", "default_oak_wood.png", "default_seeds_wolfshood_side.png"},
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {attached_node=1, seeds=1, oddly_breakable_by_hand=3, dig_immediate=1},
	sounds = qtcore.node_sound_defaults(),
	node_box = qtcore.nb_dustpile(),
	on_place = SeedPlace,
})
--]]