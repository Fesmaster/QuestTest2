--[[
    This materials system is designed to be able to handle various mods registering various materials
    and then other mods doing things for all of the materials

    The order of registrations does not matter, ie, material groups are created lazily (on first use),
    and the individual materials can be registered before, after, or both of the for_all_materials registrations
    
]]

--[[
    Global registered materials table
    
    qtcore.registered_materials[materialname]
    {
        {fields},
        {fields},
        ...
        {fields}
    }
]]
---@type { [string] : table[] }
qtcore.registered_materials = {}

--[[
    Global registered material functions table
    
    qtcore.registered_material_functions[materialname]
    {
        func,
        func,
        ...
        func
    }
]]
---@type { [string] : (fun(fields : table) : nil)[]}
qtcore.registered_material_functions = {}

---Register a material to a group
---@param groupname string
---@param fields table
function qtcore.register_material(groupname, fields)
    if type(groupname) ~= "string" then
        error("cannot create a material group that is not a string name")
    end

    local func_list = qtcore.registered_material_functions[groupname]
    
    if func_list and #func_list > 0 then
        for i, func in ipairs(func_list) do
            func(fields)
        end
    end

    if qtcore.registered_materials[groupname] then
        qtcore.registered_materials[groupname][#(qtcore.registered_materials[groupname])+1] = fields
    else
        qtcore.registered_materials[groupname] = {fields}
    end
end

---Register a function to be called for all materials in a group
---@param groupname string the group string
---@param func fun(fields : table) : nil the function to run
function qtcore.for_all_materials(groupname, func)
    if type(groupname) ~= "string" then
        error("cannot create a material group that is not a string name")
    end

    local fields_list = qtcore.registered_materials[groupname];
    if fields_list and #fields_list > 0 then
        for i, fields in ipairs(fields_list) do
            func(fields)
        end
    end

    if qtcore.registered_material_functions[groupname] then
        qtcore.registered_material_functions[groupname][#(qtcore.registered_material_functions[groupname])+1] = func
    else
        qtcore.registered_material_functions[groupname] = {func}
    end
end