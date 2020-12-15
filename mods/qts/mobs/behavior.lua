--[[
qts.ai.register_behavior(name, def)
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
		visual = "mesh" / "wielditem" / ... ,
		textures = {},
		mesh = "mesh",
		visual_size = {},
		colors = {},
		makes_footsteps_sounds = true,
		
		use_texture_alpha,
		spritediv,
		initial_sprite_basepos,
		backface_culling,
		glow,
		
		automatic_rotate,
		automatic_face_movement_dir,
		automatic_face_movement_max_rotation_per_sec,
		
		behavior = "behavor name",
		speed = number,
		view_radius = number,
		gravity_scale = number,
		armor_groups = {fleshy = 0},
		level = 0,
		
		spawnegg = {
			description = "Description",
			color1 = "colorstring",
			color2 = "colorstring",
			pattern = "spots",
		}
		--if you don't want a spawnegg, leave this nil
		
		--custom_key = cusom_val
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

--these values don't get propigated 
local dont_propigate = {
	on_activate=true,get_staticdata=true,on_step=true,on_punch=true,on_rightclick=true,hp_max=true,
	weight=true,collisionbox=true,visual=true,visual_size=true,textures=true,mesh=true,colors=true,
	makes_footsteps_sounds=true,use_texture_alpha=true,spritediv=true,initial_sprite_basepos=true,
	backface_culling=true,glow=true,automatic_rotate=true,automatic_face_movement_dir=true,
	automatic_face_movement_max_rotation_per_sec=true,static_save=true,is_visible=true,
	collide_with_objects=true,physical=true,name=true,behavior_name=true,behavior=true,
	default_textures=true,speed=true,view_radius=true,view_radius_base=true,gravity_scale=true,
	armor_groups_base=true,level=true,level_base=true,hp_max_base=true,timer=true,initial_properties=true,
	spawnegg=true,
}

local behavior_propigate={on_activate=true,get_staticdata=true,on_step=true,on_punch=true,on_rightclick=true}

function qts.ai.register_creature(name, def)
	if (not(def.behavior) or not(qts.registered_behaviors[def.behavior])) then
		minetest.log("Incorrect creature definition. Valid behavior must be supplied.")
		return false
	end
	
	local entity_def = {
		initial_properties = {
			--regular stuff
			hp_max = def.hp_max or 1,
			weight = def.weight or 1,
			collisionbox = def.collisionbox or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			selectionbox = def.selectionbox or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
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
		
		--AI 
		behavior_name = def.behavor,
		--behavior = qts.registered_behaviors[def.behavior],
		behavior = {},
		
		--stats
		speed = def.speed or 1,
		gravity_scale = def.gravity_scale or 1,
		level = def.level or 0,
		view_radius = def.veiw_radius or 16,
		
		--rendering
		default_textures = def.textures or {"air"},
		animations = def.animations or {none = {x=0,y=0}},
		current_animation = def.default_animation or "none",
		animation_speed = def.animation_speed or 30;
		
		--unsorted values
		name = name,
		timer = 0,
		armor_groups_base = def.armor_groups or {fleshy = 100},
		level_base = def.level or 0,
		hp_max_base = def.hp_max or 1,
		view_radius_base = def.view_radius,
		
		play_animation = function(self, anim_name)
			if self.current_animation == anim_name then
				return
			end
			if self.animations[anim_name] then
				self.object:set_animation(self.animations[anim_name], self.animation_speed, 0)
			end
		end,
		
		on_activate = function(self, staticdata, dtime_s)
			self.object:set_armor_groups(self.armor_groups_base)
			self.QTID = qts.gen_entity_id()
			self.object:set_acceleration({x=0, y=-9.8*self.gravity_scale, z=0})
			self.behavior.on_activate(self, staticdata, dtime_s)
		end,
		
		get_staticdata = function(self)
			if def.get_staticdata then	
				return def.get_staticdata(self)
			end
			return ""
		end,
		
		on_step = function(self, dtime)
			if (self.timer > 0) then 
				self.timer = self.timer - dtime 
				if (self.timer <= 0 and self.on_timer) then
					self:on_timer();
				end
			end
			
			self.behavior.on_step(self, dtime)
		end,
		
		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			return self.behavior.on_punch(self, puncher, time_from_last_punch, tool_capabilities, dir)
		end,
		
		on_rightclick = function(self, clicker)
			return self.behavior.on_rightclick(self, clicker)
		end,
	}
	
	--propigate any custom values from the behavior to the entity itself.
	for name, value in pairs(qts.registered_behaviors[def.behavior]) do
		if not (dont_propigate[name]) then
			entity_def[name] = value
		elseif (behavior_propigate[name]) then --only methods propigate
			entity_def.behavior[name] = value
		end
	end
	
	--propigate any custom values from the creature def to the entity itself.
	for name, value in pairs(def) do
		if not (dont_propigate[name]) and entity_def[name] == nil then
			entity_def[name] = value
		end
	end
	
	
	
	minetest.register_entity(name, entity_def)
	
	if (def.spawnegg) then
		minetest.register_craftitem(":"..name.."_spawnegg", {
			description = def.spawnegg.description,
			inventory_image = "(qts_egg_base.png^[multiply:" .. 
				def.spawnegg.color1 .. 
				")^(qts_egg_"..
				def.spawnegg.pattern .. 
				".png^[multiply:"..
				def.spawnegg.color2..")",
			groups = {spawnegg = 1,},
			on_place = function(itemstack, placer, pointed_thing)
				if pointed_thing.above then
					local obj = minetest.add_entity(pointed_thing.above, name)
					if obj and not qts.is_player_creative(placer) then
						itemstack:take_item(1)
						return itemstack;
					end
				end
			end
		})
	end
	qts.registered_creatures[name] = 1
end