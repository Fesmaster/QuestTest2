--[[
    Initial Items for the player
]]

local inital_items = {}

function qtcore.add_initial_item(itemname)
    inital_items[#inital_items+1] = itemname
end

minetest.register_on_newplayer(function(player)
	minetest.log("action","Giving initial items to player: " .. player:get_player_name())
	local inv = player:get_inventory()
	for _, stack in ipairs(inital_items) do
		inv:add_item("main", stack)
	end
end)