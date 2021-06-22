--[[
	This mod contains any API and functions that are content-specific
	
	for example, sound-generator functions
	or nodebox generator functions
	
	they are not part of the content-agnostic QuestTest System (qts)
	and thus do not belong in that mod

--]]
qtcore = {}
dofile(minetest.get_modpath("qtcore").."/sounds.lua")
dofile(minetest.get_modpath("qtcore").."/nodeboxes.lua")
dofile(minetest.get_modpath("qtcore").."/textures.lua")
dofile(minetest.get_modpath("qtcore").."/forms.lua")
dofile(minetest.get_modpath("qtcore").."/trees.lua")
dofile(minetest.get_modpath("qtcore").."/deconodes.lua")
--[[
Random functions are placed here
--]]

qtcore.place_random_plantlike = function(itemstack, placer, pointed_thing)
	return minetest.item_place(itemstack, placer, pointed_thing, (
		math.random(0,4)			--first 3 bits (0,1,2)
		+ (math.random(0,1) * 8)    --bit 3
		+ (math.random(0,1) * 16)   --bit 4
		+ (math.random(0,1) * 32))  --bit 5
	)
end


--[[
leaves use param2 to hold if they were placed by the player
to allow player-placed leaves to not decay
--]]
qtcore.after_place_leaves = function(pos, placer, itemstack, pointed_thing)
	if not qts.world_settings.get_bool("natLeaves") then
		if placer and placer:is_player() then
			local node = minetest.get_node(pos)
			node.param2 = 1
			minetest.set_node(pos, node)
		end
	end
end

qtcore.get_random_meshdata = function()
	return (math.random(0,4)			--first 3 bits (0,1,2)
		+ (math.random(0,1) * 8)    --bit 3
		+ (math.random(0,1) * 16)   --bit 4
		+ (math.random(0,1) * 32))  --bit 5
end

