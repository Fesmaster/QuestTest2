--inventory for the player
--functions.lua
inventory = {}
inventory.utils = {}
inventory.itemlist_player = {}
inventory.listdata_player = {}
inventory.list_items = {}
inventory.exemplar = {}

local esc = minetest.formspec_escape
local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
dofile(minetest.get_modpath("inventory") .."/functions.lua")
dofile(minetest.get_modpath("inventory") .."/detached.lua")
dofile(minetest.get_modpath("inventory") .."/hud.lua")
--dofile(minetest.get_modpath("inventory") .."/exemplar.lua")


--register util buttons
--TODO: make more util buttons

--minetest.set_timeofday(val)
inventory.register_util_btn("Morning!", function(playername)
	minetest.set_timeofday(0.25)
end)

inventory.register_util_btn("Night!", function(playername)
	minetest.set_timeofday(0.85)
end)



--register the main player inventory gui
qts.gui.register_gui("inventory", {
	tab_owner = true,
	get = function(data, pos, name)
		if not data.player_item_list_page then data.player_item_list_page = 1 end
		if not data.prev_search then data.prev_search = "" end
		return inventory.get_default_size()
	end,
	handle = function(data, pos, name, fields)
		if not data.player_item_list_page then data.player_item_list_page = 1 end
		if not data.prev_search then data.prev_search = "" end
		local page = data.player_item_list_page
		local offset = (8*6) * (page-1)
		--item buttons
		for i = 1,6*8,1 do
			if fields["btn_item_"..tostring(i)] then
				qts.gui.click(name)
				local item_name = inventory.itemlist_player[name][offset + i]
				local recipe_list = qts.get_craft_recipes(item_name)
				if recipe_list then
					data.currRecipeList = recipe_list
					data.currRecipeIndex = 1
					data.currRecipeItem = item_name
				end
				
				if qts.is_player_creative(name) and data.cheat_mode_enabled then
					local inv = minetest.get_player_by_name(name):get_inventory()
					local item_name = inventory.itemlist_player[name][offset + i]
					inv:add_item("main", item_name .. " " .. (minetest.registered_items[item_name].stack_max or 99))
					
				else
					data.activeTab = 2
					inventory.refresh_inv(name, 2) --TODO: make sure tab 2 is always crafting tab.
				end
			end
		end
		
		--back and foreward buttons
		if fields.btn_page_back then
			page = page - 1
			if page <= 0 then page = inventory.listdata_player[name].pages end
			data.player_item_list_page = page
			qts.gui.click(name)
			inventory.refresh_inv(name, data.activeTab)
			return
		end
		if fields.btn_page_forward then
			page = page + 1
			if page > inventory.listdata_player[name].pages then page = 1 end
			data.player_item_list_page = page
			qts.gui.click(name)
			inventory.refresh_inv(name, data.activeTab)
			return
		end
		--search button
		if fields.btn_search or fields.key_enter_field then
			page = 1
			data.player_item_list_page = page
			data.prev_search = fields.search_bar
			inventory.gen_item_list_for_player (name, fields.search_bar)
			inventory.refresh_inv(name, data.activeTab)
			return
		end
		
		--util buttons
		for i, btn in ipairs(inventory.utils) do
			if fields["util_btn_"..tostring(i)] then
				btn.on_click(name)
				qts.gui.click(name)
			end
		end
		
		--craft buttions
		if fields.craft_prev then
			qts.gui.click(name)
			local i = (data.currRecipeIndex or 0)-1
			if (i < 1) then
				i = #data.currRecipeList or 1
			end
			data.currRecipeIndex = i
			inventory.refresh_inv(name, data.activeTab)
		end
		
		if fields.craft_next then
			qts.gui.click(name)
			local i = (data.currRecipeIndex or 0)+1
			local l = #data.currRecipeList or 1
			if (i > l) then
				i = 1
			end
			data.currRecipeIndex = i
			inventory.refresh_inv(name, data.activeTab)
		end
		
		if (fields.craft_one) then
			qts.gui.click(name)
			if (data.currRecipeIndex and data.currRecipeList) then
				local recipe = data.currRecipeList[data.currRecipeIndex]
				if (recipe) then
					qts.execute_craft(recipe, name)
					inventory.refresh_inv(name, data.activeTab)
				end
			end
		end
		
		if (fields.craft_ten or fields.craft_all) then
			qts.gui.click(name)
			local count = 0
			if (data.currRecipeIndex and data.currRecipeList) then
				local recipe = data.currRecipeList[data.currRecipeIndex]
				if (recipe) then
					while(qts.player_can_craft(recipe, name)) do
						qts.execute_craft(recipe, name)
						count = count + 1
						if (fields.craft_ten and count >= 10) then
							break
						end
						if (count > 10000) then
							break --prevent inf. crafting loops
						end
					end
					inventory.refresh_inv(name, data.activeTab)
				end
			end
		end
		
		if (fields.cheat_toggle) then
			--toggle cheat mode
			qts.gui.click(name)
			data.cheat_mode_enabled = not data.cheat_mode_enabled
			inventory.refresh_inv(name, data.activeTab)
		end
	end,
	tab_update = function(data, pos, name, fields, tabnumber) --only used for inventory
		inventory.refresh_inv(name, tabnumber)
	end,
})
qts.gui.set_inventory_qui_name("inventory") --set it to the main inventory


qts.gui.register_gui("inv_tab_equipment", {
	tab = true,
	caption = "Equipment",
	owner = "inventory",
	get = function(data, pos, name)
		return inventory.get_player_main()..
			inventory.get_player_equipment(name)..
			inventory.get_button_grid(name, data.player_item_list_page,
				data.prev_search, data.cheat_mode_enabled)..
			inventory.get_util_bar()..
			"listring[current_player;main]listring[current_player;equipment]"
	end,
	handle = function(data, pos, name, fields)
		return false
	end,
})

qts.gui.register_gui("inv_tab_craft", {
	tab = true,
	caption = "Crafting",
	owner = "inventory",
	get = function(data, pos, name)
		return inventory.get_craft_area(data, name)..
			inventory.get_player_main()..
			inventory.get_button_grid(name, data.player_item_list_page,
				data.prev_search, data.cheat_mode_enabled)..
			inventory.get_util_bar()
	end,
	handle = function(data, pos, name, fields)
		return false
	end,
})

qts.gui.register_gui("inv_tab_test", {
	tab = true,
	caption = "Test",
	owner = "inventory",
	get = function(data, pos, name)
		return --inventory.get_player_main()..
			inventory.get_button_grid(name, data.player_item_list_page, 
				data.prev_search, data.cheat_mode_enabled)
			--inventory.get_util_bar()
	end,
	handle = function(data, pos, name, fields)
		return false
	end,
})


minetest.register_on_joinplayer(function(player)
	inventory.init_inventory(player)
	inventory.init_hud(player)
end)



minetest.register_allow_player_inventory_action(function(player, action, inv, inventory_info)
	local handle_equipment = nil
	local returnval = 0
	if action=="move" then
		local stack = inv:get_stack(inventory_info.from_list, inventory_info.from_index)
		if inventory_info.to_list == "equipment" then
			--equipment move!
			handle_equipment = {
				stack = stack,
				receive_stack = inv:get_stack(inventory_info.to_list, inventory_info.to_index),
				index = inventory_info.to_index,
			}
		else
			returnval = stack:get_count()
		end
	elseif action == "put" then
		if inventory_info.listname == "equipment" then
			--equipment put
			handle_equipment = {
				stack = inventory_info.stack,
				receive_stack = inv:get_stack(inventory_info.listname, inventory_info.index),
				index = inventory_info.index,
			}
		else
			returnval = inventory_info.stack:get_count()
		end
	elseif action == "take" then
		returnval = inventory_info.stack:get_count()
	end

	--handle equipment actions
	if handle_equipment then
		if 	inventory.check_equiped_item_add(handle_equipment.index, handle_equipment.stack) and 
			handle_equipment.index <= inventory.equipment_slots_general_count + #inventory.special_equipment_slots + (qts.get_player_bonus_equipment_slots(player) or 0)
		then
			returnval =  handle_equipment.stack:get_count()
		else
			returnval =  0
		end
	end

	return returnval
end)

minetest.register_on_player_inventory_action(function(player, action, inv, inventory_info)
	local refresh_data = nil
	if action=="move" then
		--no need to refresh if its an internal move (armor should never be equipable, or this will break)
		if inventory_info.to_list ~= inventory_info.from_list then
			if inventory_info.to_list == "equipment" then
				refresh_data={
					stack = inv:get_stack(inventory_info.to_list, inventory_info.to_index),
					is_add = true,
					list = "equipment",
					index = inventory_info.to_index,
				}
			elseif inventory_info.from_list == "equipment" then
				refresh_data={
					stack = inv:get_stack(inventory_info.to_list, inventory_info.to_index),
					is_add = false,
					list = inventory_info.to_list,
					index = inventory_info.to_index,
				}
			end
		end
	elseif action == "put" or action == "take" then
		if inventory_info.listname == "equipment" then
			refresh_data={
				stack = inventory_info.stack,
				is_add = action=="put",
				list = inventory_info.listname,
				index = inventory_info.index,
			}
		end
	end

	if refresh_data then
		--call callbacks for equipping items
		local itemname = refresh_data.stack:get_name()
		local itemdef = minetest.registered_items[itemname]
		if itemdef then
			if refresh_data.is_add then
				if itemdef.on_equip then
					local replace_stack = itemdef.on_equip(player, refresh_data.stack)
					if replace_stack then
						inv:set_stack(refresh_data.list, refresh_data.index, replace_stack)
					end
				end
			else
				if itemdef.on_unequip then
					local replace_stack = itemdef.on_unequip(player, refresh_data.stack)
					if replace_stack then
						inv:set_stack(refresh_data.list, refresh_data.index, replace_stack)
					end
				end
			end
		end
		
		--recalculate armor and player image
		--player depends on inventory, so this function is not created yet!
		Player_API.set_textures(player, {qts.humanoid_texture(player, "player_base.png")}) --hardcoded base image
		qts.recalculate_player_armor(player)
		inventory.refresh_inv(player,1)
	end
end)