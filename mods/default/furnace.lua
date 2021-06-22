
local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
local S = function(x,y) return qts.gui.gui_makesize(x,y):get() end
local esc = minetest.formspec_escape

qts.gui.register_gui("default_furnace", {
	get = function(data, pos, name)
		local str = "size["..S(9.75,8.25).."]real_coordinates[true]"
		local spos = pos.x .. "," .. pos.y .. "," .. pos.z
		local meta = minetest.get_meta(pos)
		--Get the percentage values from the item meta, instead of constantly calculating on the fly, twice!
		local fuel_percent = meta:get_float("fuel_percent") 
		local item_percent = meta:get_float("item_percent")
		
		str = str .. "list[nodemeta:"..spos..";src;"..P(2.75,0.5)..";1,1;]"..
			"list[nodemeta:"..spos..";fuel;"..P(2.75,2.5)..";1,1;]"..
			"list[nodemeta:"..spos..";dst;"..P(4.75,0.96)..";2,2;]"..
			"image["..P(2.75,1.5)..";1,1;default_furnace_fire_bg.png^[lowpart:"..
			(fuel_percent)..":default_furnace_fire_fg.png]"..
			"image["..P(3.75,1.5)..";1,1;gui_furnace_arrow_bg.png^[lowpart:"..
			(item_percent)..":gui_furnace_arrow_fg.png^[transformR270]"..
			inventory.get_player_main(qts.gui.gui_makepos(0, 4.25), false) ..
			--liststrings
			"listring[nodemeta:"..spos..";dst]"..
			"listring[current_player;main]"..
			"listring[nodemeta:"..spos..";src]"..
			"listring[current_player;main]"..
			"listring[nodemeta:"..spos..";fuel]"..
			"listring[current_player;main]"
		
		minetest.after(0.8, function(pos, name)
			if qts.gui.get_open_gui(name) == "default_furnace" then
				qts.gui.show_gui(pos, name, "default_furnace")
			end
		end, pos, name)
		
		return str
	end,
	handle = function(data, pos, name, fields)
		return
	end,
})

--[[
minetest.register_chatcommand("ft", {
	params = "",
	description = "Furnace Test",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		qts.gui.show_gui(player:get_pos(), player, "default_furnace")
	end
})
--]]


--
--Functions that are the same for both active and inactive furnaces
--
--Note: this code is copied and edited from the default mod of minetest_game
--

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", "Furnace is empty")
			end
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end


local function furnace_node_timer(pos, elapsed)
	--
	-- Initialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist
	local dst_full = false

	local cookable, cooked
	local fuel

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		--
		-- Cooking
		--

		-- Check if we have cookable content
		local aftercooked
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0

		local el = math.min(elapsed, fuel_totaltime - fuel_time)
		if cookable then -- fuel lasts long enough, adjust el to cooking duration
			el = math.min(el, cooked.time - src_time)
		end

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + el
			-- If there is a cookable item then check if it is ready yet
			if cookable then
				src_time = src_time + el
				if src_time >= cooked.time then
					-- Place result in dst list if possible
					if inv:room_for_item("dst", cooked.item) then
						inv:add_item("dst", cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
						src_time = src_time - cooked.time
						update = true
					else
						dst_full = true
					end
				else
					-- Item could not be cooked: probably missing fuel
					update = true
				end
			end
		else
			-- Furnace ran out of fuel
			if cookable then
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- Take fuel from fuel list
					inv:set_stack("fuel", 1, afterfuel.items[1])
					-- Put replacements in dst list or drop them on the furnace.
					local replacements = fuel.replacements
					if replacements[1] then
						local leftover = inv:add_item("dst", replacements[1])
						if not leftover:is_empty() then
							local above = vector.new(pos.x, pos.y + 1, pos.z)
							local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above
							minetest.item_drop(replacements[1], nil, drop_pos)
						end
					end
					update = true
					fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
				end
			else
				-- We don't need to get new fuel since there is no cookable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - el
	end

	if fuel and fuel_totaltime > fuel.time then
		fuel_totaltime = fuel.time
	end
	if srclist and srclist[1]:is_empty() then
		src_time = 0
	end

	--
	-- Update formspec, infotext and node
	--
	local item_state
	local item_percent = 0
	local fuel_percent = 0
	if cookable then
		item_percent = math.floor(src_time / cooked.time * 100)
		if dst_full then
			item_state = "100% (output full)"
		else
			item_state = tostring(item_percent)
		end
	else
		if srclist and not srclist[1]:is_empty() then
			item_state = "Not cookable"
		else
			item_state = "Empty"
		end
	end

	local fuel_state = "Empty"
	local active = false
	local result = false

	if fuel_totaltime ~= 0 then
		active = true
		fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		fuel_state = tostring(fuel_percent)
		swap_node(pos, "default:furnace_active")
		-- make sure timer restarts automatically
		result = true
	else
		if fuellist and not fuellist[1]:is_empty() then
			fuel_state = "0"
		end
		
		swap_node(pos, "default:furnace")
		-- stop timer on the inactive furnace
		minetest.get_node_timer(pos):stop()
	end


	local infotext
	if active then
		infotext = "Furnace active"
	else
		infotext = "Furnace inactive"
	end
	infotext = infotext.."\n".."(Item: "..item_state.."; Fuel: "..fuel_state

	--
	-- Set meta values
	--
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
	meta:set_float("item_percent", item_percent)
	meta:set_float("fuel_percent", fuel_percent)
	--meta:set_string("formspec", formspec)
	meta:set_string("infotext", infotext)
	
	
	
	return result
end

minetest.register_node("default:furnace", {
	description = "Furnace",
	tiles = {
		"default_furnace_top.png", "default_furnace_bottom.png",
		"default_furnace_side.png", "default_furnace_side.png",
		"default_furnace_side.png", "default_furnace_front.png"
	},
	paramtype2 = "facedir",
	groups = {cracky=2, furnace=1},
	--legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),

	can_dig = can_dig,

	on_timer = furnace_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('fuel', 1)
		inv:set_size('dst', 4)
		furnace_node_timer(pos, 0)
	end,

	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		qts.get_node_inventory_drops(pos, "src", drops)
		qts.get_node_inventory_drops(pos, "fuel", drops)
		qts.get_node_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "default:furnace"
		minetest.remove_node(pos)
		return drops
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		qts.gui.show_gui(pos, clicker, "default_furnace")
	end,
	
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

minetest.register_node("default:furnace_active", {
	description = "Furnace",
	tiles = {
		"default_furnace_top.png", "default_furnace_bottom.png",
		"default_furnace_side.png", "default_furnace_side.png",
		"default_furnace_side.png", "default_furnace_front_active.png" --TODO: animate this
	},
	paramtype2 = "facedir",
	groups = {cracky=2, not_in_creative_inventory = 1, furnace=1},
	--legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),

	can_dig = can_dig,

	on_timer = furnace_node_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('fuel', 1)
		inv:set_size('dst', 4)
		furnace_node_timer(pos, 0)
	end,

	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "src", drops)
		default.get_inventory_drops(pos, "fuel", drops)
		default.get_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "default:furnace"
		minetest.remove_node(pos)
		return drops
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		qts.gui.show_gui(pos, clicker, "default_furnace")
	end,
	
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})
