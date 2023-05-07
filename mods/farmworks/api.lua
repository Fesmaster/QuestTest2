--[[
    Farmworks seed and plant API
]]


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

--[[
	This boolean is entirely to tell if exemplar seeds have been registered yet.
]]
local registered_exemplar_seeds = false

function  farmworks.register_farm_plant(name, def)
	
	minetest.register_node("farmworks:seed_" .. name, {
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
		on_place = SeedPlace("farmworks:herb_"..name.."_1"),
	})
	if not registered_exemplar_seeds then
		registered_exemplar_seeds = true
		inventory.register_exemplar_item("seeds", "farmworks:seed_" .. name)
	end
	
	minetest.register_craftitem("farmworks:herb_" .. name, {
		description = def.description,
		inventory_image = def.item_image,
	})
	
	for i =1,def.plant_levels-1 do
		qts.register_growable_node("farmworks:herb_"..name.."_"..i, {
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
					{items = {"farmworks:seed_"..name}, rarity = 5},
				},
			},
			
			growable_nodes = {"group:farmland"},
			grow_timer = def.grow_timer or 90,
			grow_timer_random = def.grow_timer_random or 30,
			required_light_level = def.required_light_level or 7,
			on_grow = function(pos)
				minetest.log("info","An "..name.." plant has grown at "..minetest.pos_to_string(pos))
				minetest.set_node(pos, {name = "farmworks:herb_"..name.."_"..(i+1), param2 = 32})
			end,
		})
	end
	local lvl = def.plant_levels
	minetest.register_node("farmworks:herb_"..name.."_"..lvl, {
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
				{items = {"farmworks:seed_"..name}},
				{items = {"farmworks:herb_"..name}},
				{items = {"farmworks:seed_"..name}, rarity = 5},
				{items = {"farmworks:seed_"..name}, rarity = 5},
				{items = {"farmworks:herb_"..name}, rarity = 5},
				{items = {"farmworks:herb_"..name}, rarity = 5},
			},
		}
	})
	
end