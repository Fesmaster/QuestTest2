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
		
		
		behavior = "behavor name",
		speed = number,
		view_radius = number,
		
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