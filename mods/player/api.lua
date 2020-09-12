--[[
API for the player mod

Much of this code, namely, the model stuff, is from the player_api mod from minetest_game
it has been modified to work well with QuestTest and qts

]]

--[[GLOBALS]]
Player_API.registered_models = {}
Player_API.doubleclick_funcs = {}
Player_API.special_key_funcs = {}
Player_API.player_data = {}


--[[LOCAL SETUP]]
local animation_blend = 0

--setup locals that are used solely for speed of access
local models = Player_API.registered_models
local FDoubleClick = Player_API.doubleclick_funcs
local FSpecialClick = Player_API.special_key_funcs
local player_data = Player_API.player_data
local player_set_animation = Player_API.set_animation
local player_attached = Player_API.player_attached

--[[FUNCTIONS]]

--TODO: change some values here
function Player_API.new_player(player)
	qts.set_player_modifier(player, "CONTROL_INTERNAL", {}) --empty list, just making a default one exist
	local name = player:get_player_name()
	player_data[name] = {
		model = nil,
		texture = nil,
		anim = nil,
		controlTimer = {
			jump = -1,
			right = -1,
			left = -1,
			LMB = -1,
			RMB = -1,
			sneak = -1,
			aux1 = -1,
			down = -1,
			up = -1,
		},
		sprint = false,
		sneak = false,
		attached = false,
		sprint_speed = Player_API.SPRINT_MULT,
	}
end


--[[
def = {
	animation_speed = 30,
	textures = {"texturename.png"},
	animations = {
		name = {x = start, y = end},
		anoter = {x = start, y = end},
		...
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6 --just over half a block
	eye_height = 1.47
}

animations contains:
	stand
	lay
	walk
	punch
	walk_punch
	sit
	sneak
	sneak_walk
	sneak_punch
	sneak_walk_punch
	
	--for a custom punch for specific items ...
	custom_punch 
	--and maybe
	walk_custom_punch
	shift_custom_punch
	shift_walk_custom_punch
]]
function Player_API.register_model(name, def)
	models[name] = def
end

function Player_API.get_animation(player)
	local name = player:get_player_name()
	return {
		model = player_data[name].model,
		textures = player_data[name].texture,
		animation = player_data[name].anim,
	}
end

function Player_API.set_model(player, model_name)
	local name = player:get_player_name()
	local model = models[model_name]
	if model then
		if player_data[name].model == model_name then
			return
		end
		player:set_properties({
			mesh = model_name,
			textures = player_data[name].texture or model.textures,
			visual = "mesh",
			visual_size = model.visual_size or {x = 1, y = 1},
			collisionbox = model.collisionbox or {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			stepheight = model.stepheight or 0.6,
			eye_height = model.eye_height or 1.47,
		})
		Player_API.set_animation(player, "stand")
	else
		player:set_properties({
			textures = {"player.png", "player_back.png"},
			visual = "upright_sprite",
			visual_size = {x = 1, y = 2},
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.75, 0.3},
			stepheight = 0.6,
			eye_height = 1.625,
		})
	end
	player_data[name].model = model_name
end

function Player_API.set_textures(player, textures)
	local name = player:get_player_name()
	local model = models[player_data[name].model]
	local model_textures = model and model.textures or nil
	player_data[name].texture = textures or model_textures
	player:set_properties({textures = textures or model_textures,})
end

function Player_API.set_animation(player, anim_name, speed)
	local name = player:get_player_name()
	if player_data[name].anim == anim_name then
		return
	end
	local model = player_data[name].model and models[player_data[name].model]
	if not (model and model.animations[anim_name]) then
		return
	end
	local anim = model.animations[anim_name]
	player_data[name].anim = anim_name
	player:set_animation(anim, speed or model.animation_speed, animation_blend)
end

function Player_API.sprint(player, on)
	local dat = player_data[player:get_player_name()]
	if dat.sneak and on then
		return
	end
	if on and dat.sprint == false then
		local mods = qts.get_player_modifier(player, "CONTROL_INTERNAL")
		--Player_API.SPRINT_INCREASE
		if not mods then
			qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = Player_API.SPRINT_MULT})
			dat.sprint = true
			return
		end
		mods.speed = mods.speed + Player_API.SPRINT_INCREASE
		if mods.speed > dat.sprint_speed then
			qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = Player_API.SPRINT_MULT})
			dat.sprint = true
		else
			qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = mods.speed})
		end
	elseif on == false and dat.sprint then
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = 1})
		dat.sprint = false
		
	end
end

function Player_API.sneak(player, on)
	local dat = player_data[player:get_player_name()]
	if dat.sprint then
		dat.sprint = false
	end
	if on and dat.sneak == false then
		player:set_eye_offset({x=0,y=-0.75,z=0}, {x=0,y=0,z=0})
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = Player_API.SNEAK_MULT})
		dat.sneak = true
	elseif on == false and dat.sneak then
		player:set_eye_offset({x=0,y=0,z=0}, {x=0,y=0,z=0})
		qts.set_player_modifier(player, "CONTROL_INTERNAL", {speed = 1})
		dat.sneak = false
	end
end

function Player_API.dodge(player, dir)
	if dir == nil then return end
	if dir == "left" then dir = {x=-1, y=0.1, z=0}
	elseif dir == "right" then dir = {x=1, y=0.1, z=0}
	elseif dir == "up" then dir = {x=0, y=0.1, z=1}
	elseif dir == "down" then dir = {x=0, y=0.1, z=-1} 
	end
	local angle = player:get_look_horizontal()
	player:add_player_velocity(vector.multiply(vector.rotate_yaw(dir, angle), 10))
end

--register a function to be called when a key is double clicked 
--params are: (player, key)
function Player_API.register_on_doubleclick(func)
	Player_API.doubleclick_funcs[#Player_API.doubleclick_funcs + 1] = func
end

--registers a function to to be called when the aux1 key (E by default) is pressed
--params are (player, isClicked, newEvent)
function Player_API.register_on_special_key(func)
	Player_API.special_key_funcs[#Player_API.special_key_funcs + 1] = func
end


--[[MINETEST GLOBAL FUNCTIONS]]

--clear the data for a particular player when they leave
minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_model[name] = nil
end)

--[[
----locals---- 
local models = Player_API.registered_models
local FDoubleClick = Player_API.doubleclick_funcs
local FSpecialClick = Player_API.special_key_funcs
local player_data = Player_API.player_data
local player_set_animation = Player_API.set_animation
local player_attached = Player_API.player_attached
]]

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local ctrl = player:get_player_control() --current boolean control state
		local pdat = player_data[name] --the player data
		local switched = {} --the prev time of ONLY the switched controls
		
		--first, collect the changes in the controls, and update the timers
		for control, val in pairs(ctrl) do
			local prev = pdat.controlTimer[control]
			if prev then
				if val then 
					if prev > 0 then
						pdat.controlTimer[control] = prev + dtime
					else
						pdat.controlTimer[control] = dtime
						switched[control] = prev
					end
				else
					if prev < 0 then
						pdat.controlTimer[control] = prev - dtime
					else
						pdat.controlTimer[control] = -dtime
						switched[control] = prev
					end
				end
			end
		end
		
		--now, scan for double clicks and call the double click functions
		for control, prev in pairs(switched) do
			if math.abs(prev) <= Player_API.DOUBLECLICK_TIME and ctrl[control] then
				--doubleclick found. run funcs
				for i, func in ipairs(FDoubleClick) do
					func(player, control)
				end
			end
		end
		
		--cancel sprinting if the forward key is not pressed, or the player is not moving enough
		local vel = vector.length(player:get_player_velocity())
		if (not ctrl.up) or (vel < Player_API.SPRINT_MIN_SPEED) then
			Player_API.sprint(player, false)
		end
		
		--block dodging when sneaking or when not moving forward
		if switched.sneak or switched.up then
			if ctrl.sneak or not ctrl.up then
				pdat.can_dodge = false
			else
				pdat.can_dodge = true
			end
		end
		
		--sneak controls
		if switched.sneak then
			Player_API.sneak(player, ctrl.sneak)
		end
		
		if ctrl.aux1 then
			--minetest.settings:set_bool("fast_move", false) --to fix that STUPID BUILTIN STUFF!!!!!!!!!
			local newEvent = false
			if switched.aux1 ~= nil then
				newEvent = true
			end
			for i, func in ipairs(FSpecialClick) do
				func(player, true, newEvent)
			end
		end
		if switched.aux1 and not ctrl.aux1 then
			for i, func in ipairs(FSpecialClick) do
				func(player, false, true)
			end
		end
		
		--sprint 3
		--if Player_API.SPRINT_MODE == 3 then
		if ctrl.up and pdat.controlTimer.up > 3 then
			Player_API.sprint(player, true)
		end
		--end
		
		--Animation stuff
		local model_name = pdat.model
		local model = model_name and models[model_name]
		if model and not pdat.attached then
			--there is a valid model to work with
			--setup the data
			local walking = ctrl.up or ctrl.down or ctrl.left or ctrl.right
			local anim_speed_mod = model.animation_speed or 30
			if ctrl.sneak then
				anim_speed_mod = anim_speed_mod / 2
			end
			
			--apply data
			--TODO: add sneak anims
			if player:get_hp() == 0 then
				Player_API.set_animation(player, "lay")
			elseif walking then
				if ctrl.LMB then
					Player_API.set_animation(player, "walk_mine", anim_speed_mod)
				else
					Player_API.set_animation(player, "walk", anim_speed_mod)
				end
			elseif ctrl.LMB then
				Player_API.set_animation(player, "mine")
			else
				Player_API.set_animation(player, "stand", anim_speed_mod)
			end
		end
		
	end
end)




--[[MINETEST FUNCTION OVERRIDES]]
local old_calculate_knockback = minetest.calculate_knockback
function minetest.calculate_knockback(player, ...)
	if player_data[player:get_player_name()].attached then
		return 0
	end
	return old_calculate_knockback(player, ...)
end