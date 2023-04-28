--[[
Bandit Camp generation

--]]
--TODO: Change these to settings
local MIN_CLASSES_PER_CHEST = 3
local MAX_CLASSES_PER_CHEST = 8
local MAX_ITEMS_PER_CLASS = 8
local WATCH_TOWER_HEIGHT_MIN = 2
local WATCH_TOWER_HEIGHT_MAX = 5
local CAMP_FEATURES_MIN = 3
local CAMP_FEATURES_MAX = 7
local CAMP_SIZE = 7

--[[
    Generate a node, only replacing replacables
]]
local function generate_node(pos, node)
    local n = minetest.get_node_or_nil(pos)
    if n and n.name then
        if minetest.get_item_group(n.name, "generation_replacable") ~= 0 then
            minetest.set_node(pos, node)
        end
    else
        minetest.set_node(pos, node)
    end
end

local function generate_treereplace(pos, node)
    local n = minetest.get_node_or_nil(pos)
    if n and n.name then
        if minetest.get_item_group(n.name, "generation_replacable") ~= 0 or
                minetest.get_item_group(n.name, "generation_trees") ~= 0 then
            minetest.set_node(pos, node)
        end
    else
        minetest.set_node(pos, node)
    end
end

--[[
    Trace upwards to find the top of the ground  
    will return null if no ground found
]]
---Trace upwards to find the ground
---@param pos Vector
---@param delta number
---@return Vector|nil
local function trace_up(pos, delta)
    local found_earth = false
    for y= -delta, delta do
        local node = minetest.get_node_or_nil(pos + vector.new(0,y,0))
        if node and node.name then
            if minetest.get_item_group(node.name, "generation_replacable") ~= 0 then
                if found_earth then
                    return pos + vector.new(0,y,0)
                end
            elseif minetest.get_item_group(node.name, "generation_trees") ~= 0 or 
                    minetest.get_item_group(node.name, "generation_artificial") ~= 0 then
                return nil
            elseif minetest.get_item_group(node.name, "generation_ground") ~= 0 then
                found_earth = true
            end
        end
    end
end

local woodtypes_plains = {"oak", "rowan", "apple", "aspen"}
--[[
Get a table of the materials needed to make a camp
This can later be randomized, based off of biome
--]]
local function get_camp_materials_plains()
    local wood = woodtypes_plains[math.random(#woodtypes_plains)]
    return {
        log = "overworld:"..wood.."_log",
        wood = "overworld:"..wood.."_wood_planks",
        fence = "overworld:"..wood.."_wood_fence",
        crate = "default:crate_"..wood.."",

        ladder = "default:ladder",
        campfire = "craftable:campfire_lit",
        torch = "craftable:torch",
    }
end

local function get_camp_materials_prarie()
    return {
        log = "overworld:rosewood_log",
        wood = "overworld:rosewood_wood_planks",
        fence = "overworld:rosewood_wood_fence",
        crate = "default:crate_rosewood",

        ladder = "default:ladder",
        campfire = "craftable:campfire_lit",
        torch = "craftable:torch",
    }
end

local cage_fence_area = {
    vector.new(-1,0,-1), vector.new(-1,0,0), vector.new(-1,0,1),
    vector.new(0,0,-1),                      vector.new(0,0,1),
    vector.new(1,0,-1),  vector.new(1,0,0),  vector.new(1,0,1),

    vector.new(-1,1,-1), vector.new(-1,1,0), vector.new(-1,1,1),
    vector.new(0,1,-1),                      vector.new(0,1,1),
    vector.new(1,1,-1),  vector.new(1,1,0),  vector.new(1,1,1),

    vector.new(-1,2,-1), vector.new(-1,2,0), vector.new(-1,2,1),
    vector.new(0,2,-1),  vector.new(0,2,0),  vector.new(0,2,1),
    vector.new(1,2,-1),  vector.new(1,2,0),  vector.new(1,2,1),
}
local function build_cage(pos, materials)   
    minetest.set_node(pos, {name="air"})
    minetest.set_node(pos+ vector.new(0,1,0), {name="air"})
    for k, v in ipairs(cage_fence_area) do
        generate_node(pos+ v, {name=materials.fence})
    end
end

local campfire_offsets = {vector.new(0,-3,2), vector.new(2,-3,0), vector.new(0,-3,-2), vector.new(-2,-3,0)}
local function build_fire_pit(pos, materials)
    minetest.set_node(pos, {name=materials.campfire})
    for k, v in ipairs(campfire_offsets) do
        local p = trace_up(pos + v, 1)
        if p then
            generate_node(p, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = k-1})
        end
        --[[
            local foundGround = false
            for off = 0,3 do
            p.y = p.y + 1
            local node = minetest.get_node_or_nil(p)
            if node and node.name then
                if node.name == "air" or minetest.get_item_group(node.name, "underbrush") ~= 0 then
                    if foundGround then
                        generate_node(p, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = k-1})
                        break
                    end
                else
                    foundGround = true
                end
            end
        end]]
        
    end
end

local banit_crate_items = {
    "tools:axe_bronze", "tools:axe_copper", "tools:axe_flint", 
    "default:bread", "overworld:bronze_alloy", "overworld:bronze_bar", "default:bucket",
    "craftable:charcoal", "overworld:coal", "overworld:clay_lump", "overworld:coconut", "overworld:copper_bar", "default:dishes_clay",  
    "default:herb_bloodbulb", "default:herb_flax", "default:herb_grain", "default:herb_milfoil",
    "default:herb_potatoe", "default:herb_wolfshood", "default:herb_carrot", "default:herb_goard", "default:herb_onion",
	"tools:hammer_stone", "tools:knife_flint",  "craftable:paper",
	"default:seed_bloodbulb", "default:seed_flax", "default:seed_grain", "default:seed_milfoil", "default:seed_potatoe", 
    "default:seed_wolfshood", "default:seed_carrot", "default:seed_goard", "default:seed_onion",
	"tools:shovel_bronze", "tools:shovel_copper", "tools:sword_bronze", "tools:sword_copper",
	"craftable:tinderbox", "overworld:flint", "craftable:tinder", "tools:axe_rusted", "tools:knife_rusted", "tools:knife_copper", 
    "tools:knife_bronze", "tools:shovel_rusted", "tools:sword_rusted", "tools:hoe_rusted", "tools:hoe_copper", "tools:hoe_bronze"
}
local function build_crate(pos, materials)
    minetest.set_node(pos, {name=materials.crate})
    --fill chest with stuff
    local metaRef = minetest.get_meta(pos)
    local invRef = metaRef:get_inventory()
    local class_count = math.random(MIN_CLASSES_PER_CHEST,MAX_CLASSES_PER_CHEST)
    for k = 1,class_count do
        --get the item and count
        local itemname = banit_crate_items[math.random(#banit_crate_items)]
        local item = ItemStack(itemname)
        local stack_max = 1
        if minetest.registered_items[itemname] then
            stack_max = minetest.registered_items[itemname].stack_max
        end
        if stack_max > 1 then
            item:set_count(math.random(1,math.min(MAX_ITEMS_PER_CLASS, stack_max)))
        end
        --place into inventory scattered
        local placed = false
        while not placed do
            local i = math.random(invRef:get_size("main"))
            if invRef:get_stack("main", i):is_empty() then
                invRef:set_stack("main", i, item)
                placed = true;
            end
        end
    end
end

local tower_offsets = {
    {
        -- +X
        left = vector.new(0,0,1),
        right = vector.new(0,0,-1),
        forward = vector.new(1,0,0),
        backward = vector.new(-1,0,0),
        floor = 1,
        ladder = 2,
        f_roof = 3,
        r_roof = 0,
        l_roof = 2,
        slab = 1,
    },
    {
        -- -X
        left = vector.new(0,0,-1),
        right = vector.new(0,0,1),
        forward = vector.new(-1,0,0),
        backward = vector.new(1,0,0),
        floor = 3,
        ladder = 3,
        f_roof = 1,
        r_roof = 2,
        l_roof = 0,
        slab = 3,
    },
    {
        -- +Z
        left = vector.new(-1,0,0),
        right = vector.new(1,0,0),
        forward = vector.new(0,0,1),
        backward = vector.new(0,0,-1),
        floor = 0,
        ladder = 4,
        f_roof = 2,
        r_roof = 3,
        l_roof = 1,
        slab = 0,
    },
    {
        -- -Z
        left = vector.new(1,0,0),
        right = vector.new(-1,0,0),
        forward = vector.new(0,0,-1),
        backward = vector.new(0,0,1),
        floor = 2,
        ladder = 5,
        f_roof = 0,
        r_roof = 1,
        l_roof = 3,
        slab = 1,
    },
}
local function build_watch_tower(pos, materials)
    local height = math.random(WATCH_TOWER_HEIGHT_MIN, WATCH_TOWER_HEIGHT_MAX)
    local rot = math.random(4)

    local perm = tower_offsets[rot]
    local fr = perm.forward
    local bk = perm.backward
    local rt = perm.right
    local lf = perm.left

    --make the columns
    for y = 0, height do
        for x = -1,1 do
            for z = -1,1 do
                if x ~= 0 and z ~= 0 then
                    generate_treereplace(pos + vector.new(x,y,z), {name=materials.fence})
                else
                    generate_treereplace(pos + vector.new(x,y,z), {name="air"})
                end
            end
        end
        generate_treereplace(
            pos + bk + bk + vector.new(0,y,0), 
            {name=materials.ladder, param2 = tower_offsets[rot].ladder}
        )
    end
    --vertical offset
    local off = vector.new(0,height+1,0)

    --make the platform
    for x = -1,1 do
        for z = -1,1 do
            generate_treereplace(pos + vector.new(x,0,z) + off, {name=materials.wood, param2 = perm.floor})
        end
    end
    generate_treereplace(
        pos + bk + bk + off, 
        {name=materials.ladder, param2 = perm.ladder}
    )

    --deal with the stuff above the platform
    off.y = off.y + 1
    for x = -1,1 do
        for z = -1,1 do
            local v = vector.new(x,0,z)
            if not vector.equals(v, bk) and (x~=0 or z~=0) then
                generate_treereplace(v+pos+off, {name=materials.fence})
            else
                generate_treereplace(v+pos+off, {name="air"})
            end
        end
    end

    off.y = off.y + 1
    --is it open-top or closed-top?
    if math.random() > 0.5 then
        --open top - put torches on corners
        for x = -1,1 do
            for z = -1,1 do
                if x ~= 0 and z ~= 0 then
                    generate_treereplace(pos+off+vector.new(x,0,z), {name=materials.torch, param2=1})
                else
                    generate_treereplace(pos+off+vector.new(x,0,z), {name="air"})
                end
            end
        end
    else
        --closed top

        --add support pillars
        for x = -1,1 do
            for z = -1,1 do
                if x ~= 0 and z ~= 0 then
                    generate_treereplace(pos+off+vector.new(x,0,z), {name=materials.fence})
                else
                    generate_treereplace(pos+off+vector.new(x,0,z), {name="air"})
                end
            end
        end

        --add the roof
        off.y=off.y+1
        --right slope
        generate_treereplace(pos+off+bk+rt, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = perm.r_roof})
        generate_treereplace(pos+off+rt, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = perm.r_roof})
        generate_treereplace(pos+off+fr+rt, {name=qts.shaped_node_name(materials.wood, "stair_outer"), param2 = perm.r_roof})
        
        --left slope
        generate_treereplace(pos+off+bk+lf, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = perm.l_roof})
        generate_treereplace(pos+off+lf, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = perm.l_roof})
        generate_treereplace(pos+off+fr+lf, {name=qts.shaped_node_name(materials.wood, "stair_outer"), param2 = perm.f_roof})
        
        --front
        generate_treereplace(pos+off+fr, {name=qts.shaped_node_name(materials.wood, "stair"), param2 = perm.f_roof})
        
        --torch
        generate_treereplace(pos+off, {name=qts.torch_name(materials.torch, "ceiling")})

        --ceiling
        off.y=off.y+1
        generate_treereplace(pos+off, {name=qts.shaped_node_name(materials.wood, "slab"), param2 = perm.slab})
        generate_treereplace(pos+off+bk, {name=qts.shaped_node_name(materials.wood, "slab"), param2 = perm.slab})

    end
end



local features = {
    build_cage,
    build_crate,
    build_fire_pit,
    build_watch_tower,
}
---Build a Camp
---@param pos Vector
---@param materials table
local function build_camp(pos, materials)
    local featureCount = math.random(CAMP_FEATURES_MIN, CAMP_FEATURES_MAX)
    for i =1,featureCount do
        --pick a random nearby point
        local offset = vector.new(math.random(-CAMP_SIZE, CAMP_SIZE), 0, math.random(-CAMP_SIZE, CAMP_SIZE))
        local vAdjust = trace_up(pos+offset, CAMP_SIZE)
        if (vAdjust) then
            --pick a random feature and build it
            features[math.random(#features)](vAdjust, materials)
        end
    end
    --make the spawner
    local needs_spawner = true
    local attempt_count = 0
    while(needs_spawner and attempt_count < 10) do
        local spawner_offset = trace_up(pos + vector.new(math.random(-CAMP_SIZE/2, CAMP_SIZE/2), 0, math.random(-CAMP_SIZE/2, CAMP_SIZE/2)), CAMP_SIZE)
        if spawner_offset then
            qts.ai.create_spawner_from_config(spawner_offset+vector.new(0,math.random(2,4),0), "mobs:spawnconfig_bandit_weapons") 
            needs_spawner=false
        else
            attempt_count=attempt_count+1
        end
    end
end

minetest.register_node ("dungeon:camp_generator_plains", {
	description = "Camp Generator - Plains",
	tiles = {"default.png"},
	groups = DUNGEON_GENERATOR_GROUPS,
	sounds = qtcore.node_sound_defaults(),
	drop = "",
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name="air"})
		local materials = get_camp_materials_plains()
        
        build_camp(pos, materials)
		return itemstack
	end
})

if not qts.ISDEV then
	minetest.register_lbm({
		label = "Camp Generator - Plains",
		name = "dungeon:camp_generator_plains_lbm",
		nodenames = {"dungeon:camp_generator_plains"},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.set_node(pos, {name="air"})
			local materials = get_camp_materials_plains()
            build_camp(pos, materials)
		end
	})
end




minetest.register_node ("dungeon:camp_generator_prarie", {
	description = "Camp Generator - Prarie",
	tiles = {"default.png"},
	groups = DUNGEON_GENERATOR_GROUPS,
	sounds = qtcore.node_sound_defaults(),
	drop = "",
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name="air"})
		local materials = get_camp_materials_prarie()
        
        build_camp(pos, materials)
		return itemstack
	end
})

if not qts.ISDEV then
	minetest.register_lbm({
		label = "Camp Generator - Prarie",
		name = "dungeon:camp_generator_prarie_lbm",
		nodenames = {"dungeon:camp_generator_prarie"},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.set_node(pos, {name="air"})
			local materials = get_camp_materials_prarie()
            build_camp(pos, materials)
		end
	})
end