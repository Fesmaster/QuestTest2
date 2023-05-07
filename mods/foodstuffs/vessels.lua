
--[[
    !WARNING! this file needs a good scrubbing. Its rather messy.

]]


--[[
    Textures needed for dishes
    item images (dishes, cup, bowl)
    for nodeboxes
    -single pixle color

    overlays needed for new things in dishes, 
    need item and nodebox top overlays (cups and vessels have same nodebox overlays) (and sides for poweder bowl)
]]

local dish_types = {"clay", "stoneware", "gold", "silver"}
local dish_types_desc = {"Clay", "Stoneware", "Gold", "Silver"}
--main dish making for loop
for i, types in ipairs(dish_types) do

	--full cups and vessels
	local cup_fill = {"coffee_turkish", "water", "oil_coconut", "oil_seeds"}
	local cup_fill_desc = {"Turkish Coffee", "Water", "Oil Coconut", "Oil_Seeds"}
	for n, fill in ipairs(cup_fill) do
		minetest.register_node("foodstuffs:cup_"..types.."_"..fill, {
			description = "Cup of "..cup_fill_desc[n],
			tiles = {
				"foodstuffs_dishes_"..types..".png^foodstuffs_cup_"..fill.."_top_overlay.png",
				"foodstuffs_dishes_"..types..".png",
				"foodstuffs_dishes_"..types..".png"
			},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			inventory_image = "foodstuffs_cup_"..types.."_item.png^foodstuffs_cup_"..fill.."_item_overlay.png",
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

		minetest.register_node("foodstuffs:vessels_"..types.."_"..fill, {
			description = cup_fill_desc[n].." Vessel",
			tiles = {
				"foodstuffs_dishes_"..types..".png^foodstuffs_cup_"..fill.."_top_overlay.png",
				"foodstuffs_dishes_"..types..".png",
				"foodstuffs_dishes_"..types..".png"
			},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			--inventory_image = "foodstuffs_dishes_"..types.."_item.png^foodstuffs_vessels_"..fill.."_item_overlay.png",
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {oddly_breakable_by_hand=3, vessels_water=1, generation_artificial=1},
			node_box = {
				type = "fixed",
				fixed = {
					{ -1/16, -8/16, -2/16, 1/16, -7/16, 2/16, },
					{ -2/16, -8/16, -1/16, 2/16, -7/16, 1/16, },
					{ -2/16, -7/16, -2/16, -1/16, -6/16, 2/16, },
					{ 1/16, -7/16, -2/16, 2/16, -6/16, 2/16, },
					{ -2/16, -7/16, 1/16, 2/16, -6/16, 2/16, },
					{ -2/16, -7/16, -2/16, 2/16, -6/16, -1/16, },
					{ -3/16, -6/16, -3/16, 3/16, -2/16, -2/16, },
					{ -3/16, -6/16, 2/16, 3/16, -2/16, 3/16, },
					{ -3/16, -6/16, -3/16, -2/16, -2/16, 3/16, },
					{ 2/16, -6/16, -3/16, 3/16, -2/16, 3/16, },
					{ 1/16, -2/16, -2/16, 2/16, -1/16, 2/16, },
					{ -2/16, -2/16, -2/16, -1/16, -1/16, 2/16, },
					{ -2/16, -2/16, 1/16, 2/16, -1/16, 2/16, },
					{ -2/16, -2/16, -2/16, 2/16, -1/16, -1/16, },
					{ -1/16, -2/16, -2/16, 1/16, 1/16, -1/16, },
					{ -1/16, -2/16, 1/16, 1/16, 1/16, 2/16, },
					{ -2/16, -2/16, -1/16, -1/16, 1/16, 1/16, },
					{ 1/16, -2/16, -1/16, 2/16, 1/16, 1/16, },
					{ 1/16, 1/16, -2/16, 2/16, 2/16, 2/16, },
					{ -2/16, 1/16, -2/16, -1/16, 2/16, 2/16, },
					{ -2/16, 1/16, -2/16, 2/16, 2/16, -1/16, },
					{ -1/16, 1/16, 2/16, 1/16, 2/16, 3/16, },
					{ -1/16, -1/16, -3/16, 1/16, 0/16, -2/16, },
					{ -1/16, 0/16, -4/16, 1/16, 1/16, -3/16, },
					{ -1/16, -5/16, -5/16, 1/16, 0/16, -4/16, },
					{ -1/16, -6/16, -4/16, 1/16, -5/16, -3/16, },
					{ -1/16, -5/16, -1/16, 1/16, 0/16, 1/16, },
				},
			},
			sounds = qtcore.node_sound_stone(),
		})

	end

	-- vessel and cup crafting 

	--water included crafting
	local cup_craft = {"water", "river_water"}
	for h, fill in ipairs(cup_craft) do
		qts.register_craft({
			ingredients = {"foodstuffs:cup_"..types, "tools:bucket_wood_overworld_"..fill},
			results = {"foodstuffs:cup_"..types.."_water", "tools:bucket_wood"},
		})

		qts.register_craft({
			ingredients = {"foodstuffs:vessels_empty_"..types, "tools:bucket_wood_overworld_"..fill},
			results = {"foodstuffs:vessels_"..types.."_water", "tools:bucket_wood"},
		})

		qts.register_craft({
			ingredients = {"foodstuffs:cup_"..types},
			results = {"foodstuffs:cup_"..types.."_water"},
			near = {"overworld:"..fill.."_source"}
		})

		qts.register_craft({
			ingredients = {"foodstuffs:vessels_empty_"..types},
			results = {"foodstuffs:vessels_"..types.."_water"},
			near = {"overworld:"..fill.."_source"}
		})

		qts.register_craft({
			ingredients = {"foodstuffs:coffee_grounds", "foodstuffs:vessels_empty_"..types, "tools:bucket_wood_overworld_"..fill},
			results = {"foodstuffs:vessels_"..types.."_coffee_turkish", "tools:bucket_wood"},
			near = {"group:table", "group:cookware", "group:furnace"},
		})

		qts.register_craft({
			ingredients = {"foodstuffs:coffee_grounds", "foodstuffs:vessels_empty_"..types},
			results = {"foodstuffs:vessels_"..types.."_coffee_turkish", "tools:bucket_wood"},
			near = {"group:table", "group:cookware", "group:furnace", "overworld:"..fill.."_source"},
		})
	end
		

	qts.register_craft({
		ingredients = {"foodstuffs:vessels_empty_"..types, "overworld:coconut 4"},
		results = {"foodstuffs:vessels_"..types.."_oil_coconut"},
		near = {"group:table", "group:cookware", "group:furnace"},
	})

	qts.register_craft({
		ingredients = {"foodstuffs:vessels_empty_"..types, "group:seeds 12"},
		results = {"foodstuffs:vessels_"..types.."_oil_seeds"},
		near = {"group:press"},
	})

	qts.register_craft({
		ingredients = {"foodstuffs:vessels_"..types.."_oil_coconut", "alchemy:lye"},
		results = {"alchemy:soap"},
		near = {"group:table", "foodstuffs:vessels_empty_"..types},
	})

	qts.register_craft({
		ingredients = {"foodstuffs:vessels_"..types.."_oil_seeds", "alchemy:lye"},
		results = {"alchemy:soap"},
		near = {"group:table", "foodstuffs:vessels_empty_"..types},
	})

	--vessel cup interchangability
	local cup_fill = {"coffee_turkish", "water", "oil_coconut", "oil_seeds"}
	local dish_2 = {"clay", "stoneware", "gold", "silver" }
	for h, fill in ipairs(cup_fill) do
		for r, types2 in ipairs(dish_2) do
				qts.register_craft({
				ingredients = {"foodstuffs:vessels_"..types.."_"..fill, "foodstuffs:cup_"..types2.." 8" },
				results = {"foodstuffs:cup_"..types2.."_"..fill.." 8", "foodstuffs:vessels_empty_"..types},
			})

			qts.register_craft({
				ingredients = {"foodstuffs:vessels_empty_"..types, "foodstuffs:cup_"..types2.."_"..fill.." 8"},
				results = { "foodstuffs:cup_"..types2.." 8", "foodstuffs:vessels_"..types.."_"..fill},
			})
		end
	end

	--dish nodes (and empty vessels)
	minetest.register_node("foodstuffs:dishes_"..types, {
		description = dish_types_desc[i].." Dishes",
		tiles = {"foodstuffs_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "foodstuffs_dishes_"..types.."_item.png",
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
	
	if types == dish_types[1] then
		inventory.register_exemplar_item("dishes", "foodstuffs:dishes_"..types)
	end

	minetest.register_node("foodstuffs:vessels_empty_"..types, {
		description = dish_types_desc[i].." Vessel",
		tiles = {"foodstuffs_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		--inventory_image = "foodstuffs_dishes_"..types.."_item.png",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {oddly_breakable_by_hand=3, dishes=1, generation_artificial=1},
		node_box = {
			type = "fixed",
			fixed = {
				{ -1/16, -8/16, -2/16, 1/16, -7/16, 2/16, },
				{ -2/16, -8/16, -1/16, 2/16, -7/16, 1/16, },
				{ -2/16, -7/16, -2/16, -1/16, -6/16, 2/16, },
				{ 1/16, -7/16, -2/16, 2/16, -6/16, 2/16, },
				{ -2/16, -7/16, 1/16, 2/16, -6/16, 2/16, },
				{ -2/16, -7/16, -2/16, 2/16, -6/16, -1/16, },
				{ -3/16, -6/16, -3/16, 3/16, -2/16, -2/16, },
				{ -3/16, -6/16, 2/16, 3/16, -2/16, 3/16, },
				{ -3/16, -6/16, -3/16, -2/16, -2/16, 3/16, },
				{ 2/16, -6/16, -3/16, 3/16, -2/16, 3/16, },
				{ 1/16, -2/16, -2/16, 2/16, -1/16, 2/16, },
				{ -2/16, -2/16, -2/16, -1/16, -1/16, 2/16, },
				{ -2/16, -2/16, 1/16, 2/16, -1/16, 2/16, },
				{ -2/16, -2/16, -2/16, 2/16, -1/16, -1/16, },
				{ -1/16, -2/16, -2/16, 1/16, 1/16, -1/16, },
				{ -1/16, -2/16, 1/16, 1/16, 1/16, 2/16, },
				{ -2/16, -2/16, -1/16, -1/16, 1/16, 1/16, },
				{ 1/16, -2/16, -1/16, 2/16, 1/16, 1/16, },
				{ 1/16, 1/16, -2/16, 2/16, 2/16, 2/16, },
				{ -2/16, 1/16, -2/16, -1/16, 2/16, 2/16, },
				{ -2/16, 1/16, -2/16, 2/16, 2/16, -1/16, },
				{ -1/16, 1/16, 2/16, 1/16, 2/16, 3/16, },
				{ -1/16, -1/16, -3/16, 1/16, 0/16, -2/16, },
				{ -1/16, 0/16, -4/16, 1/16, 1/16, -3/16, },
				{ -1/16, -5/16, -5/16, 1/16, 0/16, -4/16, },
				{ -1/16, -6/16, -4/16, 1/16, -5/16, -3/16, },
			},
		},
		sounds = qtcore.node_sound_stone(),
	})

	--powder bowls
	local bowl_fill = {"flour"}
	local bowl_fill_desc = {"Flour"}
	for n, fill in ipairs(bowl_fill) do
		minetest.register_node("foodstuffs:bowl_"..types.."_"..fill, {
			description = bowl_fill_desc[n].." Bowl",
			tiles = {
				"foodstuffs_dishes_"..types..".png^foodstuffs_bowl_powder_"..fill.."_top_overlay.png",
				"foodstuffs_dishes_"..types..".png",
				"foodstuffs_dishes_"..types..".png^foodstuffs_bowl_powder_"..fill.."_side_overlay.png"
			},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			inventory_image = "foodstuffs_bowl_"..types.."_item.png^foodstuffs_bowl_powder_"..fill.."_item_overlay.png",
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
		ingredients = {"foodstuffs:dishes_"..types, "farmworks:herb_grain 4"},
		results = {"foodstuffs:bowl_"..types.."_flour", "foodstuffs:cup_"..types},
		near = {"group:table", "group:dishes"},
	})
	
	qts.register_craft({
		ingredients = {"foodstuffs:bowl_"..types, "farmworks:herb_grain 4"},
		results = {"foodstuffs:bowl_"..types.."_flour"},
		near = {"group:table", "group:dishes"},
	})

	--individual empty cup and bowl
	minetest.register_node("foodstuffs:cup_"..types, {
		description = dish_types_desc[i].." Cup",
		tiles = {"foodstuffs_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "foodstuffs_cup_"..types.."_item.png",
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
	
	minetest.register_node("foodstuffs:bowl_"..types, {
		description = dish_types_desc[i].." Bowl",
		tiles = {"foodstuffs_dishes_"..types..".png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "foodstuffs_bowl_"..types.."_item.png",
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
		ingredients = {"foodstuffs:bowl_"..types, "foodstuffs:cup_"..types},
		results = {"foodstuffs:dishes_"..types},
	})
	
	qts.register_craft({
		ingredients ={"foodstuffs:dishes_"..types}, 
		results = {"foodstuffs:bowl_"..types, "foodstuffs:cup_"..types},
	})
-- related crafting
	qts.register_craft({
		ingredients = {"foodstuffs:bowl_"..types.."_flour", "tools:bucket_wood_overworld_water"},
		results = {"foodstuffs:bread", "foodstuffs:bowl_"..types, "tools:bucket_wood"},
		near = {"group:table", "group:dishes", "group:furnace"},
	})
	
	qts.register_craft({
		ingredients = {"foodstuffs:bowl_"..types.."_flour", "tools:bucket_wood_overworld_river_water"},
		results = {"foodstuffs:bread", "foodstuffs:bowl_"..types, "tools:bucket_wood"},
		near = {"group:table", "group:dishes", "group:furnace"},
	})

end
--end things in dishes


--greenwares
local greenware_types = {"clay", "stoneware"}
local greenware_types_desc = {"Clay","Stoneware"}
for i, types in ipairs(greenware_types) do
	minetest.register_node("foodstuffs:dishes_"..types.."_greenware", {
		description = greenware_types_desc[i].." Greenware Dishes",
		tiles = {"foodstuffs_dishes_"..types.."_greenware.png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		inventory_image = "foodstuffs_dishes_"..types.."_greenware_item.png",
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

	minetest.register_node("foodstuffs:vessels_"..types.."_greenware", {
		description = greenware_types_desc[i].." Greenware Vessel",
		tiles = {"foodstuffs_dishes_"..types.."_greenware.png",},
		use_texture_alpha="clip",
		drawtype = "nodebox",
		--inventory_image = "foodstuffs_dishes_"..types.."_greenware_item.png",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {oddly_breakable_by_hand=3, generation_artificial=1},
		node_box = {
			type = "fixed",
			fixed = {
				{ -1/16, -8/16, -2/16, 1/16, -7/16, 2/16, },
				{ -2/16, -8/16, -1/16, 2/16, -7/16, 1/16, },
				{ -2/16, -7/16, -2/16, -1/16, -6/16, 2/16, },
				{ 1/16, -7/16, -2/16, 2/16, -6/16, 2/16, },
				{ -2/16, -7/16, 1/16, 2/16, -6/16, 2/16, },
				{ -2/16, -7/16, -2/16, 2/16, -6/16, -1/16, },
				{ -3/16, -6/16, -3/16, 3/16, -2/16, -2/16, },
				{ -3/16, -6/16, 2/16, 3/16, -2/16, 3/16, },
				{ -3/16, -6/16, -3/16, -2/16, -2/16, 3/16, },
				{ 2/16, -6/16, -3/16, 3/16, -2/16, 3/16, },
				{ 1/16, -2/16, -2/16, 2/16, -1/16, 2/16, },
				{ -2/16, -2/16, -2/16, -1/16, -1/16, 2/16, },
				{ -2/16, -2/16, 1/16, 2/16, -1/16, 2/16, },
				{ -2/16, -2/16, -2/16, 2/16, -1/16, -1/16, },
				{ -1/16, -2/16, -2/16, 1/16, 1/16, -1/16, },
				{ -1/16, -2/16, 1/16, 1/16, 1/16, 2/16, },
				{ -2/16, -2/16, -1/16, -1/16, 1/16, 1/16, },
				{ 1/16, -2/16, -1/16, 2/16, 1/16, 1/16, },
				{ 1/16, 1/16, -2/16, 2/16, 2/16, 2/16, },
				{ -2/16, 1/16, -2/16, -1/16, 2/16, 2/16, },
				{ -2/16, 1/16, -2/16, 2/16, 2/16, -1/16, },
				{ -1/16, 1/16, 2/16, 1/16, 2/16, 3/16, },
				{ -1/16, -1/16, -3/16, 1/16, 0/16, -2/16, },
				{ -1/16, 0/16, -4/16, 1/16, 1/16, -3/16, },
				{ -1/16, -5/16, -5/16, 1/16, 0/16, -4/16, },
				{ -1/16, -6/16, -4/16, 1/16, -5/16, -3/16, },	
			},
		},
		sounds = qtcore.node_sound_stone(),
	})
end 

--vessel crafting

qts.register_craft({
	ingredients = {"overworld:clay_lump"},
	results = {"foodstuffs:dishes_clay_greenware"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"craftable:refined_clay_lump"},
	results = {"foodstuffs:dishes_stoneware_greenware"},
	near = {"group:workbench"},
})

minetest.register_craft({
	type = "cooking",
	output = "foodstuffs:dishes_clay",
	recipe = "foodstuffs:dishes_clay_greenware",
})

minetest.register_craft({
	type = "cooking",
	output = "foodstuffs:dishes_stoneware",
	recipe = "foodstuffs:dishes_stoneware_greenware",
})

qts.register_craft({
	ingredients = {"overworld:gold_bar"},
	results = {"foodstuffs:cup_gold"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:gold_bar"},
	results = {"foodstuffs:bowl_gold"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:silver_bar"},
	results = {"foodstuffs:cup_silver"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:silver_bar"},
	results = {"foodstuffs:bowl_silver"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:clay_lump 2"},
	results = {"foodstuffs:vessels_clay_greenware"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"craftable:refined_clay_lump 2"},
	results = {"foodstuffs:vessels_stoneware_greenware"},
	near = {"group:workbench"},
})

minetest.register_craft({
	type = "cooking",
	output = "foodstuffs:vessels_empty_clay",
	recipe = "foodstuffs:vessels_clay_greenware",
})

minetest.register_craft({
	type = "cooking",
	output = "foodstuffs:vessels_empty_stoneware",
	recipe = "foodstuffs:vessels_stoneware_greenware",
})

qts.register_craft({
	ingredients = {"overworld:gold_bar 3"},
	results = {"foodstuffs:vessels_empty_gold"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:silver_bar 3"},
	results = {"foodstuffs:vessels_empty_silver"},
	near = {"group:workbench"},
})