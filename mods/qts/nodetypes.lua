function qts.register_shaped_node(name, def)
	--prep the data for node registration
	local imgs = {}
	for i, image in ipairs(def.tiles) do
		if type(image) == "string" then
			imgs[i] = {
				name = image,
				backface_culling = true,
				align_style = "world"
			}
		else
			imgs[i] = table.copy(image)
			if imgs[i].backface_culling == nil then
				img[i].backface_culling = true
				img[i].align_style = "world"
			end
		end
	end
	def.tiles = imgs --overwrite old tiles
	if def.drop == nil then def.drop = name end --setup drops
	
	--groups setup
	def.groups.shaped_node = 1
	--SOLID-----------------------
	def.groups.shaped_full = 1
	minetest.register_node(":"..name, qts.table_deep_copy(def))
	--STAIR-----------------------
	--change def to get various drawtypes etc
	def.groups.not_in_creative_inventory = 1
	def.groups.shaped_full = nil
	def.groups.shaped_stair = 1
	def.drawtype = "nodebox"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
		},
	}
	def.on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		return qts.hammer.rotate_and_place(itemstack, placer, pointed_thing)
	end
	minetest.register_node(":" .. name .."_stair", qts.table_deep_copy(def))
	--STAIR INNER-----------------------
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			{-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
		},
	}
	minetest.register_node(":" .. name.."_stair_inner", qts.table_deep_copy(def))
	--STAIR OUTER-----------------------
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			{-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
		},
	}
	minetest.register_node(":" .. name.."_stair_outer", qts.table_deep_copy(def))
	--SLANT-----------------------
	def.groups.shaped_stair = nil
	def.groups.shaped_slant = 1
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4375, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.375, 0.375, 0.5, 0.4375, 0.5}, -- NodeBox2
			{-0.5, 0.3125, 0.3125, 0.5, 0.375, 0.5}, -- NodeBox3
			{-0.5, 0.25, 0.25, 0.5, 0.3125, 0.5}, -- NodeBox4
			{-0.5, 0.1875, 0.1875, 0.5, 0.25, 0.5}, -- NodeBox5
			{-0.5, 0.125, 0.125, 0.5, 0.1875, 0.5}, -- NodeBox6
			{-0.5, 0.0625, 0.0625, 0.5, 0.125, 0.5}, -- NodeBox7
			{-0.5, 0, 0, 0.5, 0.0625, 0.5}, -- NodeBox8
			{-0.5, -0.0625, -0.0625, 0.5, 0, 0.5}, -- NodeBox9
			{-0.5, -0.125, -0.125, 0.5, -0.0625, 0.5}, -- NodeBox10
			{-0.5, -0.1875, -0.1875, 0.5, -0.125, 0.5}, -- NodeBox11
			{-0.5, -0.25, -0.25, 0.5, -0.1875, 0.5}, -- NodeBox12
			{-0.5, -0.3125, -0.3125, 0.5, -0.25, 0.5}, -- NodeBox13
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, -- NodeBox14
			{-0.5, -0.4375, -0.4375, 0.5, -0.375, 0.5}, -- NodeBox15
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox16
		},
	}
	minetest.register_node(":" .. name.."_slant", qts.table_deep_copy(def))
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4375, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.375, 0.375, 0.5, 0.4375, 0.5}, -- NodeBox3
			{-0.5, 0.3125, 0.3125, 0.5, 0.375, 0.5}, -- NodeBox4
			{-0.5, 0.25, 0.25, 0.5, 0.3125, 0.5}, -- NodeBox5
			{-0.5, 0.1875, 0.1875, 0.5, 0.25, 0.5}, -- NodeBox6
			{-0.5, 0.125, 0.125, 0.5, 0.1875, 0.5}, -- NodeBox7
			{-0.5, 0.0625, 0.0625, 0.5, 0.125, 0.5}, -- NodeBox8
			{-0.5, 0, 0, 0.5, 0.0625, 0.5}, -- NodeBox9
			{-0.5, -0.0625, -0.0625, 0.5, 0, 0.5}, -- NodeBox10
			{-0.5, -0.125, -0.125, 0.5, -0.0625, 0.5}, -- NodeBox11
			{-0.5, -0.1875, -0.1875, 0.5, -0.125, 0.5}, -- NodeBox12
			{-0.5, -0.25, -0.25, 0.5, -0.1875, 0.5}, -- NodeBox13
			{-0.5, -0.3125, -0.3125, 0.5, -0.25, 0.5}, -- NodeBox14
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, -- NodeBox15
			{-0.5, -0.4375, -0.4375, 0.5, -0.375, 0.5}, -- NodeBox16
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox17
			{0.4375, 0.4375, -0.5, 0.5, 0.5, 0.4375}, -- NodeBox18
			{0.375, 0.375, -0.5, 0.5, 0.4375, 0.375}, -- NodeBox19
			{0.3125, 0.3125, -0.5, 0.5, 0.375, 0.3125}, -- NodeBox20
			{0.25, 0.25, -0.5, 0.5, 0.3125, 0.25}, -- NodeBox21
			{0.1875, 0.1875, -0.5, 0.5, 0.25, 0.1875}, -- NodeBox22
			{0.125, 0.125, -0.5, 0.5, 0.1875, 0.125}, -- NodeBox23
			{0.0625, 0.0625, -0.5, 0.5, 0.125, 0.0625}, -- NodeBox24
			{0, 0, -0.5, 0.5, 0.0625, 0}, -- NodeBox25
			{-0.0625, -0.0625, -0.5, 0.5, 0, -0.0625}, -- NodeBox26
			{-0.125, -0.125, -0.5, 0.5, -0.0625, -0.125}, -- NodeBox27
			{-0.1875, -0.1875, -0.5, 0.5, -0.125, -0.1875}, -- NodeBox28
			{-0.25, -0.25, -0.5, 0.5, -0.1875, -0.25}, -- NodeBox29
			{-0.3125, -0.3125, -0.5, 0.5, -0.25, -0.3125}, -- NodeBox30
			{-0.375, -0.375, -0.5, 0.5, -0.3125, -0.375}, -- NodeBox31
			{-0.4375, -0.4375, -0.5, 0.5, -0.375, -0.4375}, -- NodeBox32
		},
	}
	minetest.register_node(":" .. name.."_slant_inner", qts.table_deep_copy(def))
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4375, 0.4375, -0.4375, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.375, 0.375, -0.375, 0.4375, 0.5}, -- NodeBox3
			{-0.5, 0.3125, 0.3125, -0.3125, 0.375, 0.5}, -- NodeBox4
			{-0.5, 0.25, 0.25, -0.25, 0.3125, 0.5}, -- NodeBox5
			{-0.5, 0.1875, 0.1875, -0.1875, 0.25, 0.5}, -- NodeBox6
			{-0.5, 0.125, 0.125, -0.125, 0.1875, 0.5}, -- NodeBox7
			{-0.5, 0.0625, 0.0625, -0.0625, 0.125, 0.5}, -- NodeBox8
			{-0.5, 0, 0, 0, 0.0625, 0.5}, -- NodeBox9
			{-0.5, -0.0625, -0.0625, 0.0625, 0, 0.5}, -- NodeBox10
			{-0.5, -0.125, -0.125, 0.125, -0.0625, 0.5}, -- NodeBox11
			{-0.5, -0.1875, -0.1875, 0.1875, -0.125, 0.5}, -- NodeBox12
			{-0.5, -0.25, -0.25, 0.25, -0.1875, 0.5}, -- NodeBox13
			{-0.5, -0.3125, -0.3125, 0.3125, -0.25, 0.5}, -- NodeBox14
			{-0.5, -0.375, -0.375, 0.375, -0.3125, 0.5}, -- NodeBox15
			{-0.5, -0.4375, -0.4375, 0.4375, -0.375, 0.5}, -- NodeBox16
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox17
		},
	}
	minetest.register_node(":" .. name.."_slant_outer", qts.table_deep_copy(def))
	--SLAB-----------------------
	def.groups.shaped_slant = nil
	def.groups.shaped_slab = 1
	def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	}
	def.on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		local wield_item = itemstack:get_name()
		local player_name = placer and placer:get_player_name() or ""
		local creative_enabled = (creative and creative.is_enabled_for
				and creative.is_enabled_for(player_name)) --TODO: update creative API

		if under and under.name:find("_slab") then
			-- place slab using under node orientation
			local dir = minetest.dir_to_facedir(vector.subtract(
				pointed_thing.above, pointed_thing.under), true)

			local p2 = under.param2

			-- Placing a slab on an upside down slab should make it right-side up.
			if p2 >= 20 and dir == 8 then
				p2 = p2 - 20
			-- same for the opposite case: slab below normal slab
			elseif p2 <= 3 and dir == 4 then
				p2 = p2 + 20
			end

			-- else attempt to place node with proper param2
			minetest.item_place_node(ItemStack(wield_item), placer, pointed_thing, p2)
			if not creative_enabled then
				itemstack:take_item()
			end
			return itemstack
		else
			return qts.hammer.rotate_and_place(itemstack, placer, pointed_thing)
		end
	end
	
	minetest.register_node(":"..name.."_slab", qts.table_deep_copy(def))
	--TODO: implement more shapes
end

local fence_collision_extra = minetest.settings:get_bool("enable_fence_tall") and 3/8 or 0
function qts.register_fencelike_node(name, def)
	
	if not def.type then minetest.log("qts.register_fencelike_node: the node def must contain type = [fence, rail, wall, pane]") end
	if not def.texture then minetest.log("qts.register_fencelike_node: instead of using tiles = {}, use texture = \"texturename\". This works better.") end
	
	local default_fields = {}
	--fence style
	if def.type == "fence" then
		local fence_texture = "default_fence_overlay.png^" .. def.texture ..
				"^default_fence_overlay.png^[makealpha:255,126,126"
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
			connects_to = {"group:fence", "group:wood", "group:tree", "group:wall"},
			inventory_image = fence_texture,
			wield_image = fence_texture,
			tiles = {def.texture},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {},
		}
		-- Always add to the fence group, even if no group provided
		def.groups.fence = 1

	elseif def.type == "rail" then
		local fence_rail_texture = "default_fence_rail_overlay.png^" .. def.texture ..
				"^default_fence_rail_overlay.png^[makealpha:255,126,126"
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
			connects_to = {"group:fence", "group:wall"},
			inventory_image = fence_rail_texture,
			wield_image = fence_rail_texture,
			tiles = {def.texture},
			sunlight_propagates = true,
			is_ground_content = false,
			groups = {},
		}
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
			connects_to = { "group:wall", "group:stone", "group:fence" },
			tiles = {def.texture},
			sunlight_propagates = true,
			is_ground_content = false,
			walkable = true,
			groups = {},
		}
		def.groups.wall = 1
	elseif def.type == "pane" then
	
		default_fields = {
			paramtype = "light",
			--paramtype2 = "facedir",
			drawtype = "nodebox",
			node_box = {
				type = "connected",
				fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
				connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
				connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
				connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
				connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
			},
			collision_box = {
				type = "connected",
				fixed = {{-1/32, -1/2, -1/32, 1/32, 1/2, 1/32}},
				connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
				connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
				connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
				connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
			},
			connects_to = {"group:pane", "group:stone", "group:glass", "group:wood", "group:tree"},
			tiles = {def.texture},
			inventory_image = def.texture,
			wield_image = def.texture,
			sunlight_propagates = true,
			is_ground_content = false,
			use_texture_alpha = true,
			walkable = true,
			groups = {},
		}
		def.groups.pane = 1
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
	minetest.register_node(name, def)
end

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
	minetest.register_craftitem(bucket_data.name .. to_bucket_name(liquid_data.name), {
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




function qts.register_liquid(name, def)
	local defaults = {
		waving = 3,
		paramtype = "light",
		alpha = 191, --default transperancy
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquid_alternative_flowing = name.."_flowing",
		liquid_alternative_source = name.."_source",
		liquid_viscosity = 1,
		post_effect_color = {a = 103, r = 30, g = 60, b = 90},
		groups = {}
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
	minetest.register_node(":"..name.."_flowing", qts.table_deep_copy(def))
	
	--now, backpropigate already registered buckets
	for bk_id, bk in ipairs(bucket_cache) do
		register_bucket_full(bk_id, self_id)
	end
end

--this func is MUCH more locked in than any of the other.
--[[
	def contains:
		description
		inventory_image
		groups {bucket_level >= 1}
--]]
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

