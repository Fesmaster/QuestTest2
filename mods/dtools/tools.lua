

minetest.register_tool ("dtools:gauntlet", {
	description = ("Gauntlet of DESTRUCTION"),
	inventory_image = "wieldhand.png",
	wield_image = "wieldhand.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			crumbly = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			choppy = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			snappy = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			oddly_breakable_by_hand = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
		},
		damage_groups = {fleshy=10000},
	},
})



minetest.register_tool("dtools:testingTool", {
	description = "Testing Tool:\nCurrently messes with param2",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		---[[
		
		if pointed_thing.under then
			minetest.log("QTS Testing Tool used")
			local node = minetest.get_node(pointed_thing.under)
			node.param2 = node.param2 + 1
			minetest.set_node(pointed_thing.under, node)
			--minetest.set_node(pointed_thing.above, {name="arcane:disollving_stone", param2=10})
		end
		--]]
	end,
	on_place = function(itemstack, user, pointed_thing)
		
		if pointed_thing.under then
			--minetest.log("QTS Testing Tool placed")
			--local node = minetest.get_node(pointed_thing.under)
			--node.param2 = node.param2 - 1
			--minetest.set_node(pointed_thing.under, node)
			--minetest.set_node(pointed_thing.above, {name="arcane:disollving_stone", param2=10})
			minetest.log(minetest.pos_to_string(vector.subtract(pointed_thing.above, pointed_thing.under)))
		end
	end
})

minetest.register_tool("dtools:timer_tool", {
	description = "Timer Tool:\nShows the node's timer",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Timer Tool used")
		if pointed_thing.under then
			local timer = minetest.get_node_timer(pointed_thing.under)
			if timer then
				minetest.log("Node Timer at: " .. minetest.pos_to_string(pointed_thing.under) .. "\n" ..
					dump(timer:get_elapsed()) .. "/" .. dump(timer:get_timeout()) .. 
					"  -  started? " .. dump(timer:is_started()))
				--qts.get_modname_from_item(itemname)
				
			end
		end
	end,
})


minetest.register_tool("dtools:summoning_wand", {
	description = "Summoning Wand\nCurrently Summoning: dtools:static_entity",
	inventory_image = "dtools_blue_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Summoning Wand used")
		if pointed_thing.above then
			minetest.add_entity(pointed_thing.above, "dtools:mob_test_entity")
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("QTS Summoning Tool placed")
		if (pointed_thing.under) then
			qts.projetile_launch_to(
				"dtools:testing_projectile", 
				vector.add(user:get_pos(), {x=0, y=1.5, z=0}), 
				pointed_thing.under, 
				user, 
				25
			)
		end
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Summoning Tool rightclicked")
		--dtools.player_launch_projectile(user, "dtools:testing_projectile")
		qts.projectile_launch_player("dtools:testing_projectile", user, 5)
		--dtools.launch_test_projectile(vector.add(user:get_pos(), {x=0, y=1.5, z=0}), user:get_look_dir(), 25)
	end
})

minetest.register_tool("dtools:anti_stone", {
	description = "Anti Stone Tool",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool used")
		if pointed_thing.under then
			local nodes = qts.get_nodes_in_radius(pointed_thing.under, 10)
			for i, nodedat in ipairs(nodes) do
				if nodedat.noderef.name == "default:stone" then
					minetest.remove_node(nodedat.pos)
				end
			end
		end
	end,
	--[[
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool placed")
		if pointed_thing.under then
			local node = minetest.get_node_or_nil(pointed_thing.under)
			if node then
				node.param2 = node.param2 - 1
			end
			minetest.set_node(pointed_thing.under, node)
		end
	end
	--]]
})

minetest.register_tool("dtools:biome_check_tools", {
	description = "Biome Analitics Tool:\nCheck heat/humidity",
	inventory_image = "dtools_red_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if user then
			local p = user:get_pos()
			local humid = minetest.get_humidity(p)
			local heat = minetest.get_heat(p)
			local str = "Pos: ".. minetest.pos_to_string(p) .." Heat: "..dump(heat) .. " Humidity: "..dump(humid)
			minetest.chat_send_all(str)
			minetest.log(str)
		end
	end,

})


qts.register_item_modifier("testPlace", {
	description = "Test Place Modifier",
	on_place = function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
		minetest.log("Test Place Modifier Placed")
		return false
	end,
	on_dignode = function(pos, node, digger)
		minetest.log("modified Item used to dig")
	end,
	on_punch_node = function(pos, node, puncher, pointed_thing)
		minetest.log("modified Item used to punch a node")
	end,
	on_punch_player_ = function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
		minetest.log("modified Item used to punch a player")
	end,
	on_punch_entity = function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
		minetest.log("modified Item used to punch a entity")
	end,
	on_dieplayer = function(player, reason)
		minetest.log("player died with modified Item in the inventory")
	end,
	inventory_can_act = function(player, action, inventory, inventory_info)
		minetest.log("player inventory action check with modified Item")
		return -1 --all are OK, or, ignore the results of this func
	end,
	inventory_on_act = function(player, action, inventory, inventory_info)
		minetest.log("player inventory action execute with modified Item")
	end,
})


minetest.register_tool("dtools:paintbrush", {
	description = "Paintbrush",
	inventory_image = "dtools_paintbrush.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("Paintbrush Used")
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				local pindex = node.param2 / 32
				pindex = pindex + 1
				if (pindex >= 8) then pindex = 0 end
				node.param2 = pindex * 32
				minetest.set_node(pointed_thing.under, node)
			end
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("Paintbrush Placed")
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				local pindex = node.param2 / 32
				pindex = pindex - 1
				if (pindex <= -1) then pindex = 7 end
				node.param2 = pindex * 32
				minetest.set_node(pointed_thing.under, node)
			end
		end
	end,
})

