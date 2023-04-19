--[[
	This mod contains most of the mob registrations
	
	the actual code that makes the mobs of questest work lives in qts
--]]
mobs = {}


dofile(minetest.get_modpath("mobs").."/modules.lua")

dofile(minetest.get_modpath("mobs").."/bandit.lua")




if qts.ISDEV then

qts.ai.register_creature("mobs:testing_humanoid", {
	initial_properties = {
		hp_max = 10,
		armor_groups = {fleshy = 0},
		level = 0,
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		collide_with_objects = true,
		visual = "mesh",
--		textures = {"player_base.png"},
		textures = {qts.make_humanoid_texture("player_base.png", nil, nil, nil, nil)},
		base_textures = {"player_base.png"},
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
		description = "Testing Humanoid",
		color1 = "#FFB973",
		color2 = "#B35900",
		pattern = "spots",
	}
})

end