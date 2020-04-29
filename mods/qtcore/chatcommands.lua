

minetest.register_chatcommand("leafplace", {
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