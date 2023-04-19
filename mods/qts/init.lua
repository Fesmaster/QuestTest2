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

dofile(qts.path.."/customversions.lua")
dofile(qts.path.."/worldsettings.lua")
--load the QT2 Settings File

--setup some constants
--qts.world_settings. 

qts.LEAFDECAY_RADIUS = qts.config("LEAFDECAY_RADIUS", 4, "leafdecay radius for leaves") --qts.settings.get_num("LEAFDECAY_RADIUS") or 4
--qts.settings.set_num("LEAFDECAY_RADIUS", qts.LEAFDECAY_RADIUS)

qts.DEFAULT_HP=qts.config("DEFAULT_HP", 20, "default health for player", {loadtime=true})
--qts.settings.set_num("DEFAULT_HP", qts.DEFAULT_HP)

qts.LEVEL_MULTIPLIER = qts.config("LEVEL_MULTIPLIER", 0.2, "default level power multiplier") --five levels for 2x effect

dofile(qts.path.."/benchmark.lua")

dofile(qts.path.."/api/maths.lua") --non-vector math
dofile(qts.path.."/api/util.lua")
dofile(qts.path.."/api/vector.lua") --vector math

dofile(qts.path.."/api/callbacks.lua")
dofile(qts.path.."/api/creative.lua")
dofile(qts.path.."/api/player.lua")
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





