--[[
    Definition of many common modules 
]]

mobs.modules = {}
local modules = mobs.modules

local mobs_actually_target_player = true
if qts.ISDEV then
	minetest.register_chatcommand("set_mob_target_player", {
		params = "<yes/no>",
		description = "toggles common mobs from targeting player.",
		func = function(name, param)
			mobs_actually_target_player = minetest.is_yes(param)
			return true
		end
	})

end

---Dummy function to get an item's score
---@param self table
---@param itemname ItemStack
---@return number
local function get_item_score_func(self, itemname)
	return 1
end

mobs.static_target_types = {
    node = true,
	point = true,
}

---Check if a given target type is a mobile object
---@param target_type TargetType
---@return boolean
function mobs.get_is_target_type_static(target_type)
	return qts.select(mobs.static_target_types[target_type], true, false) 
end

local function reset_target_func(self)
	self.target_id = false
	self.target_pos = false
	self.target_objref = false
	self.target_type = "none"
end

---Dummy function to get an item's score
---@param self table
---@param itemname ItemStack
---@return number
local function get_item_score_func(self, itemname)
	return 1
end

--[[
	Module that gives the creature the Punch ability. It can punch.
]]
modules.punch = qts.ai.register_module("mobs:punch", {
	---@class CreatureLuaEntity_Implements_Punch_Partial : CreatureLuaEntity
	depends_properties={
		wielded_item=""
	},
	---@class CreatureLuaEntity_Implements_Punch : CreatureLuaEntity_Implements_Punch_Partial
	reqired_properties={
		---Punch another entity
		---@param self CreatureLuaEntity_Implements_Punch
		---@param target ObjectRef
		punch = function(self, target)
			local tool_capabilities = {}
			if self.wielded_item then
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
	---@class CreatureLuaEntity_Implements_PunchTarget : CreatureLuaEntity_Implements_Punch
	depends_properties={
		punch_priority = qts.ai.priority.MED+5,
		attack_timer = 0,
		attack_timer_reset =1,
        punch_target_types = {player=true, creature=true},
	},
	required_modules ={
		modules.punch
	},
	---module on_step
	---@param self CreatureLuaEntity_Implements_PunchTarget
	---@param dtime number
	---@param moveresult table
	on_step = function (self, dtime, moveresult)
		if (self.target_pos and self.punch_target_types[self.target_type] and vector.distancesq(self.target_pos, self.object:get_pos()) < qts.ai.MELEE_RADIUS_SQ ) then
			
			self:run_task(self.punch_priority, function(self--[[@type CreatureLuaEntity_Implements_PunchTarget]], dtime--[[@type number]], moveresult--[[@type table]])
				if self.target_pos and self.punch_target_types[self.target_type] and vector.distancesq(self.target_pos, self.object:get_pos()) < qts.ai.MELEE_RADIUS_SQ then
					---@type ObjectRef[]
					
					qts.ai.freeze(self.object, true, false)
					qts.ai.face(self.object, self.target_pos, true, false)
					self:play_animation("mine")
					if self.attack_timer <= 0 then
						local objects = minetest.get_objects_inside_radius(self.object:get_pos(), qts.ai.MELEE_RADIUS)
						for i, obj in ipairs(objects) do
							if qts.get_object_id(obj) == self.target_id then
								self.target_objref = obj
								break
							end
						end
						if type(self.target_objref) == "boolean" or self.target_objref == "false" then 
							self:clear_current_task()
						else
							self:punch(self.target_objref)
						end
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
	---@class CreatureLuaEntity_Implements_ItemTextures : CreatureLuaEntity
    depends_properties={
        texture_is_dirty=false,
        wielded_item="",
        base_textures = {""}
    },

	---module on_activate
	---@param self CreatureLuaEntity_Implements_ItemTextures
	---@param data table
	---@param dtime_s number
    on_activate = function(self, data, dtime_s)
        if data ~= nil then
            self.base_textures = data.base_textures or self.base_textures
        end
        self.texture_is_dirty = true
    end,

	---module get_staticdata
	---@param self CreatureLuaEntity_Implements_ItemTextures
	---@param data table
    get_staticdata = function(self, data)
        data.base_textures = self.base_textures
    end,

	---moduel on_step
	---@param self CreatureLuaEntity_Implements_ItemTextures
	---@param dtime number
	---@param moveresult table
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
	---@class CreatureLuaEntity_Implements_PickUpItem : CreatureLuaEntity_Implements_ItemTextures
	depends_properties={
        wielded_item="",
		wielded_item_score=0,
        texture_is_dirty=false,
		timer_till_pickup_again = 0,

		pickup_priority = qts.ai.priority.MED+15,
		get_item_score = get_item_score_func,
	},
	required_modules ={
		modules.item_textures
	},

	---moduel on_activate
	---@param self CreatureLuaEntity_Implements_PickUpItem
	---@param data table
	---@param dtime_s number
    on_activate = function(self, data, dtime_s)
        if data ~= nil then
            self.wielded_item = data.wielded_item or self.wielded_item
        end
    end,

	---module get_staticdata
	---@param self CreatureLuaEntity_Implements_PickUpItem
	---@param data table
    get_staticdata = function(self, data)
        data.wielded_item = self.wielded_item
    end,

	---module on entity death
	---@param self CreatureLuaEntity_Implements_PickUpItem
	---@param drops table
    on_death = function(self, drops)
        if self.wielded_item ~= "" then
            drops[#drops+1] = self.wielded_item
        end
    end,

	---module on_step
	---@param self CreatureLuaEntity_Implements_PickUpItem
	---@param dtime number
	---@param moveresult table
	on_step = function (self, dtime, moveresult)
		self.timer_till_pickup_again = self.timer_till_pickup_again - dtime --handle timer

		if (self.timer_till_pickup_again <= 0 and self.target_objref and self.target_pos and self.target_type== "item" and vector.distancesq(self.target_pos, self.object:get_pos()) < qts.ai.MELEE_RADIUS_SQ ) then	
            qts.ai.freeze(self.object, true, false)
			qts.ai.face(self.object, self.target_pos, true, false)
			self:play_animation("mine")

            local luaentity = self.target_objref:get_luaentity()
            if (luaentity) then
				--we will pickup or ignore, but either way, the target should be cleared.
				
				local item = ItemStack(luaentity.itemstring)
				local score = self:get_item_score(item)
				if (self.wielded_item ~= "") then
					if (score > self.wielded_item_score ) then
						--drop any existing held item
						minetest.add_item(self.object:get_pos(), self.wielded_item)
					else
						--wow, the held item is a greater priority. Don't drop it!
						self.timer_till_pickup_again = 1
						self:reset_target()
						return --cancel the pickup!
					end
				end
				self.wielded_item_score = score
				if self.target_objref then self.target_objref:remove() end
		        self.wielded_item = item:to_string()
                self.texture_is_dirty = true
				
				self.timer_till_pickup_again = 1 -- can only pickup things every second, to prevent pickup loops
				self:reset_target()
            end
		end
	end
})

--[[
	Module that causes the creature to move towards its target. Only uses the target position
]]
modules.move_to_target = qts.ai.register_module("mobs:move_to_target", {
	---@class CreatureLuaEntity_Implements_MoveToTarget : CreatureLuaEntity
	depends_properties = {
		move_to_priority = qts.ai.priority.MED,
		speed = 1,
		view_radius_small = 8, -- the radius at which new targets are tracked, if they cannot be seen
		view_radius = 16, -- the radius at which new targets are tracked
		view_radius_far = 32, --the radius at which tracked targets are untracked
		
		ticks_between_target_update = 16, --when not tracking a player, use this many ticks between re-scans
		ticks_offset_target_update=0, --when not tracking a player, use this offset for re-scans

		should_track_target = true, --if false, the target is not tracked. can be turned off for optimization

		---Task function to move to the target
		---@param self CreatureLuaEntity_Implements_MoveToTarget
		---@param dtime number
		---@param moveresult table
		move_to_task = function(self, dtime, moveresult)
			
			--target tracking
			if self.should_track_target then
				if self.target_id and self.target_objref==false then
					if self.target_type == "player" then
						-- player targets can get their locations directly, and check the distance
						local playerref = minetest.get_player_by_name(self.target_id)
						local dist = vector.distancesq(playerref:get_pos(), self.object:get_pos())
						if (dist <= self.view_radius_far*self.view_radius_far) then
							self.target_pos = playerref:get_pos()
							self.target_objref = playerref
						else
							self:reset_target()
						end
					elseif qts.ai.get_is_target_type_mobile(self.target_type) then
						-- non-player targets have to scan the nearby objects
						if self.TICK_COUNT % self.ticks_between_target_update == self.ticks_between_target_update then
							--rescan nearby region and get the target's position
							local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius_far)
							local found_target = false
							for i, obj in ipairs(objs) do
								if qts.get_object_id(obj) == self.target_id then
									self.target_pos = obj:get_pos() --guaranteed to be within the view radius, only objects within that radius are considered.
									self.target_objref = obj
									found_target = true
									break
								end
							end
							if not found_target then
								self:reset_target()
							end
						end
					end
				elseif self.target_objref ~= false then --if we already have the target objectref (which means it was found and set earlier this step) we don't need to find it
					self.target_pos = self.target_objref:get_pos()
				end
			end

			--actual movement
			if (self.target_pos) then
				local dist = vector.distancesq(self.target_pos, self.object:get_pos())
				if dist > qts.ai.MELEE_RADIUS_SQ then
					self:play_animation("walk")
					qts.ai.walk_to(self.object, self.target_pos, self.speed, true, 1, false)
				else
					qts.ai.freeze(self.object, true, false)
					qts.ai.face(self.object, self.target_pos, true, false)
					self:play_animation("stand")
					self:set_current_task_priority(qts.ai.priority.NONE) --drop our priority so other things can preempt the movement
				end
			else
				--stand around if no target
				qts.ai.freeze(self.object, true, false)
				self:play_animation("stand")
				self:set_current_task_priority(qts.ai.priority.NONE) --drop our priority so other things can preempt this
			end
		end
	},

	---module on_step function
	---@param self CreatureLuaEntity_Implements_MoveToTarget
	---@param dtime number
	---@param moveresult table
	on_step = function (self, dtime, moveresult)
		if (self.target_pos) then
			self:run_task(self.move_to_priority, self.move_to_task)
		end	
	end
})


--[[
	Enabled the ability for multiple modules to find targets without clobbering each other
]]
modules.target_finding_objref = qts.ai.register_module("mobs:target_finding_objref", {
	
	---@class CreatureLuaEntity_Implements_TargetFindObjref_Part : CreatureLuaEntity
	depends_properties = {
		view_radius_small = 8,
		view_radius = 16,
		view_radius_far = 32,

		target_task_priority = qts.ai.priority.MED,

		allow_object_targeting = true, --set to false to disable the multitarget targeting
		check_target_every_frame = false, -- set to true to force the system to find a new targe every frame
		check_target_dirty = false, --set to true to force the system to find a new target even if it currently has one
		should_find_obj_target_if_tracking_static_target = true, --if false, and tracking a static target (IE, node, pos, etc) then don't find a new target
		
		ticks_between_object_target_selection = 8, --when not tracking a player, use this many ticks between re-scans
		ticks_offset_object_target_selection=1, --when not tracking a player, use this offset for re-scans

		targeting_funcs = {},
	},

	---@class CreatureLuaEntity_Implements_TargetFindObjref : CreatureLuaEntity_Implements_TargetFindObjref_Part
	reqired_properties = {
		---assign a targeting function to the list.
		--[[
			Targeting functions return a score
		]]
		---@param self CreatureLuaEntity_Implements_TargetFindObjref
		---@param targeting_func function
		add_targeting_func = function(self, targeting_func)
			self.targeting_funcs[#self.targeting_funcs+1] = targeting_func
		end,

		---get a target
		---@param self CreatureLuaEntity_Implements_TargetFindObjref
		---@param dtime number
		---@param moveresult table
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
				self.target_type = qts.ai.get_object_target_type(objs[highest_index])
				if self:is_in_task() then
					self:clear_current_task() --clear the current task
				end
			end
			self.check_target_dirty = false
		end,
	},

	---module on_activate
	---@param self CreatureLuaEntity_Implements_TargetFindObjref
	---@param data table
	---@param dtime_s number
	on_activate = function(self, data, dtime_s)
		self.targeting_funcs = {} --clear this every time!
	end,

	---module on_step
	---@param self CreatureLuaEntity_Implements_TargetFindObjref
	---@param dtime number
	---@param moveresult table
	on_step = function (self, dtime, moveresult)
		if (self.allow_object_targeting and 
		   (self.should_find_obj_target_if_tracking_static_target or 
			not  qts.ai.get_is_target_type_static(self.target_type)) and
			self.TICK_COUNT % self.ticks_between_object_target_selection == self.ticks_offset_object_target_selection)
		then
			if self.check_target_every_frame or self.check_target_dirty then
				self:get_target(dtime, moveresult)
			elseif not (self.target_id) then
				self:run_task(self.target_task_priority, self.get_target)
			end
		end
	end
})

--[[
    module to target the player
    depends on modules.multi_target_finding
]]
modules.target_player = qts.ai.register_module("mobs:target_player", {
	---@class CreatureLuaEntity_Implements_TargetPlayer : CreatureLuaEntity_Implements_TargetFindObjref
	depends_properties={
		target_player_priority_mult=1
	},
	required_modules ={
		modules.target_finding_objref
	},
	---module on_activate
	---@param self CreatureLuaEntity_Implements_TargetPlayer
	---@param data table
	---@param dtime_s number
	on_activate = function(self, data, dtime_s)
		self:add_targeting_func(function(self, object)
			if (not mobs_actually_target_player) then return 0 end
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
	---@class CreatureLuaEntity_Implements_TargetItem : CreatureLuaEntity_Implements_TargetFindObjref
	depends_properties={
		target_item_priority_mult=1,
        wielded_item="",
		wielded_item_score=0,
        target_items_only_when_not_holding_item = false,
		get_item_score = get_item_score_func,
	},
	required_modules ={
		modules.muti_target_finding
	},
	---module on_activate
	---@param self CreatureLuaEntity_Implements_TargetItem
	---@param data table
	---@param dtime_s number
	on_activate = function(self, data, dtime_s)
		self:add_targeting_func(function(self --[[@type CreatureLuaEntity_Implements_TargetItem ]], object--[[@type ObjectRef]])
			--return the inverse distance to the object. This makes it target the nearest object
			if (
                (self.wielded_item == "" or not self.target_items_only_when_not_holding_item) and 
                qts.object_name(object) == "__builtin:item"
            ) then
				local luaentity = object:get_luaentity()
				if not (luaentity) then
					return 0
				end
				
				local item = ItemStack(luaentity.itemstring)
				local itemdef = minetest.registered_items[item:get_name()]
				if not itemdef then
					return 0
				end

				local newscore = self:get_item_score(item, itemdef)
				if self.wielded_item ~= "" and newscore > 0 and newscore <= self.wielded_item_score then
					return 0
				end
				
				return (self.view_radius*self.view_radius - vector.distancesq(self.object:get_pos(), object:get_pos())) * self.target_item_priority_mult
			else
				return 0
			end
		end)
	end
})

modules.target_attacker = qts.ai.register_module("mobs:target_attacker", {
	---module on_punch
	---@param self CreatureLuaEntity
	---@param puncher ObjectRef
	---@param time_from_last_punch number
	---@param tool_capabilities table
	---@param dir Vector
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if (puncher) then
			self.target_id = qts.get_object_id(puncher)
			self.target_pos = puncher:get_pos()
			self.target_type= qts.select(puncher:is_player(), "player", "entity")
			
			--this is unsafe, the objref may be deleted.
			--self.target_objref = puncher
		end
	end
})
