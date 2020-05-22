

qts.registered_item_modifiers = {}
--[[
An Item modifier is a set of functions attached to a spedific name
They get called from default minetest callbacks, when an item bearing that name in its meta tags
is used, etc.

function list:
	on_place(pos, newnode, placer, oldnode, itemstack, pointed_thing) --only actually gets called for nodes that can be placed
	on_dignode(pos, node, digger) --used to break a node 
	on_punch_node(pos, node, puncher, pointed_thing) --used to punch a node
	on_punch_player(player, hitter, time_from_last_punch, tool_capabilities, dir, damage) --used to punch player. Hitter is the one holding the item
	--if on_punch_player == nil and on_punch_entity ~= nil then on_punch_entity will be called by player.
	
	on_punch_entity(objref, hitter, time_from_last_punch, tool_capabilities, dir, damage) --used to punch an entity THAT CALLS IT
	on_dieplayer(player, reason) -- the player with this in his inv dies
	on_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing) --the item is eaten (return true to prevent HPChange)
	
	inventory_can_act(player, action, inventory, inventory_info)
	inventory_on_act(player, action, inventory, inventory_info)
	
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing))
minetest.register_on_dignode(function(pos, oldnode, digger))
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing))
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage))
minetest.register_on_dieplayer(function(ObjectRef, reason))
minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing))
--]]

function qts.register_item_modifier(name, def)
	if not def.maxlevel then def.maxlevel = 1 end
	def.name = name
	if not def.description then def.description = "Missing Modifier Description" end
	qts.registered_item_modifiers[name] = def
end


function qts.apply_item_modifier(itemstack, name, level)
	local def = qts.registered_item_modifiers[name]
	if not def then return false end
	local meta = itemstack:get_meta()
	
	--handle the item description
	local desc = meta:get_string("description")
	if desc == "" then
		desc = minetest.registered_items[itemstack:get_name()].description
	end
	local newdesc = ""
	--find the line that matches the current desc
	local updated = false
	minetest.log("Description Lines:")
	for line in desc:gmatch"[^\n]*" do
		minetest.log(line)
		if line:find(def.description) then
			newdesc = newdesc .. "    " .. def.description .. ": " .. tostring(level) .. "\n"
			updated = true
		elseif line ~= "" then
			newdesc = newdesc .. line .. "\n"
		end
	end
	newdesc = newdesc:sub(1, newdesc:len()-1)
	if not updated then
		newdesc = newdesc .. "\n    " .. def.description .. " " .. tostring(level)
	end
	meta:set_string("description", newdesc)
	
	--apply the modifier string to the metadata
	local modstr = meta:get_string("qt_item_modifers")
	local mods = {}
	if modstr ~= "" then
		mods = minetest.deserialize(modstr)
	end
	mods[name] = level
	modstr = minetest.serialize(mods)
	meta:set_string("qt_item_modifers", modstr)
end


minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if placer and placer:is_player() then
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return false end
		
		local mods = minetest.deserialize(modstr)
		local rtrue = false
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.on_place then
				local r = m_def.on_place(pos, newnode, placer, oldnode, itemstack, pointed_thing)
				if r then
					rtrue = true
				end
			end
		end
		if rtrue then return true end
		return false
	end
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if digger and digger:is_player() then
		local itemstack = digger:get_wielded_item()
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return end
		local mods = minetest.deserialize(modstr)
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.on_dignode then
				m_def.on_dignode(pos, node, digger)
			end
		end
	end
end)


minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if puncher and puncher:is_player() then
		local itemstack = puncher:get_wielded_item()
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return end
		local mods = minetest.deserialize(modstr)
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.on_punch_node then
				m_def.on_punch_node(pos, node, puncher, pointed_thing)
			end
		end
	end
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if hitter and hitter:is_player() then
		local itemstack = hitter:get_wielded_item()
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return end
		local mods = minetest.deserialize(modstr)
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.on_punch_player then
				m_def.on_punch_player(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
			elseif m_def and m_def.on_punch_entity then
				m_def.on_punch_entity(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
			end
		end
	end
end)

minetest.register_on_dieplayer(function(player, reason)
	if player and player:is_player() then
		local inv = player:get_inventory()
		for listname, items in pairs(inv:get_lists()) do
			for i, itemstack in ipairs(items) do
				--local itemstack = hitter:get_wielded_item()
				local meta = itemstack:get_meta()
				local modstr = meta:get_string("qt_item_modifers")
				if modstr ~= "" then 
					local mods = minetest.deserialize(modstr)
					for mod_name, mod_level in pairs(mods) do
						local m_def = qts.registered_item_modifiers[mod_name]
						if m_def and m_def.on_dieplayer then
							m_def.on_dieplayer(player, reason)
						end
					end
				end
			end
		end
	end
end)

minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	if user and user:is_player() then
		--local itemstack = hitter:get_wielded_item()
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return false end
		local mods = minetest.deserialize(modstr)
		local rval = false
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.on_item_eat then
				local r = m_def.on_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
				if r then rval = true end
			end
		end
		if rval then
			return itemstack
		end
	end
end)

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	if player and player:is_player() then
		local itemstack = nil
		if action == "put" or action == "take" then
			itemstack = inventory_info.stack
		else
			itemstack = player:get_inventory():get_stack(inventory_info.from_list, inventory_info.from_index)
		end
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return itemstack:get_count() end
		local mods = minetest.deserialize(modstr)
		local rval = itemstack:get_count()
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.inventory_can_act then
				local r = m_def.inventory_can_act(player, action, inventory, inventory_info)
				if r ~= -1 then
					rval = math.min(rval, r)
				end
			end
		end
		return rval
	end
	return itemstack:get_count()
end)

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
	if player and player:is_player() then
		local itemstack = nil
		if action == "put" or action == "take" then
			itemstack = inventory_info.stack
		else
			itemstack = player:get_inventory():get_stack(inventory_info.from_list, inventory_info.from_index)
		end
		local meta = itemstack:get_meta()
		local modstr = meta:get_string("qt_item_modifers")
		if modstr == "" then return end
		local mods = minetest.deserialize(modstr)
		for mod_name, mod_level in pairs(mods) do
			local m_def = qts.registered_item_modifiers[mod_name]
			if m_def and m_def.inventory_on_act then
				local r = m_def.inventory_on_act(player, action, inventory, inventory_info)
			end
		end
	end
end)