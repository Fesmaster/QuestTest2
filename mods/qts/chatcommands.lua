--qts chat commands

minetest.register_privilege("QT_DEV", {
	description = "QuestTest2 Dev Abilities",
	give_to_singleplayer = qts.ISDEV,
})

minetest.register_chatcommand("devmode", {
	params = "<text>",
	description = "Set the devmode enabled/disabled",
	func = function(name, param)
		if minetest.is_yes(param) or param == "on" then
			qts.ISDEV = true
			minetest.chat_send_player(name, "Devmode Enabled! \nReload World to apply to item registrations.")
			minetest.log("QT: DEVMODE ENABLED")
		else
			qts.ISDEV = false
			minetest.chat_send_player(name, "Devmode Disabled! \nReload World to apply to item registrations.")
			minetest.log("QT: DEVMODE DISABLED")
		end
	end
})


