--inventory for the player

inventory = {}
inventory.utils = {}
local itemlist_player = {}
local listdata_player = {}
local list_items = {}

local esc = minetest.formspec_escape

--default inventory form getter functions
inventory.get_player_main = function()
	return "image[0,5.2;1,1;gui_hb_bg.png]"..
			"image[1,5.2;1,1;gui_hb_bg.png]"..
			"image[2,5.2;1,1;gui_hb_bg.png]"..
			"image[3,5.2;1,1;gui_hb_bg.png]"..
			"image[4,5.2;1,1;gui_hb_bg.png]"..
			"image[5,5.2;1,1;gui_hb_bg.png]"..
			"image[6,5.2;1,1;gui_hb_bg.png]"..
			"image[7,5.2;1,1;gui_hb_bg.png]"..
			"list[current_player;main;0,5.2;8,1;]"..
			"list[current_player;main;0,6.35;8,3;8]"..
			"image[7,4.2;1,1;inv_trash.png]"..
			"list[detached:trash;main;7,4.2;1,1;]"
end

inventory.get_button_grid = function(playername, current_page, prev_search)
	if not current_page then current_page = 1 end
	--minetest.log("Pages: "..tostring(menu_settings.pages))
	local str = "container[12,0]"..
		"label[0,0;"..tostring(current_page).."/"..tostring(list_items[playername].pages).."]"..
		"container_end[]container[12,0.5]"
	
	local offset = (8*6) * (current_page - 1)
	local counter = 1
	for y = 0,7,1 do
		for x = 0,5,1 do
			if itemlist_player[playername][offset + counter] then
				str = str .. "item_image_button["..tostring(x)..","..tostring(y)..";1,1;"..
				esc(tostring(itemlist_player[playername][offset + counter])) .. 
				";btn_item_"..tostring(counter)..";]"
				counter = counter + 1
			end
		end
	end
	str = str .. "container_end[]"..
		"container[12, 8.5]"..
		"image_button[0,0.1;1,1;lshift.png;btn_page_back;]"..
		"image_button[5,0.1;1,1;rshift.png;btn_page_forward;]"..
		"field[1.4,0.4;3,1;search_bar;entry_search:;"..esc(prev_search).."]"..
		"field_close_on_enter[search_bar;false]"..
		"image_button[4,0.1;1,1;inv_glass.png;btn_search;]"..
		"container_end[]"
	
	return str
end

inventory.get_util_bar = function()
	local str = "container[0, 9.5]"
	
	for i, btn in ipairs(inventory.utils) do
		str = str .. "button["..tostring(i-1)..",0;1,1;util_btn_"..tostring(i)..";"..esc(btn.label).."]"
	end
	
	str = str .. "container_end[]"
	return str
end

inventory.get_default_size = function()
	return "size[18,10.5]"
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
	if #list_items ~= 0 then return end --in case this is called twice
	local count = 0
	for name, def in pairs(minetest.registered_items) do
		if (def.groups.not_in_creative_inventory ~= 1) and def.description and def.description ~= "" then
			list_items[#list_items + 1] = name
			count = count + 1
		end
	end
	table.sort(list_items)
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
	if itemlist_player[playername] and #itemlist_player[playername] ~= 0 then 
		for id, name in ipairs(itemlist_player[playername]) do
			itemlist_player[playername][id] = nil --clear the list
		end
	end --this only inits the list
	if not itemlist_player[playername] then itemlist_player[playername] = {} end
	if not list_items[playername] then list_items[playername] = {} end
	inventory.init_item_list()
	local order = {}
	for id, name in ipairs(list_items) do
		--local def = minetest.registered_items[name]
		--TODO: add group filtering
		local m = match(minetest.registered_items[name].description, filter) or match(name, filter)
		if m then
			itemlist_player[playername][#itemlist_player[playername]+1] = name
			order[name] = string.format("%02d", m) .. name
		end
	end
	table.sort(itemlist_player[playername], function(a,b) return order[a] < order[b] end)
	list_items[playername].count = #itemlist_player[playername]
	list_items[playername].pages = math.ceil(#itemlist_player[playername] / (8*6))
end

--refreshing the player inv
inventory.refresh_inv = function(player, tab)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	if not tab then tab = 1 end
	player:set_inventory_formspec(qts.show_gui(player:get_pos(), player, "inventory", tab, false)[2]) 
end

--create trash can
local trash = minetest.create_detached_inventory("trash", {
	-- Allow the stack to be placed and remove it in on_put()
	-- This allows the creative inventory to restore the stack
	allow_put = function(inv, listname, index, stack, player)
		if type(player) ~= "string" then player = player:get_player_name() end
		if qts.isCreativeFor(player) then
			return stack:get_count()
		else
			return 0
		end
	end,
	on_put = function(inv, listname)
		inv:set_list(listname, {})
	end,
})
trash:set_size("main", 1)

--register util buttons
--TODO: make more util buttons

inventory.register_util_btn("Test", function(playername)
	minetest.log(playername.." has pressed the test button")
end)
--minetest.set_timeofday(val)
inventory.register_util_btn("Morning!", function(playername)
	minetest.set_timeofday(0.25)
end)



--register the main player inventory gui
qts.register_gui("inventory", {
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
		
		for i = 1,6*8,1 do
			if fields["btn_item_"..tostring(i)] then
				if qts.isCreativeFor(name) then
					local inv = minetest.get_player_by_name(name):get_inventory()
					local item_name = itemlist_player[name][offset + i]
					inv:add_item("main", item_name .. " " .. (minetest.registered_items[item_name].stack_max or 99))
				end
			end
		end
		
		--back and foreward buttons
		if fields.btn_page_back then
			page = page - 1
			if page <= 0 then page = list_items[name].pages end
			data.player_item_list_page = page
			inventory.refresh_inv(name)
			return
		end
		if fields.btn_page_forward then
			page = page + 1
			if page > list_items[name].pages then page = 1 end
			data.player_item_list_page = page
			inventory.refresh_inv(name)
			return
		end
		
		if fields.btn_search or fields.key_enter_field then
			page = 1
			data.player_item_list_page = page
			data.prev_search = fields.search_bar
			inventory.gen_item_list_for_player (name, fields.search_bar)
			inventory.refresh_inv(name)
			return
		end
		
		
		for i, btn in ipairs(inventory.utils) do
			if fields["util_btn_"..tostring(i)] then
				btn.on_click(name)
			end
		end
	end,
})
qts.set_inventory_qui_name("inventory")

qts.register_gui("inv_tab_craft", {
	tab = true,
	caption = "Crafting",
	owner = "inventory",
	get = function(data, pos, name)
		return "list[current_player;craft;1.75,0.5;3,3;]"..
			"list[current_player;craftpreview;5.75,1.5;1,1;]"..
			"image[4.75,1.5;1,1;inventory_craft_arrow.png]"..
			"listring[current_player;main]"..
			"listring[current_player;craft]"..
			inventory.get_player_main()..
			inventory.get_button_grid(name, data.player_item_list_page, data.prev_search)..
			inventory.get_util_bar()
	end,
	handle = function(data, pos, name, fields)
		return
	end,
})


minetest.register_on_joinplayer(function(player)
	local formspec = [[
			bgcolor[#080808BB;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]]
	local name = player:get_player_name()
	local info = minetest.get_player_information(name)
	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end
	player:set_formspec_prepend(formspec)

	-- Set hotbar textures
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
	
	inventory.gen_item_list_for_player(name)
	player:set_inventory_formspec(qts.show_gui(player:get_pos(), player, "inventory", 1, false)[2]) 
	
end)

