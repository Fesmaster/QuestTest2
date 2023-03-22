--[[
A lot of handy functions related to entities
some live under the blanket qts namespace, rather than qts.ai namespace
because they are used for much more than the AI and Mob system

--]]


--[[
	Generates a new entity id number  
	
	Returns:
		the new ID number  
]]
qts.gen_entity_id = Counter()

--[[
	Gets the object id, either the qtid, (newly generated, if need be)  
	or the player name  

	Params:  
		obj - the objectref (player or luaentity)  

	Returns: 
		the QTID or player name  
]]
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

--[[
	Gets the name of the object, either the name of the registered luaentity  
	or the player name  

	Params:  
		obj - the objectref (player or luaentity)  

	Returns: 
		the obj name  
]]
function qts.object_name(obj)
	if obj == nil then
		return "UNKNOWN NAME"
	end
	--protection from calling this on self in entities
	if obj.is_player == nil and obj.object ~= nil and obj.name ~= nil then
		return obj.name
	end
	if (obj:is_player()) then
		return obj:get_player_name()
	else
		return obj:get_luaentity().name
	end
end

--[[
	Sphereical Iterpalation between two specific values  
	This does not deal with vectors  
	
	Params: 
		start - the start value in radians  
		finish - the end value in radians  
		alpla - 0  to 1 value telling where in between you are  
	
	Returns:
		the interpalated value, in radians  
]]
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

--[[
	Gets the current walking speed (Basically, ignoring any vertical speed)  
	of the given object  
	
	Params:   
		object - the Luaentity  
	
	Returns: 
		the speed  
]]
function qts.ai.get_current_speed(object)
	local v = object:get_velocity()
	return (v.x^2 + v.z^2)^(0.5)
end

--[[
	Get if the given pos is in front of the given object  
	
	Params:  
		object - the luaentity  
		pos - the pos  
	
	Returns: 
		boolean, true if pos is in front of Object  
]]
function qts.ai.is_point_in_front_of(object, pos)
	local dir = vector.get_forward_vector(object:get_yaw())
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
	Get if the object should see the player, based off of facing directions, player sneak, and player overiden attributes  

	Params:  
		object - the object in question (ObjRef)    
		player - the player in question (player ObjRef)  
		detection_radius - facing indepentant detection radius of the mob  
		facing_detection_radius - facing dependant detection radius of the mob.   
			IE, the mob has to be facing the player to see the player within this radius, no matter the distance.  
	
	Return: 
		boolean, true if the object detects the player.  
]]
function qts.ai.does_detect_player(object, player, detection_radius, facing_detection_radius)
	--first, modify the detection radii
	local controls = player:get_player_control()
	local mult = qts.get_playe_detection_rage_multiplier(player)
	if controls.sneak then
		mult = mult.sneak
	else
		mult = mult.normal
	end
	detection_radius = detection_radius * mult
	facing_detection_radius = facing_detection_radius * mult

	--now, check distances
	local distance = vector.distance(object:get_pos(), player:get_pos())
	if distance < detection_radius then
		return true
	end
	
	--facing detection is important
	if facing_detection_radius > detection_radius then
		if distance < facing_detection_radius then
			return qts.ai.is_point_in_front_of(object, player:get_pos())
		end
	end
	return false
end

local function check_pos_for_target(pos, query)
	local node = minetest.get_node_or_nil(pos)
	if not node then
		--minetest.log("invalid node position")
		return false
	elseif query.airlike and query.airlike == true then
		local node_info = minetest.registered_nodes[node.name]
		if node.name ~= "air" or node_info.walkable ~= false then
			return false
		end
	elseif query.group then
		local group = minetest.get_item_group(node.name, query.group)
		if group == 0 then
			return false
		end
	elseif query.name then
		if node.name ~= query.name then
			return false
		end
	end
	return true
end

--[[
qts.ai.get_random_navagatable_point_in_radius(pos, radius, query, shape)  
	Description: gets a point in radius around pos that matches query and shape.  
	
	Paramaters:  
		pos - vector as position  
		radius - float  
		query - {  
			One or more of the following:  
				airlike - boolean - search for standard airlike nodes  
				group - string as item group - search for nodes with this group  
				name - string as item name - search for nodes of this name  
			if wanted:  
				check_ground = boolean - if the node below the possible position should be not matching query.  
		} - choose one of these, make the rest nil  
		height - the height of the column.  
		shape - {  
			size - float - the x and z size in nodes to check  
			height float - the y height in nodes to check  
		} - a person would be {size = 1, height = 2}  
	
	Returns:  
		pos - vector as position - if found, the pos of the found spot. nil if no spots found.  
--]]
function qts.ai.get_random_navagatable_point_in_radius(pos, radius, query, height)
	pos = vector.round(pos)
	for i = 0, radius do
		
		local x = math.random(-radius, radius)
		local z = math.random(-radius, radius)
		local dist_horz = (x^2+z^2)^0.5
		if dist_horz < radius then
			--minetest.log("search " .. i .. "  Position: x=" .. x+pos.x .. " z=" .. z+pos.z)
			--trace down till we find a node 
			local h = (radius^2 - dist_horz^2)^0.5
			
			local target_node_found = false
			local target_height = 0
			for y = h, -h, -1 do
				local dist = (x^2+z^2+y^2)^0.5
				if (dist > (radius/2)) then
					local p = vector.new(x,y,z)+pos
					--minetest.log("Vertical Scan: " .. y .. " Pos: " .. minetest.pos_to_string(p))
					if (check_pos_for_target(p, query)) then
						--minetest.log("found target node " .. target_height)
						if (not target_node_found) then
							target_node_found = true
						end
						target_height = target_height + 1
					else
						if (target_node_found) then
							if (target_height >= height) then
								return vector.new(p.x, p.y+1, p.z)
							else
								target_node_found = false
								target_height = 0
							end
						end
					end
				end
			end
		end
	end
	return nil
end




--[[
Humanoid texture generation function	
--]]

local function insert_backslash(s)
	if type(s) == "table" and s.name then
		s = s.name
	end
	if (type(s) ~= "string") then
		minetest.log("ERROR: " .. dump(s) .. "\nis not a string! Must be a string texture name!")
		return ""
	end
	s=string.gsub(s, "%^", "\\^")
	s=string.gsub(s, ":", "\\:")
    s=string.gsub(s, "\\\\", "\\^") --maybe should be .gsub(s, "\\\\", "\\")
	return s
end
--[[
	Generate a humanoid texture from a texture list  
	final result is a 16*4 by 16*6 texture  

	Params:
		base: 64 by 32 image  
		armor_list: list of 64 by 32 images  
		item: image texture for the held item  
		node: { ... } image list for the held node  
			1 item = all sides the same  
			3 items = +Y, -Y, sides  
			6 items = +Y, -Y, +X, -X, +Z, -Z  
		crown: image texture for teh held crown 

	Return a massive texture string
]]
function qts.make_humanoid_texture(base, armor_list, item, node, crown)
	local s = "[combine:64x96:0,0=" .. insert_backslash(base) ..  "\\^[resize\\:64x32"
	if (armor_list and #armor_list > 0) then
		s=s..":0,32=("..armor_list[1]
		for i = 2,#armor_list do
			armor_list[i] = insert_backslash(armor_list[i])
			s = s .. "\\^" .. armor_list[i] ..  "\\^[resize\\:64x32"
		end
		s=s..")"
	end
	if (item) then
		s=s..":32,64=(".. insert_backslash(item) ..")\\^[resize\\:16x16"
	end
	
	if node then
		local node2 = {} --for prevention of accumulated LONG strings of \^^\^\^^\^...
		for i = 1, #node do
			node2[i] = insert_backslash(node[i])
		end
		if #node == 1 then
			s=s..":0,64=(".. node2[1] .."\\^[resize\\:16x16)"..
				":16,64=(".. node2[1] .."\\^[resize\\:16x16)"..
				 ":0,80=(".. node2[1] .."\\^[resize\\:16x16)"..
				":16,80=(".. node2[1] .."\\^[resize\\:16x16)"..
				":32,80=(".. node2[1] .."\\^[resize\\:16x16)"..
				":48,80=(".. node2[1] .."\\^[resize\\:16x16)"
		elseif #node == 3 then
			
			s=s..":0,64=(".. node2[1] .."\\^[resize\\:16x16)"..
				":16,64=(".. node2[2] .."\\^[resize\\:16x16)"..
				 ":0,80=(".. node2[3] .."\\^[resize\\:16x16)"..
				":16,80=(".. node2[3] .."\\^[resize\\:16x16)"..
				":32,80=(".. node2[3] .."\\^[resize\\:16x16)"..
				":48,80=(".. node2[3] .."\\^[resize\\:16x16)"
		elseif #node == 6 then
			s=s..":0,64=(".. node2[1] .."\\^[resize\\:16x16)"..
				":16,64=(".. node2[2] .."\\^[resize\\:16x16)"..
				 ":0,80=(".. node2[3] .."\\^[resize\\:16x16)"..
				":16,80=(".. node2[4] .."\\^[resize\\:16x16)"..
				":32,80=(".. node2[5] .."\\^[resize\\:16x16)"..
				":48,80=(".. node2[6] .."\\^[resize\\:16x16)"
		end
	end
	
	if (crown) then
		s=s..":48,64=(".. insert_backslash(crown) .."\\^[resize\\:16x16)"
	end
	return s
end

local cubic_drawtype = {
	["normal"] = true,
	["liquid"] = true,
	["flowingliquid"] = true,
	["glasslike"] = true,
	["glasslike_framed"] = true,
	["glasslike_framed_optional"] = true,
	["allfaces"] = true,
	["allfaces_optional"] = true
}
--[[
	Generate a humanoid texture for a player or mob  

	Params:
		entity - the entity
		base - base texture, 64 by 32 image
]]
function qts.humanoid_texture(entity, base)
	local armor_list = {}
	local item = nil
	local node = {}
	local crown = nil
	
	--get the wielded item
	local wield_name = ""
	if entity:is_player() then
		wield_name = entity:get_wielded_item():get_name()
	else
		local luaentity = entity:get_luaentity()
		if luaentity.wielded_item then
			wield_name = ItemStack(luaentity.wielded_item):get_name()
		end
	end
	local itemdef = minetest.registered_items[wield_name]
	if itemdef and wield_name ~= "" then
		if (itemdef.type=="node" and cubic_drawtype[itemdef.drawtype]) then
			node = itemdef.tiles
		elseif (itemdef.inventory_image and itemdef.inventory_image ~= "") then
			item = itemdef.inventory_image
		elseif (itemdef.wield_image and itemdef.wield_image ~= "") then
			item = itemdef.wield_image
		end
	end
	
	local base_modified = base
	
	
	if entity:is_player() then
		for index, stack in ipairs(qts.get_player_equipment_list(entity)) do
			if not stack:is_empty() then
				local itemname = stack:get_name()
				local itemdef = minetest.registered_items[itemname]
				if itemdef then
					--skin overrides
					if itemdef.skin_image then
						if type(itemdef.skin_image) == "string" then
							base_modified = base_modified .. "^" .. itemdef.skin_image
						elseif type(itemdef.skin_image) == "function" then
							base_modified = base_modified .. "^" .. itemdef.skin_image(entity, stack)
						end
					end

					--armor
					if itemdef.armor_image then
						if type(itemdef.armor_image) == "string" then
							table.insert(armor_list, itemdef.armor_image)
						elseif type(itemdef.armor_image) == "function" then
							table.insert(armor_list, itemdef.armor_image(entity, stack))
						end
					end

					--crown
					if itemdef.crown_image then
						local newcrown;
						if type(itemdef.crown_image) == "string" then
							newcrown = itemdef.crown_image
						elseif type(itemdef.crown_image) == "function" then
							newcrown =  itemdef.crown_image(entity, stack)
						end

						if crown then
							crown = crown .. "^" .. newcrown
						else
							crown = newcrown
						end
					end

				end
			end
		end
	end
	--get armor
	
	--get crown
	
	return qts.make_humanoid_texture(base_modified, armor_list, item, node, crown)
end

--[[
	Modify a value by a level.

	Params:
		value - the value (a number)
		level - the level (a number)

	Reurns:
		the modified value
]]
function qts.modify_value_by_level(value, level)
	return value*((level*qts.LEVEL_MULTIPLIER)+1)
end
