
--[[
	on_ignite(pos, igniter)
	
	node callback for when a node it lit, either by natural sources or a tinderbox
]]



minetest.register_tool("default:tinderbox", {
	description = "Tinderbox",
	inventory_image = "default_tinder_box.png",
	sound = qtcore.tool_sounds_default(),
	groups = {tinderbox = 1},
	on_use = function(itemstack, user, pointed_thing)
		local sound_pos = pointed_thing.above or user:get_pos()
		minetest.sound_play(
			"tinderbox",
			{pos = sound_pos, gain = 1, max_hear_distance = 8},
			true
		)
		
		if (pointed_thing.type == "node") then
			local inv = user:get_inventory()
			local removed = inv:remove_item("main", "default:tinder 1")
			if (ItemStack(removed):is_empty()) then return end
			
			local under = minetest.get_node(pointed_thing.under)
			local underdef = minetest.registered_nodes[under.name]
			if (underdef and underdef.on_ignite) then
				underdef.on_ignite(pointed_thing.under, user)
			else
				minetest.log("SORRY! FIRE NOT IMPLEMENTED YET")
				--TODO:Implement Fire
			end
		end
		
	end
})