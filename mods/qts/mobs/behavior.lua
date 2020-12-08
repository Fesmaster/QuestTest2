--[[
qts.ai.register_behavior(name def)
	Registers a new AI behavior

	Params:
	name =  the name of the behavior
	def = {
		on_step = function(self, dtime),
		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir),
		on_rightclick = function(self, clicker),
		on_activate = function(self, staticdata, dtime_s),
		get_staticdata = function(self) - return "string"
	}
	
qts.ai.register_creature(name, def)
	Registers a new Creature
	
	Params:
	name = the name of the creature
	def = {
		hp_max,
		weight,
		
		collisionbox = {},
		selectionbox = {},
		collide_with_objects = true,
		visual = "mesh" / "wielditem" / ... ,
		texture = {},
		mesh = "mesh",
		visual_size = {},
		is_visible = true,
		colors = {},
		makes_footsteps_sounds = true,
		
		use_texture_alpha
		spritediv
		initial_sprite_basepos
		backface_culling
		glow
		
		automatic_rotate
		automatic_face_movement_dir
		automatic_face_movement_max_rotation_per_sec
		
		behavior = "behavor name",
		speed = number,
		view_radius = number,
		gravity_scale = number,
		armor_groups = {fleshy = 0}
	}
--]]

qts.ai.register_behavior = function(name, def)
	def.name = name
	
	if (not def.on_step or type(def.on_step) ~= "function") then
		def.on_step = function(self, dtime)
			return
		end
	end
	
	if (not def.on_punch or type(def.on_punch) ~= "function") then
		def.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			return
		end
	end
	
	if (not def.on_rightclick or type(def.on_rightclick) ~= "function") then
		def.on_rightclick = function(self, clicker)
			return
		end
	end
	
	if (not def.on_activate or type(def.on_activate) ~= "function") then
		def.on_activate = function(self, staticdata, dtime_s)
			return
		end
	end
	
	if (not def.get_staticdata) or (type(def.get_staticdata) ~= "function") then
		def.get_staticdata = function(self)
			return ""
		end
	end
	
	qts.registered_behaviors[name] = def
end


function qts.ai.register_creature(name, def)
	if (not(def.behavior) or not(qts.registered_behaviors[def.behavior])) then
		minetest.log("Incorrect creature definition. Valid behavior must be supplied.")
		return false
	end
	
	minetest.register_behavior_entity(name, {
		initial_properties = {
			--regular stuff
			hp_max = def.hp_max or 1,
			weight = def.weight or 1,
			collisionbox = def.collisionbox or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			visual = def.visual or "wielditem",
			visual_size = def.visual_size or {x=.7, y=.7, z=.7},
			textures = def.textures or {"air"},
			mesh = def.mesh or "",
			colors = def.colors or {},
			makes_footsteps_sounds = def.makes_footsteps_sounds,

			--other rendering
			use_texture_alpha = def.use_texture_alpha,
			spritediv = def.spritediv,
			initial_sprite_basepos = def.initial_sprite_basepos,
			backface_culling = def.backface_culling,
			glow = def.glow,
			
			--effects
			automatic_rotate = def.automatic_rotate,
			automatic_face_movement_dir = def.automatic_face_movement_dir,
			automatic_face_movement_max_rotation_per_sec = def.automatic_face_movement_max_rotation_per_sec,
			
			--builtings
			static_save = true, --creatures should be saved
			is_visible = true,
			collide_with_objects = false, --using manual detection
			physical = true,
		},
		
		behavior_name = def.behavor,
		behavior = qts.registered_behaviors[def.behavior],
		speed = def.speed or 1,
		view_radius = def.veiw_radius,
		view_radius_default = def.view_radius,
		gravity_scale = def.gravity_scale or 1,
		default_armor_groups = def.armor_groups or {fleshy = 0},
		
		on_activate = function(self, staticdata, dtime_s)
			self.object:set_armor_groups(default_armor_groups)
			self.QTID = qts.gen_entity_id()
			self.object:set_acceleration({x=0, y=-9.8*self.gravity_scale, z=0})
			behavior.on_activate(self, staticdata, dtime_s)
		end,
		
		get_staticdata = function(self)
			return def.get_staticdata(self)
		end,
		
		on_step = function(self, dtime)
			behavior.on_step(self, dtime)
		end,
		
		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			return behavior.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
		end,
		
		on_rightclick = function(self, clicker)
			return behavior.on_rightclick(self, clicker)
		end,
	})
	
	qts.registered_creatures[name] = 1
end