

local esc = minetest.formspec_escape

local function P(x,y) return qts.gui.gui_makepos(x,y):get() end
local function S(x,y) return qts.gui.gui_makesize(x,y):get() end


inventory.special_equipment_slots = {
	{group="helmet",  template="inv_helmet.png",  pos=P(2.5,0)},
	{group="gloves",  template="inv_gloves.png",  pos=P(  2,1)},
	{group="shield",  template="inv_shield.png",  pos=P(  3,1)},
	{group="cuirass", template="inv_cuirass.png", pos=P(  2,2)},
	{group="cloak",   template="inv_cloak.png",   pos=P(  3,2)},
	{group="boots",   template="inv_boots.png",   pos=P(2.5,3)},
}
inventory.equipment_slots_general_count = 12


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
		for k, t in ipairs(inventory.special_equipment_slots) do
			str = str .. 
			"image["..t.pos..";1,1;".. t.template .. "]" .. 
			"list[current_player;equipment;"..t.pos..";1,1;"..tostring(k-1).."]"
		end
		local totalSlots = inventory.equipment_slots_general_count + (qts.get_player_bonus_equipment_slots(playername) or 0)
		local width = math.floor(totalSlots / 4)
		local extras = totalSlots % 4

		for k = 1,width do
			str = str .. "list[current_player;equipment;" .. P(4.5+(k-1),0)..";1,4;"..
			tostring(#inventory.special_equipment_slots + ((k-1)*4)).."]"
		end 
		str = str .."list[current_player;equipment;" .. P(4.5+width,0)..";1,"..tostring(extras)..";"..
			tostring(#inventory.special_equipment_slots+(width*4)).."]"


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


minetest.register_craftitem("inventory:groupItem", {
	description = "GROUP ITEM",
	inventory_image = "inv_gear.png",
	groups = {not_in_creative_inventory = 1,},
})

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

--registration stuff
function inventory.register_util_btn(label, on_click)
	if label and on_click then
		inventory.utils[#inventory.utils + 1] = {
			label = label,
			on_click = on_click,
		}
	end
end

function inventory.register_exemplar_item(group, item)
	--remove any ":" prefix
	if string.sub(item, 1,1) == ":" then
        item = string.gsub(item, ":", "",1)
    end
	if (minetest.registered_items[item]) then
		inventory.exemplar[group] = item
		minetest.log("verbose", "Inventory: exemplar item for " .. group .. " added: " .. item)
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

function inventory.gen_item_list_for_player(playername, filter, craftonly)
	if not filter then filter = "" end
	--if craftonly == nil then craftonly = false end --nil is false
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
			if m == 0 then m = nil end
		end
		if m and craftonly then
			if not qts.player_can_craft_item(name, playername) then
				m = nil
			end
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

	local name = player:get_player_name()
	local info = minetest.get_player_information(name)
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
	inventory.gen_item_list_for_player(name)
	inventory.refresh_inv(player)
end

--refreshing the player inv
function inventory.refresh_inv(player, tab)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	if not tab then tab = 1 end
	local formspec_code = qts.gui.show_gui(player:get_pos(), player, "inventory", tab, false)[2]
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