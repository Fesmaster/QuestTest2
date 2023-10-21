--[[
    init for the async threads
]]

--since external globals are not available here, re-register them
qts = {}

qts.ASYNC=true

--yep, this works
qts.path = minetest.get_modpath("qts")

qts.LIGHT_MAX = 14
qts.WEAR_MAX = 65535

dofile(qts.path.."/customversions.lua")
--dofile(qts.path.."/worldsettings.lua")
--dofile(qts.path.."/benchmark.lua")
dofile(qts.path.."/api/maths.lua") --non-vector math
dofile(qts.path.."/api/util.lua")
dofile(qts.path.."/api/vector.lua") --vector math
--dofile(qts.path.."/api/callbacks.lua")
--dofile(qts.path.."/api/creative.lua")
--dofile(qts.path.."/api/player.lua")
--dofile(qts.path.."/api/nodetypes.lua")
--dofile(qts.path.."/api/shapedNodes.lua")
--dofile(qts.path.."/api/doors.lua")
--dofile(qts.path.."/scribe/scribe.lua")
--dofile(qts.path.."/api/growing.lua")
--dofile(qts.path.."/api/chest.lua")
--dofile(qts.path.."/api/itemModifiers.lua")
--dofile(qts.path.."/api/playerModifiers.lua")
--dofile(qts.path.."/api/explosion.lua")
--dofile(qts.path.."/api/projectiles.lua")
--dofile(qts.path.."/api/elements.lua")
--dofile(qts.path.."/api/erosion.lua")
--dofile(qts.path.."/crafting/crafting.lua")
--dofile(qts.path.."/mobs/mobs.lua")
--dofile(qts.path.."/worldgen/worldgen.lua")
--dofile(qts.path.."/chatcommands.lua")