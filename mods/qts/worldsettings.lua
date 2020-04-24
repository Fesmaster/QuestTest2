
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
		return settings:get_bool(key, false)
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
	local function get_noiseParams(key)
		return settings:get_np_group(key)
	end
	local function set_noiseParams(key, tbl)
		return settings:set_np_group(key, tbl)
	end
	local function get_mapgen_flags(key)
		return settings:get_flags(key)
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
		get_noiseParams = get_noiseParams,
		get_mapgen_flags = get_mapgen_flags,
		set_str = set_str,
		set_num = set_num,
		set_bool = set_bool,
		set_noiseParams = set_noiseParams,
		remove_key = remove_key,
		keys = keys,
		to_table = to_table,
		save = save
	}
end


--load the WorldSettings into the qts namespace
qts.world_settings = qts.create_settings_clojure(minetest.get_worldpath().."/QTConf.conf")
qts.ISDEV = qts.world_settings.get_bool("QT_DEV_WORLD") --setup qts.ISDEV
if (not qts.ISDEV) then
	qts.world_settings.set_bool("QT_DEV_WORLD", false) --makes sure the file contains the key, and exists
end

