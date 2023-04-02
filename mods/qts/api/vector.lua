--[[
Extentions to Vector Library

vector.readonly(x,y,z)
vector.unit.X
vector.unit.Y
vector.unit.Z
vector.fill(number)
vector.lengthsq(vector)
vector.distancesq(p1, p2)
vector.nearly_equal(a, b, degree)
vector.nearly_equal_xz(a, b, degree)
vector.rotate_yaw(vec, angle)
vector.flat_dist(pos1, pos2
vector.get_rot(vec)
vector.get_forward_vector([rot] [yaw, (pitch)])
vector.get_right_vector([rot] [yaw, (pitch)])
vector.get_up_vector([rot] [yaw, (pitch)])
vector.lerp(vec1, vec2, alpha)
vector.slerp(rot1, rot2, alpha)

--]]

--[[
	create a read-only vector, that operates as a normal vector

	Params:
		exactly like vector.new()

	Returns:
		a read-only vector
]]
function vector.readonly(x,y,z)
	local upvec = vector.new(x,y,z)
	local vector_metatable_copy = qts.table_deep_copy(vector.metatable)
	vector_metatable_copy.__index = function(t,k)
		if upvec[k] then 
			return upvec[k]
		else
			return vector[k]
		end
	end
	vector_metatable_copy.__newindex = function(table, key, value)
		error("Attempted to modify a read-only vector")
	end
	vector_metatable_copy.__metatable = false

	return setmetatable({}, vector_metatable_copy)
end

--[[
	Basis Vectors  
	vector.unit.X - unit X vector  
	vector.unit.Y - unit Y vector  
	vector.unit.Z - unit Z vector  
]]
vector.unit = qts.readonly_table({
	X = vector.readonly(1,0,0),
	Y = vector.readonly(0,1,0),
	Z = vector.readonly(0,0,1),
})

---Fix up any NaN or Inf in a vector. Operates in-place
---@param v Vector
---@return Vector
function vector.verify(v)
	if ((v.x ~= v.x) or (v.x == 1/0)) then v.x = 0 end
	if ((v.y ~= v.y) or (v.y == 1/0)) then v.y = 0 end
	if ((v.z ~= v.z) or (v.z == 1/0)) then v.y = 0 end
	return v
end

--[[
	creates a vector with number in X, Y, and Z
	
	Params:
		number - the number to fill
	
	Return:
		vector of {x=num, y=num, z=num}
]]
function vector.fill(x)
	return vector.new(x, x, x)
end

--[[
	gets the sqared length of the vector. Faster than the actual length
	
	Params:
		vector - vector, of which the square lenght is calculated
	
	Return: 
		number, the square length
]]
function vector.lengthsq(v)
	return v.x*v.x+v.y*v.y+v.z*v.z
end

--[[
	gets the squared distance between two vectors. 
	Does not call other functions. 
	Equivilent to vector.lengthsq(vector.sub(p2, p1))
	
	Params:
		p1 - vector, the first pos
		p2 - vector, the second pos

	Return: 
		number, the distance squared
]]
function vector.distancesq(p1, p2)
	local x = p2.x-p1.x
	local y = p2.y-p1.y
	local z = p2.z-p1.z
	return x*x+y*y+z*z
end


--[[
	Checks if a and b are nearly equal, within degree distance
	
	Params:
		a - vector, the first vector
		b - vector, the second vector
		degree - number, degree of equality. defaults to 0.001
	
	Return: 
		boolean true or false
]]
function vector.nearly_equal(a, b, degree)
	if not degree then degree = 0.001 end
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.y, b.y, degree) and qts.nearly_equal(a.z, b.z, degree))
end

--[[
	Checks if a and b are nearly equal, within degree distance, but ignoring height difference.
	
	Params:
		a - vector, the first vector
		b - vector, the second vector
		degree - number, degree of equality. defaults to 0.001
	
	Return: 
		boolean true or false
]]
function vector.nearly_equal_xz(a, b, degree)
	if not degree then degree = 0.001 end
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.z, b.z, degree))
end

--[[
	rotates the vector by a angle around the vertical axis
	
	Params:
		vec - vector, to rotate
		angle - the angle to rotate in radians
	
	Return: 
		vector, the rotated vector
]]
function vector.rotate_yaw(vec, angle)
	return vector.new((vec.x * math.cos(angle) - vec.z * math.sin(angle)), vec.y, (vec.x * math.sin(angle) + vec.z * math.cos(angle)))
end


--[[
	Gets the distance between two points, ignoring height distance
	
	Params:
		pos1 = vector, first position
		pos2 = vector, second position
	
	Return: 
		number - the distance 
]]
function vector.flat_dist(pos1, pos2)
	return vector.distance(vector.new(pos1.x, 0, pos1.z), vector.new(pos2.x, 0, pos2.z))
end

--[[
	Gets the rotation of a directional vector
	
	Params:
		vec - a vector (as a direction / offset)

	Return: 
		rot - a vector (as a euler rotation)
]]
function vector.get_rot(vec)
	local rot = vector.new(0, 0, 0)
	
	rot.y = math.atan(vec.z/vec.x)+math.pi/2
	if (vec.x > 0) then rot.y = rot.y + math.pi end
	
	local dist = math.sqrt((vec.x^2)+(vec.z^2))
	rot.x = math.atan(vec.y/dist)
	return rot
end

--TODO: vector.set_rot(vec, rot)

local function get_forward_vector(yaw, pitch)
	local dir = vector.new(
		math.sin(yaw),
		math.cos(pitch or math.pi), --if pitch is null, PI used (dir.y == 0)
		math.cos(yaw)
	)
	if dir.x ~= dir.x then 
		dir.x=0
	end
	if dir.y ~= dir.y then 
		dir.y=0
	end
	if dir.z ~= dir.z then 
		dir.z=0
	end
	dir.x = dir.x*-1
	return dir
end

--[[
	Gets the forward vector of a rotation
	
	Params:
		rot - a vector, as euler rotation
	--OR--
		yaw - the yaw or the rotation
		pitch (optional) - the pitch of the rotation
	
	Return: 
		unit vector, as direction
]]
function vector.get_forward_vector(yaw, pitch)
	if (type(yaw) == "table") and yaw.x ~= nil and yaw.y ~= nil then
		return get_forward_vector(yaw.y, yaw.x)
	else
		return get_forward_vector(yaw, pitch)
	end
end

--[[
	Gets the right vector of a rotation
	
	Params:
		rot - a vector, as euler rotation
	--OR--
		yaw - the yaw or the rotation
		pitch (optional) - the pitch of the rotation
	
	Return: 
		unit vector, as direction
]]
function vector.get_right_vector(yaw, pitch)
	if (type(yaw) == "table") and yaw.x and yaw.y then
		return get_forward_vector(yaw.y+(math.pi/2), yaw.z)
	else
		return get_forward_vector(yaw+(math.pi/2), pitch)
	end
end

--[[
	gets the up vector of a rotation
	
	Params:
		rot - a vector, as euler rotation
	--OR--
		yaw - the yaw or the rotation
		pitch (optional) - the pitch of the rotation. If nil, assumed to be 0
	
	Return: 
		unit vector, as direction
]]
function vector.get_up_vector(yaw, pitch)
	if (type(yaw) == "table") and yaw.x and yaw.y then
		return get_forward_vector(yaw.y, yaw.z+(math.pi/2))
	else
		return get_forward_vector(yaw, (pitch or 0) +(math.pi/2))
	end
end

--[[
	Linear Iterpalation between two points / directions
	
	Params:
		vec1 - vector, the origin
		vec2 - vector, the end
		alpha - 0 to 1 value, where in between you are
	
	Return: 
		vector - the interpalated value
]]
function vector.lerp(vec1, vec2, alpha)
	local result = vector.new()
	for k, v in pairs(vec1) do
		result[k] = vec1[k] + ((vec2[k] - vec1[k]) * alpha)
	end
	return vector.copy(result)
end


--[[
	Sphereical Iterpalation between two rotations
	WANRING: This function does NOT currently work

	Params:
	rot1 - vector, as euler rotation in radians, the origin
	rot2 - vector, as euler rotation in radians, the end
	alpha - 0 to 1 valeu, where in between you are
	
	Return: vector, as euler rotation in radians - the interpalated value
]]
function vector.slerp(rot1, rot2, alpha)
	local result = vector.new()
	for k, v in pairs(rot1) do
		local diff = math.abs(rot2[k] - rot1[k])
		local start = rot1[k]
		local finish = rot2[k]
		if (diff > math.pi) then
			if (finish > start) then
				start = start + math.pi*2
			else
				finish = finish + math.pi*2
			end
		end 
		result[k] = (start + ((finish - start) * alpha)) % (math.pi*2)
	end
	return result
end

