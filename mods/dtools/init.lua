--[[
QuestTest Development Tools

This mod does nothing outside of dev mode
It mod contains tools and the like used to 
make and analize during QuestTest development
]]

if qts.ISDEV then
local path = minetest.get_modpath("dtools")
dofile(path.."\\chatcommands.lua")
dofile(path.."\\tools.lua")
dofile(path.."\\schematics.lua")

dofile(path.."\\other.lua")
end