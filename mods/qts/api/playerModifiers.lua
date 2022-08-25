--[[
	Player Modifer System

	This allows various entries to modify player attributes, like speed, sprint power, etc.
	without the possibility of them muddling each other up (unless you tried really, really hard)

	it maintains an unordered list of modifiers, (as order does not matter). A Modifier is a table with text keys and number or boolean values
	Numbers are combined via multiplication, booleans are combined via OR. If the numeric key starts with `ADD` then addition will be used, and if a 
	boolean key starts with `AND` then AND will be used.
	All the modifers in the list are combined to get the final result
	This is the job of `qts.update_player_modifiers(player)`

	Modifiers can be added by qts.add_player_modifier(player, modifier [handle], [set])
	This function returns a handle to that specific modifier, needed to acces it later

	SPECIAL KEYS
	speed 							= player speed
	jump 							= player jump height
	gravity 						= player gravity scale
	sprint_multiplier 				= how much sprint changes the player speed
	sprint_multiplier_liquid 		= how much sprint changes the player speed in water
	sprint_multiplier_climbable 	= how much the sprint speed changes player speed in climbables (like leaves)
	sneak_multiplier 				= how much sneaking changes the player speed
	detection_range					= effects how far away mobs will detect the player, as a fraction of their full distance 
	detection_range_sneak			= effects how far away mobs will detect the player when the player is sneaking, as a fraction of their full distance
	ADD_extra_equpment_slots		= number of extra equipment slots
	ADD_damgae_bonus_fleshy			= damage bonus to what the player deals when fleshy
	ADD_damage_bonus_stabby			= damage bonus to what the player deals when stabby
	ADD_damage_bonus_psycic			= damage bonus to what the player deals when psycic
	ADD_damage_bonus_<group>		= damage bonus for your custom <group> of damage NOT returned in the qts.get_player_bonus_damages() function
	ADD_health_bonus				= bonus to player health

	All these keys have special getter functions for utility, more can be added and gotten via:
	`qts.get_player_data(player, "MODIFIERS", "<key name here>")`


	playerRef:set_physics_override(overrides) is considered bad form
	in QuestTest, due to the high chance of manny different ones muddling each other up
	Thus, individual modifiers are added to a list, and then the overrides are passed through and set internally
]]

--local for faster speed
local player_modifer_lists = {}

local handle_counter = Counter()

--[[
update the player modifiers effect on the player
]]
function qts.update_player_modifiers(player)
	local name = player:get_player_name()
	local mods = player_modifer_lists[name]
	if not mods then return end
	local sum_mods = {
		speed = 1,
		jump = 1,
		gravity = 1,
		sprint_multiplier=2.5,
		sprint_multiplier_liquid = 1,
		sprint_multiplier_climbable = 1,
		sneak_multiplier = 0.75,
		detection_range=1,
		detection_range_sneak = 0.75,
		ADD_extra_equpment_slots = 0,
		ADD_damgae_bonus_fleshy = 0,
		ADD_damage_bonus_stabby = 0,
		ADD_damage_bonus_psycic = 0,
		ADD_health_bonus = 0,

	}
	--this is UNORDERED
	for id, mod in pairs(mods) do
		for k, v in pairs(mod) do
			if type(k)=="string" then
				if sum_mods[k] then
					if type(sum_mods[k]) == type(v)	then
						if type(v) == "number" then
							if string.sub(k,1,3) == "ADD" then
								sum_mods[k] = sum_mods[k] + v
							else
								sum_mods[k] = sum_mods[k] * v
							end
						elseif type(v) == "boolean" then
							if string.sub(k,1,3) == "AND" then
								sum_mods[k] = sum_mods[k] and v
							else
								sum_mods[k] = sum_mods[k] or v
							end
						end
					end			
				else
					sum_mods[k] = v
				end
			end
		end
	end
	--the modifiers are combined
	player:set_physics_override({
		speed = sum_mods.speed,
		jump = sum_mods.jump,
		gravity = sum_mods.gravity,
		sneak = true,
		sneak_glitch = true,
		new_move = true
	})
	--minetest.log("MODIFIERS: " .. dump(sum_mods))
	--these are not set to player data
	sum_mods.speed=nil
	sum_mods.jump=nil
	sum_mods.gravity=nil
	--store these in player data
	qts.set_player_data(player, "MODIFIERS", sum_mods)
end

--[[
	Add a set of player modifiers to the list.  
	Returns a handle to reference them later.
	optionally, pass a handle as a value
	optionally, pass a boolean for if the final value should be set. 
	If the 3rd param is a bool and the fourth is nil, the third is this set value.
	if set is nil, then it is assumed true
]]
function qts.add_player_modifier(player, modifer_table, handle, set)
	local name = player:get_player_name()
	local mods = player_modifer_lists[name]
	if not mods then
		player_modifer_lists[name] = {}
		mods = player_modifer_lists[name]
	end
	if set == nil and type(handle) == "boolean" then
		set = handle
		handle = nil	
	end
	if handle ~= nil then
		if ({"nil", "table", "function", "thread", "userdata", "boolean"})[type(handle)] then
			error("Bad handle passed. Should not be one of: {nil, table, function, thread, userdata, boolean}")
		end
		if mods[handle] then
			minetest.log("warning", "Player Modifer System: Overriding an existing modifer handle. Better to use qts.override_player_modifer")
		end
	else
		--no handle supplied, generate a unique one
		handle = "PLAYER_MODIFIER_HANDLE::" .. tostring(handle_counter())
	end

	if type(modifer_table) ~= "table"  then
		error("cannot set a modifier table that is not a table!")
	end

	mods[handle] = modifer_table

	--update modifiers
	if set or set==nil then
		qts.update_player_modifiers(player)
	end
	return handle
end

--[[
	Overrides an existing player modifer.  
	returns true/false for sucess.  
	does not ever add a new modifier if handle is not valid.  
]]
function qts.override_player_modifer(player, handle, modifer_table, set)
	local name = player:get_player_name()
	local mods = player_modifer_lists[name]
	if not mods then
		return false --no modifiers for this player
	end
	if mods[handle] then
		if type(modifer_table) ~= "table" and type(modifer_table) ~= "nil" then
			error("cannot set a modifier table that is not a table!")
		end
		mods[handle] = modifer_table

		if set or set == nil then
			qts.update_player_modifiers(player)
		end
		return true
	else
		return false
	end
end

--[[
	Get the player modifer table at this handle.  
	WARNING: this is a volatile reference, meaning, you can change it,  
	and it will not come into effect untill something calls qts.update_player_modifiers()  
]]
function qts.get_player_modifier(player, handle)
	local name = player:get_player_name()
	local mods = player_modifer_lists[name]
	if not mods then
		return false --no modifiers for this player
	end
	if mods[handle] then
		return mods[handle]
	else
		return nil
	end
end

--[[
	Remove a modifier from the player by handle  
	returns true or false for sucess.  
]]
function qts.remove_player_modifier(player, handle, set)
	local name = player:get_player_name()
	local mods = player_modifer_lists[name]
	if not mods then
		return false --no modifiers for this player
	end
	if mods[handle] then
		mods[handle] = nil
		if set or set == nil then
			qts.update_player_modifiers(player)
		end
		return true
	else
		return false
	end
	
end

--[[
	Get the player's sprint mulplipliers
]]
function qts.get_player_sprint_multipliers(player)
	return {
		normal = qts.get_player_data(player, "MODIFIERS", "sprint_multiplier"),
		liquid = qts.get_player_data(player, "MODIFIERS", "sprint_multiplier_liquid"),
		climbable = qts.get_player_data(player, "MODIFIERS", "sprint_multiplier_climbable"),
	}
end
--[[
	Get the player's sneak speed multipliers
]]
function qts.get_player_sneak_multiplier(player)
	return qts.get_player_data(player, "MODIFIERS", "sneak_multiplier")
end

--[[
	get the player's mob detection range multipliers
]]
function qts.get_playe_detection_rage_multiplier(player)
	return {
		normal = qts.get_player_data(player, "MODIFIERS", "detection_range"),
		sneak = qts.get_player_data(player, "MODIFIERS", "detection_range_sneak"),
	}
end

--[[
	get the player's number of bonus equipment slots
]]
function qts.get_player_bonus_equipment_slots(player)
	return qts.get_player_data(player, "MODIFIERS", "ADD_extra_equpment_slots")
end

--[[
	Get the player's bonus damage ammounts
]]
function qts.get_player_bonus_damages(player)
	return {
		fleshy = qts.get_player_data(player, "MODIFIERS", "ADD_damgae_bonus_fleshy"),
		stabby = qts.get_player_data(player, "MODIFIERS", "ADD_damgae_bonus_stabby"),
		psycic = qts.get_player_data(player, "MODIFIERS", "ADD_damgae_bonus_psycic"),
	}
end


--[[
function qts.update_player_modifiers(player)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	local name = player:get_player_name()
	
	local mods = qts.player_modifer_lists[name]
	if mods then
		local speed = 1
		local jump = 1
		local gravity = 1
		for id, mod in pairs(mods) do
			speed = speed * mod.speed
			jump = jump * mod.jump
			gravity = gravity * mod.gravity
		end
		player:set_physics_override({
			speed = speed,
			jump = jump,
			gravity = gravity,
			sneak = true,
			sneak_glitch = true,
			new_move = true
		})
	end
end


function qts.set_player_modifier(player, id, modifiers, do_not_set)
	error("is this running?")
	if do_not_set == nil then do_not_set = false end
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	local name = player:get_player_name()
	if not qts.player_modifer_lists[name] then
		qts.player_modifer_lists[name] = {}
	end
	
	qts.player_modifer_lists[name][id] = {
		speed = modifiers.speed or 1.0,
		jump = modifiers.jump or 1.0,
		gravity = modifiers.gravity or 1.0,
	}
	if not do_not_set then
		--apply the modifier stack
		qts.update_player_modifiers(player)
	end
end

function qts.get_player_modifier(player, id)
	if type(player) ~= "string" then
		player = player:get_player_name()
	end
	if qts.player_modifer_lists[player] and qts.player_modifer_lists[player][id] then
		local mod = qts.player_modifer_lists[player][id]
		return{ --copy these three values ONLY
			speed = mod.speed,
			jump = mod.jump,
			gravity = mod.gravity
		}
	else
		minetest.log("PlayerEffects Info Unavalable")
		return nil
	end
end
--]]
