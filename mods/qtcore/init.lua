--[[
	This mod contains any API and functions that are content-specific
	
	for example, sound-generator functions
	or nodebox generator functions
	
	they are not part of the content-agnostic QuestTest Sytem (qts)
	and thus do not belong in that mod
--]]
qtcore = {}
dofile(minetest.get_modpath("qtcore").."\\sounds.lua")
dofile(minetest.get_modpath("qtcore").."\\nodeboxes.lua")
dofile(minetest.get_modpath("qtcore").."\\textures.lua")