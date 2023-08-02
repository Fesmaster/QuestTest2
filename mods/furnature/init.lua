--[[
    Furnature mod.
    This mod creates all the furnature types, using the various materials.
]]

dofile(minetest.get_modpath("furnature").."/wooden.lua")
dofile(minetest.get_modpath("furnature").."/wood_and_metal.lua")
dofile(minetest.get_modpath("furnature").."/stone.lua")


--[[
--bed stuff

minetest.register_node("default:bedroll_flax", {
	description = "Flaxen Badroll",
	tiles = {
		"default_textile_flax_top.png", 
		"default_textile_flax_top.png", 
		"default_textile_flax_side.png", 
		"default_textile_flax_side.png",  
		"default_textile_flax_end.png",  
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	--inventory_image = "default_textile_flax_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ 2/16, -7/16, -8/16, 7/16, -3/16, 8/16, },
			{ 2/16, -8/16, -8/16, 6/16, -2/16, 8/16, },
			{ 1/16, -7/16, -8/16, 6/16, -3/16, 8/16, },
			{ -24/16, -8/16, -8/16, 6/16, -7/16, 8/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

qts.register_craft({
	ingredients = {"default:textile_flax 2"},
	results = {"default:bedroll_flax"},
	near = {"group:workbench"},
})
--]]
