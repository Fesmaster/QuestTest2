--[[
This file contains functions that return nodeboxes, 
a handy thing to have if you are registering many nodes with the same shape
--]]

--standard leveled nodebox functions
local levels = {-3/8, -1/4, -1/8, 0, 1/8, 1/5, 3/8}
for i= 1,7 do
	qtcore["nb_level"..i] = function()
		return{
			type = "fixed",
			fixed = {
				{-1/2, -1/2, -1/2, 1/2, levels[i], 1/2}, -- NodeBox1
			}
		}
	end
end

qtcore.nb_bottle = function()
	return{
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, -0.4375, 0.125}, -- NodeBox1
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.1875, 0.1875}, -- NodeBox2
			{-0.125, -0.1875, -0.125, 0.125, 0, 0.125}, -- NodeBox3
			{-0.0625, 0, -0.0625, 0.0625, 0.25, 0.0625}, -- NodeBox4
			{-0.125, 0.25, -0.125, 0.125, 0.3125, 0.125}, -- NodeBox5
		}
	}
end

qtcore.nb_chest = function()
	return{
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.375, 0.4375, 0.0625, 0.4375}, -- NodeBox33
			{-0.0625, -0.1875, -0.4375, 0.0625, 0.125, -0.25}, -- NodeBox34
		}
	}
end