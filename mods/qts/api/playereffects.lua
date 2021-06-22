--[[
	PlayerEffects is a system to add effects to a player
	It also is responsible for physics overrides for players
	
	playerRef:set_physics_override(overrides) is considered bad form
	in QuestTest, due to the high chance of manny different ones muddling each other up
	Thus, individual modifiers are added to a list, and then the overrides are passed through and set internally
]]

qts.player_modifer_lists = {}


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

--[[
Adds or changed a modifier slot to the player. 
]]
function qts.set_player_modifier(player, id, modifiers, do_not_set)
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
