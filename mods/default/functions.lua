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
			local n = possible_nodes[math.random(1, #possible_nodes)]
			minetest.set_node(pos, {name = n})
		end
	end
})

minetest.register_abm({
	label = "Reed Growth",
	nodenames = {"group:reeds"},
	neighbors = {"group:soil", "group:water"},
	interval = 3.0,
	chance = 5,
	catch_up = false,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--check the height of the reeds
		local suffix = string.sub(node.name, -1)
		local sfx = {s=1, ["2"]=2, ["3"]=3, ["4"]=4}
		local level = sfx[suffix]
		--early out if the reeds cannot grow
		if level >= 4 then 
			return 
		end
		
		local grow = false
		
		--check for water.
		local offs = {vector.new(1,-1,0), vector.new(-1,-1,0), vector.new(0,-1,1), vector.new(0,-1,-1) }
		for i, vec in ipairs(offs) do
			local qnode = minetest.get_node_or_nil(pos + vec)
			if qnode and qnode.name and minetest.get_item_group(qnode.name, "water") ~= 0 then
				grow = true
			end
		end
		if not grow then 
			return 
		end
		
		--check for air.
		for i = 1, level do
			local qnode = minetest.get_node_or_nil(pos + vector.new(0,i,0))
			if qnode and qnode.name and qnode.name ~= "air" then
				return --there was air
			end
		end
		
		if minetest.get_node_light(pos) < 7 then
			return
		end
		
		minetest.swap_node(pos, {name = "default:reeds_" .. (level+1) })
	end
})