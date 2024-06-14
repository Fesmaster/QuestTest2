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
dofile(minetest.get_modpath("inventory") .."/legacy.lua")
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
				width=24.4,
				height=16,
				name="inventory_tabs",
				inner_size={x=24,y=14.5},
			},{
				{
					tab={
						name="inventory_tab_equipment",
						label="Equipment",
						width=2,
						height=1,
						padding={x=0,y=0}
					},
					page=function (t1c1)
						t1c1:vertical_box(
							{
								width=24,
								height=14.5,
								position={x=-0.2, y=0},
								padding={x=0,y=0}
							},
							function (t1c2)
								t1c2:horizontal_box(
									{
										texture="Transparent.png",
										padding={x=0.125,y=0.125},
										spacing={x=0.125,y=0.125},
									},
									function (t1c3)

										-- Armor Slots
										t1c3:container(
											{
												texture="Transparent.png",
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

										-- Equipment slots
										local totalSlots = inventory.equipment_slots_general_count + (
											qts.get_player_bonus_equipment_slots(
												t1c3.player:get_player_name()
											) or 0
										)
										local width = math.floor(totalSlots / 4)
										local extras = totalSlots % 4

										t1c3:inventory({
											width=width,
											height=4,
											slot_size={x=1,y=1},
											listname="equipment",
											source=qts.scribe.inventory_source.CURRENT_PLAYER,
											starting_item_index=#inventory.special_equipment_slots,
											orientation=qts.scribe.orientation.VERTICAL,
											slot_spacing = {x=0.125,y=0.125},
										})
										:inventory({
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
								)

								t1c2:inventory({
									source = qts.scribe.inventory_source.CURRENT_PLAYER,
									sourcename = "",
									listname = "main",
									width=10,
									height=4,
									position={x=0,y=0},
									slot_size = {x=1,y=1},
									slot_spacing = {x=0.125,y=0.125},
									use_list_ring=true,
								})
							end -- END t1c2
						)
					end -- END t1c1
				}, --END Equipment tab

				
			}) -- END Main tabs
---[[
			c3:tab_header({
				width=8.4,
				height=16,
				name="itemsearch_tabs",
				innser_size={x=8,y=14.5},
			},
			{
				{
					tab={
						name="search_tab_main",
						label="Catalog",
						width=1.75,
						height=1,
						padding={x=0,y=0}
					},
					page=function (item_t1c1)
						item_t1c1:container({
							width=8,
							height=14.5,
							position={x=-0.2, y=0},
							padding={x=0,y=0}
						})
					end -- END item_t1c1
				}, -- END Tab1
				{
					tab={
						name="search_tab_favorite",
						label="Favorites",
						width=1.75,
						height=1,
						padding={x=0,y=0}
					},
					page=function (item_t2c1)
						item_t2c1:container({
							width=8,
							height=14.5,
							position={x=-0.2, y=0},
							padding={x=0,y=0}
						}, function (item_t2c2)
							
						end) -- END item_t2c2
					end -- END item_t2c1
				}, -- END Tab2
			}) -- END itemsearch_tabs
--]]
		end) -- END c3
	end) --END c2 
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