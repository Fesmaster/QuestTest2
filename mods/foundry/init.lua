--[[
	FOUNDRY MOD
--]]
--do all the other stuff first
foundry = {}
local fpath = minetest.get_modpath("foundry")
dofile( fpath.."\\gui.lua")
dofile( fpath.."\\functions.lua")
dofile( fpath.."\\registers.lua")
dofile( fpath.."\\metals.lua")

--[[
Main Foundry Content (ie, the controller and its logic)
--]]

minetest.register_node("foundry:foundry_inactive", {
	description = "Foundry Controller",
	tiles = {"foundry_scorched_brick.png", "foundry_scorched_brick.png", 
		"foundry_scorched_brick.png", "foundry_scorched_brick.png", 
		"foundry_scorched_brick.png", "foundry_smelter_inactive.png"},
	paramtype2 = "facedir",
	groups = {cracky=3, foundry_controller = 1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local lvl = foundry.is_foundry(pos, true)
		if lvl then
			local node = minetest.get_node(pos)
			node.name = "foundry:foundry_active"
			minetest.set_node(pos, node)
			foundry.make_foundry(pos, lvl)
			foundry.log_foundry(pos, lvl)
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local lvl = foundry.is_foundry(pos, true)
		if lvl then
			local node = minetest.get_node(pos)
			node.name = "foundry:foundry_active"
			minetest.set_node(pos, node)
			foundry.make_foundry(pos, lvl)
			foundry.log_foundry(pos, lvl)
		end
	end,
	
	--TODO: add GUI stuff
})

minetest.register_node("foundry:foundry_active", {
	description = "Foundry Controller (Active)",
	tiles = {"foundry_scorched_brick.png", "foundry_scorched_brick.png", 
		"foundry_scorched_brick.png", "foundry_scorched_brick.png", 
		"foundry_scorched_brick.png", "foundry_smelter_active.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	drop = "foundry:foundry_inactive",
	groups = {cracky=3, foundry_controller = 1, not_in_creative_inventory = 1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	
	on_construct = function(pos)
		foundry.InitFoundry(pos)
		--this makes the metadata
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Foundry")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*6)
		minetest.log("inv of node "..minetest.pos_to_string(pos).." should be made")
		minetest.get_node_timer(pos):start(1.0)
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local lvl = foundry.is_foundry(pos, true)
		local lvl2 = foundry.is_foundry(pos, false)
		minetest.log(dump(lvl))
		if lvl == false then
			local node = minetest.get_node(pos)
			node.name = "foundry:foundry_inactive"
			minetest.set_node(pos, node)
			foundry.worldfoundries[minetest.hash_node_position(pos)] = nil --unlog the foundry
		else
			--if there is a difference in the levels
			if lvl ~= lvl2 then
				foundry.make_foundry(pos, lvl)
				foundry.log_foundry(pos, lvl)
			end
			--load the GUI
			qts.gui.show_gui(pos, clicker, "foundry")
		end
	end,
		
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		--TODO: disallow this?
		--local meta = minetest.get_meta(pos)
		--local inv = meta:get_inventory()
		--local stack = inv:get_stack(from_list, from_index)
		return 0
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local s = inv:get_stack(listname, index)
		if s:get_count() == 0 then
			return 1
		else
			return 0
		end
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local t = minetest.get_node_timer(pos)
		if not t:is_started() then
			t:start(1.0)
		end
		--qts.gui.show_gui(pos, player, "foundry")
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local t = minetest.get_node_timer(pos)
		if not t:is_started() then
			t:start(1.0)
		end
		--qts.gui.show_gui(pos, player, "foundry")
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		--qts.gui.show_gui(pos, player, "foundry")
	end,
	
	on_timer = function(pos, elapsed)
		--timer func. update the ticking of things melting and burning
		local FD = foundry.GetFoundryData(pos)
		if not FD then return false end
		FD:tick_smelt_percent(elapsed)
		FD:update_crucible()
		
		--update the infotext
		--local max = FD:get_max_metal()
		--
		--local it = "Heat: " .. tostring(FD.heat) .. 
		--	"\nMetal: "..tostring(FD.metalLVL/max*100)..
		--	" (" .. tostring(FD.metalLVL) .. 
		--	"/"..tostring(max) .. ")"
		
		FD:apply() --does this somehow invalidate the meta?
		--minetest.log("INFOTEXT: "..it)
		--local meta = minetest:get_meta(pos)
		--meta:set_string("infotext", "foundry lol")
		
		--minetest.log("foundry timer!")
		return true--so it auto restarts
	end,
	
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		local FD = foundry.GetFoundryData(pos)
		if not FD then return inv:is_empty("main") end
		return inv:is_empty("main") and FD:is_empty()
	end,
})

minetest.register_lbm({
	name = "foundry:log_foundries",
	nodenames = {"foundry:foundry_active", "foundry:foundry_inactive"},
	run_at_every_load = true,
	action = function(pos, node)
		local lvl = foundry.is_foundry(pos, true)
		if lvl then
			minetest.log("Foundry logged")
			node.name = "foundry:foundry_active"
			minetest.swap_node(pos, node)
			foundry.make_foundry(pos, lvl)
			foundry.log_foundry(pos, lvl)
		end
	end,
})