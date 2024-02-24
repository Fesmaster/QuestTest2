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

---Create a PentoolBrushPoint. This brush type draws a single node, and does not take into account shaped nodes.
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

