--[[
    This file is responsible for door registration functions
]]

local door_boxes = {
    main_closed = {
		type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 1.5, -7/16},
            },
	},
    main_open = {
		type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, -7/16, 1.5, 0.5},
            },
	},
    alt_closed = {
		type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 1.5, -7/16},
            },
	},
    alt_open = {
		type = "fixed",
            fixed = {
                {7/16, -0.5, -0.5, 0.5, 1.5, 0.5},
            },
	}
}

local trapdoor_boxes = {
    main_closed = {
		type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, -6/16, 0.5},
            },
	},
    main_open = {
		type = "fixed",
            fixed = {
                {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5},
            },
	},
    alt_closed = {
		type = "fixed",
            fixed = {
                {-0.5, 6/16, -0.5, 0.5, 0.5, 0.5},
            },
	},
    alt_open = {
		type = "fixed",
            fixed = {
                {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5},
            },
	}
}

--[[
    The coor register door function, not publicly exposed
]]
local function register_doorlike_internal(name, def, doorOpts)
    def.drawtype = "mesh"
    def.paramtype='light'
	def.paramtype2 = "facedir"
    
    local name_left_closed = name
    --[[
        This is to remove a leading ":" from names. Nodes registered outside of their mod need this, but
        it tends to break itemstacks and node names at runtime
    ]]
    local prefix = ""
    if string.sub(name, 1,1) == ":" then
        name_left_closed = string.gsub(name, ":", "",1)
        prefix = ":"
    end
    local name_left_open = name_left_closed.."_open"
    local name_right_closed = name_left_closed..doorOpts.alt
    local name_right_open = name_left_closed..doorOpts.alt.."_open"

    local mapping = {
        [name_left_closed] = name_left_open,
        [name_left_open] = name_left_closed,
        [name_right_closed] = name_right_open,
        [name_right_open] = name_right_closed,
    }

    def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        minetest.swap_node(pos, {name=mapping[node.name], param1=node.param1, param2=node.param2})
    end

    local main_closed = qts.table_deep_copy(def)
    def.groups.not_in_creative_inventory=1
    def.drop = def.drop or name_left_closed --not def.name just in case there is a leading ":", which breaks it.
    --do these after to get them to propigate to all the non-normal ones
    local main_open = qts.table_deep_copy(def)
    local alt_closed = qts.table_deep_copy(def)
    local alt_open = qts.table_deep_copy(def)
    
    --meshes
    main_closed.mesh = doorOpts.main_closed
    main_open.mesh = doorOpts.main_open
    alt_closed.mesh = doorOpts.alt_closed
    alt_open.mesh = doorOpts.alt_open

    --boxes
    main_closed.selection_box = doorOpts.boxes.main_closed
	main_closed.collision_box = doorOpts.boxes.main_closed
    main_open.selection_box = doorOpts.boxes.main_open
    main_open.collision_box = doorOpts.boxes.main_open
    alt_closed.selection_box = doorOpts.boxes.alt_closed
    alt_closed.collision_box = doorOpts.boxes.alt_closed
    alt_open.selection_box = doorOpts.boxes.alt_open
    alt_open.collision_box = doorOpts.boxes.alt_open
    
    --registers
    minetest.register_node(prefix..name_left_closed,  main_closed)
    minetest.register_node(prefix..name_left_open,    main_open)
    minetest.register_node(prefix..name_right_closed, alt_closed)
    minetest.register_node(prefix..name_right_open,   alt_open)
end

local param2_to_leftvector = {
    [0] = vector.new(-1,0,0),
    vector.new(0,0,1),
    vector.new(1,0,0),
    vector.new(0,0,-1)
}

--[[
    Register a new door  

    Params:  
        name - the node name  
        def - the node definition table  

    Definition Table Additions:  
        [None]  
    
    Definition Table Not Allowed:  
        drawtype  
        paramtype  
        paramtype2  
        mesh  
        selection_box  
        collision_box  
        on_place(...)    
        on_rightclick(...)  
        on_destruct(...)  
        on_blast(...)  

    Default Groups:  
        door=1  
        not_in_creative_inventory=1 (For Alternate Forms Only)  
]]
function qts.register_door(name, def)

    if def.groups then
        def.groups.door = 1
    else
        def.groups = {door=1}
    end

    local name_left_closed = name
    if string.sub(name, 1,1) == ":" then
        name_left_closed = string.gsub(name, ":", "",1)
    end
    local name_left_open = name_left_closed.."_open"
    local name_right_closed = name_left_closed.."_right"
    local name_right_open = name_left_closed.."_right_open"
    
    
    def.on_place = function(itemstack, placer, pointed_thing)
        --handle clickable functions
        local under = minetest.get_node_or_nil(pointed_thing.under)
        if under and under.name then
            local def = minetest.registered_nodes[under.name]
            if def and def.on_rightclick then
                minetest.log("Placing door failed due to rightclick function in node pointed at")
                return def.on_rightclick(pointed_thing.under, under, placer, itemstack, pointed_thing)
            end
        end

        --check if we can override the node above
        local above  = minetest.get_node_or_nil(pointed_thing.above+vector.new(0,1,0))
        if above and above.name then
            local def = minetest.registered_nodes[above.name]
            if def and not def.buildable_to then
                minetest.log("Placing door failed due to a blocking node above: " .. dump(above.name))
                return itemstack
            end
        end
        
        --select door type
        local param2 = minetest.dir_to_facedir(vector.subtract(pointed_thing.above, placer:get_pos()))
        if param2 > 3 then 
            minetest.log("Placing door failed due to a bad param2: "..dump(param2))
            return itemstack 
        end
        minetest.log("Placing door should succeed")
        local toTheLeft = minetest.get_node_or_nil(pointed_thing.above+param2_to_leftvector[param2])
        local toTheRight = minetest.get_node_or_nil(pointed_thing.above-param2_to_leftvector[param2])
        
        local thisname = name_left_closed
        local switchRight = false
        --switch to right
        if toTheLeft and (toTheLeft.name == name_left_closed or toTheLeft.name == name_left_open) and toTheLeft.param2 == param2 then
            thisname = name_right_closed
        elseif toTheRight and (toTheRight.name == name_left_closed or toTheRight.name == name_left_open) and toTheRight.param2 == param2 then
            switchRight = true
        end

        minetest.item_place(ItemStack(thisname), placer, pointed_thing, param2)
        if (switchRight) then
            local name = name_right_closed
            if toTheRight.name == name_left_open then
                name = name_right_open
            end
            minetest.swap_node(pointed_thing.above-param2_to_leftvector[param2], {name = name, param2 = param2})
        end
        --add a void above the node
        minetest.set_node(pointed_thing.above+vector.new(0,1,0), {name="qts:void"})

        if not qts.is_player_creative(placer) then
            itemstack:take_item()
        end
        return itemstack
    end

    def.on_destruct = function(pos)
        --remove the void above it
        minetest.set_node(pos+vector.new(0,1,0), {name="air"})
    end

    def.on_blast = function(pos, i)
        minetest.set_node(pos+vector.new(0,1,0), {name="air"})
        return {ItemStack(name)}
    end

    local doorOpts = {
        boxes = door_boxes,
        alt = "_right",
        main_closed = "door_left.obj",
        main_open = "door_left_open.obj",
        alt_closed = "door_right.obj",
        alt_open = "door_right_open.obj",
    }

    register_doorlike_internal(name, def, doorOpts)
end

--[[
        Register a new door  

    Params:  
        name - the node name  
        def - the node definition table  

    Definition Table Additions:  
        [None]  
    
    Definition Table Not Allowed:  
        drawtype  
        paramtype  
        paramtype2  
        mesh  
        selection_box  
        collision_box  
        on_place(...)    
        on_rightclick(...)  

    Default Groups:  
        trapdoor=1  
        not_in_creative_inventory=1 (For Alternate Forms Only)  
]]
function qts.register_trapdoor(name, def)
    if def.groups then
        def.groups.trapdoor = 1
    else
        def.groups = {trapdoor=1}
    end

    local name_left_closed = name
    if string.sub(name, 1,1) == ":" then
        name_left_closed = string.gsub(name, ":", "",1)
    end
    local name_left_open = name_left_closed.."_open"
    local name_right_closed = name_left_closed.."_top"
    local name_right_open = name_left_closed.."_top_open"
    

    def.on_place = function(itemstack, placer, pointed_thing)
        local under = minetest.get_node_or_nil(pointed_thing.under)
        if under and under.name then
            local def = minetest.registered_nodes[under.name]
            if def and def.on_rightclick then
                minetest.log("Placing trapdoor failed due to rightclick function in node pointed at")
                return def.on_rightclick(pointed_thing.under, under, placer, itemstack, pointed_thing)
            end
        end


        local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1
		local param2 = minetest.dir_to_facedir(vector.subtract(pointed_thing.above, placer:get_pos()))
        local place_name = name_left_closed
		if pointed_thing.under.y - 1 == pointed_thing.above.y or (fpos > 0 and fpos < 0.5)
			or (fpos < -0.5 and fpos > -0.999999999999) 
        then
            place_name = name_right_closed
        end
        minetest.item_place(ItemStack(place_name), placer, pointed_thing, param2)
        if not qts.is_player_creative(placer) then
            itemstack:take_item()
        end
        return itemstack
    end

    local doorOpts = {
        boxes = trapdoor_boxes,
        alt = "_top",
        main_closed = "trapdoor_bottom.obj",
        main_open = "trapdoor_bottom_open.obj",
        alt_closed = "trapdoor_top.obj",
        alt_open = "trapdoor_top_open.obj",
    }

    register_doorlike_internal(name, def, doorOpts)
end