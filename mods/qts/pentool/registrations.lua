--[[
    Pentool Registrations.

    Registered Pentools are methods of creating a pentool, then executing it by name later
    at a specific transform.

    This can be useful for known common Pentools that are used repededly, in different scenarios, 
    like a tree.

]]

---@alias PentoolParamList table<string,any>

---@type table<ItemName, {name:ItemName, param_defaults:PentoolParamList, func:fun(context:PentoolContext):nil}>
qts.pentool.registered_tools = {}

---@type table<ItemName, {name:ItemName, param_defaults:PentoolParamList, parent:ItemName}>
qts.pentool.registered_tool_instances = {}

---Register a new PenTool
---@param name ItemName The name of the tool.
---@param params PentoolParamList List of paramaters and their defaults for the tool. This should be trivially copyable, IE, values should not be a table. If they are, they should support :copy() being called on them. 
---@param func fun(context:PentoolContext):nil the PenTool function
function qts.pentool.register_tool(name, params, func)
    if qts.pentool.registered_tools[name] ~= nil then
        minetest.log("warning", "qts.pentool: Registered a PenTool under the same name as an existing PenTool! Replacing existing tool. This might break Instances. Name: " .. dump(name))
    end

    qts.pentool.registered_tools[name] = {
        name = name,
        param_defaults = params,
        func = func
    }

    if qts.pentool.registered_tool_instances[name] ~= nil then
        minetest.log("warning", "qts.pentool: Registered a PenTool under the same name as an existing PenTool Instance! Name: " .. dump(name))
    end
end

---Register an instance of a PenTool. 
---An Instance is a PenTool params override that can be exeucted like a PenTool
---@param name ItemName The instance name.
---@param parent ItemName The parent PenTool. Must be registered
---@param params PentoolParamList The Instance param overrides
function qts.pentool.register_tool_instance(name, parent, params)
    if qts.pentool.registered_tools[name] ~= nil then
        error("qts.pentool: Registered a PenTool Instance under the same name as an existing PenTool! Blocking Registration. Name: " .. dump(name))
    end
    if qts.pentool.registered_tool_instances[name] ~= nil then
        minetest.log("warning", "qts.pentool: Registered a PenTool Instance under the same name as an existing tool instance! Replacing existing PenTool Instance. Name: " .. dump(name))
    end
    if qts.pentool.registered_tools[parent] == nil and qts.pentool.registered_tool_instances[parent] == nil then
        error("qts.pentool: Attempted to register a PenTool Istance with an unregistered parent. Blocking. Name: " .. dump(name) .. " Parent: " .. dump(parent))
    end
    
    qts.pentool.registered_tool_instances[name] = {
        name = name,
        param_defaults = params,
        parent = parent
    }
end

---Combine Params from a base and an instance
---@param base PentoolParamList
---@param instance PentoolParamList
---@return PentoolParamList
local function combine_params(base, instance)
    local t = {}
    for k, v in pairs(base) do
        if instance[k] then
            if type(instance[k]) == "table" and type(instance[k].copy) == "function" then
                t[k] = instance[k]:copy()
            else
                t[k] = instance[k]
            end
        else
            if type(v) == "table" and type(v.copy) == "function" then
                t[k] = v:copy()
            else
                t[k] = v
            end
        end
    end
    return t
end



---recursively resolve instances
---@param instance ItemName Instance to resolve.
---@param visited table<ItemName,number>? which instances have been visited, to prevent infinite recursion
---@param count number? number of times this function has been called, iteratively
---@return {params:PentoolParamList,func:fun(context:PentoolContext):nil}
local function resolve_instance_params(instance, visited, count)
    --early out if instance is not a Instance but a full PenTool
    if (qts.pentool.registered_tools[instance]) then
        return {
            params = qts.pentool.registered_tools[instance].param_defaults,
            func = qts.pentool.registered_tools[instance].func
        }
    end

    --get the instance table - it must be an instance or invalid at this point
    local instancetbl = qts.pentool.registered_tool_instances[instance]
    if (instancetbl == nil) then
        error("Attempted to resolve an invalid PenTool Instance name: " .. dump(instance))
    end

    --first-time setup
    if visited == nil then visited = {} end
    if count == nil then count = 1 end

    --check for infinite recursion
    if visited[instance] ~= nil then
        --Infinite recursion occured. Must sort the visited list to get good debugh data.
        local ordered = {}
        for k, v in pairs(visited) do
            ordered[v] = k
        end
        local errstr = "Error! Infinite recursion detected when resolving PenTool Instances. Stack: "
        for i, name in ipairs(ordered) do
            errstr = errstr .. "\n" .. string.rep("\t",i) .. "["..tostring(i).."] : " .. dump(name)
            if name == instance then
                errstr = errstr .. " <-- Original use of " .. dump(name)
            end
        end
        errstr = errstr .. "\n" .. string.rep("\t",#ordered+1) .. "["..tostring(#ordered+1).."] : " .. dump(instance) .. " <-- Error!"
        error(errstr)
    end

    --log that we visited this instance name
    visited[instance] = count

    -- recursively get the parent params, combine with current params, and return that.
    -- no need to check if the parent is valid of if its an instance or not, recursive call will handle that.
    local parent = resolve_instance_params(instancetbl.parent, visited, count+1)
    parent.params = combine_params(parent.params, instancetbl.param_defaults)
    return parent
end

---Execute a PenTool with an optional set of instance params
---@param name ItemName the PenTool to execute
---@param origin Transform|Vector|PointedThing the origin of the PenTool
---@param params PentoolParamList? Optional param overrides. Any param not in the base params is ignored.
function qts.pentool.execute_tool(name, origin, params)
    if params == nil then params = {} end

    if (qts.pentool.registered_tool_instances[name] == nil) and (qts.pentool.registered_tools[name] == nil) then
        error("Attempted to run an unknown pentool! Name: " .. dump(name))
    end

    -- Get the origin transform
    ---@type Transform
    local t = origin
    if not transform.check(origin) then
        if vector.check(origin) then
            t = transform.new(origin, rotator(0,0,0), vector.new(1,1,1))
        elseif origin.under and vector.check(origin.under) and origin.above and vector.check(origin.above) then
            t = transform.new(
		    	origin.under,
		    	(origin.above - origin.under):dir_to_rotation(),
		    	vector.new(1,1,1)
		    )
        else
            error("Attempted to execute a pentool without a valid origin!")
        end
    end

    --get instance data
    --this will return valid data or create an error
    local parent = resolve_instance_params(name)

    -- Execute the PenTool
    minetest.log("Executing PenTool: " .. name .. "at" .. t:to_string())
    local context = qts.pentool.context_base.create(t, combine_params(parent.params, params))
    parent.func(context)
end

---Check if an itemname is a PenTool or PenTool Instance
---@param name ItemName
function qts.pentool.is_tool(name)
    return not ((qts.pentool.registered_tool_instances[name] == nil) and (qts.pentool.registered_tools[name] == nil))
end