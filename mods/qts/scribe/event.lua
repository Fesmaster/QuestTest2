--[[
    Scribe Event
    This type is passed to callback functions.

]]

---@class ScribeEvent
---@field player Player the player
---@field position Vector the position referenced
---@field name string the form name
---@field userdata table arbitrary data that is available at event-time and at regen-time
---@field fields table global callback fields from the form
---@field context_func nil|ScribeContextFunction function to fill context with data.
---@field callbacks nil|table<string,fun(event:ScribeEvent):nil> New callback functions, if regenerated
---@field needs_refresh boolean|nil set to true to cause the GUI to automatically refresh after all events handled.
---@field needs_close boolean|nil set to true to cause the GUI to automatically close after all events handled.
qts.scribe.event_base = {
    --metatable
    __mt = {},

    ---Regenerate the GUI. Completely replaces the callback function list.
    ---You should always return right after calling this
    ---@param self ScribeEvent
    refresh_gui = function(self)
        if self.context_func then
            local context = qts.scribe.new_context(self.player, self.position, self.name)
            context.userdata = self.userdata --copy userdata ref
            self.context_func(context)
            self.callbacks = context.callbacks
            context:show_gui()
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
        minetest.close_formspec(self.player:get_player_name(), self.name)
    end,

    ---Mark the GUI for close when all events handled.
    ---@param self ScribeEvent
    mark_for_close = function(self)
        self.needs_close = true
    end,


    ---Create a new ScribeEvent
    ---@param player Player
    ---@param position Vector
    ---@param name string
    ---@param userdata table
    ---@param fields table
    ---@param context_func nil|fun(context:ScribeContext):nil
    ---@return ScribeEvent
    create = function(player, position, name, userdata, fields, context_func)
        --custom data
        local t = {
            player = player,
            position = position,
            name=name,
            userdata = userdata,
            fields = fields,
            context_func = context_func,
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