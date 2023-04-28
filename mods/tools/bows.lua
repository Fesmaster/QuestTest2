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

qts.register_projectile("tools:arrow_projectile", {
    visual="mesh",
    visual_size = vector.new(5,5,5),
    textures = {"default_arrow.png"},
    use_texture_alpha=false,
    mesh ="arrow.obj",
    automatic_rotate=true,
    
    radius = 0.25,
    selectable = false,
    gravity_scale = 0.5,
    collectable = "tools:arrow 1", --TO CHANGE
    lifetime=60*5,
    speed = 20,
    damage_groups = {fleshy=8},

    on_strike_node = qts.projectile_default_struck_node,
    on_strike_entity = qts.projectile_default_struck_entity,
    on_timeout = qts.projectile_default_timeout,
    on_step = function(self, dtime) end,
})

minetest.register_craftitem("tools:arrow", {
	description = "Arrow",
	inventory_image = "default_arrow_item.png",
	groups = {ammunition = 1, arrow=1,},
    projectile = "tools:arrow_projectile",
})

qts.register_projectile("tools:arrow_gold_projectile", {
    visual="mesh",
    visual_size = vector.new(5,5,5),
    textures = {"default_arrow_gold.png"},
    use_texture_alpha=false,
    mesh ="arrow.obj",
    automatic_rotate=true,
    
    radius = 0.25,
    selectable = false,
    gravity_scale = 0.5,
    collectable = "tools:arrow_gold 1", --TO CHANGE
    lifetime=60*5,
    speed = 20,
    damage_groups = {fleshy=8},

    on_strike_node = qts.projectile_default_struck_node,
    on_strike_entity = qts.projectile_default_struck_entity,
    on_timeout = qts.projectile_default_timeout,
    on_step = function(self, dtime) end,
})

minetest.register_craftitem("tools:arrow_gold", {
	description = "Gold Arrow",
	inventory_image = "default_arrow_gold_item.png",
	groups = {ammunition = 1, arrow=1,},
    projectile = "tools:arrow_gold_projectile",
})


--[[
    Register a new bow  
    def contains:  
    description = "Bow",  
    inventory_images = {"stage1", "stage2", "stage3"},  
    groups = {},  
    draw_time = 1.5,  -- the full draw time of the bow. each stage is half.  
    inaccuracy = 0.5,  
    uses = 100,  
]]
local function register_bow(name, def)
    def.groups.bow = def.groups.bow or 1
    local groups_2 = qts.table_deep_copy(def.groups)
    groups_2.not_in_creative_inventory=1
    
    minetest.register_tool(name, {
    	description = def.description,
    	inventory_image = def.inventory_images[1],
        groups = def.groups,
        on_long_secondary_use = function(itemstack, user)
            --get an arrow from the inventory
            local inv = user:get_inventory()
            local wield_index = user:get_wield_index()
            local wield_list = user:get_wield_list()
            local arrow_index = 0
            local arrow_item = nil
            if inv then
                local list = inv:get_list(wield_list)
                for i=wield_index+1,inv:get_size(wield_list) do
                    local item = list[i]
                    if minetest.get_item_group(item:get_name(), "arrow") ~= 0 then
                        --we found our arrow
                        arrow_index = i
                        arrow_item = item
                        break
                    end
                end
                if (arrow_item) then
                    local taken_arrow = arrow_item:take_item(1)
                    --don't actually set the stack back if the player is in creative
                    if not qts.is_player_creative(user:get_player_name()) then
                        inv:set_stack(wield_list, arrow_index, arrow_item)
                    end

                    local next_stage = ItemStack(name .. "_s2")

                    local meta = next_stage:get_meta()
                    meta:set_string("current_arrow", taken_arrow:to_string() )
                    --next_stage:set_meta(meta)

                    next_stage:set_wear(itemstack:get_wear()) --wear pass-along

                    return next_stage
                end
            end
        end,
        long_secondary_use_time=def.draw_time/2,
    })

    minetest.register_tool(name .. "_s2", {
    	description = def.description,
    	inventory_image = def.inventory_images[2],
        groups = groups_2,
    	on_long_secondary_use = function(itemstack, user)
            local next_stage = ItemStack(name.."_s3")
            next_stage:set_wear(itemstack:get_wear()) --wear pass-along
            next_stage:get_meta():set_string("current_arrow", itemstack:get_meta():get_string("current_arrow")) --meta pass-along
            return next_stage
        end,
        on_stop_secondary_use = function(itemstack, user)
            local meta = itemstack:get_meta()
            local arrow_item = ItemStack(meta:get_string("current_arrow"))
            local inv = user:get_inventory()
            if arrow_item and inv and not qts.is_player_creative(user:get_player_name()) then
                local leftover = inv:add_item("main",arrow_item)
                if leftover then
                    minetest.add_item(user:get_pos(), leftover)
                end
            end

            local next_stage = ItemStack(name)
            next_stage:set_wear(itemstack:get_wear()) --wear pass-along
            return next_stage
        end,
        long_secondary_use_time=def.draw_time/2,
        on_drop = function(itemstack, dropper, pos)
            local meta = itemstack:get_meta()
            local arrow_item = ItemStack(meta:get_string("current_arrow"))
            local inv = dropper:get_inventory()
            if arrow_item and inv and not qts.is_player_creative(dropper:get_player_name()) then
                local leftover = inv:add_item("main",arrow_item)
                if leftover then
                    minetest.add_item(dropper:get_pos(), leftover)
                end
            end
            local next_stage = ItemStack(name)
            next_stage:set_wear(itemstack:get_wear()) --wear pass-along
            return minetest.item_drop(next_stage, dropper, pos)
        end
    })

    minetest.register_tool(name.."_s3", {
    	description = def.description,
    	inventory_image = def.inventory_images[3],
        groups = groups_2,
        on_stop_secondary_use = function(itemstack, user, cause)
            local launched = false
            local meta = itemstack:get_meta()
            local arrow_item = ItemStack(meta:get_string("current_arrow"))
            local wear = itemstack:get_wear()
            if cause == "unclicked" then
                if arrow_item then
                    local arrow_def = minetest.registered_items[arrow_item:get_name()]
                    if arrow_def and arrow_def.projectile then
                        launched = true
                        qts.projectile_launch_player(arrow_def.projectile, user, def.inaccuracy)
                        if not qts.is_player_creative(user:get_player_name()) then
                            wear = wear + (qts.WEAR_MAX/def.uses)
                        end
                    end
                end
            end
            if not launched then
                local inv = user:get_inventory()
                if arrow_item and inv and not qts.is_player_creative(user:get_player_name()) then
                    local leftover = inv:add_item("main",arrow_item)
                    if leftover then
                        minetest.add_item(user:get_pos(), leftover)
                    end
                end
            end
            local next_stage = ItemStack(name)
            if wear >= qts.WEAR_MAX then
                next_stage:take_item(1)
                return next_stage --the bow broke!
            end
            next_stage:set_wear(wear)
            return next_stage
        end,
        long_secondary_use_time=0.5,
        on_drop = function(itemstack, dropper, pos)
            local meta = itemstack:get_meta()
            local arrow_item = ItemStack(meta:get_string("current_arrow"))
            local inv = dropper:get_inventory()
            if arrow_item and inv and not qts.is_player_creative(dropper:get_player_name()) then
                local leftover = inv:add_item("main",arrow_item)
                if leftover then
                    minetest.add_item(dropper:get_pos(), leftover)
                end
            end
            local next_stage = ItemStack(name)
            next_stage:set_wear(itemstack:get_wear()) --wear pass-along
            return minetest.item_drop(next_stage, dropper, pos)
        end
    })
end

register_bow("tools:bow", {
    description = "Bow",
    inventory_images = {"default_bow1.png", "default_bow2.png", "default_bow3.png"},
    groups = {},
    draw_time = 1.5,
    inaccuracy = 5,
    uses = 100,
})