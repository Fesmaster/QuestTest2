minetest.log("info", "QTS loading!")
qts = {}
qts_internal = {}
qts.path = minetest.get_modpath("qts")
qts.LIGHT_MAX = 14
qts.WEAR_MAX = 65535

--default stack max changes.
minetest.nodedef_default.stack_max = 999
minetest.craftitemdef_default.stack_max = 999
minetest.noneitemdef_default.stack_max = 999

dofile(qts.path.."/worldsettings.lua")
--load the QT2 Settings File
qts.settings = qts.create_settings_clojure(minetest.get_modpath("qts") .. "/QT2Settings.conf")
--setup some constants
--qts.world_settings.
qts.LEAFDECAY_RADIUS = qts.settings.get_num("LEAFDECAY_RADIUS") or 4
qts.settings.set_num("LEAFDECAY_RADIUS", qts.LEAFDECAY_RADIUS)

qts.DEFAULT_HP=qts.settings.get_num("DEFAULT_HP") or 20
qts.settings.set_num("DEFAULT_HP", qts.DEFAULT_HP)

qts.LEVEL_MULTIPLIER = qts.world_settings.get_num("LEVEL_MULTIPLIER") or 0.2 --five levels for 2x effect

dofile(qts.path.."/benchmark.lua")

dofile(qts.path.."/api/maths.lua") --non-vector math
dofile(qts.path.."/api/util.lua")
dofile(qts.path.."/api/vector.lua") --vector math

dofile(qts.path.."/api/creative.lua")
dofile(qts.path.."/api/player.lua")
dofile(qts.path.."/api/callbacks.lua")
dofile(qts.path.."/api/nodetypes.lua")
dofile(qts.path.."/api/shapedNodes.lua")
dofile(qts.path.."/api/screwdriver.lua")
dofile(qts.path.."/api/doors.lua")
dofile(qts.path.."/api/gui.lua")
dofile(qts.path.."/api/growing.lua")
dofile(qts.path.."/api/chest.lua")
dofile(qts.path.."/api/itemModifiers.lua")
dofile(qts.path.."/api/playerModifiers.lua")
dofile(qts.path.."/api/explosion.lua")
dofile(qts.path.."/api/projectiles.lua")
dofile(qts.path.."/api/elements.lua")
dofile(qts.path.."/api/erosion.lua")
--any other code here 
dofile(qts.path.."/crafting/crafting.lua")

dofile(qts.path.."/mobs/mobs.lua")

dofile(qts.path.."/worldgen/worldgen.lua")
--post worldgen files




dofile(qts.path.."/chatcommands.lua")
--dofile(qts.path.."/api/creative.lua")dofile(qts.path.."/mt_impl.lua")





