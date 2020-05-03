
local esc = minetest.formspec_escape

local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
local S = function(x,y) return qts.gui.gui_makesize(x,y):get() end

--default inventory form getter functions
inventory.get_player_main = function(pos, showTrash)
	--pos = inventory.convert_pos(pos)
	--local x, y = pos.x, pos.y
	if showTrash == nil then showTrash = true end
	if not pos then pos = qts.gui.gui_makepos(0, 5.1) end
	local str =  "container["..pos:get().."]"
	for i = 0,7 do
		str = str .. "image["..P(i,0)..";1,1;gui_hb_bg.png]"
	end
	str = str .."list[current_player;main;"..P(0,0)..";8,1;]"..
		"list[current_player;main;"..P(0,1.15)..";8,3;8]"
		
	if showTrash then
		str = str .. "image["..P(7,-1)..";1,1;inv_trash.png]"..
			"list[detached:trash;main;"..P(7,-1)..";1,1;]"
	end
	str = str.. "container_end[]"
	return str
end

inventory.get_button_grid = function(playername, current_page, prev_search, pos)
	if not current_page then current_page = 1 end
	if not prev_search then prev_search = "" end
	if not pos then pos = qts.gui.gui_makepos(12, 0) end
	
	--minetest.log(dump(pos:get()))
	
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
				counter = counter + 1
			end
		end
	end
	str = str .. "container_end[]"..
		"container["..P(0,8.5).."]"..
		"image_button["..P(0,0)..";1,1;lshift.png;btn_page_back;]"..
		"image_button["..P(5,0)..";1,1;rshift.png;btn_page_forward;]"..
		"field["..P(1,0)..";3,1;search_bar;entry_search:;"..esc(prev_search).."]"..
		"field_close_on_enter[search_bar;false]"..
		"image_button["..P(4,0)..";1,1;inv_glass.png;btn_search;]"..
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

inventory.get_craft_area = function(pos)
	if not pos then pos = qts.gui.gui_makepos(1.75, 0.5) end
	return "container["..pos:get().."]"..
			"list[current_player;craft;"..P(0,0)..";3,3;]"..
			"list[current_player;craftpreview;"..P(4,1)..";1,1;]"..
			"image["..P(3,1)..";1,1;inventory_craft_arrow.png]"..
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
		--local def = minetest.registered_items[name]
		--TODO: add group filtering
		local m = match(minetest.registered_items[name].description, filter) or match(name, filter)
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