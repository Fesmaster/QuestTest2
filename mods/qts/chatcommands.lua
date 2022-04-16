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

minetest.register_chatcommand("qlevelmult", {
	params = "<number, 0 to 1>",
	description = "Set the level power multiplier",
	func = function(name, p)
		if (p) then
			local n = tonumber(p)
			if n > 0 and n <= 1 then
				qts.LEVEL_MULTIPLIER = n
				qts.world_settings.set_num("LEVEL_MULTIPLIER", n)
				minetest.log("World Settings Updated: LEVEL_MULTIPLIER set to " .. n)
			else
				minetest.chat_send_player(name, "Unable to update settings: only values from 0 to 1 are allowed")
			end
		else
			qts.world_settings.set_num("LEVEL_MULTIPLIER", 0.2)
			qts.LEVEL_MULTIPLIER = 0.2 --TODO: potentally bad hardcoded value
			minetest.log("World Settings Updated: LEVEL_MULTIPLIER set to 0.2")
		end
	end
})

