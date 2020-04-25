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
	local other = node.param2 - node.param2 % 32 --everything but the first five bits
	
	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end
		
		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y - math.floor(p0.y)
		minetest.log("Face pos:"..tostring(fpos))
		
		if p0.y - 1 == p1.y or (fpos > -1 and fpos < 0 and not(placer:get_pos().y+1 > p0.y))then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.swap_node(p0, {name = node.name, param1 = node.param1, param2 = param2+other}) --last bit of param2 data added back in
end

--deep copy func, that is from lua-users.org  https://lua-users.org/wiki/CopyTable
function qts.table_deep_copy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[qts.table_deep_copy(orig_key, copies)] = qts.table_deep_copy(orig_value, copies)
            end
            setmetatable(copy, qts.table_deep_copy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

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

qts.hammer.CHANGE_TYPE = 1
qts.hammer.CHANGE_STYLE = 2
function qts.hammer.apply(pointed_thing, user, mode)
	if not mode then mode = qts.hammer.CHANGE_TYPE end
	local player_name = user:get_player_name() or ""
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return
	end
	local pos = pointed_thing.under
	local node = minetest.get_node(pos)
	if minetest.get_item_group(node.name, "shaped_node") >= 1 then
		if node.name:find("_stair") then
			if mode and mode == qts.hammer.CHANGE_STYLE then
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
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_stair", "_slant"),param1 = node.param1, param2 = node.param2})
			end
		elseif node.name:find("_slant") then
			if mode and mode == qts.hammer.CHANGE_STYLE then
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
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_slant", "_slab"):gsub("_inner", ""):gsub("_outer", ""),param1 = node.param1, param2 = node.param2})
			end
		elseif node.name:find("_slab") then
			--slab --> whole
			if mode == qts.hammer.CHANGE_TYPE then
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_slab", ""),param1 = node.param1, param2 = node.param2})
			end
		else
			--whole --> stair
			if mode == qts.hammer.CHANGE_TYPE then
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name.."_stair",param1 = node.param1, param2 = node.param2})
			end
		end
		--TODO: implement any added shapes into the hammer functionality
	end
end