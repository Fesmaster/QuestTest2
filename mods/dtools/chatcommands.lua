

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
		player:punch(player, 1.0, {fleshy=5}, nil)
	end,
})