--[[
    Pentool Context

    A Pentool context is the drawing interface for a pentool. 
    The context keeps track of the current stack, pen transform, brush, and similar
]]



---@class PentoolContext
---@field transform Transform the transform of the Pentool
---@field draw_weight Alpha the weight for drawing. 0: no drawing. 1: always draw
---@field _stack table Internal stack of pushes and pops. Do not use directly.
---@field _seed number Internal seed for random numbers. Do not use directly.
---@field _random PCGRandom Internal random number generator, used for the pentool random calls. Do not use directly.
---@field _drawrandom PCGRandom Internal random number generator, used for drawing nodes. Do not use directly.
qts.pentool.context_base = {
    ---@type table the metatable for PentoolContext
    __mt = {
        --no new indices allowed in PentoolContext
        __newindex = nil
    },

    ---Create a Pentool Context
    ---@param origin Transform the original transform
    ---@param tbl table? table to create the pentool context in
    create = function(origin, tbl)
        if not transform.check(origin) then
            minetest.log(dump(origin))
            error("Failed to create a Pentool context: Origin is not a Transform!")
        end
        if tbl == nil then
            tbl = {}
        end
        tbl.transform = origin
        tbl.draw_weight = 1
        tbl._stack = {}
        tbl._seed = origin:hashpos()
        tbl._random = PcgRandom(tbl._seed)
        tbl._drawrandom = PcgRandom(tbl._seed)
        setmetatable(tbl, qts.pentool.context_base.__mt)
        return tbl
    end,

    ---Set the draw chance
    ---@param context PentoolContext
    ---@param weight Alpha 0: no placement. 1:always place
    ---@return PentoolContext
    drawweight = function(context, weight)
        context.draw_weight = qts.clamp(weight, 0, 1)
        return context
    end,

    ---Disable drawing
    ---@param context PentoolContext
    ---@return PentoolContext
    penup = function (context)
        context:drawweight(0)
        return context
    end,

    ---Enable drawing at 100 percent chance
    ---@param context PentoolContext
    ---@return PentoolContext
    pendown = function (context)
        context:drawweight(1)
        return context
    end,

    ---Move the pen forward N nodes. Cannot move the pen backwards with a negative distance. (YET)
    ---As a rule, Pentool writes to a node when its position *enters* that node.
    ---If a pentool is at {0,0,0} and moves 5 blocks up, it will not change the node at {0,0,0}
    ---@param context PentoolContext
    ---@param distance number how far to move
    ---@param snap boolean? should it snap to the nearest node at each step
    ---@return PentoolContext
    forward = function(context, distance, snap)
        if snap == nil then snap = false end;
        if (distance <= 0) then return context end;
        for i = 0, math.floor(distance) do
            --calculate the new pen location, one unit on
            context.transform:translate(context.transform:forward())
            --snap, if we should
            if (snap) then
                context.transform:set_pos(context.transform.pos:round())
            end
            --draw, if we can
            if (context.draw_weight > 0 and context._drawrandom:next(0, 1000)/1000.0 < context.draw_weight) then
                -- TEMP
                minetest.set_node(context.transform.pos, {name="default:default"})
            end
        end
        return context;
    end,

    ---Rotate the pen relative to its current rotation.
    ---Currently does not draw.
    ---@param context PentoolContext
    ---@param rotation Rotator
    ---@return PentoolContext
    rotate = function(context, rotation)
        context.transform:rotate(rotation)
        return context
    end,

    ---Push the current transform to the stack
    ---@param context PentoolContext
    ---@return PentoolContext
    push = function(context)
        context._stack[#context._stack+1] = context.transform:copy()
        return context;
    end,

    ---Restore the pentool to its transform before the last pop. Removes that transform from the stack.
    ---@param context any
    ---@return any
    pop = function(context)
        if (#context._stack > 0) then
            context.transform = context._stack[#context._stack]:copy()
            context._stack[#context._stack] = nil
        end
        return context;
    end,

    ---Restore the pentool to its transform before the last pop. Does not removes that transform from the stack.
    ---@param context any
    ---@return any
    peak = function(context)
        if (#context._stack > 0) then
            context.transform = context._stack[#context._stack]:copy()
        end
        return context;
    end,
}

--set the context as the metatable 
qts.pentool.context_base.__mt.__index  = qts.pentool.context_base