

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
				minetest.set_node(p, {name = "overworld:granite"})
				
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
				minetest.set_node(pos, {name="overworld:copper_block"})
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
			if node and node.name == "overworld:copper_block" then
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


local scme_current_schematic = nil
local scme_path = minetest.get_modpath("qtcore") .. "/schems/"


minetest.register_chatcommand("scme_load", {
	params = "<filename>",
	description = "Loads the schematic of the specified filename to edit",
	func = function(name, param)
		scme_current_schematic = minetest.read_schematic(scme_path..param, {write_yslice_prob = "all"})
		minetest.log("Loaded File")
	end
})

minetest.register_chatcommand("scme_dump", {
	params = "none",
	description = "dumps the luatable of the currently edited schematic to the log",
	func = function(name, param)
		minetest.log(dump(scme_current_schematic))
	end
})

minetest.register_chatcommand("scme_write", {
	params = "<newfilename>",
	description = "writes the currently edited schematic to the supplied filename, in the world directory",
	func = function(name, param)
		if scme_current_schematic then
			local serialzied = minetest.serialize_schematic(scme_current_schematic, "mts", {})
			dtools.writeToFile("/" .. param, serialzied, true)
			minetest.log("Tried to Save File")
		end
	end
})

minetest.register_chatcommand("scme_repair_alias", {
	params = "None",
	description = "repairs alias names in the currently edited schematic",
	func = function(name, param)
		if scme_current_schematic then
			--minetest.registered_aliases
			for i, blob  in ipairs(scme_current_schematic.data) do
				local origName = blob.name
				local tn = minetest.registered_aliases[blob.name]
				while(tn) do
					blob.name = tn
					tn = minetest.registered_aliases[blob.name]
				end
				if (origName ~= blob.name) then
					minetest.log("replaced [" ..origName .. "] with [" .. blob.name .. "]")
				end
			end
			minetest.log("Alias repair completed.")
		end
	end
})