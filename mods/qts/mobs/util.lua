--[[
A lot of handy functions related to entities
some live under the blanket qts namespace, rather than qts.ai namespace
because they are used for much more than the AI and Mob system


qts.gen_entity_id()
	Generates a new entity id number
	
	Params: none
	
	Return - the new ID number

qts.get_object_id(obj)
	Gets the object id, either the qtid, (newly generated, if need be)
	or the player name
	
	Params:
	obj - the objectref (player or luaentity)
	
	Return: the QTID or player name

qts.object_name(obj)
	Gets the name of the object, either the name of the registered luaentity
	or the player name
	
	Params:
	obj - the objectref (player or luaentity)
	
	Return: the obj name

qts.slerp(start, finish, alpha)
	Sphereical Iterpalation between two specific values
	This does not deal with vectors
	
	Params:
	start - the start value in radians
	finish - the end value in radians
	alpla - 0  to 1 value telling where in between you are
	
	Return - the interpalated value, in radians
	

these are more AI specific, and thus live under qts.ai

qts.ai.get_walking_speed(object)
	Gets the current walking speed (Basically, ignoring any vertical speed)
	of the given object
	
	Params: 
	object - the Luaentity
	
	Return: the speed
	
qts.ai.is_point_in_front_of(object, pos)
	Get if the given pos is in front of the given object
	
	Params:
	object - the luaentity
	pos - the pos
	
	Return: boolean, true if pos is in front of Object

--]]

qts.gen_entity_id = qts.new_counter()

function qts.get_object_id(obj)
	if obj:is_player() then
		return obj:get_player_name()
	else
		local le = obj:get_luaentity()
		if le.QTID then 
			return le.QTID 
		else
			le.QTID = qts.gen_entity_id()
			return le.QTIDs
		end
	end
end

function qts.object_name(obj)
	if (obj:is_player()) then
		return obj:get_player_name()
	else
		return obj:get_luaentity().name
	end
end

function qts.slerp(start, finish, alpha)
	local diff = math.abs(finish - start)
	if (diff > math.pi) then
		if (finish > start) then
			start = start + math.pi*2
		else
			finish = finish + math.pi*2
		end
	end 
	return (start + ((finish - start) * alpha)) % (math.pi*2)
end

function qts.ai.get_walking_speed(object)
	local v = object:get_velocity()
	return (v.x^2 + v.z^2)^(0.5)
end

function qts.ai.is_point_in_front_of(object, pos)
	local dir = qts.ai.get_forward_vector(object:getyaw())
	local loc = object:get_pos()
	dir = vector.add(loc, dir)
	
	local dist_obj = vector.distance(loc, pos)
	local dist_dir = vector.distance(dir, pos)
	
	if dist_dir <= dist_obj then
		return true
	else
		return false
	end
end

--[[
Additions to the vector library
These are built in here because they are so darn useful for mobs

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

