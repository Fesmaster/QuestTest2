--[[
This code is based on the code from the schemedit mod (MIT license - see bottom of file)
Much of it is straight from said mod
--]]

local F = minetest.formspec_escape
if not DIR_DELIM then
	DIR_DELIM = "\\"
end
local export_path = minetest.get_worldpath()..DIR_DELIM.."schems"
--place files into qtcore mod's schematic dir
local text_color = "#ff0000"
local text_color_num = 0xff0000

local schm = {}
local markers = {}
local displayed_waypoints = {}

--re-index a table to list style
local function renumber(t)
	local res = {}
	for _,i in pairs(t) do
		res[#res+ 1] = i
	end
	return res
end

--unlike the original code, I like having a seperate lua prob and internal schematic prob.
--it lets me have lua prob be 0 - 100, (you know, normal!) for ease-of-use
--because of computer memory reasons, I store the prob 0 - 255, like the original.
--this is to preserve the detail of the data. Also, 0-100 can be decimal here, and not just int
--
--finally, trying to take 50% of 0 - 255 is just HARD!
local function prob_lua_to_schem(lua_prob)
	return math.floor(lua_prob / 2)
end
local function prob_schem_to_lua(schem_prob)
	return schem_prob * 2
end
local function prob_lua_to_disp(lua_prob)
	if lua_prob then
		return (lua_prob / 255) * 100
	end
end
local function prob_disp_to_lua(disp_prob)
	--minetest.log("here") --TODO: here
	if disp_prob then
		return math.floor((disp_prob / 100) * 255)
	end
end

--function to scan the metadata in a area of nodes and return a probability list
function schm.scan_meta(pos1, pos2)
	local prob_list = {}
	
	for x=pos1.x,pos2.x do
	for y=pos1.y,pos2.y do
	for z=pos1.z,pos2.z do
		local scanpos = {x=x, y=y, z=z}
		local node = minetest.get_node_or_nil(scanpos)
		
		local prob, force_place
		if node == nil or node.name == "dtools:schm_void" then
			prob = 0
			force_place = false
		else
			local meta = minetest.get_meta(scanpos)
			prob = tonumber(meta:get_string("schm_prob")) or 255 --full prob
			local fp = meta:get_string("schm_force_place")--always force place if its not there
			--if node.name == "dtools:schm_air" then fp = "true" end --force place dtools:schm_air
			if fp == "true" then
				force_place = true
			else
				force_place = false
			end
		end
		
		local hashpos = minetest.hash_node_position(scanpos)
		prob_list[hashpos] = {
			pos = scanpos,
			prob = prob,
			force_place = force_place,
		}
		
	end
	end
	end
	
	return prob_list
end

--sets the probabity tool's metadata and description
function schm.set_probtool_meta(itemstack, prob, force_place)
	local meta = itemstack:get_meta()
	local prob_desc = ""
	
	if prob  and prob >=0 and prob < 255 then --given probility
		meta:set_string("schem_prob", tostring(prob))
		prob_desc = "\n".."Probability: "..tostring(prob)
	elseif prob and prob == 255 then--default probability
		--prob_desc = ""
		--clear for default
		meta:set_string("schem_prob", nil)
	else --void probaboloty
		prob_desc = "\n".."Probability: ".. 
		(meta:get_string("schem_prob") or "Not Set")
	end
	
	--update force place
	if force_place == true then
		meta:set_string("schem_force_place", "true")
	elseif frce_place ==false then
		meta:set_string("schem_force_place", nil)
	end
	
	--update desc
	local desc = minetest.registered_items[itemstack:get_name()].description
	--there is a lot of redundant, stupid code in there that plays with 3 different ways of doing the line above.....
	local force_desc = "Force Placement"
	if not force_place then
		force_desc = "Yield Placement"
	end
	force_desc = "\n"..force_desc --append the newline on
	desc = desc .. minetest.colorize(text_color, prob_desc..force_desc)
	meta:set_string("description", desc)
	
	return itemstack
end

--mark a region
function schm.mark_border(pos)
	schm.unmark_border(pos)
	local id = minetest.hash_node_position(pos)
	local owner = minetest.get_meta(pos):get_string("owner") --TODO: make the entity not need an owner
	local pos1, pos2 = schm.getsize(pos)
	pos1, pos2 = schm.sortpos(pos1, pos2)
	
	local thickness = 0.2
	local sizex, sizey, sizez = (1 + pos2.x - pos1.x) / 2, (1 + pos2.y - pos1.y) / 2, (1 + pos2.z - pos1.z) / 2
	local m = {}
	local low = true
	local offset
	
	--XY plane markers
	for _,z in ipairs({pos1.z - 0.5, pos2.z + 0.5}) do
		if low then
			offset = -0.01
		else
			offset = 0.01
		end
		local marker = minetest.add_entity({
				x = pos1.x + sizex - 0.5, 
				y = pos1.y + sizey - 0.5, 
				z = z + offset
			}, "dtools:schm_disp")
		if marker ~= nil then
			marker:set_properties({
				visual_size={x=(sizex+0.01) * 2, y=sizey * 2},
			})
			marker:get_luaentity().id = id
			marker:get_luaentity().owner = owner--TODO: make the entity not need an owner
			table.insert(m, marker)
		end
		low = false
	end
	
	low = true
	--YZ plane markers
	for _, x in ipairs({pos1.x - 0.5, pos2.x + 0.5}) do
		if low then
			offset = -0.01
		else
			offset = 0.01
		end

		local marker = minetest.add_entity({
				x = x + offset, 
				y = pos1.y + sizey - 0.5, 
				z = pos1.z + sizez - 0.5
			},"dtools:schm_disp")
		if marker ~= nil then
			marker:set_properties({
				visual_size={x=(sizez+0.01) * 2, y=sizey * 2},
			})
			marker:set_yaw(math.pi / 2)
			marker:get_luaentity().id = id
			marker:get_luaentity().owner = owner
			table.insert(m, marker)
		end
		low = false
	end
	
	markers[id] = m
	return true
end
--unmark a region
function schm.unmark_border(pos)
	local id = minetest.hash_node_position(pos)
	if markers[id] then
		local retval
		for _, entity in ipairs(markers[id]) do
			entity:remove()
			retval = true
		end
		return retval
	end
end

--get the size of the area
function schm.getsize(pos)
	local pos1 = vector.new(pos)
	local meta = minetest.get_meta(pos)
	local node = minetest.get_node(pos)
	local param2 = node.param2
	local size = {
		x = meta:get_int("x_size"),
		y = math.max(meta:get_int("y_size")-1, 0), --why?
		z = meta:get_int("z_size"),
	}
	if param2 == 1 then
		local new_pos = vector.add({x = size.z, y = size.y, z = -size.x}, pos)
		pos1.x = pos1.x + 1
		new_pos.z = new_pos.z + 1
		return pos1, new_pos
	elseif param2 == 2 then
		local new_pos = vector.add({x = -size.x, y = size.y, z = -size.z}, pos)
		pos1.z = pos1.z - 1
		new_pos.x = new_pos.x + 1
		return pos1, new_pos
	elseif param2 == 3 then
		local new_pos = vector.add({x = -size.z, y = size.y, z = size.x}, pos)
		pos1.x = pos1.x - 1
		new_pos.z = new_pos.z - 1
		return pos1, new_pos
	else
		local new_pos = vector.add(size, pos)
		pos1.z = pos1.z + 1
		new_pos.x = new_pos.x - 1
		return pos1, new_pos
	end
end
--is it possible to replace with a function from vector?
--from original:
-- Copies and modifies positions `pos1` and `pos2` so that each component of
--`pos1` is less than or equal to the corresponding component of `pos2`.
-- Returns the new positions.
function schm.sortpos(pos1, pos2)
	if not pos1 or not pos2 then
		return
	end

	pos1, pos2 = table.copy(pos1), table.copy(pos2)
	if pos1.x > pos2.x then
		pos2.x, pos1.x = pos1.x, pos2.x
	end
	if pos1.y > pos2.y then
		pos2.y, pos1.y = pos1.y, pos2.y
	end
	if pos1.z > pos2.z then
		pos2.z, pos1.z = pos1.z, pos2.z
	end
	return pos1, pos2
end

--from original:
---
--- Mark node probability values near player
---

-- Show probability and force_place status of a particular position for player in HUD.
-- Probability is shown as a number followed by “[F]” if the node is force-placed.
-- The distance to the node is also displayed below that. This can't be avoided and is
-- and artifact of the waypoint HUD element. TODO: Hide displayed distance.
function schm.display_node_prob(player, pos, prob, force_place)
	--minetest.log("Disp Node Prob.   Prob:"..dump(prob).." Force: "..dump(force_place))
	local wpstring
	if prob and force_place == true then
		wpstring = string.format("%d [F]", prob_lua_to_disp(prob))
	elseif prob then
		wpstring = prob_lua_to_disp(prob)
	elseif force_place == true then
		wpstring = "[F]"
	end
	if wpstring then
		--minetest.log("Hud item should be added")
		return player:hud_add({
			hud_elem_type = "waypoint",
			name = wpstring,
			text = "m", -- For the distance artifact
			number = text_color_num,
			world_pos = pos,
		})
	end
end

--from original:
-- Display the node probabilities and force_place status of the nodes in a region.
-- By default, this is done for nodes near the player (distance: 5).
-- But the boundaries can optionally be set explicitly with pos1 and pos2.
function schm.display_node_probs_region(player, pos1, pos2)
	local playername = player:get_player_name()
	local pos = vector.round(player:get_pos())

	local dist = 5
	-- Default: 5 nodes away from player in any direction
	if not pos1 then
		pos1 = vector.subtract(pos, dist)
	end
	if not pos2 then
		pos2 = vector.add(pos, dist)
	end
	for x=pos1.x, pos2.x do
		for y=pos1.y, pos2.y do
			for z=pos1.z, pos2.z do
				local checkpos = {x=x, y=y, z=z}
				local nodehash = minetest.hash_node_position(checkpos)

				-- If node is already displayed, remove it so it can re replaced later
				if displayed_waypoints[playername][nodehash] then
					player:hud_remove(displayed_waypoints[playername][nodehash])
					displayed_waypoints[playername][nodehash] = nil
				end

				local prob, force_place
				local meta = minetest.get_meta(checkpos)
				prob = tonumber(meta:get_string("schem_prob"))
				force_place = meta:get_string("schem_force_place") == "true"
				local hud_id = schm.display_node_prob(player, checkpos, prob, force_place)
				if hud_id then
					displayed_waypoints[playername][nodehash] = hud_id
					displayed_waypoints[playername].display_active = true
				end
			end
		end
	end
end

-- Remove all active displayed node statuses.
function schm.clear_displayed_node_probs(player)
	local playername = player:get_player_name()
	for nodehash, hud_id in pairs(displayed_waypoints[playername]) do
		player:hud_remove(hud_id)
		displayed_waypoints[playername][nodehash] = nil
	end
	displayed_waypoints[playername].display_active = false
end



--gui
--using the qts gui system
qts.gui.register_gui("schem_main", {
	tab_owner = true,
	get = function(data, pos, name)
		return "size[7,8]"
	end,
	handle = function(data, pos, name, fields)
		return
	end,
})

qts.gui.register_gui("schem_create", {
	tab = true,
	caption = "Schematic Creator",
	owner = "schem_main",
	get = function(data, pos, name)
		local meta = minetest.get_meta(pos):to_table().fields
		local strpos = minetest.pos_to_string(pos)
		local hashpos = minetest.hash_node_position(pos)
		
		--show/hide the border. basically changes the text based on its visibility
		local border_button
		if meta.schem_border == "true" and markers[hashpos] then
			border_button = "button[3.5,7.5;3,1;border;"..F("Hide border").."]"
		else
			border_button = "button[3.5,7.5;3,1;border;"..F("Show border").."]"
		end
		local txt_x, txt_y, txt_z = meta.x_size, meta.y_size, meta.z_size
		if not txt_x then txt_x = "1" end
		if not txt_y then txt_y = "1" end
		if not txt_z then txt_z = "1" end
		                            
		return "label[0.5,-0.1;"..F("Position: "..strpos).."]"..
			"label[3,-0.1;"..F("Owner: "..name).."]"..

			"field[0.8,1;5,1;name;"..F("Schematic name:")..";"..F(meta.schem_name or "").."]"..
			"button[5.3,0.69;1.2,1;save_name;"..F("Save").."]"..
			"tooltip[save_name;"..F("Save schematic name").."]"..
			"field_close_on_enter[name;false]"..
			
			"button[0.5,1.5;6,1;export;"..F("Export schematic").."]"..
			"textarea[0.8,2.5;6.2,5;;"..F("The schematic will be exported as a .mts file and stored in "..
			export_path .. DIR_DELIM .. "<name>.mts.")..";]"..
			"field[0.8,7;2,1;x;"..F("X size:")..";"..txt_x.."]"..
			"field[2.8,7;2,1;y;"..F("Y size:")..";"..txt_y.."]"..
			"field[4.8,7;2,1;z;"..F("Z size:")..";"..txt_z.."]"..
			"field_close_on_enter[x;false]"..
			"field_close_on_enter[y;false]"..
			"field_close_on_enter[z;false]"..
			"button[0.5,7.5;3,1;save;"..F("Save size").."]"..
			border_button
		
	end,
	handle = function(data, pos, name, fields)
		local realmeta = minetest.get_meta(pos)
		local meta = realmeta:to_table().fields
		local hashpos = minetest.hash_node_position(pos)
		
		--Toggle the border
		if fields.border then
			if meta.schem_border == "true" and markers[hashpos] then
				schm.unmark_border(pos)
				meta.schem_border = "false"
			else
				schm.mark_border(pos)
				meta.schem_border = "false"
			end
		end
		
		--save the size vector values
		if (fields.save or fields.key_enter_field == "x" or fields.key_enter_field == "y" or fields.key_enter_field == "z")
				and (fields.x and fields.y and fields.z and fields.x ~= "" and fields.y ~= "" and fields.z ~= "") then
			--
			local x, y, z = tonumber(fields.x), tonumber(fields.y), tonumber(fields.z)
			if x then
				meta.x_size = math.max(x, 1)
			end
			if y then
				meta.y_size = math.max(y, 1)
			end
			if z then
				meta.z_size = math.max(z, 1)
			end
		end
		
		--save the name
		if fields.save_name or fields.key_enter_field == "name" and fields.name and fields.name ~= "" then
			meta.schem_name = fields.name
		end
		
		--export schematic TODO: export schematic code section marker
		if fields.export and meta.schem_name and meta.schem_name ~= "" then
			local pos1, pos2 = schm.getsize(pos)
			pos1, pos2 = schm.sortpos(pos1, pos2)
			local path = export_path .. DIR_DELIM
			minetest.mkdir(path)
			
			--node meta for probability
			local plist = schm.scan_meta(pos1, pos2)
			local probability_list = {}
			for hash, i in pairs(plist) do
				local prob = prob_lua_to_schem(i.prob)
				if i.force_place then
					prob = prob + 128 --set the 8th bit to be true
				end
				
				table.insert(probability_list, {
					pos = minetest.get_position_from_hash(hash),
					prob = prob
				})
			end
			
			--y slices
			local slist = minetest.deserialize(meta.slices)
			local slice_list = {}
			for _, i in pairs(slist) do
				slice_list[#slice_list + 1] = {
					ypos = pos.y + i.ypos,
					prob = prob_lua_to_schem(i.prob),
				}
			end
			
			--create the schematic
			local filepath = path..meta.schem_name..".mts"
			local res = minetest.create_schematic(pos1, pos2, probability_list, filepath, slice_list)
			
			--and send back the results
			if res then
				minetest.chat_send_player(name, minetest.colorize("#00ff00", "Exported Schematic to "..filepath))
			else
				minetest.chat_send_player(name, minetest.colorize("red", "Failed to export to "..filepath))
			end
		end
		
		--save the meta before updating anything
		local inv = realmeta:get_inventory():get_lists()
		realmeta:from_table({fields = meta, inventory = inv})
		--inv = nil --'delete' this value
		
		--update border
		--if not fields.border and meta.schem_border == "true" then
		--	schm.mark_border(pos)
		--end
		
		--reload the form
		if not fields.quit then
			qts.gui.show_gui(pos, name, "schem_create", 1)
		end
		
	end,
})

qts.gui.register_gui("schem_yslice", {
	tab = true,
	caption = "Y-Slices",
	owner = "schem_main",
	get = function(data, pos, name)
		local meta = minetest.get_meta(pos):to_table().fields
		
		data.selected = data.selected or 1
		local selected = tostring(data.selected)
		local slice_list = minetest.deserialize(meta.slices)
		if not slice_list then slice_list = {} end
		local slices = ""
		for _,i in pairs(slice_list) do
			local insert = F("Y = "..tostring(i.ypos).."; Probability = "..tostring(i.prob))
			slices = slices..insert..","
		end
		slices = slices:sub(1, -2)--remove final comma
		
		local form = [[
			table[0,0;6.8,6;slices;]]..slices..[[;]]..selected..[[]
		]]
		
		--edit fields
		if data.pannel_add or data.pannel_edit then
			local ypos_default, prob_default = "", ""
			local done_button = "button[5,7.18;2,1;done_add;"..F("Done").."]"
			if data.pannel_edit then
				done_button = "button[5,7.18;2,1;done_edit;"..F("Done").."]" --change the button internal name
				if slice_list[data.selected] then
					ypos_default = slice_list[data.selected].ypos
					prob_default = slice_list[data.selected].prob
				end
			end
			
			form = form..[[
				field[0.3,7.5;2.5,1;ypos;]]..F("Y position (max. "..tostring(meta.y_size - 1).."):")..[[;]]..ypos_default..[[]
				field[2.8,7.5;2.5,1;prob;]]..F("Probability (0-100):")..[[;]]..tostring(prob_lua_to_disp(prob_default))..[[]
				field_close_on_enter[ypos;false]
				field_close_on_enter[prob;false]
			]]..done_button
			
		end
		
		--add button
		if not data.pannel_edit then
			form = form.."button[0,6;2,1;add;"..F("+ Add slice").."]"
		end
		
		--edit and remove buttons
		if slices ~= "" and data.selected and not data.pannel_add then
			--if not data.pannel_edit then
			--for some reason, this next block was used twice, in an if-else statment, for BOTH options. 
			--so ive only represented it once
			form = form..[[
				button[2,6;2,1;remove;]]..F("- Remove slice")..[[]
				button[4,6;2,1;edit;]]..F("+/- Edit slice")..[[]
			]]
			--else
			--end
		end
		return form
	end,
	handle = function(data, pos, name, fields)
		local meta = minetest.get_meta(pos)
		local player = minetest.get_player_by_name(name)
		
		if fields.slices then
			local slices = fields.slices:split(":")
			data.selected = tonumber(slices[2])
		end
		--add button
		if fields.add then
			if not data.pannel_add then
				data.pannel_add = true
				qts.gui.show_gui(pos, name, "schem_yslice", 1)
			else
				data.pannel_add = nil
				qts.gui.show_gui(pos, name, "schem_yslice", 1)
			end
		end
		
		--done button
		local ypos, prob = tonumber(fields.ypos), prob_disp_to_lua(tonumber(fields.prob))
		if (fields.done_add or fields.done_edit) and fields.ypos and fields.prob and
				fields.ypos ~= "" and fields.prob ~= "" and ypos and prob and
				ypos <= (meta:get_int("y_size")-1) and prob >= 0 and prob <= 255 then
			--one heck of an if statment
			local slice_list = minetest.deserialize(meta:get_string("slices"))
			local index = #slice_list + 1
			if fields.done_edit then
				index = data.selected
			end
			
			slice_list[index] = {ypos = ypos, prob = prob}
			meta:set_string("slices", minetest.serialize(slice_list))
			
			--update formspec
			data.pannel_add = nil
			qts.gui.show_gui(pos, name, "schem_yslice", 1)
		end
		
		--remove button
		if fields.remove and data.selected then
			local slice_list = minetest.deserialize(meta:get_string("slices"))
			slice_list[data.selected] = nil
			meta:set_string("slices", minetest.serialize(slice_list))
			
			--update formspec
			data.selected = 1
			self.pannel_edit = nil
			qts.gui.show_gui(pos, name, "schem_yslice", 1)
		end
		
		--edit button
		if fields.edit then
			if not data.pannel_edit then
				data.pannel_edit = true
				qts.gui.show_gui(pos, name, "schem_yslice", 1)
			else
				data.pannel_edit = nil
				qts.gui.show_gui(pos, name, "schem_yslice", 1)
			end
		end
	end,
})

qts.gui.register_gui("schem_probtool", {
	get = function(data, pos, name)
		local player = minetest.get_player_by_name(name)
		if not player then return end
		
		local probtool = player:get_wielded_item()
		if probtool:get_name() ~= "dtools:schem_probtool" then return end
		
		local meta = probtool:get_meta()
		local prob = tonumber(meta:get_string("schem_prob"))
		local force_place = meta:get_string("schem_force_place")
		
		if not prob then prob = 255 end
		if force_place == nil or force_place == "" then
			force_place = "false"
		end
		local form = "size[5,4]"..
			"label[0,0;"..F("Schematic Node Probability Tool (New and Improved!)").."]"..
			"field[0.75,1;4,1;prob;"..F("Probability(0-100)")..";"..tostring(prob_lua_to_disp(prob)).."]"..
			"checkbox[0.60,1.5;force_place;"..F("Force placement")..";" .. force_place .. "]" ..
			"button_exit[0.25,3;2,1;cancel;"..F("Cancel").."]"..
			"button_exit[2.75,3;2,1;submit;"..F("Apply").."]"..
			"tooltip[prob;"..F("Probability that the node will be placed").."]"..
			"tooltip[force_place;"..F("If enabled, the node will replace nodes other than air and ignore").."]"..
			"field_close_on_enter[prob;false]"
		return form
	end,
	handle = function(data, pos, name, fields)
		--minetest.log("Got to handle func")
		if fields.submit then --TODO: probtool GUI
			local prob = prob_disp_to_lua(tonumber(fields.prob))
			--minetest.log("Probability set: lua: "..dump(prob).." disp: "..dump(fields.prob))
			if prob then
				local player = minetest.get_player_by_name(name)
				if not player then return end
				local probtool = player:get_wielded_item()
				if probtool:get_name() ~= "dtools:schem_probtool" then return end
				local force_place = data.force_place == true
				
				schm.set_probtool_meta(probtool, prob, force_place)
				probtool:set_wear(math.floor(((255-prob)/255)*65535))
				
				player:set_wielded_item(probtool)
			end
		end
		if fields.force_place == "true" then
			data.force_place = true
		elseif fields.force_place == "false" then
			data.force_place = false
		end
	end
})

--[[



--]]



minetest.register_on_joinplayer(function(player)
	displayed_waypoints[player:get_player_name()] = {
		display_active = false	-- If true, there *might* be at least one active node prob HUD display
					-- If false, no node probabilities are displayed for sure.
	}
end)

minetest.register_on_leaveplayer(function(player)
	displayed_waypoints[player:get_player_name()] = nil
end)
--from original
-- Regularily clear the displayed node probabilities and force_place
-- for all players who do not wield the probtool.
-- This makes sure the screen is not spammed with information when it
-- isn't needed.
local cleartimer = 0
minetest.register_globalstep(function(dtime)
	cleartimer = cleartimer + dtime
	if cleartimer > 2 then
		local players = minetest.get_connected_players()
		for p = 1, #players do
			local player = players[p]
			local pname = player:get_player_name()
			if displayed_waypoints[pname].display_active then
				local item = player:get_wielded_item()
				if item:get_name() ~= "dtools:schem_probtool" then
					schem.clear_displayed_node_probs(player)
				end
			end
		end
		cleartimer = 0
	end
end)

--dtools:schm_void
--dtools:schm_air
--dtools:schem_probtool
--dtools:schm_disp

-- [node] Schematic creator
minetest.register_node("dtools:schem_creator", {
	description = "Schematic Creator",
	tiles = {"dtools_schm_top.png", "dtools_schm_top.png",
			"dtools_schm_side.png"},
	groups = { dig_immediate = 2},
	paramtype2 = "facedir",
	is_ground_content = false,

	after_place_node = function(pos, player)
		local name = player:get_player_name()
		local meta = minetest.get_meta(pos)

		meta:set_string("owner", name) --ONLY because it is passed to the entity for some reason ???? TODO: Dont make the node have an owner
		meta:set_string("infotext", "Schematic Creator".."\n".."(owned by "..name..")")
		meta:set_string("prob_list", minetest.serialize({}))
		meta:set_string("slices", minetest.serialize({}))
		
		--these are never used, so why bother getting them?
		--local node = minetest.get_node(pos)
		--local dir  = minetest.facedir_to_dir(node.param2)

		meta:set_int("x_size", 1)
		meta:set_int("y_size", 1)
		meta:set_int("z_size", 1)

		-- Don't take item from itemstack
		return true
	end,
	can_dig = function(pos, player)
		local name = player:get_player_name()
		local meta = minetest.get_meta(pos)
		--if meta:get_string("owner") == name or
		--		minetest.check_player_privs(player, "schematic_override") == true then
		--	return true
		--end
		--
		--return false
		return true
	end,
	on_rightclick = function(pos, node, player)
		--local meta = minetest.get_meta(pos)
		--local name = player:get_player_name()
		--if meta:get_string("owner") == name or
		--		minetest.check_player_privs(player, "schematic_override") == true then
		-- Get player attribute
		--local tab = player:get_meta():get("schemedit:tab") --changed to fix depriciated code
		--if not forms[tab] or not tab then
		--	tab = "main"
		--end

		qts.gui.show_gui(pos, player, "schem_main", 1)
		--end
	end,
	after_destruct = function(pos)
		schm.unmark_border(pos)
	end,
})

minetest.register_tool("dtools:schem_probtool", {
	description = "Schematic Node Probability Tool",
	wield_image = "dtools_schm_prob.png",
	inventory_image = "dtools_schm_prob.png",
	liquids_pointable = true,
	groups = { disable_repair = 1 },
	
	on_place = function(itemstack, placer, pointed_thing)
		local ctrl = placer:get_player_control()
		-- Simple use
		if not ctrl.sneak then
			-- Open dialog to change the probability to apply to nodes
			qts.gui.show_gui(placer:get_pos(), placer, "schem_probtool")

		-- Use + sneak
		else
			-- Display the probability and force_place values for nodes.
			-- If a schematic creator was punched, only enable display for all nodes
			-- within the creator's region.
			local use_creator_region = false
			if pointed_thing and pointed_thing.type == "node" and pointed_thing.under then
				punchpos = pointed_thing.under
				local node = minetest.get_node(punchpos)
				if node.name == "dtools:schem_creator" then
					local pos1, pos2 = schm.getsize(punchpos)
					pos1, pos2 = schm.sortpos(pos1, pos2)
					schm.display_node_probs_region(placer, pos1, pos2)
					return
				end
			end
			-- Otherwise, just display the region close to the player
			schm.display_node_probs_region(placer)
		end
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		schm.clear_displayed_node_probs(user)
	end,
	-- Set note probability and force_place and enable node probability display
	on_use = function(itemstack, user, pointed_thing)
		--this function is no longer on_place() so this is pointless
		-- Use pointed node's on_rightclick function first, if present
		--local node = minetest.get_node(pointed_thing.under)
		--if placer and not placer:get_player_control().sneak then
		--	if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
		--		return minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer, itemstack) or itemstack
		--	end
		--end

		-- This sets the node probability of pointed node to the
		-- currently used probability stored in the tool.
		
		if not pointed_thing.under then return end
		
		local pos = pointed_thing.under
		local node = minetest.get_node(pos)
		-- Schematic void are ignored, they always have probability 0
		if node.name == "dtools:schm_void" then
			return itemstack
		end
		local nmeta = minetest.get_meta(pos)
		local imeta = itemstack:get_meta()
		local prob = tonumber(imeta:get_string("schem_prob"))
		local force_place = imeta:get_string("schem_force_place")
		
		if not prob or prob == 255 then
			nmeta:set_string("schem_prob", nil)
		else
			nmeta:set_string("schem_prob", prob)
			--minetest.log("prob of node should be set")
		end
		if force_place == "true" then
			nmeta:set_string("schem_force_place", "true")
		else
			nmeta:set_string("schem_force_place", nil)
		end
		--minetest.log("Probetool")
		-- Enable node probablity display
		schm.display_node_probs_region(user)

		return itemstack
	end,
})

minetest.register_node("dtools:schm_void", {
	description = "Schematic Void",
	tiles = { "dtools_schm_void.png" },
	drawtype = "nodebox",
	is_ground_content = false,
	paramtype = "light",
	walkable = false,
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{ -4/16, -4/16, -4/16, 4/16, 4/16, 4/16 },
		},
	},
	groups = { dig_immediate = 3},
})

-- [entity] Visible schematic border
minetest.register_entity("dtools:schm_disp", {
	visual = "upright_sprite",
	textures = {"dtool_schm_border.png"},
	visual_size = {x=10, y=10},
	pointable = false,
	physical = false,
	glow = minetest.LIGHT_MAX,

	on_step = function(self, dtime)
		if not self.id then
			self.object:remove()
		elseif not markers[self.id] then
			self.object:remove()
		end
	end,
	on_activate = function(self)
		self.object:set_armor_groups({immortal = 1})
	end,
})


--TODO: finish shematic placer tool
--minetest.register_tool("dtools:schem_probtool", {
--	description = "Schematic Node Probability Tool",
--	wield_image = "dtools_schm_prob.png",
--	inventory_image = "dtools_schm_prob.png",
--	liquids_pointable = true,
--	groups = { disable_repair = 1 },
--	on_use = function(itemstack, user, pointed_thing)
--		
--	end,
--})

--[[
Copied from License of the schemedit mod

MIT License
Copyright (c) 2017 Elijah Duffy
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]