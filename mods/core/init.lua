--[[
	This mod contains any API and functions that are content-specific
	
	for example, sound-generator functions
	or nodebox generator functions
	
	they are not part of the content-agnostic QuestTest Sytem (qts)
	and thus do not belong in that mod
--]]
core = {}
dofile(minetest.get_modpath("core").."\\sounds.lua")
dofile(minetest.get_modpath("core").."\\nodeboxes.lua")
