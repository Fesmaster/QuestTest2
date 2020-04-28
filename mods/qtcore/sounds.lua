--[[
Here live the sound data gen functions, similar to those that live in default from minetest_game
--]]



function qtcore.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "sounds_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 1.0}
	return table
end

function qtcore.node_sound_dirt(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_gravel_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_gravel_footstep", gain = 0.5} --TODO: Change this one?
	table.place = table.place or
			{name = "sounds_place_node", gain = 0.5} --
	return table
end

function qtcore.node_sound_sand(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_sand_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_sand_footstep", gain = 0.5} --TODO: Change this one?
	table.place = table.place or
			{name = "sounds_place_node", gain = 0.5} --
	return table
end

function qtcore.node_sound_grass(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_grass_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_grass_footstep", gain = 0.5} --TODO: Change this one?
	table.place = table.place or
			{name = "sounds_place_node", gain = 0.5} --
	return table
end

function qtcore.node_sound_stone(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_hard_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 0.5} --
	return table
end

function qtcore.node_sound_wood(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_wood_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 0.5} --
	return table
end

function qtcore.node_sound_metal(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_metal_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_dug_metal", gain = 0.25}
	table.place = table.place or
			{name = "sounds_dug_metal", gain = 0.5} --
	return table
end

function qtcore.node_sound_glass(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_glass_footstep", gain = 0.25}
	table.dug = table.dug or
			{name = "sounds_dug_glass", gain = 0.25}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 0.5} --
	return table
end