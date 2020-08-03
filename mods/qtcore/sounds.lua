--[[
Here live the sound data gen functions, similar to those that live in default from minetest_game
--]]



function qtcore.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "sounds_dug_node", gain = 0.5}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 1.0}
	return table
end

function qtcore.node_sound_dirt(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_gravel_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_gravel_footstep", gain = 1} --TODO: Change this one?
	table.place = table.place or
			{name = "sounds_place_node", gain = 1} --
	return table
end

function qtcore.node_sound_sand(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_sand_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_sand_footstep", gain = 1} --TODO: Change this one?
	table.place = table.place or
			{name = "sounds_place_node", gain = 1} --
	return table
end

function qtcore.node_sound_grass(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_grass_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_grass_footstep", gain = 1} --TODO: Change this one?
	table.place = table.place or
			{name = "sounds_place_node", gain = 1} --
	return table
end

function qtcore.node_sound_stone(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_hard_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_dug_node", gain = 0.5}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 1} --
	return table
end

function qtcore.node_sound_wood(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_wood_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_dug_node", gain = 0.5}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 1} --
	return table
end

function qtcore.node_sound_metal(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_metal_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_dug_metal", gain = 0.1}
	table.place = table.place or
			{name = "sounds_dug_metal", gain = 1} --
	return table
end

function qtcore.node_sound_glass(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_glass_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "sounds_dug_glass", gain = 0.5}
	table.place = table.place or
			{name = "sounds_place_node_hard", gain = 1} --
	return table
end


function qtcore.node_sound_water(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "sounds_water_footstep", gain = 0.5}
	return table
end

function qtcore.tool_sounds_default(table)
	table = table or {}
	table.breaks = table.breaks or {name = "default_tool_breaks", gain = 1.0}
	return table
end