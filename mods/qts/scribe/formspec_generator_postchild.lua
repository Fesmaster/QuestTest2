---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
return {
    ---@param formdata ScribeFormdata
    container = function(formdata)
        return "container_end[]\n"
    end,
    
    ---@param formdata ScribeFormdata
    vertical_box = function(formdata)
        if formdata.details.scrollable then
            return "scroll_container_end[]\n"
        else
            return "container_end[]\n"
        end
    end,

    ---@param formdata ScribeFormdata
    horizontal_box = function(formdata)
        if formdata.details.scrollable then
            return "scroll_container_end[]\n"
        else
            return "container_end[]\n"
        end
    end,
}