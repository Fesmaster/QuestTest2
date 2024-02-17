--[[
    This file adds a number of functions that take advantage of
    Minetest's parallel Lua thread structure

    The most simple of these are a series of parallel loops.
    One is range based, one is the equivelent of ipairs(...), and the last is the equivelent of pairs(...)

    Because minetest.get_content_id(...) works on the async thread, we can have custom versions of minetest.get_node(...) and similar that work on the
    async threads, via a VoxelManip object passed to the thread.
    For implementation details, see async_world_access.lua
]]

---Parallel for loop
---@param start_value number starting value
---@param stop_value number stopping value (never reached)
---@param increment number? increment value (default: 1)
---@param body fun(i:number, ...):unknown loop body (run on async threads)
---@param body_sync fun(i:number, ...)? syncronous loop body (run on main thread). Parasm are return value from body()
---@param finished fun()? syncronous after all loops (run on main thread)
---@param ... unknown params to the loop body
function qts.parallel_for(start_value, stop_value, increment, body, body_sync, finished, ...)
	if increment == nil then increment = 1 end

	local max_iters = math.abs(math.floor((stop_value - start_value) / increment)) + 1;
	for i=start_value,stop_value,increment do
		minetest.handle_async(function(body_func, i, ...)
			return i, body_func(i, ...)
		end, 
		function(i, ...)
			if (body_sync) then body_sync(i, ...) end
			max_iters = max_iters - 1
			if (max_iters == 0 and finished) then
				finished()
			end
		end, body, i, ...)
	end
end

---Parallel for k, v, in ipairs(...)
---@param table table
---@param body fun(k:number, v:any, ...):... loop body
---@param body_sync fun(k:number, v:any, ...)? syncronous loob body (run on main thread). Params are return value from body()
---@param finished fun()? Syncronous after all loops (run on main thread)
---@param ... unknown params to the loop body
function qts.parallel_ipairs(table, body, body_sync, finished, ...)
	local max_iters = #table
	for k, v in ipairs(table) do
		minetest.handle_async(function(body_func, k, v, ...)
			return k, v, body_func(k, v, ...)
		end, 
		function(k, v, ...)
			if (body_sync) then body_sync(k, v, ...) end
			max_iters = max_iters - 1
			if (max_iters == 0 and finished) then
				finished()
			end
		end, body, k, v, ...)
	end
end

---Parallel for k, v, in pairs(...)
---@param table table
---@param body fun(k:number, v:any, ...):... loop body
---@param body_sync fun(k:number, v:any, ...)? syncronous loob body (run on main thread). Params are return value from body()
---@param finished fun()? Syncronous after all loops (run on main thread)
---@param ... unknown params to the loop body
function qts.parallel_pairs(table, body, body_sync, finished, ...)
	local counted_iters = 0
	local added_all_iters = false
	for k, v in pairs(table) do
		counted_iters = counted_iters + 1
		minetest.handle_async(function(body_func, k, v, ...)
			return k, v, body_func(k, v, ...)
		end, 
		function(k, v, ...)
			if (body_sync) then body_sync(k, v, ...) end
			counted_iters = counted_iters - 1
			if (counted_iters == 0 and added_all_iters and finished) then
				finished()
			end
		end, body, k, v, ...)
	end
	added_all_iters = true
end

---@type {string:AsyncAbmDef}
qts.registered_async_abms = {}

--true if there is an async abm currently running - don't start another!
local has_async_abm_running = false

--[[
    Register an async ABM

    Async ABMs work on the Async Thread
    
    Through the magic of code (And VoxelManip), they can still use minetest.get_node and the like.

    Async AMBs trigger in a Very Limited range around the player. Their interval is limited to 1.
]]
---@param def AsyncAbmDef
function qts.register_async_abm(def)
    if type(def.label) ~= "string" or 
        type(def.nodenames) ~= "table" or
        #def.nodenames < 1 or
        type(def.action) ~= "function"
    then 
        error ("Cannot define an async abm without a label, nodenames, and action!\n\ttype(label)="..
            dump(type(def.label)).."\n\ttype(nodenames)=" ..dump(type(def.nodenames)).."\n\t#nodenames="..
            dump(dump(#def.nodenames)) .. "\n\ttype(def.action)=" .. dump(type(def.action))
        )
        return 
    end
    if type(def.chance) ~= "number" then def.chance = 1 end
    if type(def.interval) ~= "number" then def.interval = 1 end
    if type(def.max_y) ~= "number" then def.max_y = math.huge end
    if type(def.min_y) ~= "number" then def.min_y = -math.huge end
    for i, name in ipairs(def.nodenames) do
        if type(name) ~= "string" then
            error("nodenames must be an array of strings!")
            return
        end
    end
    if (def.neighbors ~= nil) then
        if (type(def.neighbors) ~= "table") then
            error("if neighbors is supplied, it must be an array of strings!")
            return
        end
        for i, name in ipairs(def.neighbors) do
            if type(name) ~= "string" then
                error("if neighbors is supplied, it must be an array of strings!")
                return
            end
        end
    end

    --initalize this value
    def.time_since_last_active = 0

    qts.registered_async_abms[def.label] = def
end

---Create an async world context
---@param pos1 Vector
---@param pos2 Vector
---@return AsyncWorldContext?
function qts.create_async_world_context(pos1, pos2)
    local context = {
        VM = minetest.get_voxel_manip(pos1, pos2)
    }
    if (context.VM) then
        local p1, p2 = context.VM:read_from_map(pos1, pos2)
        context.VA = VoxelArea(p1, p2)
    end
    if (context.VM and context.VA) then return context end
    return nil
end

---Apply an Async World Context to the world
---@param context AsyncWorldContext
function qts.apply_async_world_context(context)
    if (type(context) == "table" and context.VM ~= nil and context.VA ~= nil) then
        --valid context assumed
        if context.VM:was_modified() then
            context.VM:calc_lighting()
            context.VM:update_liquids()
            context.VM:write_to_map(true)
        end
    end
end

---Async context functoon
---@param context AsyncWorldContext
---@param abm AsyncAbmDef
---@return AsyncWorldContext
local async_abm_func = function(context, abm)
    --set the async world context
    if not qts.set_async_world_context(context) then
        minetest.debug("error", "Error: Async ABM received invalid context!")
        return context
    end

    local checking_groups = false
    local CIDs = {} --set of CIDs {CID:true, CID:false} - only ones with nil are checked against groups
    local groups = {} --set of groups
    for i, name in ipairs(abm.nodenames) do
        if qts.is_group(name) then
            checking_groups=true
            groups[#groups+1] = qts.remove_modname_from_item(name)
        else 
            local cid = minetest.get_content_id(name)
            if cid then
                CIDs[cid] = true
            end
        end
    end
    local checking_neighbors = false
    local checking_neighbor_groups = false
    local NeighborCIDs = {}
    local NeighborGroups = {}
    if type(abm.neighbors) == "table" then
        for i, name in ipairs(abm.neighbors) do
            checking_neighbors = true
            if qts.is_group(name) then
                checking_neighbor_groups=true
                NeighborGroups[#NeighborGroups+1] = qts.remove_modname_from_item(name)
            else 
                local cid = minetest.get_content_id(name)
                if cid then
                    NeighborCIDs[cid] = true
                end
            end
        end
    end

    --get the region to iterate
    local p1, p2 = context.VM:get_emerged_area()
    p1.y = math.max(p1.y, abm.min_y)
    p2.y = math.min(p1.y, abm.max_y)

    --get the data
    local blockData = context.VM:get_data()
    local param1data = context.VM:get_light_data()
    local param2data = context.VM:get_param2_data()

    --minetest.log("context:\n"..dump(context))

    for i in context.VA:iterp(p1, p2) do
        local cidstat = CIDs[blockData[i]]
        if cidstat == nil and checking_groups then
            --check groups
            local name=minetest.get_name_from_content_id(blockData[i])
            for i, group in ipairs(groups) do
                local groupval = minetest.get_item_group(name, group)
                if groupval ~= 0 then
                    --change cidstat
                    cidstat=true
                    break
                end
            end
            --change cidstat
            if (cidstat == nil) then cidstat = false end

            --write back into CIDs to save time next time this block is encountered
            CIDs[blockData[i]] = cidstat
        end


        
        
        if cidstat then
            local blockpos = context.VA:position(i)

            --match neighbors
            local neighbor_found = false
            if checking_neighbors then
                for x = -1,1 do
                    for y = -1,1 do
                        for z = -1,1 do
                            --match each block in the 26 around the one in question
                            if (x ~= 0 or y ~= 0 or z ~= 0) then
                                local p2 = blockpos + vector.new(x, y, z)
                                if context.VA:containsp(p2) then
                                    local idx = context.VA:indexp(p2)
                                    local ncidstat = NeighborCIDs[blockData[idx]]
                                    if ncidstat == nil and checking_neighbor_groups then
                                       --check groups 
                                       local name=minetest.get_name_from_content_id(blockData[i])
                                        for i, group in ipairs(groups) do
                                            local groupval = minetest.get_item_group(name, group)
                                            if groupval ~= 0 then
                                                --change ncidstat
                                                ncidstat=true
                                                break
                                            end
                                        end
                                        --change ncidstat
                                        if (ncidstat == nil) then ncidstat = false end

                                        --write back into CIDs to save time next time this block is encountered
                                        NeighborCIDs[blockData[i]] = ncidstat
                                    end

                                    if ncidstat then
                                        neighbor_found=true
                                        break
                                    end
                                end
                            end
                        end
                        if neighbor_found then break end
                    end
                    if neighbor_found then break end
                end
            else
                neighbor_found=true
            end
            local chance_passed = false
            if abm.chance == 1 then
                chance_passed = true
            else
                chance_passed = math.random(abm.chance) == 1
            end

            if neighbor_found and chance_passed then
                --call the callback
                abm.action(blockpos, {
                    name=minetest.get_name_from_content_id(blockData[i]),
                    param1 = param1data[i],
                    param2 = param2data[i]
                })
            end
            --intentionally don't read changes to the map
        end
    end

    return context;
end



local function build_callback_chain()
    ---Callback for async abm thread
    ---@param context AsyncWorldContext
    local callback_func = function(context)
        qts.apply_async_world_context(context)
        minetest.log("All Async AMBs finished!")
        has_async_abm_running=false
    end

    
    for name, def in pairs(qts.registered_async_abms) do
        local prev_calllback = callback_func --stash the previous callback
        --change the callback to add another layer
        callback_func = function(context)
            if (def.time_since_last_active > def.interval) then
                --if the interval has been long enough
                --send off the next async abm task
                minetest.log("Beginning Async ABM: " .. def.label)
                has_async_abm_running=true --keep this true...
                minetest.handle_async(async_abm_func, prev_calllback, context, def)
                def.time_since_last_active=0
            else
                --ignore the next task adn pass the function call down the chain
                prev_calllback(context)
            end
        end
    end

    return callback_func
end

qts.ASYNC_ABM_EFFECT_RADIUS = qts.config("ASYNC_ABM_EFFECT_RADIUS", 64, "number of blocks around the player that Async AMBs take effect")

minetest.register_globalstep(function(dtime)
    --parallelize this?
    for name, def in pairs(qts.registered_async_abms) do
        def.time_since_last_active = def.time_since_last_active + dtime
    end

    if not has_async_abm_running then

        local callback = build_callback_chain()
        ---@type Player[]
        local players = minetest.get_connected_players()
        if (#players <= 0) then return end
        local player = players[math.random(#players)] --pick a random player
        local p1 = player:get_pos()
        local p2 = p1:copy()
        local v = vector.new(qts.ASYNC_ABM_EFFECT_RADIUS:get(),qts.ASYNC_ABM_EFFECT_RADIUS:get(),qts.ASYNC_ABM_EFFECT_RADIUS:get())
        p1 = p1 - v
        p2 = p2 + v

        local context = qts.create_async_world_context(p1, p2)
        if context then
            callback(context)
        end
    end

end)


---@class AsyncAbmDef
---@field label string
---@field nodenames ItemName[]
---@field neighbors ItemName[]?
---@field interval number?
---@field chance number?
---@field min_y number?
---@field max_y number?
---@field action fun(pos:Vector, node:NodeRef)
---@field time_since_last_active number? Do Not supply at registration time!



--- testing ---

minetest.register_chatcommand("parallel_test", {
	params = "<num>",
	description = "Parallel Testing chat command",
	func = function(name, param)
        --argument parsing
        local args = string.split(param, " ", false)
        local maxiters = 10
        if (#args > 0) then
		    local newMaxIters = tonumber(string.trim(args[1]))
            if newMaxIters then maxiters = newMaxIters end
        end

        qts.parallel_pairs(minetest.registered_nodes, function(nodename, def)
            local cid = minetest.get_content_id(nodename)
            minetest.debug("Cid of ".. nodename.. " is: " .. dump(cid))
        end)
	end
})