
qts.ai.register_behavior("bandit_enemy", {
	texture_is_dirty = true,
	attack_timer = 1,
	target_creature = nil,
	target_pos = nil,
	
	--the tool_capabilities for the bandit empty hand
	hand = {
		full_punch_interval = 1,
		max_drop_level = 1,
		groupcaps ={},
		damage_groups = {fleshy=2},
	},
	
	on_step = function(self, dtime)
		
		if (self.texture_is_dirty) then
			local t = qts.humanoid_texture(self.object, self.default_textures[1])
			self.object:set_properties({textures = {t}})
			self.texture_is_dirty = false
		end
		
		self.attack_timer = self.attack_timer - dtime
		local pos = self.object:get_pos()
		
		local mindist = self.view_radius*self.view_radius
		if (self.target_creature) then
			pcall(function()
				if (vector.distancesq(pos, self.target_creature:get_pos()) > mindist) then
					self.target_creature = nil
				end
			end)
		end
		--check for nearby entities and get nearest player
		--local target = nil
		local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius or 16)
		if (#objs > 1) then
			for i, obj in ipairs(objs) do
				pcall(function()
					--check for nearby players
					if (obj:is_player()) and (not self.target_creature) then
						local dist = vector.distancesq(pos, obj:get_pos())
						if (dist < mindist) then
							mindist = dist
							self.target_creature = obj
							--minetest.log("target found")
						end
					end
					--check for nearby items to pick up, if nothing is held.
					return false
				end)
			end
		end
                                         
		--if found, move to them, or, if in melee range, attack them.
		if (self.target_creature) then
			pcall(function()
				if mindist > qts.ai.MELEE_RADIUS*qts.ai.MELEE_RADIUS then
					--minetest.log("player going to be attacked.")
					self:play_animation("walk")
					qts.ai.walk_to(self.object, target:get_pos(), self.speed, true, 1, false)
				else
					qts.ai.freeze(self.object, true, false)
					
					qts.ai.face(self.object, target:get_pos(), true, false)
					self:play_animation("mine")
					if self.attack_timer <= 0 then
						minetest.log("ATTACK PLAYER!")
						self.attack_timer = 1
					end
				end
			end)
		else
			--stand around if no enemy nearby
			qts.ai.freeze(self.object, true, false)
			self:play_animation("stand")
		end
		--check for somthing to pick up
	end,
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		
	end,
	on_rightclick = function(self, clicker)
		
	end,
	on_activate = function(self, staticdata, dtime_s)
		local t = qts.humanoid_texture(self.object, self.default_textures[1])
		self.object:set_properties({textures = {t}})
	end,
	get_staticdata = function(self)
		return ""
	end,
})

--[[
qts.ai.register_creature("mobs:testing_humanoid", {
	hp_max = 10,
	armor_groups = {fleshy = 100},
	level = 0,
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	collide_with_objects = true,
	visual = "mesh",
	textures = {"player_base.png"},
	mesh = "character2.b3d",
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
--]]
