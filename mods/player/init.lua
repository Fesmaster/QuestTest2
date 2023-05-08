--[[
QuestTest Player Mod

Player visuals and controls
]]
Player_API = {}
dofile(minetest.get_modpath("player").."/api.lua")

--minetest.settings:set_bool("fast_move", false)
minetest.settings:set_bool("aux1_decends", false)
minetest.settings:set_bool("always_fly_fast", true)

Player_API.SPRINT_INCREASE = qts.config("SPRINT_INCREASE", 0.01, "ammount of speed you gain each frame when starting to sprint")
Player_API.DOUBLECLICK_TIME = qts.config("DOUBLECLICK_TIME", 0.50, "max ammount of time between clicks to make it count as a double click")
Player_API.SPRINT_MIN_SPEED = qts.config("SPRINT_MIN_SPEED",0.75,"blocks per second you must be moving at to start sprinting")
--these two were moved to player modifier system
--Player_API.SPRINT_MULT = 2.5
--Player_API.SNEAK_MULT = 0.75

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
---Special function to rotate the inventory in devmode
---@param player Player
---@param isClicked boolean
---@param newEvent boolean
Player_API.register_on_special_key(function(player, isClicked, newEvent)
	if newEvent and isClicked and qts.ISDEV then
		--minetest.log("SPECIAL")
		--rotate the inventory

		local inv = player:get_inventory()
		if inv == nil then return end
		local mainlist = inv:get_list("main")
		local newlist = {}
		local list_width = 10
		local fullList = #mainlist --40
		for i=0,#mainlist do
			local newindex = i - list_width
			if newindex < 1 then
				newindex = newindex + fullList
			end
			newlist[newindex] = mainlist[i]
		end

		inv:set_list("main", newlist)
	end
end)
--]]


--[[DEBUG STUFF]]
if qts.ISDEV then
minetest.register_chatcommand("phys", {
	params = "<text>",
	description = "Log your physics overrdie",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local phys = player:get_physics_override()
		minetest.log("Physics Override for player: [" .. name .. "] : " .. dump(phys))
	end
})
end
