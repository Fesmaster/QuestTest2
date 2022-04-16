

minetest.register_chatcommand("natleaves", {
	params = "<y/n>",
	description = "If on, placed leaves will be \"natural\" and able to decay. \nNot that leafdecy does not happen in Devmode",
	func = function(name, param)
		if minetest.is_yes(param) or param == "on" then
			qts.world_settings.set_bool("natLeaves", true)
			minetest.chat_send_player(name, "Natural leaves are placeable")
		else
			qts.world_settings.set_bool("natLeaves", false)
			minetest.chat_send_player(name, "Natural leaves are not placeable")
		end
	end
})

minetest.register_chatcommand("toys", {
	params = "<text>",
	description = "Get you some toys",
	func = function(name, param)
		local inv = minetest.get_player_by_name(name):get_inventory()
		inv:add_item("main", "dtools:testingTool")
		inv:add_item("main", "dtools:gauntlet")
	end,
})

minetest.register_chatcommand("playground", {
	params = "None",
	description = "Make a nice, flat area",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			local pos = player:get_pos()
			for x = -20,20 do
			for z = -20,20 do
				local p = {x=pos.x + x, y = pos.y - 1, z = pos.z + z}
				minetest.set_node(p, {name = "default:stone_cobble"})
				
			end
			end
		end
	end,
})


minetest.register_chatcommand("tmod", {
	params = "<text>",
	description = "Apply the test modifer to the itemstack helt",
	func = function(name, param)
		local itemstack = minetest.get_player_by_name(name):get_wielded_item()
		qts.apply_item_modifier(itemstack, "testPlace", 1)
		minetest.get_player_by_name(name):set_wielded_item(itemstack)
	end,
})

minetest.register_chatcommand("punchme", {
	params = "<text>",
	description = "Player punches themselves in the arm",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		player:punch(player, 1.0, {
				full_punch_interval = 0.9,
				damage_groups = {fleshy = 50},
			}, nil)
	end,
})

minetest.register_chatcommand("healme", {
	params = "<text>",
	description = "Player heals themselves",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local props = player:get_properties()
		player:set_hp(props.hp_max)
	end,
})

minetest.register_chatcommand("hp100me", {
	params = "<text>",
	description = "Player sets their own HP max to 100",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local props = player:get_properties()
		props.hp_max = 100
		player:set_properties(props)
	end,
})

minetest.register_chatcommand("randpos_check", {
	params = "<text>",
	description = "Player is randomly teleported in a range of 64 blocks",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		for i = 0, 50 do
			local pos = qts.ai.get_random_navagatable_point_in_radius(
				player:get_pos(), 
				32, 
				{airlike=true,check_ground=true}, 
				2
			)
			if pos then
				minetest.set_node(pos, {name="default:copper_block"})
				--player:set_pos(pos)
			else
				minetest.log("No position returned. try: " .. i)
			end
		end
	end,
})

minetest.register_chatcommand("randpos_clear", {
	params = "<text>",
	description = "Player is randomly teleported in a range of 64 blocks",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		for x = -32, 32 do
		for y = -32, 32 do
		for z = -32, 32 do
			local p = vector.add({x=x,y=y,z=z}, pos)
			local node = minetest.get_node_or_nil(p)
			if node and node.name == "default:copper_block" then
				minetest.set_node(p, {name="air"})
			end
		end
		end
		end
	end
})

minetest.register_chatcommand("clearground", {
	params = "None",
	description = "Make a nice, flat area",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			local pos = player:get_pos()
			for x = -20,20 do
			for z = -20,20 do
			for y = 0, 10 do
				local p = {x=pos.x + x, y = pos.y + y, z = pos.z + z}
				minetest.set_node(p, {name = "air"})
			end
			end
			end
		end
	end
})


minetest.register_chatcommand("checkhand", {
	params = "None",
	description = "check wield hand item name",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player then
			local wield = player:get_wielded_item()
			if wield then
				local item = wield:get_name()
				if item then
					minetest.chat_send_player(name, "item: " .. dump(item))
					return
				end
			end
		end
		minetest.chat_send_player(name, "item failure")
	end
})