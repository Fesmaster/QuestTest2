


--
--[[
	recursive deep copy func, that can deal with repeated subtables and metatables
	Note that the metatable is also copied.
	from lua-users.org  https://lua-users.org/wiki/CopyTable

	Params:
		orig - the table to copy
		copies - a param for the recursive system. DO NOT PASS ANYTHING HERE

	Returns:
		a true deep copy of the table.
]]
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

--[[
	make a read only table from the passed table
	from http://lua-users.org/wiki/ReadOnlyTables
	See that location for caviats and problems (IE, ipairs and pairs not working)
	the new table is not a true copy, but uses the original for its data.
	the original is kept as an upvalue, so feel free to let it go out of scope or be overriden
	any change to it will change the resulting readonly table!

	Params;
		tbl - the table to make a readonly copy of

	Returns:
		read-only table
]]
function qts.readonly_table(tbl)
	return setmetatable({}, {
		__index = tbl,
		__newindex = function(table, key, value)
			error("Attempted to modify a read-only table")
		end,
		__metatable = false
	})
end

--[[
	Get a list of all the nodes in a sphere

	Params:
		pos - the center of the sphere
		radius - the radius of the sphere

	Returns:
		array of:
		{
			pos - the vector position 
			noderef - the node reference
		}
]]
function qts.get_nodes_in_radius(pos, radius)
	if pos ~= nil and radius ~= nil then
		local ntable = {}
		local counter = 1
		for z = -radius, radius do
		for y = -radius, radius do 
		for x = -radius, radius do
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

--[[
	Get a list of all the nodes on the surface of a sphere

	Params:
		pos - the center of the sphere
		radius - the radius of the sphere

	Returns:
		array of:
		{
			pos - the vector position 
			noderef - the node reference
		}
]]
function qts.get_nodes_on_radius(pos, radius)
	if pos ~= nil and radius ~= nil then
		local ntable = {}
		local counter = 1
		for z = -radius, radius do
		for y = -radius, radius do 
		for x = -radius, radius do
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
	Finds if a nodename or a node of group group:name in a sphere
	If it finds one, then it returns the position.

	Params:
		pos - the center of the sphere
		radius - the radius of the sphere
		nodename - the name of a registered node, or a group
			if a group, use the format "group:groupname <minlevel>"
			IE, "group:wood 4" means find a node of group:wood that its group is at least 4

	Returns:
		the position of the node, or nil
	
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
	for z = -radius, radius do
	for y = -radius, radius do 
	for x = -radius, radius do
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


--[[
	get an even distribution of a number of points on a sphere. 
	Since it returns unit vectors, this sphere has a radius of 1,
	any vector returned can be multiplied by the radius of the sphere you
	really want to distribute the points on, for the true point

	Params:
		point_count - the number of points to distribute

	Returns:
		array of points as unit vectors
]]
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

--[[
	Play the pickup sound to a player

	Params:
		player - the player or playername
]]
function qts.pickup_sound(player)
	if (type(player) ~= "string") then player = player:get_player_name() end
	minetest.sound_play("pickup", {
		to_player = player,
		gain = 1.0,
	})
end

--[[
	Start a fire at a position

	Params:
		pos - the position to start the fire at

	NOTE: this function should be implemented in whatever mod actually adds fire
		This is to keep fire lighting abstract and not dependant on that mod.
]]
function qts.ignite(pos)
	minetest.log("qts.ignite should be implemented in default mod")
end

--[[
	Get the mod name from an item name

	Params:
		itemname - the item name (string)

	Return:
		string, just the modname 
		For example, if the param is "default:wood", it returns "default"
]]
function qts.get_modname_from_item(itemname)
	return string.match(itemname, '([%w_]*):')
end

--[[
	Remove the modname from an itemname

	Params:
		itemname - the item name (string)

	Return:
		string, everything but the mod name and colon
		For example, if the param is "default:wood 4", it returns "wood 4"
]]
function qts.remove_modname_from_item(itemname)
	return string.match(itemname, ':([%w_]*)')
end

--[[
	Check if an itemname is actually a group

	Params:
		itemname - the item name (string)
	
	Returns:
		boolean, true if the itemname is a group in the form "group:<groupname>"
]]
function qts.is_group(itemname)
	return (string.match(itemname, '([%w_]*):') == "group")
end


--[[
	DEPRICATED
	use qts.inventory_contains_group() instead
]]
function qts.inv_contains_group(inv, groupString, ignoreNames)
	error("ERROR: qts.inv_contains_group is depricated. Use qts.inventory_contains_group() instead")
	return qts.inventory_contains_group(inv, "main", groupString, ignoreNames)
end

--[[
	DEPRICATED
	use qts.inventory_take_group()
]]
function qts.inv_take_group(inv, groupString, ignoreNames)
	error("ERROR: qts.inv_take_group is depricated. Use qts.inventory_take_group() instead")
	return qts.inventory_take_group(inv, "main", groupString, ignoreNames)
end

--[[
	Check if any items in an inventory ref contain a group

	Params:
		inventory - the inventory reference
		listname - the list to check
		groupString - the group to check, in the form "group:<groupname> <count to find>"
		ignoreNames - (Optional) set of names to ignore in the search, ie {name1=true, name2=true ... }

	Returns:
		boolean, true if found, false otherwise
--]]
function qts.inventory_contains_group(inventory, listname, groupString, ignoreNames)
	if not ignoreNames then ignoreNames = {} end
	local groupStack = ItemStack(groupString)
	--local minlevel = groupStack:get_count()
	if (qts.get_modname_from_item(groupStack:get_name()) ~= "group") then return nil end --not a group.
	local groupname = qts.remove_modname_from_item(groupStack:get_name())
	local itemList = inventory:get_list(listname)
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
	Take items in an inventory ref contain a group
	if there are not enough, none are taken

	Params:
		inventory - the inventory reference
		listname - the list to check
		groupString - the group to check, in the form "group:<groupname> <count to find>"
		ignoreNames - (Optional) set of names to ignore in the search, ie {name1=true, name2=true ... }

	Returns:
		array of remved ItemStacks
--]]
function qts.inventory_take_group(inventory, listname, groupString, ignoreNames)
	if not ignoreNames then ignoreNames = {} end
	local groupStack = ItemStack(groupString)
	--local minlevel = groupStack:get_count()
	if (qts.get_modname_from_item(groupStack:get_name()) ~= "group") then return nil end --not a group.
	local groupname = qts.remove_modname_from_item(groupStack:get_name())
	local itemList = inventory:get_list(listname)
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
	inventory:set_list(listname, itemList)
	return removeList
end


--[[
	checks to see if the collisionbox of objA and objB are overlapping.  
	highly accurate Axis-Alligned Bounding Box overlapping  
	  
	Params:   
		objA - ObjRef, the first entity  
		objB - ObjRef, the second entity  
	  
	Return: 
		boolean true or false  
]]
function qts.objects_overlapping(objA, objB)
	--get bounding boxes
	local propsA = objA:get_properties()
	local propsB = objB:get_properties()
	local posA = objA:get_pos()
	local posB = objB:get_pos()
	--check for collision
	return (
		posA.x + propsA.collisionbox[1] <  posB.x + propsB.collisionbox[4] and
		posA.x + propsA.collisionbox[4] >= posB.x + propsB.collisionbox[1] and
		posA.y + propsA.collisionbox[2] <  posB.y + propsB.collisionbox[5] and
		posA.y + propsA.collisionbox[5] >= posB.y + propsB.collisionbox[2] and
		posA.z + propsA.collisionbox[3] <  posB.z + propsB.collisionbox[6] and
		posA.z + propsA.collisionbox[6] >= posB.z + propsB.collisionbox[3]
	)
end


--[[
	Apply the default wear to a tool itemstack

	Params:
		itemstack - the item to remove the wear from.
		itemname - an item used to compare level
		
	Returns:
		itemstack - the modified itemstack
]]
function qts.apply_default_wear(itemstack,itemname)
	local nlvl = 0
	if itemname then
		nlvl = minetest.get_item_group(itemname, "level")
	end
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
	for z = pos1.z, pos2.z, (pos1.z < pos2.z) and 1 or -1 do
		for y = pos1.y, pos2.y, (pos1.y < pos2.y) and 1 or -1 do
			for x = pos1.x, pos2.x, (pos1.x < pos2.x) and 1 or -1  do
				coroutine.yield(vector.new(x,y,z))
			end
		end
	end
	return nil
end

local function columns_iter(pos1, pos2)
	for z = pos1.z, pos2.z, (pos1.z < pos2.z) and 1 or -1 do
		for x = pos1.x, pos2.x, (pos1.x < pos2.x) and 1 or -1  do
			for y = pos1.y, pos2.y, (pos1.y < pos2.y) and 1 or -1 do
				coroutine.yield(vector.new(x,y,z))
			end
		end
	end
	return nil
end

--[[
	Rectangle iter function from pos1 to pos2

	Params:
		pos1 - the lower position
		pos2 - the upper position
	
	Usage: 
		for pos in qts.rectangle(p1, p2) do ... end

	uses z-y-x ordering for max efficenty
]]
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

--[[
	Column-based iter function from pos1 to pos2
	
		Params:
		pos1 - the lower position
		pos2 - the upper position
	
	Usage: 
		for pos in qts.columns(p1, p2) do ... end

	uses z-x-y ordering to do it by columns
]]
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

--[[
	given a 3 dimentional array, insert an item into a position as a vector.
	if the index is nonexistant, it will create it.
	vector should be INT VECTORS and will not be rounded.
	This may create unreadable data if its not an int vector

	Params:
		t - the 3d Array table (can be nil and it will make one)
		pos - the vector
		item - the thing to insert

	Returns:
		t
]]
function qts.insert3(t, pos, item)
	t = t or {}
	t[pos.x] = t[pos.x] or {}
	t[pos.x][pos.y] = t[pos.x][pos.y] or {}
	t[pos.x][pos.y][pos.z] = item
	return t
end

--[[
	given a 3-dimentional array, read a location from it using a vector
	vector should be INT VECTORS and will not be rounded.

	Params:
		t - the 3D aray table (will not make if nil)
		pos - the position to read

	Returns:
		value at that position or nil if no value present
]]
function qts.read3(t, pos)
	if not t[pos.x] then return nil end
	if not t[pos.x][pos.y] then return nil end
	return t[pos.x][pos.y][pos.z]
end

--[[
	read all the nodes into a 3D aray from pos1 to pos2
	The indecies in the list will be 1-based, not starting at the values of pos1

	Params:
		pos1 - the lower corner
		pos2 - the upper corner
	
	Returns:
		3D array of node references
]]
function qts.readNodes(pos1, pos2)
	local t = {}
	pos1, pos2 = vector.sort(pos1, pos2)
	for p in qts.rectangle(pos1, pos2) do
		t = qts.insert3(t, p-pos1, minetest.get_node_or_nil(p))
	end
	return t
end

--[[
	write an area of nodes to the map from a 3D array

	Params:
		pos1 - the lower position On the Map
		pos2 - the upper position On the Map
		tbl - the 3D array of nodes

	Returns - nothing
]]
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
	for z, t2 in zpairs(tbl) do
		for y, t3 in zpairs(t2) do
			for x, node in zpairs(t3) do
				coroutine.yield(vector.new(x,y,z), node)
			end
		end
	end
	return nil
end

--[[
	iterate through all the positions in a 3D array of nodes

	Params:
		tbl - the 3D array

	Usage:
		for pos, node in qts.nodePairs(array) do ... end

	uses z-y-x ordering
]]
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
	This function is desighed to be set as the value of the item `on_place` callback, 
	to operate rightclickable items if pointing at them, or do the `on_secondary_use` callback if not.

	Params:
		same as item callback `on_place(...)`

	Usage:
		in an Item Def Table:
		...
		on_place = qts.item_place_check_and_propigate,
		...
		on_secondary_use = <your custom function>

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
--[[
	Eat an item function, for a passed HP

	Params:
		hpchange - how much to change the HP by
		replace_with_item - (optional) - the new item

	Usage:
		in Item Definition Table:
		...
		on_use = qts.item_eat(<hpgain>, [<replace item>])
		...
	
	Returns:
		a function compatable with Item Definition Table's `on_use(...)` callback
]]
function qts.item_eat(hpchange, replace_with_item)
	return function(itemstack, user, pointed_thing)
		return qts.do_item_eat(hpchange, replace_with_item, itemstack, user, pointed_thing)
	end
end

--[[
	used to actually eat an item.
	does all the HP calculations, calls on_item_eat callbacks, etc, etc.

	Params:
		hpchange - how much to change the HP by
		replace_with_item - what to replace the eaten item with
		itemstack - the current itemstack you are eating
		user - who is doing the eating
		pointed_thing - what you are pointing at
]]
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

--[[
	selects opt1 if check is true, otherwise selects opt2. 
	if the opts are functions, then they are called, their return value is returned, and any variable args are passed to them.

	Params:
		check - the boolean to check
		opt1 - the option to return when check is true
		opt2 - the option to return when check is false
		... - variable args passed to opt1 or opt2 in the case they are functions.
]]
function qts.select(check, opt1, opt2, ...)
    if (check) then
        if type(opt1) == "function" then
            return opt1(...)
        else
            return opt1
        end
    else
        if type(opt2) == "function" then
            return opt2(...)
        else
            return opt2
        end
    end
end