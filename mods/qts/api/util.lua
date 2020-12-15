

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

function qts.get_nodes_in_radius(pos, radius)
	if pos ~= nil and radius ~= nil then
		local ntable = {}
		local counter = 1
		for x = -radius, radius do
		for y = -radius, radius do
		for z = -radius, radius do
			local dist = ((x^2)+(y^2)+(z^2))^0.5
			if qts.nearly_equal(dist, radius, 0.5) or dist <= radius then
				local npos = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local nref = minetest.get_node(npos)
				ntable[counter]={}
				ntable[counter].pos = npos
				ntable[counter].noderef = nref
				counter = counter+1
			end
		end
		end
		end
		return ntable
	else
		return nil
	end
end

function qts.get_nodes_on_radius(pos, radius)
	if pos ~= nil and radius ~= nil then
		local ntable = {}
		local counter = 1
		for x = -radius, radius do
		for y = -radius, radius do
		for z = -radius, radius do
			local dist = ((x^2)+(y^2)+(z^2))^0.5
			if qts.nearly_equal(dist, radius, 0.5) then
				local npos = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local nref = minetest.get_node(npos)
				ntable[counter]={}
				ntable[counter].pos = npos
				ntable[counter].noderef = nref
				counter = counter+1
			end
		end
		end
		end
		return ntable
	else
		return nil
	end
end

--[[
	Finds if a nodename or a node of group group:name is in a radius around pos.
	If it finds one, then it returns the position.
	
	TODO: Possible change so that it prioritizes the closest node that matches the criteria
--]]
function qts.is_node_in_radius(pos, radius, nodename)
	if pos == nil or radius == nil or nodename == nil then return nil end
	local isGroup = qts.is_group(nodename)
	if (isGroup) then
		nodename = qts.remove_modname_from_item(nodename)
	end
	for x = -radius, radius do
	for y = -radius, radius do
	for z = -radius, radius do
		local dist = ((x^2)+(y^2)+(z^2))^0.5
		if qts.nearly_equal(dist, radius, 0.5) or dist <= radius then
			local npos = {x=pos.x+x,y=pos.y+y,z=pos.z+z}
			local nref = minetest.get_node(npos)
			
			if (isGroup) then
				if (minetest.get_item_group(nref.name, nodename) ~= 0) then
					return npos
				end
			else
				if nref.name == nodename then
					return npos
				end
			end
		end
	end
	end
	end
	return nil
end

--get an even distribution of # of points on a sphere. sphere's radius is 1
function qts.distribute_points_on_sphere(point_count)
	local points = {}
	
	local phi = math.pi * (3 - math.sqrt(5)) --golden angle in randians
	
	for i = 0, point_count do
		
		local y = 1 - (i / (point_count-1)) * 2 --  1 to -1
		local radius = math.sqrt(1 - y*y)
		local theta = phi * i
		
		local x = math.cos(theta) * radius
		local z = math.sin(theta) * radius
		
		points[#points+1] = {x=x, y=y, z=z}
	end
	
	return points
end

function qts.pickup_sound(player)
	if (type(player) ~= "string") then player = player:get_player_name() end
	minetest.sound_play("pickup", {
		to_player = player,
		gain = 1.0,
	})
end

function qts.ignite(pos)
	minetest.log("qts.ignite should be implemented in default mod")
end

function qts.get_modname_from_item(itemname)
	return string.match(itemname, '([%w_]*):')
end

function qts.remove_modname_from_item(itemname)
	return string.match(itemname, ':([%w_]*)')
end

function qts.is_group(itemname)
	return (qts.get_modname_from_item(itemname) == "group")
end

--[[

qts.inv_contains_group(inv, groupString, [ignoreNames])
	Search an inventory for items in a specific group
	inv - inventory userdata
	groupString - "group:groupname <count>"
	ignoreNames - set of names to ignore {["name"]=1 ... }
	
qts.inv_take_group(inv, groupString, [ignoreNames])
	Take items from inv that match group
	Does not take any if there are not enough to remove
	inv - inventory userdata
	groupString - "group:groupname <count>"
	ignoreNames - set of names to ignore {["name"]=1 ... }
--]]

function qts.inv_contains_group(inv, groupString, ignoreNames)
	if not ignoreNames then ignoreNames = {} end
	local groupStack = ItemStack(groupString)
	if (qts.get_modname_from_item(groupStack:get_name()) ~= "group") then return nil end --not a group.
	local groupname = qts.remove_modname_from_item(groupStack:get_name())
	local itemList = inv:get_list("main")
	local count = groupStack:get_count()
	for k, v in ipairs(itemList) do
		local groupValue = minetest.get_item_group(v:get_name(), groupname)
		if (groupValue ~= 0 and not(ignoreNames[v:get_name()])) then
			if (v:get_count() > count) then
				--found all remining
				return true
			else
				--found some
				count = count - v:get_count()
			end
		end
	end
	if (count > 0) then
		return false
	end
	return true
end

function qts.inv_take_group(inv, groupString, ignoreNames)
	if not ignoreNames then ignoreNames = {} end
	local groupStack = ItemStack(groupString)
	if (qts.get_modname_from_item(groupStack:get_name()) ~= "group") then return nil end --not a group.
	local groupname = qts.remove_modname_from_item(groupStack:get_name())
	local itemList = inv:get_list("main")
	local removeList = {}
	local count = groupStack:get_count()
	for k, v in ipairs(itemList) do
		local groupValue = minetest.get_item_group(v:get_name(), groupname)
		if (groupValue ~= 0 and not(ignoreNames[v:get_name()])) then
			if (v:get_count() > count) then
				--remove some
				removeList[#removeList+1] = ItemStack(v:get_name())
				removeList[#removeList]:set_count(count)
				v:set_count(v:get_count() - count)
				count = 0
				break
			else
				--remove all
				removeList[#removeList+1] = ItemStack(v:get_name())
				removeList[#removeList]:set_count(v:get_count())
				count = count - v:get_count()
				v:set_count(0)
			end
		end
	end
	if (count > 0) then
		return nil
	end
	inv:set_list("main", itemList)
	return removeList
end


