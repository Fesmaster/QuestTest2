--[[
	This mod contains dungeons for QuestTest2.
	Dungeons are not limited to actual structures, but also features of
	worldgen, like lakes
--]]

DUNGEON_GENERATOR_GROUPS = {generator=1, oddly_breakable_by_hand=3}
if not qts.ISDEV then
	DUNGEON_GENERATOR_GROUPS.not_in_creative_inventory = 1
end

dofile(minetest.get_modpath("dungeon").."/lakes.lua")


dofile(minetest.get_modpath("dungeon").."/mapgen.lua")
