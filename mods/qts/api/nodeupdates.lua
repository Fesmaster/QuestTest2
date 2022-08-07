--[[
    This file causes Node Updates to be triggered when nodes are changed

    Node updates can be collected by having a node callback function:
    on_node_update = function(pos)
]]

local function add_pos_to_set(set, pos, data)
    local serialized = pos:to_string()
    if not set[serialized] then
        set[serialized] = data
        return true
    else
        return false
    end
end

local function get_pos_from_set(set, pos)
    local serialized = pos:to_string()
    return set[serialized]
end

local function get_nearby_set(set, inpos)
    for x=-1,1 do
        for y=-1,1 do
            for z=-1,1 do
                local offset = vector.new(x,y,z)+inpos
                add_pos_to_set(set, offset, {pos=offset, node=minetest.get_node_or_nil(offset)} )
            end
        end
    end
    return set
end

local function update_node(pos, node)
    if node then
        local def = minetest.registered_nodes[node.name]
        if def and def.on_node_update then
            def.on_node_update(pos)
        end
    end
end

function qts.update_node(pos)
    local set = get_nearby_set({}, pos)
    for s, dat in pairs(set) do
        update_node(dat.pos, dat.node)
    end
end

function qts.update_node_list(pos_list)
    local set = {}
    for k, pos in ipairs(pos_list) do
        get_nearby_set(set, pos)
    end
    for s, dat in pairs(set) do
        update_node(dat.pos, dat.node)
    end
end



minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    qts.update_node(pointed_thing.under)
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
    qts.update_node(pos)
end)

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    qts.update_node(pos)
end)

minetest.register_on_liquid_transformed(function(pos_list, node_list)
    qts.update_node_list(pos_list)
end)