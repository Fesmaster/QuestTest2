--qt2 chat commands

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


--some testing code.
--will del
--[[

qts.register_gui("rename", {
	get =function(data, pos, name)
		return "size[4,4.5]" ..
				"field_close_on_enter[enter, true]"..
                "label[0,0;rename]" ..
                "field[1,1.5;3,1;name;New Node/Item name;]" ..
				"field[1,2.5;3,1;color;New Color;]" ..
                "button_exit[1,3;2,1;exit;Rename Now!]"
	end,
	handle = function(data, pos, name, fields)
		local player = minetest.get_player_by_name(name)
		local itemstack = player:get_wielded_item()
		local meta = itemstack:get_meta()
		if fields.name and fields.color then
			meta:set_string("description", fields.name .. "\n    " .. minetest.colorize(fields.color, "Color:" .. fields.color))
			meta:set_string("color", fields.color)
			player:set_wielded_item(itemstack)
		end
		return true
	end,
})

qts.register_gui("container", {
	tab_owner = true,
	get = function(data, pos, name)
		return "size[4,5]"
	end,
	handle = function(data, pos, name, fields)
		return
	end,
})

qts.register_gui("tab1", {
	tab = true,
	owner = "container",
	caption = "Tab 1",
	get = function(data, pos, name)
		return (--""..
				"field_close_on_enter[enter, true]"..
				"label[0,0;Print To Chant]"..
				"field[1,1.5;3,1;message;Message;]"..
				"button_exit[2,3;2,1;exit;Print Now!]")
	end,
	handle = function(data, pos, name, fields)
		if fields.message then
			minetest.log("Message sent through chat")
			minetest.chat_send_all(fields.message)
		end
	end
})

qts.register_gui("tab2", {
	tab = true,
	owner = "container",
	caption = "Tab 2",
	get = function(data, pos, name)
		return (--""..
				"field_close_on_enter[enter, true]"..
				"label[0,0;Print To Console:]"..
				"field[1,1.5;3,1;message;Log:;]"..
				"button_exit[2,3;2,1;exit;Log Now!]")
	end,
	handle = function(data, pos, name, fields)
		if fields.message then
			minetest.log(fields.message)
		end
	end
})

--qts.show_gui(pos, player, formname, tabindex, ...)
minetest.register_chatcommand("rename", {
    func = function(name, param)
		local player = minetest.get_player_by_name(name)
		qts.show_gui(player:get_pos(), player, "rename")
	end
})

minetest.register_chatcommand("tab", {
    func = function(name, param)
		minetest.log("Tab chatcommand")
		local player = minetest.get_player_by_name(name)
		qts.show_gui(player:get_pos(), player, "tab2")
	end
})

--]]
