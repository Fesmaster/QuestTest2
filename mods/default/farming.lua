--[[
stuff related to farming
--]]


local function SeedPlace(plantname)
	return function(itemstack, placer, pointed_thing)
		if pointed_thing and pointed_thing.under then
			local node = minetest.get_node(pointed_thing.under)
			if minetest.get_item_group(node.name, "farmland") ~= 0 then
				minetest.item_place(ItemStack(plantname), placer, pointed_thing)
				itemstack:take_item(1);
				return itemstack
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing)
	end
end



local function register_farm_plant(name, def)
	
	minetest.register_node("default:seed_" .. name, {
		description = def.description.." Seeds",
		inventory_image = def.seed_image,
		wield_image = def.seed_image,
		tiles = def.seed_tiles,
		use_texture_alpha = "clip",
		sunlight_propagates = true,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {attached_node=1, seeds=1, oddly_breakable_by_hand=3, dig_immediate=1, generation_replacable=1},
		sounds = qtcore.node_sound_defaults(),
		node_box = qtcore.nb_dustpile(),
		on_place = SeedPlace("default:herb_"..name.."_1"),
	})
	
	minetest.register_craftitem("default:herb_" .. name, {
		description = def.description,
		inventory_image = def.item_image,
	})
	
	for i =1,def.plant_levels-1 do
		qts.register_growable_node("default:herb_"..name.."_"..i, {
			description = def.description.." Plant "..i,
			tiles ={ def.plant_tiles_list[i] },
			use_texture_alpha = "clip",
			groups = {snappy=3, flammable=2, herb_plant=1,not_in_creative_inventory=1},
			sounds = qtcore.node_sound_defaults(),
			drawtype = "plantlike",
			paramtype = "light",
			paramtype2 = "meshoptions",
			place_param2 = 32,
			selection_box = qtcore.nb_level1(),
			sunlight_propagates = true,
			walkable = false,
			waving = 1,
			drop = {
				max_items = 1,
				items = {
					{items = {"default:seed_"..name}, rarity = 5},
				},
			},
			
			growable_nodes = {"group:farmland"},
			grow_timer = def.grow_timer or 90,
			grow_timer_random = def.grow_timer_random or 30,
			required_light_level = def.required_light_level or 7,
			on_grow = function(pos)
				minetest.log("info","An "..name.." plant has grown at "..minetest.pos_to_string(pos))
				minetest.set_node(pos, {name = "default:herb_"..name.."_"..(i+1), param2 = 32})
			end,
		})
	end
	local lvl = def.plant_levels
	minetest.register_node("default:herb_"..name.."_"..lvl, {
		description = def.description.." Plant "..lvl.." (Full Grown)",
		tiles ={ def.plant_tiles_list[lvl] },
		use_texture_alpha = "clip",
		groups = {snappy=3, flammable=2, herb_plant=1,not_in_creative_inventory=1},
		sounds = qtcore.node_sound_defaults(),
		drawtype = "plantlike",
		paramtype = "light",
		paramtype2 = "meshoptions",
		place_param2 = 32,
		selection_box = qtcore.nb_level1(),
		sunlight_propagates = true,
		walkable = false,
		waving = 1,
		drop = {
			max_items = 5,
			items = {
				{items = {"default:seed_"..name}},
				{items = {"default:herb_"..name}},
				{items = {"default:seed_"..name}, rarity = 5},
				{items = {"default:seed_"..name}, rarity = 5},
				{items = {"default:herb_"..name}, rarity = 5},
				{items = {"default:herb_"..name}, rarity = 5},
			},
		}
	})
	
end

register_farm_plant("bloodbulb", {
	description = "Bloodbulb",
	seed_image = "default_seeds_bloodbulb_item.png",
	seed_tiles = {"default_seeds_bloodbulb_top.png", "default_oak_wood.png", "default_seeds_bloodbulb_side.png"},
	item_image = "default_herb_bloodbulb.png",
	plant_levels = 5,
	plant_tiles_list = {"default_herb_0.png", "default_herb_bloodbulb_1.png", "default_herb_bloodbulb_2.png", "default_herb_bloodbulb_3.png", "default_herb_bloodbulb_4.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("milfoil", {
	description = "Milfoil",
	seed_image = "default_seeds_milfoil_item.png",
	seed_tiles = {"default_seeds_milfoil_top.png", "default_oak_wood.png", "default_seeds_milfoil_side.png"},
	item_image = "default_herb_milfoil.png",
	plant_levels = 8,
	plant_tiles_list = {"default_herb_0.png", "default_herb_milfoil_1.png", "default_herb_milfoil_2.png", "default_herb_milfoil_3.png", "default_herb_milfoil_4.png",
	"default_herb_milfoil_5.png", "default_herb_milfoil_6.png", "default_herb_milfoil_7.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("goard", {
	description = "Goard",
	seed_image = "default_seeds_goard_item.png",
	seed_tiles = {"default_seeds_goard_top.png", "default_oak_wood.png", "default_seeds_goard_side.png"},
	item_image = "default_herb_goard.png",
	plant_levels = 5,
	plant_tiles_list = {"default_herb_0.png", "default_herb_goard_1.png", "default_herb_goard_2.png", "default_herb_goard_3.png", "default_herb_goard_4.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("carrot", {
	description = "Carrot",
	seed_image = "default_seeds_carrot_item.png",
	seed_tiles = {"default_seeds_carrot_top.png", "default_oak_wood.png", "default_seeds_carrot_side.png"},
	item_image = "default_herb_carrot.png",
	plant_levels = 7,
	plant_tiles_list = {"default_herb_0.png", "default_herb_carrot_1.png", "default_herb_carrot_2.png", "default_herb_carrot_3.png", "default_herb_carrot_4.png",
	"default_herb_carrot_5.png", "default_herb_carrot_6.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("wolfshood", {
	description = "Wolfshood",
	seed_image = "default_seeds_wolfshood_item.png",
	seed_tiles = {"default_seeds_wolfshood_top.png", "default_oak_wood.png", "default_seeds_wolfshood_side.png"},
	item_image = "default_herb_wolfshood.png",
	plant_levels = 5,
	plant_tiles_list = {"default_herb_0.png", "default_herb_wolfshood_1.png", "default_herb_wolfshood_2.png", "default_herb_wolfshood_3.png", "default_herb_wolfshood_4.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("grain", {
	description = "Grain",
	seed_image = "default_seeds_grain_item.png",
	seed_tiles = {"default_seeds_grain_top.png", "default_oak_wood.png", "default_seeds_grain_side.png"},
	item_image = "default_herb_grain.png",
	plant_levels = 9,
	plant_tiles_list = {"default_herb_0.png", "default_herb_grain_1.png", "default_herb_grain_2.png", "default_herb_grain_3.png", "default_herb_grain_4.png",
	"default_herb_grain_5.png", "default_herb_grain_6.png", "default_herb_grain_7.png", "default_herb_grain_8.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("onion", {
	description = "Onion",
	seed_image = "default_seeds_onion_item.png",
	seed_tiles = {"default_seeds_onion_top.png", "default_oak_wood.png", "default_seeds_onion_side.png"},
	item_image = "default_herb_onion.png",
	plant_levels = 9,
	plant_tiles_list = {"default_herb_0.png", "default_herb_onion_1.png", "default_herb_onion_2.png", "default_herb_onion_3.png", "default_herb_onion_4.png",
	"default_herb_onion_5.png", "default_herb_onion_6.png", "default_herb_onion_7.png", "default_herb_onion_8.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("potatoe", {
	description = "Potatoe",
	seed_image = "default_seeds_potatoe_item.png",
	seed_tiles = {"default_seeds_potatoe_top.png", "default_oak_wood.png", "default_seeds_potatoe_side.png"},
	item_image = "default_potatoe.png",
	plant_levels = 6,
	plant_tiles_list = {"default_potatoe_0.png", "default_potatoe_1.png", "default_potatoe_2.png", "default_potatoe_3.png", "default_potatoe_4.png",
	"default_potatoe_5.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("flax", {
	description = "Flax",
	seed_image = "default_seeds_flax_item.png",
	seed_tiles = {"default_seeds_flax_top.png", "default_oak_wood.png", "default_seeds_flax_side.png"},
	item_image = "default_herb_flax.png",
	plant_levels = 7,
	plant_tiles_list = {"default_herb_0.png", "default_herb_flax_1.png", "default_herb_flax_2.png", "default_herb_flax_3.png", "default_herb_flax_4.png",
	"default_herb_flax_5.png", "default_herb_flax_6.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

--breads
local bread_nodeboxes = {
	{ -5/16, -8/16, -6/16, 6/16, -5/16, -1/16, },
	{ -5/16, -8/16, 2/16, 6/16, -5/16, 6/16, },
	{ -5/16, -5/16, -2/16, 6/16, -2/16, 3/16, },
}


qts.register_ingot("default:bread", {
	description = "Bread",
	inventory_image = "default_bread.png",
	tiles = {
			"default_bread_top.png",
			"default_bread_bottom.png",
			"default_bread_side.png"
		},
	groups = {oddly_breakable_by_hand=3},
	nodeboxes = bread_nodeboxes,
	on_use = minetest.item_eat(4),
	levels = 3,
})


minetest.register_node("default:herb_mureux", {
	description = "Mureux Plant",
	tiles ={"default_herb_mureux_empty.png"},
	inventory_image = "default_herb_mureux.png",
	wield_image = "default_herb_mureux.png",
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

minetest.register_node("default:herb_mureux_ripe", {
	description = "Mureux Plant (Ripe)",
	tiles ={"default_herb_mureux_ripe.png"},
	inventory_image = "default_herb_mureux.png",
	wield_image = "default_herb_mureux.png",
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
			"default:herb_mureux",
			"default:herb_mureux_fruit",
		}}}
	},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local itemname = itemstack:get_name()
		if minetest.get_item_group(itemname, "knife") ~= 0 then
			local inv = clicker:get_inventory()
			local leftovers = inv:add_item("main", "default:herb_mureux_fruit 1")
			if leftovers then
				minetest.add_item(pos, leftovers)
			end
			minetest.set_node(pos, {name="default:herb_mureux", param2 = 18})
			if not (qts.is_player_creative(clicker)) then
				qts.apply_default_wear(node.name, itemstack)
			end
		end
		return itemstack
	end,
	--on_flood = floodFunc,
})

minetest.register_craftitem("default:herb_mureux_fruit", {
	description = "Mureux Fruit",
	inventory_image = "default_herb_mureux_fruit.png",
	on_secondary_use = function(itemstack, user, pointed_thing)

		qts.projectile_launch_player("default:mureux_fruit_projectile", user, 0)

		if not (qts.is_player_creative(user)) then
			itemstack:take_item()
		end
		return itemstack
	end
})

qts.register_projectile("default:mureux_fruit_projectile", {
    visual="wielditem",
    visual_size = vector.new(0.25,0.25,0.25),
    use_texture_alpha=true,
    textures ={"default:herb_mureux_fruit"},
    automatic_rotate=true,
    
    radius = 0.25,
    selectable = false,
    gravity_scale = 0.5,
    collectable = "", --TO CHANGE
    lifetime=60*1,
    speed = 10,
    damage_groups = {},

    on_strike_node = qts.projectile_default_struck_node,
    on_strike_entity = qts.projectile_default_struck_entity,
    on_timeout = qts.projectile_default_timeout,
    on_step = function(self, dtime) end,
})

minetest.register_node("default:mureux_goo", {
	description = "Mureux Fruit Goo",
	tiles = {"default_mureux_goo.png"},
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
	connects_to = {"default:mureux_goo", "group:underbrush", "group:generation_replacable"},
	sounds = qtcore.node_sound_wood(),
	drop = "", --intentional no drop
	on_node_update = function(pos)
		local has_solid = false
		for i, p in ipairs({vector.new(-1,0,0),vector.new(1,0,0),vector.new(0,-1,0),vector.new(0,1,0),vector.new(0,0,-1),vector.new(0,0,1)}) do
			local node = minetest.get_node_or_nil(p+pos)
			if node and node.name then
				if (
					minetest.get_item_group(node.name, "generation_replacable") == 0 and
					minetest.get_item_group(node.name, "underbrush") == 0 and
					node.name ~= "default:mureux_goo"
				) then
					has_solid = true
					break
				end
			end
		end
		if not has_solid then
			minetest.log("goo be gone")
			minetest.set_node(pos, {name="air"}) --intentional no drops
		end
	end,
})

