
minetest.register_node("dtools:test_node", {
	description = "Testing Node",
	tiles ={"default.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
})


minetest.register_node("dtools:blue_node", {
	description = "Blue Node",
	tiles ={"dtools_blue.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
	on_projectile_strike = function(projectile, pointed_thing)
		if (pointed_thing.above) then
			minetest.set_node(pointed_thing.above, {name = "dtools:blue_node"})
		end
	end
})

minetest.register_entity("dtools:static_entity", {
	initial_properties = {
		--
		hp_max = 1,
		physical = true,
		weight = 1,
		collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		visual = "wielditem",
		visual_size = {x=.7, y=.7, z=.7},
		textures = {"dtools:blue_node"},
		colors = {},
		is_visible = true,
		makes_footsteps_sounds = false,
		
	},
	
	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({fleshy = 0})
	end,
	
	on_step = function(self, dtime)
		local vel = self.object:get_velocity()
		if (vector.length(vel) < 0.25) then
			self.object:set_velocity({x=0, y=0, z=0})
			self.object:set_acceleration({x=0, y=0, z=0})
		else
			self.object:set_acceleration(vector.multiply(vel, -2))
		end
	end,
	
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		--self.object:remove()
		local origin = puncher:get_pos()
		origin.y = origin.y + 1 --bring it up
		local final = self.object:get_pos()
		if (not vector.equals(origin, final)) then
			local dir = vector.direction(origin, final)
			self.object:add_velocity(vector.multiply(dir, 10))
		end
		
		minetest.log("Punched by ".. qts.ObjectName(puncher) .. "with damage " .. dump(tool_capabilities))
	end,
	
	on_rightclick = function(self, clicker)
		if (clicker:is_player()) then
			minetest.log( "CLicked by player: " .. dump(clicker:get_player_name()))
			self.object:remove()
		end
	end,
	
	get_staticdata = function(self)
		return ""
	end,
	
})

--[[
properties of def for register_projectile

radius = radius of projectile
selectable = boolean can player select

--from regular entities
visual
visual_size
textures
use_texture_alpha
spritediv
initial_sprite_basepos
backface_culling
glow
automatic_rotate
automatic_face_movement_dir
automatic_face_movement_max_rotation_per_sec

gravity_scale = number - scale of the gravity. default: 1
collectable = itemstring given to player when walked over an inactive one
lifetime = how long (seconds) the projectile should live
speed = number - how fast the projectile goes

damage_groups = {damagetype = value}
--]]
qts.register_projectile("dtools:testing_projectile", {
	radius = 0.1,
	selectable = false,
	visual = "wielditem",
	visual_size = {x=0.2, y=0.2, z=0.2},
	textures = {"dtools:blue_node"},
	automatic_face_movement_dir = true,
	gravity_scale = 1,
	collectable = "dtools:blue_node",
	lifetime = 240,
	speed = 30,
	damage_groups = {fleshy = 5},
	--[[
	on_timeout = function(self)
		qts.explode(self.object:get_pos(), 10, {
				destroy_nodes = false,
				make_drops = false,
				drop_speed_multiplier = 1,
				make_sound = true,
				make_particles = true,
				particle_multiplier = 1,
				damage_entities = true,
				push_entities = true,
				damage_player = true,
				damage_type = "fleshy",
				exploder = self.launcher
			})
		
		self.object:remove()
	end,
	--]]
})

function dtools.player_launch_projectile(player, projectile)
	local pos = player:get_pos()
	if (player:is_player()) then
		pos = vector.add(pos, {x=0, y=1.5, z=0})
		local dir = player:get_look_dir()
		pos = vector.add(pos, dir)
		local obj = minetest.add_entity(pos, projectile)
		if obj:get_luaentity().launch ~= nil then
			obj:get_luaentity():launch(dir, player)
			minetest.log("Projectile launch called")
		else
			minetest.log("Error launching projectile")
		end
	end
end


minetest.register_node("dtools:ecd_inactive", {
	description = "Entity Collision Detection Node - Inactive",
	tiles ={"dtools_detector_blue.png"},
	drawtype = "glasslike",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	on_projectile_enter = function(projectile, pos) 
		minetest.set_node(pos, {name = "dtools:ecd_active"})
	end,
})

minetest.register_node("dtools:ecd_active", {
	description = "Entity Collision Detection Node - Active",
	tiles ={"dtools_detector_red.png"},
	drawtype = "glasslike",
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
	walkable = false,
	sunlight_propagates = true,
	paramtype = "light",
	on_projectile_exit = function(projectile, pos) 
		minetest.set_node(pos, {name = "dtools:ecd_inactive"})
	end,
})