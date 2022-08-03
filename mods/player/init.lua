--[[
QuestTest Player Mod

Player visuals and controls
]]
Player_API = {}
dofile(minetest.get_modpath("player").."/api.lua")

--minetest.settings:set_bool("fast_move", false)
minetest.settings:set_bool("aux1_decends", false)
minetest.settings:set_bool("always_fly_fast", true)

Player_API.SPRINT_MODE = 1
Player_API.SPRINT_INCREASE = 0.01
Player_API.SPRINT_MULT = 2.5
Player_API.SNEAK_MULT = 0.75
Player_API.DOUBLECLICK_TIME = 0.50
Player_API.SPRINT_MIN_SPEED = 0.75

--"player_armor.png"
Player_API.register_model("character.x", {
	animation_speed = 30,
	textures = {qts.make_humanoid_texture("player_base.png", nil, nil, nil, nil)},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160},
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.47,
})

minetest.register_on_joinplayer(function(player)
	Player_API.new_player(player)
	Player_API.set_model(player, "character.x")
	Player_API.set_animation(player, "stand", 30)
end)

Player_API.register_on_doubleclick(function(player, control)
	local dat = Player_API.player_data[player:get_player_name()]
	if control == "right" and dat.can_dodge then
		Player_API.dodge(player, "right")
	elseif control == "left" and dat.can_dodge then
		Player_API.dodge(player, "left")
	--else
	--	minetest.log("Double Click: " .. dump(control))
	end
end)

---[[
Player_API.register_on_special_key(function(player, isClicked, newEvent)
	if newEvent then
		minetest.log("SPECIAL")
	end
end)
--]]


--[[DEBUG STUFF]]
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
			Player_API.SPRINT_MODE = 1
		elseif param == '2' then
			Player_API.SPRINT_MODE = 2
 		else
			Player_API.SPRINT_MODE = 3
		end
	end
})

