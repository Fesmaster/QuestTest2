--[[
	This file manages player specific data,


QuestTest Damge Groups:
	fleshy = melee attacks
	stabby = ranged attacks
	psycic = magic attacks
	enviromental = node damage, fall damage, drowning damage, poison, etc.
--]]

local playerDataPath = minetest.get_worldpath().."/QT2PlayerData"
minetest.mkdir(playerDataPath)

qts.player_data = {}


local playerdata_profile_start, playerdata_profile_stop = qts.profile("Player Data Access", "ms")
local damage_profile_start, damage_profile_stop = qts.profile("Player Damage", "ms")

--[[
	Set a player's special data fields   
	This data is maintained between sessions. 

	Params:
		player - the player. can be a player name  
		category - mod-specific or use specific category. To prevent name clashing. Should at least contain the mod name  
		field - the specific field  
		data - the data to set (if ommited, then field is the data - useful when setting a table, as its keys can be fields for future gets)

]]
function qts.set_player_data(player, catagory, field, data)
	playerdata_profile_start()
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
	playerdata_profile_stop()
end

--[[
	Get a player's special data fields   
	This data is maintained between sessions. 
	
	Params:
		player - the player. can be a player name  
		category - mod-specific or use specific category. To prevent name clashing. Should at least contain the mod name  
		field - the specific field  

	Returns:
		the data field

	
]]
function qts.get_player_data(player, catagory, field)
	playerdata_profile_start()
	if (type(player) ~= "string") then player = player:get_player_name() end
	
	if (qts.player_data[player] == nil) then
		playerdata_profile_stop()
		return nil
	end
	if (qts.player_data[player][catagory] == nil) then
		playerdata_profile_stop()
		return nil
	end
	if (field == nil) then
		playerdata_profile_stop()
		return qts.player_data[player][catagory]
	else
		playerdata_profile_stop()
		return qts.player_data[player][catagory][field]
	end
end

local IS_DAMAGE_ENABLED = minetest.settings:get_bool("enable_damage")

--[[
	QuestTest armor calculations function
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

	Params:
		victim - the victim entity
		damage - the ammount of damage
		damage_group - the type of damage
]]
function qts.apply_armor_to_damage(victim, damage, damage_group)
	local armor = victim:get_armor_groups()
	--default to fleshy, if available
	damage_group = damage_group or "fleshy"
	if armor[damage_group] then
		armor = (armor[damage_group] or 1)-1
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

--[[
	clamp a value between a min and max
]]
local function clamp(a, min, max)
	return math.max(math.min(a, max),min)
end

local registered_playerpunches = {}
--[[
	Register a function to be run when the player attacks an entity or another player.
	If there is a return value, then it is taken as the new tool_capabilities
	This is applied before armor calculations, including checking if the victim is immortal

	Params:
		function(victim, hitter, time_from_last_punch, tool_capabilities, dir)
]]
function qts.register_on_player_attack(func)
	registered_playerpunches[#registered_playerpunches+1] = func 
end

--[[
	calculate the damage that should be delivered for a specific hit. victim and hitter are any objref, not just players or luaentities

	Params:
		victim - the victim entity
		hitter - the hitting entity
		time_from_last_punch - the time since the last punch delivered by hitter to anyone
		tool_capabilities - the tool capabilities, including damage types
		dir - the direction the damage came from (usually from hitter to victim)
	
	Returns:
		the damage value, correctly calculated for armor, bonuses, etc

	TODO: this needs to take Item Modifiers into account. See itemModifiers.lua
]]
function qts.calculate_damage(victim, hitter, time_from_last_punch, tool_capabilities, dir)
	
	if hitter:is_player() then
		for k, func in ipairs(registered_playerpunches) do
			local tbl = func(victim, hitter, time_from_last_punch, tool_capabilities, dir)
			if tbl and type(tbl) == "table" then
				tool_capabilities = tbl
			end
		end
	end


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
		local bonus = 0
		if hitter:is_player() then
			bonus = qts.get_player_data(hitter, "MODIFIERS", "ADD_damgae_bonus_" .. cap) or 0
		end
		dmg = dmg + apply_armor((val * clamping) + bonus, armor_groups[cap]-1)
	end
	--minetest.log("Calculating damage using new function: " .. dump(dmg))
	return dmg
end

--[[
	Get the list of armor for the player
	This function should be overriden to return the equipment list for the player  
	These entries should be itemstacks, and the list should be packed. 

	Params:  
		player - the player

	Returns:
		table - an array of **item names**, not ItemStacks, item strings, or item stables
]]
function qts.get_player_equipment_list(player)
	return {}
end

--[[
	Recalculate the player armor, based off of their equipment list

	Params:
		player - the player

	Returns:
		nothing
]]
function qts.recalculate_player_armor(player)
	if IS_DAMAGE_ENABLED then --only do this when damage is enabled, as that is when it has a purpose.
		local armor_groups = {fleshy=1, stabby=1, psycic=1, enviromental=1} --DEFUALT ARMOR GROUPS

		for index,stack in ipairs(qts.get_player_equipment_list(player)) do
			if not stack:is_empty() then
				local name = stack:get_name()
				local def = minetest.registered_items[name]
				if def and def.armor_groups then
					for k, v in pairs(def.armor_groups) do
						if armor_groups[k] then
							armor_groups[k] = armor_groups[k]+v
						else
							armor_groups[k] = v+1 --this deals with the off-by-one error
						end
					end
				end
			end
		end
		player:set_armor_groups(armor_groups)
	end
end

local old_register_on_puchplayer = minetest.register_on_punchplayer
local old_register_on_player_hpchange =minetest.register_on_player_hpchange
local registered_puchplayers = {}
local registered_hpchanges_mod = {}
local registered_hpchanges_nomod = {}

--[[
	Get the player current HP

	Params:
		player - the player

	Returns:
		the player health
]]
function qts.get_player_hp(player)
	if IS_DAMAGE_ENABLED then
		return qts.get_player_data(player, "COMBATSYSTEM", "HP")
	else
		return qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX")
	end
end

--[[
	Get the player's max HP
	
	Params:
		player - the player

	Returns:
		the plaeyr's max health (unboosted)
]]
function qts.get_player_hp_max(player)
	return qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX")
end

--[[
	Set the player's max HP  
	optionally, also fill their health to this value

	Params
		player - the player
		max - the new max health
		fillHealth = true - boolean, if true, then fill the currrent health to the max

	Returns:
		nothing
]]
function qts.set_player_hp_max(player, max, fillHealth)
	qts.set_player_data(player, "COMBATSYSTEM", "HP_MAX", max)
	if fillHealth or fillHealth == nil then
		qts.set_player_hp(player, max, "set_hp")
	end
end

local function clamp_player_hp(player,hp)
	return math.min(hp, qts.get_player_data(player, "COMBATSYSTEM", "HP_MAX") + (qts.get_player_data(player, "MODIFIERS", "ADD_health_bonus") or 0))
end

--[[
	refresh the player HP, in case the max dropped
	This just clamps what is currently there.

	Params:
		player - the player
]]
function qts.refresh_player_hp(player)
	local oldhp = qts.get_player_data(player, "COMBATSYSTEM", "HP")
	local newhp = clamp_player_hp(player, oldhp)
	local should_run_funcs = newhp ~= oldhp
	qts.set_player_data(player, "COMBATSYSTEM", "HP", newhp)
	if should_run_funcs then
		for i, func in ipairs(registered_hpchanges_nomod) do
			func(player, oldhp-newhp, "set_hp")
		end
	end
end

--[[
	Add a value to the player hp (or remove if negative)

	Params:
		player - the player
		hp - the change in health
		reason - if negative, then the reason for the HP change. defaults to "set_hp"
]]
function qts.add_player_hp(player, hp, reason)
	qts.set_player_hp(player, qts.get_player_data(player, "COMBATSYSTEM", "HP")+hp, reason or "set_hp")
end

--[[
	Set the player's HP

	Params:
		player - the player
		hp - the change in health
		reason - if negative, then the reason for the HP change. defaults to "set_hp"
]]
function qts.set_player_hp(player, hp, reason)
	if IS_DAMAGE_ENABLED then
		local oldhp = qts.get_player_data(player, "COMBATSYSTEM", "HP")
		local hpchange = hp - oldhp
		if not reason then reason = "set_hp" end

		for i, func in ipairs(registered_hpchanges_mod) do
			hpchange = func(player, hpchange, reason)
		end
		

		local newhp = clamp_player_hp(player, oldhp + hpchange)
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
	damage_profile_start()
	if IS_DAMAGE_ENABLED then
		qts.set_player_hp(player, qts.get_player_hp(player)-qts.calculate_damage(player, hitter, time_from_last_punch, tool_capabilities, dir), "punch")
	end
	damage_profile_stop()
	return true
end)

old_register_on_player_hpchange(function(player, hp_change, reason)
	damage_profile_start()
	if IS_DAMAGE_ENABLED then
		--minetest.log("Starting default HP change override. Value: " .. dump(hp_change) .. " Reason: " .. dump(reason))
		local unsafe_reasons = {fall=true, node_damage=true,drown=true}
		local internal_hp_change = 0
		if unsafe_reasons[reason.type] then
			--these need armor applied
			--minetest.log("unsafe")
			if hp_change < 0 then
				--this function expects damage to be positive, but here, damage is negative.
				internal_hp_change = -qts.apply_armor_to_damage(player, -hp_change, "enviromental")
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
			damage_profile_stop()
			return hp_change
		end
		--minetest.log("HP CHANGE post funcs: " .. dump(internal_hp_change))
		local player_hp_current = qts.get_player_data(player, "COMBATSYSTEM", "HP")
		--minetest.log("CURRENT: " .. dump(player_hp_current))
		player_hp_current = clamp_player_hp(player, player_hp_current + internal_hp_change)
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
		damage_profile_stop()
		return external_hp_change
	else
		damage_profile_stop()
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
	qts.set_player_data(player, "COMBATSYSTEM", "HP", qts.DEFAULT_HP.get())
	qts.set_player_data(player, "COMBATSYSTEM", "HP_MAX", qts.DEFAULT_HP.get())
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
			qts.update_player_modifiers(player)
			player:hud_set_flags({healthbar=false}) --make default health bar invisible
		end
	end, player:get_player_name())
	
	if qts.get_player_data(player,"COMBATSYSTEM", "HP") == nil then
		qts.set_player_data(player, "COMBATSYSTEM", "HP", qts.DEFAULT_HP.get())
		qts.set_player_data(player, "COMBATSYSTEM", "HP_MAX", qts.DEFAULT_HP.get())
	end
end)


--clean player data that should not be saved
local function clean_player_data(playername)
	if qts.player_data[playername] then
		for _, v in ipairs({"MODIFIERS"}) do	
			qts.player_data[playername][v] = nil
		end
	end
end

--save player data
local function save_player_data(playername, nullify)
	clean_player_data(playername)
	minetest.log("Saving custom data for ".. playername)
	local file = qts.create_settings_clojure(playerDataPath.."/"..playername..".conf")
	file.set_str("datatable", minetest.serialize(qts.player_data[playername]))
	file.save()
	if nullify or nullify == nil then
		qts.player_data[playername] = nil
	end
end

minetest.register_on_leaveplayer(function(player, timed_out)
	local name = player:get_player_name()
	save_player_data(name)
end)

minetest.register_on_shutdown(function()
	--any remaining players should have their data saved
	for playername, data in pairs(qts.player_data) do
		save_player_data(playername, false)
	end

	qts.world_settings.set_bool("QT_DEV_WORLD", qts.ISDEV)
    qts.world_settings.save()
	qts.settings.save()
	minetest.log("QTS shutdown finished")
end)


--[[
	Damage Effects
]]

local DAMAGE_VIGNETTE_COLOR = qts.config("DAMAGE_VIGNETTE_COLOR", "#FF0000", "Color of the screen flash vignette when taking damage.")
local DAMAGE_VIGNETTE_TIME = qts.config("DAMAGE_VIGNETTE_TIME", 0.2, "Duration of the screen flash vignette when taking damage.")

---player HP loss screen flash and other effects
---@param player Player
---@param hpchange number
---@param reason any
minetest.register_on_player_hpchange(function (player, hpchange, reason) 
	if hpchange < 0 then
		local playername = player:get_player_name()
		
		--add the HUD vignette
		local screenflash_id = player:hud_add({
			hud_elem_type="image",
			z_index = -400, --vignette
			text = "vignette.png^[multiply:"..DAMAGE_VIGNETTE_COLOR.get(),
			position = {x=0.5,y=0.5},
			alignment = {x=0,y=0},
			scale = {x=-100,y=-100}, --negative scale values are percentage of screen
			name="QTS_damageVignette",
			direction=1,
			offset={x=0,y=0},
		})
		
		--remove the vignette a bit later
		local job = minetest.after(DAMAGE_VIGNETTE_TIME.get(), function()
			local player = minetest.get_player_by_name(playername)
			player:hud_remove(screenflash_id)
		end)
		
		--play sound effect
		minetest.sound_play("player_hit", {gain = 0.5, to_player = playername}, true)

	end
end, false)
