--[[
	Mobs code.
	
	This section of QTS contains a bunch of functionality for the creation of 
	npcs (mobs), be they good or bad.
--]] 

--Creature and Entity related functions
qts.ai = {}

--the distance a mob can be from a player to enact melee damage
qts.ai.MELEE_RADIUS = qts.settings.get_num("MELEE_RADIUS") or 1.5

--the distance a mob can be from a player to enact melee damage, squared, for faster checks without sqrt
qts.ai.MELEE_RADIUS_SQ = qts.ai.MELEE_RADIUS * qts.ai.MELEE_RADIUS

--list of creatures that have been registered
qts.registered_creatures = {}

--list of modules that have been registered
qts.registered_modules = {}

--**DEPRICATED** list of registered behaviors
qts.registered_behaviors = {}

--[[
DOFILES
-]]
dofile(qts.path.."/mobs/util.lua")
dofile(qts.path.."/mobs/movement.lua")
dofile(qts.path.."/mobs/behavior.lua")


