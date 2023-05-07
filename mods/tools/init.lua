--[[
    Tools mod

    This mod should register all generic tools and armor.
    Specalty tools, such as the tinerbox, should be registered where most logical. That may or may not be here.

    Why do these not use the qtcore materials system? each one needs its own custom tool capabilities, and thus, they are seperate.
    Sure, we could do something with a master list of capabilities and a sensible default, but that is a possible later move.
]]

dofile(minetest.get_modpath("tools").."/knives.lua")
dofile(minetest.get_modpath("tools").."/hammers.lua")
dofile(minetest.get_modpath("tools").."/pickaxes.lua")
dofile(minetest.get_modpath("tools").."/axes.lua")
dofile(minetest.get_modpath("tools").."/swords.lua")
dofile(minetest.get_modpath("tools").."/shovels.lua")
dofile(minetest.get_modpath("tools").."/hoes.lua")
dofile(minetest.get_modpath("tools").."/armor.lua")
dofile(minetest.get_modpath("tools").."/bows.lua")
dofile(minetest.get_modpath("tools").."/buckets.lua")

dofile(minetest.get_modpath("tools").."/recipes.lua")

--bucket
