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
		groups = {attached_node=1, seeds=1, oddly_breakable_by_hand=3, dig_immediate=1},
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
	plant_tiles_list = {"default_plant_0.png", "default_herb_bloodbulb_1.png", "default_herb_bloodbulb_2.png", "default_herb_bloodbulb_3.png", "default_herb_bloodbulb_4.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("milfoil", {
	description = "Milfoil",
	seed_image = "default_seeds_milfoil_item.png",
	seed_tiles = {"default_seeds_milfoil_top.png", "default_oak_wood.png", "default_seeds_milfoil_side.png"},
	item_image = "default_herb_milfoil.png",
	plant_levels = 8,
	plant_tiles_list = {"default_plant_0.png", "default_herb_milfoil_1.png", "default_herb_milfoil_2.png", "default_herb_milfoil_3.png", "default_herb_milfoil_4.png",
	"default_herb_milfoil_5.png", "default_herb_milfoil_6.png", "default_herb_milfoil_7.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("goard", {
	description = "Goard",
	seed_image = "default_seeds_milfoil_item.png",
	seed_tiles = {"default_seeds_milfoil_top.png", "default_oak_wood.png", "default_seeds_milfoil_side.png"},
	item_image = "default_herb_goard.png",
	plant_levels = 5,
	plant_tiles_list = {"default_plant_0.png", "default_herb_goard_1.png", "default_herb_goard_2.png", "default_herb_goard_3.png", "default_herb_goard_4.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("wolfshood", {
	description = "Wolfshood",
	seed_image = "default_seeds_wolfshood_item.png",
	seed_tiles = {"default_seeds_wolfshood_top.png", "default_oak_wood.png", "default_seeds_wolfshood_side.png"},
	item_image = "default_herb_wolfshood.png",
	plant_levels = 5,
	plant_tiles_list = {"default_plant_0.png", "default_herb_wolfshood_1.png", "default_herb_wolfshood_2.png", "default_herb_wolfshood_3.png", "default_herb_wolfshood_4.png"},
	grow_timer = 90,
	grow_timer_random = 30,
})

register_farm_plant("grain", {
	description = "Grain",
	seed_image = "default_seeds_grain_item.png",
	seed_tiles = {"default_seeds_grain_top.png", "default_oak_wood.png", "default_seeds_grain_side.png"},
	item_image = "default_grain.png",
	plant_levels = 9,
	plant_tiles_list = {"default_plant_0.png", "default_grain_1.png", "default_grain_2.png", "default_grain_3.png", "default_grain_4.png",
	"default_grain_5.png", "default_grain_6.png", "default_grain_7.png", "default_grain_8.png"},
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
	seed_tiles = {"default_seeds_grain_top.png", "default_oak_wood.png", "default_seeds_grain_side.png"},
	item_image = "default_flax.png",
	plant_levels = 7,
	plant_tiles_list = {"default_plant_0.png", "default_flax_1.png", "default_flax_2.png", "default_flax_3.png", "default_flax_4.png",
	"default_flax_5.png", "default_flax_6.png"},
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