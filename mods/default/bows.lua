--[[
This is where bow definitions will be made

--]]

--[[

def is a table with values:
{
	--from regular entities
	visual
	visual_size
	textures
	use_texture_alpha
	spritediv
	initial_sprite_basepos
	backface_culling
	glow
	automatic_rotate
	automatic_face_movement_dir
	automatic_face_movement_max_rotation_per_sec
	
	--custom
	radius = radius of projectile
	selectable = boolean can player select
	gravity_scale = number - scale of the gravity. default: 1
	collectable = itemstring given to player when walked over an inactive one
	lifetime = how long (seconds) the projectile should live
	speed = number - how fast the projectile goes
	damage_groups = {damagetype = value}
	
	--callbacks
	on_strike_node = function(self, pos, node) - called when striking a node
	on_strike_entity = function(self, objref) - called when striking an entity
	on_timeout = function(self) - called when timed out
	on_step = function(self, dtime) - called every frame. does not override builtin on_step function, but runs inside of it
	
}
]]

qts.register_projectile("default:arrow_projectile", {
    visual="mesh",
    visual_size = vector.new(5,5,5),
    textures = {"default_arrow.png"},
    use_texture_alpha=false,
    mesh ="arrow.obj",
    automatic_rotate=0,
    automatic_face_movement_dir=1.0,
    automatic_face_movement_max_rotation_per_sec=1.0,

    radius = 0.25,
    selectable = false,
    gravity_scale = 0.5,
    collectable = false, --TO CHANGE
    lifetime=60*5,
    speed = 20,
    damage_groups = {fleshy=8},

    on_strike_node = qts.projectile_default_struck_node,
    on_strike_entity = qts.projectile_default_struck_entity,
    on_timeout = qts.projectile_default_timeout,
    on_step = function(self, dtime) end,
})

minetest.register_tool("default:testing_bow", {
	description = "Testing Bow",
	inventory_image = "default_bow1.png",
	--on_secondary_use = function(itemstack, user, pointed_thing)
		--qts.projectile_launch_player("default:arrow_projectile", user, 0)

    --end,
    on_long_secondary_use = function(itemstack, user)
        --minetest.log("LONG USE")
        local next_stage = ItemStack("default:testing_bow_s2")
        next_stage:set_wear(itemstack:get_wear())
        return next_stage
    end,
    --on_stop_secondary_use = function(itemstack, user)
    --    minetest.log("stopped secondary use")
    --end,
})

minetest.register_tool("default:testing_bow_s2", {
	description = "Testing Bow",
	inventory_image = "default_bow2.png",
    groups = {not_in_creative_inventory=1},
	on_long_secondary_use = function(itemstack, user)
        --minetest.log("LONG USE")
        local next_stage = ItemStack("default:testing_bow_s3")
        next_stage:set_wear(itemstack:get_wear())
        return next_stage
    end,
    on_stop_secondary_use = function(itemstack, user)
        --minetest.log("stopped secondary use")
        local next_stage = ItemStack("default:testing_bow")
        next_stage:set_wear(itemstack:get_wear())
        return next_stage
    end,
})

minetest.register_tool("default:testing_bow_s3", {
	description = "Testing Bow",
	inventory_image = "default_bow3.png",
    groups = {not_in_creative_inventory=1},
	
    on_stop_secondary_use = function(itemstack, user)
        --minetest.log("stopped secondary use")
        qts.projectile_launch_player("default:arrow_projectile", user, 0)
        local next_stage = ItemStack("default:testing_bow")
        next_stage:set_wear(itemstack:get_wear())
        return next_stage
    end,
})