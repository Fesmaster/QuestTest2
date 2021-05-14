local TREE_TIME = 90
local TREE_VAR = 30

qts.register_growable_node("default:oak_sapling", {
	description = "Oak Sapling",
	tiles ={"default_oak_leaves.png", "default_oak_leaves.png", 
		"default_oak_leaves.png^[lowpart:37:default_oak_side.png"},
	use_texture_alpha = "clip",
	groups = {snappy=3, flammable=2, sapling=1},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Oak tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_oak_tree(pos)
	end,
})

qts.register_growable_node("default:aspen_sapling", {
	description = "Aspen Sapling",
	tiles ={"default_aspen_leaves.png", "default_aspen_leaves.png", 
		"default_aspen_leaves.png^[lowpart:37:default_aspen_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Aspen tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_aspen_tree(pos)
	end,
})

qts.register_growable_node("default:apple_sapling", {
	description = "Apple Sapling",
	tiles ={"default_apple_leaves.png", "default_apple_leaves.png", 
		"default_apple_leaves.png^[lowpart:37:default_apple_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Apple tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_apple_tree(pos)
	end,
})



qts.register_growable_node("default:rowan_sapling", {
	description = "Rowan Sapling",
	tiles ={"default_rowan_leaves.png", "default_rowan_leaves.png", 
		"default_rowan_leaves.png^[lowpart:37:default_rowan_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Rowan tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_rowan_tree(pos)
	end,
})

qts.register_growable_node("default:lanternfruit_sapling", {
	description = "Lanternfruit Sapling",
	tiles ={"default_lanternfruit_leaves.png", "default_lanternfruit_leaves.png", 
		"default_lanternfruit_leaves.png^[lowpart:37:default_lanternfruit_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Lanternfruit tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_lantern_tree(pos)
	end,
})

qts.register_growable_node("default:coffeetree_sapling", {
	description = "Coffeetree Sapling",
	tiles ={"default_coffee_leaves.png", "default_coffee_leaves.png", 
		"default_coffee_leaves.png^[lowpart:37:default_coffee_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Coffeetree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_coffee_tree(pos)
	end,
})

qts.register_growable_node("default:mahogany_sapling", {
	description = "Mahogany Sapling",
	tiles ={"default_mahogany_leaves.png", "default_mahogany_leaves.png", 
		"default_mahogany_leaves.png^[lowpart:37:default_mahogany_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Mahogany tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_mahogany_tree(pos)
	end,
})



qts.register_growable_node("default:rosewood_sapling", {
	description = "Rosewood Sapling",
	tiles ={"default_rosewood_leaves.png", "default_rosewood_leaves.png", 
		"default_rosewood_leaves.png^[lowpart:37:default_rosewood_side.png"},
	use_texture_alpha = "clip",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_stone(),
	drawtype = "nodebox",
	paramtype = "light",
	node_box = qtcore.nb_sapling(),
	paramtype2 = "facedir",
	
	growable_nodes = {"group:soil"},
	grow_timer = TREE_TIME,
	grow_timer_random = TREE_VAR,
	on_grow = function(pos)
		minetest.log("info","An Rosewood tree has grown at "..minetest.pos_to_string(pos))
		minetest.set_node(pos, {name = "air"})
		qtcore.grow_rosewood_tree(pos)
	end,
})
