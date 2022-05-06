qts.open_chests = {}

qts.gui.register_gui("qt_chest", {
	get = function(data, pos, name)
		local node = minetest.get_node_or_nil(pos)
		if node and node.name then
			local nodedef = minetest.registered_nodes[node.name]
			if nodedef and nodedef.get_chest_formspec then
				return nodedef.get_chest_formspec(pos, name)
			end
		end
		return "size[8,8]"
	end,
	handle = function(data, pos, name, fields)
		if not fields.quit then
			return
		end
		
		if not qts.open_chests[name] then
			return
		end
		qts.close_chest(name)
		return true
	end,
})


qts.is_chest_lid_obstructed = function(pos)
	local above = pos+vector.new(0,1,0)
	local def = minetest.registered_nodes[minetest.get_node(above).name]
	-- allow ladders, signs, wallmounted things and torches to not obstruct
	if def and
			(def.drawtype == "airlike" or
			def.drawtype == "signlike" or
			def.drawtype == "torchlike" or
			(def.drawtype == "nodebox" and def.paramtype2 == "wallmounted")) then
		return false
	end
	return true
end

qts.get_node_inventory_drops = function(pos, inventory, drops)
	if not drops then drops = {} end --basic table
	local inv = minetest.get_meta(pos):get_inventory()
	local n = #drops
	for i = 1, inv:get_size(inventory) do
		local stack = inv:get_stack(inventory, i)
		if stack:get_count() > 0 then
			drops[n+1] = stack:to_table()
			n = n + 1
		end
	end
	return drops
end

qts.close_chest = function(pname)
	--get a ref to the data
	local info = qts.open_chests[pname]
	
	--remove the ref in the table
	qts.open_chests[pname] = nil
	--search the table for others
	local is_closed = true
	for pname, check in pairs(qts.open_chests) do
		if check.pos.x == info.pos.x and check.pos.y == info.pos.y and check.pos.y == info.pos.y then
			is_closed = false
			break
		end
	end
	
	--play the sound
	if is_closed and info.sound then
		minetest.sound_play(info.sound, {gain = 0.3, pos = info.pos,
			max_hear_distance = 10}, true)
	end
	
	--call the callback func
	local node = minetest.get_node_or_nil(info.pos)
	if node and node.name then
		local nodedef = minetest.registered_nodes[node.name]
		if nodedef and nodedef.on_chest_close then
			nodedef.on_chest_close(info.pos, node, minetest.get_player_by_name(pname), is_closed)
		end
	end
end



minetest.register_on_leaveplayer(function(player)
	local pname = player:get_player_name()
	if qts.open_chests[pname] then
		qts.close_chest(pname)
	end
end)


--[[
custom params that are needed
invsize = number
get_chest_formspec(pos, pname)
sound_open  = sound setup
sound_close = sound setup


chest callbacks:
on_chest_open(pos, node, opener, is_already_open)
on_chest_close(pos, node, closer, is_final_close)

--]]
qts.register_chest = function(name, def)
	--this does not show a difference from the chest being open or closed
	--local formsize = def.formsize or {x=8,y=8}
	local invsize = def.invsize or (8*4)
	local infotext = def.description or "Chest"
	local sound_open = def.sound_open
	local sound_close = def.sound_close
	--def.formsize = nil
	def.invsize = nil
	def.sound_open = nil
	def.sound_close = nil
	
	--take out the formsize data
	def.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", infotext)
		--meta:set_string("chest_form_width", formsize.x)
		--meta:set_string("chest_form_height", formsize.y)
		--meta:set_string("chest_width", invsize.x)
		--meta:set_string("chest_height", invsize.y)
		local inv = meta:get_inventory()
		inv:set_size("main", invsize) --size of the inv
	end
	
	--this one can be overridden manually by then user
	if not def.can_dig then
		def.can_dig = function(pos, player) --one liner!
			local meta = minetest.get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("main")
		end
	end
	
	def.on_rightclick = function(pos, node, clicker)
		--play the sound
		
		if sound_open then
			minetest.sound_play(sound_open, {gain = 0.3, pos = pos, 
				max_hear_distance = 10}, true)
		end
		--actually open the chest after a few milliseconds
		minetest.after(0.2, qts.gui.show_gui, pos, clicker, "qt_chest")
		
		--is the chest already open? (multiplayer)
		local is_already_open = false
		for pname, check in pairs(qts.open_chests) do
			if check.pos.x == pos.x and check.pos.y == pos.y and check.pos.y == pos.y then
				is_already_open = true
				break
			end
		end
		
		--add this opening instance to the list
		qts.open_chests[clicker:get_player_name()] = {
			pos = pos,
			sound_close = sound_close
		}
		
		local nodedef = minetest.registered_nodes[node.name]
		if nodedef and nodedef.on_chest_open then
			nodedef.on_chest_open(pos, node, clicker, is_already_open)
		end
	end
	
	if not def.on_blast then
		def.on_blast = function(pos)
			local drops = {}
			qts.get_node_inventory_drops(pos, "main", drops)
			drops[#drops+1] = name
			minetest.remove_node(pos)
			return drops
		end
	end
	
	if not def.on_metadata_inventory_move then
		def.on_metadata_inventory_move = function(pos, from_list, from_index,
				to_list, to_index, count, player)
			minetest.log("action", player:get_player_name() ..
				" moves stuff in chest at " .. minetest.pos_to_string(pos))
		end
	end
	
	if not def.on_metadata_inventory_put then
		def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name() ..
				" moves " .. stack:get_name() ..
				" to chest at " .. minetest.pos_to_string(pos))
		end
	end
	
	if not def.on_metadata_inventory_take then
		def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
			minetest.log("action", player:get_player_name() ..
				" takes " .. stack:get_name() ..
				" from chest at " .. minetest.pos_to_string(pos))
		end
	end
	
	if def.groups == nil then def.groups = {} end
	def.groups.chest = 1
	
	
	--register the node
	minetest.register_node(":"..name, def)
end
