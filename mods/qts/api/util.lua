

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

function qts.Set(t)
	local s = {}
	for i, v in ipairs(t) do
		s[v] = true
	end
	return s
end

function qts.new_counter()
	local i = 0
	return function()
		i = i + 1
		return i
	end
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