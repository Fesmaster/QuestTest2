--inventory for the player
--functions.lua
inventory = {}
inventory.utils = {}
inventory.itemlist_player = {}
inventory.listdata_player = {}
inventory.list_items = {}
inventory.favoritelist_player = {}
inventory.favoritelist_filtered_player = {}
inventory.exemplar = {}
inventory.collapse_groups = {}

-- Settings for Inventory Looks
local function refresh_inv_page_sizes(oldval, newval, src)
	for k, v in pairs(inventory.listdata_player) do
		v.pages = math.ceil(v.count / inventory.get_catalog_dimentions().count)
	end
end
inventory.CATALOG_WIDTH = qts.config("InventoryCatalogWidth", 6, "Width of the item catalogue", {}, refresh_inv_page_sizes)
inventory.CATALOG_HEIGHT = qts.config("InventoryCatalogHeight", 8, "Height of the item catalogue", {}, refresh_inv_page_sizes)
inventory.CATALOG_BUTTON_PADDING = qts.config("InventoryCatalogButtonPadding", 0.125, "Padding between buttons in the item catalogue", {})
inventory.CATALOG_BUTTON_SIZE = qts.config("InventoryCatalogButtonSize", 1.2, "Size of buttons in the item catalogue", {})


dofile(minetest.get_modpath("inventory") .."/functions.lua")
dofile(minetest.get_modpath("inventory") .."/detached.lua")
dofile(minetest.get_modpath("inventory") .."/hud.lua")
dofile(minetest.get_modpath("inventory") .."/legacy.lua")

--register util buttons
--TODO: make more util buttons

--minetest.set_timeofday(val)
inventory.register_util_btn("Morning!", function(playername)
	minetest.set_timeofday(0.25)
end)

inventory.register_util_btn("Night!", function(playername)
	minetest.set_timeofday(0.85)
end)

-- updated version, overrides the version in functions.lua
---@type{group:string, template:string, pos:vec2}
inventory.special_equipment_slots = {
	{group="helmet",  template="inv_helmet.png",  pos={x=0.625, y=0}},
	{group="gloves",  template="inv_gloves.png",  pos={x=  0,   y=1.125}},
	{group="shield",  template="inv_shield.png",  pos={x=1.25,  y=1.125}},
	{group="cuirass", template="inv_cuirass.png", pos={x=  0,   y=2.25}},
	{group="cloak",   template="inv_cloak.png",   pos={x=1.25,  y=2.25}},
	{group="boots",   template="inv_boots.png",   pos={x=0.625, y=3.375}},
}
inventory.equipment_slots_general_count = 12



---event for interacting with search bar
---@param event ScribeEvent
local function execute_inv_search(event)
	local search_string = event.userdata.inventory_search_string or ""
	local craftonly = event.userdata.inventory_search_craftonly
	if craftonly == nil then craftonly = false end
	local playername = event.player:get_player_name()
	inventory.gen_item_list_for_player(playername, search_string , craftonly)
	inventory.gen_favorite_list_for_player(playername, search_string , craftonly)
	event.userdata.catalog_current_page = 1
	event:mark_for_refresh()
end

---Event for clicking the favorite buttons on items
---@param event ScribeEvent
---@param item ItemString
---@param favorite boolean
local function favorite_state_change(event, item, favorite)
	local playername = event.player:get_player_name()
	if favorite then
		inventory.add_item_to_favorites(playername, item)
	else
		inventory.remove_item_from_favorites(playername, item)
	end
	local search_string = event.userdata.inventory_search_string or ""
	local craftonly = event.userdata.inventory_search_craftonly
	if craftonly == nil then craftonly = false end
	inventory.gen_favorite_list_for_player(playername, search_string , craftonly)
	event.userdata.favorites_current_page = 1
	event:mark_for_refresh()
end

---Reusable bar for searching and filtering. Used in both the main catalog and the favorite page
---@param context ScribeContext
---@param buttonsize number
---@param padding number
---@param page_size {width:number,height:number,count:number}
local function add_search_bar(context, buttonsize, padding, page_size)
	context:horizontal_box({
		texture = "_transparent",
		padding={x=padding,y=padding},
		spacing={x=padding,y=padding},
	}, function (item_t1c3)
		local width = 
			((page_size.width - 3) * buttonsize) + 
			((page_size.width - 4) * padding)
		item_t1c3:text_entry({
			close_on_enter=false,
			name="inventory_search_string",
			persistant_text=true,
			width=width,
			height=buttonsize,
			multiline=false,
			tooltip="Search",
		}, function (event)
			event.userdata.inventory_search_string = event.fields.inventory_search_string
			execute_inv_search(event)
		end)
		:button({
			texture="inv_glass.png",
			width=buttonsize,
			height=buttonsize,
			name="inventory_search_button",
			tooltip="Search",
		}, function (event)
			event.userdata.inventory_search_string = event.fields.inventory_search_string
			execute_inv_search(event)
		end)
		:button({
			texture="inv_craft_icon.png",
			texture_pressed="inv_craft_icon.png",
			toggleable=true,
			width=buttonsize,
			height=buttonsize,
			name = "inventory_search_craftonly",
			tooltip="Show Only Craftable Items",
		}, function (event)
			local toggled = event:get_toggle_state()
			if toggled == nil then toggled = false end
			event.userdata.inventory_search_craftonly = toggled
			execute_inv_search(event)
		end)
		:button({
			texture="inv_cheat_icon.png",
			texture_pressed="inv_cheat_icon.png",
			toggleable=true,
			width=buttonsize,
			height=buttonsize,
			name = "inventory_cheat",
			tooltip="Enable Cheat Mode\nCatalog will give items in Cheat Mode",
			default_toggle_state=qts.is_player_creative(item_t1c3.player:get_player_name())
		}, function (event)
			local toggled = event:get_toggle_state()
			if toggled == nil then toggled = false end
			event.userdata.inventory_cheatmode = toggled
		end)
	end)
end

qts.gui.register_scribe_gui("inventory:new_inventory", function (c1)
	c1:set_style("qtcore:stormcloud")
	:container({
		position={x=0,y=0},
		--texture="Transparent.png",
		padding={x=0,y=0},
		},function(c2)
		c2:horizontal_box({
			position={x=-0.2,y=0},
			padding={x=0.5,y=0},
			spacing={x=0.25,y=0},
			--texture="Transparent.png",
		}, function (c3)
			c3:tab_header({
				--width=24.4,
				--height=16,
				name="inventory_tabs",
				--inner_size={x=24,y=14.5},
			},{
				{
					tab={
						name="inventory_tab_equipment",
						label="Equipment",
						width=2.2,
						height=1,
						padding={x=0,y=0}
					},
					page=function (t1c1)
						t1c1:vertical_box(
							{
								--width=24,
								--height=14.5,
								position={x=-0.2, y=0},
								padding={x=0,y=0}
							},
							function (t1c2)
								t1c2:horizontal_box(
									{
										texture="_transparent",
										padding={x=0.125,y=0.125},
										spacing={x=0.125,y=0.125},
									},
									function (t1c3)

										-- Armor Slots
										t1c3:container(
											{
												texture="_transparent",
											},
											function (t1c4)
												for k, t in ipairs(inventory.special_equipment_slots) do
													t1c4:image({
														position=t.pos,
														texture=t.template,
														width=1,
														height=1,
													})
													:inventory({		
														position=t.pos,
														width=1,
														height=1,
														listname="equipment",
														slot_size={x=1,y=1},
														source=qts.scribe.inventory_source.CURRENT_PLAYER,
														starting_item_index=k-1
													})
												end
											end -- END t1c4
										)
										-- Custom Keybind Slots
										-- TODO
										-- Equipment slots
										t1c3:container(
											{
												texture="_transparent",
											},
											function (t1c4)
												local totalSlots = inventory.equipment_slots_general_count + (
													qts.get_player_bonus_equipment_slots(
														t1c4.player:get_player_name()
													) or 0
												)
												local width = math.floor(totalSlots / 4)
												local extras = totalSlots % 4
		
												t1c4:inventory({
													width=width,
													height=4,
													slot_size={x=1,y=1},
													listname="equipment",
													source=qts.scribe.inventory_source.CURRENT_PLAYER,
													starting_item_index=#inventory.special_equipment_slots,
													orientation=qts.scribe.orientation.VERTICAL,
													slot_spacing = {x=0.125,y=0.125},
												})
		
												if extras > 0 then
													t1c4:inventory({
														width=1,
														height=extras,
														slot_size={x=1,y=1},
														listname="equipment",
														source=qts.scribe.inventory_source.CURRENT_PLAYER,
														starting_item_index=#inventory.special_equipment_slots + totalSlots - extras,
														orientation=qts.scribe.orientation.VERTICAL,
														slot_spacing = {x=0.125,y=0.125},
													})
												end
											end -- END t1c4
										)
									end
								)
								
								-- MAIN inventory
								t1c2:horizontal_box({
									texture="_transparent",
									padding={x=0.25,y=0.25},
									spacing={x=0.25,y=0.25},
								}, function (t1c3)
									t1c3:inventory({
										source = qts.scribe.inventory_source.CURRENT_PLAYER,
										sourcename = "",
										listname = "main",
										width=10,
										height=4,
										slot_size = {x=1,y=1},
										slot_spacing = {x=0.125,y=0.125},
										use_list_ring=true,
									})

									-- trash slot
									t1c3:container({
										texture="_transparent",
										padding={x=0,y=0},
										spacing={x=0,y=0},
									}, function (t1c4)
										t1c4:image({
											position={x=0,y=0},
											width=1,
											height=1,
											texture="inv_trash.png",
										})
										:inventory({
											source = qts.scribe.inventory_source.DETACHED,
											sourcename = "trash",
											listname = "main",
											width=1,
											height=1,
											position = {x=0,y=0},
											slot_size = {x=1,y=1},
											slot_spacing = {x=0.125,y=0.125},
											use_list_ring=false,
										})
									end)
								end)
							end -- END t1c2
						)
					end -- END t1c1
				}, --END Equipment tab

				
			}) -- END Main tabs
---[[
			c3:tab_header({
				--width=8.4,
				--height=16,
				name="itemsearch_tabs",
				--innser_size={x=8,y=14.5},
			},
			{
				{
					tab={
						name="catalog_tab_main",
						label="Catalog",
						width=1.75,
						height=1,
						padding={x=0,y=0}
					},
					page=function (item_t1c1)
						item_t1c1:vertical_box({
							--width=8,
							--height=14.5,
							position={x=-0.2, y=0},
							padding={x=0,y=0}
						}, function (item_t1c2)
							local playername = item_t1c2.player:get_player_name()
							local current_page = (item_t1c2.userdata.catalog_current_page or 1) - 1 -- page base 0
							local page_size = inventory.get_catalog_dimentions()
							local buttonsize = inventory.CATALOG_BUTTON_SIZE:get()
							local padding = inventory.CATALOG_BUTTON_PADDING:get()
							local pagecount = inventory.listdata_player[playername].pages
							-- Pageing buttons and page display
							item_t1c2:horizontal_box({
								texture = "_transparent",
								padding={x=padding,y=padding},
								spacing={x=padding,y=padding},
							}, function (item_t1c3)
								local width = 
									((page_size.width - 2) * buttonsize) + 
									((page_size.width - 3) * padding)
								item_t1c3:button({
									texture="lshift.png",
									width=buttonsize,
									height=buttonsize,
									visibility=qts.select(pagecount>1, qts.scribe.visibility.VISIBLE, qts.scribe.visibility.HIDDEN),
								}, function (event)
									local page = (event.userdata.catalog_current_page or 1)
									if page > 1 then
										page = page - 1
									else
										page = pagecount
									end
									event.userdata.catalog_current_page = page
									event:mark_for_refresh()
								end)
								:text({
									text = "page " .. tostring(current_page + 1) .. " of " .. tostring(pagecount),
									width=width,
									height=buttonsize,
									horizontal_allignment=qts.scribe.allignment.LEFT,
									vertical_allignment=qts.scribe.allignment.CENTER,
								})
								:button({
									texture="rshift.png",
									width=buttonsize,
									height=buttonsize,
									visibility=qts.select(pagecount>1, qts.scribe.visibility.VISIBLE, qts.scribe.visibility.HIDDEN),
								}, function (event)
									local page = (event.userdata.catalog_current_page or 1)
									if page < pagecount then
										page = page + 1
									else
										page = 1
									end
									event.userdata.catalog_current_page = page
									event:mark_for_refresh()
								end)
							end) -- END item_t1c3

							-- Main body
							item_t1c2:container({
								texture = "_transparent"
							}, function (item_t1c3)
								-- Button Grid
								local x = 0
								local y = 0
								
								local index = (page_size.count * current_page) + 1
								local itemlist = inventory.itemlist_player[playername]

								for yy = 1, page_size.height do
									for xx = 1, page_size.width do
										local item_name = itemlist[index]
										if item_name then
											if qts.is_group(item_name) then
												-- groups
												local exemplar = inventory.collapse_groups[qts.remove_modname_from_item(item_name)]
												if exemplar then
													-- group button
													item_t1c3:button({
														item = exemplar,
														width=buttonsize,
														height=buttonsize,
														position={x=x,y=y},
														tooltip=item_name.."\nClick to Expand"
													}, function (event)
														event.userdata.inventory_search_string = item_name
														--event.userdata._scribe.inventory_search_string = item_name
														execute_inv_search(event)
													end)
													-- Plus image
													:image(
														{
															texture="inv_plus.png",
															width=buttonsize/3,
															height=buttonsize/3,
															position={x=x+buttonsize*0.6666,y=y}
														}
													)
												end
											else
												local item_desc = minetest.registered_items[item_name].description
												-- Item button
												item_t1c3:button({
													item = item_name,
													width=buttonsize,
													height=buttonsize,
													position={x=x,y=y},
													tooltip=qts.select(qts.ISDEV, item_desc .. "\n" .. item_name, item_desc)
												}, function (event)
													local cheatmode = event.userdata.inventory_cheatmode
													if cheatmode == nil then
														cheatmode = qts.is_player_creative(playername)
													end
													if cheatmode then
														local inv = event.player:get_inventory()
														if inv then
															inv:add_item("main", item_name .. " " .. (minetest.registered_items[item_name].stack_max or 1024))
														end
													else
														event.userdata.inventory_selected_item = item_name
														event:mark_for_refresh()
													end
												end)
												-- favorite button
												local favbuttonname = "fav_toggle_"..item_name
												item_t1c3:button({
													texture="inv_favorite_empty.png",
													texture_pressed="inv_favorite.png",
													toggleable=true,
													default_toggle_state=inventory.is_item_favorite(playername, item_name),
													name=favbuttonname,
													width=buttonsize/3,
													height=buttonsize/3,
													position={x=x+buttonsize*0.6666,y=y},
													style_all={
														background="Transparent.png",
													},
													style_toggled_all={
														background="Transparent.png",
													},
													tooltip=qts.select(qts.ISDEV, item_desc .. "\n" .. item_name, item_desc).."\n"..
														qts.select(inventory.is_item_favorite(playername, item_name), "Unfavorite", "Favorite")
												}, function (event)
													local toggled = event:get_toggle_state()
													favorite_state_change(event, item_name, toggled)
												end)
											end
										end
										-- invisible item to add empty space when the page is not full
										if xx == page_size.width and yy == page_size.height and item_name == nil then
											item_t1c3:separator({
												width=buttonsize,
												height=buttonsize,
												-- not sure why the math on y is nesecary, but the seperator has a different size? Without it, empty pages wobble a bit.
												position={x=x,y=y+buttonsize-(padding/16)} 
											})
										end
										index = index + 1
										x = x + buttonsize + padding
									end
									y = y + buttonsize + padding
									x = 0
								end

							end) -- END item_t1c3
							
							-- Searching and Filtering
							add_search_bar(item_t1c2, buttonsize, padding, page_size)
								
							--end) -- END item_t1c3
						end) -- END item_t1c2
					end -- END item_t1c1
				}, -- END Tab1
				{
					tab={
						name="catalog_tab_favorite",
						label="Favorites",
						width=1.75,
						height=1,
						padding={x=0,y=0}
					},
					page=function (item_t2c1)
						item_t2c1:vertical_box({
							--width=8,
							--height=14.5,
							position={x=-0.2, y=0},
							padding={x=0,y=0}
						}, function (item_t2c2)
							local playername = item_t2c2.player:get_player_name()
							local current_page = (item_t2c2.userdata.favorites_current_page or 1) - 1 -- page base 0
							local page_size = inventory.get_catalog_dimentions()
							local buttonsize = inventory.CATALOG_BUTTON_SIZE:get()
							local padding = inventory.CATALOG_BUTTON_PADDING:get()
							local pagecount = inventory.listdata_player[playername].fav_pages
							
							-- Pageing buttons and page display
							item_t2c2:horizontal_box({
								texture = "_transparent",
								padding={x=padding,y=padding},
								spacing={x=padding,y=padding},
							}, function (item_t2c3)
								local width = 
								((page_size.width - 2) * buttonsize) + 
								((page_size.width - 3) * padding)
								item_t2c3:button({
									texture="lshift.png",
									width=buttonsize,
									height=buttonsize,
									visibility = qts.select(pagecount > 1, qts.scribe.visibility.VISIBLE, qts.scribe.visibility.HIDDEN),
								}, function (event)
									local page = (event.userdata.favorites_current_page or 1)
									if page > 1 then
										page = page - 1
									else
										page = pagecount
									end
									event.userdata.favorites_current_page = page
									event:mark_for_refresh()
								end)
								:text({
									text = "page " .. tostring(current_page + 1) .. " of " .. tostring(pagecount),
									width=width,
									height=buttonsize,
									horizontal_allignment=qts.scribe.allignment.LEFT,
									vertical_allignment=qts.scribe.allignment.CENTER,
								})
								:button({
									texture="rshift.png",
									width=buttonsize,
									height=buttonsize,
									visibility = qts.select(pagecount > 1, qts.scribe.visibility.VISIBLE, qts.scribe.visibility.HIDDEN),
								}, function (event)
									local page = (event.userdata.favorites_current_page or 1)
									if page < pagecount then
										page = page + 1
									else
										page = 1
									end
									event.userdata.favorites_current_page = page
									event:mark_for_refresh()
								end)
							end) -- END item_t1c3
							--
							-- Main body
							item_t2c2:container({
								texture = "_transparent"
							}, function (item_t2c3)
								-- Button Grid
								local x = 0
								local y = 0
								
								local index = (page_size.count * current_page) + 1
								local itemlist = inventory.favoritelist_filtered_player[playername]
								--
								for yy = 1, page_size.height do
									for xx = 1, page_size.width do
										local item_name = itemlist[index]
										if item_name then
											if qts.is_group(item_name) then
												-- groups
												minetest.log("warning", "Group added to favorites. This should be impossible. Group: " .. item_name)
											else
												local item_desc = minetest.registered_items[item_name].description
												-- Item button
												item_t2c3:button({
													item = item_name,
													width=buttonsize,
													height=buttonsize,
													position={x=x,y=y},
													tooltip=qts.select(qts.ISDEV, item_desc .. "\n" .. item_name, item_desc)
												}, function (event)
													local cheatmode = event.userdata.inventory_cheatmode
													if cheatmode == nil then
														cheatmode = qts.is_player_creative(playername)
													end
													if cheatmode then
														local inv = event.player:get_inventory()
														if inv then
															inv:add_item("main", item_name .. " " .. (minetest.registered_items[item_name].stack_max or 1024))
														end
													else
														event.userdata.inventory_selected_item = item_name
														event:mark_for_refresh()
													end
												end)
												-- favorite button
												local favbuttonname = "fav_toggle_"..item_name
												item_t2c3:button({
													texture="inv_favorite_empty.png",
													texture_pressed="inv_favorite.png",
													toggleable=true,
													default_toggle_state=inventory.is_item_favorite(playername, item_name),
													name=favbuttonname,
													width=buttonsize/3,
													height=buttonsize/3,
													position={x=x+buttonsize*0.6666,y=y},
													style_all={
														background="Transparent.png",
													},
													style_toggled_all={
														background="Transparent.png",
													},
													tooltip=qts.select(qts.ISDEV, item_desc .. "\n" .. item_name, item_desc).."\n"..
														qts.select(inventory.is_item_favorite(playername, item_name), "Unfavorite", "Favorite")
												}, function (event)
													local toggled = event:get_toggle_state()
													favorite_state_change(event, item_name, toggled)
												end)
											end
										end
										-- invisible item to add empty space when the page is not full
										if xx == page_size.width and yy == page_size.height and item_name == nil then
											item_t2c3:separator({
												width=buttonsize,
												height=buttonsize,
												-- not sure why the math on y is nesecary, but the seperator has a different size? Without it, empty pages wobble a bit.
												position={x=x,y=y+buttonsize-(padding/16)} 
											})
										end
										index = index + 1
										x = x + buttonsize + padding
									end
									y = y + buttonsize + padding
									x = 0
								end
	
							end) -- END item_t1c3
								
								-- Searching and Filtering
							add_search_bar(item_t2c2, buttonsize, padding, page_size)
						end) -- END item_t2c2
					end -- END item_t2c1
				}, -- END Tab2
			}) -- END itemsearch_tabs
--]]
		end) -- END c3
	end) --END c2 

	c1:quit_callback(function (event)
		inventory.refresh_inv(event.player)
	end)
end)

qts.gui.set_inventory_gui_name("inventory:new_inventory") --set the new GUIs to the main inventory


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