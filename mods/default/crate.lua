
qts.register_chest("default:crate", {
	description = "Crate",
	tiles = {"default_crate.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	sounds = qtcore.node_sound_wood(),
	
	invsize = 8*4,
	get_chest_formspec = qtcore.get_default_chest_formspec,
})

--[[
--A Test chest to see how well different inv sizes would work
--
qtcore.register_chest("default:crate_big", {
	description = "Big Crate",
	tiles = {"default_crate.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 2},
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	sounds = qtcore.node_sound_wood(),
	
	invsize = 8*6,
	get_chest_formspec = function(pos, pname)
		local size = qts.gui.gui_makesize(7.6, 10)
		return "size["..size:get().."]"..
			"real_coordinates[true]"..
			qtcore.get_default_chest_formspec(qts.gui.gui_makepos(0,0), pos, {x=8,y=6})..
			inventory.get_player_main(qts.gui.gui_makepos(0,6.5), false)..
			qtcore.get_chest_liststring(pos)..
			"listring[current_player;main]"
	end
})
--]]
