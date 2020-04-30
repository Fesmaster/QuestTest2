

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