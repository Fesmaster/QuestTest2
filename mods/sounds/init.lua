--[[
This mod exists only to have all the standard game sounds reside in a mod other than default or qts.

Here live the sound data gen functions, similar to those that live in default from minetest_game

Note: some sounds have been preserved from minetest_game. They are all the files with the name beginning with default_
instead of sounds_
This is to clarify which were copied
TODO: their license info
--]]

sounds = {}

function sounds.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "default_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "default_place_node_hard", gain = 1.0}
	return table
end

function sounds.node_sound_dirt(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_gravel_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_gravel_footstep", gain = 0.5} --TODO: Change this one?
	table.place = table.place or
			{name = "default_place_node", gain = 0.5} --
	return table
end

function sounds.node_sound_grass(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_grass_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_grass_footstep", gain = 0.5} --TODO: Change this one?
	table.place = table.place or
			{name = "default_place_node", gain = 0.5} --
	return table
end

function sounds.node_sound_stone(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_hard_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "default_dug_node", gain = 0.25} --TODO: Change this one?
	table.place = table.place or
			{name = "default_place_node_hard", gain = 0.5} --
	return table
end
