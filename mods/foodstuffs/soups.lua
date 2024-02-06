--[[

]]


--list of ingredient names
local ingredient={"apple", "goard", "grain", "carrot", "onion", "potatoe"}
--mapping of said name to the actual item used to craft it
local ingredient_map = {
	apple = {item = "overworld:apple",          broth_affinity = 0},
	goard = {item = "farmworks:herb_goard",     broth_affinity = 1},
	grain = {item = "farmworks:herb_grain",     broth_affinity = 2},
	carrot= {item = "farmworks:herb_carrot",    broth_affinity = 3},
	onion = {item = "farmworks:herb_onion",     broth_affinity = 4},
	potatoe={item = "farmworks:herb_potatoe",   broth_affinity = 5},
}


local comb_complete = {}

for i=1, #ingredient do
	for j=i, #ingredient do
		for k=j, #ingredient do
			local ingredient_1 = ingredient[i]
			local ingredient_2 = ingredient[j]
			local ingredient_3 = ingredient[k]
			--this set will have a unique entry for every combination, not permutation
			--so, if both herb_1 and herb_2 are "apple", then they are the same entry in the table, and not two different ones.
			local comb_set = {[ingredient_1]=true, [ingredient_2]=true, [ingredient_3]=true}
			--turn the set into a list
			local comb_list = {}
			for herbname,_ in pairs(comb_set)do
				comb_list[#comb_list+1] = herbname
			end
			--sort the list alphabetically to make sure it stays unique to the combination, not permutation (pairs is not deterministic)
			table.sort(comb_list)

			local comb_name = ""
			local comb_description = ""
			
			--deal with brothiness
			local max_brothiness_value = ingredient_map[comb_list[1]].broth_affinity
			local max_brothiness_name = comb_list[1]
			for l, name in ipairs(comb_list) do
				if ingredient_map[name].broth_affinity > max_brothiness_value then
					max_brothiness_value = ingredient_map[name].broth_affinity
					max_brothiness_name = name
				end		
			end
			
			local comb_textuereSet = "foodstuffs_bowl_clay_top_overlay.png^foodstuffs_soup_"..max_brothiness_name.."_top.png^"
			local comb_invTextureSet = "foodstuffs_soup_"..max_brothiness_name.."_item.png^foodstuffs_bowl_clay_soup_item_overlay.png"
			
			--now, generate a unique string from this for the name
			--also generate a description and node texture
			for l, name in ipairs(comb_list)do
				comb_name = comb_name .. name
				comb_description = comb_description .. qtcore.string_first_to_upper(name)
				if l == 1 then
					comb_textuereSet = comb_textuereSet .. "foodstuffs_soup_overlay_"..name..".png"
				else
					comb_textuereSet = comb_textuereSet .. "foodstuffs_soup_overlay_"..name..".png"
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

				--register the soup node.
				minetest.register_node("foodstuffs:bowl_clay_soup_"..comb_name, {
					description = comb_description .. " Soup",
					tiles = {
						comb_textuereSet,
						"foodstuffs_dishes_clay.png"
					},
					inventory_image = comb_invTextureSet,
					use_texture_alpha="clip",
					groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1, soup=1},
					drawtype = "nodebox",
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
					selection_box = {
						type = "fixed",
						fixed = {
							{ -5/16, -8/16, -5/16, 5/16, -5/16, 5/16, },
						},
					},
					sounds = qtcore.node_sound_stone(),
				})
				
				--build the ingredient list
				local ig_List = {}
				for l, name in ipairs(comb_list) do
					ig_List[l] = ingredient_map[name].item
				end
				ig_List[#ig_List+1] = "foodstuffs:dishes_clay"

				qts.register_craft({
					ingredients = ig_List,
					results = {"foodstuffs:bowl_clay_soup_"..comb_name, "foodstuffs:cup_clay"},
					near = {"group:table", "group:furnace", "group:cookware"},
				})

			end
		end
	end
end