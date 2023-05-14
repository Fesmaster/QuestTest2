--[[
    a scribe Context is the table containing all the functions needed to generate a GUI element.

    A context is a local table with its metatable set to allow it to access the scribe context functions.

    A context is created for each gui, and has to know the player, the position, and the form name at creation time.
]]

--[[Helper functions to generate formspec from a formdata table]]

local element_name_counter = Counter()

---Create an element name for those that do not exist
---@param basename string
---@return string
function qts.scribe.next_element_name(basename)
    return basename .. element_name_counter()
end

--import these datatables to make this file more writable

---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
local formspec_builder_prechild = dofile(qts.path.."/scribe/formspec_generator_prechild.lua")

---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
local formspec_builder_postchild = dofile(qts.path.."/scribe/formspec_generator_postchild.lua")



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
    else
        minetest.log("skipping invisible formspec")
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

---Helper for building a child context.
---@param context ScribeContext
---@param childformdata ScribeFormdata
---@param def ScribeBasicFormDefinition
---@param type ScribeFormType
local function common_build_child_formdata(context, childformdata, def, type)
    childformdata.details.type = type
    if def.visibility then
        childformdata.details.visibility = def.visibility
    else
        childformdata.details.visibility = qts.scribe.visibility.VISIBLE
    end
    childformdata.details.position = qts.scribe.vec2.copy(def.position, childformdata.details.position)
    childformdata.details.tooltip = def.tooltip
end

---Get the size of a form, taking its visibility into account
---@param formdata ScribeFormdata
---@return vec2
local function get_formdata_size(formdata)
    if formdata.details.visibility == qts.scribe.visibility.COLLAPSED then
        return {x=0,y=0}
    end
    return formdata.details.size
end


---Helper for calculating a child's size
---@param context ScribeContext
---@param childformdata ScribeFormdata
---@param def ScribeBasicFormDefinition
---@param defaultsize vec2|nil defautls to {x=0,y=0}
local function common_build_child_size(context, childformdata, def, defaultsize)
    ---@type vec2
    local size = defaultsize or {x=0,y=0}
    for i, subchildformdata in ipairs(childformdata.children) do
        if subchildformdata.details.visibility ~= qts.scribe.visibility.COLLAPSED then
            qts.scribe.vec2.max(get_formdata_size(subchildformdata), size, size)
        end
    end
    --override with set width and height
    if def.width and type(def.width)=="number" then
        size.x = def.width
    end
    if def.height and type(def.height)=="number" then
        size.y = def.height
    end
    --assign to form
    childformdata.details.size = size
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
        --create the child context
        local child = self:child()
        common_build_child_formdata(self, child.formdata, def, "container")

        --texture
        if def.texture and type(def.texture) == "string" then
            child.formdata.details.texture = def.texture

            --check for a valid middle definition
            local hasMid = false
            if def.middle then
                child.formdata.details.middle = parse_middle_format(def.middle)
            end
        end

        --children
        if type(children) == "function" then
            children(child)
        end

        common_build_child_size(self, child.formdata, def)

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
        --create the child context
        local child = self:child()
        common_build_child_formdata(self, child.formdata, def, "vertical_box")

        --texture
        if def.texture and type(def.texture) == "string" then
            child.formdata.details.texture = def.texture
        
            --check for a valid middle definition
            local hasMid = false
            if def.middle then
                child.formdata.details.middle = parse_middle_format(def.middle)
            end
        end

        --other box fields:
        if def.scrollable ~= nil then
            child.formdata.details.scrollable = def.scrollable
        else
            child.formdata.details.scrollable = false
        end
        child.formdata.details.alignment = def.alignment
        child.formdata.details.scrollbar_side = def.scrollbar_side
        
        --children
        if type(children) == "function" then
            children(child)
        end
        
        --running height of next element
        local runningHeight = 0 --TODO: include padding
        
        local scrollbar_size = 0
        if def.scrollable then
            if def.scrollbar_size then
                scrollbar_size = def.scrollbar_size
            else
                scrollbar_size = 0.5
            end
        end
        child.formdata.details.scrollbar_size = scrollbar_size

        --calculate width
        local maxwidth = 0
        if def.width then 
            maxwidth = def.width - scrollbar_size
        else
            for i, subchildformdata in ipairs(child.formdata.children) do
                maxwidth = math.max(maxwidth, get_formdata_size(subchildformdata).x)
            end
        end

        --arrange children and get total height
        for i, subchildformdata in ipairs(child.formdata.children) do
            local size = get_formdata_size(subchildformdata)
            local x_pos = 0 --default: left allignment
            if def.alignment == qts.scribe.allignment.CENTER then
                --center allignment
                x_pos = (maxwidth/2) - (size.x/2)
            elseif def.alignment == qts.scribe.allignment.RIGHT then
                --right allignment
                x_pos = maxwidth - size.x
            end
            --set the position
            subchildformdata.details.position = {x=x_pos, y=runningHeight}
            
            --update height for next one
            runningHeight = runningHeight + size.y --TODO: include spacing!
        end

        --full size of list, in case scrollable
        child.formdata.details.listsize = runningHeight

        --set self size
        child.formdata.details.size = {}
        if def.height then
            child.formdata.details.size.y = def.height
        else
            child.formdata.details.size.y = runningHeight --TODO: include padding!
        end
        child.formdata.details.size.x = maxwidth + scrollbar_size


        --add the child to self.
        self.formdata.children[#self.formdata.children+1] = child.formdata

        --ALWAYS return self from gui form type functions!
        return self
    end,

    ---Create a button element. 
    ---@param self ScribeContext
    ---@param def ScribeButtonFormDefinition
    ---@param callback ScribeCallbackFunction|nil
    ---@return ScribeContext self self-reference.
    button = function(self, def, callback)
        local childformdata = common_create_formdata(self)
        common_build_child_formdata(self, childformdata, def, "button")
        common_build_child_size(self, childformdata, def, {x=1,y=1})

        if def.name then
            childformdata.details.name = def.name
        else
            childformdata.details.name = qts.scribe.next_element_name("button")
        end
        childformdata.details.label = def.label
        childformdata.details.is_exit = def.is_exit
        childformdata.details.texture = def.texture
        childformdata.details.texture_pressed = def.texture_pressed
        childformdata.details.background = def.background
        childformdata.details.background_pressed = def.background_pressed
        childformdata.details.background_hovered = def.background_hovered
        childformdata.details.background_middle = parse_middle_format(def.background_middle)
        childformdata.details.background_use_alpha = def.background_use_alpha
        childformdata.details.background_tint = def.background_tint
        childformdata.details.background_tint_hovered = def.background_tint_hovered
        childformdata.details.background_tint_pressed = def.background_tint_pressed
        childformdata.details.font = def.font or {}
        childformdata.details.border = def.border or false
        childformdata.details.internal_offset = def.internal_offset
        childformdata.details.padding = parse_middle_format(def.padding)
        childformdata.details.sound = def.sound or "gui_button" --default sound!!!
        
        if def.texture == nil and def.texture_pressed == nil and (def.is_exit == nil or def.is_exit == false) then
            childformdata.details.item = def.item
        else
            minetest.log("warning", "[formspec unsupported] you cannot make a button with an item if it has a texture, a texture_pressed, or is an exit button. Sorry!")
        end

        self.formdata.children[#self.formdata.children+1] = childformdata

        --add the function
        self.callbacks[childformdata.details.name] = callback

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
                details = {type="child"},
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
        minetest.show_formspec(self.player:get_player_name(), self.name, self:generate_formspec())
    end,
}





--set the context as the metatable 
qts.scribe.context_base.__mt.__index  = qts.scribe.context_base

--common function
qts.scribe.new_context = qts.scribe.context_base.create

--[[Meta Lua Annotations]]

--[[ Internal data types ]]

---@alias ScribeContextFunction fun(context:ScribeContext):nil function for generating GUI elements using a context

---@alias ScribeCallbackFunction fun(context:ScribeEvent):nil function for a gui event callback

---@alias ScribeFormType
---| "base"
---| "child"
---| "container"
---| "button"
---| "vertical_box"
---| "horizontal_box"

---@class ScribeFormDetails
---@field type ScribeFormType
---@field size vec2
---@field position vec2|nil
---@field visibility ScribeFormVisibility
---@field tooltip string|{text:string,bgcolor:ColorSpec,fgcolor:ColorSpec}|nil

---@class ScribeFormdata
---@field details ScribeFormDetails|table details about the type of form represented
---@field children ScribeFormdata[]|nil list of children

--[[ Definitions for form elements ]]

---@alias Rect number|vec2|{x_min:number,y_min:number,x_max:number,y_max:number} a middle definition for 9-slice elements

---@class ScribeFontStyle {style:"normal"|"mono"|nil, bold:boolean|nil, italic:boolean|nil, size:number|string|nil}
---@field style "normal"|"mono"|nil use normal or monospace. If nil, normal is used
---@field bold boolean|nil boolean text bold or not
---@field italic boolean|nil boolean text italic or not.
---@field size number|string|nil number-the size. "+<number>"-increase by size. "-<number>" decrease by size. "*<number>"-multiply by size
---@field color ColorSpec|nil Text color

---@class ScribeBasicFormDefinition
---@field width number|nil if supplied, the width of the container. If not, size is auto-calculated.
---@field height number|nil if supplied, the height of the container. If not, size is auto-calculated.
---@field tooltip string|{text:string,bgcolor:ColorSpec,fgcolor:ColorSpec}|nil if supplied, it is the tooltip text when hovering over this form.
---@field visibility ScribeFormVisibility|nil if supplied, it is the visibility of the form. defaults to VISIBLE
---@field position vec2|nil the position of the form, if supported.

---@class ScribeContainerFormDefinition : ScribeBasicFormDefinition
---@field texture Texture|nil the background texture of the form, if supplied.
---@field middle nil|Rect If supplied, the middle definition for the texture, as a 9-slice tile. number - that many pixels from all size. {x,y} - x pixels from edge horizontally, y pixels vertically. {x_min,y_min,x_max,y_max} - respective pixels from each side.

---@class ScribeBoxFormDefinition : ScribeContainerFormDefinition
---@field scrollable boolean|nil should the box be able to scroll
---@field alignment ScribeFormAllignment|nil how should the elements be aligned?
---@field scrollbar_side ScribeFormAllignment|nil where should the scrollbar be placed?
---@field scrollbar_size number|nil scrollbar size. Default: 1

---@class ScribeButtonFormDefinition : ScribeBasicFormDefinition
---@field name string|nil form name, if you want a static one. Otherwise, a autogenerated oen will be used.
---@field label string|nil text on the button
---@field is_exit boolean|nil if true, the button will close the form on exit. does not work with 'item'.
---@field texture Texture|nil texture to show, if wanted
---@field texture_pressed Texture|nil 
---@field item ItemName|nil item to appear on the button. Does not work with 'texture' or 'texture_pressed'
---@field background Texture|nil the texture to be shown behind the main one
---@field background_hovered Texture|nil the texture to be shown behind the main one when hovered
---@field background_pressed Texture|nil the texture to be shown behind the main one when pressed
---@field background_middle Rect|nil the middle of the background texture, to make it a 9-slice tile
---@field background_use_alpha boolean|nil should the bg images use their alpha channel?
---@field background_tint ColorSpec|nil tint for normal button
---@field background_tint_hovered ColorSpec|nil tint for hovered button
---@field background_tint_pressed ColorSpec|nil tint for pressed button
---@field font ScribeFontStyle|nil Font permutation.
---@field border boolean|nil draw the border or not
---@field internal_offset vec2|nil offset the contents of the button without resize.
---@field padding Rect|nil padding around the middle. Relative ot the internal_offset
---@field sound string sound to play when clicked.

--[[TESTING]]

---Test function
---@param context ScribeContext
local function gui_test_func(context)
    context:container({
        --texture="gui_formbg.png",
        width=10,
        height=10,
        --middle=5,
    }, function (context_c1)
        --do nothing right now.
        context_c1:button({
            label="Button1",
            tooltip="The first Button",
            width=2,
            height=1,
            padding=0,
            --background="Transparent.png",
            --background_hovered="Transparent.png",
            --background_pressed="Transparent.png",
            position={x=1,y=0},
            font = {
                style="mono",
                bold=true,
                italic=true,
                color="#FF0000",
                size=20
            }
        },
        function(event)
            minetest.log("Button1 pressed")
        end)
        :vertical_box({
            texture="gui_buttonareabg.png",
            position={x=0,y=1},
            scrollable=true,
            height=8,
            width=7,
            alignment=qts.scribe.allignment.CENTER,
            scrollbar_side=qts.scribe.allignment.LEFT,
            scrollbar_size=0.5
        }, function(context_v1)
            context_v1:button({
                tooltip="The granite Button",
                item="overworld:granite",
                width=4,
                height=4,
                padding=5,
            },
            function(event)
                minetest.log("granite button pressed")
            end)
            :button({
                tooltip="The marble Button",
                item="overworld:marble",
                width=3,
                height=4,
                padding=5,
            },
            function(event)
                minetest.log("marble button pressed")
            end)
            :button({
                tooltip="The oak Button",
                item="overworld:oak_wood_planks",
                width=2,
                height=4,
                padding=5,
            },
            function(event)
                minetest.log("oak button pressed")
            end)
            :button({
                tooltip="The aspen Button",
                item="overworld:aspen_wood_planks",
                width=1,
                height=4,
                padding=5,
            },
            function(event)
                minetest.log("aspen button pressed")
            end)
            
        end)
        --[[
        ]]
    end)
    :quit_callback(function(event)
        minetest.log("scribe test gui quit!")
    end)
end

local userdata = {}
local callbacks = {}

minetest.register_chatcommand("scribetest", {
    params = "",
	description = "Tests Scribe GUI system",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
        if player then
            local context = qts.scribe.new_context(player, player:get_pos(), "qts:scribe_test")
            gui_test_func(context)
            userdata = context.userdata
            callbacks = context.callbacks
            minetest.log("FORMSPEC: "..context:generate_formspec())
            context:show_gui()
        end
	end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "qts:scribe_test" then
        minetest.log("Fields: " ..dump(fields))
        
        local event = qts.scribe.new_event(player, player:get_pos(), formname, userdata, fields, gui_test_func)
        for name, callback in pairs(callbacks) do
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
           event:refresh_gui()
        end

        return true
    end
    return false
end)

