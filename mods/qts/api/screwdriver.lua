--screwdriver functionality
--this has been copied from the screwdriver mod from minetest_game
--and brought under the qts namespace
--license lgpl (see QT2's license)

qts.screwdriver = {}
qts.screwdriver.ROTATE_FACE = 1
qts.screwdriver.ROTATE_AXIS = 2
qts.screwdriver.disallow = function(pos, node, user, mode, new_param2)
	return false
end
qts.screwdriver.rotate_simple = function(pos, node, user, mode, new_param2)
	if mode ~= qts.screwdriver.ROTATE_FACE then
		return false
	end
end

-- For attached wallmounted nodes: returns true if rotation is valid
-- simplified version of minetest:builtin/game/falling.lua#L148.
local function check_attached_node(pos, rotation)
	local d = minetest.wallmounted_to_dir(rotation)
	local p2 = vector.add(pos, d)
	local n = minetest.get_node(p2).name
	local def2 = minetest.registered_nodes[n]
	if def2 and not def2.walkable then
		return false
	end
	return true
end

qts.screwdriver.rotate = {}

local facedir_tbl = {
	[qts.screwdriver.ROTATE_FACE] = {
		[0] = 1, [1] = 2, [2] = 3, [3] = 0,
		[4] = 5, [5] = 6, [6] = 7, [7] = 4,
		[8] = 9, [9] = 10, [10] = 11, [11] = 8,
		[12] = 13, [13] = 14, [14] = 15, [15] = 12,
		[16] = 17, [17] = 18, [18] = 19, [19] = 16,
		[20] = 21, [21] = 22, [22] = 23, [23] = 20,
	},
	[qts.screwdriver.ROTATE_AXIS] = {
		[0] = 4, [1] = 4, [2] = 4, [3] = 4,
		[4] = 8, [5] = 8, [6] = 8, [7] = 8,
		[8] = 12, [9] = 12, [10] = 12, [11] = 12,
		[12] = 16, [13] = 16, [14] = 16, [15] = 16,
		[16] = 20, [17] = 20, [18] = 20, [19] = 20,
		[20] = 0, [21] = 0, [22] = 0, [23] = 0,
	},
}

qts.screwdriver.rotate.facedir = function(pos, node, mode)
	local rotation = node.param2 % 32 -- get first 5 bits
	local other = node.param2 - rotation
	rotation = facedir_tbl[mode][rotation] or 0
	return rotation + other
end

qts.screwdriver.rotate.colorfacedir = qts.screwdriver.rotate.facedir

local wallmounted_tbl = {
	[qts.screwdriver.ROTATE_FACE] = {[2] = 5, [3] = 4, [4] = 2, [5] = 3, [1] = 0, [0] = 1},
	[qts.screwdriver.ROTATE_AXIS] = {[2] = 5, [3] = 4, [4] = 2, [5] = 1, [1] = 0, [0] = 3}
}

qts.screwdriver.rotate.wallmounted = function(pos, node, mode)
	local rotation = node.param2 % 8 -- get first 3 bits
	local other = node.param2 - rotation
	rotation = wallmounted_tbl[mode][rotation] or 0
	if minetest.get_item_group(node.name, "attached_node") ~= 0 then
		-- find an acceptable orientation
		for i = 1, 5 do
			if not check_attached_node(pos, rotation) then
				rotation = wallmounted_tbl[mode][rotation] or 0
			else
				break
			end
		end
	end
	return rotation + other
end

qts.screwdriver.rotate.colorwallmounted = qts.screwdriver.rotate.wallmounted

-- Handles rotation
-- qts changed to be identical to hammer api and not contain extra functionality
qts.screwdriver.apply = function(pointed_thing, user, mode)
	local pos = pointed_thing.under
	local player_name = user:get_player_name() or ""
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return
	end

	local node = minetest.get_node(pos)
	local ndef = minetest.registered_nodes[node.name]
	if not ndef then
		return
	end
	-- can we rotate this paramtype2?
	local fn = qts.screwdriver.rotate[ndef.paramtype2]
	if not fn and not ndef.on_rotate then
		return
	end

	local should_rotate = true
	local new_param2
	if fn then
		new_param2 = fn(pos, node, mode)
	else
		new_param2 = node.param2
	end

	-- Node provides a handler, so let the handler decide instead if the node can be rotated
	if ndef.on_rotate then
		-- Copy pos and node because callback can modify it
		local result = ndef.on_rotate(vector.new(pos),
				{name = node.name, param1 = node.param1, param2 = node.param2},
				user, mode, new_param2)
		if result == nil then
			return
		elseif result == false then -- Disallow rotation
			should_rotate = false
		elseif result == true then
			should_rotate = true
		end
	elseif ndef.on_rotate == false then
		return
	elseif ndef.can_dig and not ndef.can_dig(pos, user) then
		return
	end

	if should_rotate and new_param2 ~= node.param2 then
		node.param2 = new_param2
		minetest.swap_node(pos, node)
		minetest.check_for_falling(pos)
	end
end
