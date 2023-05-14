---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
return {
    ---@param formdata ScribeFormdata
    container = function(formdata)
        return "container_end[]"
    end,
    
    ---@param formdata ScribeFormdata
    vertical_box = function(formdata)
        if formdata.details.scrollable then
            return "scroll_container_end[]"
        else
            return "container_end[]"
        end
    end,
}