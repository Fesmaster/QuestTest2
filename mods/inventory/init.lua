--inventory for the player
--functions.lua
inventory = {}
inventory.utils = {}
inventory.itemlist_player = {}
inventory.listdata_player = {}
inventory.list_items = {}

local esc = minetest.formspec_escape
local P = function(x,y) return qts.gui_makepos(x,y):get() end
dofile(minetest.get_modpath("inventory") .."\\functions.lua")
dofile(minetest.get_modpath("inventory") .."\\detached.lua")


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
		--item buttons
		for i = 1,6*8,1 do
			if fields["btn_item_"..tostring(i)] then
				if qts.isCreativeFor(name) then
					local inv = minetest.get_player_by_name(name):get_inventory()
					local item_name = inventory.itemlist_player[name][offset + i]
					inv:add_item("main", item_name .. " " .. (minetest.registered_items[item_name].stack_max or 99))
				end
			end
		end
		
		--back and foreward buttons
		if fields.btn_page_back then
			page = page - 1
			if page <= 0 then page = inventory.listdata_player[name].pages end
			data.player_item_list_page = page
			inventory.refresh_inv(name, data.activeTab)
			return
		end
		if fields.btn_page_forward then
			page = page + 1
			if page > inventory.listdata_player[name].pages then page = 1 end
			data.player_item_list_page = page
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
			end
		end
	end,
	tab_update = function(data, pos, name, fields, tabnumber) --only used for inventory
		inventory.refresh_inv(name, tabnumber)
	end,
})
qts.set_inventory_qui_name("inventory") --set it to the main inventory


qts.register_gui("inv_tab_craft", {
	tab = true,
	caption = "Crafting",
	owner = "inventory",
	get = function(data, pos, name)
		return inventory.get_craft_area()..
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

qts.register_gui("inv_tab_test", {
	tab = true,
	caption = "Test",
	owner = "inventory",
	get = function(data, pos, name)
		return --inventory.get_player_main()..
			inventory.get_button_grid(name, data.player_item_list_page, data.prev_search)
			--inventory.get_util_bar()
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
	
	--set the inventory formspec
	inventory.gen_item_list_for_player(name)
	inventory.refresh_inv(player)
end)

