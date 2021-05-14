--[[
Extentions to Vector Library
See AI section for more

vector.fill(number)
	creates a vector with number in X, Y, and Z
	Params:
	number - the number to fill
	
	Return:
	vector of {x=num, y=num, z=num}
	
vector.lengthsq(vector)
	gets the sqared length of the vector. Faster than the actual length
	Params:
	vector - vector, of which the square lenght is calculated
	
	Return: number, the square length
	
vector.distancesq(p1, p2)
	gets the squared distance between two vectors. 
	Does not call other functions. 
	Equivilent to vector.lengthsq(vector.sub(p2, p1))
	
	Params:
	p1 - vector, the first pos
	p2 - vector, the second pos
	
	Return: number, the distance squared
	
vector.nearly_equal(a, b, degree)
	Checks if a and b are nearly equal, within degree distance
	Params:
	a - vector, the first vector
	b - vector, the second vector
	degree - number, degree of equality. defaults to 0.001
	
	Return: true or false

vector.nearly_equal_xz(a, b, degree)
	Checks if a and b are nearly equal, within degree distance, but ignoring height difference.
	Params:
	a - vector, the first vector
	b - vector, the second vector
	degree - number, degree of equality. defaults to 0.001
	
	Return: true or false

vector.rotate_yaw(vec, angle)
	rotates the vector by a angle around the vertical axis
	Params:
	vec - vector, to rotate
	angle - the angle to rotate in radians
	
	Return: vector, the rotated vector

vector.unit()
	Returns a unit vector, pointing to z+
	
	Params: None
	
	Return: {x=0, y=0, z=1}


vector.flat_dist(pos1, pos2)
	Gets the distance between two points, ignoring height distance
	
	Params:
	pos1 = vector, first position
	pos2 = vector, second position
	
	Return: the distance 
	

vector.get_rot(vec)
	Gets the rotation of a directional vector
	
	Params:
	vec - a vector (as a direction / offset)
	
	Return: rot - a vector (as a euler rotation)
	

vector.get_forward_vector([rot] [yaw, (pitch)])
	Gets the forward vector of a rotation
	
	Params:
	rot - a vector, as rotation
	--OR--
	yaw - the yaw or the rotation
	pitch (optional) - the pitch of the rotation
	
	Return: vector, as direction


vector.get_right_vector([rot] [yaw, (pitch)])
	Gets the right vector of a rotation
	
	Params:
	rot - a vector, as rotation
	--OR--
	yaw - the yaw or the rotation
	pitch (optional) - the pitch of the rotation
	
	Return: vector, as direction

vector.get_up_vector([rot] [yaw, (pitch)])
	gets the up vector of a rotation
	
	Params:
	rot - a vector, as rotation
	--OR--
	yaw - the yaw or the rotation
	pitch (optional) - the pitch of the rotation. If nil, assumed to be 0
	
	Return: vector, as direction

vector.lerp(vec1, vec2, alpha)
	Linear Iterpalation between two points / directions
	
	Params:
	vec1 - vector, the origin
	vec2 - vector, the end
	alpha - 0 to 1 value, where in between you are
	
	Return: vector - the interpalated value

vector.slerp(rot1, rot2, alpha)
	Sphereical Iterpalation between two rotations
	
	Params:
	rot1 - vector, as rotation, the origin
	rot2 - vector, as rotation, the end
	alpha - 0 to 1 valeu, where in between you are
	
	Return: vector, as rotation - the interpalated value

vector.
	
	
	Params:
	
	
	Return:

--]]


function vector.fill(x)
	return vector.new(x, x, x)
end

function vector.lengthsq(v)
	return v.x*v.x+v.y*v.y+v.z*v.z
end

function vector.distancesq(p1, p2)
	local x = p2.x-p1.x
	local y = p2.y-p1.y
	local z = p2.z-p1.z
	return x*x+y*y+z*z
end

function vector.nearly_equal(a, b, degree)
	if not degree then degree = 0.001 end
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.y, b.y, degree) and qts.nearly_equal(a.z, b.z, degree))
end


function vector.nearly_equal_xz(a, b, degree)
	if not degree then degree = 0.001 end
	return (qts.nearly_equal(a.x, b.x, degree) and qts.nearly_equal(a.z, b.z, degree))
end


function vector.rotate_yaw(vec, angle)
	return {x = (vec.x * math.cos(angle) - vec.z * math.sin(angle)), y = vec.y, z = (vec.x * math.sin(angle) + vec.z * math.cos(angle))}
end

function vector.unit()
	return vector.new(0, 0, 1)
end

function vector.flat_dist(pos1, pos2)
	return vector.distance({x=pos1.x, y=0, z=pos1.z}, {x=pos2.x, y=0, z=pos2.z})
end

function vector.get_yaw(vec)
	error("DEPRECIATED: Use vector.get_rot(vec).y instead")
end

function vector.get_pitch(vec)
	error("DEPRECIATED: Use vector.get_rot(vec).x instead")
end

function vector.get_rot(vec)
	local rot = {x=0, y=0, z=0}
	
	rot.y = math.atan(vec.z/vec.x)+math.pi/2
	if (vec.x > 0) then rot.y = rot.y + math.pi end
	
	local dist = math.sqrt((vec.x^2)+(vec.z^2))
	rot.x = math.atan(vec.y/dist)
	return rot
end

--TODO: vector.set_rot(vec, rot)

local function get_forward_vector(yaw, pitch)
	local dir = {}
	dir.x = math.sin(yaw)
	dir.y = math.cos(pitch or math.pi) --if pitch is null, PI used (dir.y == 0)
	dir.z = math.cos(yaw)
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

function vector.get_forward_vector(yaw, pitch)
	if (type(yaw) == "table") and yaw.x ~= nil and yaw.y ~= nil then
		return get_forward_vector(yaw.y, yaw.x)
	else
		return get_forward_vector(yaw, pitch)
	end
end

function vector.get_right_vector(yaw, pitch)
	if (type(yaw) == "table") and yaw.x and yaw.y then
		return get_forward_vector(yaw.y+(math.pi/2), yaw.z)
	else
		return get_forward_vector(yaw+(math.pi/2), pitch)
	end
end

function vector.get_up_vector(yaw, pitch)
	if (type(yaw) == "table") and yaw.x and yaw.y then
		return get_forward_vector(yaw.y, yaw.z+(math.pi/2))
	else
		return get_forward_vector(yaw, (pitch or 0) +(math.pi/2))
	end
end

function vector.lerp(vec1, vec2, alpha)
	local result = vector.new()
	for k, v in pairs(vec1) do
		result[k] = vec1[k] + ((vec2[k] - vec1[k]) * alpha)
	end
	return result
end

--THIS FUNCTION IS INTENDED FOR ROTATIONS EXPRESSED IN RADIANS
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



