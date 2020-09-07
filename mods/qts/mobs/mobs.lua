--[[
	Mobs code.
	
	This section of QTS contains a bunch of functionality for the creation of 
	npcs (mobs), be they good or bad.
--]] 

qts.ai = {}

qts.registered_creatures = {}
qts.registered_behaviors = {}

--[[
DOFILES
-]]
dofile(qts.path.."/mobs/util.lua")
dofile(qts.path.."/mobs/movement.lua")
dofile(qts.path.."/mobs/behavior.lua")

