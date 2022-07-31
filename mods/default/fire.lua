
--[[
	on_ignite(pos, igniter)
	
	node callback for when a node it lit, either by natural sources or a tinderbox
]]

--from the fire mod, cause it works really well
local fire_enabled = minetest.settings:get_bool("enable_fire")
if fire_enabled == nil then
	-- enable_fire setting not specified, check for disable_fire
	local fire_disabled = minetest.settings:get_bool("disable_fire")
	if fire_disabled == nil then
		-- Neither setting specified, check whether singleplayer
		fire_enabled = minetest.is_singleplayer()
	else
		fire_enabled = not fire_disabled
	end
end

local function fire_flood(pos, oldnode, newnode)
	minetest.sound_play("sounds_cooling_hiss",	{pos = pos, gain = 1})
	return false
end

qts.ignite = function(pos)
	--local sound_pos = pointed_thing.above or user:get_pos()
		minetest.sound_play(
			"tinderbox",
			{pos = pos, gain = 1, max_hear_distance = 8},
			true
		)
		
		local node = minetest.get_node(pos)
		local nodedef = minetest.registered_nodes[node.name]
		if (nodedef and nodedef.on_ignite) then
			nodedef.on_ignite(pos)
		else
			local p = minetest.find_node_near(pos, 1, {"air"})
			if p then
				minetest.set_node(p, {name = "default:fire"})
			end
		end
	
end


minetest.register_tool("default:tinderbox", {
	description = "Tinderbox",
	inventory_image = "default_tinder_box.png",
	sound = qtcore.tool_sounds_default(),
	groups = {tinderbox = 1},
	on_use = function(itemstack, user, pointed_thing)
		
		if (pointed_thing.type == "node") then
			--remove item from inv
			local inv = user:get_inventory()
			local removed = inv:remove_item("main", "default:tinder 1")
			if (ItemStack(removed):is_empty()) then return end
		
			qts.ignite(pointed_thing.under)
		end
	end
})

--instead of having a permanent flame node, we will use param2 to determine this

minetest.register_node("default:fire", {
	description = "Fire",
	drawtype = "firelike",
	tiles = {{
		name = "default_flame_animated.png",
		animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1}
	}},
	inventory_image = "default_flame.png",
	paramtype = "light",
	light_source = 13,
	walkable = false,
	buildable_to = true,
	sunlight_propigates = true,
	floodable = true,
	
	groups = {fire = 1, dig_immediate = 3, igniter = 2, ambient = 1, generation_replacable=1},
	drop = "",
	
	sounds = {
		ambience = {
			name = "campfire",
			spec = {gain = 10},
			chance = 1,
			playtime = 16,
			positional = true,
			loop = true,
		}
	},
	
	on_timer = function(pos)
		local node = minetest.get_node(pos)
		local under = minetest.get_node({x=pos.z, y=pos.y-1, z=pos.z})
		if (minetest.get_item_group(under.name, "infinite_burn") ~= 0) then
			if (node.param2 ~= 1) then
				node.param2 = 1
				minetest.swap_node(pos, node)
			end
		else
			if (node.param2 ~= 0) then
				node.param2 = 0
				minetest.swap_node(pos, node)
			end
		end
	
		
		local f = minetest.find_node_near(pos, 1, {"group:flammable"})
		if (not fire_enabled or not f) and node.param2 == 0 then
			minetest.remove_node(pos)
			return
		end
		-- Restart timer
		return true
	end,

	on_construct = function(pos)
		local node = minetest.get_node(pos)
		local under = minetest.get_node({x=pos.z, y=pos.y-1, z=pos.z})
		
		if (minetest.get_item_group(under.name, "infinite_burn") ~= 0) then
			node.param2 = 1
			minetest.swap_node(pos, node)
		end
		
		if (not fire_enabled )and node.param2 == 0 then
			minetest.remove_node(pos)
		else
			minetest.get_node_timer(pos):start(math.random(30, 60))
		end
	end,
	
	on_flood = fire_flood,
	
})

--
-- ABMs
-- these are modified from the fire mode in minetest_game
--

if fire_enabled then

	-- Ignite neighboring nodes, add flames
	minetest.register_abm({
		label = "Ignite flame",
		nodenames = {"group:flammable"},
		neighbors = {"group:igniter"},
		interval = 3,
		chance = 12,
		catch_up = false,
		action = function(pos)
			local p = minetest.find_node_near(pos, 1, {"air"})
			if p then
				minetest.set_node(p, {name = "default:fire"})
			end
		end,
	})

	-- Remove flammable nodes around flame
	minetest.register_abm({
		label = "Remove flammable nodes",
		nodenames = {"default:fire"},
		neighbors = "group:flammable",
		interval = 3,
		chance = 18,
		catch_up = false,
		action = function(pos)
			local p = minetest.find_node_near(pos, 1, {"group:flammable"})
			if not p then
				return
			end
			local flammable_node = minetest.get_node(p)
			local def = minetest.registered_nodes[flammable_node.name]
			if def.on_burn then
				def.on_burn(p)
			else
				if (minetest.get_item_group(flammable_node.name, "infinite_burn") == 0) then
					minetest.remove_node(p)
					minetest.check_for_falling(p)
				end
			end
		end,
	})
	
	--Same functions, but for flash flamable nodes. these burn MUCH faster
	minetest.register_abm({
		label = "Ignite flame flash",
		nodenames = {"group:flammable_flash"},
		neighbors = {"group:igniter"},
		interval = 1,
		chance = 2,
		catch_up = false,
		action = function(pos)
			local p = minetest.find_node_near(pos, 1, {"air"})
			if p then
				minetest.set_node(p, {name = "default:fire"})
			end
		end,
	})

	minetest.register_abm({
		label = "Remove flash flammable nodes",
		nodenames = {"default:fire"},
		neighbors = "group:flammable_flash",
		interval = 3,
		chance = 7,
		catch_up = false,
		action = function(pos)
			local p = minetest.find_node_near(pos, 1, {"group:flammable_flash"})
			if not p then
				return
			end
			local flammable_node = minetest.get_node(p)
			local def = minetest.registered_nodes[flammable_node.name]
			if def.on_burn then
				def.on_burn(p)
			else
				if (minetest.get_item_group(flammable_node.name, "infinite_burn") == 0) then
					minetest.remove_node(p)
					minetest.check_for_falling(p)
				end
			end
		end,
	})

end
