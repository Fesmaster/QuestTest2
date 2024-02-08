--[[
    Hoes

    This one is a bit unique as it has a custom function for hoes.
]]

local function Hoe_Use(itemstack, user, pointed_thing)
	if pointed_thing and pointed_thing.under then
		local node = minetest.get_node_or_nil(pointed_thing.under)
		local nodeAbove = minetest.get_node_or_nil(pointed_thing.under + vector.new(0,1,0))
		if node and node.name and nodeAbove and nodeAbove.name and nodeAbove.name == "air" then
			local underbrush = minetest.get_item_group(node.name, "underbrush")
			local pos = pointed_thing.under

            --hoe thorough underbrush
			if (underbrush ~= 0) then
				minetest.set_node(pointed_thing.under, {name="air"})
				pos = pos - vector.new(0,1,0)
				node = minetest.get_node_or_nil(pos)
			end
			
			local soilness = minetest.get_item_group(node.name, "soil")
			local loamness = minetest.get_item_group(node.name, "loam")
			if soilness ~= 0 then
				
				local param2 = 0
				if user then
					local user_pos = user:get_pos()
					if user_pos then
						param2 = minetest.dir_to_facedir(vector.subtract(pointed_thing.above, user_pos))
					end
				end
				
				minetest.swap_node(pos, {name = "overworld:dirt_tilled", param2=param2})
				
				if not (qts.is_player_creative(user)) then
					qts.apply_default_wear(itemstack, node.name)
				end
				
			elseif loamness ~= 0 then 

				local param2 = 0
				if user then
					local user_pos = user:get_pos()
					if user_pos then
						param2 = minetest.dir_to_facedir(vector.subtract(pointed_thing.above, user_pos))
					end
				end
				
				minetest.swap_node(pos, {name = "overworld:loam_tilled", param2=param2})
				
				if not (qts.is_player_creative(user)) then
					qts.apply_default_wear(itemstack, node.name)
				end
			else
				minetest.punch_node(pos)
			end
		end
	end
	return itemstack
end

minetest.register_tool("tools:hoe_rusted", {
	description = "Rusted Hoe",
	inventory_image = "tools_hoe_rusted.png",
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1},
	on_use = Hoe_Use,
	max_uses = 50,
})

--copper

minetest.register_tool("tools:hoe_copper", {
	description = "Copper Hoe",
	inventory_image = "tools_hoe_copper.png",
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1},
	on_use = Hoe_Use,
	max_uses = 50,
})

--bronze
minetest.register_tool("tools:hoe_bronze", {
	description = "Bronze Hoe",
	inventory_image = "tools_hoe_bronze.png",
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1},
	on_use = Hoe_Use,
	max_uses = 100,
})

--iron
minetest.register_tool("tools:hoe_iron", {
	description = "Iron Hoe",
	inventory_image = "tools_hoe_iron.png",
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1},
	on_use = Hoe_Use,
	max_uses = 400,
})

--steel
minetest.register_tool("tools:hoe_steel", {
	description = "Steel Hoe",
	inventory_image = "tools_hoe_steel.png",
	sound = qtcore.tool_sounds_default(),
	groups = {hoe = 1},
	on_use = Hoe_Use,
	max_uses = 600,
})