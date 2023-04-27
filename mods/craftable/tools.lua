--[[
    Miscellanious craftable tools
]]

minetest.register_tool("craftable:tinderbox", {
	description = "Tinderbox",
	inventory_image = "default_tinder_box.png",
	sound = qtcore.tool_sounds_default(),
	groups = {tinderbox = 1},
	on_use = function(itemstack, user, pointed_thing)
		
		if (pointed_thing.type == "node") then
			--remove item from inv
			local inv = user:get_inventory()
			local removed = inv:remove_item("main", "craftable:tinder 1")
			if (ItemStack(removed):is_empty()) then return end
		
			qts.ignite(pointed_thing.under)
		end
	end
})