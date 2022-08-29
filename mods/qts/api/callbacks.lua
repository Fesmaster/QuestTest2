--[[
    This file creates many, many more callbacks for nodes and items

	It is also responsible for ambient sounds

#CALLBACKS

on_walk = function(pos, player) -> nil
	called when the player walks on top of a block

on_walk_in = function(pos, player) -> nil
	called when the player walks within a block

on_walk_exit = function(pos, player) -> nil
	called when the player leaves a block (from within it)
	
on_carry = function(itemstack, player) -> itemstack, nil
	called every tick when the item is in the player's inventory
	if nil is returned, then the itemstack is unmodified, otherwise, 
	the return must be a new itemstack to replace the old one

on_wield = function(itemstack, player) ->itemstack, nil
	called every tick when the item is in the player's hand.
	if nil is returned, then the itemstack is unmodified, otherwise, 
	the return must be a new itemstack to replace the old one

on_long_secondary_use = function(itemstack, player) ->itemstack, nil
	called if you hold the rightclick button down for more than 1 second without changing item
	used for things like eating, bows, etc.
	if nil is returned, then the itemstack is unmodified, otherwise, 
	the return must be a new itemstack to replace the old one

long_secondary_use_time = number
	how long to wait before calling on_long_secondary_use. Defaults to 1 if not specified.

on_stop_secondary_use = function(wield, player, cause) -> itemstack, nil
	called when you stop rightclicking an item, either by changing the wielded index or by releasing the button
	`cause` will always be a string, either "unclicked", or "scrolled". 
		"unclikced" means that the RMB was released.
		"scrolled" meamd that the player changed their wield index
	if nil is returned, then the itemstack is unmodified, otherwise, 
	the return must be a new itemstack to replace the old one

on_node_update = function(pos)
	called whenever a node receives and update

	
Ambient Sounds	
	inside of a register_node, under [sounds] = {}, 
	ambience = {
		name = "name"
		spec = simple_sound_spec
		chance = 1 in value
		playtime = number
		positional = boolean
		
		--if playtime is nil, the sound is killed every sound cycle (default: 3 seconds)
	}
	
	in player data, a table of {
		nodename = {
			timer = time_left
			handle = sound_handle
		}
	}
]]

local node_damage_timer = 0

local ambient_sound_cycles = 2
local ambient_sound_timer = 0
local ambient_sound_radius = 8

local long_click_time = 1

--[[
	Retuns true once per second
]]
function qts.is_damage_tick()
	return node_damage_timer >= 1
end

local function add_pos_to_set(set, pos, data)
    local serialized = pos:to_string()
    if not set[serialized] then
        set[serialized] = data
        return true
    else
        return false
    end
end


local function get_nearby_set(set, inpos)
    for x=-1,1 do
        for y=-1,1 do
            for z=-1,1 do
                local offset = vector.new(x,y,z)+inpos
                add_pos_to_set(set, offset, {pos=offset, node=minetest.get_node_or_nil(offset)} )
            end
        end
    end
    return set
end

local function update_node(pos, node)
    if node then
        local def = minetest.registered_nodes[node.name]
        if def and def.on_node_update then
            def.on_node_update(pos)
        end
    end
end

local ustart, ustop = qts.profile("qts node update callbacks", "ms")

--[[
	Notify that a single node is updated in some way by the player
]]
function qts.update_node(pos)
	ustart()
    local set = get_nearby_set({}, pos)
    for s, dat in pairs(set) do
        update_node(dat.pos, dat.node)
    end
	ustop()
end

--[[
	Notify that a group of nodes are updated in some way by the player
]]
function qts.update_node_list(pos_list)
    ustart()
	local set = {}
    for k, pos in ipairs(pos_list) do
        get_nearby_set(set, pos)
    end
    for s, dat in pairs(set) do
        update_node(dat.pos, dat.node)
    end
	ustop()
end

local start, stop = qts.profile("qts mod callback globalstep", "ms")
minetest.register_globalstep(function(dtime)
	start()
	--damage tick update
	--this is important, because at least one tick will have the timer >= 1 for the entire duration.
	if node_damage_timer >= 1 then
		node_damage_timer = 0
	end
	node_damage_timer = node_damage_timer + dtime
	
	--player node and item callbacks
	for _, player in ipairs(minetest.get_connected_players()) do
		--generate the player data table
		local name = player:get_player_name()
		if not qts.player_data[name] then
			qts.player_data[name] = {}
		end
		
		--[[
			Deal with the world callbacks of where the player is stepping
		--]]
		local pos = player:get_pos()
		local prevpos = qts.get_player_data(name, "INTERNAL", "prevpos")
		if not prevpos then prevpos = vector.new(pos) end
		
		pos.y = pos.y-0.5 --vertical height adjustment
		prevpos.y = prevpos.y+0.5
		
		local node_under = minetest.get_node(pos)
		local node_dat_under = minetest.registered_nodes[node_under.name]
		if node_dat_under and node_dat_under.on_walk then
			node_dat_under.on_walk(pos, player)
		end

		for offset_y = 0,1 do
			local offset_v = vector.new(0,1+offset_y,0)
			local offset_pos = pos + offset_v
			local node_in = minetest.get_node(offset_pos)
			local new = not (vector.equals(vector.round(offset_pos), vector.round(prevpos)))
			
			local node_dat_in = minetest.registered_nodes[node_in.name]
			if node_dat_in and node_dat_in.on_walk_in then
				node_dat_in.on_walk_in(offset_pos, player, new)
			end
			if new then
				local old_node_dat_in = minetest.registered_nodes[minetest.get_node(prevpos+offset_v).name]
				if (old_node_dat_in and old_node_dat_in.on_walk_exit) then
					old_node_dat_in.on_walk_exit(prevpos+offset_v, player)
				end
			end
		end
		
		--[[
			Deal with the inventory callbacks
		--]]
		local inv = player:get_inventory()
		
		local invlist = inv:get_list("main")
		local invlist_n = {}
		for ref, itemstack in ipairs(invlist) do
			local itemdat = minetest.registered_items[itemstack:get_name()]
			if itemdat and itemdat.on_carry then
				local itemstack_n = itemdat.on_carry(itemstack, player)
				if itemstack_n then
					invlist_n[ref]=itemstack_n
				else
					invlist_n[ref]=itemstack
				end
			else
				invlist_n[ref]=itemstack
			end
		end
		inv:set_list("main", invlist_n)
		
		local wield = player:get_wielded_item()
		local wielddat = minetest.registered_items[wield:get_name()]
		if wielddat then
			local rmb_time = qts.get_player_data(name, "INTERNAL", "rmb_time") or 0
			local wield_index_prev = qts.get_player_data(name, "INTERNAL", "wield_index") or 0
			local wield_index = player:get_wield_index()
			local controls = player:get_player_control()
			local long_click_time_max = wielddat.long_secondary_use_time or long_click_time

			local did_unclick = false
			if wield_index == wield_index_prev then
				if controls.RMB then
					rmb_time = rmb_time + dtime
					if rmb_time > long_click_time_max then
						--run the long click function
						if wielddat.on_long_secondary_use then
							local wield_n = wielddat.on_long_secondary_use(wield, player)
							if wield_n then
								player:set_wielded_item(wield_n)
							end
						end

						rmb_time = 0
					end
				else
					if rmb_time > 0 then
						--was clicking last frame
						did_unclick = true
					end
					rmb_time = 0
				end
			else
				if rmb_time > 0 then
					--was clicking last frame
					did_unclick = true
				end 
				rmb_time = 0
			end
			if did_unclick then
				--run the unclick function
				--make sure it is for the previous rightclicked item
				local cause = "unclicked"
				if (wield_index ~= wield_index_prev) then
					cause = "scrolled"
					inv = player:get_inventory()
					local prev_wield = inv:get_stack(player:get_wield_list(), wield_index_prev)
					if prev_wield then
						wield = prev_wield
						wielddat = minetest.registered_items[prev_wield:get_name()]
					else
						wielddat = nil
					end
				end

				if wielddat and wielddat.on_stop_secondary_use then
					local wield_n = wielddat.on_stop_secondary_use(wield, player, cause)
					if wield_n then
						if (wield_index ~= wield_index_prev) then
							inv:set_stack(player:get_wield_list(), wield_index_prev, wield_n)
						else
							player:set_wielded_item(wield_n)
						end
					end
				end
			end

			qts.set_player_data(name, "INTERNAL", "rmb_time", rmb_time)
			qts.set_player_data(name, "INTERNAL", "wield_index", wield_index)
		end

		--wielded item may have changed. Re-fetch it.
		wield = player:get_wielded_item()
		wielddat = minetest.registered_items[wield:get_name()]
		if wielddat and wielddat.on_wield then
			--run the one_wield function
			local wield_n = wielddat.on_wield(wield, player)
			if wield_n then
				player:set_wielded_item(wield_n)
			end
		end
		
		--[[
			Pick up dropped items in the world
		--]]
		local objs = minetest.get_objects_inside_radius(vector.add(pos, {x=0, y=1, z=0}), 1.5)
		if (#objs > 1) then
			for i, obj in ipairs(objs) do
				pcall(function()
					--auto-punch dropped items
					if obj and not obj:is_player() then
						if qts.object_name(obj) == "__builtin:item" then
							if obj:get_luaentity().age and obj:get_luaentity().age >= 2 then
								obj:punch(player, 1, {
									full_punch_interval = 0.9,
									max_drop_level = 1,
									groupcaps = {},
									damage_groups = {fleshy = 1},
								}, nil)
								qts.pickup_sound(obj)
							end
						end
					end
				end)
			end
		end
		
		--[[
			Ambient Sounds
			
			inside of a register_node, under [sounds] = {}, 
			ambience = {
				name = "name"
				spec = simple_sound_spec
				chance = 1 in value
				playtime = number
				positional = boolean
				
				--if playtime is nil, the sound is killed every sound cycle (default: 3 seconds)
			}
			
			in player data, a table of {
				nodename = {
					timer = time_left
					handle = sound_handle
					
				}
			}
		--]]
		
		ambient_sound_timer = ambient_sound_timer + dtime
		local playing_sounds = qts.get_player_data(name, "INTERNAL", "playing_sounds") or {}
		for k, v in pairs(playing_sounds) do
			v.timer = v.timer - dtime;
			if (v.timer <= 0) then
				minetest.sound_stop(v.handle) --kill sounds
				playing_sounds[k] = nil
			end
		end
		
		if (ambient_sound_timer >= ambient_sound_cycles) then
			ambient_sound_timer = 0
			
			local as_pos_list, as_num = minetest.find_nodes_in_area(
				vector.subtract(pos, ambient_sound_radius),
				vector.add(pos, ambient_sound_radius),
				{"group:ambient"}
			)
			
			local as_count = 0
			for i, v in pairs(as_num) do 
				as_count = as_count + v
			end
			
			--if there is an ambient sound node in the area
			if (as_count >= 1) then
				
				for i, as_pos in ipairs(as_pos_list) do
					--minetest.log("ambient sound update")
					local sound_node = minetest.get_node_or_nil(as_pos)
					if (sound_node) then
						local sound_node_name = sound_node.name
						if (playing_sounds[sound_node_name] == nil) then 
							--minetest.log("new sound - " .. sound_node_name)
							--only play sounds from a node type not already playing
							local sound_node_def = minetest.registered_nodes[sound_node_name]
							if (sound_node_def) then
								--minetest.log("def exists")
								local sound_profile = sound_node_def.sounds.ambience --ambience 
								if (sound_profile) then
									--minetest.log("sound profile exists")
									if (math.random(sound_profile.chance) == 1) then
										--minetest.log("chance suceeded. player: " .. name)
										local spec = {
											max_hear_distance = sound_profile.spec.max_hear_distance or 32,
											gain = sound_profile.spec.gain or 1,
											--loop = sound_profile.spec.loop,
											to_player = name,
										}
										if (sound_profile.positional) then
											spec.pos = as_pos
										end
										local h = minetest.sound_play(sound_profile.name, spec)
										playing_sounds[sound_node_name] = {
											handle = h,
											timer = sound_profile.playtime or ambient_sound_cycles
										}
									end
								end
							end
						end
					end
					
				end
			end
			
		end
		qts.set_player_data(name, "INTERNAL", "playing_sounds", playing_sounds)
		
		
		--update prevpos
		qts.set_player_data(name, "INTERNAL", "prevpos", player:get_pos())
	end
	
	stop()
end)



minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    qts.update_node(pointed_thing.under)
end)

minetest.register_on_dignode(function(pos, oldnode, digger)
    qts.update_node(pos)
end)

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    qts.update_node(pos)
end)

minetest.register_on_liquid_transformed(function(pos_list, node_list)
    qts.update_node_list(pos_list)
end)