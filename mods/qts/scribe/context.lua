--[[
    a scribe Context is the table containing all the functions needed to generate a GUI element.

    A context is a local table with its metatable set to allow it to access the scribe context functions.

    A context is created for each gui, and has to know the player, the position, and the form name at creation time.
]]

--[[Helper functions to generate formspec from a formdata table]]

local element_name_counter = Counter()

qts.scribe.registered_styles = {}

---Create an element name for those that do not exist
---@param basename string
---@return string
function qts.scribe.next_element_name(basename)
    return basename .. element_name_counter()
end

---Register a new GUI style
---@param name string modname:stylename the name of the style
---@param def ScribeStyle
function qts.scribe.register_style(name, def)
    if qts.scribe.registered_styles[name] ~= nil then
        minetest.log("warning", "Scribe Style " .. name .. " is registered twice. Using the second definition.")
    end
    qts.scribe.registered_styles[name] = def
end

--import these datatables to make this file more writable

---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
local formspec_builder_prechild = dofile(qts.path.."/scribe/formspec_generator_prechild.lua")

---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
local formspec_builder_postchild = dofile(qts.path.."/scribe/formspec_generator_postchild.lua")

---Pick the first value that is not nil
---@param a any
---@param b any
---@param c any
local function pick_first_not_nil(a, b, c)
    if a ~= nil then return a end
    if b ~= nil then return b end
    return c
end

---Builg a formspec string from ScribeFormData, recursively iterating over all children.
---@param formdata ScribeFormdata
---@return string
local function build_formspec_from_fields(formdata)
    local formstr = ""
    if formdata.details.visibility == qts.scribe.visibility.VISIBLE then
        local type = formdata.details.type
        --pre-children elements
        if formspec_builder_prechild[type] then
            formstr = formstr .. formspec_builder_prechild[type](formdata)
        end

        --children
        for i, childformdata in ipairs(formdata.children) do
            formstr = formstr .. build_formspec_from_fields(childformdata)
        end

        --post-children elements
        if formspec_builder_postchild[type] then
            formstr = formstr .. formspec_builder_postchild[type](formdata)
        end
    end
    return formstr
end

---Create formdata without a child context
---@param context ScribeContext
---@return ScribeFormdata formdata
local function common_create_formdata(context)
    return {
        details = {type="child"},
        children = {}
    }
end

---Build a tooltop
---@param custom ScribeToolTip?
---@param default ScribeToolTip
---@return ScribeToolTip
local function build_tooltip(custom, default)
    if custom then 
        if type(custom) == "string" and default ~= nil then
            return {
                text=custom,
                fgcolor=default.fgcolor,
                bgcolor=default.bgcolor
            }
        elseif type(custom) == "table" then
            return custom
        end
    end
    return default
end

---Helper for building a child context.
---@param context ScribeContext
---@param childformdata ScribeFormdata
---@param def ScribeBasicFormDefinition
---@param defaults ScribeBasicFormDefinition
---@param type ScribeFormType
local function common_build_child_formdata(context, childformdata, def, defaults, type)
    childformdata.details.type = type
    if def.visibility then
        childformdata.details.visibility = def.visibility
    else
        childformdata.details.visibility = qts.scribe.visibility.VISIBLE
    end
    childformdata.details.position = qts.scribe.vec2.copy(def.position, childformdata.details.position)
    childformdata.details.tooltip = build_tooltip(def.tooltip, defaults.tooltip)
    childformdata.details.spacing = qts.scribe.vec2.copy(pick_first_not_nil(def.spacing, defaults.spacing, nil))
    childformdata.details.padding = qts.scribe.vec2.copy(pick_first_not_nil(def.padding, defaults.padding, nil))
end

---Get the size of a form, taking its visibility into account
---@param formdata ScribeFormdata
---@return vec2
local function get_formdata_size(formdata)
    if formdata.details.visibility == qts.scribe.visibility.COLLAPSED then
        return {x=0,y=0}
    end
    return qts.scribe.vec2.copy(formdata.details.size)
end


---Helper for calculating a child's size
---@param context ScribeContext
---@param childformdata ScribeFormdata
---@param def ScribeBasicFormDefinition
---@param defaults ScribeBasicFormDefinition
---@param defaultsize vec2|nil defautls to {x=0,y=0}
local function common_build_child_size(context, childformdata, def, defaults, defaultsize)
    ---@type vec2
    local size = defaultsize or {x=0,y=0}
    if defaults.width and type(defaults.width) == "number" then
        size.x = defaults.width
    end
    if defaults.height and type(defaults.height)=="number" then
        size.y = defaults.height
    end
    
    for i, subchildformdata in ipairs(childformdata.children) do
        if subchildformdata.details.visibility ~= qts.scribe.visibility.COLLAPSED then
            local size_and_pos =get_formdata_size(subchildformdata)
            --take position of elements into account
            size_and_pos.x = size_and_pos.x + subchildformdata.details.position.x
            size_and_pos.y = size_and_pos.y + subchildformdata.details.position.y
            qts.scribe.vec2.max(size_and_pos, size, size)
        end
    end
    --override with set width and height
    if def.width and type(def.width)=="number" then
        size.x = def.width
    end
    if def.height and type(def.height)=="number" then
        size.y = def.height
    end
    --calculate padding
    if childformdata.details.padding then
        size.x=size.x+(childformdata.details.padding.x*2)
        size.y=size.y+(childformdata.details.padding.y*2)
    end
    --assign to form
    childformdata.details.size = size
end

---comment
---@param context ScribeContext
---@param childformdata ScribeFormdata
local function common_build_subchild_sizes(context, childformdata)
    for i, subchildformdata in ipairs(childformdata.children) do
        if subchildformdata.details.visibility ~= qts.scribe.visibility.COLLAPSED then
            local size_and_pos =get_formdata_size(subchildformdata)
            --take position of elements into account
            if subchildformdata.details.size.x < 0 then
                subchildformdata.details.size.x = childformdata.details.size.x
            end
            if subchildformdata.details.size.y < 0 then
                subchildformdata.details.size.y = childformdata.details.size.y
            end
        end
    end
end

---Parse the ScribeTextureMiddle format
---@param middle Rect
---@return {x_min:number,y_min:number,x_max:number,y_max:number}|nil middle
local function parse_middle_format(middle)
    local out = nil
    if type(middle) == "number" then
        out={
            x_min=middle,
            y_min=middle,
            x_max=middle,
            y_max=middle,
        }
    elseif type(middle)=="table" then
        if middle.x and middle.y and type(middle.x)=="number" and type(middle.y)=="number" then
            out={
                x_min=middle.x,
                y_min=middle.y,
                x_max=middle.x,
                y_max=middle.y,
            }
        elseif middle.x_min and middle.y_min and middle.x_max and middle.y_max 
        and type(middle.x_min)=="number" and type(middle.y_min)=="number" 
        and type(middle.x_max)=="number" and type(middle.y_max)=="number" 
        then
            out={
                x_min=middle.x_min,
                y_min=middle.y_min,
                x_max=middle.x_max,
                y_max=middle.y_max,
            }
        end
    end
    return out
end

---Apply a source style to a destination style, without overriding anything from the destination style
---@param style_dest ScribeButtonStateStyle inout style
---@param style_src ScribeButtonStateStyle
local function ApplyButtonStyleToAnother(style_dest, style_src)
    if style_dest == nil or style_src == nil then
        return
    end

    if style_dest.background == nil then
        style_dest.background = style_src.background
    end
    if style_dest.background_middle == nil then
        style_dest.background_middle = style_src.background_middle
    end
    if style_dest.background_use_alpha == nil then
        style_dest.background_use_alpha = style_src.background_use_alpha
    end
    if style_dest.background_tint == nil then
        style_dest.background_tint = style_src.background_tint
    end

    if style_dest.font == nil then
        style_dest.font = style_src.font
    elseif type(style_src.font) == "table" then
        if style_dest.font.bold == nil then
            style_dest.font.bold = style_src.font.bold
        end
        if style_dest.font.color == nil then
            style_dest.font.color = style_src.font.color
        end
        if style_dest.font.italic == nil then
            style_dest.font.italic = style_src.font.italic
        end
        if style_dest.font.size == nil then
            style_dest.font.size = style_src.font.size
        end
        if style_dest.font.style == nil then
            style_dest.font.style = style_src.font.style
        end
    end
    
    if style_dest.border == nil then
        style_dest.border = style_src.border
    end
    if style_dest.internal_offset == nil then
        style_dest.internal_offset = style_src.internal_offset
    end
    if style_dest.padding == nil then
        style_dest.padding = style_src.padding
    end
end

---@class ScribeContext
---@field player Player the player the context is created for
---@field position Vector the position the GUI is related To
---@field name string the GUI name
---@field userdata table arbitrary data that is available at event-time and at regen-time
---@field formdata ScribeFormdata form data, built by calling functions. Do not access directly.
---@field callbacks table<string, ScribeCallbackFunction|ScribeCallbackFunction[]> Callback functions, map of element name to callback. Do not access directly.
qts.scribe.context_base = {
    ---@type table the metatable for ScribeContext
    __mt = {
        --no new indices allowed in ScribeContext
        __newindex = nil
    },

    --[[   GUI Createion Functions   ]]

    ---Create a container element. Useful for backgrounds and the like.
    ---@param self ScribeContext
    ---@param def ScribeContainerFormDefinition
    ---@param children ScribeContextFunction|nil
    ---@return ScribeContext self self-reference.
    container = function(self, def, children)
        local defaults = self:get_element_defaults("container")
        ---@cast defaults +ScribeContainerFormDefinition
        
        --create the child context
        local child = self:child()
        common_build_child_formdata(self, child.formdata, def, defaults, "container")

        --texture
        if def.texture and type(def.texture) == "string" then
            if (def.texture ~= "") then
                child.formdata.details.texture = def.texture
                
                --check for a valid middle definition
                if def.middle then
                    child.formdata.details.middle = parse_middle_format(def.middle)
                end
            end
        elseif defaults.texture and type(defaults.texture)== "string" then
            if (defaults.texture ~= "") then
                child.formdata.details.texture = defaults.texture

                --check for a valid middle definition
                if defaults.middle then
                    child.formdata.details.middle = parse_middle_format(defaults.middle)
                end
            end
        end

        --children
        if type(children) == "function" then
            children(child)
        end

        common_build_child_size(self, child.formdata, def, defaults, {x=0,y=0})

        common_build_subchild_sizes(self, child.formdata)

        --add the child to self.
        self.formdata.children[#self.formdata.children+1] = child.formdata

        --ALWAYS return self from gui form type functions!
        return self
    end,

    ---Create a vertical box element. Lists its children vertically, with allignment.
    ---@param self ScribeContext
    ---@param def ScribeBoxFormDefinition
    ---@param children ScribeContextFunction|nil
    ---@return ScribeContext self self-reference.
    vertical_box = function(self, def, children)
        local defaults = self:get_element_defaults("vertical_box")
        ---@cast defaults +ScribeBoxFormDefinition

        --create the child context
        local child = self:child()
        common_build_child_formdata(self, child.formdata, def, defaults, "vertical_box")

        --texture
        if def.texture and type(def.texture) == "string" then
            if (def.texture ~= "") then
                child.formdata.details.texture = def.texture
                
                --check for a valid middle definition
                if def.middle then
                    child.formdata.details.middle = parse_middle_format(def.middle)
                end
            end
        elseif defaults.texture and type(defaults.texture) == "string" then
            if (defaults.texture ~= "") then
                child.formdata.details.texture = defaults.texture
                
                --check for a valid middle definition
                if defaults.middle then
                    child.formdata.details.middle = parse_middle_format(defaults.middle)
                end
            end
        end

        --other box fields:
        if def.scrollable ~= nil then
            child.formdata.details.scrollable = def.scrollable
        elseif defaults.scrollable ~= nil then
            child.formdata.details.scrollable = defaults.scrollable
        else
            child.formdata.details.scrollable = false
        end
        child.formdata.details.allignment = pick_first_not_nil(def.allignment, defaults.allignment, qts.scribe.allignment.MIN)
        child.formdata.details.scrollbar_side = pick_first_not_nil(def.scrollbar_side, defaults.scrollbar_side, qts.scribe.allignment.MIN)
        --scrollbar name
        if def.scrollbar_name then
            child.formdata.details.scrollbar_name = def.scrollbar_name
        else
            child.formdata.details.scrollbar_name = qts.scribe.next_element_name("scrollbar")
        end
        --auto-hide scrollbar
        child.formdata.details.scrollbar_autohide=pick_first_not_nil(def.scrollbar_autohide, defaults.scrollbar_autohide, true)

        --children
        if type(children) == "function" then
            children(child)
        end
        
        --running height of next element
        local runningHeight = 0

        --calculate width and place all elements at final height
        local maxwidth = 0

        local vert_spacing = 0
        if child.formdata.details.spacing then
            vert_spacing = child.formdata.details.spacing.y
        end

        local had_noncollapsed_element = false
        for i, subchildformdata in ipairs(child.formdata.children) do

            --add spacing if you are not the first and you are visible
            if subchildformdata.details.visibility ~= qts.scribe.visibility.COLLAPSED then
                if had_noncollapsed_element then 
                    runningHeight = runningHeight + vert_spacing
                else
                    had_noncollapsed_element = true
                end
            end
            local size = get_formdata_size(subchildformdata)
            
            --calculate width
            maxwidth = math.max(maxwidth, size.x)

            --set vertical position and reset horizontal.
            subchildformdata.details.position = {x=0, y=runningHeight}

            --update height for next one
            runningHeight = runningHeight + size.y
        end

        --full size of list, in case scrollable
        child.formdata.details.listsize = runningHeight

        --set self size
        child.formdata.details.size = {}
        
        --set the vertical size
        if def.height then
            child.formdata.details.size.y = def.height
            
            if runningHeight <= def.height and child.formdata.details.scrollbar_autohide then
                child.formdata.details.scrollable=false
            end
        else
            child.formdata.details.size.y = runningHeight + (2 * vert_spacing)
        end

        --calculate the scrollbar size
        local scrollbar_size = 0
        if child.formdata.details.scrollable then
            scrollbar_size = pick_first_not_nil(def.scrollbar_size, defaults.scrollbar_size, 0.3)
        end
        child.formdata.details.scrollbar_size = scrollbar_size

        --edit width
        if def.width then 
            maxwidth = def.width - scrollbar_size
        else
            if child.formdata.details.padding then
                maxwidth = maxwidth + child.formdata.details.padding.x*2
            end
        end

        --set the horizontal size
        child.formdata.details.size.x = maxwidth + scrollbar_size
        
        --arrange children horizontally now that width and scrollbar status is known
        local allignment = pick_first_not_nil(def.allignment, defaults.allignment, qts.scribe.allignment.LEFT)
        for i, subchildformdata in ipairs(child.formdata.children) do
            local size = get_formdata_size(subchildformdata)
            local x_pos = 0 --default: left allignment
            if allignment == qts.scribe.allignment.CENTER then
                --center allignment
                x_pos = (maxwidth/2) - (size.x/2) - child.formdata.details.padding.x
            elseif allignment == qts.scribe.allignment.RIGHT then
                --right allignment
                x_pos = maxwidth - size.x - (child.formdata.details.padding.x*2)
            end

            --set the horizontal position
            subchildformdata.details.position.x = x_pos
        end

        common_build_subchild_sizes(self, child.formdata)

        --add the child to self.
        self.formdata.children[#self.formdata.children+1] = child.formdata

        --ALWAYS return self from gui form type functions!
        return self
    end,


    ---Create a horizontal box element. Lists its children horizontally, with allignment.
    ---@param self ScribeContext
    ---@param def ScribeBoxFormDefinition
    ---@param children ScribeContextFunction|nil
    ---@return ScribeContext self self-reference.
    horizontal_box = function(self, def, children)
        local defaults = self:get_element_defaults("horizontal_box")
        ---@cast defaults +ScribeBoxFormDefinition

        --create the child context
        local child = self:child()
        common_build_child_formdata(self, child.formdata, def, defaults, "horizontal_box")

        --texture
        if def.texture and type(def.texture) == "string" then
            if (def.texture ~= "") then
                child.formdata.details.texture = def.texture
                
                --check for a valid middle definition
                if def.middle then
                    child.formdata.details.middle = parse_middle_format(def.middle)
                end
            end
        elseif defaults.texture and type(defaults.texture) == "string" then
            if (defaults.texture ~= "") then
                child.formdata.details.texture = defaults.texture
                
                --check for a valid middle definition
                if defaults.middle then
                    child.formdata.details.middle = parse_middle_format(defaults.middle)
                end
            end
        end

        --other box fields:
        if def.scrollable ~= nil then
            child.formdata.details.scrollable = def.scrollable
        elseif defaults.scrollable ~= nil then
            child.formdata.details.scrollable = defaults.scrollable
        else
            child.formdata.details.scrollable = false
        end
        child.formdata.details.allignment = pick_first_not_nil(def.allignment, defaults.allignment, qts.scribe.allignment.MIN)
        child.formdata.details.scrollbar_side = pick_first_not_nil(def.scrollbar_side, defaults.scrollbar_side, qts.scribe.allignment.MIN)
        --scrollbar name
        if def.scrollbar_name then
            child.formdata.details.scrollbar_name = def.scrollbar_name
        else
            child.formdata.details.scrollbar_name = qts.scribe.next_element_name("scrollbar")
        end
        --auto-hide scrollbar
        child.formdata.details.scrollbar_autohide=pick_first_not_nil(def.scrollbar_autohide, defaults.scrollbar_autohide, true)

        --children
        if type(children) == "function" then
            children(child)
        end
        
        --running width of next element
        local running_width = 0

        --calculate width and place all elements at final height
        local maxheight = 0

        local horz_spacing = 0
        if child.formdata.details.spacing then
            horz_spacing = child.formdata.details.spacing.x
        end

        local had_noncollapsed_element = false
        for i, subchildformdata in ipairs(child.formdata.children) do

            --add spacing if you are not the first and you are visible
            if subchildformdata.details.visibility ~= qts.scribe.visibility.COLLAPSED then
                if had_noncollapsed_element then 
                    running_width = running_width + horz_spacing
                else
                    had_noncollapsed_element = true
                end
            end
            local size = get_formdata_size(subchildformdata)
            
            --calculate width
            maxheight = math.max(maxheight, size.y)

            --set vertical position and reset horizontal.
            subchildformdata.details.position = {x=running_width, y=0}

            --update width for next one
            running_width = running_width + size.x
        end

        --full size of list, in case scrollable
        child.formdata.details.listsize = running_width

        --set self size
        child.formdata.details.size = {}
        
        --set the vertical size
        if def.width then
            child.formdata.details.size.x = def.width
            
            if running_width <= def.width and child.formdata.details.scrollbar_autohide then
                child.formdata.details.scrollable=false
            end
        else
            child.formdata.details.size.x = running_width + (2 * horz_spacing)
        end

        --calculate the scrollbar size
        local scrollbar_size = 0
        if child.formdata.details.scrollable then
            scrollbar_size = pick_first_not_nil(def.scrollbar_size, defaults.scrollbar_size, 0.3)
        end
        child.formdata.details.scrollbar_size = scrollbar_size

        --edit width
        if def.height then 
            maxheight = def.height - scrollbar_size
        else
            if child.formdata.details.padding then
                maxheight = maxheight + child.formdata.details.padding.y*2
            end
        end

        --set the horizontal size
        child.formdata.details.size.y = maxheight + scrollbar_size
        
        
        --arrange children horizontally now that width and scrollbar status is known
        local allignment = pick_first_not_nil(def.allignment, defaults.allignment, qts.scribe.allignment.TOP)
        for i, subchildformdata in ipairs(child.formdata.children) do
            local size = get_formdata_size(subchildformdata)
            local y_pos = 0 --default: TOP allignment
            if allignment == qts.scribe.allignment.CENTER then
                --center allignment
                y_pos = (maxheight/2) - (size.y/2) - child.formdata.details.padding.y
            elseif allignment == qts.scribe.allignment.BOTTOM then
                --right allignment
                y_pos = maxheight - size.y - (child.formdata.details.padding.y*2)
            end

            --set the horizontal position
            subchildformdata.details.position.y = y_pos
        end

        common_build_subchild_sizes(self, child.formdata)

        --add the child to self.
        self.formdata.children[#self.formdata.children+1] = child.formdata

        --ALWAYS return self from gui form type functions!
        return self
    end,

    ---Create a Text element.
    ---@param self ScribeContext
    ---@param def ScribeTextFormDefinition
    ---@param callback ScribeCallbackFunction|nil
    ---@return ScribeContext self self-reference.
    text = function(self, def, callback)
        local defaults = self:get_element_defaults("text")
        ---@cast defaults +ScribeTextFormDefinition

        --create the child context
        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "text")
        common_build_child_size(self, childformdata, def, defaults, {x=1,y=1})

        --text stuff
        childformdata.details.name = def.name or qts.scribe.next_element_name("text")
        childformdata.details.text = pick_first_not_nil(def.text, defaults.text, "Hello World") --default text
        childformdata.details.font = pick_first_not_nil(def.font, defaults.font, {})
        childformdata.details.vertical_allignment =   pick_first_not_nil(def.vertical_allignment,   defaults.vertical_allignment,   qts.scribe.allignment.CENTER)
        childformdata.details.horizontal_allignment = pick_first_not_nil(def.horizontal_allignment, defaults.horizontal_allignment, qts.scribe.allignment.CENTER)
        childformdata.details.background_color = pick_first_not_nil(def.background_color, defaults.background_color, "none")
        childformdata.details.margin = pick_first_not_nil(def.margin, defaults.margin, 0)

        --add the child
        self.formdata.children[#self.formdata.children+1] = childformdata

        --add the function
        if callback then
            self:named_callback(childformdata.details.name, callback)
        end

        return self
    end,

    ---Create an editable text element
    ---@param self ScribeContext
    ---@param def ScribeTextInputFormDefinition
    ---@param callback ScribeCallbackFunction|nil
    ---@return ScribeContext self
    text_entry = function(self, def, callback)
        local defaults = self:get_element_defaults("text_input")
        ---@cast defaults +ScribeTextInputFormDefinition

        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "text_entry")
        common_build_child_size(self, childformdata, def, defaults, {x=1,y=1})
        
        
        childformdata.details.name = def.name or qts.scribe.next_element_name("text_entry")
        childformdata.details.label = pick_first_not_nil(def.label, defaults.label, "")
        local obscure_content = pick_first_not_nil(def.obscure_content, defaults.obscure_content, false)
        if obscure_content then
            childformdata.details.obscure_content = true
            childformdata.details.multiline = false
        else
            childformdata.details.obscure_content = false
            childformdata.details.default_value = pick_first_not_nil(def.default_value, defaults.default_value, "")
            
            if pick_first_not_nil(def.persistant_text, defaults.persistant_text, true) then
                local name = childformdata.details.name
                self:refresh_callback(function (event)
                    if event.fields[name] then
                        if event.userdata._scribe == nil then
                            event.userdata._scribe = {}
                        end
                        --store the value
                        event.userdata._scribe[name] = event.fields[name]
                    end
                end)

                --fetch the value
                if self.userdata._scribe and self.userdata._scribe[childformdata.details.name] then
                    childformdata.details.default_value = self.userdata._scribe[childformdata.details.name]
                end
            end
            
            if pick_first_not_nil(def.multiline, defaults.multiline, false) then
                childformdata.details.multiline = true
            else
                childformdata.details.multiline = false
            end

        end
        childformdata.details.border = pick_first_not_nil(def.border, defaults.border, true)
        childformdata.details.font = pick_first_not_nil(def.font, defaults.font, {})
        childformdata.details.close_on_enter = pick_first_not_nil(def.close_on_enter, defaults.close_on_enter, false)

        --add the child
        self.formdata.children[#self.formdata.children+1] = childformdata

        --add the function
        --due to text entry fields needing to make extra checks, this is done in a custom lambda.
        if callback then
            local name = childformdata.details.name
            self:named_callback(childformdata.details.name, function (event)
                if event.fields.key_enter and event.fields.key_enter_field == name then
                    callback(event)
                end 
            end)
        end

        return self
    end,

    ---Create an Image element. Can show a texture or an item
    ---@param self ScribeContext
    ---@param def ScribeImageFormDefinition
    ---@return ScribeContext self
    image = function(self, def)
        local defaults = self:get_element_defaults("image")
        ---@cast defaults +ScribeImageFormDefinition

        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "image")
        common_build_child_size(self, childformdata, def, defaults, {x=1,y=1})

        childformdata.details.name = def.name or qts.scribe.next_element_name("image")
        if def.item then
            childformdata.details.item = def.item
        elseif def.texture then
            childformdata.details.texture = def.texture
            childformdata.details.animation = def.animation 
            childformdata.details.middle = parse_middle_format(def.middle)
        elseif defaults.item then
            childformdata.details.item = defaults.item
        elseif defaults.texture then
            childformdata.details.texture = defaults.texture
            childformdata.details.animation = defaults.animation 
            childformdata.details.middle = parse_middle_format(defaults.middle)
        else
            error("qts.scribe: image element must have either an item or a texture defined.")
        end

        --add the child
        self.formdata.children[#self.formdata.children+1] = childformdata

        return self
    end,

    ---Create a colored rectangle
    ---@param self ScribeContext
    ---@param def ScribeRectFormDefinition
    ---@return ScribeContext self self-reference
    rect = function(self, def)
        local defaults = self:get_element_defaults("rect")
        ---@cast defaults +ScribeRectFormDefinition

        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "rect")
        common_build_child_size(self, childformdata, def, defaults, {x=1,y=1})
        --color
        childformdata.details.color = pick_first_not_nil(def.color, defaults.color, "none")

        --add the child
        self.formdata.children[#self.formdata.children+1] = childformdata
        return self
    end,

    ---Create a seperator bar
    ---@param self ScribeContext
    ---@param def ScribeSeperatorFormDefinition
    ---@return ScribeContext self
    seperator = function(self, def)
        def.width = def.length or -1
        def.height = 0.01
        if def.orientation == qts.scribe.orientation.VERTICAL then
            def.height = def.width
            def.width = 0.01
        end
        self:rect(def)
        return self
    end,


    ---Create a button element. 
    ---@param self ScribeContext
    ---@param def ScribeButtonFormDefinition
    ---@param callback ScribeCallbackFunction|nil
    ---@return ScribeContext self self-reference.
    button = function(self, def, callback)
        local defaults = self:get_element_defaults("button")
        if def.toggleable then
            defaults = self:get_element_defaults("toggle_button")
        end
        ---@cast defaults +ScribeButtonFormDefinition

        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "button")
        common_build_child_size(self, childformdata, def, defaults, {x=1,y=qts.select(def.toggleable, 0.66, 1)})

        if def.name then
            childformdata.details.name = def.name
        else
            childformdata.details.name = qts.scribe.next_element_name("button")
            if (def.toggleable) then
                minetest.log("warning", "Warning: toggleables without a static name will not function!")
            end
                
        end
        childformdata.details.label = pick_first_not_nil(def.label, defaults.label, nil)
        childformdata.details.is_exit = def.is_exit
        childformdata.details.sound = pick_first_not_nil(def.sound, defaults.sound, "gui_button") --default sound!!!
        
        local is_toggled = false
        if def.toggleable then
            if self.userdata._scribe == nil then
                self.userdata._scribe = {[childformdata.details.name] = {toggled = false}}
            elseif self.userdata._scribe[childformdata.details.name] == nil then 
                self.userdata._scribe[childformdata.details.name] = {toggled = false}
            elseif self.userdata._scribe[childformdata.details.name].toggled == nil then
                self.userdata._scribe[childformdata.details.name].toggled = false
            else
                is_toggled = self.userdata._scribe[childformdata.details.name].toggled
            end

            --default textures
            if def.texture == nil and defaults.texture == nil then
                def.texture = "gui_toggle_off.png"
                def.texture_pressed = "gui_toggle_on.png"
            end

            --default empty background
            --this should be enfored by the style, not the API
            --[[
            if def.style_all == nil then
                def.style_all = {}
            end
            if def.style_toggled_all == nil then
                def.style_toggled_all = {}
            end
            if def.style_all.background == nil and (defaults.style_all == nil or defaults.style_all.background == nil) then
                def.style_all.background = ""
            end
            if def.style_toggled_all.background == nil and (defaults.style_toggled_all == nil or defaults.style_toggled_all.background == nil) then
                def.style_toggled_all.background = ""
            end
            --]]
        end
        
        if is_toggled then
            --when button is toggled on
            childformdata.details.texture = pick_first_not_nil(def.texture_pressed, defaults.texture_pressed, nil)
            childformdata.details.texture_pressed = pick_first_not_nil(def.texture, defaults.texture, nil)
            
            if def.style_any then
                childformdata.details.style_any = table.copy(def.style_toggled_any)
            else
                childformdata.details.style_any = {}
            end
            if def.style_normal then
                childformdata.details.style_normal = table.copy(def.style_toggled_normal)
            else
                childformdata.details.style_normal = {}
            end
            if def.style_hovered then
                childformdata.details.style_hovered = table.copy(def.style_toggled_hovered)
            else
                childformdata.details.style_hovered = {}
            end
            if def.style_pressed then
                childformdata.details.style_pressed = table.copy(def.style_toggled_pressed)
            else
                childformdata.details.style_pressed = {}
            end
            if def.style_all then
                ApplyButtonStyleToAnother(childformdata.details.style_normal, def.style_toggled_all)
                ApplyButtonStyleToAnother(childformdata.details.style_hovered, def.style_toggled_all)
                ApplyButtonStyleToAnother(childformdata.details.style_pressed, def.style_toggled_all)
            end
            --apply the defaults to everything, if needed
            ApplyButtonStyleToAnother(childformdata.details.style_normal,  defaults.style_toggled_normal)
            ApplyButtonStyleToAnother(childformdata.details.style_hovered, defaults.style_toggled_hovered)
            ApplyButtonStyleToAnother(childformdata.details.style_pressed, defaults.style_toggled_pressed)

            ApplyButtonStyleToAnother(childformdata.details.style_normal,  defaults.style_toggled_all)
            ApplyButtonStyleToAnother(childformdata.details.style_hovered, defaults.style_toggled_all)
            ApplyButtonStyleToAnother(childformdata.details.style_pressed, defaults.style_toggled_all)
        else
            childformdata.details.texture = pick_first_not_nil(def.texture, defaults.texture, nil)
            childformdata.details.texture_pressed = pick_first_not_nil(def.texture_pressed, defaults.texture_pressed, nil)
            
            if def.style_any then
                childformdata.details.style_any = table.copy(def.style_any)
            else
                childformdata.details.style_any = {}
            end
            if def.style_normal then
                childformdata.details.style_normal = table.copy(def.style_normal)
            else
                childformdata.details.style_normal = {}
            end
            if def.style_hovered then
                childformdata.details.style_hovered = table.copy(def.style_hovered)
            else
                childformdata.details.style_hovered = {}
            end
            if def.style_pressed then
                childformdata.details.style_pressed = table.copy(def.style_pressed)
            else
                childformdata.details.style_pressed = {}
            end
            if def.style_all then
                ApplyButtonStyleToAnother(childformdata.details.style_normal, def.style_all)
                ApplyButtonStyleToAnother(childformdata.details.style_hovered, def.style_all)
                ApplyButtonStyleToAnother(childformdata.details.style_pressed, def.style_all)
            end
            --apply the defaults to everything, if needed
            ApplyButtonStyleToAnother(childformdata.details.style_normal,  defaults.style_normal)
            ApplyButtonStyleToAnother(childformdata.details.style_hovered, defaults.style_hovered)
            ApplyButtonStyleToAnother(childformdata.details.style_pressed, defaults.style_pressed)

            ApplyButtonStyleToAnother(childformdata.details.style_normal,  defaults.style_all)
            ApplyButtonStyleToAnother(childformdata.details.style_hovered, defaults.style_all)
            ApplyButtonStyleToAnother(childformdata.details.style_pressed, defaults.style_all)
        end

        --verify middles are parsed
        if childformdata.details.style_normal.background_middle ~= nil then
            childformdata.details.style_normal.background_middle = parse_middle_format(childformdata.details.style_normal.background_middle)
        end
        if childformdata.details.style_hovered.background_middle ~= nil then
            childformdata.details.style_hovered.background_middle = parse_middle_format(childformdata.details.style_hovered.background_middle)
        end
        if childformdata.details.style_pressed.background_middle ~= nil then
            childformdata.details.style_pressed.background_middle = parse_middle_format(childformdata.details.style_pressed.background_middle)
        end

        
        if childformdata.details.texture == nil and childformdata.details.texture_pressed == nil and (childformdata.details.is_exit == nil or childformdata.details.is_exit == false) then
            childformdata.details.item = pick_first_not_nil(def.item, defaults.item, nil)
        else
            if def.item then
                minetest.log("warning", "[formspec unsupported] you cannot make a button with an item if it has a texture, a texture_pressed, or is an exit button. Sorry!")
            end
        end

        self.formdata.children[#self.formdata.children+1] = childformdata

        --add the function
        if callback then

            if def.toggleable then
                local name = childformdata.details.name
                --custom wrapper callback to update the toggle
                self:named_callback(childformdata.details.name, function (event)
                    event.userdata._scribe[name].toggled = not self.userdata._scribe[name].toggled
                    callback(event)
                    event:mark_for_refresh()
                end)
            else
                self:named_callback(childformdata.details.name, callback)
            end
        end

        return self
    end,

    ---Create an inventory element
    ---@param self ScribeContext
    ---@param def ScribeInventoryFormDefinition
    ---@return ScribeContext self
    inventory = function(self, def)
        local defaults = self:get_element_defaults("inventory")
        ---@cast defaults +ScribeInventoryFormDefinition

        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "inventory")

        local slot_size = pick_first_not_nil(def.slot_size, defaults.slot_size, {x=1,y=1})
        local slot_spacing = pick_first_not_nil(def.slot_spacing, defaults.slot_spacing, {x=0.25,y=0.25})
        childformdata.details.slot_size = slot_size
        childformdata.details.slot_spacing = slot_spacing

        local actual_size = {x=0,y=0}
        local slots = {x=0,y=0}
        if pick_first_not_nil(def.use_actual_size, defaults.use_actual_size, false) then
            actual_size.x = def.width or slot_size.x
            actual_size.y = def.height or slot_size.y

            --calcualte the slots
            slots.x = 1 + math.floor((actual_size.x - slot_size.x) / (slot_size.x+slot_spacing.x))
            slots.y = 1 + math.floor((actual_size.y - slot_size.y) / (slot_size.y+slot_spacing.y))
        else
            slots.x = def.width or 1
            slots.y = def.height or 1

            --calculate the actual size
            actual_size.x = (slots.x * slot_size.x) + ((slots.x-1) * slot_spacing.x)
            actual_size.y = (slots.y * slot_size.y) + ((slots.y-1) * slot_spacing.y)
        end

        --set the size and slots
        childformdata.details.size = actual_size
        childformdata.details.slots = slots
        
        --source
        childformdata.details.source = def.source or qts.scribe.inventory_source.CURRENT_PLAYER
        if type(def.sourcename) == "table" then
            childformdata.details.sourcename = vector.new(def.sourcename)
            --minetest.log("Source Vector: " .. vector.to_string(childformdata.details.sourcename))
        else
            childformdata.details.sourcename = def.sourcename
        end
        if childformdata.details.source == qts.scribe.inventory_source.CURRENT_NODE then
            childformdata.details.source = qts.scribe.inventory_source.SPECIFIC_NODE
            childformdata.details.sourcename = vector.new(self.position)
        end
        childformdata.details.listname = pick_first_not_nil(def.listname, defaults.listname or "main")

        childformdata.details.starting_item_index = pick_first_not_nil(def.starting_item_index, defaults.starting_item_index, 0)
        childformdata.details.orientation = pick_first_not_nil(def.orientation, defaults.orientation, qts.scribe.orientation.HORIZONTAL)
        childformdata.details.use_list_ring = pick_first_not_nil(def.use_list_ring, defaults.use_list_ring, false)
        
        --colors
        --[[ List colors are a universal setting, and cannot be set per-element
        childformdata.details.background_color          = def.background_color          or "#00000069"
        childformdata.details.background_hover_color    = def.background_hover_color    or "#5A5A5A"
        childformdata.details.border_color              = def.border_color              or "#141318"
        childformdata.details.tooltip_color             = def.tooltip_color             or "#30434C"
        childformdata.details.tooltip_text_tint         = def.tooltip_text_tint         or "#FFFFFF"
        --]]
        
        --add the child
        self.formdata.children[#self.formdata.children+1] = childformdata
        return self
    end,

    ---Create an inventory element
    ---@param self ScribeContext
    ---@param def ScribeModelFormDefinition
    ---@return ScribeContext self
    model = function(self, def)
        local defaults = self:get_element_defaults("model")
        ---@cast defaults +ScribeModelFormDefinition

        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, defaults, "model")
        common_build_child_size(self, childformdata, def, defaults, {x=1,y=1})

        if def.name then
            childformdata.details.name = def.name
        else
            childformdata.details.name = qts.scribe.next_element_name("model")
        end

        if (
            def.mesh == nil or 
            type(def.mesh) ~= "string" or
            def.textures == nil or 
            type(def.textures) ~= "string"
        ) then
            minetest.log("error", "Error: Model elements must have a mesh and a texture")
            return self
        end

        childformdata.details.mesh = def.mesh
        childformdata.details.textures = def.textures

        childformdata.details.rotation = pick_first_not_nil(def.rotation, defaults.rotation, {x=0,y=0})
        childformdata.details.continuous_rotation = pick_first_not_nil(def.continuous_rotation, defaults.continuous_rotation, false)
        childformdata.details.mouse_control = pick_first_not_nil(def.mouse_control, defaults.mouse_control, false)
        childformdata.details.frame_loop_range = pick_first_not_nil(def.frame_loop_range, defaults.frame_loop_range, {x=0,y=0})
        childformdata.details.frames_per_second = pick_first_not_nil(def.frames_per_second, defaults.frames_per_second, 0)
        childformdata.details.background_color = pick_first_not_nil(def.background_color, defaults.background_color, nil)

        self.formdata.children[#self.formdata.children+1] = childformdata
        return self
    end,

    ---Create a tab header and its tabs
    ---@param self ScribeContext
    ---@param def ScribeTabHeaderFormDefinition
    ---@param tabs ScribeTab[]
    tab_header = function(self, def, tabs)
        --tab header is actually a bunch of buttons and a container
        if (#tabs == 0) then 
            minetest.log("warning", "Number of tabs in a tab header is 0.")
            return 
        end
        
        local defaults = self:get_element_defaults("tab_header")
        ---@cast defaults +ScribeTabHeaderFormDefinition

        local inner_size = pick_first_not_nil(def.inner_size, defaults.inner_size, {x=nil,y=nil})

        local active_tab = tabs[1] ---@type ScribeTab
        local active_tab_name = active_tab.tab.name
        local active_tab_index = 1
        local active_tab_entry = "__scribe_active_tab_"..def.name
        if self.userdata[active_tab_entry] then 
            active_tab_name = self.userdata[active_tab_entry]
            local found = false
            for i, tab in ipairs(tabs) do
                if tab.tab.name == active_tab_name then
                    active_tab = tab
                    active_tab_index = i
                    found=true
                    break
                end
            end
            if not found then
                active_tab_name = active_tab.tab.name
            end
        end
        
        ---function to display the tabs
        ---@param context ScribeContext
        local tabs_func = function(context)
            --TODO: appropreately implement per-tab allignment

            for i, tab_entry in ipairs(tabs) do
                ---@cast tab_entry ScribeTab
                local tab = tab_entry.tab

                --merging button styles
                if tab.style_any == nil then tab.style_any = {} end
                if tab.style_normal == nil then tab.style_normal = {} end
                if tab.style_hovered == nil then tab.style_hovered = {} end
                if tab.style_pressed == nil then tab.style_pressed = {} end
                if tab.style_all == nil then tab.style_all = {} end
                ApplyButtonStyleToAnother(tab.style_any, def.style_any)
                ApplyButtonStyleToAnother(tab.style_any, defaults.style_any)
                ApplyButtonStyleToAnother(tab.style_normal, def.style_normal)
                ApplyButtonStyleToAnother(tab.style_normal, defaults.style_normal)
                ApplyButtonStyleToAnother(tab.style_hovered, def.style_hovered)
                ApplyButtonStyleToAnother(tab.style_hovered, defaults.style_hovered)
                ApplyButtonStyleToAnother(tab.style_pressed, def.style_pressed)
                ApplyButtonStyleToAnother(tab.style_pressed, defaults.style_pressed)
                ApplyButtonStyleToAnother(tab.style_all, def.style_all)
                ApplyButtonStyleToAnother(tab.style_all, defaults.style_all)

                -- allignment ScribeFormAllignment? Overide to the global allignment
                context:button({
                    position = tab.position,
                    width = tab.width,
                    height = tab.height,
                    padding = tab.padding,

                    name = tab.name,
                    label = pick_first_not_nil(tab.label,tab.name, "ERROR: UNNAMED TAB"),
                    texture = qts.select(i==active_tab_index, tab.texture_pressed, tab.texture),
                    texture_pressed = qts.select(i==active_tab_index, tab.texture, tab.texture_pressed),
                    item = tab.item,
                    sound = tab.sound,
                    style_any = tab.style_any,
                    style_normal = qts.select(i==active_tab_index, tab.style_pressed, tab.style_normal),
                    style_hovered = tab.style_hovered,
                    style_pressed = qts.select(i==active_tab_index, tab.style_normal, tab.style_pressed),
                    style_all = tab.style_all,

                    toggleable=false,
                    is_exit=false,
                    tooltip=tab.tooltip,
                    visibility=tab.visibility,
                }, function (event)
                    event.userdata[active_tab_entry] = tab_entry.tab.name
                    event:mark_for_refresh();
                end)
            end
        end
        
        def.orientation = pick_first_not_nil(def.orientation, defaults.orientation, qts.scribe.orientation.HORIZONTAL)
        def.allignment = pick_first_not_nil(def.allignment, defaults.allignment, qts.scribe.allignment.TOP)
        def.tabs_allignment = pick_first_not_nil(def.tabs_allignment, defaults.tabs_allignment, qts.scribe.allignment.LEFT)
        
        if (def.orientation == qts.scribe.orientation.HORIZONTAL) then
            self:vertical_box({
                position = def.position,
                width = def.width,
                height = def.height,
                tooltip = def.tooltip,
                visibility = def.visibility,
                padding=def.padding,
                texture="",
                middle={0,0,0,0}
            }, function(context)
                if (def.allignment == qts.scribe.allignment.TOP) then
                    --tabs on top
                    context:horizontal_box({
                        allignment=def.tabs_allignment,
                        padding={x=0,y=0},
                        texture="",
                        middle={0,0,0,0}
                    }, tabs_func)
                end
                --tab body
                context:container({
                    width=inner_size.x,
                    height=inner_size.y,
                    padding={x=0,y=0},
                    texture="",
                    middle={0,0,0,0}
                }, active_tab.page)
                if (def.allignment ~= qts.scribe.allignment.TOP) then
                    --tabs on bottom
                    context:horizontal_box({
                        allignment=def.tabs_allignment,
                        padding={x=0,y=0},
                        texture="",
                        middle={0,0,0,0}
                    }, tabs_func)
                end
            end)
        elseif (def.orientation == qts.scribe.orientation.VERTICAL) then
            self:horizontal_box({
                position = def.position,
                width = def.width,
                height = def.height,
                tooltip = def.tooltip,
                visibility = def.visibility,
                padding=def.padding,
                texture="",
                middle={0,0,0,0}
            }, function(context)
                if (def.allignment == qts.scribe.allignment.LEFT) then
                    --tabs on left
                    context:vertical_box({
                        allignment=def.tabs_allignment,
                        padding={x=0,y=0},
                        texture="",
                        middle={0,0,0,0}
                    }, tabs_func)
                end
                --tab body
                context:container({
                    width=inner_size.x,
                    height=inner_size.y,
                    padding={x=0,y=0},
                        texture="",
                        middle={0,0,0,0}
                }, active_tab.page)
                if (def.allignment ~= qts.scribe.allignment.LEFT) then
                    --tabs on right
                    context:vertical_box({
                        allignment=def.tabs_allignment,
                        padding={x=0,y=0},
                        texture="",
                        middle={0,0,0,0}
                    }, tabs_func)
                end
            end)
        end

        return self
    end,

    ---Add a callback function to run when GUI is closed. More than 1 can be added.
    ---@param self ScribeContext
    ---@param callback ScribeCallbackFunction
    quit_callback = function(self, callback)
        if self.callbacks.quit then
            if type(self.callbacks.quit) == "function" then
                local f =self.callbacks.quit
                self.callbacks.quit = {
                    f,
                    callback
                } 
            elseif type(self.callbacks.quit) == "table" then
                self.callbacks.quit[#self.callbacks.quit+1] = callback
            end
        else
            self.callbacks.quit = callback
        end
        return self
    end,

    ---Add a callback function to run when GUI is refreshed. More than 1 can be added.
    ---@param self ScribeContext
    ---@param callback ScribeCallbackFunction
    refresh_callback = function(self, callback)
        if self.callbacks.refresh then
            if type(self.callbacks.refresh) == "function" then
                local f =self.callbacks.refresh
                self.callbacks.refresh = {
                    f,
                    callback
                } 
            elseif type(self.callbacks.refresh) == "table" then
                self.callbacks.refresh[#self.callbacks.refresh+1] = callback
            end
        else
            self.callbacks.refresh = callback
        end
        return self
    end,

    ---Add an arbitrary callback function to run when the callback is named. Only one can be added with the same name.
    ---@param self ScribeContext
    ---@param callback ScribeCallbackFunction
    named_callback = function(self, name, callback)
        if self.callbacks[name] then
            if type(self.callbacks[name]) == "function" then
                local f =self.callbacks[name]
                self.callbacks[name] = {
                    f,
                    callback
                } 
            elseif type(self.callbacks[name]) == "table" then
                self.callbacks[name][#self.callbacks[name]+1] = callback
            end
        else
            self.callbacks[name] = callback
        end
        return self
    end,

    ---Assign a style for this element's children
    ---@param self ScribeContext
    ---@param stylename string "modname:name" style scribe style name
    set_style = function(self, stylename)
        ---@type ScribeStyle
        local style = qts.scribe.registered_styles[stylename]
        if style == nil then
            minetest.log("warning", "Attempted to set a named style that is not registered. Style: " .. stylename)
            return
        end
        if (self.formdata.details.type == "base" ) then
            self.formdata.details.use_minetest_prepend = qts.select(style.use_minetest_prepend, true, false)

            if style.inventory_colors ~= nil and type(style.inventory_colors) == "table" then
                --TODO: handler style.inventory_colors here
                ---@type ScribeInventoryFormColors
                self.formdata.details.inventory_colors = table.copy(style.inventory_colors)
                if self.formdata.details.inventory_colors.background_color == nil then 
                    self.formdata.details.inventory_colors.background_color = "#00000069"
                end
                if self.formdata.details.inventory_colors.background_hover_color == nil then 
                    self.formdata.details.inventory_colors.background_hover_color = "#5A5A5A"
                end
                if self.formdata.details.inventory_colors.border_color == nil then 
                    self.formdata.details.inventory_colors.border_color = "#141318"
                end
                if self.formdata.details.inventory_colors.tooltip_color == nil then 
                    self.formdata.details.inventory_colors.tooltip_color = "#30434C"
                end
                if self.formdata.details.inventory_colors.tooltip_text_color == nil then 
                    self.formdata.details.inventory_colors.tooltip_text_color = "#FFFFFF"
                end
            end
        end
        self.formdata.details.stylename = stylename
        return self
    end,

    --[[   Internal Utility Functions   ]] 
    ---Create a ScribeContext
    ---@param player Player The player the GUI should be open for
    ---@param position Vector gui position name
    ---@param name string "mod:name" format
    ---@param tbl? table arbitrary table or nil to make into a ScribeContext
    ---@return ScribeContext
    create = function (player, position, name, tbl)
        if tbl == nil then
            tbl = {}
        end
        --setup the data
        tbl.player = player
        tbl.position = position
        tbl.name = name
        tbl.userdata = {}
        tbl.formdata = {
            details = {
                type="base",
                visibility = qts.scribe.visibility.VISIBLE,
                stylename = nil,
            },
            children = {}
        }
        tbl.callbacks={}
        --set metatable
        setmetatable(tbl, qts.scribe.context_base.__mt)
        --return
        return tbl
    end,

    ---Create a child context, for containers
    ---This is a copy of all the refs except formdata.
    ---@param self ScribeContext
    ---@return ScribeContext child
    child = function(self)
        local t = {
            player = self.player,
            position = self.position,
            name = self.name,
            userdata = self.userdata,
            callbacks = self.callbacks,
            formdata = {
                details = {
                    type="child",
                    visibility = self.formdata.details.visibility,
                    stylename = self.formdata.details.stylename,
                },
                children = {}
            },
        }
        setmetatable(t, qts.scribe.context_base.__mt)
        return t
    end,

    ---Generate the formspec string from this context.
    ---@param self ScribeContext self-reference
    ---@return string formspec the formspec string
    generate_formspec = function(self)
        return build_formspec_from_fields(self.formdata)
    end,

    ---Show the GUI generated by this context
    ---@param self ScribeContext
    show_gui = function(self)
        if (self.userdata.__scribe__debug_printing__) then
            minetest.log("Scribe Debug Output:\n"..self:generate_formspec()) 
        end
        minetest.show_formspec(self.player:get_player_name(), self.name, self:generate_formspec())
    end,

    ---Get the default fields for an element name
    ---@param self ScribeContext
    ---@param elementname ScribeElementName
    ---@return ScribeBasicFormDefinition
    get_element_defaults = function(self, elementname)
        ---@type ScribeStyle
        local style = qts.scribe.registered_styles[self.formdata.details.stylename]
        if style == nil then 
            return {} 
        end
        ---@type ScribeBasicFormDefinition
        local defaults = {}
        if style[elementname] ~= nil then
            defaults = style[elementname]
            if (defaults) then
                defaults.tooltip = build_tooltip(defaults.tooltip, style.tooltip_colors)
            end
        end
        return defaults
    end,

    ---Enable debug printing on this scribe context. It will print the formspec when displayed.
    ---@param self ScribeContext
    ---@param debug_printing boolean
    ---@return ScribeContext self
    enable_debug_printing = function(self, debug_printing)
        self.userdata.__scribe__debug_printing__ = qts.select(debug_printing, true, false)
        return self
    end,
}

--set the context as the metatable 
qts.scribe.context_base.__mt.__index  = qts.scribe.context_base

--common function
qts.scribe.new_context = qts.scribe.context_base.create

--[[Meta Lua Annotations]]

--[[ Internal data types ]]

---@alias ScribeContextFunction fun(context:ScribeContext):nil function for generating GUI elements using a context

---@alias ScribeCallbackFunction fun(event:ScribeEvent):nil function for a gui event callback

--[[
ScribeFormType is an enum of the underlying base elements that are converted into formspec.
All other types of elements are made from these collected together.
]]
---@alias ScribeFormType
---| "base"
---| "child"
---| "container"
---| "button"
---| "vertical_box"
---| "horizontal_box"
---| "rect"
---| "text"
---| "text_entry"
---| "image"
---| "inventory"
---| "model"

---@class ScribeFormDetails
---@field type ScribeFormType
---@field size vec2
---@field position vec2|nil
---@field visibility ScribeFormVisibility
---@field tooltip string|{text:string,bgcolor:ColorSpec,fgcolor:ColorSpec}|nil
---@field padding vec2|nil the padding around child elements
---@field spacing vec2|nil the spacing between child elements
---@field stylename string|nil the name of the style being used

---@class ScribeFormdata
---@field details ScribeFormDetails|table details about the type of form represented
---@field children ScribeFormdata[]|nil list of children

--[[ Definitions for form elements ]]

---@alias Rect number|vec2|{x_min:number,y_min:number,x_max:number,y_max:number} a middle definition for 9-slice elements

---@alias ScribeToolTip
---|string
---|{text:string,bgcolor:ColorSpec,fgcolor:ColorSpec}

---@class ScribeFontStyle {style:"normal"|"mono"|nil, bold:boolean|nil, italic:boolean|nil, size:number|string|nil}
---@field style "normal"|"mono"|nil use normal or monospace. If nil, normal is used
---@field bold boolean|nil boolean text bold or not
---@field italic boolean|nil boolean text italic or not.
---@field underline boolean|nil boolean text underlined or not.
---@field size number|string|nil number-the size. "+<number>"-increase by size. "-<number>" decrease by size. "*<number>"-multiply by size
---@field color ColorSpec|nil Text color
---@field secondary_color ColorSpec|nil Secondary Text color, if a secondary color is needed. Example is hoverable text in a Text element.

---@class ScribeAnimation
---@field count integer the number of frames vertically.
---@field duration number the frame duration in milliseconds
---@field start integer the starting frame index 

---@class ScribeBasicFormDefinition
---@field width number|nil if supplied, the width of the container. If not, size is auto-calculated.
---@field height number|nil if supplied, the height of the container. If not, size is auto-calculated.
---@field tooltip ScribeToolTip|nil if supplied, it is the tooltip text when hovering over this form.
---@field visibility ScribeFormVisibility|nil if supplied, it is the visibility of the form. defaults to VISIBLE
---@field position vec2|nil the position of the form, if supported.
---@field padding vec2|nil the padding around child elements, if supported.
---@field spacing vec2|nil the spacing between child elements, if supported.

---@class ScribeContainerFormDefinition : ScribeBasicFormDefinition
---@field texture Texture|nil the background texture of the form, if supplied.
---@field middle nil|Rect If supplied, the middle definition for the texture, as a 9-slice tile. number - that many pixels from all size. {x,y} - x pixels from edge horizontally, y pixels vertically. {x_min,y_min,x_max,y_max} - respective pixels from each side.

---@class ScribeBoxFormDefinition : ScribeContainerFormDefinition
---@field scrollable boolean|nil should the box be able to scroll
---@field allignment ScribeFormAllignment|nil how should the elements be aligned?
---@field scrollbar_side ScribeFormAllignment|nil where should the scrollbar be placed?
---@field scrollbar_size number|nil scrollbar size. Default: 1
---@field scrollbar_name string|nil scrollbar name. Default: nil for autogenerated name
---@field scrollbar_autohide boolean|nil automatically hide the scrollbar when there are not enough elements for the list to be scrollable. Default to true.

---@class ScribeTextFormDefinition : ScribeBasicFormDefinition
---@field name string|nil form name, if you want a static one. Otherwise, an autogenerated name will be used.
---@field text string|nil the text to display. May have markups, though not <global>.
---@field font ScribeFontStyle|nil the label font. Color is unused.
---@field vertical_allignment ScribeFormAllignment|nil the vertical allignment of the text, defaults to CENTER
---@field horizontal_allignment ScribeFormAllignment|nil the horizontal allignment of the text, defaults to CENTER
---@field background_color ColorSpec|"none"|nil the color of the background, defaults to transparent
---@field margin number|nil page margin in pixels

---@class ScribeTextInputFormDefinition : ScribeBasicFormDefinition
---@field name string|nil form name, if you want a static one. Otherwise, an autogenerated name will be used.
---@field label string|nil Label for the field, appears in the upper-left, above the TextInput form.
---@field default_value string|nil If supplied and supported, the default text in the field.
---@field obscure_content boolean|nil if true, the field will show a "*" instead of the actual character typed in. Used for passwords. Incompatable with `multiline`.
---@field multiline boolean|nil If true, the field will support multiline text. Incompatable with `obscure_content`.
---@field border boolean|nil if true, show the default border. Defaults to true.
---@field font ScribeFontStyle|nil the text font.
---@field close_on_enter boolean|nil if true, close the UI on text submission.
---@field persistant_text boolean|nil if true, the text entered is maintained across refreshes. Default is true

---@class ScribeRectFormDefinition : ScribeBasicFormDefinition
---@field color ColorSpec|"none"|nil the color of the background, or nil/"none" for invisible

---@class ScribeSeperatorFormDefinition : ScribeRectFormDefinition
---@field length number|nil the length of the line. Defaults to -1. Set to nil or negative to use the parent element size.
---@field orientation ScribeFormOrientation|nil the orientation of the line

---@class ScribeImageFormDefinition : ScribeBasicFormDefinition
---@field name string|nil form name, if you want a static one. Otherwise, an autogenerated name will be used
---@field texture Texture|nil texture, if a texture is being used. If nil, then item must be defined.
---@field item ItemName|nil item, if an item is being used. If nil, then texture must be defined.
---@field animation ScribeAnimation|nil
---@field middle Rect|nil

---@class ScribeButtonStateStyle The description of the look of a button's State
---@field background_use_alpha boolean|nil should the bg images use their alpha channel?
---@field background Texture|nil the texture to be shown behind the main one
---@field background_middle Rect|nil the middle of the background texture, to make it a 9-slice tile
---@field background_tint ColorSpec|nil tint for normal button
---@field font ScribeFontStyle|nil Font permutation.
---@field border boolean|nil draw the border or not
---@field internal_offset vec2|nil offset the contents of the button without resize.
---@field padding Rect|nil padding around the middle. Relative ot the internal_offset

---@class ScribeButtonFormDefinition : ScribeBasicFormDefinition
---@field name string|nil form name, if you want a static one. Otherwise, a autogenerated oen will be used.
---@field label string|nil text on the button
---@field is_exit boolean|nil if true, the button will close the form on exit. does not work with 'item'.
---@field texture Texture|nil texture to show, if wanted.
---@field texture_pressed Texture|nil if texture is valid, and this is valid, show texture_pressed instead of texture when button pressed
---@field item ItemName|nil item to appear on the button. Does not work with 'texture' or 'texture_pressed'
---@field sound string|nil sound to play when clicked.
---@field style_any ScribeButtonStateStyle|nil Style when no other state specifies it. Global styles override this.
---@field style_normal ScribeButtonStateStyle|nil Style in the normal state
---@field style_hovered ScribeButtonStateStyle|nil Style in the hovered state
---@field style_pressed ScribeButtonStateStyle|nil Style in the pressed state
---@field style_all ScribeButtonStateStyle|nil Style in all states, overriding global style, but not overriding style set per state per element.
---@field toggleable boolean|nil Make the button a toggle button. When toggled "on", texture and texture_pressed are switched.
---@field style_toggled_any ScribeButtonStateStyle|nil Style when no other state specifies it. Global styles override this. Used when toggled on.
---@field style_toggled_normal ScribeButtonStateStyle|nil Style in the normal state. Used when toggled on.
---@field style_toggled_hovered ScribeButtonStateStyle|nil Style in the hovered state. Used when toggled on.
---@field style_toggled_pressed ScribeButtonStateStyle|nil Style in the pressed state. Used when toggled on.
---@field style_toggled_all ScribeButtonStateStyle|nil Style in all states, overriding global style, but not overriding style set per state per element. Used when toggled on.

---@class ScribeInventoryFormDefinition : ScribeBasicFormDefinition
---@field source ScribeInventorySource|nil The source for the inventory. Defaults to CURRENT_PLAYER
---@field sourcename string|Vector|nil If the source is specified or detached, then this is the specified name. A vector or a vector string can be used for nodes.
---@field listname string|nil Name of the inventory list.
---@field starting_item_index integer|nil The starting item index for the area. Default: 0 (no offset) - This is 0-indexed!
---@field use_list_ring boolean|nil If true, the inventory is added to the list ring.
---@field slot_size vec2|nil The size of the inventory slots
---@field slot_spacing vec2|nil The size of the inventory slot spacing
---@field use_actual_size boolean|nil if true, the width, height supplied will be actual UI size and not number of elements
---@field orientation ScribeFormOrientation|nil The orientation.Defaults to HORIZONTAL

---@class ScribeModelFormDefinition : ScribeBasicFormDefinition
---@field name string? Element name. Default: generated.
---@field mesh Mesh Mesh model name. Must be provided.
---@field textures Texture Mesh textures, seperated by commas. Must be provided.
---@field rotation vec2? Initial camera rotation. Default: {x=0,y=0}
---@field continuous_rotation boolean? If true, the rotation value is continuous, like a turntable. Default: false
---@field mouse_control boolean? If true, the mouse can control the rotation. Default: false
---@field frame_loop_range vec2? the range of any animation to play, <begin>,<end>. Default: {x=0,y=0}
---@field frames_per_second number? frames per second on the animation. Default: 0
---@field background_color ColorSpec? background color. Default: minetest default

---@class ScribeTabHeaderFormDefinition : ScribeBasicFormDefinition
---@field name string Element name. Must be provided.
---@field style_any ScribeButtonStateStyle? Style when no other state specifies it. Global styles override this.
---@field style_normal ScribeButtonStateStyle? Style in the normal state
---@field style_hovered ScribeButtonStateStyle? Style in the hovered state
---@field style_pressed ScribeButtonStateStyle? Style in the pressed state
---@field style_all ScribeButtonStateStyle? Style in the pressed state
---@field orientation ScribeFormOrientation? Orientation of the header
---@field allignment ScribeFormAllignment? Allignment of the header (IE, left-right or top-bottom selection)
---@field tabs_allignment ScribeFormAllignment? Allignment of the header tabs (left-to-right, centered, top-to-bottom, etc)
---@field inner_size vec2? Size of the inner container for the tab pages

---@class ScribeTabDefinition : ScribeBasicFormDefinition
---@field name string tab name. Must be supplied to keep it static
---@field label string? text on the button
---@field texture Texture? texture to show, if wanted.
---@field texture_pressed Texture|nil if texture is valid, and this is valid, show texture_pressed instead of texture when button pressed
---@field item ItemName? item to appear on the button. Does not work with 'texture' or 'texture_pressed'
---@field sound string? sound to play when clicked.
---@field style_any ScribeButtonStateStyle? Style when no other state specifies it. Global styles override this.
---@field style_normal ScribeButtonStateStyle? Style in the normal state
---@field style_hovered ScribeButtonStateStyle? Style in the hovered state
---@field style_pressed ScribeButtonStateStyle? Style in the pressed state
---@field style_all ScribeButtonStateStyle? Style in all states, overriding global style, but not overriding style set per state per element.
---@field allignment ScribeFormAllignment? Overide to the global allignment

---@class ScribeTab
---@field tab ScribeTabDefinition
---@field page ScribeContextFunction

---@class ScribeInventoryFormColors Colors for building an inventory
---@field background_color ColorSpec|nil The background color
---@field background_hover_color ColorSpec|nil The background color when hovered
---@field border_color ColorSpec|nil The border color
---@field tooltip_color ColorSpec|nil The tooltip background color
---@field tooltip_text_color ColorSpec|nil The tooltip text color

---@class ScribeStyle a table with the default style values for the UI elements
---@field use_minetest_prepend boolean|nil if true, will use the registered minetest prepend. Only works when style is applied to root context.
---@field container ScribeContainerFormDefinition|nil default for a container form
---@field vertical_box ScribeBoxFormDefinition|nil defaults for a vertical box form
---@field horizontal_box ScribeBoxFormDefinition|nil defaults for a horizontal box form
---@field text ScribeTextFormDefinition|nil defaults for a text form
---@field text_input ScribeTextInputFormDefinition|nil defaults for a text input form
---@field rect ScribeRectFormDefinition|nil defaults for a rect form
---@field image ScribeImageFormDefinition|nil defaults for an image form
---@field button ScribeButtonFormDefinition|nil defaults for a regular button form
---@field toggle_button ScribeButtonFormDefinition|nil defaults for a toggleable button form
---@field inventory ScribeInventoryFormDefinition|nil defaults for an inventory form
---@field model ScribeModelFormDefinition|nil defaults for a model form
---@field tab_header ScribeTabHeaderFormDefinition|nil defaults for a model form
---@field inventory_colors ScribeInventoryFormColors|nil default colors for an inventory form. Only works when style is applied to root context.
---@field tooltip_colors ScribeToolTip? default tooltip colors

--[[
    The scribe element is the type used for styling scribe forms.
    It has slightly different members than ScribeFormType, which 
    represents the underlying forms sent to formspec
]]
---@alias ScribeElementName
---|"container"
---|"vertical_box"
---|"horizontal_box"
---|"text"
---|"text_input"
---|"rect"
---|"image"
---|"button"
---|"toggle_button"
---|"inventory"
---|"model"
---|"tab_header"

--[[  Register a Scribe GUI for the existing GUI system  ]]

---Register a scribe GUI for the existing GUI system
---@param name string the gui name
---@param func ScribeContextFunction 
function qts.gui.register_scribe_gui(name, func)
    
    qts.gui.register_gui(name, {
        get = function (data, pos, playername, context)
            local player = minetest.get_player_by_name(playername)
            
            if (context == nil) then
                context = qts.scribe.new_context(player, pos, name)
            end
            func(context)
            data.userdata = context.userdata
            data.callbacks = context.callbacks
            if (data.userdata.__scribe__debug_printing__) then
                minetest.log("Scribe GUI Debug Output:\n"..context:generate_formspec()) 
            end
            return context:generate_formspec()
        end,
        handle = function (data, pos, playername, fields)
            if data.userdata == nil then data.userdata = {} end
            if data.callbacks == nil then data.callbacks = {} end
            
            local player = minetest.get_player_by_name(playername)
            
            local event = qts.scribe.new_event(player, pos, name, data.userdata, data.callbacks, fields, 
                function (context)
                    qts.gui.show_gui(pos, player, name, 1, true, context)
                    data.userdata = context.userdata
                    data.callbacks = context.callbacks
                end
            )
            
            for name, callback in pairs(data.callbacks) do
                if fields[name] then
                    if type(callback) == "function" then
                        callback(event)
                    elseif type(callback)=="table" then
                        for i, fun in ipairs(callback) do
                            fun(event)
                        end
                    end
                end
            end
            
            if event.needs_close then
                event:close_gui()
            elseif event.needs_refresh then
               event:refresh_gui(true)
            end
        end,
        tab=false,
        tab_owner=false,
    })
end


