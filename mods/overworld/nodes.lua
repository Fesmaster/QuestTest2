--[[
    misc. nodes from the overworld.
]]

minetest.register_node("overworld:shell_pieces", {
	description = "Shell Pieces",
	tiles = {
		"default_shell_pieces_top.png",
		"default_oak_wood.png",
		"default_shell_pieces_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_shell_pieces.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})