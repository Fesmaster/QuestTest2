--[[
    Definition of many common modules 
]]

mobs.modules = {}
local modules = mobs.modules


---@alias TargetType
---| "none" No Target
---| "player" A PlayerRef
---| "item" A __builtin:item
---| "creature" A QTS Creature
---| "entity" An arbitrary entity, that may or may not be tracked by QTS
---| "node" A node
---| "point" A arbitrary point


---Get the target type of a ObjRef
---@param object ObjectRef
---@return TargetType 
function mobs.get_object_target_type(object)
	if object:is_player() then
		return "player"
	end
	local name = qts.object_name(object)
	if name == "__builtin:item" then
		return "item"
	elseif qts.registered_creatures[name] then
		return "creature"
	end
	return "entity"
end

mobs.mobile_target_types = {
    creature = true,
	entity = true,
	item = true,
	player = true
}

---Check if a given target type is a mobile object
---@param target_type TargetType
---@return boolean
function mobs.get_is_target_type_mobile(target_type)
	return qts.select(mobs.mobile_target_types[target_type], true, false) 
end

--[[
	Module that gives the creature the Punch ability. It can punch.
]]
modules.punch = qts.ai.register_module("mobs:punch", {
	depends_properties={
		wielded_item=""
	},
	reqired_properties={
		punch = function(self, target)
			local tool_capabilities = {}
			if self.wielded_item then
				--minetest.log("ITEM: " .. dump(self.wielded_item))
				local stack = ItemStack(self.wielded_item)
				local def = minetest.registered_items[stack:get_name()]
				if def then
					tool_capabilities = def.tool_capabilities
				end
			else
				local hand = minetest.registered_items[""]
				if hand and target then
					tool_capabilities = hand.tool_capabilities
				end
			end

			if tool_capabilities then
				minetest.log("Entity " .. self:id_string() .. " punched creature " .. dump(qts.object_name(target)))
				target:punch(self.object, 1, tool_capabilities, self.object:get_pos() - target:get_pos())
			end
		end,
	}
})

--[[
	Module that causes the creature to punch its target object when near them. This is a task, with slightly above medium priority.
]]
modules.punch_target = qts.ai.register_module("mobs:punch_target", {
	depends_properties={
		target_id = false,
		target_pos = false,
		target_objref = false,
        target_type =  "none",
		
		punch_priority = qts.ai.priority.MED+5,
		attack_timer = 0,
		attack_timer_reset =1,
        punch_target_types = {player=true, creature=true, entity=true},
	},
	required_modules ={
		modules.punch
	},
	on_step = function (self, dtime, moveresult)
		if (self.target_pos and self.punch_target_types[self.target_type] and vector.distancesq(self.target_pos, self.object:get_pos()) < qts.ai.MELEE_RADIUS_SQ ) then
			
			self:run_task(self.punch_priority, function(self, dtime, moveresult)
				if self.target_pos and self.punch_target_types[self.target_type] and vector.distancesq(self.target_pos, self.object:get_pos()) < qts.ai.MELEE_RADIUS_SQ then
					qts.ai.freeze(self.object, true, false)
					qts.ai.face(self.object, self.target_pos, true, false)
					self:play_animation("mine")
					if self.attack_timer <= 0 then
						self:punch(self.target_objref)
						self.attack_timer = self.attack_timer_reset 
					end
				else
					self:clear_current_task()
				end
			end)

		end

		self.attack_timer = self.attack_timer - dtime
	end
})

--[[
    Module that cleans up textures, using currently wielded item and armor (once its supported!)
]]
modules.item_textures = qts.ai.register_module("mobs:item_textures", {
    depends_properties={
        texture_is_dirty=false,
        wielded_item="",
        base_textures = {""}
    },

    on_activate = function(self, data, dtime_s)
        if data ~= nil then
            self.base_textures = data.base_textures or self.base_textures
        end
        self.texture_is_dirty = true
    end,

    get_staticdata = function(self, data)
        data.base_textures = self.base_textures
    end,

    on_step = function (self, dtime, moveresult)
        if (self.texture_is_dirty) then
			local t = {}
            for i, base in ipairs(self.base_textures) do
                t[i] =qts.humanoid_texture(self.object, base) 
            end
			self.object:set_properties({textures = t})
			self.texture_is_dirty = false
		end
    end,
})

--[[
	Module that causes the creature to punch its target object when near them. This is a task, with slightly above medium priority.
]]
modules.pickup_item = qts.ai.register_module("mobs:pickup_item", {
	depends_properties={
		target_id = false,
		target_pos = false,
		target_objref = false,
        target_type =  "none",
		
        wielded_item="",
        texture_is_dirty=false,

		pickup_priority = qts.ai.priority.MED+15,
	},
	required_modules ={
		modules.item_textures
	},

    on_activate = function(self, data, dtime_s)
        if data ~= nil then
            self.wielded_item = data.wielded_item or self.wielded_item
        end
    end,

    get_staticdata = function(self, data)
        data.wielded_item = self.wielded_item
    end,

    on_death = function(self, drops)
        if self.wielded_item ~= "" then
            drops[#drops+1] = self.wielded_item
        end
    end,

	on_step = function (self, dtime, moveresult)
		if (self.target_objref and self.target_pos and self.target_type== "item" and vector.distancesq(self.target_pos, self.object:get_pos()) < qts.ai.MELEE_RADIUS_SQ ) then	
            qts.ai.freeze(self.object, true, false)
			qts.ai.face(self.object, self.target_pos, true, false)
			self:play_animation("mine")
			
            local luaentity = self.target_objref:get_luaentity()
            if (luaentity) then
		        local item = ItemStack(luaentity.itemstring)
		        self.target_objref:remove()
		        self.wielded_item = item:to_string()
                
                --this does nothing yet
                self.texture_is_dirty = true
                
                self.target_objref=false
                self.target_pos = false
                self.target_id = false
                self.target_type = "none"
            end
		end
	end
})

--[[
	Module that causes the creature to move towards its target. Only uses the target position
]]
modules.move_to_target = qts.ai.register_module("mobs:move_to_target", {
	depends_properties = {
		target_id = false,
		target_pos = false,

		move_to_priority = qts.ai.priority.MED,
		speed = 1,
	},
	on_step = function (self, dtime, moveresult)
		if (self.target_pos) then
			self:run_task(self.move_to_priority, function(self, dtime, moveresult)
				if (self.target_pos) then
					local dist = vector.distancesq(self.target_pos, self.object:get_pos())
					if dist > qts.ai.MELEE_RADIUS_SQ then
						--minetest.log("player going to be attacked.")
						self:play_animation("walk")
						qts.ai.walk_to(self.object, self.target_pos, self.speed, true, 1, false)
					else
						qts.ai.freeze(self.object, true, false)
						--self.object:set_velocity({x=0,y=0,z=0}) --freeze
						qts.ai.face(self.object, self.target_pos, true, false)
						self:play_animation("stand")
						self:set_current_task_priority(qts.ai.priority.NONE) --drop our priority so other things can preempt the movement
						--if self.attack_timer <= 0 then
						--	--minetest.log("ATTACK PLAYER!")
						--	self:punch(self.target_objref)
						--	self.attack_timer = 1
						--end
					end
				else
					--stand around if no target
					qts.ai.freeze(self.object, true, false)
					self:play_animation("stand")
					self:set_current_task_priority(qts.ai.priority.NONE) --drop our priority so other things can preempt this
				end
			end)
		end	
	end
})





--[[
	Module that causes creatures to be able to find a target that is an entity. By default, it targets the nearest entity.

Targets can be of type:
	"none" - no target
	"player" - the target is a player
	"entity" - the target is a arbitrary entity
	"creature" -  the target is a qts creature
	"item" -  the target is a builtin item
	"node" - [UNIMPLEMENTED] - the target is a specific node
	"point"  - [UNIMPLEMENTED] - the target is a arbitrary point

]]
modules.target_finder = qts.ai.register_module("mobs:target_finder", {
	depends_properties = {
		view_radius_small = 8,
		view_radius = 16,
		view_radius_far = 32,

		target_id = false,
		target_pos = false,
		target_objref = false,
		target_type = "none",

		target_task_priority = qts.ai.priority.MED,

		can_target = function(self, object)
			--return the inverse distance to the object. This makes it target the nearest object
			return self.view_radius*self.view_radius - vector.distancesq(self.object:get_pos(), object:get_pos())
		end
	},
	on_step = function (self, dtime, moveresult)

		if not (self.target_id) and self.can_target ~= nil and type(self.can_target) == "function" then
			self:run_task(self.target_task_priority, function(self, dtime, moveresult)
				if not (self.target_id) and self.can_target ~= nil and type(self.can_target) == "function" then
					local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius)
					local highest_score = 0
					local highest_index = 0
					for i, obj in ipairs(objs) do
						local score = self:can_target(obj)
						if score > highest_score then
							highest_score = score
							highest_index = i
						end
					end
					if (highest_index > 0) then --entirely possible to not find a target
						self.target_id = qts.get_object_id(objs[highest_index])
						self.target_pos = objs[highest_index]:get_pos()
						self.target_objref = objs[highest_index]
						self.target_type = mobs.get_object_target_type(objs[highest_index])
						self:clear_current_task() --clear the current task
					end
				end	
			end)
		end
	end
})

--[[
	Module to cause the creature to track what it has targeted, constantly updating its position and objref
]]
modules.target_tracking = qts.ai.register_module("mobs:target_tracking", {
	depends_properties = {
		view_radius_small = 8, -- the radius at which new targets are tracked, if they cannot be seen
		view_radius = 16, -- the radius at which new targets are tracked
		view_radius_far = 32, --the radius at which tracked targets are untracked
		
		target_id = false, --no target id
		target_pos = false, --no targeted position
		target_objref = false, --objref that MUST be updated or made invalid
		target_type = "none",
		
		ticks_between_target_update = 16, --when not tracking a player, use this many ticks between re-scans
		ticks_offset_target_update=0, --when not tracking a player, use this offset for re-scans

		should_track_target = true, --if false, the target is not tracked. can be turned off for optimization
	},
	on_step = function(self, dtime, moveresult)
		--only do this stuff if there is a target
		if self.target_id and self.should_track_target then
			if self.target_type == "player" then
				-- player targets can get their locations directly, and check the distance
				local playerref = minetest.get_player_by_name(self.target_id)
				local dist = vector.distancesq(playerref:get_pos(), self.object:get_pos())
				if (dist <= self.view_radius_far*self.view_radius_far) then
					self.target_pos = playerref:get_pos()
					self.target_objref = playerref
				else
					self.target_id = false
					self.target_pos = false
					self.target_objref = false
					self.target_type = "none"
				end
			elseif mobs.get_is_target_type_mobile(self.target_type) then
				-- non-player targets have to scan the nearby objects
				if self.TICK_COUNT % self.ticks_between_target_update == self.ticks_between_target_update then
					--rescan nearby region and get the target's position
					local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius_far)
					local found_target = false
					for i, obj in ipairs(objs) do
						if qts.get_object_id(obj) == self.target then
							self.target_pos = obj:get_pos() --guaranteed to be within the view radius, only objects within that radius are considered.
							self.target_objref = obj
							found_target = true
							break
						end
					end
					if not found_target then
						self.target_id = false
						self.target_pos = false
						self.target_objref = false
						self.target_type = "none"
					end
				end
			end
		end
	end
})

--[[
	Module to cause the creature to Only target the player
	Depends on module.target_finder 
]]
modules.target_player_only = qts.ai.register_module("mobs:target_player_only", {
	reqired_properties = {
		can_target = function(self, object)
			--return the inverse distance to the object. This makes it target the nearest object
			if object:is_player() and qts.ai.does_detect_player(self.object, object, self.view_radius_small, self.view_radius) then
				return self.view_radius*self.view_radius - vector.distancesq(self.object:get_pos(), object:get_pos())
			else
				return 0
			end
		end
	},
	required_modules = {
		modules.target_finder
	}
})

--[[
	Enabled the ability for multiple modules to find targets without clobbering each other
]]
modules.muti_target_finding = qts.ai.register_module("mobs:multi_target_finding", {
	depends_properties = {
		view_radius_small = 8,
		view_radius = 16,
		view_radius_far = 32,

		target_id = false,
		target_pos = false,
		target_objref = false,
		target_type = "none",

		target_task_priority = qts.ai.priority.MED,

		check_target_every_frame = false, -- set to true to force the system to find a new targe every frame
		check_target_dirty = false, --set to true to force the system to find a new target even if it currently has one

		targeting_funcs = {}
	},

	reqired_properties = {
		---assign a targeting function to the list.
		--[[
			Targeting functions return a score
		]]
		---@param self table
		---@param targeting_func function
		add_targeting_func = function(self, targeting_func)
			self.targeting_funcs[#self.targeting_funcs+1] = targeting_func
		end,

		get_target = function(self, dtime, moveresult)
			local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius)
			local highest_score = 0
			local highest_index = 0
			for i, obj in ipairs(objs) do
				for j, targeting_func in ipairs(self.targeting_funcs) do
					local score = targeting_func(self, obj)
					if score > highest_score then
						highest_score = score
						highest_index = i
					end
				end
			end
			if (highest_index > 0) then --entirely possible to not find a target
				self.target_id = qts.get_object_id(objs[highest_index])
				self.target_pos = objs[highest_index]:get_pos()
				self.target_objref = objs[highest_index]
				self.target_type = mobs.get_object_target_type(objs[highest_index])
				self.check_target_dirty = false
				if self:is_in_task() then
					self:clear_current_task() --clear the current task
				end
			end
		end,
	},

	on_activate = function(self, data, dtime_s)
		self.targeting_funcs = {} --clear this every time!
	end,

	on_step = function (self, dtime, moveresult)

		if self.check_target_every_frame or self.check_target_dirty then
			self:get_target(dtime, moveresult)
		elseif not (self.target_id) then
			self:run_task(self.target_task_priority, self.get_target)
		end
	end
})

--[[
    module to target the player
    depends on modules.multi_target_finding
]]
modules.target_player = qts.ai.register_module("mobs:target_player", {
	depends_properties={
		target_player_priority_mult=1
	},
	required_modules ={
		modules.muti_target_finding
	},
	on_activate = function(self, data, dtime_s)
		self:add_targeting_func(function(self, object)
			--return the inverse distance to the object. This makes it target the nearest object
			if object:is_player() and qts.ai.does_detect_player(self.object, object, self.view_radius_small, self.view_radius) then
				return (self.view_radius*self.view_radius - vector.distancesq(self.object:get_pos(), object:get_pos())) * self.target_player_priority_mult
			else
				return 0
			end
		end)
	end
})

--[[
    module to target dropped items
    depends on modules.multi_target_finding
]]
modules.target_item = qts.ai.register_module("mobs:target_item", {
	depends_properties={
		target_item_priority_mult=1,
        wielded_item="",
        target_items_only_when_not_holding_item = false,
        target_items_only_if_weapon = false
	},
	required_modules ={
		modules.muti_target_finding
	},
	on_activate = function(self, data, dtime_s)
		self:add_targeting_func(function(self, object)
			--return the inverse distance to the object. This makes it target the nearest object
			if (
                (self.wielded_item == "" or not self.target_items_only_when_not_holding_item) and 
                qts.object_name(object) == "__builtin:item"
            ) then
                if (self.target_items_only_if_weapon) then
                    local luaentity = object:get_luaentity()
                    if not (luaentity) then
                        return 0
                    end
					local item = ItemStack(luaentity.itemstring)
					local itemdef = minetest.registered_items[item:get_name()]
					if not itemdef then
                        return 0
                    end
					if not (
						itemdef.tool_capabilities and 
						itemdef.tool_capabilities.damage_groups and 
						itemdef.tool_capabilities.damage_groups.fleshy and
						itemdef.tool_capabilities.damage_groups.fleshy ~= 0)
                    then
                        return 0
                    end 
                end
				return (self.view_radius*self.view_radius - vector.distancesq(self.object:get_pos(), object:get_pos())) * self.target_item_priority_mult
			else
				return 0
			end
		end)
	end
})

