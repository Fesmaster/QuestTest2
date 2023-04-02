--[[
    This file creates the first real enemy in QuestTest2: the Bandit!
]]

local bandit_wanter_module = qts.ai.register_module("mobs:bandit_patrole_target", {
    depends_properties={
		target_id = false,
        target_pos = false,
        target_objref = false,
        target_type = "none",
        view_radius = 16,
        
        time_since_last_patrole = 0,
        max_patrole_interval = 15,

        reset_target = function(self)
			self.target_id = false
			self.target_pos = false
			self.target_objref = false
			self.target_type = "none"
		end
    },
	required_modules ={
		
	},
	on_step = function (self, dtime, moveresult)
        if (self.time_since_last_patrole > self.max_patrole_interval) then
            if (self.target_type == "none" or self.target_type == "node") then
                local near_points = qts.get_nodes_in_radius(self.object:get_pos(), self.view_radius_far, {"group:bandit_waypoint"})
                if near_points then
                    local ref = near_points[math.random(#near_points)]
                    if (ref and ref.pos) then
                        ---@type TargetType
                        self.target_type="node"
                        self.target_pos = ref.pos + vector.new(math.random(-1,1), 0, math.random(-1,1))
                        self.time_since_last_patrole = 0
                    end
                end
            end
        else
            self.time_since_last_patrole = self.time_since_last_patrole + dtime
        end
    end
})

--[[
    An actual bandit
]]
qts.ai.register_creature("mobs:basic_bandit", {
	initial_properties = {
		hp_max = 10,
		armor_groups = {fleshy = 0},
		level = 0,
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		collide_with_objects = true,
		visual = "mesh",
--		textures = {"player_base.png"},
		textures = {qts.make_humanoid_texture("bandit_base.png", nil, nil, nil, nil)},
		base_textures = {"bandit_base.png"},
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
		static_save = true,
		is_visible = true,
		physical = true,

		use_texture_alpha = true,

		speed = 2,

		view_radius_small = 4,
		view_radius = 8,
		view_radius_far = 16,
		
		gravity_scale = 1,

		target_item_priority_mult=100, -- make dropped items WAY more interesting
		check_target_every_frame = true, --force check target every frame, so AI can be distracted
        target_items_only_if_weapon = false,
	},

	modules = {
		qts.ai.module.damageable,
		qts.ai.module.gravity,
		mobs.modules.target_player, --set the player as the target
		mobs.modules.target_item, --set a dropped item as the target
        bandit_wanter_module, --bandits wander between certain nodes, like chests and fires.
		mobs.modules.move_to_target, --actually cause it to move to the target
		mobs.modules.target_tracking, --constantly update the target position
		mobs.modules.punch_target,  --cause the creature to punch its target
		mobs.modules.pickup_item, -- causes the creature to pickup targeted dropped items
		mobs.modules.target_attacker, -- causes the creature to target whatever attacks it
        
        --inline module! cause you can do that!!!
        qts.ai.register_module("mobs:bandit_goldenfingers", {
            depends_properties ={
                wielded_item = "",
                view_radius_far=32,
                flee_speed = 4,
            },
            reqired_properties = {
                get_item_score = function(self, itemstack)
                    if minetest.get_item_group(itemstack:get_name(), "gold") ~= 0 then 
                        return 2
                    end
                    return 1
                end
            },
            on_step = function (self, dtime, moveresult)
                if minetest.get_item_group(ItemStack(self.wielded_item):get_name(), "gold") ~= 0 then 
                    --RUN AWAY
                    ---@type ObjectRef[]
                    local objs = minetest.get_objects_inside_radius(self.object:get_pos(), self.view_radius_far)
                    local nearest_index = 0
                    local nearest_dist = (self.view_radius_far*self.view_radius_far)+1
                    for i, obj in ipairs(objs) do
                        if  obj:is_player() then
                            ---@cast obj Player
                            local dist = vector.distancesq(self.object:get_pos(), obj:get_pos())
                            if dist < nearest_dist then
                                nearest_dist = dist
                                nearest_index = i
                            end
                        end
                    end
                    if nearest_index ~= 0 then
                        ---@type Vector
                        local direction = self.object:get_pos() - objs[nearest_index]:get_pos();
                        ---@type Vector
                        local targetpos = self.object:get_pos() + vector.normalize(direction)*self.view_radius_far
                        ---@type Vector
                        local foundTargetPos = qts.ai.get_random_navagatable_point_in_radius(targetpos, self.view_radius_small, {airlike=true}, 2)
                        if foundTargetPos then
                            self.target_pos = foundTargetPos
                            ---@type TargetType
                            self.target_type = "point"
                            self.allow_multarget_targeting = false
                            
                            self.normal_speed = self.speed
                            self.speed = self.flee_speed
                        end
                    end
                end
            end
        })
	},
	
	spawnegg = {
		description = "Bandit",
		color1 = "#FFB973",
		color2 = "#B35900",
		pattern = "spots",
        spawner_config = "mobs:spawnconfig_bandit",
	}
})


qts.ai.register_spawner_config("mobs:spawnconfig_bandit", {
    entity_name = "mobs:basic_bandit"
})

--list of items that bandists can spawn holding, when using the weapon spawnconfig
local bandit_weapons = {
    "default:knife_flint",
    "default:knife_rusted",
    "default:knife_copper",
    "default:knife_bronze",
    "default:axe_flint",
    "default:axe_rusted",
    "default:axe_copper",
    "default:axe_bronze",
    "default:sword_rusted",
    "default:sword_copper",
    "default:sword_bronze",
}

qts.ai.register_spawner_config("mobs:spawnconfig_bandit_weapons", {
    entity_name = "mobs:basic_bandit",
    ---On Spawn callback
    ---@param spawnerpos Vector
    ---@param objref LuaEntity
    on_spawn = function(spawnerpos, objref)
        local luaentity = objref:get_luaentity();
        if luaentity.wielded_item == nil or luaentity.wielded_item=="" then
            luaentity.wielded_item = bandit_weapons[math.random(#bandit_weapons)]
        end
    end
})