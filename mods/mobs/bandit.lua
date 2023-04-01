--[[
    An actual bandi
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
	},

	modules = {
		qts.ai.module.damageable,
		qts.ai.module.gravity,
		mobs.modules.target_player, --set the player as the target
		mobs.modules.target_item, --set a dropped item as the target
		mobs.modules.target_tracking, --constantly update the target position
		mobs.modules.move_to_target, --actually cause it to move to the target
		mobs.modules.punch_target,  --cause the creature to punch its target
		mobs.modules.pickup_item, -- causes the creature to pickup targeted dropped items
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