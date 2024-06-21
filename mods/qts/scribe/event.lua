--[[
    Scribe Event
    This type is passed to callback functions.

]]

---@class ScribeEvent
---@field player Player the player
---@field position Vector the position referenced
---@field guiname string the form name
---@field userdata table arbitrary data that is available at event-time and at regen-time
---@field fields table global callback fields from the form
---@field context_func nil|ScribeContextFunction function to fill context with data.
---@field callbacks nil|table<string,fun(event:ScribeEvent):nil> New callback functions, if regenerated
---@field needs_refresh boolean|nil set to true to cause the GUI to automatically refresh after all events handled.
---@field needs_close boolean|nil set to true to cause the GUI to automatically close after all events handled.
---@field fieldname string the current field handling events.
qts.scribe.event_base = {
    --metatable
    __mt = {},

    handle_callbacks =function(self)
        if self.__in_callback_handler then return end
        self.__in_callback_handler = true
        for name, callback in pairs(self.callbacks) do
            if self.fields[name] then
                self.fieldname = name
                if type(callback) == "function" then
                    callback(self)
                elseif type(callback)=="table" then
                    for i, fun in ipairs(callback) do
                        fun(self)
                    end
                end
            end
        end
        
        if self.needs_close then
            self:close_gui()
        elseif self.needs_refresh then
            self:refresh_gui(true)
        end
        self.__in_callback_handler = true
    end,

    ---Regenerate the GUI. Completely replaces the callback function list.
    ---You should always return right after calling this
    ---@param self ScribeEvent
    ---@param ignore_show boolean? set to "true" to skip showing the GUI - as this might break some automated GUI systems
    refresh_gui = function(self, ignore_show)
        if self.callbacks and self.callbacks.refresh then
            if type(self.callbacks.refresh) == "table" then
                ---@diagnostic disable-next-line: param-type-mismatch
                for i, func in ipairs(self.callbacks.refresh) do
                    func(self)
                end
            else
                self.callbacks.refresh(self)
            end
        end        

        if self.context_func then
            local context = qts.scribe.new_context(self.player, self.position, self.guiname)
            context.userdata = self.userdata --copy userdata ref
            self.context_func(context)
            self.callbacks = context.callbacks
            self.userdata = context.userdata
            if (not ignore_show) then
                context:show_gui()
            end
        end
    end,

    ---Mark the GUI for refresh when all events handled.
    ---@param self ScribeEvent
    mark_for_refresh = function(self)
        self.needs_refresh = true
    end,

    ---Close the GUI immedately.
    ---You should always return right after calling this
    ---@param self ScribeEvent
    close_gui = function(self)
        minetest.close_formspec(self.player:get_player_name(), self.guiname)
    end,

    ---Mark the GUI for close when all events handled.
    ---@param self ScribeEvent
    mark_for_close = function(self)
        self.needs_close = true
    end,

    ---comment
    ---@param self ScribeEvent
    ---@param name string?
    get_toggle_state = function(self, name)
        if name == nil then name = self.fieldname end
        if self.userdata._scribe[name] and self.userdata._scribe[name].toggled ~= nil then
            return self.userdata._scribe[name].toggled
        end
        return nil
    end,

    ---Create a new ScribeEvent
    ---@param player Player
    ---@param position Vector
    ---@param guiname string
    ---@param userdata table
    ---@param fields table
    ---@param context_func nil|fun(context:ScribeContext):nil
    ---@return ScribeEvent
    create = function(player, position, guiname, userdata, callbacks, fields, context_func)
        --custom data
        local t = {
            player = player,
            position = position,
            guiname=guiname,
            userdata = userdata,
            callbacks = callbacks,
            fields = fields,
            context_func = context_func,
            fieldname="",
        }
        --set the metatable
        setmetatable(t, qts.scribe.event_base.__mt)
        --return new event
        return t
    end,
}

--index metamethod
qts.scribe.event_base.__mt.__index = qts.scribe.event_base

--event creation function
qts.scribe.new_event = qts.scribe.event_base.create