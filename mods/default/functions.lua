--[[
This file is for ABMs and LBMs, and the like
--]]

minetest.register_abm({
	label = "Tilled Regression",
	nodenames = {"default:dirt_tilled", "group:spreading_dirt_type"},
	interval = 1.0,
	chance = 1,
	catch_up = true,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local node_above =  minetest.get_node_or_nil(pos + vector.new(0,1,0))
		if node_above and node_above.name ~= "air" then
			local nodeDef = minetest.registered_nodes[node_above.name]
			if not (nodeDef and nodeDef.paramtype and nodeDef.paramtype == "light") then
				minetest.set_node(pos, {name="default:dirt"})
			end
		end
	end
})

minetest.register_abm({
	label = "Grass Spreading",
	nodenames = {"default:dirt"},
	neighbors = {"group:spreading_dirt_type"},
	interval = 6.0,
	chance = 15,
	catch_up = false,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local above = pos+vector.new(0,1,0)
		if minetest.get_node(above).name ~= "air" or minetest.get_node_light(above) < 7 then
			--early out if not air above.
			return
		end
		local possible_nodes = {}
		for i = -1,1 do
			for j = -1,1 do
				for k = -1,1 do
					local posd = pos + vector.new(i,j,k)
					local noded = minetest.get_node_or_nil(posd)
					if noded and noded.name then
						if minetest.get_item_group(noded.name, "spreading_dirt_type") ~= 0 then
							possible_nodes[#possible_nodes+1] = noded.name
						end
					end
					
				end
			end
		end
		if (#possible_nodes > 0) then
			minetest.log("Grass Spread")
			local n = possible_nodes[math.random(1, #possible_nodes)]
			minetest.set_node(pos, {name = n})
		end
	end
})