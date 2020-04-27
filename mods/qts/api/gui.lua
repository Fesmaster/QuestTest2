--gui code

--the gui namespace. made because there are horificly large numbers of functions
qts.gui = {}


qts.gui.forms = {} -- the registered forms
qts.gui.formData = {} --any form-instance specific data
local formContext = {} --stores the context of open forms, to see if a player has one
local inventoryFormName = nil


--convert from old to new pos and size types
qts.gui.gui_conv = {
	padding = 3/8,
	spaceing = 5/4,
}
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


function qts.gui.register_gui(name, def)
	minetest.log("form registered")
	def.name = name
	qts.gui.forms[name] = def
	if def.get == nil or def.handle == nil then
		minetest.log("error", "qts.gui.register_form: get() and handle() must be implemented")
		return
	end
	
	if def.tab then
		minetest.log("tab type form")
		--this form is a tab in another form
		if def.owner and qts.gui.forms[def.owner] and qts.gui.forms[def.owner].tab_owner then
			local count = #qts.gui.forms[def.owner].tabs
			minetest.log("tab form stored in "..tostring(count).."index of: " .. def.owner)
			qts.gui.forms[def.owner].tabs[count+1] = def
		else
			minetest.log("error", "qts.gui.register_form: if it is a tab type, a valid, registered owning form must be specified. Regsitration Failed!")
		end
		return
	elseif def.tab_owner then
		minetest.log("tab owner type form")
		--this form is the owner of a tab
		def.tabs = {}
	end
	qts.gui.forms[name] = def
end

function qts.gui.generate_tabs(current, formname)
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


function qts.gui.handle_tabs(pos, playername, formname, fields)
	local tab = tonumber(fields.tabs)
	if tab and qts.gui.forms[formname].tab_owner and qts.gui.forms[formname].tabs[tab] then
		
		qts.gui.show_gui(pos, playername, formname, tab)
	end
end

function qts.gui.pass_tabs(pos, playername, formname, fields)
	local tab = tonumber(fields.tabs)
	if tab and qts.gui.forms[formname].tab_owner and qts.gui.forms[formname].tabs[tab] then
		qts.gui.forms[formname].tab_update(pos, formContext[playername], playername, fields, tab)
	end
end

function qts.gui.show_gui(pos, player, formname, tabindex, show, ...)
	--minetest.log(""..formname.." attemting to load (1)")
	if qts.gui.forms[formname] then --does the form name exist?
		--minetest.log(""..formname.." attemting to load (2)")
		if show == nil then show = true end --show default value
		if not tabindex then 
			tabindex = 1 
			minetest.log(""..formname.." tab defaulting to 0")
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
			if qts.gui.forms[formname].tabs[tabindex] == nil then minetest.log("Tab does not exist! Index: "..tostring(tabindex)) end
			formstr =  formstr .. qts.gui.generate_tabs(tabindex, formname) .. 
				qts.gui.forms[formname].tabs[tabindex].get(qts.gui.formData[pname], pos, pname, ...)
		elseif  qts.gui.forms[formname].tab then
			for i, tab in ipairs(qts.gui.forms[qts.gui.forms[formname].owner].tabs) do
				if tab.name == formname then
					tabindex = i
				end
			end
			formstr = qts.gui.forms[qts.gui.forms[formname].owner].get(qts.gui.formData[pname], pos, pname, ...)
				..qts.gui.generate_tabs(tabindex, qts.gui.forms[formname].owner) ..formstr
			local oldformname = formname
			formname = qts.gui.forms[formname].owner
		end
		qts.gui.formData[pname].activeTab = tabindex--update the tab index
		formContext[pname] = pos
		if show then
			minetest.log(""..formname.." loading. string: "..formstr)
			minetest.show_formspec(pname, "qts:"..formname, formstr)
		else
			return {"qts:"..formname, formstr}
		end
		
	end
end

--TODO: move to mt_impl.lua
minetest.register_on_player_receive_fields(function(player, formname, fields)
	--handle registered forms
	local inv = false
	if formname == "" and inventoryFormName then
		formname = "qts:"..inventoryFormName
		inv = true
	end
	local formname = formname:split(":")
	if formname[1] == "qts" and formname[2] then
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
					qts.gui.pass_tabs(formContext[pname], pname, formname[2], fields)
				end
			else
				--else, handle them
				qts.gui.handle_tabs(formContext[pname], pname, formname[2], fields)
			end
			if handle_func then
				handle_func(qts.gui.formData[pname], formContext[pname], pname, fields)
				if qts.gui.forms[formname[2]].tab_owner and #qts.gui.forms[formname[2]].tabs > 0 and qts.gui.forms[formname[2]].tabs[qts.gui.formData[pname].activeTab] then
					--pass the event to the active tab
					qts.gui.forms[formname[2]].tabs[qts.gui.formData[pname].activeTab].handle(qts.gui.formData[pname], formContext[pname], pname, fields)
				end
			end
		end
	else
		minetest.log("qts gui system: unknown form: "..dump(formname))
	end
end)


function qts.gui.set_inventory_qui_name(name)
	inventoryFormName = name
end