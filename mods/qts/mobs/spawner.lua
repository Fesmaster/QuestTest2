--[[
This file creats the default spawner and related functions    
]]

local drawtype="airlike"
local pointable=false
---@type number|nil
local not_in_creative_inventory=1

qts.ai.SPAWNER_SPAWN_DELAY_TIME = qts.config("SPAWNER_SPAWN_DELAY_TIME", 15, "how long spawners should delay between spawning creatures")
qts.ai.SPAWNER_SPAWN_DELAY_DEVIATION_TIME = qts.config("SPAWNER_SPAWN_DELAY_DEVIATION_TIME", 5, "variation in how long spawners should delay between spawning creatures")
qts.ai.SPAWNER_DEFAULT_MAX_NEARBY_CREATURES = qts.config("SPAWNER_DEFAULT_MAX_NEARBY_CREATURES", 8, "how many creatures can be nearby a spawner for it to stop spawning")
qts.ai.SPAWNER_REQUIRED_MIN_PLAYER_DIST = qts.config("SPAWNER_REQUIRED_MIN_PLAYER_DIST", 16, "required minimum distance for a player to the spawner for it to spawn")

if qts.ISDEV then
	drawtype="normal"
	pointable=true
    not_in_creative_inventory=nil
end

---@class SpawnDefTable
---@field max_creatures_nearby number number of creatures that will block spawning
---@field nearby_radius number how big of a radius nearby is considered to be
---@field nearby_only_check_this_entity boolean true to only consider nearby entities for max if they have this specific entity name.
---@field count_to_spawn_each_step number how many entities to spawn each step
---@field spawn_radius number the radius to spawn entities in
---@field random_yaw boolean if the entity should spawn with random yaw
---@field spawn_set_table table fields that are set to the luaentity table after spawning the creature table. Will override values, but NOT functions, so as to not break things.
---@field registered_spawn_func string|nil optional string for a table of registered spanw funcs. This will be run on all newly spawned entities, AFTER the spawn_set_table is handled.
---@field delay_time number|nil NOT YET IMPLEMENTED how long to delay before spawning again (null will use global)
---@field delay_time_variation number|nil NOT YET IMPLEMENTED random variation +- opf the delay time (null will use global)
---@type SpawnDefTable
local default_spawn_def_table = {
    max_creatures_nearby = qts.ai.SPAWNER_DEFAULT_MAX_NEARBY_CREATURES.get(),
    nearby_radius=15,
    nearby_only_check_this_entity = false,
    count_to_spawn_each_step = 1,
    spawn_radius=7,
    random_yaw = true,
    spawn_set_table = {},
    registered_spawn_func = nil,
    --NOT YET IMPLEMENTED
    --TODO
    delay_time=nil,
    delay_time_variation=nil,
}

--entity names to ignore when doing creature checks
local ignored_objects={
    ["__builtin:item"]=true,
    ["__builtin:falling_node"]=true,
}

---Add an entity name to the list ignored by spawners
---@param name string the entity name
function qts.ai.add_spawner_ignored_entity_name(name)
    ignored_objects[name]=true
end

---@class SpawnerConfig
---@field entity_name string the entity to spawn
---@field max_creatures_nearby number number of creatures that will block spawning
---@field nearby_radius number how big of a radius nearby is considered to be
---@field nearby_only_check_this_entity boolean true to only consider nearby entities for max if they have this specific entity name.
---@field count_to_spawn_each_step number how many entities to spawn each step
---@field spawn_radius number the radius to spawn entities in
---@field random_yaw boolean if the entity should have random yaw when spawning
---@field spawn_set_table table fields that are set to the luaentity table after spawning the creature table. Will override values, but NOT functions, so as to not break things.
---@field on_spawn function|nil optional string for a table of registered spanw funcs. This will be run on all newly spawned entities, AFTER the spawn_set_table is handled.
---@field delay_time number|nil NOT YET IMPLEMENTED how long to delay before spawning again (null will use global)
---@field delay_time_variation number|nil NOT YET IMPLEMENTED random variation +- opf the delay time (null will use global)
---@field name string|nil the SpawnerConfig name. This is set automatically.

---Convert a registered spawn config to a spawn def table
---@param spawn_config SpawnerConfig the spawn config
---@return SpawnDefTable the returned def table
local function spawn_config_to_spawn_def_table(spawn_config)
    ---@type SpawnDefTable
    return {
        max_creatures_nearby            = qts.select(spawn_config.max_creatures_nearby~=nil,            spawn_config.max_creatures_nearby,              qts.ai.SPAWNER_DEFAULT_MAX_NEARBY_CREATURES.get()), --use the config
        nearby_radius                   = qts.select(spawn_config.nearby_radius~=nil,                   spawn_config.nearby_radius,                     default_spawn_def_table.nearby_radius),
        nearby_only_check_this_entity   = qts.select(spawn_config.nearby_only_check_this_entity~=nil,   spawn_config.nearby_only_check_this_entity,     default_spawn_def_table.nearby_only_check_this_entity),
        count_to_spawn_each_step        = qts.select(spawn_config.count_to_spawn_each_step~=nil,        spawn_config.count_to_spawn_each_step,          default_spawn_def_table.count_to_spawn_each_step),
        spawn_radius                    = qts.select(spawn_config.spawn_radius~=nil,                    spawn_config.spawn_radius,                      default_spawn_def_table.spawn_radius),
        random_yaw                      = qts.select(spawn_config.random_yaw~=nil,                      spawn_config.random_yaw,                        default_spawn_def_table.random_yaw),
        spawn_set_table                 = qts.select(spawn_config.spawn_set_table~=nil,                 spawn_config.spawn_set_table,                   default_spawn_def_table.spawn_set_table),
        registered_spawn_func           = qts.select(spawn_config.name~=nil,                            spawn_config.name,                              default_spawn_def_table.registered_spawn_func),
        delay_time                      = qts.select(spawn_config.delay_time~=nil,                      spawn_config.delay_time,                        default_spawn_def_table.delay_time),
        delay_time_variation            = qts.select(spawn_config.delay_time_variation~=nil,            spawn_config.delay_time_variation,              default_spawn_def_table.delay_time_variation),
    }
end

---Register a spawner config to be easily applied
--[[

    Spanwconfig Def table = {
        entity_name = string the entity to spawn
        max_creatures_nearby number = number of creatures that will block spawning
        nearby_radius = number how big of a radius nearby is considered to be
        nearby_only_check_this_entity = boolean true to only consider nearby entities for max if they have this specific entity name.
        count_to_spawn_each_step = number how many entities to spawn each step
        spawn_radius = number the radius to spawn entities in
        spawn_set_table = table fields that are set to the luaentity table after spawning the creature table. Will override values, but NOT functions, so as to not break things.
        on_spawn = function(spawnerpos, objref)|nil optional string for a table of registered spanw funcs. This will be run on all newly spawned entities, AFTER the spawn_set_table is handled.
        delay_time = number|nil NOT YET IMPLEMENTED how long to delay before spawning again (null will use global)
        delay_time_variation = number|nil NOT YET IMPLEMENTED random variation +- opf the delay time (null will use global)
        name = string|nil the SpawnerConfig name. This is set automatically.
    }
]]
---@param name string the config name
---@param spawner_config SpawnerConfig
function qts.ai.register_spawner_config(name, spawner_config)
    spawner_config.name = name
    qts.registered_spawner_configs[name] = spawner_config
end

---Apply a spawwner config to a spawner
---@param pos Vector the spawner pos
---@param config_name string the spawner config name
function qts.ai.apply_spawner_config(pos, config_name)
    local node = minetest.get_node_or_nil(pos)
    if not node then return end --early out
    ---@type SpawnerConfig
    local config = qts.registered_spawner_configs[config_name]
    if not config then return end --also early out
    if minetest.get_item_group(node.name, "spawner") ~= 0 then
        --dealing with a spawner!
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Spawner: ".. config.entity_name)
        meta:set_string("spawner_entity_name", config.entity_name)
        meta:set_string("spawner_spawn_def", minetest.serialize(spawn_config_to_spawn_def_table(config)))
    end
end

---Create a new spawner node from a given config
---@param pos Vector the spawner position
---@param config_name string the spawner config name
function qts.ai.create_spawner_from_config(pos, config_name)
    local config = qts.registered_spawner_configs[config_name]
    if not config then return end --also early out
    minetest.set_node(pos, {name="qts:spawner"})
    --dealing with a spawner!
    local meta = minetest.get_meta(pos)
    meta:set_string("infotext", "Spawner: ".. config.entity_name)
    meta:set_string("spawner_entity_name", config.entity_name)
    meta:set_string("spawner_spawn_def", minetest.serialize(spawn_config_to_spawn_def_table(config)))
end

--common all-mob spawner
minetest.register_node("qts:spawner", {
	drawtype=drawtype,
	tiles = {"default.png"},
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates=true,
	walkable=false,
	pointable=pointable,
	diggable=pointable,
	climbable=false,
	floodable=true,
	
	groups={spawner=1, oddly_breakable_by_hand=1, not_in_creative_inventory=not_in_creative_inventory},
	
    on_construct=function (pos)
        --start the node timer
        local timer = minetest.get_node_timer(pos)
        if (not timer:is_started()) then
            timer:start(qts.ai.SPAWNER_SPAWN_DELAY_TIME.get() + math.random(-qts.ai.SPAWNER_SPAWN_DELAY_DEVIATION_TIME.get(), qts.ai.SPAWNER_SPAWN_DELAY_DEVIATION_TIME.get()) )
        end
        
        --set the infotext to show what it spawns
		if qts.ISDEV then
            local meta = minetest.get_meta(pos)
            local entity_name = meta:get_string("spawner_entity_name")
            if (entity_name) then
                meta:set_string("infotext", "Spawner: "..entity_name)
            else
                meta:set_string("infotext", "Spawner: NONE")
            end
        end
    end,

	--preserve the metadata for digging/building these
	preserve_metadata=function(pos, oldnode, oldmeta, drops)

	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
	
    end,

    --UI customization of spawner
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if qts.ISDEV then
            
        else
            minetest.log("error", "How did you rightclick a spawner outside of devmode? You shouldn't do that.")
        end
    end,

    --end UI customization of spawner

    on_timer=function(pos, elapsed)
        --run the actual spawn
        local meta = minetest.get_meta(pos)
        
        ---@type string
        local entity_name = meta:get_string("spawner_entity_name")
        
        ---@type SpawnDefTable
        local spawn_def = minetest.deserialize(meta:get_string("spawner_spawn_def")) or {}
        
        if not spawn_def then
            spawn_def = {}
        end

        --check and copy in default spawn def if needed.
        for key, val in pairs(default_spawn_def_table) do
            if val ~= nil and spawn_def[key] == nil then
                spawn_def[key] = val
            end
        end

        local can_spawn=false
        local players = minetest.get_connected_players()
        local minplayerdistsq = qts.ai.SPAWNER_REQUIRED_MIN_PLAYER_DIST.get()
        minplayerdistsq=minplayerdistsq*minplayerdistsq
        for i, player in ipairs(players) do
            if minplayerdistsq > vector.distancesq(pos, player:get_pos()) then
                can_spawn=true
                break
            end
        end
        if can_spawn then
            minetest.log("Able to spawn a creature")
        end
        minetest.log("Try to spawn a creature - no player!")

        --check that the entity exists
        if can_spawn and entity_name and minetest.registered_entities[entity_name] then
            
            --count nearby entities to see if we can spawn
            local objlist = minetest.get_objects_inside_radius(pos, spawn_def.nearby_radius)
            local nearby_count = 0
            for i, obj in ipairs(objlist) do
                if not obj:is_player() then
                    if (not spawn_def.nearby_only_check_this_entity and not ignored_objects[qts.object_name(obj)] )  or (qts.object_name(obj) == entity_name) then
                        nearby_count=nearby_count+1 --increment if we count all entities OR we only count this object
                    end
                end
            end
            
            if (nearby_count < spawn_def.max_creatures_nearby) then
                --handle the fact that there might be less creature availability than the number to spawn normally
                local to_spawn = math.min(spawn_def.max_creatures_nearby-nearby_count, spawn_def.count_to_spawn_each_step)
                --for each entity that can be spawned
                for i =1,to_spawn do
                    --try and get a random pos. might fail!
                    local spawnpos = qts.ai.get_random_navagatable_point_in_radius(pos, spawn_def.spawn_radius, {airlike=true,check_ground=true}, 2) --TOD: this needs to be generalized to the mob!!!
                    if spawnpos then
                        ---@type LuaEntity
                        local spawned = minetest.add_entity(spawnpos, entity_name)
					    if spawned then
                            --the creature is spawned
                            minetest.log("info", "Spawned a creature: ".. dump(entity_name))
                            
                            --deal with the spawn def table
                            if spawn_def.spawn_set_table then
                                local luaentity = spawned:get_luaentity()
                                for k, v in pairs(spawn_def.spawn_set_table) do
                                    if luaentity[k] == nil or type(luaentity[k]) ~= "function" then
                                        luaentity[k] = table.copy(v) --minetest deep copy
                                    end
                                end
                            end

                            --deal with random yaw
                            if spawn_def.random_yaw then
                                spawned:set_yaw(math.random(0, math.pi*2))
                            end

                            --deal with the spawn func
                            if (
                                spawn_def.registered_spawn_func and 
                                qts.registered_spawner_configs[spawn_def.registered_spawn_func]  and 
                                qts.registered_spawner_configs[spawn_def.registered_spawn_func].on_spawn and
                                type(qts.registered_spawner_configs[spawn_def.registered_spawn_func].on_spawn) == "function" 
                            )then
                                qts.registered_spawner_configs[spawn_def.registered_spawn_func].on_spawn(pos, spawned)
                            end

                        end
                    end
                end
            end
        end
        --reset the timer
        local timer = minetest.get_node_timer(pos)
        timer:start(qts.ai.SPAWNER_SPAWN_DELAY_TIME.get() + math.random(-qts.ai.SPAWNER_SPAWN_DELAY_DEVIATION_TIME.get(), qts.ai.SPAWNER_SPAWN_DELAY_DEVIATION_TIME.get()))
    end,
})