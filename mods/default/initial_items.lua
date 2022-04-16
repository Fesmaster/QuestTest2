
local inital_items = {"default:pick_rusted"}

minetest.register_on_newplayer(function(player)
	minetest.log("action","Giving initial items to player: " .. player:get_player_name())
	local inv = player:get_inventory()
	for _, stack in ipairs(inital_items) do
		inv:add_item("main", stack)
	end
end)
