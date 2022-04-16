--[[
CHEST API
Modified from Default (minetest_game)
--]]

--######################################################################################
--FORMSPEC
--######################################################################################
local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
local esc = minetest.formspec_escape

qtcore.get_chest_inv_formspec = function(gui_pos, pos, size)
	--node pos to formspec string
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local ssize = size.x .. "," .. size.y
	--gui sensible default pos
	if not gui_pos then gui_pos = qts.gui.gui_makepos(0, 0) end
	return "container["..gui_pos:get().."]"..
		"list[nodemeta:" .. spos .. ";main;"..P(0,0)..";"..ssize..";]"..
		"container_end[]"
end

qtcore.get_chest_liststring = function(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	return "listring[nodemeta:" .. spos .. ";main]"
end




qtcore.get_default_chest_formspec = function(pos, pname)
	local size = qts.gui.gui_makesize(9.6, 8)
	return "size["..size:get().."]"..
		"real_coordinates[true]"..
		qtcore.get_chest_inv_formspec(qts.gui.gui_makepos(1,0), pos, {x=8,y=4})..
		inventory.get_player_main(qts.gui.gui_makepos(0,4.5), false)..
		qtcore.get_chest_liststring(pos)..
		"listring[current_player;main]"
end


qtcore.vprogressbar = function(pos, size, progress)
	if not pos then pos = qts.gui.gui_makepos(0, 0) end
	if not size then size = "1,1" end
	if not progress then progress = 0.5 end
	return "image["..pos:get()..";"..size..";gui_progressbar_bg.png^[lowpart:"..
			(progress)..":gui_progressbar_fg.png]"
end
qtcore.hprogressbar = function(pos, size, progress)
	if not pos then pos = qts.gui.gui_makepos(0, 0) end
	if not size then size = "1,1" end
	if not progress then progress = 0.5 end
	return "image["..pos:get()..";"..size..";gui_progressbar_bg.png^[lowpart:"..
			(progress)..":gui_progressbar_fg.png^[transformR270]"
end

