
local function launch_campfire_drop(pos, itemstack)
	local obj = minetest.add_item(pos, ItemStack(itemstack))
	if obj then
		obj:set_velocity({x = math.random(-1, 1), y = math.random(3, 5), z = math.random(-1, 1)})
	else
		minetest.log("invalid drop: ".. dump(itemstack))
	end
end

local function kill_campfire_item(pos)
	local objs = minetest.get_objects_inside_radius(pos,1)
	for i, obj in ipairs(objs) do
		if (obj:is_player() == false) then
			if (obj:get_luaentity().name == "default:campfire_item") then
				obj:remove()
			end
		end
	end
end

local function campfire_node_timer(pos, elapsed)
	local meta = minetest.get_meta(pos)
	local timer = minetest.get_node_timer(pos)
	
	local fueltime = meta:get_int("campfire_fuel")
	fueltime = fueltime - elapsed
	
	if (fueltime <= 0) then
		timer:stop()
		meta:set_int("campfire_fuel", 0)
		minetest.swap_node(pos, {name = "default:campfire"})
	else
		meta:set_int("campfire_fuel", fueltime)
		timer:start(1)
		
		local cookTimer = meta:get_int("cooking_time_left") - elapsed
		local cookItem = meta:get_string("campfire_smeltable")
		if (cookTimer <= 0 and cookItem ~= "") then
			meta:set_int("cooking_time_left", 0)
			
			local cooked, aftercooked = minetest.get_craft_result({
				method = "cooking", 
				width = 1, 
				items = {cookItem}
			})
			
			if (cooked.time ~= 0) then
				launch_campfire_drop(pos, cooked.item)
				minetest.log("Cooked drops launched")
			else
				launch_campfire_drop(pos, cookItem)
				minetest.log("Orig item launched")
			end
			
			meta:set_string("campfire_smeltable", "")
			
			kill_campfire_item(pos)
			
		else
			meta:set_int("cooking_time_left", cookTimer)
		end
	end
	
	meta:set_string("infotext", "Campfire Fuel: ".. meta:get_int("campfire_fuel") .." seconds\nSmelting: ".. meta:get_string("campfire_smeltable"))
end



local function campfire_rightclick(pos, node, clicker, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	
	if (itemstack:is_empty()) then
		local prev_item = meta:get_string("campfire_smeltable")
		if (prev_item ~= "") then
			launch_campfire_drop(pos, prev_item)
		end
		meta:set_string("campfire_smeltable", "")
		meta:set_int("cooking_time_left", 0)
		kill_campfire_item(pos)
	end
	
	if (itemstack:get_name() == "default:clay" and not itemstack:is_empty() and node.name ~= "default:campfire") then
		itemstack:take_item()
		minetest.set_node(pos, {name = "default:furnace"})
		return itemstack
	end
	
	--fuel
	local cooked, aftercooked = minetest.get_craft_result({
		method = "fuel", 
		width = 1, 
		items = {itemstack:peek_item(1)}
	})
	if (cooked.time ~= 0) then
		--item is fuel
		local item = itemstack:take_item()
		
		meta:set_int("campfire_fuel", meta:get_int("campfire_fuel") + cooked.time)
	else
		
		--cookable item
		cooked, aftercooked = minetest.get_craft_result({
			method = "cooking", 
			width = 1, 
			items = {itemstack:peek_item(1)}
		})
		if (cooked.time ~= 0) then
			--item is cookable
			kill_campfire_item(pos)
			
			local item = itemstack:take_item()
			
			local prev_item = meta:get_string("campfire_smeltable")
			if (prev_item ~= "") then
				launch_campfire_drop(pos, prev_item)
			end
			
			meta:set_string("campfire_smeltable", item:to_string())
			meta:set_int("cooking_time_left", cooked.time)
			
			local obj = minetest.add_entity(vector.add(pos, {x=0, y=-0.3, z=0}), "default:campfire_item")
			obj:get_luaentity():set_item(item)
			
		end
	end
	
	meta:set_string("infotext", "Campfire Fuel: ".. 
		meta:get_int("campfire_fuel") ..
		" seconds\nSmelting: ".. 
		meta:get_string("campfire_smeltable"))
	return itemstack
end

local function campfire_flood(pos, oldnode, newnode)
	minetest.sound_play("sounds_cooling_hiss",	{pos = pos, gain = 1})
	return false
end

minetest.register_node("default:campfire", {
	description = "Campfire",
	drawtype = "mesh",
	tiles ={"default_campfire.png"},
	mesh = "campfire.obj",
	paramtype = "light",
	is_ground_content = false,
	floodable = true,
	collision_box = {
		type = "fixed",
		fixed = {{-0.375000, -0.5, -0.375000, 0.375000, -0.375000, 0.375000}}
	},
	selection_box = {
		type = "fixed",
		fixed = {{-0.375000, -0.5, -0.375000, 0.375000, -0.375000, 0.375000}}
	},
	groups = {oddly_breakable_by_hand=3, campfire=1},
	sounds = qtcore.node_sound_wood(),
	
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("campfire_fuel", 0)
		meta:set_string("campfire_smeltable", "")
		meta:set_int("cooking_time_left", 0)
		meta:set_string("infotext", "Campfire Fuel: 0 seconds\nSmelting: nothing")
		--campfire_node_timer(pos, 0)
	end,
	
	on_ignite = function(pos, igniter)
		local meta = minetest.get_meta(pos)
		if (meta:get_int("campfire_fuel") > 0) then
			minetest.swap_node(pos, {name = "default:campfire_lit"})
			campfire_node_timer(pos, 0)
		end
	end,
	
	on_rightclick = campfire_rightclick,
	
	on_flood = campfire_flood,
})

minetest.register_node("default:campfire_lit", {
	description = "Campfire",
	drawtype = "mesh",
	tiles ={{
		name = "default_campfire_animated.png",
		animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1}
	}},
	mesh = "campfire.obj",
	light_source = 13,
	paramtype = "light",
	is_ground_content = false,
	floodable = true,
	drop = "default:campfire",
	collision_box = {
		type = "fixed",
		fixed = {{-0.375000, -0.5, -0.375000, 0.375000, -0.375000, 0.375000}}
	},
	selection_box = {
		type = "fixed",
		fixed = {{-0.375000, -0.5, -0.375000, 0.375000, -0.375000, 0.375000}}
	},
	groups = {oddly_breakable_by_hand=3, campfire=1, ambient=1, not_in_creative_inventory = 1},
	sounds = qtcore.node_sound_wood({
		ambience = {
			name = "campfire",
			spec = {gain = 10},
			chance = 1,
			playtime = 16,
			positional = true,
			loop = true,
		}
	}),
	
	on_timer = campfire_node_timer,
	
	on_ignite = function(pos, igniter) return end,
	
	on_rightclick = campfire_rightclick,
	
	on_flood = campfire_flood,
})


minetest.register_entity("default:campfire_item", {
	initial_properties = {
		--
		hp_max = 1,
		physical = false,
		weight = 1,
		collide_with_objects = false, --using manual detection
		visual = "wielditem",
		visual_size = {x=.2, y=.2, z=.2},
		textures = {"default:stone"},
		is_visible = true,
		makes_footsteps_sounds = false,
		pointable = false,
		glow = qts.LIGHT_MAX,
	},
	set_item = function(self, itemstack)
		itemstack = ItemStack(itemstack):to_string()
		self.object:set_properties({textures = {itemstack}})
	end,
	on_step = function(self, dtime)
		local pos = self.object:get_pos()
		local node = minetest.get_node_or_nil(pos)
		if node then
			if minetest.get_item_group(node.name, "campfire") == 0 then
				minetest.log("Campfire item: Self-Death")
				self.object:remove()
			end
		end
	end,
	on_activate = function(self)
		self.object:set_armor_groups({immortal = 1})
		self.QTID = qts.gen_entity_id()
		minetest.log("Campfire item: CREATED. Pos:" .. minetest.pos_to_string(self.object:get_pos()))
	end,
})

