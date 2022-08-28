--[[
	This file is responsible for creative mode changes and checking if the player is in creative.
]]

minetest.register_privilege("creative", {
	description = "Creative Mode (as a priv!)",
	give_to_singleplayer = false,
	give_to_admin = false,
})

local creative_mode_cache = minetest.settings:get_bool("creative_mode")

--[[
	Check if a player is in creative  

	Params:  
		playername - the player or the player name  
	
	Return:
		boolean, true if the player is in creative, false otherwise.  
]]
function qts.is_player_creative(playername)
	return creative_mode_cache or minetest.check_player_privs(playername, {creative = true})
end

--register the hand (both creative and not)
if creative_mode_cache then
	local digtime = 42
	local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 256}
	
	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = vector.new(1,1,2.5),
		range = 10.0,
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level = 0,
			groupcaps = {
				crumbly = caps,
				cracky  = caps,
				snappy  = caps,
				choppy  = caps,
				oddly_breakable_by_hand = caps,
				-- dig_immediate group doesn't use value 1. Value 3 is instant dig
				dig_immediate = {times = {[2] = digtime, [3] = 0}, uses = 0, maxlevel = 256},
			},
			damage_groups = {fleshy=1},
		}
	}) 
else
	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = vector.new(1,1,2.5),
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level = 0,
			groupcaps = {
				crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
				snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
				oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3},
			},
			damage_groups = {fleshy=1},
		}
	}) 
end


--handle unlimited node placement
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
	if placer and placer:is_player() then
		return qts.is_player_creative(placer:get_player_name())
	end
end)

local old_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
	--pass along to the old func
	if not digger or not digger:is_player() or
			not qts.is_player_creative(digger:get_player_name()) then
		return old_handle_node_drops(pos, drops, digger)
	end
	local inv = digger:get_inventory()
	if inv then
		for i, item in ipairs(drops) do
			if not inv:contains_item("main", item, true) then
				inv:add_item("main", item)
			end
		end
	end
end