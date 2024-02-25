--[[
    A Pentool Brush is what makes PenTool's draw into the world.
    
    Any PenTool brush follows a certain interface. Custom brush types can be made. 
]]

---@class PentoolBrush
---@field draw fun(self:PentoolBrush, transform:Transform, weight:Alpha, context:PentoolContext):nil
---@field copy fun(self:PentoolBrush):PentoolBrush

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
                for x=-transform.scale.x, transform.scale.x do
                for y=-transform.scale.y, transform.scale.y do
                for z=-transform.scale.z, transform.scale.z do
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

