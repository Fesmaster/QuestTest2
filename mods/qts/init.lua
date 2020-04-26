minetest.log("info", "QTS loading!")
qts = {}
qts_internal = {}
qts.path = minetest.get_modpath("qts")
dofile(qts.path.."/worldsettings.lua")
--load the QT2 Settings File
qts.settings = qts.create_settings_clojure(minetest.get_modpath("qts") .. "\\QT2Settings.conf")

dofile(qts.path.."/util.lua")
dofile(qts.path.."/creative.lua")
dofile(qts.path.."/nodetypes.lua")
dofile(qts.path.."/shapedNodes.lua")
dofile(qts.path.."/screwdriver.lua")
--any other code here
dofile(qts.path.."/gui.lua")


dofile(qts.path.."/chatcommands.lua")
dofile(qts.path.."/mt_impl.lua")





