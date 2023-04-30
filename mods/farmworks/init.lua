--[[
    Farmworks mod

    Farmworks is QuestTest's mod that creats farmable plants, as well as the farming mechanics.

    This does not include hoes or tilled soil, which come from Tools and the respective world layer, respectively.
]]

---@diagnostic disable-next-line: lowercase-global
farmworks = {}

dofile(minetest.get_modpath("farmworks").."/api.lua")
dofile(minetest.get_modpath("farmworks").."/plants.lua")
dofile(minetest.get_modpath("farmworks").."/craftitems.lua")