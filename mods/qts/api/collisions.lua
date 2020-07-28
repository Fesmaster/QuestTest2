--[[
This file deals with functions for Axis-Alligned Bounding Box collisions between entities and nodes


--]]


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