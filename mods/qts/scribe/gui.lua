--[[
	QuestTest2 Gui system
	This is a wrapper for formspec, to make it a bit easier to use, and so that you never have to
	regiter a on_player_receive_fields function.
]]

--[[
	QTS gui namespace
	Functions under this are for GUI use.
]]
qts.gui = {}


qts.gui.forms = {} -- the registered forms
qts.gui.formData = {} --any form-instance specific data
local formContext = {} --stores the context of open forms, to see if a player has one
local inventoryFormName = nil


--[[
	Conversion values for converting from old to new pos and size types
]]
qts.gui.gui_conv = {
	padding = 3/8,
	spaceing = 5/4,
}

--[[
	Make a GUI positon string (new format), using old (or new) position types.  
	Usually, this is aliased to a local P()  

	Params:  
		x - number - the x position  
		y - number - the y position  
		new - boolean or nil. True if the input positions are in the new position format.  
]]
qts.gui.gui_makepos = function(x, y, new)
	local get = function(self)
		return tostring(self.x)..","..tostring(self.y)
	end
	if not new then
		return {
			x = (x)*qts.gui.gui_conv.spaceing + qts.gui.gui_conv.padding,
			y = (y)*qts.gui.gui_conv.spaceing + qts.gui.gui_conv.padding,
			get = get
		}
	else
		return 	{
		x = x,
		y = y,
		get = get
	}
	end
end
--[[
	Make a GUI size string (new format), using old (or new) size types.  
	Usually, this is aliased to a local S()  

	Params:  
		x - number - the x size  
		y - number - the y size  
		new - boolean or nil. True if the input positions are in the new position format.  
]]
qts.gui.gui_makesize = function(x, y, new)
	local get = function(self)
		return tostring(self.x)..","..tostring(self.y)
	end
	if not new then
		return {
			x = (x) * qts.gui.gui_conv.spaceing + (qts.gui.gui_conv.padding * 2) + 1,
			y = (y) * qts.gui.gui_conv.spaceing + (qts.gui.gui_conv.padding * 2) + 1,
			get = get,
		}
	else
		return 	{
		x = x,
		y = y,
		get = get,
	}
	end
end

--[[
	get the name of the currently open gui.  

	Params:  
		player - the player or player name  

	Returns:  
		string of the name, or  empty string if no gui is open.  
]]
function qts.gui.get_open_gui(player)
	if type(player) ~= "string" then
		player = player:get_player_name()
	end
	if formContext[player] and formContext[player].name then
		--minetest.log(dump(formContext[player]))
		return formContext[player].name
	end
	return ""
end

--[[
	Push some random data to the currently open gui, iof one is present  

	Params:  
		player - the player or playername  
		data - table of the data. it is shallow copied into the form's data.  

	Returns:  
		boolean, true if there is an open form and the data is pushed, false otherwise.  
]]
function qts.gui.push_to_form(player, data)
	if type(player) ~= "string" then
		player = player:get_player_name()
	end
	if formContext[player] and qts.gui.formData[player] then
		for k, v in pairs(data) do
			qts.gui.formData[player][k] = v
		end
		return true
	end
	return false
end

--[[
	make a gui click sound (for buttons)  

	Params:  
		name - the player name (name only!).  
]]
function qts.gui.click(name)
	minetest.sound_play("gui_button", {gain = 0.5, to_player = name})
end

--[[
	register a new GUI  

	Params:  
		name - the GUI name, used later for displaying it later.  
		def - a GUI definition table  

	GUI Definition Table:
	{  
		get(data, pos, playername, ...) - function that returns a formspec string, to display the GUI.  
		handle(data, pos, playername, fields) - function that handles the fields received from this GUI.  
		tab_update(data, pos, playername, fields, tab) - function that handls fields for tabs received by the GUI  
			- this is called for the Tab Owner, not the tab!
		tab - boolean, true if the GUI is a tab in another  
		owner - if tab is true, then this must be an already registered gui that owns this tab.  
		tab_owner - boolean, true if the GUI can hold tabs. Ignored if the GUI is a tab. You cannot be both a tab and a tab owner.  
	}  
]]
function qts.gui.register_gui(name, def)
	--minetest.log("form registered")
	def.name = string.gsub(name, ":", "_"); --names cannot have a colen in them: its breaks the fields distributing system.
	if def.name ~= name then
		minetest.log("warning", "GUI has been renamed: " .. name .. " to " .. def.name)
	end
	if def.get == nil or def.handle == nil then
		minetest.log("error", "qts.gui.register_form: get() and handle() must be implemented")
		return
	end
	--qts.gui.forms[name] = def
	
	if def.tab then
		--minetest.log("tab type form")
		--this form is a tab in another form
		if def.owner and qts.gui.forms[def.owner] and qts.gui.forms[def.owner].tab_owner then
			local count = #qts.gui.forms[def.owner].tabs
			--minetest.log("tab form stored in "..tostring(count).."index of: " .. def.owner)
			qts.gui.forms[def.owner].tabs[count+1] = def
		else
			minetest.log("error", "qts.gui.register_form: if it is a tab type, a valid, registered owning form must be specified. Regsitration Failed!")
		end
		return
	elseif def.tab_owner then
		--minetest.log("tab owner type form")
		--this form is the owner of a tab
		def.tabs = {}
	end
	qts.gui.forms[def.name] = def
end

--[[
	generate the tab formspec string for the tabs of a named GUI.  
	
	Params:  
		current - the current tab, either the tab name or the tab number  
		formname - the registered GUI name  
]]
local function generate_tabs(current, formname)
	local returnval = "tabheader[0,0;tabs;"
	for i, f in pairs(qts.gui.forms[formname].tabs) do
		if f.tab ~= false and f.caption then
			returnval = returnval .. f.caption..","
			if type(current) ~= "number" and current == f.name then
				current = i --find the tab that we care about being set active
			end
		end
	end
	returnval = returnval:sub(1, -2) --remove last comma
	returnval = returnval .. ";" .. current .."]" --close the tab header
	return returnval
end

--[[
	Handle tab switching, when fields are recieved  

	Params:  
		pos - the position in question
		playername - the player name  
		formname - the registered GUI name  
		fields - the response fields  
]]
local function handle_tabs(pos, playername, formname, fields)
	local tab = tonumber(fields.tabs)
	if tab and qts.gui.forms[formname].tab_owner and qts.gui.forms[formname].tabs[tab] then
		
		qts.gui.show_gui(pos, playername, formname, tab)
	end
end

--[[
	Handle passing along of tab_update to the tab owner

	Params:
		pos - the position in question
		playername - the player name
		formname - the registered gui name
		fields - the fields
]]
local function pass_tabs(pos, playername, formname, fields)
	local tab = tonumber(fields.tabs)
	if tab and qts.gui.forms[formname].tab_owner and qts.gui.forms[formname].tabs[tab] then
		--(data, pos, name, fields, tabnumber)
		qts.gui.forms[formname].tab_update(qts.gui.formData[playername], pos, playername, fields, tab)
	end
end

--[[
	Show a registered GUI to a player  

	Params:  
		pos - the position in question. If the GUI is from a node, its that node's position,   
			otherwise, its often the player position. It could be any position, though.  
		player - the player or playername to show the GUI to  
		formname - the name of the registered GUI to show.  
		tabindex - the index of tab to show.  
			Tab indices come from the order in which tabs are registered for that particualr Owner.  
		show = true - bool, set to false to have this function return the formspec strings  
		... - any other params you want to pass to the get() function of the GUI  
	
	Returns:  
		when show is default or true:  nil
		when show is false: {guiname, forpsecstring}
]]
function qts.gui.show_gui(pos, player, formname, tabindex, show, ...)
	--minetest.log(""..formname.." attemting to load (1)")
	formname = string.gsub(formname, ":", "_"); --auto-handle formnames that contain colons.
	if qts.gui.forms[formname] then --does the form name exist?
		--minetest.log(""..formname.." attemting to load (2)")
		if show == nil then show = true end --show default value
		if not tabindex then 
			tabindex = 1 
			--minetest.log(""..formname.." tab defaulting to 0")
		end
		--handle the player variable being a name or player ref
		if type(player) == "string" then
			player = minetest.get_player_by_name(player)
		end
		local pname = player:get_player_name()
		--init form data
		if not qts.gui.formData[pname] then qts.gui.formData[pname] = {} end
		
		local formstr = qts.gui.forms[formname].get(qts.gui.formData[pname], pos, pname, ...)
		if qts.gui.forms[formname].tab_owner and qts.gui.forms[formname].tabs and #qts.gui.forms[formname].tabs > 0 then
			if qts.gui.forms[formname].tabs[tabindex] == nil then minetest.log("error", "Tab does not exist! Index: "..tostring(tabindex)) end
			formstr =  formstr .. generate_tabs(tabindex, formname) .. 
				qts.gui.forms[formname].tabs[tabindex].get(qts.gui.formData[pname], pos, pname, ...)
		elseif  qts.gui.forms[formname].tab then
			for i, tab in ipairs(qts.gui.forms[qts.gui.forms[formname].owner].tabs) do
				if tab.name == formname then
					tabindex = i
				end
			end
			formstr = qts.gui.forms[qts.gui.forms[formname].owner].get(qts.gui.formData[pname], pos, pname, ...)
				..generate_tabs(tabindex, qts.gui.forms[formname].owner) ..formstr
			local oldformname = formname
			formname = qts.gui.forms[formname].owner
		end
		qts.gui.formData[pname].activeTab = tabindex--update the tab index
		formContext[pname] = {pos=pos, name=formname}
		if show then
			--minetest.log(""..formname.." loading. string: "..formstr)
			minetest.show_formspec(pname, "qts:"..formname, formstr)
		else
			return {"qts:"..formname, formstr}
		end
	else
		minetest.log("Warning", "Unable to find a registered GUI named '"..formname.."'")
	end
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
	--handle registered forms
	local inv = false
	if formname == "" and inventoryFormName then
		formname = "qts:"..inventoryFormName
		inv = true
	end
	local formname = formname:split(":")
	if formname[1] == "qts" and formname[2] and qts.gui.forms[formname[2]] then
		--found a form registered by this API
		local handle_func = qts.gui.forms[formname[2]].handle
		local pname = player:get_player_name()
		if formContext[pname] then
			--init form data
			if not qts.gui.formData[pname] then qts.gui.formData[pname] = {activeTab = 1} end
			
			--if this is an inventory, dont handle tabs automatically
			if inv then
				if qts.gui.forms[formname[2]].tab_update then
					--qts.gui.forms[formname[2]].tab_update(qts.gui.formData[pname], formContext[pname], pname, fields)
					pass_tabs(formContext[pname].pos, pname, formname[2], fields)
				end
			else
				--else, handle them
				handle_tabs(formContext[pname].pos, pname, formname[2], fields)
			end
			if handle_func then
				--minetest.log("handle function should be called")
				handle_func(qts.gui.formData[pname], formContext[pname].pos, pname, fields)
				if qts.gui.forms[formname[2]].tab_owner and #qts.gui.forms[formname[2]].tabs > 0 and qts.gui.forms[formname[2]].tabs[qts.gui.formData[pname].activeTab] then
					--pass the event to the active tab
					qts.gui.forms[formname[2]].tabs[qts.gui.formData[pname].activeTab].handle(qts.gui.formData[pname], formContext[pname].pos, pname, fields)
				end
			else
				--minetest.log("handle function does not exist")
			end
		else
			--minetest.log("No form context!")
		end
		
		if fields.quit then
			formContext[pname].name = nil
		end
	--else
		--minetest.log("qts gui system: unknown form: "..dump(formname))
	end
end)

--[[
	Set an internal reference for the GUI to be used for the Inventory.  
	Does Not call `player:set_inventory_formspec(formspec_string)`  
	To actually set the inventory, call:  
	```  
	local formspec_code = qts.gui.show_gui(player:get_pos(), player, qts.gui.get_inventory_gui_name(), <0 or whatever tab you want>, false)[2]  
	player:set_inventory_formspec(formspec_code)  
	```  

	Params:  
		name - the registered GUI name   
]]
function qts.gui.set_inventory_gui_name(name)
	inventoryFormName = name
end
--[[
	Get the internal reference to the GUI to be used for the Inventory.  

	Returns:  
		the registered GUI name.  
]]
function qts.gui.get_inventory_gui_name()
	return inventoryFormName
end
