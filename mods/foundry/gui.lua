

local esc = minetest.formspec_escape
local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
local mp = qts.gui.gui_makepos
local S = function(x,y) return qts.gui.gui_makesize(x,y):get() end
local ms = qts.gui.gui_makesize
--data.metalLVL/data:get_max_metal()*100
qts.gui.register_gui("foundry", {
	get = function(data, pos, name)
		local spos = pos.x .. "," .. pos.y .. "," .. pos.z
		local FD = foundry.GetFoundryData(pos)
		if not FD then return "size["..S(10.5,8).."]" end
		
		local str = "size["..S(9.75,8.2).."]real_coordinates[true]"..
			"container["..P(0,0).."]"..
			"list[nodemeta:" .. spos .. ";main;"..P(0,0)..";6,4;]"..--the inv
			--qtcore.vprogressbar(mp(7,0), "0.15,1", 50)
			"image["..P(6.4,0)..";1,4;gui_progressbar_bg.png^[lowpart:"..
			(FD.heat)..":gui_progressbar_fg_heat.png]"..
			"label["..P(6.4,3.5)..";"..esc("Heat: "..tostring(FD.heat).."%").."]"..
			"image["..P(7.6,0)..";1,4;gui_progressbar_bg.png^[lowpart:"..
			(FD.metalLVL/FD:get_max_metal()*100)..":gui_progressbar_fg_heat.png]"..
			"label["..P(7.6,3.5)..";".."Metal: "..
				tostring(FD.metalLVL/FD:get_max_metal()*100).."% \n("..
				tostring(FD.metalLVL).."/"..tostring(FD:get_max_metal())..
			")]"
		local i = 1
		for y = 0,3 do
			for x = 0,5 do
				--the inventory
				str = str ..qtcore.vprogressbar(mp(x+0.83,y), "0.15,1", FD.smeltPercent[i])
				
				i = i + 1
			end
		end
		str = str .."container_end[]"..
			inventory.get_player_main(qts.gui.gui_makepos(0,4.5), false)..
			"listring[current_player;main]"..
			"listring[nodemeta:"..spos..";main]"..
			"listring[current_player;main]"
		
		--handle updates
		minetest.after(0.8, function(pos, name)
			if qts.gui.get_open_gui(name) == "foundry" then
				qts.gui.show_gui(pos, name, "foundry")
			end
		end, pos, name)
		
		return str
	end,
	handle = function(data, pos, name, fields)
		return
	end,
})