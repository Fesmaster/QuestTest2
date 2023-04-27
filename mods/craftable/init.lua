--[[
    Craftable mod

    QuestTest craftable, adds miscellaneous craftable creations, such as furnaces, etc.
]]

--misc
dofile(minetest.get_modpath("craftable").."/items.lua")
dofile(minetest.get_modpath("craftable").."/nodes.lua")
dofile(minetest.get_modpath("craftable").."/tools.lua")

--specific
dofile(minetest.get_modpath("craftable").."/book.lua")
dofile(minetest.get_modpath("craftable").."/campfire.lua")
dofile(minetest.get_modpath("craftable").."/sifter.lua")
dofile(minetest.get_modpath("craftable").."/torches.lua")

--crafting only
dofile(minetest.get_modpath("craftable").."/recipes.lua")