
--create trash can
local trash = minetest.create_detached_inventory("trash", {
	-- Allow the stack to be placed and remove it in on_put()
	-- This allows the creative inventory to restore the stack
	allow_put = function(inv, listname, index, stack, player)
		if type(player) ~= "string" then player = player:get_player_name() end
		if qts.isCreativeFor(player) then
			return stack:get_count()
		else
			return 0
		end
	end,
	on_put = function(inv, listname)
		inv:set_list(listname, {})
	end,
})
trash:set_size("main", 1)