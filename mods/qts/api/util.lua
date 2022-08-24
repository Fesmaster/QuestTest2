


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
	
	for groups, using
	"group:wood 4"
	means that the node must have group wood equal to 4 or greater
	
	TODO: Possible change so that it prioritizes the closest node that matches the criteria
--]]
function qts.is_node_in_radius(pos, radius, nodename)
	if pos == nil or radius == nil or nodename == nil then return nil end
	local IS = ItemStack(nodename)
	nodename = IS:get_name()
	local count = IS:get_count()
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
				if (minetest.get_item_group(nref.name, nodename) >= count) then
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
		
		points[#points+1] = vector.new(x, y, z)
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
--]]
function qts.inv_contains_group(inv, groupString, ignoreNames)
	if not ignoreNames then ignoreNames = {} end
	local groupStack = ItemStack(groupString)
	--local minlevel = groupStack:get_count()
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
--[[
qts.inv_take_group(inv, groupString, [ignoreNames])  
	Take items from inv that match group  
	Does not take any if there are not enough to remove  
	inv - inventory userdata  
	groupString - "group:groupname <count>"  
	ignoreNames - set of names to ignore {["name"]=1 ... }  
]]
function qts.inv_take_group(inv, groupString, ignoreNames)
	if not ignoreNames then ignoreNames = {} end
	local groupStack = ItemStack(groupString)
	--local minlevel = groupStack:get_count()
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


--[[
qts.objects_overlapping(objA, objB)  
	checks to see if the collisionbox of objA and objB are overlapping.  
	highly accurate Axis-Alligned Bounding Box overlapping  
	  
	Params:   
	objA - objref, the first entity  
	objB - objref, the second entity  
	  
	Return: true or false  
]]
function qts.objects_overlapping(objA, objB)
	--get bounding boxes
	local propsA = objA:get_properties()
	local propsB = objB:get_properties()
	local posA = objA:get_pos()
	local posB = objB:get_pos()
	
	local minA = {
		x= posA.x + propsA.collisionbox[1],
		y= posA.y + propsA.collisionbox[2],
		z= posA.z + propsA.collisionbox[3],
	}
	local maxA = {
		x= posA.x + propsA.collisionbox[4],
		y= posA.y + propsA.collisionbox[5],
		z= posA.z + propsA.collisionbox[6],
	}
	local minB = {
		x= posB.x + propsB.collisionbox[1],
		y= posB.y + propsB.collisionbox[2],
		z= posB.z + propsB.collisionbox[3],
	}
	local maxB = {
		x= posB.x + propsB.collisionbox[4],
		y= posB.y + propsB.collisionbox[5],
		z= posB.z + propsB.collisionbox[6],
	}
	--check for collision
	return (
		(minA.x < maxB.x and  maxA.x >= minB.x) and
		(minA.y < maxB.y and  maxA.y >= minB.y) and
		(minA.z < maxB.z and  maxA.z >= minB.z)
	)
end



function qts.apply_default_wear(name, itemstack)
	local nlvl = minetest.get_item_group(name, "level")
	local hlvl = minetest.get_item_group(itemstack:get_name(), "level")
	local mult = (hlvl-nlvl)^3
	if mult == 0 then mult = 1 end
	local def = minetest.registered_tools[itemstack:get_name()]
	if def and def.tool_capabilities and def.tool_capabilities.groupcaps then
		local uses = 0
		local groupscount=0
		for name, groupcap in pairs(def.tool_capabilities.groupcaps) do
			uses = uses + groupcap.uses
			groupscount = groupscount +1
		end
		uses = uses / groupscount
		local wear = qts.WEAR_MAX / (uses * mult)
		if not itemstack:set_wear(itemstack:get_wear() + wear) then
			itemstack:take_item()
		end
	end
	return itemstack
end


local function rect_iter(pos1, pos2)
	for x = pos1.x, pos2.x, (pos1.x < pos2.x) and 1 or -1  do
		for y = pos1.y, pos2.y, (pos1.y < pos2.y) and 1 or -1 do
			for z = pos1.z, pos2.z, (pos1.z < pos2.z) and 1 or -1 do
				coroutine.yield(vector.new(x,y,z))
			end
		end
	end
	return nil
end

local function columns_iter(pos1, pos2)
	for x = pos1.x, pos2.x, (pos1.x < pos2.x) and 1 or -1  do
		for z = pos1.z, pos2.z, (pos1.z < pos2.z) and 1 or -1 do
			for y = pos1.y, pos2.y, (pos1.y < pos2.y) and 1 or -1 do
				coroutine.yield(vector.new(x,y,z))
			end
		end
	end
	return nil
end

function qts.rectangle(pos1, pos2)
	local co = coroutine.create(rect_iter)
	
	return function()
		local state, value = coroutine.resume(co, pos1, pos2)
		if state then 
			return value 
		else
			return nil
		end
	end
end

function qts.columns(pos1, pos2)
	local co = coroutine.create(columns_iter)
	
	return function()
		local state, value = coroutine.resume(co, pos1, pos2)
		if state then 
			return value 
		else
			return nil
		end
	end
end

function qts.insert3(t, pos, item)
	t = t or {}
	t[pos.x] = t[pos.x] or {}
	t[pos.x][pos.y] = t[pos.x][pos.y] or {}
	t[pos.x][pos.y][pos.z] = item
	return t
end

function qts.read3(t, pos)
	if not t[pos.x] then return nil end
	if not t[pos.x][pos.y] then return nil end
	return t[pos.x][pos.y][pos.z]
end

function qts.readNodes(pos1, pos2)
	local t = {}
	pos1, pos2 = vector.sort(pos1, pos2)
	for p in qts.rectangle(pos1, pos2) do
		t = qts.insert3(t, p-pos1, minetest.get_node_or_nil(p))
	end
	return t
end

function qts.writeNodes(pos1, pos2, tbl)
	pos1, pos2 = vector.sort(pos1, pos2)
	for p in qts.rectangle(pos1, pos2) do
		local node = qts.read3(tbl, p-pos1)
		local actual = minetest.get_node_or_nil(p)
		if node and actual and (node.name ~= actual.name or node.param2 ~= actual.param2) then
			minetest.set_node(p, node)
		end
	end
end

--zero-based indexing.
local function zpairs(tbl)
	local i = 0
	return function()
		local rval = tbl[i]
		if rval then
			i = i+1
			return i-1, rval
		end
	end
end


local function nodePairs_iter(tbl)
	for x, t2 in zpairs(tbl) do
		for y, t3 in zpairs(t2) do
			for z, node in zpairs(t3) do
				coroutine.yield(vector.new(x,y,z), node)
			end
		end
	end
	return nil
end

function qts.nodePairs(tbl)
	local co = coroutine.create(nodePairs_iter)
	
	return function()
		local status, pos, node = coroutine.resume(co, tbl)
		if status then
			return pos, node
		else
			return nil, nil
		end
	end
end

--[[
	This function is desighed to be set as the value of the item `on_place` callback, to operate rightclickable items if pointing at them, or do the `on_secondary_use` callback if not.
]]
function qts.item_place_check_and_propigate(itemstack, placer, pointed_thing)
	if pointed_thing.under then
		local node = minetest.get_node_or_nil(pointed_thing.under)
		if node then
			local def = minetest.registered_nodes[node.name]
			if def and def.on_rightclick then
				return def.on_rightclick(pointed_thing.under, node, placer, itemstack, pointed_thing)
			end 
		end
	end
	local def = minetest.registered_items[itemstack:get_name()]
	if def and def.on_secondary_use then
		return def.on_secondary_use(itemstack, placer, pointed_thing)
	end
end

--Item Eating

function qts.item_eat(hpchange, replace_with_item)
	return function(itemstack, user, pointed_thing)
		return qts.do_item_eat(hpchange, replace_with_item, itemstack, user, pointed_thing)
	end
end
--register_on_item_eat
function qts.do_item_eat(hpchange, replace_with_item, itemstack, user, pointed_thing)
	if user:is_player() then
		local playerHP = qts.get_player_hp(user)
		local playerHPMax = qts.get_player_hp_max(user)
		if playerHP < playerHPMax then
			if minetest.registered_on_item_eat then
				for _, func in ipairs(minetest.registered_on_item_eat) do
					local rval = func(hpchange, replace_with_item, itemstack, user, pointed_thing)
					--assume rval is an itemstack
					if rval then
						return rval
					end
				end
			end
			--do health increas
			itemstack:take_item(1)
			local inv = user:get_inventory()
			inv:add_item("main", ItemStack(replace_with_item))
			qts.set_player_hp(user, playerHP+hpchange, "set_hp")
		end
	end
	return itemstack
end
--backcompatability
minetest.do_item_eat = qts.do_item_eat
minetest.item_eat = qts.item_eat



--prevent all functions registered by minetest.register_allow_player_inventory_action from collobering each other.

local old_register_allow_player_inventory_action = minetest.register_allow_player_inventory_action
local registered_allowed_inventory_move_funcs = {}
minetest.register_allow_player_inventory_action = function(func)
    table.insert(registered_allowed_inventory_move_funcs, func)
end
old_register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
	local min
	for k, v in ipairs(registered_allowed_inventory_move_funcs) do
		local val = v(player, action, inventory, inventory_info)
		if val and (not min or val < min) then
			min = val
		end
	end
	return min or 0
end)