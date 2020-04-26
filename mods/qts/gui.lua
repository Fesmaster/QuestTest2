--gui code


qts.forms = {} -- the registered forms
qts.formData = {} --any form-instance specific data
qts_internal.formContext = {} --stores the context of open forms, to see if a player has one
local inventoryFormName = nil


--convert from old to new pos and size types
qts.gui_conv = {
	padding = 3/8,
	spaceing = 5/4,
}
qts.gui_makepos = function(x, y, new)
	local get = function(self)
		return tostring(self.x)..","..tostring(self.y)
	end
	if not new then
		return {
			x = (x)*qts.gui_conv.spaceing + qts.gui_conv.padding,
			y = (y)*qts.gui_conv.spaceing + qts.gui_conv.padding,
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
qts.gui_makesize = function(x, y, new)
	local get = function(self)
		return tostring(self.x)..","..tostring(self.y)
	end
	if not new then
		return {
			x = (x) * qts.gui_conv.spaceing + (qts.gui_conv.padding * 2) + 1,
			y = (y) * qts.gui_conv.spaceing + (qts.gui_conv.padding * 2) + 1,
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


function qts.register_gui(name, def)
	minetest.log("form registered")
	def.name = name
	qts.forms[name] = def
	if def.get == nil or def.handle == nil then
		minetest.log("error", "qts.register_form: get() and handle() must be implemented")
		return
	end
	
	if def.tab then
		minetest.log("tab type form")
		--this form is a tab in another form
		if def.owner and qts.forms[def.owner] and qts.forms[def.owner].tab_owner then
			local count = #qts.forms[def.owner].tabs
			minetest.log("tab form stored in "..tostring(count).."index of: " .. def.owner)
			qts.forms[def.owner].tabs[count+1] = def
		else
			minetest.log("error", "qts.register_form: if it is a tab type, a valid, registered owning form must be specified. Regsitration Failed!")
		end
		return
	elseif def.tab_owner then
		minetest.log("tab owner type form")
		--this form is the owner of a tab
		def.tabs = {}
	end
	qts.forms[name] = def
end

function qts.generate_tabs(current, formname)
	local returnval = "tabheader[0,0;tabs;"
	for i, f in pairs(qts.forms[formname].tabs) do
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


function qts.handle_tabs(pos, playername, formname, fields)
	local tab = tonumber(fields.tabs)
	if tab and qts.forms[formname].tab_owner and qts.forms[formname].tabs[tab] then
		
		qts.show_gui(pos, playername, formname, tab)
	end
end

function qts.pass_tabs(pos, playername, formname, fields)
	local tab = tonumber(fields.tabs)
	if tab and qts.forms[formname].tab_owner and qts.forms[formname].tabs[tab] then
		qts.forms[formname].tab_update(pos, qts_internal.formContext[playername], playername, fields, tab)
	end
end

function qts.show_gui(pos, player, formname, tabindex, show, ...)
	--minetest.log(""..formname.." attemting to load (1)")
	if qts.forms[formname] then --does the form name exist?
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
		if not qts.formData[pname] then qts.formData[pname] = {} end
		
		local formstr = qts.forms[formname].get(qts.formData[pname], pos, pname, ...)
		if qts.forms[formname].tab_owner and qts.forms[formname].tabs and #qts.forms[formname].tabs > 0 then
			if qts.forms[formname].tabs[tabindex] == nil then minetest.log("Tab does not exist! Index: "..tostring(tabindex)) end
			formstr =  formstr .. qts.generate_tabs(tabindex, formname) .. 
				qts.forms[formname].tabs[tabindex].get(qts.formData[pname], pos, pname, ...)
		elseif  qts.forms[formname].tab then
			for i, tab in ipairs(qts.forms[qts.forms[formname].owner].tabs) do
				if tab.name == formname then
					tabindex = i
				end
			end
			formstr = qts.forms[qts.forms[formname].owner].get(qts.formData[pname], pos, pname, ...)
				..qts.generate_tabs(tabindex, qts.forms[formname].owner) ..formstr
			local oldformname = formname
			formname = qts.forms[formname].owner
		end
		qts.formData[pname].activeTab = tabindex--update the tab index
		qts_internal.formContext[pname] = pos
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
		local handle_func = qts.forms[formname[2]].handle
		local pname = player:get_player_name()
		if qts_internal.formContext[pname] then
			--init form data
			if not qts.formData[pname] then qts.formData[pname] = {activeTab = 1} end
			
			--if this is an inventory, dont handle tabs automatically
			if inv then
				if qts.forms[formname[2]].tab_update then
					--qts.forms[formname[2]].tab_update(qts.formData[pname], qts_internal.formContext[pname], pname, fields)
					qts.pass_tabs(qts_internal.formContext[pname], pname, formname[2], fields)
				end
			else
				--else, handle them
				qts.handle_tabs(qts_internal.formContext[pname], pname, formname[2], fields)
			end
			if handle_func then
				handle_func(qts.formData[pname], qts_internal.formContext[pname], pname, fields)
				if qts.forms[formname[2]].tab_owner and #qts.forms[formname[2]].tabs > 0 and qts.forms[formname[2]].tabs[qts.formData[pname].activeTab] then
					--pass the event to the active tab
					qts.forms[formname[2]].tabs[qts.formData[pname].activeTab].handle(qts.formData[pname], qts_internal.formContext[pname], pname, fields)
				end
			end
		end
	else
		minetest.log("qts gui system: unknown form: "..dump(formname))
	end
end)


function qts.set_inventory_qui_name(name)
	inventoryFormName = name
end