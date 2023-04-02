--[[
DEPRICATED
qts.ai.register_behavior(name, def)
	
DEPRICATED	
qts.ai.register_creature(name, def)


Creature Modules and Tasks
a Module is a self-contained set of behaviors for a creature, that hooks into the Task state machine system.

Each module describes a specific set of functions, as well as needed attributes.

Requires vs Depends attributes:
the table of required attributes is always set: it overrides any previously set. If they have no value, an error is generated.
the table of depends attributes are only set if they are not yet set. They do not need a value.

--]]

---Register a Creature Module
---@param name string "modname:name" format
---@param def table module definition table
---@return string name the module name as supplied
--[[
	all fields of def are optional.
	
	fields of Def:
		reqired_properties = {} - initial properties of the entity that will be overriden
		depends_properties = {} - initial properties of the entity that will only set their value if not already set
		required_modules = {} - other modules that Must be added to the module list first
		on_activate = function(self, table_data, dtime_s) - modified from default minetest register entity. table_data is a reference, should be read only.
		get_staticdata = function(self, table_data) - return nil, modify table - modified from default minetest register entity.  table_data is a reference, should be written to. No function pointers!
		on_death = function(self, drops) - drops is a array that should have any drops added to it
		on_step = function(self, dtime, moveresult)
		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		on_rightclick = function(self, clicker)
]]
function qts.ai.register_module(name, def)
	if (type(def) ~= "table") then
		minetest.log("error", "qts.ai.register_module(...) requires a table as the definition")
		return name
	end
	def.name = name;
	qts.registered_modules[name]=def

	return name
end

--[[
Priority constants. These are NOT adjacent, so you can do relative priorities such as
	qts.ai.PRIORITY_MED + 10	
]]

---@enum Priority
qts.ai.priority = {
	NONE=0,
	LOW=100,
	MED=200,
	HIGH=300,
	NOW=1000,
}


--prioerties that go in an initial_properties table
local properties_to_propigate = {
	hp_max = true,
	breath_max = true,
	zoom_fov = true,
	eye_height = true,
	physical = true,
	collide_with_objects = true,
	collisionbox = true,
	selectionbox = true,
	pointable = true,
	visual = true,
	visual_size = true,
	mesh = true,
	textures = true,
	colors = true,
	use_texture_alpha = false,
	spritediv = true,
	initial_sprite_basepos = true,
	is_visible = true,
	makes_footstep_sound = false,
	automatic_rotate = true,
	stepheight = true,
	automatic_face_movement_dir = true,
	automatic_face_movement_max_rotation_per_sec = true,
	backface_culling = true,
	glow = true,
	nametag = true,
	nametag_color = true,
	nametag_bgcolor = true,
	infotext = true,
	static_save = true,
	damage_texture_modifier = true,
	shaded = true,
	show_on_minimap = true,
}

---Registeres a new creature
---@param name string "modname:name" format
---@param def table creature definition table
--[[
	fields of def:
		modules = {} - a list of module names. They are applied in the order given, with any dependant modules inserted before the one that depends on them
		initial_properties = {} - the eneity's initial properties. May be overriden by modules, if the same property is in the module's required_fields
		spawnegg = {   - Spawnegg information, if you don't want a spawnegg, leave this nil
				description = "Description",
				color1 = "colorstring",
				color2 = "colorstring",
				pattern = "spots", -current patterns are limited to "spots"
				spawner_config = "string" -- the spawner config to apply to a spawner when you rightclick one with the egg
			}

	special fields in initial_properties:
		animations - table of name->minetest animation table.
]]
function qts.ai.register_creature(name, def)
	if (def.behavior) then
		minetest.log("warning", "qts.ai.register_creature(...) no longer uses behaviros, they are depricated.")
		qts.ai.register_creature_old(name, def)
		return
	end

	if (def.modules == nil or def.initial_properties == nil) then
		minetest.log("error", "qts.ai.register_creature(...) requires both modules and initial_properties to be defined in its def table.")
		return
	end

	def.initial_properties.name = name

	local properties = qts.table_deep_copy(def.initial_properties)
	local backlog_properties = {} -- any depends properties with no values.
	local modules = {}
	local modules_added = {}
	local function add_module(modulename)
		--don't add the same module twice
		if (modules_added[modulename]) then
			return
		end

		modules_added[modulename] = true
		if not qts.registered_modules[modulename] then
			minetest.log("error", "attempted to register a creature with an unknwon module: " .. dump(modulename))
		end

		local module = qts.registered_modules[modulename]
		if module.required_modules then
			for i, modulename in ipairs(module.required_modules) do
				add_module(modulename)	
			end
		end

		if module.reqired_properties then
			for key, value in pairs(module.reqired_properties) do
				if properties[key] then
					minetest.log("warning", "stamping existing initial property [" .. dump(key) .. "] when registering creature: " .. dump(name) .. " and its module: " .. dump(modulename) .. " as the module lists it as required")
				end
				properties[key] = value
				if backlog_properties[key] then
					backlog_properties[key] = nil
				end
			end
		end

		if module.depends_properties then
			for key, value in pairs(module.depends_properties) do
				if properties[key] == nil then
					if value == nil then
						backlog_properties[key] = true
					else
						properties[key] = value
						if backlog_properties[key] then
							backlog_properties[key] = nil
						end
					end
				end
			end
		end

		--add module to list
		modules[#modules+1] = modulename
	end
	--end function def

	for i, modulename in ipairs(def.modules) do
		add_module(modulename)
	end

	for key, _ in pairs(backlog_properties) do
		minetest.log("warning", "When registering creature: " .. dump(name) .. "depends property: " .. dump(key) .. " never had a value. Setting it to 0" )
		properties[key] = 1
	end

	--add the modules list to the initial properties
	properties.modules = modules

	local entity_def = {
		initial_properties = {},

		on_activate = function(self, staticdata, dtime_s)
			self.QTID = qts.gen_entity_id()
			self.queued_events = {}
			self.current_task_priority = 0
			self.current_task = nil

			local data = minetest.deserialize(staticdata)
			--self.modules = data.modules
			if self.modules == nil then
				self.modules = {}
			end

			-- build module queues
			self.module_function_step = {}
			self.module_function_punch = {}
			self.module_function_rightclick = {}

			if (data ~= nil and data.modules ~= nil) then
				self.modules = {} --completely override the modules from registration
				for i, modulename in ipairs(data.modules) do
					if qts.registered_modules[modulename] ~= nil then
						self.modules[#self.modules+1] = modulename --only add modules IF they exist!
					end
				end
			end

			local modules_keyed = {}
			local index = 1
			for i, modulename in ipairs(self.modules) do
				if qts.registered_modules[modulename] ~= nil then
					if modules_keyed[modulename] == nil then
						modules_keyed[modulename] = index
						index = index + 1
					end
				end
			end
			self.modules = {}
			for modulename, index in pairs(modules_keyed) do
				self.modules[index] = modulename
			end

			for i, modulename in ipairs(self.modules) do
				local module = qts.registered_modules[modulename]
				if module ~= nil then
					--load up the module
					if module.on_activate and type(module.on_activate) == "function" then
						module.on_activate(self, data, dtime_s)
					end
					--add existing attributes to the queues
					if module.on_step and type(module.on_step) == "function" then
						self.module_function_step[#self.module_function_step+1] = module.on_step
					end
					if module.on_punch and type(module.on_punch) == "function" then
						self.module_function_punch[#self.module_function_punch+1] = module.on_punch
					end
					if module.on_rightclick and type(module.on_rightclick) == "function" then
						self.module_function_rightclick[#self.module_function_rightclick+1] = module.on_rightclick
					end
				else
					minetest.log("error", "tried to create a creature with an unknown module list. Entity: ".. self:id_string())
				end
			end

			
		end,

		get_staticdata = function(self)
			local data = {}
			for i, modulename in ipairs(self.modules) do
				local module = qts.registered_modules[modulename]
				if module ~= nil then
					--load up the module
					if module.get_staticdata and type(module.get_staticdata) == "function" then
						module.get_staticdata(self, data)
					end
				else
					minetest.log("error", "tried to save a creature with an unknown module list. Entity: ".. self:id_string())
				end
			end
			
			data.modules = self.modules

			return minetest.serialize(data)
		end,

		on_step = function(self, dtime, moveresult)
			if self.TICK_COUNT == nil then 
				self.TICK_COUNT = 1 
			else
				self.TICK_COUNT = self.TICK_COUNT + 1
			end

			

			-- first, run all module on_step functions
			for i, module_step_func in ipairs(self.module_function_step) do
				module_step_func(self, dtime, moveresult)
			end
			
			-- then update any timed functions
			if self.queued_events then
				local index_to_remove = {}
				for i, event in ipairs(self.queued_events) do
					event.timer = event.timer - dtime
					if event.timer <= 0 then
						event.func(self)
						table.insert(index_to_remove, 1, i)
					end
				end
				--reverse loop to remove indices
				for _ ,i  in ipairs(index_to_remove) do
					table.remove(self.queued_events, i)
				end
			end
			

			-- finally tick the task
			if (self.current_task) then
				self.bisincurrenttask = true
				self.current_task(self, dtime, moveresult)
				self.bisincurrenttask = false
			end
		end,

		on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
			minetest.log("Punch called on entity " .. self:id_string() .. " by " ..qts.object_name(puncher))
			-- run all module on_punch functions
			for i, module_punch_func in ipairs(self.module_function_punch) do
				module_punch_func(self, puncher, time_from_last_punch, tool_capabilities, dir)
			end
			return true
			
		end,

		on_rightclick = function(self, clicker)
			minetest.log("Rightclick called on entity " .. self:id_string() .. " by " .. qts.object_name(clicker))
			for i, module_rightclick_func in ipairs(self.module_function_rightclick) do
				module_rightclick_func(self, clicker)
			end
		end,

		-- add a module

		contains_module = function(self, modulename)
			for i, existingmodulename in ipairs(self.modules) do
				if existingmodulename == modulename then
					return true
				end
			end
			return false
		end,

		add_module = function(self, modulename, run_activate)
			if self:contains_module(modulename) then
				minetest.log("warning", "you cannot add two of the same module. Entity: ".. self:id_string())
				return
			end
			local module = qts.registered_modules[modulename]
			if module ~= nil then
				self.modules[#self.modules+1] = modulename

				--load dependant meodules!
				for i, depends_modulename in ipairs(module.required_modules) do
					if not self:contains_module(depends_modulename) then
						self:add_module(depends_modulename, run_activate)
					end
				end

				if (run_activate and module.on_activate ~= nil and type(module.on_activate) == "function") then
					module.on_activate(self, {}, 0)
				end
				--add existing attributes to the queues
				if module.on_step and type(module.on_step) == "function" then
					self.module_function_step[#self.module_function_step+1] = module.on_step
				end
				if module.on_punch and type(module.on_punch) == "function" then
					self.module_function_punch[#self.module_function_punch+1] = module.on_punch
				end
				if module.on_rightclick and type(module.on_rightclick) == "function" then
					self.module_function_rightclick[#self.module_function_rightclick+1] = module.on_stepon_rightclick
				end
				minetest.log("added module " .. dump(modulename) .. " to an entity: ".. self:id_string())
			else
				minetest.log("error", "you cannot add an unregistered module! Entity: ".. self:id_string())
			end
		end,

		remove_module = function(self, modulename)
			local containsmodule = false
			local module = qts.registered_modules[modulename]
			for i, existingmodulename in ipairs(self.modules) do
				if existingmodulename == modulename then
					table.remove(self.modules, i)					
					containsmodule = true
					break
				end
			end
			if (containsmodule) then
				if module ~= nil then
					local func_to_remove = {}
					for i, existingmodulefunc in ipairs(self.module_function_step) do
						if existingmodulefunc == module.on_step then
							table.insert(func_to_remove, 1, i)
						end
					end
					for _, i in ipairs(func_to_remove) do
						table.remove(self.module_function_step, i)
					end

					func_to_remove = {}
					for i, existingmodulefunc in ipairs(self.module_function_punch) do
						if existingmodulefunc == module.on_punch then
							table.insert(func_to_remove, 1, i)
						end
					end
					for _, i in ipairs(func_to_remove) do
						table.remove(self.module_function_punch, i)
					end

					func_to_remove = {}
					for i, existingmodulefunc in ipairs(self.module_function_rightclick) do
						if existingmodulefunc == module.on_rightclick then
							table.insert(func_to_remove, 1, i)
						end
					end
					for _, i in ipairs(func_to_remove) do
						table.remove(self.module_function_rightclick, i)
					end
					minetest.log("removed module " .. dump(modulename) .. " from entity:".. self:id_string())
				else
					minetest.log("error", "attempted remove an unregistered module! Entity:".. self:id_string())
				end
			end
		end,

		-- Tasks (or, the state machine)

		run_task = function (self, priority, func)
			if self.current_task_priority == nil then self.current_task_priority = 0 end
			if priority > self.current_task_priority and type(func) == "function" then
				self.current_task_priority = priority
				self.current_task = func
				return true
			end
			return false
		end,

		set_current_task_priority = function(self, priority, allow_from_anywhere)
			if (self:is_in_task() or allow_from_anywhere) then
				self.current_task_priority = priority
			else
				minetest.log("warning", "you cannot set the priority of a task from outside the task itself without setting allow_from_anywhere to true.")
			end
		end,

		clear_current_task = function(self, allow_from_anywhere)
			if (self:is_in_task() or allow_from_anywhere) then
				self.current_task_priority = qts.ai.PRIORITY_NONE
				self.current_task = nil
			else
				minetest.log("warning", "you cannot clear the task from outside the task itself without setting allow_from_anywhere to true.")
			end
		end,

		is_in_task = function(self)
			return qts.select(self.bisincurrenttask==nil, false, self.bisincurrenttask)
		end,
		--[[
			Play an animation

			anim_name - a name into an animation table self.animations
		]]
		play_animation = function(self, anim_name)
			if self.current_animation ~= nil and self.current_animation == anim_name then
				return
			end
			if  self.animations ~= nil and type(self.animations) == "table" and self.animations[anim_name] then
				self.object:set_animation(self.animations[anim_name], self.animation_speed, 0)
				self.current_animation = anim_name
			end
		end,

		-- Event Queues

		enqueue_event = function(self, handle, time, func)
			if self.queued_events == nil then
				self.queued_events = {}
			end
			self.queued_events[#self.queued_events+1] = {
				handle = handle,
				timer = time,
				func = func
			}
		end,

		kill_event = function(self, handle)
			if self.queued_events then
				local index_to_remove = {}
				for i, event in ipairs(self.queued_events) do
					if event.handle == handle then
						index_to_remove[#index_to_remove+1] = i
					end
				end
				--reverse loop to remove indices
				for i = #index_to_remove, 0, -1 do
					table.remove(self.queued_events, index_to_remove[i])
				end
			end
		end,

		id_string = function(self)
			return (qts.select(self.name ~= nil, dump(self.name), "UNNAMED ENTITY") .. "(" .. dump(self.QTID) .. ")")
		end
	}

	for key, value in pairs(properties) do
		if properties_to_propigate[key] then
			entity_def.initial_properties[key] = value
		elseif entity_def[key] == nil then
			entity_def[key] = value
		else
			minetest.log("warning", "attempted to define property " .. dump(key) .. " that overrides a default creature function. Blocking." )
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
			spawn_entity_name = name,
			default_spawner_config = def.spawnegg.spawner_config,
			on_place = function(itemstack, placer, pointed_thing)
				local itemdef = minetest.registered_items[itemstack:get_name()]
				if not itemdef or not itemdef.spawn_entity_name then return end

				if pointed_thing.above then
					if itemdef.default_spawner_config then
						local below_node = minetest.get_node_or_nil(pointed_thing.under)
						if below_node and minetest.get_item_group(below_node.name, "spawner") ~= 0 then
							--clicked on a spawner
							qts.ai.apply_spawner_config(pointed_thing.under, itemdef.default_spawner_config)
							if not qts.is_player_creative(placer) then
								itemstack:take_item(1)
							end
							return itemstack;
						end
					end

					local obj = minetest.add_entity(pointed_thing.above, itemdef.spawn_entity_name)
					if obj and not qts.is_player_creative(placer) then
						itemstack:take_item(1)
					end
					return itemstack;
				end
			end
		})
	end
	qts.registered_creatures[name] = 1
end



--qts-defined modules. These are very common, base modules.
qts.ai.module = {}

-- TODO: make a seperate self.armor_groups that Can be modified, to work with a armor-wearing module

--[[
	module that makes it possible to damage a creature. Very common, and uses the damage system, so its part of qts.
]]
qts.ai.module.damageable = qts.ai.register_module("qts:ai:module_damageable", {
	depends_properties = {
		armor_groups_base= {fleshy=1}
	},

	on_activate = function(self, data, dtime_s)
		--load armor
		if data ~= nil and data.armor_groups_base ~= nil and self.armor_groups_base == nil then
			self.armor_groups_base = data.armor_groups_base
		end

		--apply armor
		if (self.armor_groups_base) then
			local armor_groups = {fleshy=1, stabby=1, psycic=1, enviromental=1}
			for k, v in pairs(self.armor_groups_base) do
				armor_groups[k] = v+1 --deal with that off by one error
			end
			self.object:set_armor_groups(armor_groups)
		end
	end,

	get_staticdata = function(self, data)
		data.armor_groups_base = self.armor_groups_base
	end,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		local damage = qts.calculate_damage(self.object, puncher, time_from_last_punch, tool_capabilities, dir)
		local new_hp = self.object:get_hp() - damage
		
		--handle deaths
		if new_hp <= 0 and not self.immortal then
			minetest.log("Entity " .. self:id_string() .. " has died. Collecting drops and destroying")
			local drops = {}
			for i, modulename in ipairs(self.modules) do
				local module = qts.registered_modules[modulename]
				if module then
					if module.on_death and type(module.on_death) == "function" then
						module.on_death(self, drops)
					end
				else
					minetest.log("error", "somehow, despite all odds, a unregistered module name ended up in a dying entity. You should probably fix this. Or don't.")
				end
			end
			local pos = self.object:get_pos()
			for i, itemstring in ipairs(drops) do
				minetest.add_item(pos, itemstring)
			end
			self.object:remove()
			return true
		end

		self.object:set_hp(new_hp, "punch")
	end,
	
})

--[[
	Module that gives gravity to the object. Very common, so its part of qts
]]
qts.ai.module.gravity = qts.ai.register_module("qts:ai:module_gravity", {
	depends_properties = {
		gravity_scale= 1
	},
	on_activate = function(self, data, dtime_s)
		if (data ~= nil and data.gravity_scale) then
			self.gravity_scale = data.gravity_scale
		end
		self.object:set_acceleration({x=0, y=-9.8*qts.select(self.gravity_scale ~= nil, self.gravity_scale, 1), z=0})
	end,
})
