--[[
    Scribe

    Scribe is a GUI frontent for Formspec. Its purpose is to generate formspec code.
]]

qts.scribe = {}

dofile(qts.path.."/scribe/gui.lua")

dofile(qts.path.."/scribe/vec2.lua")
dofile(qts.path.."/scribe/enums.lua")

dofile(qts.path.."/scribe/event.lua")
dofile(qts.path.."/scribe/context.lua")