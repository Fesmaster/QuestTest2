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
			
			local comb_textuereSet = "default_bowl_clay_top_overlay.png^default_soup_"..max_brothiness_name.."_top.png^"
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
				ig_List[#ig_List+1] = "default:dishes_clay"

				qts.register_craft({
					ingredients = ig_List,
					results = {"default:bowl_clay_soup_"..comb_name, "default:cup_clay"},
					near = {"group:ttable", "group:furnace", "group:cookware"},
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


--end (regular) consumables

--Things in dishes

--[[Textures needed for dishes
item images (dishes, cup, bowl)
for nodeboxes
-single pixle color

overlays needed for new things in dishes, 
need item and nodebox top overlays (and sides for poweder bowl)]]--
local dish_types = {"clay", "stoneware", "gold", "silver"}
local dish_types_desc = {"Clay", "Stoneware", "Gold", "Silver"}
--main dish making for loop
for i, types in ipairs(dish_types) do

--full cups
	local cup_fill = {"coffee_turkish", "water"}
local cup_fill_desc = {"Turkish Coffee", "Water"}
	for n, fill in ipairs(cup_fill) do
		minetest.register_node("default:cup_"..types.."_"..fill, {
			description = "Cup of "..cup_fill_desc[n],
			tiles = {
				"default_dishes_"..types..".png^default_cup_"..fill.."_top_overlay.png",
				"default_dishes_"..types..".png",
				"default_dishes_"..types..".png"
			},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			inventory_image = "default_cup_"..types.."_item.png^default_cup_"..fill.."_item_overlay.png",
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
	end
	--cup crafting
	
	qts.register_craft({
		ingredients = {"default:coffee_grounds", "default:dishes_"..types, "default:bucket_default_water"},
		results = {"default:cup_clay_coffee_turkish", "default:bowl_"..types, "default:bucket"},
		near = {"group:ttable", "group:cookware", "group:furnace"},
	})

	qts.register_craft({
		ingredients = {"default:coffee_grounds", "default:dishes_"..types, "default:bucket_default_river_water"},
		results = {"default:cup_"..types.."_coffee_turkish", "default:bowl_"..types, "default:bucket"},
		near = {"group:ttable", "group:cookware", "group:furnace"},
	})
	
	qts.register_craft({
		ingredients = {"default:coffee_grounds", "default:cup_"..types.."_water"},
		results = {"default:cup_"..types.."_coffee_turkish"},
		near = {"group:ttable", "group:cookware", "group:furnace"},
	})
	
	qts.register_craft({
		ingredients = {"default:coffee_grounds", "default:cup_"..types, "default:bucket_default_water"},
		results = {"default:cup_"..types.."_coffee_turkish", "default:bucket"},
		near = {"group:ttable", "group:cookware", "group:furnace"},
	})
	
	qts.register_craft({
		ingredients = {"default:coffee_grounds", "default:cup_"..types, "default:bucket_default_river_water"},
		results = {"default:cup_clay_coffee_turkish", "default:bucket"},
		near = {"group:ttable", "group:cookware", "group:furnace"},
	})
	
	qts.register_craft({
	ingredients = {"default:cup_"..types, "default:bucket_default_water"},
	results = {"default:cup_"..types.."_water", "default:bucket"},
	})

	qts.register_craft({
		ingredients = {"default:cup_"..types, "default:bucket_default_river_water"},
		results = {"default:cup_"..types.."_water", "default:bucket"},
	})
	
	qts.register_craft({
		ingredients = {"default:cup_"..types},
		results = {"default:cup_"..types.."_water"},
		near = {"default:water_source"}
	})
	
	qts.register_craft({
		ingredients = {"default:cup_"..types},
		results = {"default:cup_"..types.."_water"},
		near = {"default:river_water_source"}
	})

--dish nodes
	minetest.register_node("default:dishes_"..types, {
		description = dish_types_desc[i].." Dishes",
		tiles = {"default_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "default_dishes_"..types.."_item.png",
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
--vessels
local vessel_fill = {"oil_coconut"}
local vessel_fill_desc = {"Coconut oil"}
	for n, fill in ipairs(vessel_fill) do
		minetest.register_node("default:vessels_"..types.."_"..fill, {
			description = vessel_fill_desc[n].." Vessel",
			tiles = {
				"default_dishes_"..types..".png^default_vessels_"..fill.."_top_overlay.png",
				"default_dishes_"..types..".png",
				"default_dishes_"..types..".png"
			},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			inventory_image = "default_dishes_"..types.."_item.png^default_vessels_"..fill.."_item_overlay.png",
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
	end
-- vessel crafting
--[[qts.register_craft({
	ingredients = {"default:dishes_"..types, "default:bucket_default_water"},
	results = {"default:vessels_"..types.."_water", "default:bucket"},
})

qts.register_craft({
	ingredients = {"default:dishes_"..types, "default:bucket_default_river_water"},
	results = {"default:vessels_"..types.."_water", "default:bucket"},
})

qts.register_craft({
	ingredients = {"default:dishes_"..types},
	results = {"default:vessels_"..types.."_water"},
	near = {"default:water_source"}
})

qts.register_craft({
	ingredients = {"default:dishes_"..types},
	results = {"default:vessels_"..types.."_water"},
	near = {"default:river_water_source"}
})]]--

qts.register_craft({
	ingredients = {"default:dishes_"..types, "default:coconut 3"},
	results = {"default:vessels_"..types.."_oil_coconut"},
	near = {"group:ttable", "group:cookware", "group:furnace"},
})

--powder bowls
local bowl_fill = {"flour"}
local bowl_fill_desc = {"Flour"}
	for n, fill in ipairs(bowl_fill) do
		minetest.register_node("default:bowl_"..types.."_"..fill, {
			description = bowl_fill_desc[n].." Bowl",
			tiles = {
				"default_dishes_"..types..".png^default_bowl_powder_"..fill.."_top_overlay.png",
				"default_dishes_"..types..".png",
				"default_dishes_"..types..".png^default_bowl_powder_"..fill.."_side_overlay.png"
			},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			inventory_image = "default_bowl_"..types.."_item.png^default_bowl_powder_"..fill.."_item_overlay.png",
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {oddly_breakable_by_hand=3, generation_artificial=1},
			node_box = {
				type = "fixed",
				fixed = {
				{ -5/16, -6/16, -5/16, 5/16, -5/16, 5/16, },
				{ -4/16, -7/16, -4/16, 4/16, -5/16, 4/16, },
				{ -3/16, -8/16, -3/16, 3/16, -4/16, 3/16, },
				{ -2/16, -8/16, -2/16, 2/16, -3/16, 2/16, },
				},
			},
		})
	end
	--powder bowl crafting
			qts.register_craft({
			ingredients = {"default:dishes_"..types, "default:herb_grain 4"},
			results = {"default:bowl_"..types.."_flour", "default:cup_"..types},
			near = {"group:ttable", "group:dishes"},
		})
		
		qts.register_craft({
			ingredients = {"default:bowl_"..types, "default:herb_grain 4"},
			results = {"default:bowl_"..types.."_flour"},
			near = {"group:ttable", "group:dishes"},
		})

--individual empty cup and bowl
	minetest.register_node("default:cup_"..types, {
		description = dish_types_desc[i].." Cup",
		tiles = {"default_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "default_cup_"..types.."_item.png",
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
	
	minetest.register_node("default:bowl_"..types, {
		description = dish_types_desc[i].." Bowl",
		tiles = {"default_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "default_bowl_"..types.."_item.png",
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
	
	--individual crafting
	qts.register_craft({
		ingredients = {"default:bowl_"..types, "default:cup_"..types},
		results = {"default:dishes_"..types},
	})
	
	qts.register_craft({
		ingredients ={"default:dishes_"..types}, 
		results = {"default:bowl_"..types, "default:cup_"..types},
	})
-- related crafting
	qts.register_craft({
		ingredients = {"default:bowl_"..types.."_flour", "default:bucket_default_water"},
		results = {"default:bread", "default:bowl_"..types, "default:bucket"},
		near = {"group:ttable", "group:dishes", "group:furnace"},
	})
	
	qts.register_craft({
		ingredients = {"default:bowl_"..types.."_flour", "default:bucket_default_river_water"},
		results = {"default:bread", "default:bowl_"..types, "default:bucket"},
		near = {"group:ttable", "group:dishes", "group:furnace"},
	})
end
--end things in dishes

--greenwares
local greenware_types = {"clay", "stoneware"}
local greenware_types_desc = {"Clay","Stoneware"}
for i, types in ipairs(greenware_types) do
	minetest.register_node("default:dishes_"..types.."_greenware", {
		description = greenware_types_desc[i].." Greenware Dishes",
		tiles = {"default_dishes_"..types.."_greenware.png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "default_dishes_"..types.."_greenware_item.png",
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
end 
--end greenwares

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

--crafting
qts.register_craft({
	ingredients = {"default:herb_potatoe"},
	results = {"default:seeds_potatoe"},
})

qts.register_craft({
	ingredients = {"default:coffee_beans"},
	results = {"default:coffee_grounds 2"},
	near = {"group:ttable", "group:dishes"},
})

qts.register_craft({
	ingredients = {"default:small_mushroom 2", "default:dishes_clay"},
	results = {"default:mushroom_stew", "default:cup_clay"},
})

qts.register_craft({
	ingredients = {"default:small_mushroom 2", "default:bowl_clay"},
	results = {"default:mushroom_stew"},
	near = {"group:furnace", "group:cookware"}
})

qts.register_craft({
	ingredients = {"default:clay_lump"},
	results = {"default:dishes_clay_greenware"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:refined_clay_lump"},
	results = {"default:dishes_stoneware_greenware"},
	near = {"group:workbench"},
})


minetest.register_craft({
	type = "cooking",
	output = "default:dishes_clay",
	recipe = "default:dishes_clay_greenware",
})

minetest.register_craft({
	type = "cooking",
	output = "default:dishes_stoneware",
	recipe = "default:dishes_stoneware_greenware",
})

qts.register_craft({
	ingredients = {"default:gold_bar"},
	results = {"default:cup_gold"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:gold_bar"},
	results = {"default:bowl_gold"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:silver_bar"},
	results = {"default:cup_silver"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:silver_bar"},
	results = {"default:bowl_silver"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = { "default:palm_log"},
	results = {"default:wax_palm 4"},
	near = {"group:ttable", "group:dishes", "group:furnace"},
})
