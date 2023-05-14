--[[
    Helper functions for dealing with vec2 fields
]]

---@class vec2
---@field x number
---@field y number

qts.scribe.vec2 = {
    
    ---check if a vec2 is valid
    ---@param v any
    is_valid = function (v)
        return v and type(v) == "table" and 
            v.x and v.y and
            type(v.x) == "number" and type(v.y) == "number"
    end,

    ---Turn a vec2 into a string, sutable for inserting into formspec. Always safe, returns "0,0" if vec2 is invalid
    ---@param v vec2
    tostring = function (v)
        if qts.scribe.vec2.is_valid(v) then
            return ""..v.x..","..v.y
        end
        return "0,0"
    end,

    ---Copy a vec2 into a destination. safe if src is not a valid vec2
    ---@param src vec2
    ---@param dest vec2|nil
    ---@return vec2 dest
    copy = function(src, dest)
        if type(dest) ~= "table" then
            dest = {}
        end
        if qts.scribe.vec2.is_valid(src) then
            dest.x = src.x
            dest.y = src.y
        else
            dest.x=dest.x or 0
            dest.y=dest.y or 0
        end
        return dest
    end,

    ---Get the minimum of vec2 a, b and put it in dest
    ---@param a vec2
    ---@param b vec2
    ---@param dest vec2|nil
    ---@return vec2 dest
    min = function(a, b, dest)
        if dest == nil then
            dest = {}
        end
        dest.x = math.min(a.x, b.x)
        dest.y = math.min(a.y, b.y)
        return dest
    end,

    ---Get the maximum of vec2 a, b and put it in dest
    ---@param a vec2
    ---@param b vec2
    ---@param dest vec2|nil
    ---@return vec2 dest
    max = function(a, b, dest)
        if dest == nil then
            dest = {}
        end
        dest.x = math.max(a.x, b.x)
        dest.y = math.max(a.y, b.y)
        return dest
    end,
}