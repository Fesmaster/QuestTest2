--[[
Paintbrushes

pindex colors
0=none, 1=red, 2=yellow, 3=green, 4=blue, 5=purple, 6=pink, 7=gray
--]]

--[[
minetest.register_tool("tools:paintbrush", {
	description = "Paintbrush",
	inventory_image = "tools_paintbrush.png",
	range = 10.0,
})



	for colorstr, colorvalue in pairs(qtcore.colors) do
	local desc = qtcore.string_first_to_upper(colorstr)

	--dyes
	minetest.register_node("craftable:dye_"..colorstr, {
]]--
local dye_values = {0,1,2,3,4,5,6,7}
local dye_names = {"none","red","yellow","green","blue","purple","pink","gray"}
minetest.register_tool("tools:paintbrush_", {
	description = "Paintbrush",
	inventory_image = "tools_paintbrush.png",
	range = 10.0,
	on_use = function(itemstack, user, pointed_thing)
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				minetest.log("if1")
				local wield_index = user:get_wield_index()
				local wield_list = user:get_wield_list()
				local dye_index = 0
    		   	local dye_item = nil
				local inv = user:get_inventory()
    		   	if inv then
					minetest.log("if2")
	     	      	local list = inv:get_list(wield_list)
    		       	for i=wield_index+1,inv:get_size(wield_list) do
    		  			local item = list[i]
						for colorstr, colorvalue in pairs(qtcore.colors) do
							minetest.log(colorvalue)
							minetest.log("craftable:dye_"..colorstr)
    		          		if minetest.get_item_group(item:get_name(), "craftable:dye_"..colorstr) ~= 0 then
								minetest.log("dye found")
    	 	            	 --we found our dye
    		            	   dye_index = i
    		            	   dye_item = item
    		            	   break
    		           		end
						end
    		       	end
				
    		       	if (dye_item) then
						minetest.log("dye taken")
    		            local taken_dye = dye_item:take_item(1)
    		           --don't actually set the stack back if the player is in creative
    		           	if not qts.is_player_creative(user:get_player_name()) then
							minetest.log("not creative")
    		               inv:set_stack(wield_list, dye_index, dye_item)
    	   	        	end
						for colorstr, colorvalue in pairs(qtcore.colors) do
							for dyestr in pairs(dye_names) do
								if colorstr == dyestr then
									minetest.log("should paint it")
									for i=1, #dye_names do
										minetest.log("Paintbrush Used")
										local pindex = node.param2 / 32
										pindex = dye_values(dyenum)
										node.param2 = pindex * 32
										minetest.set_node(pointed_thing.under, node)
									end
									break
								end
							end
						end
    	    		end
				end
			end
		end
	end
})

