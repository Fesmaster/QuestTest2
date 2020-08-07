--[[
The functions in this file are building blocks of AI behavior.
It works a bit like a set of legos. These functions have specific purposes, and are intended to be easily
able to be plugged together, to create more complex behaviors

For an example of this, see the Navigational Movement functions, they combine the Facing Functions and the Simple Movement Functions


--]]


--[[
Simple Facing Functions


qts.ai.face(object, facing_pos, yaw_only, dont_set)
	Sets the object to face the given position. 
	This can be called once and it will immedately be facing the target.
	It also can be called every frame to keep the object facing the target pos with no turn delay
	
	params:
	object - the luaentity to effect
	facing_pos - where it sould be looking
	yaw_only - if true or nil, does not set the pitch
	dont_set - does not actually set the value, but does claculate and return it
	
	return - the new rotation (as a vector)

qts.ai.rotate_to(object, facing_pos, max_rotation, yaw_only, dont_set)
	--WARNING: THIS FUNCTION IS SUPER BUGGY
	Performs one step in the movement of an object to face a directon, rotating no more than max_rotation
	This should be called every frame while rotating to face something, but it will have turn delay.
	
	params:
	object - the luaentity to effect
	facing_pos - where it sould be looking
	max_rotation - the max angle (in radains) to turn this step. usually constant
	yaw_only - if true or nil, does not set the pitch
	dont_set - does not actually set the value, but does claculate and return it
	
	return - the new rotation (as a vector)

--]]

function qts.ai.face(object, facing_pos, yaw_only, dont_set)
	if (yaw_only == nil) then yaw_only = true end
	if object and facing_pos then
		local pos = object:get_pos()
		local dir = vector.direction(pos, facing_pos)
		local rotation = object:get_rotation()
		rotation.y = vector.get_rot(dir).y
		if (not yaw_only) then
			rotation.x = vector.get_pitch(dir)
		end
		--rotation.z = 0
		if object:get_luaentity().drawtype == "side" then
			rotation.y = rotation.y+(math.pi/2)
		end
		if (not dont_set) then
			object:set_rotation(rotation)
		end
		return rotation
	end
end
--WARNING: THIS FUNCTION IS SUPER BUGGY
function qts.ai.rotate_to(object, facing_pos, max_rotation, yaw_only, dont_set)
	if (yaw_only == nil) then yaw_only = true end
	if (not max_rotation) then max_rotation = 0.01 end
	if object and facing_pos and max_rotation then
		local pos = object:get_pos()
		local dir = vector.direction(pos, facing_pos)
		local oldrot = object:get_rotation()
		local rot = vector.get_rot(dir)
		--local rot = {x=0, y=0,z=oldrot.z}
		--rot.y = vector.get_rot(dir).y
		rot.z = oldrot.z
		if (yaw_only) then
			rot.x = oldrot.x
		--else
			--rot.x = vector.get_rot(dir).x
		end
		
		if object:get_luaentity().drawtype == "side" then
			rot.y = rot.y+(math.pi/2)
		end
		
		local diff = vector.subtract(rot, oldrot)
		if diff and max_rotation then
			local maxDif = math.max(diff.x, diff.y, diff.z)
			local steps = math.ceil(maxDif / max_rotation)
			if (steps > 1) then
				rot = vector.slerp(oldrot, rot, 1/steps)
			end
			if (not dont_set) then
				object:set_rotation(rot)
			end
		end
		return rot
	end
end

--[[
Simple movement functions, that depend on the current direction of the object

qts.ai.walk(object, speed, dont_set)
	walks the object along its forward vector, in 2d space (top down) at speed speed
	
	params:
	object - the luaentity being told to walk
	speed - the speed it should walk at
	dont_set - if true, the value is calculated, but not set. It is still returned
	
	return: - the new velocity of the object


qts.ai.fly(object, speed, dont_set)
	Flys the object along its forward vector, in 3d space, at speed speed
	
	params:
	object - the luaentity being told to walk
	speed - the speed it should walk at
	dont_set - if true, the value is calculated, but not set. It is still returned
	
	return: - the new velocity of the object


qts.ai.fly_pitch(object, speed, pitch, dont_set)
	Flys the object along its forward vector, but using a given pitch, in 3d space, at speed speed
	
	params:
	object - the luaentity being told to walk
	speed - the speed it should walk at
	pitch - the pitch to use instead of the object's Range: -PI/2 to PI/2
	dont_set - if true, the value is calculated, but not set. It is still returned
	
	return: - the new velocity of the object


qts.ai.straife(object, speed, dont_set)
	straifes the object to its right in 2d space (top down) at speed speed.
	Use a negative speed for straifing to the left.
	
	params:
	object - the luaentity being told to walk
	speed - the speed it should walk at
	dont_set - if true, the value is calculated, but not set. It is still returned
	
	return: - the new velocity of the object


qts.ai.jump(object, height, forward_ammount, dont_set)
	Causes the object to attempt to jump up height
	
	Params:
	object - the luaentity begin told to jump
	height - how high to jump
	forward_ammount - the speed to jump forward
	dont_set - if true, the value is calculated, but not set. It is still returned

	Return: - the new velocity of the object
--]]

function qts.ai.walk(object, speed, dont_set)
	local dir
	if object and speed then
		local yaw = object:get_yaw()
		if object:get_luaentity().drawtype == "side" then
			yaw = yaw+(math.pi/2)
		end
		dir = vector.get_forward_vector(yaw)
		dir.x = dir.x*speed
		dir.z = dir.z*speed
		dir.y = object:get_velocity().y
		if not dont_set then
			object:set_velocity(dir)
		end
	else
		return nil
	end
	return dir
end

function qts.ai.fly(object, speed, dont_set)
	local dir
	if object and speed then
		local rot = object:get_rotation()
		if object:get_luaentity().drawtype == "side" then
			rot.y = rot.y+(math.pi/2)
		end
		rot.x = rot.x - (math.pi / 2)
		dir = vector.get_forward_vector(rot)
		dir.x = dir.x*speed
		dir.y = dir.y*speed
		dir.z = dir.z*speed
		if not dont_set then
			object:set_velocity(dir)
		end
	else
		return nil
	end
	return dir
end

function qts.ai.fly_pitch(object, speed, pitch, dont_set)
	local dir
	if object and speed then
		local rot = object:get_rotation()
		if object:get_luaentity().drawtype == "side" then
			rot.y = rot.y+(math.pi/2)
		end
		rot.x = pitch
		dir = vector.get_forward_vector(rot)
		dir.x = dir.x*speed
		dir.y = dir.y*speed
		dir.z = dir.z*speed
		if not dont_set then
			object:set_velocity(dir)
		end
	else
		return nil
	end
	return dir
end

function qts.ai.straife(object, speed, dont_set)
	local dir
	if object and speed then
		local yaw = object:get_yaw()
		if object:get_luaentity().drawtype == "side" then
			yaw = yaw+(math.pi/2)
		end
		dir = vector.get_right_vector(yaw)
		dir.x = dir.x*speed
		dir.z = dir.z*speed
		dir.y = object:get_velocity().y
		if not dont_set then
			object:set_velocity(dir)
		end
	else
		return nil
	end
	return dir
end

function qts.ai.jump(object, height, forward_ammount, dont_set)
	local dir = object:get_velocity()
	if dir.y == 0 then
		local h = (height*4)+1 --?? Magic?
		if forward_ammount ~= 0 then
			local yaw = object:get_yaw()
			if object:get_luaentity().drawtype == "side" then
				yaw = yaw+(math.pi/2)
			end
			dir = vector.get_forward_vector(yaw)
			dir.x=dir.x*forward_ammount
			dir.z=dir.z*forward_ammount
		end
		dir.y = h
		if dont_set == false then
			object:set_velocity(dir)
		end
		return dir
	end
end

--[[
Basic Navigational Functions







--]]



--[[
Basic Navigational Movement

qts.ai.walk_to(object, dest_pos, speed, can_jump, jump_height, dont_set)
	Causes the entity to walk to a destination, jumping over obstacles if they can.
	The entity will face the dest_pos 
	
	Params:
	object - the luaentity
	dest_pos - vector - the destination to walk to
	speed - number - the speed of the eneity
	can_jump - boolean - can the entity jump?
	jump_height - number - the height the entity can jump. 
		Should not be 0 if can_jump is true, 
		can be nil if can_jump is false
	dont_set - if true, the value is calculated, but not set. It is still returned
	
	Return - vector - the new velocity

qts.ai.fly_to(object, dest_pos, speed, yaw_turn_only, turning_max, dont_set)
	Causes the entity to fly (as if it had wings, like a bird) to the target pos, 
	but it always screeches past, circles around, and makes another pass (if left running)
	This is ment to immitate a bird or other winged creature in flight
	
	Params:
	object - the luaentity
	dest_pos - vector - the destination to fly to
	speed - number - the entity's speed
	yaw_turn_only - should the entity only have its yaw changed, or its pitch as well? 	
	turning_max - the max ammount to turn in one frame. 0.01 is a good number
	dont_set - if true, the value is calculated, but not set. It is still returned
	
	Return - vector - the new velocity



--]]

function qts.ai.walk_to(object, dest_pos, speed, can_jump, jump_height, dont_set)
	if object and dest_pos and speed then
		qts.ai.face(object, dest_pos, true, dont_set)
		local dir = ai.walk(object, speed, true)
		if can_jump == true then
			if qts.ai.get_walking_speed(object) < 0.5 then
				local jump = qts.ai.jump(object, jump_height, 0, true)
				if jump then
					dir.y = jump
				end
			end
		end
		if dont_set == false then
			object:set_velocity(dir)
		end
		return dir
	end
end


function qts.ai.fly_to(object, dest_pos, speed, yaw_turn_only, turning_max, dont_set)
	if object and dest_pos and speed then
		qts.ai.rotate_to(object, dest_pos, turning_max, yaw_turn_only,  dont_set)
		local pos = object:get_pos()
		local dir = vector.direction(pos, dest_pos)
		local pitch = vector.get_rotation(dir).x
		
		--banking up and down as it flys
		if qts.ai.is_point_in_front_of(object, dest_pos) then
			if pitch >= 2.7 then
				pitch = (math.pi/2)
			elseif pitch <= 2.5 then
				pitch = (math.pi*3)/2
			else
				pitch = (math.pi)
			end
		else
			pitch = (math.pi)-(math.pi/4)
		end
		
		if (yaw_turn_only) then
			return qts.ai.fly_pitch(object, speed, pitch, dont_set)
		else
			return qts.ai.fly(object, speed, dont_set)
		end
	end
end



--[[
Pathfinding Movement


--]]