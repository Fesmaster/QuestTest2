--[[
Projectile code for shooty things
]]

qts.registered_projectiles = {}

--[[
	Register a new projectile

	Params: 
		name - the projectile name
		def - the Projectile Definition table

	Projectile Definition Table:
		From Regular Entities
			visual
			visual_size
			textures
			use_texture_alpha
			spritediv
			initial_sprite_basepos
			backface_culling
			glow
			mesh

		Custom
			automatic_rotate = boolean - true if the projectile automatically turns to face its movement direction
			radius = number -  radius of projectile
			selectable = boolean - can player select
			gravity_scale = number - scale of the gravity. default: 1
			collectable = itemstring - item given to player when walked over an inactive one
			lifetime = number - how long (seconds) the projectile should live
			speed = number - how fast the projectile goes
			damage_groups = {damagetype = value}

		Callbacks - Builtin versions available.
			on_strike_node(self, pos, node) - called when striking a node
											Defaults to `qts.projectile_default_struck_node(...)`
			on_strike_entity(self, objref) - called when striking an entity
											Defaults to `qts.projectile_default_struck_entity(...)`
			on_timeout(self) - called when timed out
											Defaults to `qts.projectile_default_timeout(...)`
			on_step(self, dtime) - called every frame. does not override builtin on_step function, but runs inside of it


	Functions inside of LuaEntity:
		projectile:get_lauentity():launch(dir = vector, objref = launcher) - launches the projectile in dir with builtin speed, etc.

	Callbacks for Nodes
		on_projectile_strike(projectile, pointed_thing) -> nil - called before projectile's on_strike_node()
		on_projectile_enter(projectile, pos) -> nil - called when a projectile first enters a node. 
														Not called when a projectile strikes the node
		on_projectile_exit(projectile, pos) -> nil - called when a projectile leaves a node

--]]
function qts.register_projectile(name, def)
	--log the new projectile
	def.name = name
	qts.registered_projectiles[name] = def
	if not def.radius then def.radius = 0.1 end
	if def.selectable then
		def.sradius = def.radius
	else
		def.sradius = 0
	end
	
	minetest.register_entity(":"..name, {
		
		initial_properties = {
			--physics
			physical = false, --using manual detection
			collide_with_objects = false, --using manual detection
			collisionbox = {-def.radius,-def.radius, -def.radius, def.radius, def.radius, def.radius},
			selectionbox = {-def.sradius, -def.sradius, -def.sradius, def.sradius, def.sradius, def.sradius},
			
			--graphics
			visual = def.visual,
			visual_size = def.visual_size,
			textures = def.textures,
			use_texture_alpha = def.use_texture_alpha,
			spritediv = def.spritediv,
			mesh = def.mesh,
			initial_sprite_basepos = def.initial_sprite_basepos,
			backface_culling = def.backface_culling,
			glow = def.glow,
			
			--effects
			--automatic_rotate = def.automatic_rotate,
			--automatic_face_movement_dir = def.automatic_face_movement_dir,
			--automatic_face_movement_max_rotation_per_sec = def.automatic_face_movement_max_rotation_per_sec,
			
			--builtin
			hp_max = 1,
			is_visible = true,
			makes_footsteps_sounds = false,
			static_save = false, --projectiles should not be saved
		},
		
		--custom options
		name = name,
		gravity_scale = def.gravity_scale or 1,
		radius = def.radius,
		active = false,
		collectable = def.collectable,
		recently_spawned = true,
		lifetime = def.lifetime or 240,
		lifetime_full = def.lifetime or 240, --DO NOT CHANGE
		speed = def.speed or 10,
		launcher = nil,
		prevpos = {x=0, y=0, z=0},
		damage_groups = def.damage_groups or {fleshy = 1},
		
		custom_step = def.on_step or nil,

		auto_rotate = def.automatic_rotate,
		
		--QuestTest stuff
		qt_entity = true,
		qt_projectile = true, --ALL qt_projectile entities must have a launch(self, dir, launcher) function!!
		
		
		on_activate = function(self, staticdata, dtime_s)
			self.QTID = qts.gen_entity_id()
		
			self.object:set_armor_groups({fleshy = 0, projectile = 100})
			
			self.prevpos = self.object:get_pos()
		end,
		
		launch = function(self, direction, launcher)
			if (launcher) then
				if type(launcher) ~= "string" and launcher:is_player() then
					launcher = launcher:get_player_name()
				end
				self.launcher = launcher
			end
			self.active = true
			self.recently_spawned = false
			
			if (self.gravity_scale and self.gravity_scale ~= 0) then
				self.object:set_acceleration({x=0, y=-9.8 * (self.gravity_scale or 1), z=0}) --gravity
			end
			
			self.object:set_velocity(vector.multiply(direction, self.speed))
			
			self.prevpos = self.object:get_pos()
		end,
		
		on_step = function(self, dtime)
			local pos = self.object:get_pos()
			if (self.active) then
				local node = minetest.get_node_or_nil(pos)
				if (node) then
					local def = minetest.registered_nodes[node.name]
					if (def and def.walkable) then
						--struck a node
						if (def.on_projectile_strike) then
							def.on_projectile_strike(self.object, {type="node", under=vector.round(pos), above=vector.round(self.prevpos)})
						end
						self:on_strike_node(pos, node)
					else
						--passing through
						if (not vector.equals(vector.round(pos), vector.round(self.prevpos))) then
							local prevnode = minetest.get_node_or_nil(self.prevpos)
							if (prevnode and minetest.registered_nodes[prevnode.name].on_projectile_exit) then
								minetest.registered_nodes[prevnode.name].on_projectile_exit(self.object, vector.round(self.prevpos))
							end
							
							if (def.on_projectile_enter) then
								def.on_projectile_enter(self.object, vector.round(pos))
							end
						end
					end
				end
				local objs = minetest.get_objects_inside_radius(pos, math.max(2, self.radius * 2))
				if (#objs > 0) then
					--struck an entity
					for i, obj in ipairs(objs) do
						--make sure not the same obj and the other is not a projectile either
						if (not pcall(function()
							if (qts.get_object_id(obj) ~= self.QTID and qts.objects_overlapping(self.object, obj)) then
								if (obj:is_player()) then
									if (self.launcher and self.launcher:is_player()) then
										if (obj:get_player_name() ~= self.launcher:get_player_name()) then
											self:on_strike_entity(obj)
										end
									else
										self:on_strike_entity(obj)
									end
								elseif ((obj.get_luaentity ~= nil) --there is a strange error that obj might no longer exits on the next line
										and (obj:get_luaentity().name ~= self.name)
										and (obj:get_luaentity().name ~= "__builtin:item")) then 
									self:on_strike_entity(obj)
								end
							end
						end)) then 
							minetest.log("QUESTEST ERROR: An error occured with a projectile targeting a deleted entity. Gracefully skipping.")
						end
					end
				end
			else
				if (self.collectable and self.collectable ~= "") then
					--pickup code here
					local objs = minetest.get_objects_inside_radius(pos, 2)
					if (#objs > 0) then
						--struck an entity
						for i, obj in ipairs(objs) do
							if (not pcall(function()
								if (obj and obj:is_player() and self.collectable ~= "") then
									local inv = obj:get_inventory()
									local left = inv:add_item("main", self.collectable)
									qts.pickup_sound(obj)
									if (left and not left:is_empty()) then
										self.collectable = ItemStack(left):to_string()
									else
										self.collectable = ""
										local node = minetest.get_node_or_nil(pos)
										if (node) then
											local def = minetest.registered_nodes[node.name]
											if def.on_projectile_exit then
												def.on_projectile_exit(self.object, vector.round(pos))
											end
										end
										self.object:remove()
										
									end
								end
							end)) then
								minetest.log("QUESTEST ERROR: An error occured picking up an entity. Gracefully skipping.")
							end
						end
					end
				end
			end
			
			--custom step functionality
			if (self.custom_step) then
				self:custom_step(dtime)
			end
			
			--FINALIZE
			--lifetime caclulations
			self.lifetime = self.lifetime - dtime
			if (self.lifetime <= 0) then
				self:on_timeout()
			end
			
			if self.auto_rotate  and self.prevpos then
				local dir = vector.direction(self.prevpos, pos)
				if dir.x ~= 0 or dir.y ~=0 or dir.z ~= 0 then
					if self.invert_direction then
						dir = -dir
					end
					self.object:set_rotation(vector.dir_to_rotation(dir))
				end
			end
			--minetest.log(dump(self.object:get_properties().automatic_face_movement_dir))
			
			--update the prevpos
			self.prevpos = pos
		end,
		
		--special callback functions
		on_strike_node = def.on_strike_node or qts.projectile_default_struck_node,
		on_strike_entity = def.on_strike_entity or qts.projectile_default_struck_entity,
		on_timeout = def.on_timeout or qts.projectile_default_timeout,
		
		
		on_punch = def.on_punch,
	})
	
end

--[[
Default Questtest projectile callback functions
these are used if none are provided
they are publicly accessable so that, if one wanted to, they could use them inside of their custom callback functions
to get the default behavior along with the custom
--]]

--[[
	Default function for when a projectile strikes a node.

	Params:
		self - the LuaEntity
		pos - the node position
		node - the node reference

	Returns:
		nil

	Effect:
		sets the speed to 0, moves projectile to previous position
		flips its automatic movement direction so it does not get turned by the above
		and sets itself inactive
]]
qts.projectile_default_struck_node = function(self, pos, node)
	self.object:set_velocity({x=0, y=0, z=0})
	self.object:set_acceleration({x=0, y=0, z=0})
	if (self.prevpos) then
		self.object:set_pos(self.prevpos)
	end
	self.invert_direction = true
	self.active = false --deactivate the entity
end

--[[
	Default function for when a projectile strikes an entity.

	Params:
		self - the LuaEntity
		obj_other - the struck entity, ObjRef

	Returns:
		nil

	Effect:
		puches the other object, with the launcher as the hitter if there is a launcher, else itself,
		uses passe damage groups
		removes self.
]]
qts.projectile_default_struck_entity = function(self, obj_other)
	if self.launcher and type(self.launcher) == "string" then
		self.launcher = minetest.get_player_by_name(self.launcher)
	end
	obj_other:punch((self.launcher or self.object), 1, {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {},
		damage_groups = self.damage_groups or {fleshy = 1},
	}, vector.direction(self.object:get_pos(), obj_other:get_pos()))
	self.object:remove() --destroy the projectile
end

--[[
	Default function for when a projectile times out.

	Params:
		self - the LuaEntity
		
	Returns:
		nil

	Effect:
		removes self.
]]
qts.projectile_default_timeout = function(self)
	self.object:remove()
end


--[[
Launching Functions
--]]

--[[
	Have a player launch a projectile. 

	Params:
		projectile = the registered projectile name
		player - the player objref
		inacuracy = 0 - the amount of variation in blocks at a range of 100 blocks. 
]]
function qts.projectile_launch_player(projectile, player, inacuracy)
	local pos = player:get_pos()
	if (not inacuracy) then inacuracy = 0 end
	if (player:is_player()) then
		pos = vector.add(pos, vector.new(0, 1.5, 0))
		local dir = player:get_look_dir()
		pos = vector.add(pos, dir)
		local obj = minetest.add_entity(pos, projectile)
		if (inacuracy ~= 0) then
			inacuracy = inacuracy / 100
			dir = vector.new(
				dir.x + ((math.random() - 0.5 ) * inacuracy), 
				dir.y + ((math.random() - 0.5 ) * inacuracy),
				dir.z + ((math.random() - 0.5 ) * inacuracy)
			)
		end
		if obj:get_luaentity().launch ~= nil then
			obj:get_luaentity():launch(dir, player)
		end
	end
end

--[[
	Launch a projectile from origin to target
	due to gravity, there is no guarantee this will hit!

	Params:
		projectile = the registered projectile name
		origin - the position to launch from
		target - launch directly at this position
		launcher - the ObjRef that launched it
		inacuracy = 0 - the amount of variation in blocks at a range of 100 blocks. 
]]
function qts.projetile_launch_to(projectile, origin, target, launcher, inacuracy)
	local dir = vector.direction(origin, target)
	if (not inacuracy) then inacuracy = 0 end
	if (inacuracy ~= 0) then
		inacuracy = inacuracy / 100
		dir = vector.new(
			dir.x + ((math.random() - 0.5 ) * inacuracy), 
			dir.y + ((math.random() - 0.5 ) * inacuracy),
			dir.z + ((math.random() - 0.5 ) * inacuracy)
		)
	end
	local obj = minetest.add_entity(origin, projectile)
	if obj:get_luaentity().launch ~= nil then
		obj:get_luaentity():launch(dir, launcher)
	end
end

--[[
	Launch a projectile in a specific direction

	Params:
		projectile = the registered projectile name
		origin - the position the projectile launches from
		dir - the direction of the launch
		launcher - the ObjRef that luanched it
		inacuracy = 0 - the amount of variation in blocks at a range of 100 blocks. 
]]
function qts.projetile_launch_dir(projectile, origin, dir, launcher, inacuracy)
	dir = vector.normalize(dir)
	if (not inacuracy) then inacuracy = 0 end
	if (inacuracy ~= 0) then
		inacuracy = inacuracy / 100
		dir = vector.new(
			dir.x + ((math.random() - 0.5 ) * inacuracy), 
			dir.y + ((math.random() - 0.5 ) * inacuracy),
			dir.z + ((math.random() - 0.5 ) * inacuracy)
		)
	end
	local obj = minetest.add_entity(origin, projectile)
	if obj:get_luaentity().launch ~= nil then
		obj:get_luaentity():launch(dir, launcher)
	end
end
