--[[
Legacy GUI for Inventory
]]

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
		
		--things that modify the item list
		if fields.btn_search or fields.key_enter_field or fields.craftonly_toggle then
			page = 1
			data.player_item_list_page = page
			data.prev_search = fields.search_bar
			
			if (fields.craftonly_toggle) then
				--craftable only visiblity
				qts.gui.click(name)
				data.craftonly_mode_enabled = not data.craftonly_mode_enabled
			end
			
			inventory.gen_item_list_for_player (name, fields.search_bar, data.craftonly_mode_enabled)
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
--qts.gui.set_inventory_gui_name("inventory") --set it to the main inventory


qts.gui.register_gui("inv_tab_equipment", {
	tab = true,
	caption = "Equipment",
	owner = "inventory",
	get = function(data, pos, name)
		return inventory.get_player_main()..
			inventory.get_player_equipment(name)..
			inventory.get_button_grid(name, data.player_item_list_page,
				data.prev_search, data.cheat_mode_enabled, data.craftonly_mode_enabled)..
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
				data.prev_search, data.cheat_mode_enabled, data.craftonly_mode_enabled)..
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
				data.prev_search, data.cheat_mode_enabled, data.craftonly_mode_enabled)
			--inventory.get_util_bar()
	end,
	handle = function(data, pos, name, fields)
		return false
	end,
})