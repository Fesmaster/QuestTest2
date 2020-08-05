minetest.log("info", "QTS loading!")
qts = {}
qts_internal = {}
qts.path = minetest.get_modpath("qts")
qts.LIGHT_MAX = 14

dofile(qts.path.."/worldsettings.lua")
--load the QT2 Settings File
qts.settings = qts.create_settings_clojure(minetest.get_modpath("qts") .. "\\QT2Settings.conf")
dofile(qts.path.."/benchmark.lua")
dofile(qts.path.."/api/maths.lua")
dofile(qts.path.."/api/util.lua")
dofile(qts.path.."/api/creative.lua")
dofile(qts.path.."/api/player.lua")
dofile(qts.path.."/api/nodetypes.lua")
dofile(qts.path.."/api/shapedNodes.lua")
dofile(qts.path.."/api/screwdriver.lua")
dofile(qts.path.."/api/gui.lua")
dofile(qts.path.."/api/growing.lua")
dofile(qts.path.."/api/chest.lua")
dofile(qts.path.."/api/itemModifiers.lua")
dofile(qts.path.."/api/playereffects.lua")
dofile(qts.path.."/api/explosion.lua")
dofile(qts.path.."/api/collisions.lua")
dofile(qts.path.."/api/projectiles.lua")
dofile(qts.path.."/api/elements.lua")
--any other code here 



dofile(qts.path.."/worldgen/worldgen.lua")
--post worldgen files




dofile(qts.path.."/chatcommands.lua")
--dofile(qts.path.."/api/creative.lua")dofile(qts.path.."/mt_impl.lua")





