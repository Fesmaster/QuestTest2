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

minetest.register_chatcommand("spawnpoint", {
	params="[<offset>]",
	description = "Set your spawnpoint",
	privs={creative=1},
	func=function (name, param)
		local offset = vector.new(0,0,0)
		---@type Player
		local player = minetest.get_player_by_name(name)
		if player == nil then return end
		local abspos = player:get_pos()
		if param and param ~= "" then
			local fields = string.split(param, ",", false)
			if #fields ~= 3 then
				minetest.chat_send_player(name, "Unable to complete spawnpoint set. Offset String format invalid. use 'x,y,z' format, where each can be a number for absolute or a number preceded by '~' for relative")
				return
			end
			local map = {"x","y","z"}
			for i, str in ipairs(fields) do
				if string.sub(str, 1,1) == "~" then
					local off = tonumber(string.sub(str, 2))
					if off then
						offset[map[i]] = off
					else
						minetest.chat_send_player(name, "Unable to complete spawnpoint set. Offset String format invalid. use 'x,y,z' format, where each can be a number for absolute or a number preceded by '~' for relative")
						return
					end
				else
					local abs = tonumber(str)
					if abs then
						abspos[map[i]] = abs
					else
						minetest.chat_send_player(name, "Unable to complete spawnpoint set. Offset String format invalid. use 'x,y,z' format, where each can be a number for absolute or a number preceded by '~' for relative")
						return
					end
				end
			end
		end

		--set the spawnpoint
		qts.set_player_spawnpoint(player, abspos+offset)
		minetest.chat_send_player(name, "spawnpoint set to: " .. (abspos+offset):to_string())
	end
})
