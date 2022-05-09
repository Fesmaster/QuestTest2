
local esc = minetest.formspec_escape

local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
local S = function(x,y) return qts.gui.gui_makesize(x,y):get() end

--default inventory form getter functions
inventory.get_player_main = function(pos, showTrash)
	--pos = inventory.convert_pos(pos)
	--local x, y = pos.x, pos.y
	if showTrash == nil then showTrash = true end
	if not pos then pos = qts.gui.gui_makepos(0, 5.1) end
	local str =  "container["..pos:get().."]" --.. 
		--"background9[0,0;"..S(9.5,3.5)..";gui_buttonareabg.png;false;16]"
	for i = 0,7 do
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

inventory.get_button_grid = function(playername, current_page, prev_search, cheat_mode, pos)
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
		
		"container_end[]"..
		"container_end[]"
	--minetest.log(str)
	return str
end

inventory.get_util_bar = function(pos)
	if not pos then pos = qts.gui.gui_makepos(0, 9.5) end
	local str = "container["..pos:get().."]"
	
	for i, btn in ipairs(inventory.utils) do
		str = str .. "button["..P(i-1,0)..";1,1;util_btn_"..tostring(i)..";"..esc(btn.label).."]"
	end
	
	str = str .. "container_end[]"
	return str
end


minetest.register_craftitem("inventory:groupItem", {
	description = "GROUP ITEM",
	inventory_image = "inv_gear.png",
	groups = {not_in_creative_inventory = 1,},
})

inventory.get_craft_area = function(data, name, pos)
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
					cs = cs .."item_image["..P(i,j)..";1,1;".. (inventory.exemplar[name] or "inventory:groupItem") .. " " ..count.."]"..
						"tooltip["..P(i,j)..";1,1;Group: ".. name .. " " .. count .."]"
				else
					cs = cs .."item_image["..P(i,j)..";1,1;" ..item.."]"..
						"tooltip["..P(i,j)..";1,1;".. desc .. " " .. count .."]"
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

inventory.get_default_size = function()
	--return "size[18,10.5]"
	return "size["..qts.gui.gui_makesize(18, 10.5):get().."]real_coordinates[true]"
end

--registration stuff
inventory.register_util_btn = function(label, on_click)
	if label and on_click then
		inventory.utils[#inventory.utils + 1] = {
			label = label,
			on_click = on_click,
		}
	end
end

inventory.register_exemplar_item =function(group, item)
	if (minetest.registered_items[item]) then
		inventory.exemplar[group] = item
		minetest.log("verbose", "Inventory: exemplar item for " .. group .. " added: " .. item)
	else
		minetest.log("warning", "Inventory: register_exemplar_item: invalid item. please declare first!")
	end
end

--item list stuff
inventory.init_item_list = function()
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

inventory.gen_item_list_for_player = function(playername, filter)
	if not filter then filter = "" end
	if inventory.itemlist_player[playername] and #inventory.itemlist_player[playername] ~= 0 then 
		for id, name in ipairs(inventory.itemlist_player[playername]) do
			inventory.itemlist_player[playername][id] = nil --clear the list
		end
	end --this only inits the list
	if not inventory.itemlist_player[playername] then inventory.itemlist_player[playername] = {} end
	if not inventory.listdata_player[playername] then inventory.listdata_player[playername] = {} end
	inventory.init_item_list()
	local order = {}
	for id, name in ipairs(inventory.list_items) do
		local m = match(minetest.registered_items[name].description, filter) or match(name, filter)
		if not m then
			m = minetest.get_item_group(name, filter)
			if m ==0 then m = nil end
		end
		if m then
			inventory.itemlist_player[playername][#inventory.itemlist_player[playername]+1] = name
			order[name] = string.format("%02d", m) .. name
		end
	end
	table.sort(inventory.itemlist_player[playername], function(a,b) return order[a] < order[b] end)
	inventory.listdata_player[playername].count = #inventory.itemlist_player[playername]
	inventory.listdata_player[playername].pages = math.ceil(#inventory.itemlist_player[playername] / (8*6))
end

--refreshing the player inv
inventory.refresh_inv = function(player, tab)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	if not tab then tab = 1 end
	player:set_inventory_formspec(qts.gui.show_gui(player:get_pos(), player, "inventory", tab, false)[2]) 
end
