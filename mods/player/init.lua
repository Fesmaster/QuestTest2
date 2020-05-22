--[[
QuestTest Player Mod

Player visuals and controls
]]
minetest.settings:set_bool("fast_move", false)
minetest.settings:set_bool("aux1_decends", false)
minetest.settings:set_bool("always_fly_fast", false)

SPRINT_MODE = 1
SPRINT_MULT = 2.5
SNEAK_MULT = 0.75
DOUBLECLICK_TIME = 0.50

PlayerControls = {}

minetest.register_on_joinplayer(function(player)
	PlayerControls[player:get_player_name()] = {
		jump = -1,
		right = -1,
		left = -1,
		LMB = -1,
		RMB = -1,
		sneak = -1,
		aux1 = -1,
		down = -1,
		up = -1,
		sprint = false,
		can_dodge = true,
	}
	 qts.set_player_modifier(player, "CONTROL_INTERNAL", {}) --empty list, just making a default one exist
end)

local function rotateVectorYaw(vec, angle)
	return {x = (vec.x * math.cos(angle) - vec.z * math.sin(angle)), y = vec.y, z = (vec.x * math.sin(angle) + vec.z * math.cos(angle))}
end

local function sprint(player, on)
	if PlayerControls[player:get_player_name()].sneak > 0 and on then
		minetest.log("Cannot sprint while sneaking!")
		return
	end
	if on and PlayerControls[player:get_player_name()].sprint == false then
		minetest.log("Sprint ON")
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = SPRINT_MULT})
		PlayerControls[player:get_player_name()].sprint = true
	elseif on == false and PlayerControls[player:get_player_name()].sprint then
		minetest.log("Sprint OFF")
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = 1})
		PlayerControls[player:get_player_name()].sprint = false
	end
end

local function sneak(player, on)
	--sprint(player, false)
	if PlayerControls[player:get_player_name()].sprint then
		minetest.log("Sprint disabled by sneak")
		PlayerControls[player:get_player_name()].sprint = false
	end
	if on then
		player:set_eye_offset({x=0,y=-0.75,z=0}, {x=0,y=0,z=0})
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = SNEAK_MULT})
	else
		player:set_eye_offset({x=0,y=0,z=0}, {x=0,y=0,z=0})
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = 1})
	end
end

local function doubleclick_func(clicker, control) --can_dodge
	if control == "right" and PlayerControls[clicker:get_player_name()].can_dodge then
		local angle = clicker:get_look_horizontal()
		local dir = {x=1, y=0.1, z= 0}
		clicker:add_player_velocity(vector.multiply(rotateVectorYaw(dir, angle), 10))
		minetest.log("Doged Right!")
	elseif control == "left" and PlayerControls[clicker:get_player_name()].can_dodge then
		local angle = clicker:get_look_horizontal()
		local dir = {x=-1, y=0.1, z= 0}
		clicker:add_player_velocity(vector.multiply(rotateVectorYaw(dir, angle), 10))
		minetest.log("Doged Left!")
	elseif control  == "up" and SPRINT_MODE == 1 then
		sprint(clicker, true)
	else
		minetest.log("Double Click: " .. dump(control))
	end
	
end



minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		--update the control counters
		local ctrl = player:get_player_control()
		local ctrlCount = PlayerControls[player:get_player_name()]
		local switched = {}
		local prevCtrlCount = {}
		--collect the controls
		for control, val in pairs(ctrl) do
			prevCtrlCount[control] = ctrlCount[control]
			if val then
				if ctrlCount[control] > 0 then
					ctrlCount[control] = ctrlCount[control] + dtime
				else
					ctrlCount[control] = dtime
					--minetest.log("SWTITCH ON: "..dump(control) .. " | " .. dump(prevCtrlCount[control]))
					switched[control] = true
				end
			else
				if ctrlCount[control] < 0 then
					ctrlCount[control] = ctrlCount[control] - dtime
				else
					ctrlCount[control] = -dtime
					--minetest.log("SWTITCH OFF: "..dump(control) .. " | " .. dump(prevCtrlCount[control]))
					switched[control] = true
				end
			end
		end
		
		--process doubleclicks
		for control, _ in pairs(switched) do
			if math.abs(prevCtrlCount[control]) <= DOUBLECLICK_TIME and ctrl[control] then
				 doubleclick_func(player, control)
			end
		end
		
		--stop sprinting if not holding forward key
		if not ctrl.up then
			sprint(player, false)
		end
		--stop sprinting if vel ~ 0
		local vel = vector.length(player:get_player_velocity())
		if vel < 0.5 then
			--minetest.log("sprint off from low vel")
			sprint(player, false)
		end
		
		--can or cannot dodge
		if ctrl.sneak or not ctrl.up then
			ctrlCount.can_dodge = false
		else
			ctrlCount.can_dodge = true
		end
		--sneak controls
		if switched.sneak then
			sneak(player, ctrl.sneak)
		end
		
		--sprint 2:
		if switched.aux1 and SPRINT_MODE == 2 then
			minetest.settings:set_bool("fast_move", false)
			sprint(player, ctrl.aux1)
		end
		
		--sprint 3
		if SPRINT_MODE == 3 then
			if ctrl.up and ctrlCount.up > 3 then
				sprint(player, true)
			end
		end
		
	end
end)

minetest.register_chatcommand("phys", {
	params = "<text>",
	description = "Log your physics overrdie",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local phys = player:get_physics_override()
		minetest.log(dump(phys))
	end
})

minetest.register_chatcommand("sprintmode", {
	params = "<number>",
	description = "Change sprint mode",
	func = function(name, param)
		minetest.log(dump(param))
		if param == '1' then
			SPRINT_MODE = 1
		elseif param == '2' then
			SPRINT_MODE = 2
 		else
			SPRINT_MODE = 3
		end
	end
})

