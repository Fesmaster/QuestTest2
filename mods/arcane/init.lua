--[[
	This mod contains most of the arcane and magical stuff in QuestTest2
--]]


minetest.register_node("arcane:disollving_stone", {
	description = "Stone",
	tiles = {"default_stone.png^arcane_magic_outline.png"},
	groups = {magic=1, cracky=1},
	sounds = qtcore.node_sound_stone(),
	drop = "default:stone_cobble",
	light_source = 9,
})

minetest.register_abm({
	label = "StoneDissolving",
	nodenames = {"arcane:disollving_stone"},
	--neighbors = {"group:stone"},
	interval = 1,
	chance = 3,
	catch_up = false,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local p2 = node.param2
		if (p2 > 0) then
			for x = -1,1 do
			for y = -1,1 do
			for z = -1,1 do
				local poff = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local node = minetest.get_node(poff)
				if (minetest.get_item_group(node.name, "stone") > 0 and 
						minetest.get_item_group(node.name, "ore") == 0) then
					minetest.set_node(poff, {name="arcane:disollving_stone", param2=p2-1})
				end
			end
			end
			end
		end
		minetest.set_node(pos, {name="air"})
	end,
})

minetest.register_node("arcane:miner_unit", {
	description = "Arcane Miner Unit",
	tiles = {
		"arcane_miner_top.png",
		"arcane_miner_top.png",
		"arcane_miner_side.png",
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "wallmounted",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, -0.3125, -0.25, -0.3125}, -- Leg1
			{0.3125, -0.5, -0.4375, 0.4375, -0.25, -0.3125}, -- Leg2
			{0.3125, -0.5, 0.3125, 0.4375, -0.25, 0.4375}, -- Leg3
			{-0.4375, -0.5, 0.3125, -0.3125, -0.25, 0.4375}, -- Leg4
			{-0.375, -0.25, -0.375, -0.1875, -0.125, 0.375}, -- Bar1
			{0.1875, -0.25, -0.375, 0.375, -0.125, 0.375}, -- Bar2
			{-0.1875, -0.25, 0.1875, 0.1875, -0.125, 0.375}, -- Bar3
			{-0.1875, -0.25, -0.375, 0.1875, -0.125, -0.1875}, -- Bar4
			{-0.125, -0.0625, -0.125, 0.125, 0.3125, 0.125}, -- Core
			{-0.25, -0.125, -0.25, -0.125, 0.375, -0.125}, -- Col1
			{0.125, -0.125, -0.25, 0.25, 0.375, -0.125}, -- Col2
			{0.125, -0.125, 0.125, 0.25, 0.375, 0.25}, -- Col3
			{-0.25, -0.125, 0.125, -0.125, 0.375, 0.25}, -- Col4
		}
	},
	groups = {cracky=3,oddly_breakable_by_hand=3},
})
