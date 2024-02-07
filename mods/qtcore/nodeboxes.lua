--[[
This file contains functions that return nodeboxes, 
a handy thing to have if you are registering many nodes with the same shape
--]]

--standard leveled nodebox functions
local levels = {-3/8, -1/4, -1/8, 0, 1/8, 1/5, 3/8}
for i= 1,7 do
	qtcore["nb_level"..i] = function()
		return {
			type = "fixed",
			fixed = {
				{-1/2, -1/2, -1/2, 1/2, levels[i], 1/2},
			}
		}
	end
end

qtcore.nb_bottle = function()
	return {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, -0.4375, 0.125},
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.1875, 0.1875},
			{-0.125, -0.1875, -0.125, 0.125, 0, 0.125},
			{-0.0625, 0, -0.0625, 0.0625, 0.25, 0.0625},
			{-0.125, 0.25, -0.125, 0.125, 0.3125, 0.125},
		}
	}
end

qtcore.nb_chest = function()
	return {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.375, 0.4375, 0.0625, 0.4375},
			{-0.0625, -0.1875, -0.4375, 0.0625, 0.125, -0.25},
		}
	}
end

qtcore.nb_lantern_fruit = function()
	return {
		type = "fixed",
		fixed = {
			{-0.1875, -0.4375, -0.1875, 0.1875, 0.125, 0.1875},
			{-0.125, -0.5, -0.125, 0.125, -0.4375, 0.125},
			{-0.125, 0.125, -0.125, 0.125, 0.3125, 0.125},
			{-0.03125, 0.3125, -0.03125, 0.03125, 0.5, 0.03125},
		}
	}
end

qtcore.nb_sapling = function()
	return {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.1875, 0.0625},
			{-0.25, -0.125, -0.25, 0.25, 0.4375, 0.25},
			{-0.3125, 0.25, -0.3125, -0.0625, 0.5, -0.0624999},
			{0.0625, 0.125, -0.25, 0.3125, 0.375, 7.45058e-008},
			{-0.25, -0.0625, 0.0625, 1.49012e-008, 0.1875, 0.3125},
		}
	}
end

qtcore.nb_dustpile = function()
	return {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -5/16, 3/16, -7/16, 5/16, },
			{ -2/16, -7/16, -4/16, 2/16, -6/16, 4/16, },
			{ -1/16, -6/16, -3/16, 1/16, -5/16, 3/16, },
			{ -2/16, -8/16, -6/16, 2/16, -7/16, 6/16, },
		}
	}
end

qtcore.nb_dustpile_selection = function()
	return {
		type = "fixed",
		fixed = {
			{ -3/16, -8/16, -6/16, 3/16, -5/16, 6/16, },
		}
	}
end