--[[
Legacy GUI for Inventory
]]

local esc = minetest.formspec_escape

local function P(x,y) return qts.gui.gui_makepos(x,y):get() end
local function S(x,y) return qts.gui.gui_makesize(x,y):get() end


local special_equipment_slots = {
	{group="helmet",  template="inv_helmet.png",  pos=P(2.5,0)},
	{group="gloves",  template="inv_gloves.png",  pos=P(  2,1)},
	{group="shield",  template="inv_shield.png",  pos=P(  3,1)},
	{group="cuirass", template="inv_cuirass.png", pos=P(  2,2)},
	{group="cloak",   template="inv_cloak.png",   pos=P(  3,2)},
	{group="boots",   template="inv_boots.png",   pos=P(2.5,3)},
}
local equipment_slots_general_count = 12


--default inventory form getter functions
function inventory.get_player_main(pos, showTrash)
	--pos = inventory.convert_pos(pos)
	--local x, y = pos.x, pos.y
	if showTrash == nil then showTrash = true end
	if not pos then pos = qts.gui.gui_makepos(0, 5.1) end
	local str =  "container["..pos:get().."]" --.. 
		--"background9[0,0;"..S(9.5,3.5)..";gui_buttonareabg.png;false;16]"
	for i = 0,10 do
		str = str .. "image["..P(i,0)..";1,1;gui_hb_bg.png]"
	end
	str = str .."list[current_player;main;"..P(0,0)..";10,1;]"..
		"list[current_player;main;"..P(0,1.15)..";10,3;10]"
		
	if showTrash then
		str = str .. "image["..P(10,0)..";1,1;inv_trash.png]"..
			"list[detached:trash;main;"..P(10,0)..";1,1;]"
	end
	str = str.. "container_end[]"
	return str
end

function inventory.get_player_equipment(playername, pos)
	if not pos then pos = qts.gui.gui_makepos(0,0) end
	local str = "container["..pos:get().."]"
		for k, t in ipairs(special_equipment_slots) do
			str = str .. 
			"image["..t.pos..";1,1;".. t.template .. "]" .. 
			"list[current_player;equipment;"..t.pos..";1,1;"..tostring(k-1).."]"
		end
		local totalSlots = equipment_slots_general_count + (qts.get_player_bonus_equipment_slots(playername) or 0)
		local width = math.floor(totalSlots / 4)
		local extras = totalSlots % 4

		for k = 1,width do
			str = str .. "list[current_player;equipment;" .. P(4.5+(k-1),0)..";1,4;"..
			tostring(#special_equipment_slots + ((k-1)*4)).."]"
		end 
		str = str .."list[current_player;equipment;" .. P(4.5+width,0)..";1,"..tostring(extras)..";"..
			tostring(#special_equipment_slots+(width*4)).."]"


		if playername then
			--minetest.log("Equipment Inventory player name:" .. dump(playername))
			local player = minetest.get_player_by_name(playername)
			local armor_groups = player:get_armor_groups()
			local hp = qts.get_player_hp(player)
			local hpmax = qts.get_player_hp_max(player)
			--display the player model (currently breaks after inv. change in any way?)
			str = str .. "background9["..P(0,0)..";2,5;gui_buttonareabg.png;false;16]".. 
				"container["..P(0,0).."]"..
				"model[0,0;2,4;player_display;character.x;"..esc(qts.humanoid_texture(player, "player_base.png"))..";0,180;false;true;0,79;30".. qts.select(ENGINE_VERSION_FORMSPEC_MODEL_FIX, ";0,10,0;", "") .. "]" ..
				"container_end[]"..
				"image["..P(0,4)..";1,1;inv_health_icon.png]" ..
				"tooltip["..P(0,4)..";1,1;Health/Max]"..
				"hypertext["..P(0.8,4)..";3,1;health_label;<global valign=middle halign=left><bigger><b>" .. tostring(hp) .. "/" .. tostring(hpmax) .."</b></bigger>]"
			
			if armor_groups.fleshy then
				str = str .. "image["..P(3,4)..";1,1;inv_fleshy_icon.png]" ..
					"tooltip["..P(3,4)..";1,1;Melee (fleshy) Armor]"..
					"hypertext["..P(3.8,4)..";2,1;health_label;<global valign=middle halign=left><bigger><b>" .. tostring(armor_groups.fleshy-1) .."</b></bigger>]"
			end
			if armor_groups.stabby then
				str = str .. "image["..P(5,4)..";1,1;inv_stabby_icon.png]" ..
					"tooltip["..P(5,4)..";1,1;Projectile (stabby) Armor]"..
					"hypertext["..P(5.8,4)..";2,1;health_label;<global valign=middle halign=left><bigger><b>" .. tostring(armor_groups.stabby-1) .."</b></bigger>]"
			end
			if armor_groups.psycic then
				str = str .. "image["..P(7,4)..";1,1;inv_psycic_icon.png]" ..
					"tooltip["..P(7,4)..";1,1;Magic (psycic) Armor]"..
					"hypertext["..P(7.8,4)..";2,1;health_label;<global valign=middle halign=left><bigger><b>" .. tostring(armor_groups.psycic-1) .."</b></bigger>]"
			end
			if armor_groups.enviromental then
				str = str .. "image["..P(9,4)..";1,1;inv_enviromental_icon.png]" ..
					"tooltip["..P(9,4)..";1,1;Enviromental Armor]"..
					"hypertext["..P(9.8,4)..";2,1;health_label;<global valign=middle halign=left><bigger><b>" .. tostring(armor_groups.enviromental-1) .."</b></bigger>]"
			end
		end
		str = str .."container_end[]"
		
	return str
end

function inventory.get_button_grid(playername, current_page, prev_search, cheat_mode, craftonly_mode, pos)
	if not current_page then current_page = 1 end
	if not prev_search then prev_search = "" end
	if not pos then pos = qts.gui.gui_makepos(11.5, 0) end
	
	local str = "container["..pos:get().."]"..
		"background9[0,0;"..S(5.6,9.4)..";gui_buttonareabg.png;false;16]"..
		"label["..P(0,0)..";"..tostring(current_page).."/"..tostring(inventory.listdata_player[playername].pages).."]"..
		"container["..P(0,0).."]"
	
	local offset = (8*6) * (current_page - 1)
	local counter = 1
	for y = 0,7,1 do
		for x = 0,5,1 do
			if inventory.itemlist_player[playername][offset + counter] then
				str = str .. "item_image_button["..P(x,y)..";1,1;"..
				esc(tostring(inventory.itemlist_player[playername][offset + counter])) .. 
				";btn_item_"..tostring(counter)..";]"
				if qts.ISDEV then
					local name = tostring(inventory.itemlist_player[playername][offset + counter])
					str=str.."tooltip[btn_item_" .. tostring(counter) .. ";" ..esc(minetest.registered_items[name].description .. "\n" .. name).. "]"
				end
				counter = counter + 1
			end
		end
	end
	local cheat_img = "gui_toggle_off.png"
	if (cheat_mode) then cheat_img = "gui_toggle_on.png" end

	local craftonly_img = "gui_toggle_off.png"
	if (craftonly_mode) then craftonly_img = "gui_toggle_on.png" end
	
	str = str .. "container_end[]"..
		"container["..P(0,8.5).."]"..
		"image_button["..P(0,0)..";1,1;lshift.png;btn_page_back;]"..
		"image_button["..P(5,0)..";1,1;rshift.png;btn_page_forward;]"..
		"field["..P(1,0)..";3,1;search_bar;Search:;"..esc(prev_search).."]"..
		"field_close_on_enter[search_bar;false]"..
		"image_button["..P(4,0)..";1,1;inv_glass.png;btn_search;]"..
		--cheat toggle button
		"style[cheat_toggle;bgimg=Transparent.png;"..
			"bgimg_hovered=Transparent.png;bgimg_pressed=Transparent.png;"..
			"bgimg_middle=0;border=false]"..
		"image_button["..P(5,1)..";1,0.5;"..cheat_img..";cheat_toggle;]"..
		"tooltip[cheat_toggle;Toggle Cheat Mode]"..
		--craftonly toggle button
		"style[craftonly_toggle;bgimg=Transparent.png;"..
			"bgimg_hovered=Transparent.png;bgimg_pressed=Transparent.png;"..
			"bgimg_middle=0;border=false]"..
		"image_button["..P(0,1)..";1,0.5;"..craftonly_img..";craftonly_toggle;]"..
		"tooltip[craftonly_toggle;Toggle Craftable Only Mode]"..
		
		
		"container_end[]"..
		"container_end[]"
	--minetest.log(str)
	return str
end

function inventory.get_util_bar(pos)
	if not pos then pos = qts.gui.gui_makepos(0, 9.5) end
	local str = "container["..pos:get().."]"
	
	for i, btn in ipairs(inventory.utils) do
		str = str .. "button["..P(i-1,0)..";1,1;util_btn_"..tostring(i)..";"..esc(btn.label).."]"
	end
	
	str = str .. "container_end[]"
	return str
end

function inventory.get_craft_area(data, name, pos)
	if not pos then pos = qts.gui.gui_makepos(0, 0) end
	local cs = ""
	local needs_craft_imgs = true
	local recipe_list = data.currRecipeList
	local recipe_index = data.currRecipeIndex
	if recipe_list and recipe_index then
		if not (recipe_list[recipe_index]) then
			recipe_index = 0
		end
		local resultItemName = ItemStack(data.currRecipeItem):get_name()
		cs = cs .. "label["..P(5.5,0)..";Recipe: "..recipe_index.."]"..
				"label["..P(5.5,0.4)..";Result: ".. (minetest.registered_items[resultItemName].description or "ERROR") .."]"
		local recip = recipe_list[recipe_index]
		if recip then
			local i = 0
			local j = 0
			for item, v in pairs(recip.ingredients) do
				local name = ItemStack(item):get_name()
				local count = ItemStack(item):get_count()
				local desc = "ERROR-TYPE"
				if minetest.registered_items[name] then
					desc = minetest.registered_items[name].description
				end
				if (qts.is_group(item)) then
					name = qts.remove_modname_from_item(name)
					cs = cs .."item_image["..P(i%3,j)..";1,1;".. (inventory.exemplar[name] or "inventory:groupItem") .. " " ..count.."]"..
						"tooltip["..P(i,j)..";1,1;Group: ".. name .. " " .. count .."]"
				else
					cs = cs .."item_image["..P(i%3,j)..";1,1;" ..item.."]"..
						"tooltip["..P(i%3,j)..";1,1;".. desc .. " " .. count .."]"
				end
				i = i+1;
				if i > 2 then j = j+1 end
				if j > 2 then break end
			end
			i = 0
			for item, v in pairs(recip.results) do
				local name = ItemStack(item):get_name()
				local count = ItemStack(item):get_count()
				local desc = "ERROR-TYPE"
				if minetest.registered_items[name] then
					desc = minetest.registered_items[name].description
				end
				cs = cs .."item_image["..P(i+4.5,1)..";1,1;" ..item.."]"..
					"tooltip["..P(i+4.5,1)..";1,1;".. desc .. " " .. count .."]"
				i = i+1;
				if i > 4 then break end
			end

			if recip.type ~= "reference" then
				--near items
				i = 0
				for item, v in pairs(recip.near) do
					local name = ItemStack(item):get_name()
					local count = ItemStack(item):get_count()
					local desc = "ERROR-TYPE"
					if minetest.registered_items[name] then
						desc = minetest.registered_items[name].description
					end
					if (qts.is_group(item)) then
						name = qts.remove_modname_from_item(name)
						cs = cs .."item_image["..P(i,4)..";1,1;".. (inventory.exemplar[name] or "inventory:groupItem") .. "]"..
							"tooltip["..P(i,4)..";1,1;Group: ".. name .. " ("..count..")" .. "]"
					else
						cs = cs .."item_image["..P(i,4)..";1,1;" ..item.."]"..
							"tooltip["..P(i,4)..";1,1;".. desc .. "]"
					end
					i = i+1;
					if i > 4 then break end
				end
				i = 0
				--held items
				for item, v in pairs(recip.held) do
					local name = ItemStack(item):get_name()
					local desc = "ERROR-TYPE"
					if minetest.registered_items[name] then
						desc = minetest.registered_items[name].description
					end
					if (qts.is_group(item)) then
						name = qts.remove_modname_from_item(name)
						cs = cs .."item_image["..P(i+5.5,4)..";1,1;".. (inventory.exemplar[name] or "inventory:groupItem") .. "]"..
							"tooltip["..P(i+5.5,4)..";1,1;Group: ".. name .. "]"
					else
						cs = cs .."item_image["..P(i+5.5,4)..";1,1;" ..item.."]"..
							"tooltip["..P(i+5.5,4)..";1,1;".. desc .. "]"
					end
					i = i+1;
					if i > 4 then break end
				end

				if (qts.player_can_craft(recip, name)) then
					cs = cs .. "image_button["..P(5,2.25)..";1,1;gui_one.png;craft_one;]" ..
						"image_button["..P(6.5,2.25)..";1,1;gui_ten.png;craft_ten;]"..
						"image_button["..P(8,2.25)..";1,1;gui_all.png;craft_all;]"
					needs_craft_imgs = false
				end
				--add the labels back in
				cs = "label["..P(0,3.9)..";Required Nearby Nodes:]"..
					"label["..P(5.5,3.9)..";Required Held Items:]".. 
					cs

			else
				needs_craft_imgs = false
				cs = "label["..P(0,3.9)..";"..esc(recip.description).."]" .. cs
			end
		end
	end
	if (needs_craft_imgs) then
		cs = cs .. 
			"image["..P(5,2.25)..";1,1;gui_hb_bg.png]"..
			"image["..P(6.5,2.25)..";1,1;gui_hb_bg.png]"..
			"image["..P(8,2.25)..";1,1;gui_hb_bg.png]"..
			"image["..P(5,2.25)..";1,1;gui_one.png]"..
			"image["..P(6.5,2.25)..";1,1;gui_ten.png]"..
			"image["..P(8,2.25)..";1,1;gui_all.png]"
	end
	return "container["..pos:get().."]" .. 
		"background9["..P(-0.25,-0.25)..";"..S(2,2)..";gui_buttonareabg.png;false;16]"..
		"background9["..P(4.25,0.75)..";"..S(4,0)..";gui_buttonareabg.png;false;16]"..
		"image["..P(3.25,1)..";1,1;inventory_craft_arrow.png]"..
		"image_button["..P(4.5, -0.25)..";1,1;lshift.png;craft_prev;]"..
			"tooltip["..P(4.5,-0.25)..";1,1;Prev Recipe]"..
		"image_button["..P(8.5, -0.25)..";1,1;rshift.png;craft_next;]"..
			"tooltip["..P(8.5,-0.25)..";1,1;Next Recipe]"..
		cs ..
		"container_end[]"
end

function inventory.get_default_size()
	--return "size[18,10.5]"
	return "size["..qts.gui.gui_makesize(18, 10.5):get().."]real_coordinates[true]"
end

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