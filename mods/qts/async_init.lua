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
dofile(qts.path.."/api/maths.lua") --non-vector math
dofile(qts.path.."/api/util.lua")
dofile(qts.path.."/api/vector.lua") --vector math
dofile(qts.path.."/api/async_world_access.lua") --async world access
