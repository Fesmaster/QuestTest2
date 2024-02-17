--[[
    World Access for Async threads

    This is the other half of parallel.lua.

    This file should only be loaded from the async thread
]]

---@type AsyncWorldContext
qts.async_world_context = nil

function minetest.set_node(pos, node)
    pos = vector.round(pos)
    if qts.async_world_context and
        qts.async_world_context.VA:containsp(pos)
    then
        qts.async_world_context.VM:set_node_at(pos, {
            name=node.name,
            param1=node.param1 or 255,
            prob=node.param1 or 255,
            param2=node.param2 or 0
        })
    end
end

minetest.add_node = minetest.set_node
minetest.swap_node = minetest.set_node

function minetest.bulk_set_node(positions, node)
    if qts.async_world_context then
        --probably not particularly efficent, but we are just doing this with a loop for now.
        for k, pos in ipairs(positions) do
            minetest.set_node(pos, node)
        end
    end
end

function minetest.remove_node(pos)
    minetest.set_node(pos, {name="air"})
end



function minetest.get_node_or_nil(pos)
    if qts.async_world_context and
        qts.async_world_context.VA:containsp(vector.round(pos))
    then
        local mapnode = qts.async_world_context.VM:get_node_at(pos)
        return {
            name = mapnode.name,
            param1 = mapnode.prob or (mapnode.param1 or 0),
            param2 = mapnode.param2
        }        
    end
    return nil
end

function minetest.get_node(pos)
    return minetest.get_node(pos) or {name="ignore", param1=0, param2=0}
end

---Set the async world context on an async threads
---@param new_context AsyncWorldContext
---@return boolean set true if the async world context is set to a valid value
function qts.set_async_world_context(new_context)
    if type(new_context) == "table" and 
        new_context.VM ~= nil
    then
        qts.async_world_context = new_context
        --the VoxelArea object seems to loose its functions when passed, so re-create the VoxelArea here
        qts.async_world_context.VA = VoxelArea(qts.async_world_context.VM:get_emerged_area())
        return true
    elseif new_context == nil then
        qts.async_world_context = nil
        return false
    end
    return false
end

---@class AsyncWorldContext
---@field VM VoxelManip
---@field VA VoxelArea
