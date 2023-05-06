--[[
this file contains the "special" registrations that make
nodes and items of specific types
that often have lots of code attached to then

qts.register_fencelike_node(name, def)
	def.type = [fence, rail, wall, pane]
	def.texture = "texture.png" (DEPRICIATED, use def.tiles = {"texture1.png", ...})
qts.register_liquid(name, def)
	no special things
qts.register_bucket(name, def)
	def contains:
		description
		inventory_image
		groups {bucket_level >= 1}
	Note: this function is much more restricted than the others in this file.
qts.register_ingot(name, def)
	no special things
qts.register_torch(name, def)
	no special things
--]]

--[[
Given a node name, try and guess the permutation type
this may not work well for some nodes, particularly shaped nodes
]]



local enable_fence_tall = qts.config("enable_fence_tall", false, "enable tall fences that cannot be jumped over", {loadtime=true})
local fence_collision_extra = enable_fence_tall and 3/8 or 0

--[[
besides the defaults from minetest.register_node, must contain:  
	type = [fence, rail, wall, pane]
]]
function qts.register_fencelike_node(name, def)
	if not def.type then minetest.log("qts.register_fencelike_node: the node def must contain type = [fence, rail, wall, pane]") end
	if def.texture and not def.tiles then
		minetest.log("qts.register_fencelike_node: instead of using texture = \"texturename\", use tiles = {}. This works better.")
		def.tiles = {def.texture}
	end
	if not def.drop then
		def.drop = name
	end

	local default_fields = {}
	--fence style

	if def.type == "fence" then
		local fence_texture = "qts_fence_overlay.png^" .. def.tiles[1] ..
			"^qts_fence_overlay.png^[makealpha:255,126,126"

		if not def.no_tile_transform then
			for i, v in ipairs(def.tiles) do
				def.tiles[i] = def.tiles[i] .. "^(" .. def.tiles[i] .."^[transformR90^[mask:fence_pole_mask.png)"
			end
			def.no_tile_transform = nil
		end

		-- Allow almost everything to be overridden
		default_fields = {
			paramtype = "light",
			drawtype = "nodebox",
			node_box = {
				type = "connected",
				fixed = {-1/8, -1/2, -1/8, 1/8, 1/2, 1/8},
				-- connect_top =
				-- connect_bottom =
				connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/8 },
							{-1/16, -5/16, -1/2,   1/16, -3/16, -1/8 }},
				connect_left =  {{-1/2,   3/16, -1/16, -1/8,   5/16,  1/16},
							{-1/2,  -5/16, -1/16, -1/8,  -3/16,  1/16}},
				connect_back =  {{-1/16,  3/16,  1/8,   1/16,  5/16,  1/2 },
							{-1/16, -5/16,  1/8,   1/16, -3/16,  1/2 }},
				connect_right = {{ 1/8,   3/16, -1/16,  1/2,   5/16,  1/16},
							{ 1/8,  -5/16, -1/16,  1/2,  -3/16,  1/16}}
			},
			collision_box = {
				type = "connected",
				fixed = {-1/8, -1/2, -1/8, 1/8, 1/2 + fence_collision_extra, 1/8},
				-- connect_top =
				-- connect_bottom =
				connect_front = {-1/8, -1/2, -1/2,  1/8, 1/2 + fence_collision_extra, -1/8},
				connect_left =  {-1/2, -1/2, -1/8, -1/8, 1/2 + fence_collision_extra,  1/8},
				connect_back =  {-1/8, -1/2,  1/8,  1/8, 1/2 + fence_collision_extra,  1/2},
				connect_right = { 1/8, -1/2, -1/8,  1/2, 1/2 + fence_collision_extra,  1/8}
			},
			connects_to = {"group:fence", "group:wood", "group:tree", "group:wall", "group:shaped_node"},
			inventory_image = fence_texture,
			wield_image = fence_texture,
			tiles = def.tiles,
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {},
		}

		if def.fence_alt then
			local fence_alt = def.fence_alt
			default_fields.on_hammer = function(pointed_thing, user, mode, newnode)
				local node = minetest.get_node_or_nil(pointed_thing.under)
				if node and mode == qts.HAMMER_FUNCTION.CHANGE_TYPE then
					minetest.set_node(pointed_thing.under, {
						name = fence_alt,
						param1 = node.param1,
						param2 = node.param2
					})
				end
			end
			def.fence_alt = nil
		end

		-- Always add to the fence group, even if no group provided
		def.groups.fence = 1

	elseif def.type == "rail" then
		local fence_rail_texture =  "qts_fence_rail_overlay.png^" .. def.tiles[1] ..
			"^qts_fence_rail_overlay.png^[makealpha:255,126,126"

		-- Allow almost everything to be overridden
		default_fields = {
			paramtype = "light",
			drawtype = "nodebox",
			node_box = {
				type = "connected",
				fixed = {{-1/16,  3/16, -1/16, 1/16,  5/16, 1/16},
					{-1/16, -3/16, -1/16, 1/16, -5/16, 1/16}},
				-- connect_top =
				-- connect_bottom =
				connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/16},
							{-1/16, -5/16, -1/2,   1/16, -3/16, -1/16}},
				connect_left =  {{-1/2,   3/16, -1/16, -1/16,  5/16,  1/16},
							{-1/2,  -5/16, -1/16, -1/16, -3/16,  1/16}},
				connect_back =  {{-1/16,  3/16,  1/16,  1/16,  5/16,  1/2 },
							{-1/16, -5/16,  1/16,  1/16, -3/16,  1/2 }},
				connect_right = {{ 1/16,  3/16, -1/16,  1/2,   5/16,  1/16},
									{ 1/16, -5/16, -1/16,  1/2,  -3/16,  1/16}}
			},
			collision_box = {
				type = "connected",
				fixed = {-1/8, -1/2, -1/8, 1/8, 1/2 + fence_collision_extra, 1/8},
				-- connect_top =
				-- connect_bottom =
				connect_front = {-1/8, -1/2, -1/2,  1/8, 1/2 + fence_collision_extra, -1/8},
				connect_left =  {-1/2, -1/2, -1/8, -1/8, 1/2 + fence_collision_extra,  1/8},
				connect_back =  {-1/8, -1/2,  1/8,  1/8, 1/2 + fence_collision_extra,  1/2},
				connect_right = { 1/8, -1/2, -1/8,  1/2, 1/2 + fence_collision_extra,  1/8}
			},
			connects_to = {"group:fence", "group:wall", "group:shaped_node"},
			inventory_image = fence_rail_texture,
			wield_image = fence_rail_texture,
			tiles = def.tiles,
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {},
		}

		if def.fence_alt then
			local fence_alt = def.fence_alt
			default_fields.on_hammer = function(pointed_thing, user, mode, newnode)
				local node = minetest.get_node_or_nil(pointed_thing.under)
				if node and mode == qts.HAMMER_FUNCTION.CHANGE_TYPE then
					minetest.set_node(pointed_thing.under, {
						name = fence_alt,
						param1 = node.param1,
						param2 = node.param2
					})
				end
			end
			def.fence_alt = nil
		end

		def.groups.fence = 1

	elseif def.type == "wall" then
		-- Allow almost everything to be overridden
		default_fields = {
			paramtype = "light",
			drawtype = "nodebox",
			node_box = {
				type = "connected",
				fixed = {-1/4, -1/2, -1/4, 1/4, 1/2, 1/4},
				-- connect_bottom =
				connect_front = {-3/16, -1/2, -1/2,  3/16, 3/8, -1/4},
				connect_left = {-1/2, -1/2, -3/16, -1/4, 3/8,  3/16},
				connect_back = {-3/16, -1/2,  1/4,  3/16, 3/8,  1/2},
				connect_right = { 1/4, -1/2, -3/16,  1/2, 3/8,  3/16},
			},
			collision_box = {
				type = "connected",
				fixed = {-1/4, -1/2, -1/4, 1/4, 1/2 + fence_collision_extra, 1/4},
				-- connect_top =
				-- connect_bottom =
				connect_front = {-1/4,-1/2,-1/2,1/4,1/2 + fence_collision_extra,-1/4},
				connect_left = {-1/2,-1/2,-1/4,-1/4,1/2 + fence_collision_extra,1/4},
				connect_back = {-1/4,-1/2,1/4,1/4,1/2 + fence_collision_extra,1/2},
				connect_right = {1/4,-1/2,-1/4,1/2,1/2 + fence_collision_extra,1/4},
			},
			connects_to = { "group:wall", "group:stone", "group:fence", "group:shaped_node" },
			tiles = def.tiles,
			sunlight_propagates = true,
			is_ground_content = false,
			walkable = true,
			groups = {},
		}
		def.groups.wall = 1
	elseif def.type == "pane" then

		default_fields = {
			paramtype = "light",
			paramtype2 = "facedir",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {{-1/2, -1/2, -1/32, 1/2, 1/2, 1/32}},
			},
			collision_box = {
				type = "fixed",
				fixed = {{-1/2, -1/2, -1/32, 1/2, 1/2, 1/32}},
			},
			connects_to = {"group:pane","group:shaped_node", "group:stone", "group:glass", "group:wood", "group:log"},
			--tiles = def.tiles or tiles,
			inventory_image = def.inventory_image or def.tiles[2],
			wield_image = def.wield_image or def.tiles[2],
			sunlight_propagates = true,
			is_ground_content = false,
			use_texture_alpha = true,
			walkable = true,
			groups = {},
		}
		def.groups.pane = 1

		--special stuff for panes
		local tiles = def.tiles
		def.tiles = {tiles[1], tiles[1], tiles[2]}
		def.texture = nil
		def.material = nil
		def.type = nil
		for k, v in pairs(default_fields) do
			if def[k] == nil then
				def[k] = v
			end
		end

		minetest.register_node(name, qts.table_deep_copy(def))

		if not def.drop then
			def.drop = name
		end
		def.groups.not_in_creative_inventory=1
		def.tiles = {tiles[1], tiles[1], tiles[3]}
		def.node_box = {
			type = "connected",
			fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
			connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
			connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
			connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
			connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
		}
		def.collision_box = {
			type = "connected",
			fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
			connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
			connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
			connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
			connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
		}

		minetest.register_node(name.."_part", qts.table_deep_copy(def))

		--this one has its own registration
		return
	else
		minetest.log("qts.register_fencelike_node: the node def must contain type = [fence, rail, wall, pane]")
	end

	def.texture = nil
	def.material = nil
	def.type = nil
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end
	minetest.register_node(":"..name, def)
end


--this is almost entirely copied from xpanes, but contains a few tweaks
local function is_pane(pos)
	return minetest.get_item_group(minetest.get_node(pos).name, "pane") > 0
end
local function connects_dir(pos, name, dir)
	local aside = vector.add(pos, minetest.facedir_to_dir(dir))
	if is_pane(aside) then
		return true
	end
	local connects_to = minetest.registered_nodes[name].connects_to
	if not connects_to then
		return false
	end
	local list = minetest.find_nodes_in_area(aside, aside, connects_to)
	if #list > 0 then
		return true
	end
	return false
end
local function swap(pos, node, name, param2)
	if node.name == name and node.param2 == param2 then
		return
	end
	minetest.swap_node(pos, {name = name, param2 = param2})
end
local function update_pane(pos)
	if not is_pane(pos) then
		return
	end
	local node = minetest.get_node(pos)
	local name = node.name
	if name:sub(-5) == "_part" then
		name = name:sub(1, -6)
	end
	local any = node.param2
	local c = {}
	local count = 0
	for dir = 0, 3 do
		c[dir] = connects_dir(pos, name, dir)
		if c[dir] then
			any = dir
			count = count + 1
		end
	end
	if count == 0 then
		swap(pos, node, name, any)
	elseif count == 1 then
		swap(pos, node, name, (any + 1) % 4)
	elseif count == 2 then
		if (c[0] and c[2]) or (c[1] and c[3]) then
			swap(pos, node, name, (any + 1) % 4)
		else
			swap(pos, node, name .. "_part", 0)
		end
	else
		swap(pos, node, name .. "_part", 0)
	end
end
minetest.register_on_placenode(function(pos, node)
	if minetest.get_item_group(node, "pane") then
		update_pane(pos)
	end
	for i = 0, 3 do
		local dir = minetest.facedir_to_dir(i)
		update_pane(vector.add(pos, dir))
	end
end)
minetest.register_on_dignode(function(pos)
	for i = 0, 3 do
		local dir = minetest.facedir_to_dir(i)
		update_pane(vector.add(pos, dir))
	end
end)




--BEGIN liquid
local liquid_cache = {}
local bucket_cache = {}
--liquid helper funcs
local function to_bucket_name(name)
	return "_"..name:gsub(":", "_"):gsub("_source", "")
end

--this is to register a bucket combo for the specific liquid
local function register_bucket_full(bucketid, liquidid)
	local bucket_data = bucket_cache[bucketid]
	local liquid_data = liquid_cache[liquidid]

	--copy groups into one table
	local groups = {}
	for k, v in pairs(bucket_data.groups) do
		if not groups[k] then groups[k] = v end
	end
	for k, v in pairs(liquid_data.groups) do
		if not groups[k] then groups[k] = v end
	end
	--for clojure
	local source_name = liquid_data.name.."_source"

	--yes, this is about as insane as it looks. go for it!
	minetest.register_craftitem(":"..bucket_data.name .. to_bucket_name(liquid_data.name), {
		description = bucket_data.desc .. " of " .. liquid_data.desc,
		inventory_image = bucket_data.image.."^"..liquid_data.image,
		groups = groups,
		stack_max = 1,
		liquids_pointable = true,

		on_place = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end

			local node = minetest.get_node_or_nil(pointed_thing.under)
			local ndef = node and minetest.registered_nodes[node.name]

			-- Call on_rightclick if the pointed node defines it
			if ndef and ndef.on_rightclick and
					not (user and user:is_player() and user:get_player_control().sneak) then
				return ndef.on_rightclick(pointed_thing.under, node, user, itemstack)
			end

			local lpos

			-- Check if pointing to a buildable node
			if ndef and ndef.buildable_to then
				-- buildable; replace the node
				lpos = pointed_thing.under
			else
				-- not buildable to; place the liquid above
				-- check if the node above can be replaced

				lpos = pointed_thing.above
				node = minetest.get_node_or_nil(lpos)
				local above_ndef = node and minetest.registered_nodes[node.name]

				if not above_ndef or not above_ndef.buildable_to then
					-- do not remove the bucket with the liquid
					return itemstack
				end
			end


			minetest.set_node(lpos, {name = source_name})
			return ItemStack(itemstack:get_name():gsub(to_bucket_name(source_name), ""))
		end
	})
end

--[[
	contains nothing beyond minetest:register_node
]]
function qts.register_liquid(name, def)
	local defaults = {
		waving = 3,
		paramtype = "light",
		--alpha = 191, --default transperancy
        use_texture_alpha = "blend",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		liquids_pointable = true,
		drop = "",
		drowning = 1,
		liquid_alternative_flowing = name.."_flowing",
		liquid_alternative_source = name.."_source",
		liquid_renewable = false,
		liquid_viscosity = 1,
		post_effect_color = {a = 103, r = 30, g = 60, b = 90},
		groups = {},
		--[[
		on_place = function(itemstack, placer, pointed_thing)
			minetest.item_place_node(itemstack, placer, pointed_thing)
		end,
		--]]
	}

	for k, v in pairs(defaults) do
		if def[k] == nil then
			def[k] = v
		end
	end

	if not def.groups.liquid then def.groups.liquid = 1 end

	--add to the liquid cache
	local self_id = #liquid_cache+ 1
	liquid_cache[self_id] = {name = name, desc = def.description, groups = def.groups, image = def.bucket_image}
	def.bucket_image = nil

	local prev_desc = def.description

	--source
	def.drawtype = "liquid"
	def.description = prev_desc.." Source"
	def.liquidtype = "source"
	minetest.register_node(":"..name.."_source", qts.table_deep_copy(def))

	--flowing
	def.drawtype = "flowingliquid"
	def.description = prev_desc.." Flowing"
	def.paramtype2 = "flowingliquid"
	def.liquidtype = "flowing"
	def.groups.not_in_creative_inventory = 1
	minetest.register_node(":"..name.."_flowing", qts.table_deep_copy(def))

	--now, backpropigate already registered buckets
	for bk_id, bk in ipairs(bucket_cache) do
		register_bucket_full(bk_id, self_id)
	end
end

--this func is MUCH more locked in than any of the other.

--[[
def contains ONLY:  
	description  
	inventory_image  
	groups {bucket_level >= 1}  
]]
function qts.register_bucket(name, def)
	if not def.groups then def.groups = {} end
	def.groups.tool = 1
	if not def.groups.bucket_level then def.groups.bucket_level = 1 end

	local self_id = #bucket_cache + 1

	bucket_cache[self_id] = {name = name, desc = def.description, groups = def.groups, image = def.inventory_image}

	minetest.register_craftitem(":"..name, {
		description = "Empty "..def.description,
		inventory_image = def.inventory_image,
		groups = def.groups,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			--handle non-node cases
			if pointed_thing.type == "object" then
				pointed_thing.ref:punch(user, 1.0, { full_punch_interval=1.0 }, nil)
				return user:get_wielded_item()
			elseif pointed_thing.type ~= "node" then
				-- do nothing if it's neither object nor node
				return
			end

			local node =  minetest.get_node(pointed_thing.under)
			local self_name = itemstack:get_name()
			local bucket_name = self_name..to_bucket_name(node.name)
			local item_count = user:get_wielded_item():get_count()
			if minetest.registered_items[bucket_name] then
					--the bucket type exists, unless some wierdness is done
				local ret = bucket_name
				if item_count > 1 then
						-- if space in inventory add filled bucked, otherwise drop as item
					local inv = user:get_inventory()
					if inv:room_for_item("main", {name=bucket_name}) then
						inv:add_item("main", bucket_name)
					else
						local pos = user:get_pos()
						pos.y = math.floor(pos.y + 0.5)
						minetest.add_item(pos, bucket_name)
					end

					ret = self_name.." "..tostring(item_count - 1)
				end

				minetest.set_node(pointed_thing.under, {name = "air"})
				return ret
			else
				--trigger the node's on_punch
				local node_def = minetest.registered_nodes[node.name]
				if node_def then
					node_def.on_punch(pointed_thing.under, node, user, pointed_thing)
				end
				return user:get_wielded_item()
			end
		end
	})

	--now, backpropigate already registered liquids
	for lq_id, lq in ipairs(liquid_cache) do
		register_bucket_full(self_id, lq_id)
	end
end

--[[
besides the defaults from minetest:register_node, def can contain:  
	levels = number  
This is autocalculated from the nodeboxes list length if not supplied.
]]
function qts.register_ingot(name, def)
	--group setup
	local groups_item = qts.table_deep_copy(def.groups)
	local groups_node = qts.table_deep_copy(def.groups)
	groups_item.placeable_ingot = 1
	groups_node.placed_ingot = 1
	groups_node.not_in_creative_inventory = 1
	groups_node.falling_node = 1

	--allow user-defined nodeboxes
	local nodeboxes = def.nodeboxes or {
		{-0.4375, -0.5, -0.3125, 0.4375, -0.3125, -0.0625}, -- NodeBox1
		{-0.4375, -0.5, 0.0625, 0.4375, -0.3125, 0.3125}, -- NodeBox2
		{-0.3125, -0.3125, -0.4375, -0.0625, -0.125, 0.4375}, -- NodeBox3
		{0.0625, -0.3125, -0.4375, 0.3125, -0.125, 0.4375}, -- NodeBox4
		{-0.4375, -0.125, -0.3125, 0.4375, 0.0625, -0.0624999}, -- NodeBox5
		{-0.4375, -0.125, 0.0625, 0.4375, 0.0625, 0.3125}, -- NodeBox6
		{-0.3125, 0.0625, -0.4375, -0.0624999, 0.25, 0.4375}, -- NodeBox7
		{0.0625, 0.0625, -0.4375, 0.3125, 0.25, 0.4375}, -- NodeBox8
	}


	local levels = def.levels or #nodeboxes
	local use_namemod = (levels > 9)
	local offset = -1
	if use_namemod then offset = -2 end
	local base1name = "1"
	if use_namemod then base1name = "01" end
    
    
	--register the ingot craftitem
	minetest.register_craftitem(":"..name, {
		description = def.description,
		inventory_image = def.inventory_image,
		inventory_overlay = def.inventory_overlay,
		wield_image = def.wield_image,
		wield_overlay = def.wield_overlay,
		palette = def.palette,
		color = def.color,
		wield_scale = def.wield_scale,
		stack_max = def.stack_max,
		liquids_pointable = def.liquids_pointable,
		light_source = def.light_source,
		tool_capabilities = def.tool_capabilities,
		sound = def.sound,
		groups = groups_item,
                                            
		on_place = function(itemstack, user, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end

			local node = minetest.get_node_or_nil(pointed_thing.under)
			local ndef = node and minetest.registered_nodes[node.name]

			-- Call on_rightclick if the pointed node defines it
			if ndef and ndef.on_rightclick and
					not (user and user:is_player() and user:get_player_control().sneak) then
				return ndef.on_rightclick(pointed_thing.under, node, user, itemstack)
			end

			local fpos = pointed_thing.under

			local itemdef = minetest.registered_items[itemstack:get_name().."_stacked_"..base1name]
			local sound = nil
			if itemdef and itemdef.sounds and itemdef.sounds.place then
				sound = itemdef.sounds.place
			end

			if node.name:find(itemstack:get_name().."_stacked") and not(tonumber(node.name:sub(offset)) == levels) then
				--minetest.log("found one")

			else
				local node_above = minetest.get_node_or_nil(pointed_thing.above)
				if node_above and node_above.name:find(itemstack:get_name().."_stacked") then
					fpos = pointed_thing.above
					--minetest.log("found one above")
				else
					--place a new bar on the ground
					local n = minetest.get_node_or_nil(pointed_thing.above) --buildable_to
					local def = n and minetest.registered_nodes[n.name]
					if def and n.name ~= "air" then
						if not def.buildable_to then
							return
						end
					end

					minetest.place_node(pointed_thing.above, {name = itemstack:get_name().."_stacked_"..base1name})
					--sound
					if sound then
						minetest.sound_play(sound, {gain = 1.0, max_hear_distance = 32, loop = false, pos = pointed_thing.above})
					end
					itemstack:take_item()
					return itemstack
				end
			end

			node = minetest.get_node_or_nil(fpos) --override node
			local start_count = tonumber(node.name:sub(offset))
			--minetest.log(dump(start_count))
			if start_count < levels then
				local namemod = start_count + 1
				if namemod < 10 and use_namemod then
					namemod = "0"..namemod
				end
				local newname = node.name:sub(1,offset-1)..tostring(namemod)
				minetest.set_node(fpos, {name = newname})
				--minetest.place_node(fpos, {name = newname})
				if sound then
					minetest.sound_play(sound, {gain = 1.0, max_hear_distance = 32, loop = false, pos = pointed_thing.above})
				end
				itemstack:take_item()
			elseif not vector.equals(fpos, pointed_thing.above) then
				--place a new bar on the ground
				minetest.place_node(pointed_thing.above, {name = itemstack:get_name().."_stacked_"..base1name})
				--sound
				if sound then
					minetest.sound_play(sound, {gain = 1.0, max_hear_distance = 32, loop = false, pos = pointed_thing.above})
				end
				itemstack:take_item()
			end
			--TODO:finish ingot item def
			return itemstack
		end,
		
		on_secondary_use = def.on_secondary_use,
		on_drop = def.on_drop,
		on_use = def.on_use,
		after_use = def.after_use,
	})



	for i = 1,levels do

		--copy the content of nodeboxes into local
		local nb = {}
		for j = 1,i do
			nb[j] = nodeboxes[j]
		end
		local namemod = ""..i
		if i < 10 and use_namemod then
			namemod = "0"..i
		end
		--register the nodes
		minetest.register_node(":"..name.."_stacked_"..namemod, {
			description = "Stack of "..def.description,
			tiles = def.tiles,
			drawtype = "nodebox",
			paramtype = "light",
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = nb
			},
			drop = name.." "..i,--FIX: finish
			groups = groups_node,
			sounds = def.sounds,
			on_rotate = function(pos, node, user, mode, new_param2)
				if mode == qts.screwdriver.ROTATE_FACE then
					return true
				else
					return false
				end
			end
		})
	end
end

--[[
	Get the name of a particular torch permutation
]]
function qts.torch_name(name, permutation)
	name:gsub("_ceiling", "")
	name:gsub("_wall", "")
	if permutation == "floor" or permutation == "normal" then
		return name
	elseif permutation == "wall" then
		return name .. "_wall"
	elseif permutation == "ceiling" then
		return name .. "_ceiling"
	else
		minetest.log("Incorrect permutation passed to qts.torch_name: " .. permutation)
		return name
	end
end

--[[
	def contains nothing besides the defaults from minetest:register_node  
	drawtype should not be supplied, if it is, it will be overriden.
]]
function qts.register_torch(name, def)
	local sound_flood = def.sound_flood
	def.sound_flood = nil

	def.drawtype = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "wallmounted"
    def.use_texture_alpha = def.use_texture_alpha or "clip"
	def.groups.torch = 1
	def.groups.attached_node = 1
	def.sunlight_propagates = true
	def.on_rotate = false

	--in case they forget the light.....
	def.light_source = def.light_source or 12

	local torch_main_def = qts.table_deep_copy(def)
	torch_main_def.mesh = "torch_floor.obj"
	torch_main_def.selection_box = {
		type = "wallmounted",
		wall_bottom = {-3/16, -1/2, -3/16, 3/16, 7/16, 3/16},
	}
	torch_main_def.on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local def = minetest.registered_nodes[node.name]
		if def and def.on_rightclick and
			not (placer and placer:is_player() and
			placer:get_player_control().sneak) then
			return def.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		local above = pointed_thing.above
		local wdir = minetest.dir_to_wallmounted(vector.subtract(under, above))
		local fakestack = itemstack
		if wdir == 0 then
			fakestack:set_name(name.."_ceiling")
		elseif wdir == 1 then
			fakestack:set_name(name)
		else
			fakestack:set_name(name.."_wall")
		end

		itemstack = minetest.item_place(fakestack, placer, pointed_thing, wdir)
		itemstack:set_name(name)

		return itemstack
	end

	minetest.register_node(name, torch_main_def)


	local torch_wall_def = qts.table_deep_copy(def)
	torch_wall_def.groups.not_in_creative_inventory = 1
	torch_wall_def.mesh = "torch_wall.obj"
	torch_wall_def.selection_box = {
		type = "wallmounted",
		wall_side = {-1/2, -1/2, -3/16, 0, 5/16, 3/16},
	}
	torch_wall_def.drop = name
	minetest.register_node(name.."_wall", torch_wall_def)


	local torch_ceil_def = qts.table_deep_copy(def)

	torch_ceil_def.groups.not_in_creative_inventory = 1
	torch_ceil_def.mesh = "torch_ceiling.obj"
	torch_ceil_def.selection_box = {
		type = "wallmounted",
		wall_top = {-3/16, -1/2, -3/16, 3/16, 7/16, 3/16},
	}
	torch_ceil_def.drop = name
	minetest.register_node(name.."_ceiling", torch_ceil_def)

end
--END torch





--[[
	A few nodes for utility purposes. 
	
qts:void
	used to fill nodes from placement, particularly when they are
	graphically occupied by other nodes, such as the top half of doors, beds, etc
	does not block player movement 
--]]

minetest.register_node("qts:void", {
	description = "Passible void block",
	drawtype = "airlike",
	inventory_image = "void.png",
	wield_image = "void.png",
	use_texture_alpha = "clip",
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	climbable = false,
	buildable_to=false,
	groups = {utility_node=1, not_in_creative_inventory=1}
})

if qts.ISDEV then
	minetest.register_chatcommand("clrvoid",{
		params="",
		privs={creative=true},
		func=function(name, param)
			local player = minetest.get_player_by_name(name)
			local pos = player:get_pos()
			local node = minetest.get_node_or_nil(pos)
			if node and node.name=="qts:void" then
				minetest.set_node(pos, {name="air"})
				minetest.log("void cleared.")
			else
				minetest.log("not void at your pos!")
			end
		end
	})

end