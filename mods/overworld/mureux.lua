--[[
	Murex plant in the jungle
	and its really fun projectile
--]]

minetest.register_node("overworld:mureux_plant", {
	description = "Mureux Plant",
	tiles ={"overworld_mureux_empty.png"},
	inventory_image = "overworld_mureux.png",
	wield_image = "overworld_mureux.png",
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, growable=1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	place_param2 = 18,
	--on_place = qtcore.place_random_plantlike,
	--drop = {},
	--on_flood = floodFunc,
})

minetest.register_node("overworld:mureux_plant_ripe", {
	description = "Mureux Plant (Ripe)",
	tiles ={"overworld_mureux_ripe.png"},
	inventory_image = "overworld_mureux.png",
	wield_image = "overworld_mureux.png",
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, growable=1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	place_param2 = 18,
	light_source = 4,
	drop = {
		max_items=2,
		items={{items={
			"overworld:mureux_plant",
			"overworld:mureux_fruit",
		}}}
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local itemname = itemstack:get_name()
		if minetest.get_item_group(itemname, "knife") ~= 0 then
			local inv = clicker:get_inventory()
			local leftovers = inv:add_item("main", "overworld:herb_mureux_fruit 1")
			if leftovers then
				minetest.add_item(pos, leftovers)
			end
			minetest.set_node(pos, {name="overworld:herb_mureux", param2 = 18})
			if not (qts.is_player_creative(clicker)) then
				qts.apply_default_wear(itemstack, node.name)
			end
		end
		return itemstack
	end,
	--on_flood = floodFunc,
})

minetest.register_craftitem("overworld:mureux_fruit", {
	description = "Mureux Fruit",
	inventory_image = "overworld_mureux_fruit.png",
	on_secondary_use = function(itemstack, user, pointed_thing)

		qts.projectile_launch_player("overworld:mureux_fruit_projectile", user, 0)

		if not (qts.is_player_creative(user)) then
			itemstack:take_item()
		end
		return itemstack
	end,
	on_place = qts.item_place_check_and_propigate,
})



minetest.register_node("overworld:mureux_goo", {
	description = "Mureux Fruit Goo",
	tiles = {"overworld_mureux_goo.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3, generation_replacable=1},
	light_source = 4,
	node_box = {
		type = "connected",
		disconnected_bottom = {-8/16, -8/16, -8/16, 8/16, -7/16, 8/16},
		disconnected_top = {-8/16, 7/16, -8/16, 8/16, 8/16, 8/16},
		disconnected_front = {-8/16, -8/16, -8/16, 8/16, 8/16, -7/16},
		disconnected_back = {-8/16, -8/16, 7/16, 8/16, 8/16, 8/16},
		disconnected_left = {-8/16, -8/16, -8/16, -7/16, 8/16, 8/16},
		disconnected_right = {7/16, -8/16, -8/16, 8/16, 8/16, 8/16},
	},
	connects_to = {"overworld:mureux_goo", "group:underbrush", "group:generation_replacable", "group:liquid"},
	sounds = qtcore.node_sound_wood(),
	drop = "", --intentional no drop
	floodable=true,
	on_node_update = function(pos)
		local has_solid = false
		for i, p in ipairs({vector.new(-1,0,0),vector.new(1,0,0),vector.new(0,-1,0),vector.new(0,1,0),vector.new(0,0,-1),vector.new(0,0,1)}) do
			local node = minetest.get_node_or_nil(p+pos)
			if node and node.name then
				if (
					minetest.get_item_group(node.name, "generation_replacable") == 0 and
					minetest.get_item_group(node.name, "underbrush") == 0 and
					node.name ~= "overworld:mureux_goo"
				) then
					has_solid = true
					break
				end
			end
		end
		if not has_solid then
			minetest.set_node(pos, {name="air"}) --intentional no drops
		end
	end,
})

local function scatter_goop(pos)
	local nodes = qts.get_nodes_in_radius(pos, 2, function(pos, node) return node and node.name == "air" end)
	for i, dat in ipairs(nodes) do
		if dat.noderef and dat.noderef.name and dat.noderef.name == "air" then
			minetest.place_node(dat.pos, {name="overworld:mureux_goo"})
		end
	end
end

-- function(self, pos, node)
qts.register_projectile("overworld:mureux_fruit_projectile", {
    visual="wielditem",
    visual_size = vector.new(0.25,0.25,0.25),
    use_texture_alpha=true,
    textures ={"overworld:mureux_fruit"},
    automatic_rotate=true,
    
    radius = 0.25,
    selectable = false,
    gravity_scale = 0.5,
    collectable = "", --TO CHANGE
    lifetime=60*1,
    speed = 10,
    damage_groups = {},

    on_strike_node = function(self, pos, node)
		scatter_goop(pos)
		
		self.object:remove()
	end,
    on_strike_entity = qts.projectile_default_struck_entity,
    on_timeout = qts.projectile_default_timeout,
    on_step = function(self, dtime) end,
})

minetest.register_abm({
	label = "Mureux Growing",
	nodenames = {"overworld:mureux_plant"},
	neightbors = {"group:dirt"},
	interval = 60.0,
	chance = 3,
	action = function(pos, node, ac, acw)
		local below_p = pos+vector.new(0,-1,0)
		local below_n = minetest.get_node_or_nil(below_p)
		if below_n and below_n.name and minetest.get_item_group(below_n.name, "dirt") then
			minetest.swap_node(pos, {name="overworld:mureux_plant_ripe", param2 = 18})
		end
	end
})

minetest.register_abm({
	label = "Mureux Goo Growth from goo",
	nodenames = {"overworld:mureux_goo"},
	interval = 10,
	chance = 30,
	action = function(pos, node, ac, acw)
		local below_p = pos+vector.new(0,-1,0)
		local below_n = minetest.get_node_or_nil(below_p)
		if below_n and below_n.name and minetest.get_item_group(below_n.name, "dirt") then
			local chance = 20
			if below_n.name == "overworld:dirt_with_rainforest_grass" then
				chance = 5
			end
			if math.random(chance) == 1 then
				minetest.set_node(pos, {name="overworld:mureux_plant", param2 = 18})
				return
			end
		end
		minetest.set_node(pos, {name="air"})
	end
})


