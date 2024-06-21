



minetest.register_craftitem("inventory:groupItem", {
	description = "GROUP ITEM",
	inventory_image = "inv_gear.png",
	groups = {not_in_creative_inventory = 1,},
})



--registration stuff
function inventory.register_util_btn(label, on_click)
	if label and on_click then
		inventory.utils[#inventory.utils + 1] = {
			label = label,
			on_click = on_click,
		}
	end
end

---Register an item to show as a groups
---@param group ItemString
---@param item ItemString
---@param collapsed boolean?
function inventory.register_exemplar_item(group, item, collapsed)
	--default values
	if collapsed == nil then collapsed = false end

	--remove any ":" prefix
	if string.sub(item, 1,1) == ":" then
        item = string.gsub(item, ":", "",1)
    end
	if (minetest.registered_items[item]) then
		inventory.exemplar[group] = item
		minetest.log("verbose", "Inventory: exemplar item for " .. group .. " added: " .. item)
		if collapsed then
			inventory.collapse_groups[group] = item
		end
	else
		minetest.log("warning", "Inventory: register_exemplar_item: invalid item ["..dump(item).."]. please declare first!")
	end
end

--item list stuff
function inventory.init_item_list()
	if #inventory.list_items ~= 0 then return end --in case this is called twice
	local count = 0
	for name, def in pairs(minetest.registered_items) do
		if (def.groups.not_in_creative_inventory ~= 1) and def.description and def.description ~= "" then
			inventory.list_items[#inventory.list_items + 1] = name
			count = count + 1
		end
	end
	table.sort(inventory.list_items)
	--menu_settings.len = count
	--menu_settings.pages = math.ceil(count / (8*6)) --size of a page is 8*6
	--minetest.log(menu_settings.pages)
	--minetest.log(count)
end

local function match(s, filter)
	if filter == "" then
		return 0
	end
	if s:lower():find(filter, 1, true) then
		return #s - #filter
	end
	return nil
end



---Get the size of the catalog page
---@return {width:number,height:number,count:number}
function inventory.get_catalog_dimentions()
	local ret = {
		width=inventory.CATALOG_WIDTH:get(), 
		height=inventory.CATALOG_HEIGHT:get(),
	}
	ret.count = ret.width * ret.height
	return ret
end

function inventory.gen_item_list_for_player(playername, filter, craftonly)
	if not filter then filter = "" end
	if not inventory.itemlist_player[playername] then inventory.itemlist_player[playername] = {} end
	if not inventory.listdata_player[playername] then inventory.listdata_player[playername] = {} end
	local playerlist = inventory.itemlist_player[playername] -- local for faster access
	--if craftonly == nil then craftonly = false end --nil is false
	if playerlist and #playerlist ~= 0 then 
		for id, name in ipairs(playerlist) do
			playerlist[id] = nil --clear the list
		end
	end --this only inits the list
	inventory.init_item_list()
	local order = {}
	local collapse_groups = (filter == "")
	local filter_is_group = string.sub(filter, 1, 6) == "group:"
	if (filter_is_group) then
		filter = string.sub(filter, 7, -1)
	end
	for id, name in ipairs(inventory.list_items) do
		local match_closeness = nil
		if (not filter_is_group) then
			match_closeness = match(minetest.registered_items[name].description, filter) or match(name, filter)
		end
		if not match_closeness then
			match_closeness = minetest.get_item_group(name, filter)
			if match_closeness == 0 then match_closeness = nil end
		end
		if match_closeness and craftonly then
			if not qts.player_can_craft_item(name, playername) then
				match_closeness = nil
			end
		end

		if collapse_groups then
			for group, root in pairs(inventory.collapse_groups) do
				if minetest.get_item_group(name, group) > 0 then
					-- collapse, unless its the id item
					if name == root then
						-- replace with group
						name = "group:"..group
					else
						-- collapse
						match_closeness = nil
					end
				end
			end
		end

		if match_closeness then
			playerlist[#playerlist+1] = name
			order[name] = string.format("%02d", match_closeness) .. name
		end
	end
	table.sort(playerlist, function(a,b) return order[a] < order[b] end)
	inventory.listdata_player[playername].count = #playerlist
	inventory.listdata_player[playername].pages = math.ceil(#playerlist / inventory.get_catalog_dimentions().count)
end

function inventory.gen_favorite_list_for_player(playername, filter, craftonly)
	if not filter then filter = "" end
	if not inventory.favoritelist_filtered_player[playername] then inventory.favoritelist_filtered_player[playername] = {} end
	if not inventory.listdata_player[playername] then inventory.listdata_player[playername] = {} end
	
	local favlist = inventory.favoritelist_filtered_player[playername] -- local for faster access
	--if craftonly == nil then craftonly = false end --nil is false
	if favlist and #favlist ~= 0 then 
		for id, name in ipairs(favlist) do
			favlist[id] = nil --clear the list
		end
	end --this only inits the list
	inventory.init_item_list()
	local order = {}
	local filter_is_group = string.sub(filter, 1, 6) == "group:"
	if (filter_is_group) then
		filter = string.sub(filter, 7, -1)
	end
	for name, _ in pairs(inventory.favoritelist_player[playername]) do
		local match_closeness = nil
		if (not filter_is_group) then
			match_closeness = match(minetest.registered_items[name].description, filter) or match(name, filter)
		end
		if not match_closeness then
			match_closeness = minetest.get_item_group(name, filter)
			if match_closeness == 0 then match_closeness = nil end
		end
		if match_closeness and craftonly then
			if not qts.player_can_craft_item(name, playername) then
				match_closeness = nil
			end
		end

		if match_closeness then
			favlist[#favlist+1] = name
			order[name] = string.format("%02d", match_closeness) .. name
		end
	end
	table.sort(favlist, function(a,b) return order[a] < order[b] end)
	inventory.listdata_player[playername].fav_count = #favlist
	inventory.listdata_player[playername].fav_pages = math.ceil(#favlist / inventory.get_catalog_dimentions().count)
end

function inventory.add_item_to_favorites(playername, item)
	local fav = inventory.favoritelist_player[playername]
	if fav == nil then 
		inventory.favoritelist_player[playername] = {}
		fav = inventory.favoritelist_player[playername]
	end
	fav[item] = true
	qts.set_player_data(playername, "inventory", "favorites", fav)
end

function inventory.remove_item_from_favorites(playername, item)
	local fav = inventory.favoritelist_player[playername]
	if fav == nil then 
		inventory.favoritelist_player[playername] = {}
		fav = inventory.favoritelist_player[playername]
	end
	fav[item] = nil
	qts.set_player_data(playername, "inventory", "favorites", fav)
end

function inventory.is_item_favorite(playername, item)
	local fav = inventory.favoritelist_player[playername]
	if fav == nil then 
		inventory.favoritelist_player[playername] = {}
		fav = inventory.favoritelist_player[playername]
	end
	if fav[item] then
		return true
	else
		return false
	end
end



function inventory.init_inventory(player)

	local formspec = [[
		bgcolor[#080808BB;true]
		listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] 
		style_type[button,button_exit,image_button,item_image_button;
			bgimg=gui_button.png;
			bgimg_hovered=gui_button_hovered.png;
			bgimg_pressed=gui_button_clicked.png;
			bgimg_middle=8;
			border=false]
	]]

	local playername = player:get_player_name()
	local info = minetest.get_player_information(playername)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)

	--set the inventory properties
	local inv = player:get_inventory()
	inv:set_size("main", 10*4)
	inv:set_size("equipment", 6*5)

	--refresh all items in equipment list
	for index =1,6*5 do
		local stack = inv:get_stack("equipment", index)
		if not stack:is_empty() then
			local itemname = stack:get_name()
			local itemdef = minetest.registered_items[itemname]
			if itemdef and itemdef.on_equip then
				local replace_stack = itemdef.on_equip(player, stack)
				if replace_stack then
					inv:set_stack("equipment", index, replace_stack)
				end
			end
		end
	end

	--generate item lists and refresh inventory
	inventory.favoritelist_player[playername] = qts.get_player_data(player, "inventory", "favorites")
	if inventory.favoritelist_player[playername] == nil then
		inventory.favoritelist_player[playername] = {}
	end
	inventory.gen_item_list_for_player(playername, "", false)
	inventory.gen_favorite_list_for_player(playername, "", false)
	inventory.refresh_inv(player)
end

--refreshing the player inv
function inventory.refresh_inv(player, tab)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	if not tab then tab = 1 end
	local formspec_code = qts.gui.show_gui(player:get_pos(), player, qts.gui.get_inventory_gui_name(), tab, false)[2]
	player:set_inventory_formspec(formspec_code) 
end

function inventory.check_equiped_item_add(slot, itemstack)
	local item_name = itemstack:get_name()
	if slot > #inventory.special_equipment_slots then
		return  minetest.get_item_group(item_name,"equipment") ~= 0
	else
		return minetest.get_item_group(item_name,inventory.special_equipment_slots[slot].group)  ~= 0
	end
end


--FUNCTION OVERRIDE
---@diagnostic disable-next-line: duplicate-set-field
function qts.get_player_equipment_list(player)
	local retval = {}

	local inv = player:get_inventory()
	for index = 1,#inventory.special_equipment_slots+inventory.equipment_slots_general_count do
		local stack = inv:get_stack("equipment", index)
		table.insert(retval, stack)
	end

	return retval
end

--[[
	chatcommand to check and verify all crafting recipes
]]
if qts.ISDEV then
	minetest.register_chatcommand("verifycrafting", {
		params = "",
		description = "verify that all craft recipes have only registered items and all groups have exemplar items",
		privs={},
		func = function (name, param)
			local unknown_items = {}
			local unaliased_groups = {}
			local found_unknown = false
			local found_unaliased = false
			for resultname, craftlist in pairs(qts.crafts) do
				for i, recipe in ipairs(craftlist) do
					--check everything!!!
					for ingredient, _ in pairs(recipe.ingredients) do
						local itemname = string.split(ingredient, " ", false, 1, false)[1]

						if not (minetest.registered_items[itemname]) then
							if qts.is_group(itemname) then
								local groupname = qts.remove_modname_from_item(itemname)
								if not (inventory.exemplar[groupname]) then
									--non-exemplar group
									unaliased_groups[groupname] = true
									found_unaliased = true
								end
							else
								--not known!!
								unknown_items[itemname] = true
								found_unknown=true
							end
						end
					end

					for near, _ in pairs(recipe.near) do
						local itemname = string.split(near, " ", false, 1, false)[1]

						if not (minetest.registered_items[itemname]) then
							if qts.is_group(itemname) then
								local groupname = qts.remove_modname_from_item(itemname)
								if not (inventory.exemplar[groupname]) then
									--non-exemplar group
									unaliased_groups[groupname] = true
									found_unaliased = true
								end
							else
								--not known!!
								unknown_items[itemname] = true
								found_unknown=true
							end
						end
					end

					for held, _ in pairs(recipe.held) do
						local itemname = string.split(held, " ", false, 1, false)[1]

						if not (minetest.registered_items[itemname]) then
							if qts.is_group(itemname) then
								local groupname = qts.remove_modname_from_item(itemname)
								if not (inventory.exemplar[groupname]) then
									--non-exemplar group
									unaliased_groups[groupname] = true
									found_unaliased = true
								end
							else
								--not known!!
								unknown_items[itemname] = true
								found_unknown=true
							end
						end
					end

					for result, _ in pairs(recipe.results) do
						local itemname = string.split(result, " ", false, 1, false)[1]

						if not (minetest.registered_items[itemname]) then
							if qts.is_group(itemname) then
								local groupname = qts.remove_modname_from_item(itemname)
								if not (inventory.exemplar[groupname]) then
									--non-exemplar group
									unaliased_groups[groupname] = true
									found_unaliased = true
								end
							else
								--not known!!
								unknown_items[itemname] = true
								found_unknown=true
							end
						end
					end
				end
			end

			--print the output
			if (found_unaliased or found_unknown) then
				minetest.log("Craft Verification Results: FAILURE")

				if found_unaliased then
					local groupstr = ""
					for group, _ in pairs(unaliased_groups) do
						groupstr = groupstr .. dump(group) .. "\n"
					end
					minetest.log("Groups without exemplar items found:\n"..groupstr)
				end

				if found_unknown then
					local itemsstr = ""
					for item, _ in pairs(unknown_items) do
						itemsstr = itemsstr .. dump(item) .. "\n"
					end
					minetest.log("Unregistered items found:\n"..itemsstr)
				end

			else
				minetest.log("Craft Verification Results: SUCESS")
			end
		end
	})

end