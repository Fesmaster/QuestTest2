

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

function qts.vector_round(vec)
	local p = {}
	for n, v in pairs(vec) do
		if v and n then
			if math.modf(v) <= 0.5 then
				p[n] = math.floor(v)
			else
				p[n] = math.ceil(v)
			end
		else
			minetest.debug("invalid field: ["..n.."]")
		end
	end
	return p
end


function qts.nearly_equal(a, b, degree)
	return (a >= b-degree and a <= b+degree)
end

function qts.nearly_equal_vec(a, b, degree)
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.y, b.y, degree) and qts.nearly_equal(a.z, b.z, degree))
end

function qts.nearly_equal_vec_xz(a, b, degree)
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.z, b.z, degree))
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