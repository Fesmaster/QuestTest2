--shaped Nodes API
--some of this code is hevily based on the stairs mod in minetest_game
--liscensed under lgpl (see the liscense for QT2 in general)

qts.hammer = {}
function qts.hammer.rotate_and_place(itemstack, placer, pointed_thing)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0
	
	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end
		
		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1
		
		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end

function qts.hammer.rotate_and_set(placer, pointed_thing, node)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0
	
	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end
		
		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1
		
		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	minetest.set_node(p0, {name = node.name, param1 = node.param1, param2 = param2})
end

function qts.register_shaped_node(name, description, groups, images, sounds, drop, is_ground_content, worldAlignTex)
	--prep the data for node registration
	local imgs = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			imgs[i] = {
				name = image,
				backface_culling = true
			}
			if worldAlignTex then
				imgs[i].align_style = "world"
			end
		else
			imgs[i] = table.copy(image)
			if imgs[i].backface_culling == nil then
				img[i].backface_culling = true
			end
			if worldAlignTex and imgs[i].align_style == nil then
				img[i].align_style = "world"
			end
		end
	end
	
	local drop_override = name
	if drop then
		drop_override = drop
	end
	
	
	--groups setup
	local groups_int = table.copy(groups)
	groups_int.shaped_node = 1
	
	--SOLID-----------------------
	
	local groups_dyn = table.copy(groups_int)
	groups_dyn.shaped_full = 1
	
	minetest.register_node(":"..name, {
		description = description,
		tiles =imgs,
		is_ground_content = is_ground_content,
		groups = groups_dyn,
		sounds = sounds,
		drop = drop_override,
	})
	
	--STAIR-----------------------
	
	groups_dyn = table.copy(groups_int)
	groups_dyn.shaped_stair = 1
	
	minetest.register_node(":" .. name .."_stair", {
		description = description,
		drawtype = "nodebox",
		tiles = imgs,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = is_ground_content,
		groups = groups_dyn,
		sounds = sounds,
		drop = drop_override,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})
	
	--STAIR INNER-----------------------
	
	minetest.register_node(":" .. name.."_stair_inner", {
		description = description,
		drawtype = "nodebox",
		tiles = imgs,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups_dyn,
		sounds = sounds,
		drop = drop_override,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
				{-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})
	
	--STAIR OUTER-----------------------
	
	minetest.register_node(":" .. name.."_stair_outer", {
		description = description,
		drawtype = "nodebox",
		tiles = imgs,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups_dyn,
		sounds = sounds,
		drop = drop_override,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			return rotate_and_place(itemstack, placer, pointed_thing)
		end,
	})
	
	
	--SLAB-----------------------
	
	groups_dyn = table.copy(groups_int)
	groups_dyn.shaped_slab = 1
	
	minetest.register_node(":"..name.."_slab", {
		description = description,
		drawtype = "nodebox",
		tiles = imgs,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = groups_dyn,
		sounds = sounds,
		drop = drop_override,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
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
				if not creative_enabled then--TODO: update creative API
					itemstack:take_item()
				end
				return itemstack
			else
				return rotate_and_place(itemstack, placer, pointed_thing)
			end
		end,
	})
	
	--TODO: implement more shapes
	
	
	
end

qts.hammer.CHANGE_TYPE = 1
qts.hammer.CHANGE_STYLE = 2
function qts.hammer.apply(pointed_thing, user, mode)
	if not mode then mode = 1 end
	local player_name = user:get_player_name() or ""
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return
	end
	local pos = pointed_thing.under
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "shaped_node") >= 1 then
		if node.name:find("_stair") then
			if mode and mode == 2 then
				--change corner mode
				if node.name:find("_inner") then
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_inner", "_outer"),param1 = node.param1, param2 = node.param2})
				elseif node.name:find("_outer") then
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_outer", ""),param1 = node.param1, param2 = node.param2})
				else
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name.."_inner",param1 = node.param1, param2 = node.param2})
				end
			else
				--stair-->slab
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_stair", "_slab"):gsub("_inner", ""):gsub("_outer", ""),param1 = node.param1, param2 = node.param2})
			end
			
		elseif node.name:find("_slab") then
			--slab --> whole
			qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_slab", ""),param1 = node.param1, param2 = node.param2})
		else
			--whole --> stair
			qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name.."_stair",param1 = node.param1, param2 = node.param2})
		end
		--TODO: implement any added shapes into the hammer functionality
	end
end