--[[
	This file manages player specific data
	TODO: change this to player.lua
--]]

qts_internal.nodeDamageTimer = 0
function qts.isDamageTick()
	return qts_internal.nodeDamageTimer >= 1
end

qts.player_data = {}

function qts.set_player_data(player, catagory, field, data)
	if (type(player) ~= "string") then player = player:get_player_name() end
	
	if (qts.player_data[player] == nil) then
		qts.player_data[player] = {}
	end
	if (qts.player_data[player][catagory] == nil) then
		if (data ~= nil) then
			qts.player_data[player][catagory] = {}
		end
	end
	if (data == nil) then -- no field supplied
		qts.player_data[player][catagory] =field
	else
		qts.player_data[player][catagory][field] = data
	end
end

function qts.get_player_data(player, catagory, field)
	if (type(player) ~= "string") then player = player:get_player_name() end
	
	if (qts.player_data[player] == nil) then
		qts.player_data[player] = {}
		return nil
	end
	if (qts.player_data[player][catagory] == nil) then
		if (field ~= nil) then
			qts.player_data[player][catagory] = {}
		end
		return nil
	end
	if (field == nil) then
		return qts.player_data[player][catagory]
	else
		return qts.player_data[player][catagory][field]
	end
end


minetest.register_globalstep(function(dtime)
	--damage tick update
	if qts_internal.nodeDamageTimer >= 1 then
		qts_internal.nodeDamageTimer = 0
	end
	qts_internal.nodeDamageTimer = qts_internal.nodeDamageTimer + dtime
	
	--player node and item callbacks
	for _, player in ipairs(minetest.get_connected_players()) do
		--generate the player data table
		local name = player:get_player_name()
		if not qts.player_data[name] then
			qts.player_data[name] = {}
		end
		
		--[[
			Deal with the world callbacks of where the player is stepping
		--]]
		local pos = player:get_pos()
		local prevpos = qts.get_player_data(name, "INTERNAL", "prevpos")
		if not prevpos then prevpos = vector.new(pos) end
		
		pos.y = pos.y-0.5 --vertical height adjustment
		prevpos.y = prevpos.y+0.5
		
		local node_under = minetest.get_node(pos)
		local node_dat_under = minetest.registered_nodes[node_under.name]
		if node_dat_under and node_dat_under.on_walk then
			node_dat_under.on_walk(pos, player, std.node_damage)
		end

		local node_in = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
		local new = not (vector.equals(vector.round({x=pos.x, y=pos.y+1, z=pos.z}), vector.round(prevpos)))
		
		local node_dat_in = minetest.registered_nodes[node_in.name]
		if node_dat_in and node_dat_in.on_walk_in then
			node_dat_in.on_walk_in({x=pos.x, y=pos.y+1, z=pos.z}, player, new)
		end
		if new then
			local old_node_dat_in = minetest.registered_nodes[minetest.get_node(prevpos).name]
			if (old_node_dat_in and old_node_dat_in.on_walk_exit) then
				old_node_dat_in.on_walk_exit(prevpos, player)
			end
		end
		
		--[[
			Deal with the inventory callbacks
		--]]
		local inv = player:get_inventory()
		local wield = player:get_wielded_item()
		
		local invlist = inv:get_list("main")
		local invlist_n = {}
		for ref, itemstack in ipairs(invlist) do
			local itemdat = minetest.registered_items[itemstack:get_name()]
			if itemdat and itemdat.on_carry then
				local itemstack_n = itemdat.on_carry(itemstack, player)
				if itemstack_n then
					invlist_n[ref]=itemstack_n
				else
					invlist_n[ref]=itemstack
				end
			else
				invlist_n[ref]=itemstack
			end
		end
		inv:set_list("main", invlist_n)
		
		local wielddat = minetest.registered_items[wield:get_name()]
		if wielddat and wielddat.on_wield then
			local wield_n = wielddat.on_wield(wield, player)
			if wield_n then
				player:set_wielded_item(wield_n)
			end
		end
		--[[
			Pick up dropped items in the world
		--]]
		---[[
		local objs = minetest.get_objects_inside_radius(vector.add(pos, {x=0, y=1, z=0}), 1.5)
		if (#objs > 1) then
			for i, obj in ipairs(objs) do
				pcall(function()
					--auto-punch dropped items
					if obj and not obj:is_player() then
						if qts.object_name(obj) == "__builtin:item" then
							if obj:get_luaentity().age and obj:get_luaentity().age >= 2 then
								obj:punch(player, 1, {
									full_punch_interval = 0.9,
									max_drop_level = 1,
									groupcaps = {},
									damage_groups = {fleshy = 1},
								}, nil)
								qts.pickup_sound(obj)
							end
						end
					end
				end)
			end
		end
		--]]
		--update prevpos
		qts.set_player_data(name, "INTERNAL", "prevpos", player:get_pos())
	end
	
	
end)

--minetest.register_on_joinplayer(function(player)
--	minetest.chat_send_all("QuestTest Dev Mode: ".. tostring(qts.ISDEV)) --Testing ONLY
--end)

minetest.register_on_shutdown(function()
	qts.world_settings.set_bool("QT_DEV_WORLD", qts.ISDEV)
    qts.world_settings.save()
	qts.settings.save()
	minetest.log("QTS shutdown finished")
end)