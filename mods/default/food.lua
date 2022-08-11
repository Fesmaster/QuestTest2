--food and dish items go here

--BEGIN NODES

--soups

--list of ingredient names
local ingredient={"apple", "goard", "grain", "carrot", "onion", "potatoe"}
--mapping of said name to the actual item used to craft it
local ingredient_map = {
	apple="default:apple",
	goard = "default:herb_goard",
	grain="default:herb_grain",
	carrot="default:herb_carrot",
	onion="default:herb_onion",
	potatoe="default:herb_potatoe",
}

--how preferred each item is to be the base of the soup
local brothiness = {
	apple=0,
	goard = 2,
	grain=1,
	carrot=3,
	onion=4,
	potatoe=5,
}

local comb_complete = {}

--this function capitolizes the first letter of a string
local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

for i=1, #ingredient do
	for j=i, #ingredient do
		for k=j, #ingredient do
			local herb_1 = ingredient[i]
			local herb_2 = ingredient[j]
			local herb_3 = ingredient[k]
			--this set will have a unique entry for every combination, not permutation
			--so, if both herb_1 and herb_2 are "apple", then they are the same entry in the table, and not two different ones.
			local comb_set = {[herb_1]=true, [herb_2]=true, [herb_3]=true}
			--turn the set into a list
			local comb_list = {}
			for herbname,_ in pairs(comb_set)do
				comb_list[#comb_list+1] = herbname
			end
			--sort the list alphabetically to make sure it stays unique to the combination, not permutation (pairs is not deterministic)
			table.sort(comb_list)

			
			--
			
			local comb_name = ""
			local comb_description = ""
			
			--deal with brothiness
			local max_brothiness_value = brothiness[comb_list[1]]
			local max_brothiness_name = comb_list[1]
			for l, name in ipairs(comb_list) do
				if brothiness[name] > max_brothiness_value then
					max_brothiness_value = brothiness[name]
					max_brothiness_name = name
				end		
			end
			
			local comb_textuereSet = "default_bowl_clay_soup_top_overlay.png^default_soup_"..max_brothiness_name.."_top.png^"
			local comb_invTextureSet = "default_soup_"..max_brothiness_name.."_item.png^default_bowl_clay_soup_item_overlay.png"
			
			--now, generate a unique string from this for the name
			--also generate a description and node texture
			for l, name in ipairs(comb_list)do
				comb_name = comb_name .. name
				comb_description = comb_description .. firstToUpper(name)
				if l == 1 then
					comb_textuereSet = comb_textuereSet .. "default_soup_overlay_"..name..".png"
				else
					comb_textuereSet = comb_textuereSet .. "default_soup_overlay_"..name..".png"
				end
				if l < #comb_list then
					comb_name = comb_name .. "_"
					comb_textuereSet = comb_textuereSet .. "^"
					
					if #comb_list > 2 then
						comb_description = comb_description .. ", "
						if l+1 == #comb_list then
							comb_description = comb_description .. "and "
						end
					else
						comb_description = comb_description .. " and "
					end
				end
			end

			--don't repeat combinations
			if not comb_complete[comb_name] then 
				comb_complete[comb_name] = true
				
				
				minetest.register_node("default:bowl_clay_soup_"..comb_name, {
					description = comb_description .. " Soup",
					tiles = {
						comb_textuereSet,
						"default_dishes_clay.png"	
					},
					inventory_image = comb_invTextureSet,
					use_texture_alpha="clip",
					groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1, soup=1},
					drawtype = "nodebox",
					--inventory_image = soupimage[i].."^default_bowl_clay_soup_item_overlay.png",
					paramtype = "light",
					on_use = qts.item_eat(6),
					node_box = {
						type = "fixed",
						fixed = {
							{ -3/16, -8/16, -3/16, 3/16, -7/16, 3/16, },
							{ -4/16, -7/16, -4/16, 4/16, -6/16, 4/16, },
							{ 4/16, -6/16, -5/16, 5/16, -5/16, 5/16, },
							{ -5/16, -6/16, -5/16, 5/16, -5/16, -4/16, },
							{ -5/16, -6/16, 4/16, 5/16, -5/16, 5/16, },
							{ -5/16, -6/16, -5/16, -4/16, -5/16, 5/16, },
						},
					},
					sounds = qtcore.node_sound_stone(),
				})
				
				--build the ingredient list
				local ig_List = {}
				for l, name in ipairs(comb_list) do
					ig_List[l] = ingredient_map[name]
				end
				ig_List[#ig_List+1] = "default:vessels_water"

				qts.register_craft({
					ingredients = ig_List,
					results = {"default:bowl_clay_soup_"..comb_name, "default:cup_clay"},
					near = {"group:table", "group:furnace", "group:cookware"},
				})

			end
		end
	end
end

--end soups

-- consumables
qts.register_ingot("default:apple", {
	description = "Apple",
	inventory_image = "default_apple_fruit_item.png",
	tiles = {"default_apple_fruit_top.png", "default_apple_fruit.png", "default_apple_fruit.png"},
	groups = {oddly_breakable_by_hand=3, fruit = 1, generation_artificial=1},
	on_use = minetest.item_eat(2),
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	sounds = qtcore.node_sound_wood(),
	nodeboxes = {
		{-0.4375, -0.5, 0.1875, -0.1875, -0.25, 0.4375}, -- NodeBox1
		{-0.4375, -0.5, -0.125, -0.1875, -0.25, 0.125}, -- NodeBox2
		{-0.4375, -0.5, -0.4375, -0.1875, -0.25, -0.1875}, -- NodeBox3
		{-0.125, -0.5, 0.1875, 0.125, -0.25, 0.4375}, -- NodeBox4
		{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox5
		{-0.125, -0.5, -0.4375, 0.125, -0.25, -0.1875}, -- NodeBox6
		{0.1875, -0.5, 0.1875, 0.4375, -0.25, 0.4375}, -- NodeBox7
		{0.1875, -0.5, -0.125, 0.4375, -0.25, 0.125}, -- NodeBox8
		{0.1875, -0.5, -0.4375, 0.4375, -0.25, -0.1875}, -- NodeBox9
		{-0.3125, -0.25, 0.0625, -0.0624999, 2.23517e-08, 0.3125}, -- NodeBox10
		{-0.3125, -0.25, -0.3125, -0.0624999, -5.21541e-08, -0.0625001}, -- NodeBox11
		{0.0625, -0.25, 0.0625, 0.3125, 2.23517e-08, 0.3125}, -- NodeBox12
		{0.0625, -0.25, -0.3125, 0.3125, 2.23517e-08, -0.0625}, -- NodeBox13
		{-0.125, 0, -0.125, 0.125, 0.25, 0.125}, -- NodeBox14
	},
	levels = 14,
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
	on_use = qts.item_eat(4),
	levels = 3,
})

qts.register_ingot("default:coconut", {
	description = "Coconut",
	inventory_image = "default_coconut.png",
	tiles = {"default_coconut_top.png", "default_coconut_side.png"},
	use_texture_alpha="clip",
	groups = {oddly_breakable_by_hand=3, fruit = 1, generation_artificial=1},
	on_use = minetest.item_eat(2),
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	sounds = qtcore.node_sound_wood(),
	nodeboxes = {
		{-0.4375, -0.5, 0.1875, -0.1875, -0.25, 0.4375}, -- NodeBox1
		{-0.4375, -0.5, -0.125, -0.1875, -0.25, 0.125}, -- NodeBox2
		{-0.4375, -0.5, -0.4375, -0.1875, -0.25, -0.1875}, -- NodeBox3
		{-0.125, -0.5, 0.1875, 0.125, -0.25, 0.4375}, -- NodeBox4
		{-0.125, -0.5, -0.125, 0.125, -0.25, 0.125}, -- NodeBox5
		{-0.125, -0.5, -0.4375, 0.125, -0.25, -0.1875}, -- NodeBox6
		{0.1875, -0.5, 0.1875, 0.4375, -0.25, 0.4375}, -- NodeBox7
		{0.1875, -0.5, -0.125, 0.4375, -0.25, 0.125}, -- NodeBox8
		{0.1875, -0.5, -0.4375, 0.4375, -0.25, -0.1875}, -- NodeBox9
		{-0.3125, -0.25, 0.0625, -0.0624999, 2.23517e-08, 0.3125}, -- NodeBox10
		{-0.3125, -0.25, -0.3125, -0.0624999, -5.21541e-08, -0.0625001}, -- NodeBox11
		{0.0625, -0.25, 0.0625, 0.3125, 2.23517e-08, 0.3125}, -- NodeBox12
		{0.0625, -0.25, -0.3125, 0.3125, 2.23517e-08, -0.0625}, -- NodeBox13
		{-0.125, 0, -0.125, 0.125, 0.25, 0.125}, -- NodeBox14
	},
	levels = 14,
})

minetest.register_node("default:cup_clay_coffee_turkish", {
	description = "Cup of Turkish Coffee",
	tiles = {
		"default_cup_clay_coffee_top.png",
		"default_dishes_clay.png",
		"default_dishes_clay.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_cup_clay_coffee_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -3/16, 2/16, },
			{ -2/16, -3/16, -2/16, 2/16, -2/16, -1/16, },
			{ -2/16, -3/16, 1/16, 2/16, -2/16, 2/16, },
			{ 1/16, -3/16, -2/16, 2/16, -2/16, 2/16, },
			{ -2/16, -3/16, -2/16, -1/16, -2/16, 2/16, },
		},
	},
	on_use = qts.item_eat(4),
	sounds = qtcore.node_sound_stone(),
})
--consumables

--Cooking items and stations
minetest.register_node("default:dishes_clay", {
	description = "Clay Dishes",
	tiles = {"default_dishes_clay.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_dishes_clay_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, dishes=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 1/16, -5/16, -6/16, 5/16, },
		{ -1/16, -7/16, 1/16, 0/16, -6/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 1/16, },
		{ -6/16, -7/16, 5/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -7/16, -2/16, },
		{ 2/16, -7/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -7/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -7/16, -5/16, 3/16, -2/16, -3/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:dishes_greenware", {
	description = "Greenware Dishes",
	tiles = {"default_dishes_greenware.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_dishes_greenware_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 1/16, -5/16, -6/16, 5/16, },
		{ -1/16, -7/16, 1/16, 0/16, -6/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 1/16, },
		{ -6/16, -7/16, 5/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -7/16, -2/16, },
		{ 2/16, -7/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -7/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -7/16, -5/16, 3/16, -2/16, -3/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:vessels_water", {
	description = "Water Vessel",
	tiles = {
		"default_vessel_water_top.png",
		"default_dishes_clay.png",
		"default_dishes_clay.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_vessel_water_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, vessels_water=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -3/16, -2/16, },
		{ 2/16, -3/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -3/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -3/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -3/16, -5/16, 3/16, -2/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:vessels_oil_coconut", {
	description = "Coconut Oil Vessel",
	tiles = {
		"default_vessel_oil_coconut_top.png",
		"default_dishes_clay.png",
		"default_dishes_clay.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_vessel_oil_coconut_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -5/16, -8/16, 1/16, -1/16, -7/16, 5/16, },
		{ -6/16, -7/16, 0/16, 0/16, -6/16, 6/16, },
		{ -6/16, -6/16, 6/16, 0/16, -5/16, 7/16, },
		{ -6/16, -6/16, -1/16, 0/16, -5/16, 0/16, },
		{ 0/16, -6/16, -1/16, 1/16, -5/16, 7/16, },
		{ -7/16, -6/16, -1/16, -6/16, -5/16, 7/16, },
		{ 2/16, -8/16, -6/16, 6/16, -3/16, -2/16, },
		{ 2/16, -3/16, -3/16, 6/16, -2/16, -2/16, },
		{ 2/16, -3/16, -6/16, 6/16, -2/16, -5/16, },
		{ 5/16, -3/16, -5/16, 6/16, -2/16, -3/16, },
		{ 2/16, -3/16, -5/16, 3/16, -2/16, -3/16, },
		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:flour_bowl", {
	description = "Flour Bowl",
	tiles = {
		"default_flour_bowl_top.png",
		"default_dishes_clay.png",
		"default_flour_bowl_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_flour_bowl_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
		{ -3/16, -7/16, -4/16, 4/16, -5/16, 3/16, },
		{ -4/16, -6/16, -4/16, -3/16, -5/16, 3/16, },
		{ 4/16, -6/16, -4/16, 5/16, -5/16, 3/16, },
		{ -4/16, -6/16, 3/16, 5/16, -5/16, 4/16, },
		{ -4/16, -6/16, -5/16, 5/16, -5/16, -4/16, },
		{ -2/16, -8/16, -3/16, 3/16, -4/16, 2/16, },
		{ -1/16, -4/16, -2/16, 2/16, -3/16, 1/16, },
		},
	},
})

minetest.register_node("default:cup_clay", {
	description = "Clay Cup",
	tiles = {"default_dishes_clay.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_cup_clay_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -2/16, -8/16, 1/16, 2/16, -3/16, 2/16, },
			{ -2/16, -8/16, -2/16, 2/16, -3/16, -1/16, },
			{ -2/16, -8/16, -2/16, -1/16, -3/16, 2/16, },
			{ 1/16, -8/16, -2/16, 2/16, -3/16, 2/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:bowl_clay", {
	description = "Clay Bowl",
	tiles = {"default_dishes_clay.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_bowl_clay_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, -8/16, -2/16, 2/16, -7/16, 2/16, },
			{ -3/16, -7/16, -3/16, -2/16, -6/16, 3/16, },
			{ 2/16, -7/16, -3/16, 3/16, -6/16, 3/16, },
			{ -3/16, -7/16, -3/16, 3/16, -6/16, -2/16, },
			{ -3/16, -7/16, 2/16, 3/16, -6/16, 3/16, },
			{ -4/16, -6/16, 3/16, 4/16, -5/16, 4/16, },
			{ -4/16, -6/16, -4/16, 4/16, -5/16, -3/16, },
			{ 3/16, -6/16, -4/16, 4/16, -5/16, 4/16, },
			{ -4/16, -6/16, -4/16, -3/16, -5/16, 4/16, },

		},
	},
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node("default:cookware_iron", {
	description = "Cast Iron Cookware",
	tiles = {"default_cookware_iron.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_cookware_iron_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, cookware=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, 2/16, -2/16, -7/16, 5/16, },
			{ -2/16, -7/16, 1/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -5/16, -6/16, 6/16, },
			{ -6/16, -7/16, 5/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -1/16, -6/16, 2/16, },
			{ -4/16, -7/16, -3/16, -3/16, -6/16, 1/16, },
			{ -5/16, -7/16, 0/16, -2/16, -6/16, 1/16, },
			{ 1/16, -8/16, -5/16, 5/16, -7/16, -1/16, },
			{ 0/16, -7/16, -1/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
			{ 5/16, -7/16, -6/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 1/16, -2/16, 0/16, },
			{ 2/16, -4/16, -1/16, 4/16, -3/16, 1/16, },
			{ 2/16, -4/16, -7/16, 4/16, -3/16, -5/16, },

		},
	},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_node("default:cookware_copper", {
	description = "Copper Cookware",
	tiles = {"default_cookware_copper.png",},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_cookware_copper_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, cookware=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -5/16, -8/16, 2/16, -2/16, -7/16, 5/16, },
			{ -2/16, -7/16, 1/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -5/16, -6/16, 6/16, },
			{ -6/16, -7/16, 5/16, -1/16, -6/16, 6/16, },
			{ -6/16, -7/16, 1/16, -1/16, -6/16, 2/16, },
			{ -4/16, -7/16, -3/16, -3/16, -6/16, 1/16, },
			{ -5/16, -7/16, 0/16, -2/16, -6/16, 1/16, },
			{ 1/16, -8/16, -5/16, 5/16, -7/16, -1/16, },
			{ 0/16, -7/16, -1/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 6/16, -2/16, -5/16, },
			{ 5/16, -7/16, -6/16, 6/16, -2/16, 0/16, },
			{ 0/16, -7/16, -6/16, 1/16, -2/16, 0/16, },
			{ 2/16, -4/16, -1/16, 4/16, -3/16, 1/16, },
			{ 2/16, -4/16, -7/16, 4/16, -3/16, -5/16, },

		},
	},
	sounds = qtcore.node_sound_metal(),
})

minetest.register_node("default:coffee_grounds", {
	description = "Coffee Grounds",
	tiles = {
		"default_coffee_grounds_top.png",
		"default_oak_wood.png",
		"default_coffee_grounds_side.png"
	},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	inventory_image = "default_coffee_grounds_item.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1},
	node_box = qtcore.nb_dustpile(),
})
--END NODES

--BEGIN craftitems
minetest.register_craftitem("default:mushroom_stew", {
	description = "Mushroom Stew",
	inventory_image = "default_mushroom_stew.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craftitem("default:flask_glass", {
	description = "Glass Flask",
	inventory_image = "default_flask_glass.png",
})

minetest.register_craftitem("default:flask_glass_water", {
	description = "Flask of Water",
	inventory_image = "default_flask_glass_water.png",
})

minetest.register_craftitem("default:coffee_beans", {
	description = "Coffee Beans",
	inventory_image = "default_coffee_beans.png",
})