--[[
    A Pentool Brush is what makes PenTool's draw into the world.
    
    Any PenTool brush follows a certain interface. Custom brush types can be made. 
]]

---@class PentoolBrush
---@field draw fun(self:PentoolBrush, transform:Transform, weight:Alpha, context:PentoolContext):nil function that is called to draw a point
---@field copy fun(self:PentoolBrush):PentoolBrush function that is called to copy a brush
---@field on_assign nil|fun(self:PentoolBrush, context:PentoolContext):nil optional function called by set_brush(...)
---@field on_remove nil|fun(self:PentoolBrush, context:PentoolContext):nil optional function called by set_brush(...)
---@field stroke_begin nil|fun(self:PentoolBrush, context:PentoolContext):nil optional function called by pendown(...)
---@field stroke_end nil|fun(self:PentoolBrush, context:PentoolContext):nil optional function called by penup(...) (or when changing brushes if the pen is not currently up)

---Create an empty pentool brush. Does not draw anything
---@return PentoolBrush
function qts.pentool.create_empty_brush()
    return {
        ---PentoolBrush interface draw
        ---@param self PentoolBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
        end,
        ---PentoolBrush interface clone
        ---@param self PentoolBrush
        ---@return PentoolBrush
        copy = function(self)
            return self
        end
    }
end

---@class PentoolPointBrush:PentoolBrush
---@field node NodeRef

---Create a PentoolPointBrush. This brush type draws a single node, and does not take into account shaped nodes or the scale of the current context.
---Works via minetest.set_node(...)
---@param node NodeRef|ItemName
---@return PentoolPointBrush
function qts.pentool.create_point_brush(node)
    if type(node) == "string" then
        node = {name=node}
    end

    return {
        ---PentoolBrush interface
        ---@param self PentoolPointBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
            if (context:get_draw_alpha() < weight) then
                minetest.set_node(transform.pos, self.node)
            end
        end,
        ---PentoolBrush interface copy
        ---@param self PentoolPointBrush
        ---@return PentoolPointBrush
        copy = function(self)
            return {
                draw = self.draw,
                copy = self.copy,
                node = {name=self.node.name, param1=self.node.param1, param2=self.node.param2},
            }
        end,
        node = node
    }
end

---@class PentoolBoxBrush:PentoolBrush
---@field node NodeRef

---Create a PentoolBoxBrush. This brush type draws a box of nodes that is scaled to match the PenTool. It does not smooth ShapedNodes.
---Each full Box is controlled by the weight, not individual nodes.
---Works via minetest.set_node(...)
---@param node NodeRef|ItemName
---@return PentoolBoxBrush
function qts.pentool.create_box_brush(node)
    if type(node) == "string" then
        node = {name=node}
    end

    return {
        ---PentoolBrush interface
        ---@param self PentoolBoxBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
            if (context:get_draw_alpha() < weight) then
                for x=-math.floor((transform.scale.x-1)/2), math.floor(transform.scale.x/2) do
                for y=-math.floor((transform.scale.y-1)/2), math.floor(transform.scale.y/2) do
                for z=-math.floor((transform.scale.z-1)/2), math.floor(transform.scale.z/2) do
                    local pos = transform:absolute_position_no_scale(vector.new(x,y,z))
                    minetest.set_node(pos:round(), self.node)
                end
                end
                end
            end
        end,
        ---PentoolBrush interface copy
        ---@param self PentoolBoxBrush
        ---@return PentoolPointBrush
        copy = function(self)
            return {
                draw = self.draw,
                copy = self.copy,
                node = {name=self.node.name, param1=self.node.param1, param2=self.node.param2},
            }
        end,
        node = node
    }
end

--[[
    PenToolShapedPointBrush

    the PenToolShapedPointBrush can draw shaped nodes based on the intesection with sub-node points (each corner of the node, if it was subdivided on all axis once)

    It uses a nearest-match feature to select the shape.

    Shapes are selected by bit fields. Each bit field has 8 bits - one for each of the points in the subdivided cube. 
    Starting in the bottom right and moving to the top left, xyz order


]]



local shapes = {
    [0xff] = {
        -- full block
        postfix= "",
        param2 = 0,
    },

    -- upright stairs
    [0xdd] = { -- 1101 1101
        postfix= "_stair",
        param2 = 1,
    },
    [0xfc] = { -- 1111 1100
        postfix= "_stair",
        param2 = 26,
    },
    [0xee] = { -- 1110 1110
        postfix= "_stair",
        param2 = 3,
    },
    [0xcf] = { -- 1100 1111
        postfix= "_stair",
        param2 = 0,
    },

    -- upside down stairs
    [0x77] = { -- 0111 0111
        postfix= "_stair",
        param2 = 23,
    },
    [0x3f] = { -- 0011 1111
        postfix= "_stair",
        param2 = 20,
    },
    [0xbb] = { -- 1011 1011
        postfix= "_stair",
        param2 = 21,
    },
    [0xf3] = { --  1111 0011
        postfix= "_stair",
        param2 = 22,
    },

    -- sideways stairs
    [0xaf] = { -- 1010 1111
        postfix= "_stair",
        param2 = 12,
    },
    [0x5f] = { -- 0101 1111
        postfix= "_stair",
        param2 = 16,
    },
    [0xfa] = { -- 1111 1010
        postfix= "_stair",
        param2 = 14,
    },
    [0xf5] = { -- 1111 0101
        postfix= "_stair",
        param2 = 18,
    },

    --slabs
    [0xcc] = { -- 1100 1100
        postfix= "_slab",
        param2 = 0,
    },
    [0xf0] = { -- 1111 0000
        postfix= "_slab",
        param2 = 4,
    },
    [0x0f] = { -- 0000 1111
        postfix= "_slab",
        param2 = 8,
    },
    [0xaa] = { -- 1010 1010
        postfix= "_slab",
        param2 = 12,
    },
    [0x55] = { -- 0101 0101
        postfix= "_slab",
        param2 = 16,
    },
    [0x33] = { --  0011 0011
        postfix= "_slab",
        param2 = 20,
    },
}

--[[
0b0000 0x0   |   0b1000 0x8
0b0001 0x1   |   0b1001 0x9
0b0010 0x2   |   0b1010 0xa
0b0011 0x3   |   0b1011 0xb
0b0100 0x4   |   0b1100 0xc
0b0101 0x5   |   0b1101 0xd
0b0110 0x6   |   0b1110 0xe
0b0111 0x7   |   0b1111 0xf
]]

---Get the quadrant that a specific pos is withing a node, as a bitfield
---@param pos Vector
---@param nodePos Vector
---@return integer
local function get_quadrant_bit(pos, nodePos)
    local b = bit.tobit(1)
    if pos.z < nodePos.z then
        b = bit.lshift(b, 4)
    end
    if pos.y < nodePos.y then
        b = bit.lshift(b, 2)
    end
    if pos.x < nodePos.x then
        b = bit.lshift(b, 1)
    end
    --print(pos:to_string(), b)
    return b
end

---Count the high bits in a bitfield, but only the first byte
---@param bits integer
---@return integer
local function count_bits_onebyte(bits)
    local count = 0;
    for i=0,7 do
        if (bit.band(bit.rshift(bits, i), 0x1) == 0x1) then
            count = count + 1
        end
    end
    return count
end

local function byte_to_string(bits)
    local str = "";
    for i=0,7 do
        if (bit.band(bit.rshift(bits, i), 0x1) == 0x1) then
            str = "1" .. str
        else
            str = "0" .. str
        end
    end
    return "0b" .. str
end

---@class PenToolShapedPointBrush:PentoolBrush
---@field node NodeRef
---@field map_of_nodes table<integer,{pos:Vector,field:integer,draw:boolean}>
---@field spacing number
---@field debug boolean

---Create a PenToolShapedPointBrush. This brush type draws a single node, and does not take into account shaped nodes or the scale of the current context.
---Works via minetest.set_node(...)
---@param node NodeRef|ItemName
---@param spacing number? space around the original poitn to sample
---@param debug boolean? draw debug points
---@return PenToolShapedPointBrush
function qts.pentool.create_shaped_point_brush(node, spacing, debug)
    if type(node) == "string" then
        node = {name=node}
    end
    if debug==nil then debug = false end
    if spacing == nil then spacing = 0.25 end

    return {
        ---PentoolBrush interface
        ---@param self PenToolShapedPointBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
            if (context:get_draw_alpha() < weight) then
                local bitfield = 0x00;
                local node_pos = vector.round(transform.pos)
                for i = 1,2 do
                    local offset = self.spacing / i
                    --qtcore.debug_point(transform.pos, "#7070ff", 8, 300)
                    --qtcore.debug_point(node_pos, "#0000ff", 8, 300)
                    for z = 0,1 do
                    for y = 0,1 do
                    for x = 0,1 do
                        local rel_pos = vector.new(
                            qts.lerp(-offset,offset,x),
                            qts.lerp(-offset,offset,y),
                            qts.lerp(-offset,offset,z)
                        )
                        local abs_pos = transform:absolute_position_no_scale(rel_pos)
                        local hit_node_pos = vector.round(abs_pos)
                        if self.debug then
                            qtcore.debug_point(abs_pos, "#ff0000", 3, 300)
                        end
                        --print(abs_pos:to_string())
                        bitfield = bit.bor(bitfield, get_quadrant_bit(abs_pos, hit_node_pos))
                        local hash = minetest.hash_node_position(hit_node_pos)

                        if self.debug then
                            qtcore.debug_point(hit_node_pos, "#00ff00", 5, 300)
                        end

                        local is_center = vector.equals(node_pos, hit_node_pos)

                        if self.map_of_nodes[hash] == nil then

                            self.map_of_nodes[hash] = {pos = hit_node_pos, field = bitfield, draw=is_center}
                        else
                            if not (vector.equals(self.map_of_nodes[hash].pos, hit_node_pos)) then
                                minetest.debug("Hash collision!!!!", self.map_of_nodes[hash].pos, hit_node_pos, hash)
                            end
                            self.map_of_nodes[hash].field = bit.bor(self.map_of_nodes[hash].field, bitfield)
                            self.map_of_nodes[hash].draw = self.map_of_nodes[hash].draw or is_center
                        end
                    end
                    end
                    end
                end
            end
        end,

        ---comment
        ---@param self PenToolShapedPointBrush
        ---@param context PentoolContext
        stroke_end = function(self, context)
            local matches = {}
            local bitfield_to_best = {}
            --first, gather all the matching positions
            for _, entry in pairs(self.map_of_nodes) do
                if entry.draw then
                    local bestmatch = 0xff
                    local lowesterr = 0x8 --highest possible error - only counting 8 bits
                    
                    -- keep track of the best match for each bitfield, so that we don't have to do as many loops
                    if bitfield_to_best[entry.field] then
                        bestmatch = bitfield_to_best[entry.field]
                        lowesterr = 0
                    else
                        for field, data in pairs(shapes) do
                            local err = count_bits_onebyte(bit.bxor(entry.field, field))
                            --print(byte_to_string(bitfield) .. " ^ " .. byte_to_string(field) .. " -> err: ", err)
                            if err < lowesterr then
                                bestmatch = field
                                lowesterr = err
                            end
                            -- special case - no need to search more
                            if err == 0 then
                                break
                            end
                        end

                        if lowesterr < 4 then 
                            bitfield_to_best[entry.field] = bestmatch
                        end


                    end

                    if lowesterr < 4 then 
                        if matches[bestmatch] then
                            matches[bestmatch][#matches[bestmatch]+1] = entry.pos
                        else
                            matches[bestmatch] = {entry.pos}
                        end
                    end
                end
            end

            -- now, since the nodes are already grouped by what node and what param2 they have, 
            -- we can use the slightly faster minetest.bulk_set_node(...)
            for bitfield, nodelist in pairs(matches) do
                local node = {name=self.node.name .. shapes[bitfield].postfix, param2=shapes[bitfield].param2, param1 = self.node.param1}
                minetest.bulk_set_node(nodelist, node)
            end
            -- reset the map of nodes
            self.map_of_nodes = {}
        end,

        ---PentoolBrush interface copy
        ---@param self PenToolShapedPointBrush
        ---@return PenToolShapedPointBrush
        copy = function(self)
            return {
                draw = self.draw,
                copy = self.copy,
                node = {name=self.node.name, param1=self.node.param1, param2=self.node.param2},
                map_of_nodes = {},
                spacing = self.spacing,
                debug=self.debug,
            }
        end,
        node = node,
        map_of_nodes = {},
        spacing = spacing,
        debug=debug,
    }
end



---@class PentoolGreedyBoxBrush:PentoolBrush
---@field node NodeRef
---@field spacing number
---@field node_set {number:Vector}

---Create a PentoolBoxBrush. This brush type draws a box of nodes that is scaled to match the PenTool. It does not smooth ShapedNodes.
---Each full Box is controlled by the weight, not individual nodes.
---Works via minetest.set_node(...)
---@param node NodeRef|ItemName
---@return PentoolGreedyBoxBrush
function qts.pentool.create_greedy_box_brush(node, spacing)
    if type(node) == "string" then
        node = {name=node}
    end

    if spacing == nil then spacing = 0.25 end

    return {
        ---PentoolBrush interface
        ---@param self PentoolGreedyBoxBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
            if (context:get_draw_alpha() < weight) then
                for x=-math.floor((transform.scale.x-1)/2), math.floor(transform.scale.x/2) do
                for y=-math.floor((transform.scale.y-1)/2), math.floor(transform.scale.y/2) do
                for z=-math.floor((transform.scale.z-1)/2), math.floor(transform.scale.z/2) do
                    local pos = transform:absolute_position_no_scale(vector.new(x,y,z))
                    
                    --minetest.set_node(pos:round(), self.node)

                    local offset = self.spacing
                    --qtcore.debug_point(transform.pos, "#7070ff", 8, 300)
                    --qtcore.debug_point(node_pos, "#0000ff", 8, 300)
                    for z2 = 0,1 do
                    for y2 = 0,1 do
                    for x2 = 0,1 do
                        local tf = transform.new(vector.new(0,0,0), transform.rot, vector.new(1,1,1))
                        local offset_vector = tf:absolute_position_no_scale(vector.new(
                            qts.lerp(-offset,offset,x2),
                            qts.lerp(-offset,offset,y2),
                            qts.lerp(-offset,offset,z2)
                        ))
                        local node_pos = vector.add(pos, offset_vector):round()
                        
                        local hash = minetest.hash_node_position(node_pos)
                        if self.node_set[hash] == nil then
                            self.node_set[hash] = node_pos
                        end

                    end
                    end
                    end
                end
                end
                end
            end
        end,
        ---when the stroke ends
        ---@param self PentoolGreedyBoxBrush
        ---@param context PentoolContext
        stroke_end = function(self, context)
            local point_list = {}
            for _, pos in pairs(self.node_set) do
                point_list[#point_list+1] = pos
            end
            minetest.bulk_set_node(point_list, self.node)
        end,
        ---PentoolBrush interface copy
        ---@param self PentoolGreedyBoxBrush
        ---@return PentoolGreedyBoxBrush
        copy = function(self)
            return {
                draw = self.draw,
                copy = self.copy,
                node = {name=self.node.name, param1=self.node.param1, param2=self.node.param2},
                spacing = spacing,
                node_set = {}
            }
        end,
        node = node,
        spacing = spacing,
        node_set = {},
    }
end