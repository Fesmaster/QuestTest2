--[[
Chat Command Lib
Chat Command Lib is a series of functions in the qts namespace that are about parsing chatcommand paramaters
]]

---@alias ChatcommandParamType
---|"boolean"
---|"integer"
---|"number"
---|"string"
---|"vector"
---|"transform"

---@alias ChatcommandTypes
---|boolean
---|integer
---|number
---|string
---|Vector
---|Transform

---Parse a vector from a string.
---@param arg string
---@param object ObjectRef?
---@param node NodeRefWithPos?
---@return Vector?
local function parse_vector(arg, object, node)
    local fields = string.split(arg, ",", false)
	if #fields ~= 3 then
        if (object and object:is_player()) then
            ---@cast object Player
		    minetest.chat_send_player(object:get_player_name(), "Unable to parse vector. String format invalid. Use 'x,y,z' format. Each can be a number for absolute or a number preceded by '~' for relative to the object.")
        end
        return
	end
    
    local v = vector.new(0,0,0)
    local idx = {"x", "y", "z"}
    for i = 1, 3 do
        local str = fields[i]
        local element = idx[i]
        if string.sub(str, 1,1) == "~" and object then
            if (string.len(str) == 1) then
                v[element] = object:get_pos()[element]
            else
                local off = tonumber(string.sub(str, 2))
                if off then
                    v[element] = object:get_pos()[element] + off
                else
                    if (object:is_player()) then
                        ---@cast object Player
                        minetest.chat_send_player(object:get_player_name(), "Unable to parse vector. String format invalid. Use 'x,y,z' format. Each can be a number for absolute or a number preceded by '~' for relative to the object.")
                    end
                    return
                end
            end
        elseif string.sub(str, 1,1) == "^" and node and node.pos then
            if (string.len(str) == 1) then
                v[element] = node.pos[element]
            else
                local off = tonumber(string.sub(str, 2))
                if off then
                    v[element] = node.pos[element] + off
                else
                    if (object and object:is_player()) then
                        ---@cast object Player
                        minetest.chat_send_player(object:get_player_name(), "Unable to parse vector. String format invalid. Use 'x,y,z' format. Each can be a number for absolute or a number preceded by '~' for relative to the object.")
                    end
                    return
                end
            end
        else
            local abs = tonumber(str)
            if abs then
                v[element] = abs
            else
                if (object and object:is_player()) then
                    ---@cast object Player
                    minetest.chat_send_player(object:get_player_name(), "Unable to parse vector. String format invalid. Use 'x,y,z' format. Each can be a number for absolute or a number preceded by '~' for relative to the object.")
                end
                return
            end
        end
    end
    return v
end

---Parse a vector from a string.
---@param arg string
---@param object ObjectRef?
---@param node NodeRefWithPos?
---@return Transform?
local function parse_transform(arg, object, node)
    local fields = string.split(arg, ",", false)
	--defaults for rotation and scale
    if #fields == 3 then
        fields[4] = "0"
        fields[5] = "0"
        fields[6] = "0"
    end
    if #fields == 6 then
        fields[7] = "1"
        fields[8] = "1"
        fields[9] = "1"
    end

    if #fields ~= 9 then
        if (object and object:is_player()) then
            ---@cast object Player
		    minetest.chat_send_player(object:get_player_name(), "Unable to parse transform. String format invalid. Use 'x,y,z[,roll,pitch,yaw[,scale_x,scale_y,scale_z]]' format. Each can be a number for absolute, and some numbers can be preceded by '~' for relative to the object.")
        end
        return
	end
    
    local t = transform.new(vector.new(0,0,0),vector.new(0,0,0),vector.new(0,0,0))
    local idx = {"pos", "rot", "scale"}
    local idx2 = {"x", "y", "z", "z", "x", "y", "x", "y", "z"}
    for i = 1, 9 do
        local str = fields[i]
        local major_element = idx[math.ceil(i/3)]
        local minor_element = idx2[i]
        
        if (major_element == "pos" or major_element == "rot") and string.sub(str, 1,1) == "~" and object then
            local off = tonumber(string.sub(str, 2))
            local base = 0
            if major_element == "rot" then
                --radian adjustment
                if (off) then off = math.rad(off) end

                -- calculaton of the base rotation
                if (object:is_player()) then
                    ---@cast object Player
                    if idx2 == "x" then
                        --pitch
                        base = math.deg(object:get_look_vertical())
                    elseif idx2 == "y" then
                        --yaw
                        base = math.deg(object:get_look_horizontal())
                    elseif idx2 == "z" then
                        --roll
                        base = 0
                    end
                else
                    ---@cast object LuaObject
                    base = object:get_rotation()[minor_element]
                end
                --set the rotation
                --t.rot[minor_element] = base + off
            else --guaranteed to be pos
                base = object:get_pos()[minor_element]
                --t.pos[minor_element] = base + off
            end

            if (string.len(str) == 1) then
                t[major_element][minor_element] = base
            else                
                if off then
                    t[major_element][minor_element] = base + off
                else
                    if (object and object:is_player()) then
                        ---@cast object Player
                        minetest.chat_send_player(object:get_player_name(), "Unable to parse transform. String format invalid. Use 'x,y,z[,roll,pitch,yaw[,scale_x,scale_y,scale_z]]' format. Each can be a number for absolute, and some numbers can be preceded by '~' for relative to the object.")
                    end
                    return
                end
            end
        elseif major_element == "pos" and string.sub(str, 1,1) == "^" and node and node.pos then
            -- can only be pos
            if (string.len(str) == 1) then
                t.pos[minor_element] = node.pos[minor_element]
            else
                local off = tonumber(string.sub(str, 2))
                if off and node and node.pos then
                    t.pos[minor_element] = node.pos[minor_element] + off
                else
                    if (object and object:is_player()) then
                        ---@cast object Player
                        minetest.chat_send_player(object:get_player_name(), "Unable to parse transform. String format invalid. Use 'x,y,z[,roll,pitch,yaw[,scale_x,scale_y,scale_z]]' format. Each can be a number for absolute, and some numbers can be preceded by '~' for relative to the object.")
                    end
                    return
                end
            end
        else
            local abs = tonumber(str)
            if (major_element == "rot") then
                abs = math.rad(abs)
            end
            if abs then
                t[major_element][minor_element] = abs
            else
                if (object and object:is_player()) then
                    ---@cast object Player
                    minetest.chat_send_player(object:get_player_name(), "Unable to parse transform. String format invalid. Use 'x,y,z[,roll,pitch,yaw[,scale_x,scale_y,scale_z]]' format. Each can be a number for absolute, and some numbers can be preceded by '~' for relative to the object.")
                end
                return
            end
        end
    end
    return t
end

---Parse and Breakdown chatcommand arguments
---@param args string
---@param types ChatcommandParamType[]
---@param object ObjectRef?
---@param node NodeRefWithPos?
---@return ChatcommandTypes[]
function qts.breakdown_args(args, types, object, node)
    args:trim()
    local fields = args:split(" ", false)
    local typeIndex = 1
    local output = {}
    for _, arg in ipairs(fields) do
        if (arg ~= "") then
            if (typeIndex > #types) then
                output[#output+1] = arg
            else
                local type = types[typeIndex]
                if type == "boolean" then
                    if minetest.is_yes(arg) or arg == "on" then
                        output[#output+1] = true
                    else
                        output[#output+1] = false
                    end
                elseif type == "integer" then
                    local num = tonumber(arg)
                    if (num) then
                        output[#output+1] = math.round(num)
                    else
                        if (object and object:is_player()) then
                            ---@cast object Player
                            minetest.chat_send_player(object:get_player_name(), "Unable to parse integer.")
                        end
                        return
                    end
                elseif type == "number" then
                    local num = tonumber(arg)
                    if (num) then
                        output[#output+1] = num
                    else
                        if (object and object:is_player()) then
                            ---@cast object Player
                            minetest.chat_send_player(object:get_player_name(), "Unable to parse number.")
                        end
                        return
                    end
                elseif type == "string" then
                    output[#output+1] = arg
                elseif type == "vector" then
                    local v = parse_vector(arg, object, node)
                    if (v == nil) then return end --err message handled already
                    output[#output+1] = v
                elseif type == "transform" then
                    local t = parse_transform(arg, object, node)
                    if (t == nil) then return end --err message handled already
                    output[#output+1] = t
                end
            end
            typeIndex = typeIndex + 1
        end
    end
    return output
end

if qts.ISDEV then
    
minetest.register_chatcommand("testparse", {
    params = "<bool>, <int>, <number>, <string>, <vector>, <transform>",
	description = "Tests chat command parsing",
	func = function(name, param)
		local args = qts.breakdown_args(param, {"boolean", "integer", "number", "string", "vector", "transform"}, minetest.get_player_by_name(name), nil)
        if (args) then
            for i, arg in ipairs(args) do
                minetest.chat_send_player(name, "Argument: " .. dump(i) .. " is " .. tostring(arg))
            end
        else
            minetest.chat_send_player(name, "Failed to parse the args")
        end
	end
})

end