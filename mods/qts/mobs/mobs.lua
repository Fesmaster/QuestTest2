--[[
	Mobs code.
	
	This section of QTS contains a bunch of functionality for the creation of 
	npcs (mobs), be they good or bad.
--]] 

--Creature and Entity related functions
qts.ai = {}

--the distance a mob can be from a player to enact melee damage
--special config Must be a number, so its loadtime only.
qts.ai.MELEE_RADIUS = qts.config("MELEE_RADIUS", 1.5, "mob melee radius", {loadtime=true}).get()

--the distance a mob can be from a player to enact melee damage, squared, for faster checks without sqrt
qts.ai.MELEE_RADIUS_SQ = qts.ai.MELEE_RADIUS * qts.ai.MELEE_RADIUS

--list of creatures that have been registered
qts.registered_creatures = {}

--list of modules that have been registered
qts.registered_modules = {}

---list of registered spawn configurations
qts.registered_spawner_configs = {}

--[[
DOFILES
-]]
dofile(qts.path.."/mobs/util.lua")
dofile(qts.path.."/mobs/movement.lua")
dofile(qts.path.."/mobs/spawner.lua")
dofile(qts.path.."/mobs/behavior.lua")

