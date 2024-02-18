--[[
    Pentool Context

    A Pentool context is the drawing interface for a pentool. 
    The context keeps track of the current stack, pen transform, brush, and similar
]]



---@class PentoolContext
---@field transform Transform the transform of the Pentool
---@field original_transform Transform the transform of the Pentool at its created. 
---@field draw_weight Alpha the weight for drawing. 0: no drawing. 1: always draw
---@field brush PentoolBrush The current brush, used for drawing into the world.
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
        tbl.transform = origin:copy()
        tbl.original_transform = origin:copy()
        tbl.draw_weight = 1
        tbl.brush = qts.pentool.create_empty_brush()
        tbl._stack = {}
        tbl._seed = origin:hashpos()
        tbl._random = PcgRandom(tbl._seed)
        tbl._drawrandom = PcgRandom(tbl._seed)
        setmetatable(tbl, qts.pentool.context_base.__mt)
        return tbl
    end,

    ---Set the draw chance
    ---@param self PentoolContext
    ---@param weight Alpha 0: no placement. 1:always place
    ---@return PentoolContext
    drawweight = function(self, weight)
        self.draw_weight = qts.clamp(weight, 0, 1)
        return self
    end,

    ---Disable drawing
    ---@param self PentoolContext
    ---@return PentoolContext
    penup = function (self)
        self:drawweight(0)
        return self
    end,

    ---Enable drawing at 100 percent chance
    ---@param self PentoolContext
    ---@return PentoolContext
    pendown = function (self)
        self:drawweight(1)
        return self
    end,

    ---Move the pen forward N nodes. Cannot move the pen backwards with a negative distance. (YET)
    ---As a rule, Pentool writes to a node when its position *enters* that node.
    ---If a pentool is at {0,0,0} and moves 5 blocks up, it will not change the node at {0,0,0}
    ---@param self PentoolContext
    ---@param distance number how far to move
    ---@param step number? step
    ---@param snap boolean? should it snap to the nearest node at each step
    ---@return PentoolContext
    forward = function(self, distance, step, snap)
        if snap == nil then snap = false end
        if step == nil then step = 1 end
        if (distance <= 0) then return self end;
        
        for i = 1, distance * self.transform.scale.z, step do
            --calculate the new pen location, one unit on
            self.transform:translate(self.transform:forward())
            --snap, if we should
            if (snap) then
                self.transform:set_pos(self.transform.pos:round())
            end
            --draw, if we can
            self.brush:draw(self.transform, self.draw_weight, self)
        end
        return self;
    end,


    ---Draw at the current location
    ---@param self PentoolContext
    ---@return PentoolContext
    mark = function(self)
        self.brush:draw(self.transform, self.draw_weight, self)
        return self
    end,

    ---Rotate the pen relative to its current rotation.
    ---Currently does not draw.
    ---@param self PentoolContext
    ---@param rotation Rotator
    ---@return PentoolContext
    rotate = function(self, rotation)
        self.transform:rotate(rotation)
        return self
    end,

    ---Push the current transform to the stack
    ---@param self PentoolContext
    ---@return PentoolContext
    push = function(self)
        self._stack[#self._stack+1] = {
            transform = self.transform:copy(),
            brush = self.brush:copy(),
        }
        return self;
    end,

    ---Restore the pentool to its transform before the last pop. Removes that transform from the stack.
    ---@param self any
    ---@return any
    pop = function(self)
        if (#self._stack > 0) then
            self.transform = self._stack[#self._stack].transform:copy()
            self.brush = self._stack[#self._stack].brush:copy()
            self._stack[#self._stack] = nil
        end
        return self;
    end,

    ---Restore the pentool to its transform before the last pop. Does not removes that transform from the stack.
    ---@param self any
    ---@return any
    peek = function(self)
        if (#self._stack > 0) then
            self.transform = self._stack[#self._stack].transform:copy()
            self.brush = self._stack[#self._stack].brush:copy()
        end
        return self;
    end,

    ---Get the chance for drawing a node
    ---@param self PentoolContext
    ---@return Alpha
    get_draw_chance = function(self)
        return self._drawrandom:next(0, 1000)/1000.0
    end,

    ---Get a random value in the range of [min, max]. Limeted to integers
    ---@param self PentoolContext
    ---@param min integer
    ---@param max integer
    ---@return integer
    get_random_int_in_range = function(self, min, max)
        return self._random:next(min, max)
    end,

    ---Set the current brush
    ---@param self PentoolContext
    ---@param brush PentoolBrush
    ---@return PentoolContext
    set_brush = function (self, brush)
        self.brush = brush
        return self
    end,

    ---Teleport relative to the current pen position
    ---@param self PentoolContext
    ---@param pos Vector
    ---@return PentoolContext
    teleport_relative = function(self, pos)
        self.transform:set_pos(self.transform:absolute_position(pos))
        return self
    end,
    
    ---teleport relative to the original starting position
    ---@param self PentoolContext
    ---@param pos Vector
    ---@return PentoolContext
    teleport_origin = function(self, pos)
        self.transform:set_pos(self.original_transform:absolute_position(pos))
        return self
    end,

    ---Face upwards
    ---@param self PentoolContext
    ---@param keepRelative boolean? Keep the current yaw and roll. Default: true
    ---@return PentoolContext
    face_up = function(self, keepRelative)
        if (keepRelative == nil) then keepRelative = true end
        self.transform:set_rot(vector.new(
            math.rad(90), 
            qts.select(keepRelative, self.transform.rot.y, 0), 
            qts.select(keepRelative, self.transform.rot.z, 0)
        ))
        return self
    end,
    
    ---Face downward
    ---@param self PentoolContext
    ---@param keepRelative boolean? Keep the current yaw and roll. Default: true
    ---@return PentoolContext
    face_down = function(self, keepRelative)
        if (keepRelative == nil) then keepRelative = true end
        self.transform:set_rot(vector.new(
            math.rad(-90), 
            qts.select(keepRelative, self.transform.rot.y, 0), 
            qts.select(keepRelative, self.transform.rot.z, 0)
        ))
        return self
    end,

    ---Face the horizon
    ---@param self PentoolContext
    ---@param keepRelative boolean? Keep the current yaw and roll. Default: true
    ---@return PentoolContext
    face_horizontal = function(self, keepRelative)
        if (keepRelative == nil) then keepRelative = true end
        self.transform:set_rot(vector.new(
            0, 
            qts.select(keepRelative, self.transform.rot.y, 0), 
            qts.select(keepRelative, self.transform.rot.z, 0)
        ))
        return self
    end,

    ---Debug print the current transform, and its location relative to the origin transform
    ---@param self PentoolContext
    ---@return PentoolContext
    debug_transform = function(self)
        minetest.log("Pentool Debug Transform.\nTransform: " 
            .. self.transform:format()..
            "\nOrigin Transform: " .. self.original_transform:format() ..
            "\nRelative Location: " .. self.original_transform:relative_position(self.transform.pos):to_string())
        return self
    end,

    ---Scale the current pen as a multiple of its current scale.
    ---@param self PentoolContext
    ---@param scale Vector
    ---@return PentoolContext
    scale = function(self, scale)
        self.transform:set_scale(self.transform.scale * scale)
        return self
    end,

    ---Set the absolute scale the current pen.
    ---@param self PentoolContext
    ---@param scale Vector
    ---@return PentoolContext
    set_scale = function(self, scale)
        self.transform:set_scale(scale)
        return self
    end,
}

--set the context as the metatable 
qts.pentool.context_base.__mt.__index  = qts.pentool.context_base