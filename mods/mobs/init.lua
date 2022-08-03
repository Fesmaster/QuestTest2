--[[
	This mod contains most of the mob registrations
	
	the actual code that makes the mobs of questest work lives in qts
--]]
dofile(minetest.get_modpath("mobs").."/bandit.lua")

qts.ai.register_behavior("basic_humanoid_enemy", {
	texture_is_dirty = true,
	attack_timer = 1,
	target_creature = nil,
	target_pos = nil,
	
	on_step = function(self, dtime)
		
		if (self.texture_is_dirty) then
			local t = qts.humanoid_texture(self.object, self.default_textures[1])
			self.object:set_properties({textures = {t}})
			self.texture_is_dirty = false
		end
		
		self.attack_timer = self.attack_timer - dtime
		local pos = self.object:get_pos()
		
		local mindist = self.view_radius*self.view_radius
		local item_min_dist = self.view_radius*self.view_radius
		if (self.target_creature) then
			--pcall(function()
			if (vector.distancesq(pos, self.target_creature:get_pos()) > mindist) then
				self.target_creature = nil
			else
				mindist = vector.distancesq(pos, self.target_creature:get_pos())
			end
			--end)
			
		end
		--check for nearby entities and get nearest player
		--local target = nil

		local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius or 16)
		if (#objs > 1) then
			for i, obj in ipairs(objs) do
				--pcall(function()
				--check for nearby players
				if obj:is_player() and not self.target_creature then
					local dist = vector.distancesq(pos, obj:get_pos())
					if (dist < mindist) then
						minetest.log("here")
						mindist = dist
						self.target_creature = obj
						--minetest.log("target found")
					end
				end

				if qts.object_name(obj) == "__builtin:item" and not self.wielded_item then
					local luaentity = obj:get_luaentity()
					local item = ItemStack(luaentity.itemstring)
					local itemdef = minetest.registered_items[item:get_name()]
					if itemdef then
						if 
							itemdef.tool_capabilities and 
							itemdef.tool_capabilities.damage_groups and 
							itemdef.tool_capabilities.damage_groups.fleshy and
							itemdef.tool_capabilities.damage_groups.fleshy ~= 0 
						then
							local d = vector.distancesq(pos, obj:get_pos())
							if d < item_min_dist then
								item_min_dist = d
								self.targeted_item = obj
							end
						end
					end

					--minetest.log("Nearby Item Name: " .. dump(stack:get_name()))
				end
				--check for nearby items to pick up, if nothing is held.
				--return false
				--end)
			end
		end
		--if found, move to them, or, if in melee range, attack them.
		if self.targeted_item then
			--always grab a weapon first
			if item_min_dist > qts.ai.MELEE_RADIUS*qts.ai.MELEE_RADIUS then
				--minetest.log("player going to be attacked.")
				self:play_animation("walk")
				qts.ai.walk_to(self.object, self.targeted_item:get_pos(), self.speed, true, 1, false)
			else
				local luaentity = self.targeted_item:get_luaentity()
				local item = ItemStack(luaentity.itemstring)
				self.targeted_item:remove()
				self.wielded_item = item:to_string()
				self.texture_is_dirty = true
				self.targeted_item=nil
			end
		elseif (self.target_creature) then
			--pcall(function()
			if mindist > qts.ai.MELEE_RADIUS*qts.ai.MELEE_RADIUS then
				--minetest.log("player going to be attacked.")
				self:play_animation("walk")
				qts.ai.walk_to(self.object, self.target_creature:get_pos(), self.speed, true, 1, false)
			else
				qts.ai.freeze(self.object, true, false)
				--self.object:set_velocity({x=0,y=0,z=0}) --freeze
				qts.ai.face(self.object, self.target_creature:get_pos(), true, false)
				self:play_animation("stand")
				if self.attack_timer <= 0 then
					--minetest.log("ATTACK PLAYER!")
					self:punch(self.target_creature)
					self.attack_timer = 1
				end
			end
			--end)
		else
			--stand around if no enemy nearby
			qts.ai.freeze(self.object, true, false)
			self:play_animation("stand")
		end
		--check for somthing to pick up
	end,
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
			target:punch(self.object, 1, tool_capabilities, self.object:get_pos() - target:get_pos())
		end
	end,
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)

	end,
	on_rightclick = function(self, clicker)
		
	end,
	on_activate = function(self, staticdata, dtime_s)
		minetest.log("STATICDATA: " .. staticdata)
		if staticdata ~= "" then
			local savedata = minetest.deserialize(staticdata)
			if savedata then
				--weilded item
				if savedata.wielded_item then
					self.wielded_item = savedata.wielded_item
				end

			end
		end

		local t = qts.humanoid_texture(self.object, self.default_textures[1])
		self.object:set_properties({textures = {t}})
	end,
	get_staticdata = function(self)
		local savedata = {}
		--weilded item
		if self.wielded_item then
			savedata.wielded_item = self.wielded_item
		end
		local staticdata = minetest.serialize(savedata)
		minetest.log("STATICDATA: " .. staticdata)
		return staticdata
	end
})

qts.ai.register_creature("mobs:testing_humanoid", {
	hp_max = 10,
	armor_groups = {fleshy = 100},
	level = 0,
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	collide_with_objects = true,
	visual = "mesh",
	textures = {"player_base.png"},
	mesh = "character.x",
	visual_size = {x=1, y=1, z=1},
	makes_footsteps_sounds = true,
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160},
	},
	
	use_texture_alpha = true,
	
	behavior = "basic_humanoid_enemy",
	speed = 2,
	view_radius = 8,
	gravity_scale = 1,
	
	spawnegg = {
		description = "Testing Humanoid",
		color1 = "#FFB973",
		color2 = "#B35900",
		pattern = "spots",
	}
})
