--[[
	This file manages player specific data,

--]]

local playerDataPath = minetest.get_worldpath().."/QT2PlayerData"
minetest.mkdir(playerDataPath)

qts.player_data = {}

--[[
	Set a player's special data fields   
	player - the player. can be a player name  
	category - mod-specific or use specific category. To prevent name clashing. Should at least contain the mod name  
	field - the specific field  
	data - the data to set 

	This data is maintained between sessions. 
]]
function qts.set_player_data(player, catagory, field, data)
	if (type(player) ~= "string") then player = player:get_player_name() end
	
	if (qts.player_data[player] == nil) then
		qts.player_data[player] = {}
	end
	if (qts.player_data[player][catagory] == nil) then
		if (data ~= nil) then
			qts.player_data[player][catagory] = {}
		end
	end
	if (data == nil) then -- no field supplied
		qts.player_data[player][catagory] =field
	else
		qts.player_data[player][catagory][field] = data
	end
end

--[[
	Get a player's special data fields   
	player - the player. can be a player name  
	category - mod-specific or use specific category. To prevent name clashing. Should at least contain the mod name  
	field - the specific field  

	This data is maintained between sessions. 
]]
function qts.get_player_data(player, catagory, field)
	if (type(player) ~= "string") then player = player:get_player_name() end
	
	if (qts.player_data[player] == nil) then
		qts.player_data[player] = {}
		return nil
	end
	if (qts.player_data[player][catagory] == nil) then
		if (field ~= nil) then
			qts.player_data[player][catagory] = {}
		end
		return nil
	end
	if (field == nil) then
		return qts.player_data[player][catagory]
	else
		return qts.player_data[player][catagory][field]
	end
end

local IS_DAMAGE_ENABLED = minetest.settings:get_bool("enable_damage")

--[[
	actual armor calculations
--]]
local function apply_armor(damage, armor)
	if not armor then return 0 end --nil armor value means no damage at all from that.
	if damage*10 < armor then
		return 0
	end
	if damage <= armor then
		return 1
	end
	return damage - armor
end

--[[
	Apply armor to a damage value
	player or entity agnostic
--]]
function qts.apply_armor_to_damage(victim, damage, customArmorField)
	local armor = victim:get_armor_groups()
	--default to fleshy, if available
	customArmorField = customArmorField or "fleshy"
	if armor[customArmorField] then
		armor = (armor[customArmorField] or 1)-1
	else
		local armor_tmp = 0
		local count = 0
		for k, v in pairs(armor) do
			armor_tmp = armor_tmp + v
			count = count + 1
		end
		armor = armor_tmp/count
	end
	--armor is now a number
	return apply_armor(damage, armor)
end


local function clamp(a, min, max)
	return math.max(math.min(a, max),min)
end

--[[
	calculate the damage that should be delivered for a specific hit. victim and hitter are any objref, not just players or luaentities
]]
function qts.calculate_damage(victim, hitter, time_from_last_punch, tool_capabilities, dir)
	local armor_groups = victim:get_armor_groups()
	--deal with immortal creatures
	--deal with tools that cannot cause damage
	if (armor_groups.immortal) or (not tool_capabilities) or (not tool_capabilities.damage_groups) then
		--("Calculating damage using new function: 0 :{immortal?" .. dump(armor_groups.immortal) .. ", no tool caps?" .. dump(not tool_capabilities) .. ", no damgae groups?" .. dump(not tool_capabilities.damage_groups))
		return 0
	end
	local dmg = 0
	for cap, val in pairs(tool_capabilities.damage_groups) do
		local clamping = clamp((time_from_last_punch or 1)/(tool_capabilities.full_punch_interval or 1), 0.0, 1.0)
		local prearmor = val * clamping
		local armor = armor_groups[cap]-1
		local postarmor = apply_armor(prearmor, armor)
		dmg = dmg + postarmor
		--minetest.log("Damgae debug: \n\tgroup: " .. dump(cap)..
		--	"\n\tval: "..dump(val)..
		--	"\n\tclamping: "..dump(clamping) .. 
		--	"\n\tprearmor: "..dump(prearmor)..
		--	"\n\tarmor: "..dump(armor)..
		--	"\n\tpostarmor: " ..dump(postarmor)
		--)

	end
	--minetest.log("Calculating damage using new function: " .. dump(dmg))
	return dmg
end

function qts.recalculate_player_armor(player)
	player:set_armor_groups({fleshy=1})
end

local old_register_on_puchplayer = minetest.register_on_punchplayer
local old_register_on_player_hpchange =minetest.register_on_player_hpchange
local registered_puchplayers = {}
local registered_hpchanges_mod = {}
local registered_hpchanges_nomod = {}

function qts.get_player_hp(player)
	if IS_DAMAGE_ENABLED then
		return qts.get_player_data(player, "COMBATSYSTEM", "HP")
	else
		return qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX")
	end
end

function qts.get_player_hp_max(player)
	return qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX")
end

function qts.set_player_hp_max(player, max, fillHealth)
	qts.set_player_data(player, "COMBATSYSTEM", "HP_MAX", max)
	if fillHealth then
		qts.set_player_hp(player, max, "set_hp")
	end
end

function qts.set_player_hp(player, hp, reason)
	if IS_DAMAGE_ENABLED then
		local oldhp = qts.get_player_data(player, "COMBATSYSTEM", "HP")
		local hpchange = hp - oldhp

		for i, func in ipairs(registered_hpchanges_mod) do
			hpchange = func(player, hpchange, reason)
		end
		

		local newhp = math.min(oldhp +hpchange, qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX"))
		--minetest.log("setting player HP to " .. dump(newhp))
		if newhp <= 0 then
			newhp = 0
			player:set_hp(0, reason)
		else
			player:set_hp(20, "respawn")
		end
		qts.set_player_data(player, "COMBATSYSTEM", "HP", newhp)

		--unchanging callbacks run after the set
		for i, func in ipairs(registered_hpchanges_nomod) do
			func(player, hpchange, reason)
		end
	end
end

old_register_on_puchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if IS_DAMAGE_ENABLED then
		qts.set_player_hp(player, qts.get_player_hp(player)-qts.calculate_damage(player, hitter, time_from_last_punch, tool_capabilities, dir), "punch")
	end
	return true
end)

old_register_on_player_hpchange(function(player, hp_change, reason)
	if IS_DAMAGE_ENABLED then
		--minetest.log("Starting default HP change override. Value: " .. dump(hp_change) .. " Reason: " .. dump(reason))
		local unsafe_reasons = {fall=true, node_damage=true,drown=true}
		local internal_hp_change = 0
		if unsafe_reasons[reason.type] then
			--these need armor applied
			--minetest.log("unsafe")
			if hp_change < 0 then
				internal_hp_change = -qts.apply_armor_to_damage(player, -hp_change) --this function expects damage to be positive, but here, damage is negative. 
			else
				internal_hp_change = hp_change
			end
		else
			internal_hp_change = hp_change
		end
		--minetest.log("HP CHANGE pre funcs: " .. dump(internal_hp_change))

		--run the callbacks AFTER armor. change ones run before set
		for i, func in ipairs(registered_hpchanges_mod) do
			internal_hp_change = func(player, internal_hp_change, reason)
		end

		--check if we need to pass this to the external respawn stuff
		local external_hp_change = 0
		if reason.type == "respawn" then
			--minetest.log("RESPANW HEALTH FIX: " .. dump(hp_change))
			qts.set_player_data(player, "COMBATSYSTEM", "HP", qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX"))
			return hp_change
		end
		--minetest.log("HP CHANGE post funcs: " .. dump(internal_hp_change))
		local player_hp_current = qts.get_player_data(player, "COMBATSYSTEM", "HP")
		--minetest.log("CURRENT: " .. dump(player_hp_current))
		player_hp_current = math.min(player_hp_current + internal_hp_change, qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX"))
		--minetest.log("MOD: " .. dump(player_hp_current))
		if player_hp_current <= 0 then
			player_hp_current = 0 --this one should never be less than 0, for respawn reasons
			external_hp_change = -30 --instantly kill player, whose "default" hp max is fixed at 20 
		else
			external_hp_change = 30
		end

		qts.set_player_data(player, "COMBATSYSTEM", "HP", player_hp_current)
		
		--unchanging ones run after the set
		for i, func in ipairs(registered_hpchanges_nomod) do
			func(player, internal_hp_change, reason)
		end
		--minetest.log("Final setting of health: " .. dump(player_hp_current) .. " with external change: " .. dump(external_hp_change))
		return external_hp_change
	else
		return hp_change
	end
end, true)

minetest.register_on_respawnplayer(function(player)
	qts.set_player_hp(player, qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX"), "respawn")
	player:set_hp(20)
end)

--[[
	Override these so they don't interfere with the new damage mechanism
]]
minetest.register_on_punchplayer = function(func)
	registered_puchplayers[#registered_puchplayers+1] = func
end
minetest.register_on_player_hpchange = function(func, mod)
	if mod then
		registered_hpchanges_mod[#registered_hpchanges_mod+1] = func
	else
		registered_hpchanges_nomod[#registered_hpchanges_nomod+1] = func
	end
end


minetest.register_on_newplayer(function(player)
	minetest.log("New player, creating custom data for " .. player:get_player_name())
	qts.player_data[player:get_player_name()] = {}
	qts.set_player_data(player, "COMBATSYSTEM", "HP", qts.DEFAULT_HP)
	qts.set_player_data(player, "COMBATSYSTEM", "HP_MAX", qts.DEFAULT_HP)
	--player:set_armor_groups({fleshy=0})
end)

--enable zoom and map in creative
minetest.register_on_joinplayer(function(player, last_login)
	if qts.is_player_creative(player) then
		player:set_properties({zoom_fov = 15})
		player:hud_set_flags({
			minimap = true,
			minimap_radar = true
		})
	end
	--minetest.chat_send_all("QuestTest Dev Mode: ".. tostring(qts.ISDEV)) --Testing ONLY
	if last_login then
		minetest.log("Loading custom data for " .. player:get_player_name())
		local file = qts.create_settings_clojure(playerDataPath.."/"..player:get_player_name()..".conf")
		qts.player_data[player:get_player_name()] = minetest.deserialize(file.get_str("datatable"))
	end
	minetest.after(0.1, function(playername)
		local player = minetest.get_player_by_name(playername)
		if player then
			qts.recalculate_player_armor(player)
			player:hud_set_flags({healthbar=false}) --make default health bar invisible
		end
	end, player:get_player_name())
	
	if qts.get_player_data(player,"COMBATSYSTEM", "HP") == nil then
		qts.set_player_data(player, "COMBATSYSTEM", "HP", qts.DEFAULT_HP)
		qts.set_player_data(player, "COMBATSYSTEM", "HP_MAX", qts.DEFAULT_HP)
	end
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	minetest.log("Saving custom data for ".. player:get_player_name())
	local file = qts.create_settings_clojure(playerDataPath.."/"..player:get_player_name()..".conf")
	file.set_str("datatable", minetest.serialize(qts.player_data[player:get_player_name()]))
	file.save()
	qts.player_data[player:get_player_name()] = nil
end)

minetest.register_on_shutdown(function()
	--any remaining players should have their data saved
	for playername, data in pairs(qts.player_data) do
		minetest.log("Saving custom data for ".. playername)
		local file = qts.create_settings_clojure(playerDataPath.."/"..playername..".conf")
		file.set_str("datatable", minetest.serialize(data))
		file.save()
		--qts.player_data[playername] = nil
	end

	qts.world_settings.set_bool("QT_DEV_WORLD", qts.ISDEV)
    qts.world_settings.save()
	qts.settings.save()
	minetest.log("QTS shutdown finished")
end)