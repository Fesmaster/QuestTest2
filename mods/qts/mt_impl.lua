--this file handles all the minetest.register_whatever_func_here
--this is to keep it in one centralized location



qts_internal.nodeDamageTimer = 0
function qts.isDamageTick()
	return qts_internal.nodeDamageTimer >= 1
end

minetest.register_globalstep(function(dtime)
	--damage tick update
	if qts_internal.nodeDamageTimer >= 1 then
		qts_internal.nodeDamageTimer = 0
	end
	qts_internal.nodeDamageTimer = qts_internal.nodeDamageTimer + dtime
	
	--player node and item callbacks
	for _, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		pos.y = pos.y-0.5 --vertical height adjustment
		local inv = player:get_inventory()
		local wield = player:get_wielded_item()
		
		local node = minetest.get_node(pos)
		local nodedat = minetest.registered_nodes[node.name]
		if nodedat and nodedat.on_walk then
			nodedat.on_walk(pos, player, std.node_damage)
		end

		local nodeb = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
		local nodedatb = minetest.registered_nodes[nodeb.name]
		if nodedatb and nodedatb.on_walk_in then
			nodedatb.on_walk_in({x=pos.x, y=pos.y+1, z=pos.z}, player)
		end
		
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
		
	end
	
	
end)

--minetest.register_on_joinplayer(function(player)
--	minetest.chat_send_all("QuestTest Dev Mode: ".. tostring(qts.ISDEV)) --Testing ONLY
--end)

minetest.register_on_shutdown(function()
	qts.WorldSettings.set_bool("QT_DEV_WORLD", qts.ISDEV)
    qts.WorldSettings.save()
	qts.GameSettings.save()
end)