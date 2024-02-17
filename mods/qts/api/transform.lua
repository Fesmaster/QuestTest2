--[[
    Transforms (combination of pos, rot, and scale)
]]

---@class Transform
---@field pos Vector The position of the Transform. Do not set directly.
---@field rot Rotator The rotation of the Transform. Do not set directly.
---@field scale Vector  The scale of the Transform. Do not set directly.
---@field _cache table  Internal cache for calculated params like Right(), Forward(), and Up(). Do not use.
---@diagnostic disable-next-line: lowercase-global
transform = {
    __mt = {
        __newindex = nil
    },

    ---create a new transform
    ---@param pos Vector
    ---@param rot Rotator
    ---@param scale Vector
    ---@return Transform
    new = function(pos, rot, scale)
        if pos == nil then pos = vector.new(0,0,0) end
        if rot == nil then rot = vector.new(0,0,0) end
        if scale == nil then scale = vector.new(1,1,1) end
    	local v = {
    		pos=pos,
    		rot=rot,
    		scale=scale,
            _cache={},
    	}
    	setmetatable(v, transform.__mt)
        return v
    end,

    copy = function(t)
        return t.new(t.pos, t.rot, t.scale)
    end,

    ---check if an object is a transform
    ---@param t any
    check = function(t)
        if type(t) ~= "table" then return false end
        if (
            t.pos == nil or
            vector.check(t.pos) == false or
            t.rot == nil or
            vector.check(t.rot) == false or
            t.scale == nil or
            vector.check(t.scale) == false
        ) then
            return false
        end
        return true
    end,

    ---Hash the transform. All attributes are floored to the nearest int.
    ---@param t Transform
    ---@return number
    hash = function(t)
        return bit.bxor(
            math.floor(t.pos.x),
            math.floor(t.pos.y),
            math.floor(t.pos.z),
            math.floor(t.rot.x),
            math.floor(t.rot.y),
            math.floor(t.rot.z),
            math.floor(t.scale.x),
            math.floor(t.scale.y),
            math.floor(t.scale.z)
        )
    end,

    ---Hash the position of the transform. All attributes are floored to the nearest int.
    ---@param t Transform
    ---@return number
    hashpos = function(t)
        return bit.bxor(
            math.floor(t.pos.x),
            math.floor(t.pos.y),
            math.floor(t.pos.z)
        )
    end,

    ---Set the position of a Transform
    ---@param t Transform
    ---@param pos Vector
    set_pos = function(t, pos)
        t.pos = pos:copy()
        --t._cache = {}        
    end,

    ---Set the rotation of a Transform
    ---@param t Transform
    ---@param rot Rotator
    set_rot = function(t, rot)
        t.rot = rot:copy()
        t._cache = {}        
    end,

    ---Set the scale of a Transform
    ---@param t Transform
    ---@param scale Vector
    set_scale = function(t, scale)
        t.scale = scale:copy()
        --t._cache = {}        
    end,

    ---Get the right vector of the transform
    ---@param t Transform
    ---@return Vector
    right = function(t)
        if not t._cache.right then t._cache.right = t.rot:get_right_vector() end
        return t._cache.right
    end,

    ---Get the forward vector of the transform
    ---@param t Transform
    ---@return Vector
    forward = function(t)
        if not t._cache.forward then t._cache.forward = t.rot:get_forward_vector() end
        return t._cache.forward
    end,

    ---Get the up vector of the transform
    ---@param t Transform
    ---@return Vector
    up = function(t)
        if not t._cache.up then t._cache.up = t.rot:get_up_vector() end
        return t._cache.up
    end,

    ---Move the transform
    ---@param t Transform
    ---@param pos Vector
    translate = function(t, pos)
        t:set_pos(t.pos + pos)
    end,

    ---Rotate the transform
    ---@param t Transform
    ---@param rot Rotator
    rotate = function(t, rot)
        -- SO, the rotation has to be applied backwards (the added `rot` first, then the rotation from the transform. 
        -- Otherwise, things like base roll do not apply.
        local forward =rot:get_forward_vector():rotate(t.rot)
        local up = rot:get_up_vector():rotate(t.rot)
        local right = vector.cross(up, forward)
        up = vector.cross(forward, right)
        
        t:set_rot(forward:dir_to_rotation(up))
    end,

    ---Turn the transform into a string
    ---@param t Transform
    ---@return string
    to_string = function(t)
        return "{pos="..t.pos:to_string()..",rot="..t.rot:to_string()..",scale="..t.scale:to_string().."}"
    end,

    ---Turn the transform into a formatted string
    ---@param t Transform
    ---@param prefix any? a prefix for new lines
    ---@return string
    format = function(t, prefix)
        if (prefix == nil) then prefix = "" end
        if type(prefix)  ~= "string" then prefix = tostring(prefix) end
        return "{\n"..
            prefix.."\tpos="..t.pos:to_string()..
            ",\n"..prefix.."\trot="..t.rot:copy():apply(math.deg):to_string()..
            ",\n"..prefix.."\tscale="..t.scale:to_string()..
            ",\n"..prefix.."\tForward="..t:forward():to_string()..
            ",\n"..prefix.."\tRight="..t:right():to_string()..
            ",\n"..prefix.."\tUp="..t:up():to_string()..
            "\n"..prefix.."}"
    end,
}
transform.__mt.__index = transform