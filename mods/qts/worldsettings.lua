
--clojure function to gen the worldsettings and have the settings object protected
function qts.create_settings_clojure(filename)
	local settings = Settings(filename)
	
	local function get_str(key)
		return settings:get(key)
	end
	local function set_str(key, str)
		return settings:set(key, str)
	end
	local function get_bool(key)
		return settings:get_bool(key, nil)
	end
	local function set_bool(key, val)
		return settings:set_bool(key, val)
	end
	local function get_num(key)
		return tonumber(settings:get(key))
	end
	local function set_num(key, num)
		return settings:set(key, tostring(num))
	end
	local function get_table(key)
		return minetest.deserialize(settings:get(key))
	end
	local function set_table(key, tbl)
		return settings:set(key, minetest.serialize(tbl))
	end
	local function get_noiseParams(key)
		return settings:get_np_group(key)
	end
	local function set_noiseParams(key, tbl)
		return settings:set_np_group(key, tbl)
	end
	local function get_mapgen_flags(key)
		return settings:get_flags(key)
	end
	local function get_type(key, typestr)
		if typestr == "string" then
			return settings:get(key)
		elseif typestr == "number" then
			return tonumber(settings:get(key))
		elseif typestr == "boolean" then
			return settings:get_bool(key)
		elseif typestr == "table" then
			return minetest.deserialize(settings:get(key))
		end
	end
	local function set_type(key, value)
		local typestr = type(value)
		if typestr == "string" then
			return settings:set(key)
		elseif typestr == "number" then
			return settings:set(key, tostring(value))
		elseif typestr == "boolean" then
			return settings:set_bool(key, value)
		elseif typestr == "table" then
			return settings:set(key, minetest.serialize(value))
		end
	end
	local function remove_key(key)
		return settings:remove(key)
	end
	local function keys()
		return settings:get_names()
	end
	local function to_table()
		return settings:to_table()
	end
	local function save()
		return settings:write()
	end
	return {
		get_str = get_str,
		get_num = get_num,
		get_bool = get_bool,
		get_table = get_table,
		get_type = get_type,
		get_noiseParams = get_noiseParams,
		get_mapgen_flags = get_mapgen_flags,
		set_str = set_str,
		set_num = set_num,
		set_bool = set_bool,
		set_table = set_table,
		set_type = set_type,
		set_noiseParams = set_noiseParams,
		remove_key = remove_key,
		keys = keys,
		to_table = to_table,
		save = save
	}
end


--load the WorldSettings into the qts namespace
qts.world_settings = qts.create_settings_clojure(minetest.get_worldpath().."/QTConf.conf")


qts.settings = qts.create_settings_clojure(minetest.get_modpath("qts") .. "/QT2Settings.conf")

---comment
---@param key string
---@param typestr type
local function get_setting_by_type_minetest(key, typestr)
	if typestr == "string" then
		return minetest.settings:get(key)
	elseif typestr == "number" then
		return tonumber(minetest.settings:get(key))
	elseif typestr == "boolean" then
		return minetest.settings:get_bool(key)
	elseif typestr == "table" then
		return minetest.deserialize(minetest.settings:get(key))
	end
end

minetest.register_privilege("settingmanager", {
	description="capable of managing the QT2 Settings",
	give_to_singleplayer=true,
	give_to_admin=true
})

---@class Config
---@field get function() returns the config value
---@field set function(value) sets the config value
---@field type function() gets the config value type
---@field setpoint function() gets the last thing to set the Config

---@alias ConfigSetPoint
---|"constructor" as defined in the constructor
---|"global_settings" as defined in QT2Settings.conf
---|"minetest_settings" as defined in minetest.conf
---|"world_settings" as defined in the world QTConf.conf file
---|"console" as set by a chatcommand
---|"function" as set by code

---Create a configuration variable. It will load from settings or use the constructed value. It will also have a console commadn to get and set it.
--[[

	flags={
		no_global=false,
		no_minetest=false,
		no_local=false,
		no_chatcommand=false,
		loadtime=false,
		force_chatcommand=false,
		no_setfunc=false,
	}
]]
---@param config_name string a name with no spaces
---@param default_value any
---@param description string a long descrtiption of the value
---@param flags table|nil the flags of what to create
---@return Config
function qts.config(config_name, default_value, description, flags)
	---@type any
	local val = default_value
	
	---@type type
	local typestr = type(val)

	---@type ConfigSetPoint
	local last_set_by = "constructor"

	if flags == nil then flags = {} end

	--disable chatcommand setting of table values, for safety reasons!
	if typestr == "table" then
		flags.no_chatcommand=true
	end
	
	--hirarchical get
	if not flags.no_global then
		local newval = qts.settings.get_type(config_name, typestr)
		if newval then
			val = newval
			last_set_by="global_settings"
		end
	end
	
	if not flags.no_minetest then
		local newval = get_setting_by_type_minetest(config_name, typestr)
		if newval then
			val = newval
			last_set_by="minetest_settings"
		end
	end

	if not flags.no_local then
		local newval = qts.world_settings.get_type(config_name, typestr)
		if newval then
			val = newval
			last_set_by="world_settings"
		end
	end

	if not (flags.no_chatcommand or flags.loadtime) or flags.force_chatcommand then
		minetest.register_chatcommand(config_name, {
			params= "[<value>]",
			description = config_name.."\n"..description,
			privs={settingmanager=true},
			func = function(name, param)
				if not param or param == "" then
					return true, config_name .. " = " .. dump(val) .. " (last set by " .. last_set_by..")"
				else
					local trimmed= string.trim(param)
					if typestr == "string" then
						val = trimmed
					elseif typestr == "number" then
						val = tonumber(trimmed)
					elseif typestr == "boolean" then
						val = minetest.is_yes(trimmed)
					elseif typestr == "table" then
						minetest.log("warning", "Setting a table config variable by a chat command is a really bad idea! This could be insecure. Param: " .. trimmed)
						val = minetest.deserialize(trimmed)
					else
						return false, "the type of "..config_name.." does not support setting by console."
					end
					last_set_by="console"
					return true, config_name .. " = " .. dump(val) .. " (last set by " .. last_set_by..")"
				end
			end
		})
	else
		--even if no chatcommand is requested, one is still registered to view the setting.
		minetest.register_chatcommand(config_name, {
			params= "",
			description = description,
			privs={settingmanager=true},
			func = function(name, param)
				return true, config_name .. " = " .. dump(val) .. " (last set by " .. last_set_by..")"
			end
		})
	end

	return {
		get = function () return val end,

		set = function(newval)
			if flags.no_setfunc then
				minetest.log("warning", "igoring the setting of Config "..config_name.." as it has the no_setfunc flag.")
				return
			end
			if type(newval) == typestr then
				val = newval
				last_set_by="function"
			else
				minetest.log("warning", "igoring the setting of Config "..config_name.." by code due to type mismatch.")
			end
		end,

		type=function() return typestr end,
		setpoint=function() return last_set_by end,
	}
end

qts.ISDEV = qts.world_settings.get_bool("QT_DEV_WORLD") --setup qts.ISDEV

if (not qts.ISDEV) then
	qts.world_settings.set_bool("QT_DEV_WORLD", false) --makes sure the file contains the key, and exists
end

--save the settings on shutdown
minetest.register_on_shutdown(function()
	qts.settings:save()
	qts.world_settings:save()
end)