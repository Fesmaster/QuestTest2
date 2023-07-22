--[[
Paintbrushes

pindex colors
0=none, 1=red, 2=yellow, 3=green, 4=blue, 5=purple, 6=pink, 7=gray
--]]

minetest.register_tool("tools:paintbrush", {
	description = "Paintbrush",
	inventory_image = "tools_paintbrush.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("Paintbrush Used")
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				--[[local pindex = node.param2 / 32
				pindex = pindex + 1]]--
				pindex = 0
				while(pindex >= 8) do pindex = pindex - 8 end
				--if (pindex >= 8) then pindex = 0 end
				node.param2 = pindex * 32
				minetest.set_node(pointed_thing.under, node)
			end
		end
	end,
})

--[[	
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("Paintbrush Placed")
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				local pindex = node.param2 / 32
				pindex = pindex - 1
				while(pindex <= -1) do pindex = pindex + 8 end
				--if (pindex <= -1) then pindex = 7 end
				node.param2 = pindex * 32
				minetest.set_node(pointed_thing.under, node)
			end
		end
	end,
	]]--