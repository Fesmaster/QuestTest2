--[[
Attempt at a fluid and erosion system.

]]

local FEATURE_VOLUMETRIC_FLUIDS = false

if FEATURE_VOLUMETRIC_FLUIDS then
    local LIQUID_FALL_TRACE_DISTANCE = 128

    local function IsNodeLiquidSource(node)
        if node and node.name then
            local nodedef = minetest.registered_nodes[node.name]
            if nodedef and nodedef.liquidtype == "source" then
                return true
            end
        end
        return false
    end

    local function IsNodeLiquidFlowing(node)
        if node and node.name then
            local nodedef = minetest.registered_nodes[node.name]
            if nodedef and nodedef.liquidtype == "flowing" then
                return true
            end
        end
        return false
    end

    local function IsPosLiquidSource(pos)
        return IsNodeLiquidSource(minetest.get_node_or_nil(pos))
    end

    local function IsPosLiquidFlowing(pos)
        return IsNodeLiquidFlowing(minetest.get_node_or_nil(pos))
    end

    --[[
    Fluid Falling

    This causes fluids to fall downward, ie, the source blocks.
    It makes for more realistic fluid mechancis.
    ]] 
    minetest.register_abm({
        label = "Fluid Falling",
        nodenames = {"group:liquid"},
        interval = 1,
        chance = 1,
        catch_up = true,
        action = function(pos, node, AOC, AOCW)
            if IsNodeLiquidSource(node) then
                --water spreading sideways
                if IsPosLiquidSource(vector.new(pos.x, pos.y-1, pos.z)) then
                    --check the four around this lower node for flowing water
                    local offsets = {
                        vector.new(-1, -1, 0),
                        vector.new( 1, -1, 0),
                        vector.new( 0, -1,-1),
                        vector.new( 0, -1, 1)
                    }
                    for k, offset in ipairs(offsets) do
                        if IsPosLiquidFlowing( pos + offset ) then
                            --move the water node here.
                            minetest.set_node(pos+offset, {name=node.name})
                            minetest.set_node(pos, {name="air"})
                            break
                        end

                    end
                    return
                end

                --water falling
                --trace down to find lowest non flowing node
                local low_y = pos.y
                for y = pos.y-1, pos.y - LIQUID_FALL_TRACE_DISTANCE, -1 do
                    if not IsPosLiquidFlowing(vector.new(pos.x, y, pos.z)) then
                        low_y = y + 1 --hop back up one level
                        break
                    end
                end
                if low_y < pos.y then
                    --trace upwards and move all liquid sources down.
                    for y = pos.y, pos.y + LIQUID_FALL_TRACE_DISTANCE do
                        local nodeTraced = minetest.get_node_or_nil(vector.new(pos.x, y, pos.z))
                        if IsNodeLiquidSource(nodeTraced) then --implicit nill check too
                            minetest.set_node(vector.new(pos.x, low_y, pos.z), {name=nodeTraced.name})
                            low_y = low_y + 1
                            minetest.set_node(vector.new(pos.x, y, pos.z), {name="air"})
                        else
                            break
                        end
                    end
                end
            end
        end
    })

    --[[
    Block erosion

    want to encourace "trenching", so different chances based on constrictedness of the water
    X - solid
    0 - water

    XXX
    XX0
    XXX
    should be the most likely to be washed away. (middle block)


    ]]

    --[[
    minetest.register_abm({
        label = "Fluid Eroding",
        nodenames = {"group:erodeable"},
        neighbors = {"group:liquid"},
        interval = 0.25,
        chance = 1,
        catch_up = true,
        action = function(pos, node, AOC, AOCW)
            local above = minetest.get_node_or_nil(vector.new(pos.x, pos.y+1, pos.z))
            if IsNodeLiquidSource(above) or IsNodeLiquidFlowing(above) then
                local count_sides = 0
                local count_corners = 0

                local offsets_sides = {
                    vector.new(-1, 0, 0),
                    vector.new( 1, 0, 0),
                    vector.new( 0, 0,-1),
                    vector.new( 0, 0, 1)
                }

                for k, offset in ipairs(offsets_sides) do
                    --want to count flowing waters here
                    if IsPosLiquidFlowing(pos + offset) then
                        count_sides = count_sides + 1
                    end
                end

                local offsets_corners = {
                    vector.new(-1, 0,-1),
                    vector.new( 1, 0,-1),
                    vector.new(-1, 0, 1),
                    vector.new( 1, 0, 1)
                }

                for k, offset in ipairs(offsets_corners) do
                    --want to count non-waters here
                    if not (IsPosLiquidFlowing(pos + offset) or IsPosLiquidSource(pos + offset))then
                        count_corners = count_corners + 1
                    end
                end

                --calculate the chance
                local chance = 4 - count_corners + count_sides
                if count_sides > 0 and math.random(2 + math.pow(chance, 3)) == 1 then
                    minetest.set_node(pos, {name="air"})
                end
            end
        
        end
    })
    --]]

end