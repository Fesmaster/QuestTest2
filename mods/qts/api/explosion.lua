qts.EXPLOSION_MAX_STEPS = qts.settings.get_num('EXPLOSION_MAX_STEPS') or 1000
--qts.EXPLOSION_DEFAULT_STEP_SIZE = 0.9

--node found list
--a table with a bunch of positions as keys, and a code stored there.
--if code == 0 then the node was probably nil
--if code == 1, it does not have an on_blast function
--if code == 2, it does have an on_blast function

--[[
Explosion properties
properties = {
	destroy_nodes = true,
	make_drops = true,
	drop_speed_multiplier = 1,
	make_sound = true,
	make_particles = true,
	particle_multiplier = 1,
	damage_entities = true,
	push_entities = true,
	damage_player = true,
	damage_type = "fleshy",
	exploder = nil
}
--]]

local function add_to_drops_table(drops, itemstack)
	local itbl = ItemStack(itemstack):to_table()
	for i, d in ipairs(drops) do
		if d.name == itbl.name and d.metadata == itbl.metadata and d.wear == itbl.wear then
			drops[i].count = d.count + itbl.count
			return drops
		end
	end
	drops[#drops + 1] = itbl
	return drops
end

local function append_drops_list(DL1, DL2)
	if (DL1 and DL2) then
		for i, d in ipairs(DL2) do
			DL1 = add_to_drops_table(DL1, d)
		end
	end
	return DL1
end

local function append_found_list(FL1, FL2)
	for pos, code in pairs(FL2) do
		if not FL1[pos] then
			FL1[pos] = code
		end
	end
	return FL1
end

local function destroy_exploded_nodes(foundList)
	for key, code in pairs(foundList) do
		local pos, _ = vector.from_string(key)
		if pos ~= nil then
			if code == 1 then
				--local name = minetest.get_node(pos).name
				--local liquid  = minetest.get_item_group(name, "liquid")
				if (minetest.get_item_group(minetest.get_node(pos).name, "liquid") == 0) then --don't blow up liquids
					minetest.remove_node(pos)
				end
			end
		end
	end
	--check for falling node AFTER all removed
	for key, code in pairs(foundList) do
		local pos, _ = vector.from_string(key)
		minetest.check_for_falling(pos)
	end
end

--stolen from tnt mod TESTING ONLY
local function rand_pos(center, pos, radius)
	local def
	local reg_nodes = minetest.registered_nodes
	local i = 0
	repeat
		-- Give up and use the center if this takes too long
		if i > 4 then
			pos.x, pos.z = center.x, center.z
			break
		end
		pos.x = center.x + math.random(-radius, radius)
		pos.z = center.z + math.random(-radius, radius)
		def = reg_nodes[minetest.get_node(pos).name]
		i = i + 1
	until def and not def.walkable
end

local function eject_drops(drops, pos, radius, speed_multiplier)
	speed_multiplier = speed_multiplier or 1
	local drop_pos = vector.new(pos)
	for _, item in pairs(drops) do
		item = ItemStack(item)
		local count = math.min(item:get_count(), item:get_stack_max())
		while count > 0 do
			local take = math.max(1,math.min(radius * radius,
					count,
					item:get_stack_max()))
			rand_pos(pos, drop_pos, radius)
			local dropitem = ItemStack(item)
			dropitem:set_count(take)
			local obj = minetest.add_item(drop_pos, dropitem)
			if obj then
				obj:get_luaentity().collect = true
				obj:set_acceleration({x = 0, y = -10, z = 0})
				obj:set_velocity(vector.multiply(vector.new(
						math.random(-3, 3),
						math.random(0, 10),
						math.random(-3, 3))
					, speed_multiplier))
			end
			count = count - take
		end
	end
end

function qts.explode_sound(pos, distance)
	minetest.sound_play("explosion",
	{
		gain = 1,
		max_hear_distance = distance,
		loop = false,
		pos = pos
	})
end

function qts.explode_particles(pos, radius, mult)
	mult = mult or 1
	local particleSpeed = 30
	local maxTime = radius / particleSpeed
	local minTime = maxTime / 4
	local images = {"explosion_blast_01.png", "explosion_blast_02.png", "explosion_blast_03.png"}
	for i, image in ipairs(images) do
		minetest.add_particlespawner({
			amount = 64 * mult,
			time = 0.1,
			minpos = vector.subtract(pos, radius / 2),
			maxpos = vector.add(pos, radius / 2),
			minvel = vector.new(-particleSpeed, -particleSpeed, -particleSpeed),
			maxvel = vector.new(particleSpeed, particleSpeed, particleSpeed),
			minacc = vector.zero(),
			maxacc = vector.zero(),
			minexptime = minTime,
			maxexptime = maxTime,
			minsize = radius * 3,
			maxsize = radius * 5,
			texture = image,
		})
	end
end

local function append_object_list(OL1, OL2)
	for k, v in pairs(OL2) do
		if (OL1[k] == nil) then
			OL1[k] = v
		end
	end
	return OL1
end

local function blast_objects(objectList, pos, power, properties)
	if (properties.damage_entities == nil) then properties.damage_entities = true end
	if (properties.push_entities == nil) then properties.push_entities = true end
	if (properties.damage_player == nil) then properties.damage_player = true end
	properties.damage_type = properties.damage_type or "fleshy"
	
	for k, obj in pairs(objectList) do
		if (obj) then
			local armor = obj:get_armor_groups()
			if (not armor.immortal) then
				local origin = obj:get_pos()
				--push the object
				local dir = vector.direction(pos, origin)
				local dist = vector.distance(pos, origin)
				if (not obj:is_player() and properties.push_entities) then
					obj:add_velocity(vector.multiply(dir, (power - (dist*dist))))
				end
				
				--damage the object
				local puncher = properties.exploder or obj
				if (
						((obj:is_player()) and properties.damage_player) or 
						((not obj:is_player()) and properties.damage_entities))
						then
					local radius = math.sqrt(power)
					local damageMult = (radius - dist)/radius
					obj:punch(puncher, 1.1,  {
						max_drop_level = 1,
						groupcaps = {},
						damage_groups = {
							[properties.damage_type] = power * damageMult,
						},
						full_punch_interval = 1,
						punch_attack_uses = 0
					},	dir) 
				end
			end
		end
	end
end

function qts.explode_ray(pos, slopeVector, stepSize, power, returnFound, excludeDrops)
	slopeVector = vector.multiply(vector.normalize(slopeVector), stepSize)
	excludeDrops = excludeDrops or {}
	local check = vector.new(pos.x, pos.y, pos.z)
	local currentPower = power
	local found = {}
	local drops = {}
	local objects = {}
	
	local DEBUG_ITERS = 0
	local prevdist = 0
	for i = 1, qts.EXPLOSION_MAX_STEPS do
		
		if ( --breaking rays that have NAN directions
				check.x ~= check.x 
				or check.y ~= check.y 
				or check.z ~= check.z
			) then
			break
		end
		
		DEBUG_ITERS = DEBUG_ITERS + 1
		
		local c1 = vector.new(math.floor(check.x), math.floor(check.y), math.floor(check.z))
		local c2 = vector.new(math.ceil(check.x),  math.ceil(check.y),  math.ceil(check.z) )
		local dist = vector.distance(pos, check)
		local maxPow = 0
		--collect the four nodes that are hit, and explode them them
		for x = c1.x, c2.x do
		for y = c1.y, c2.y do
		for z = c1.z, c2.z do
			local p = vector.new(x, y, z)
			local key = p:to_string()
			if not found[key] then
				local node = minetest.get_node_or_nil(p)
				if node then
					local desPow = math.max(
						minetest.get_item_group(node.name, "cracky") * 2,
						minetest.get_item_group(node.name, "choppy"),
						minetest.get_item_group(node.name, "crumbly"),
						minetest.get_item_group(node.name, "snappy") * 0.5,
						minetest.get_item_group(node.name, "explode_resistance")
					)
					if maxPow < desPow and desPow >= currentPower then
						maxPow = desPow
					end
					
					local nodeDef = minetest.registered_nodes[node.name]
					if nodeDef and nodeDef.on_blast then 
						found[key] = 2
						if excludeDrops[key] == nil then --if drops are excluded for this pos, don't call the func
							local customDrops = nodeDef.on_blast(p, currentPower)
							if customDrops and type(customDrops) == "table" then
								for i, drop in ipairs(customDrops) do
									drops = add_to_drops_table(drops, drop)
								end
							end
						end
					else
						--ones that do not have a function
						if desPow <= currentPower then
							found[key] = 1
							if excludeDrops[key] == nil then --if drops are excluded for this pos, don't collect the drops
								local nodeDrops = minetest.get_node_drops(node.name)
								for i, drop in ipairs(nodeDrops) do
									drops = add_to_drops_table(drops, drop)
								end
							end
						end
					end
				end
				if not found[key] then
					found[key] = 0
				end
			end
		end
		end
		end
		
		--get any entities in the ray
		if (
				check.x == check.x 
				and check.y == check.y 
				and check.z == check.z
			) then --weirdness relying on NAN not being equal to itself
			
			local objs = minetest.get_objects_inside_radius({x=check.x, y=check.y, z=check.z}, 2)
			for i, obj in ipairs(objs) do
				if (obj and obj.get_pos) then
					if (objects[obj:get_pos()]) then
						--already found
						--ignore for now
						minetest.log("EXPLOSION RAY: object collection: duplicate found?! Overrideing")
					end
					objects[minetest.pos_to_string(obj:get_pos())] = obj
				end
			end
		else
			minetest.log("EXPLOSION RAY: Weirdness with position when getting objects")
		end
		
		local distPowLoss = (dist * dist) - (prevdist * prevdist)
		currentPower = currentPower - (distPowLoss + maxPow)
		if currentPower <= 0 then
			break
		end
		
		prevdist = dist
		check = vector.add(check, slopeVector)
	end
	--collected all the nodes hit
	--return if needed
	if returnFound then
		--should return drops too
		return {found = found, drops = drops, objects = objects}
	end
	--create drops TODO:create drops
	eject_drops(drops, pos, 1)
	--otherwise, actually destroy then
	destroy_exploded_nodes(found)
	--shove objects
	blast_objects(objects, pos, power)
	return {found = found, drops = drops, objects = objects}
end

--icky thing cause my calculation currently sucks
local explotion_ray_multiplier = {
	20, 100
}

function qts.explode(pos, power, properties)
	if (properties == nil or type(properties) ~= "table") then
		properties = {
			destroy_nodes = true,
			make_drops = true,
			drop_speed_multiplier = 1,
			make_sound = true,
			make_particles = true,
			particle_multiplier = 1,
			damage_entities = true,
			push_entities = true,
			damage_player = true,
			damage_type = "fleshy",
			exploder = nil
		}
	end
	
	local EstimatedRadius = math.sqrt(power)
	local SurfaceArea = 4 * math.pi * EstimatedRadius
	--1 ray for every 4 blocks, but also there should be slightly less..
	local rays = (SurfaceArea) --ray reduction const
	
	for i, val in ipairs(explotion_ray_multiplier) do
		if (power > val) then
			rays = rays * 2
		end
	end
	
	rays = rays * (math.random(800, 900)/1000)--randomize the explosion shape
	
	local stepSize = 0.9
	
	local found = {}
	local drops = {}
	local objects = {}
	
	local points = qts.distribute_points_on_sphere(rays)
	for i, point in ipairs(points) do
		local f = qts.explode_ray(pos, point, stepSize, power, true, found)
		found = append_found_list(found, f.found)
		if (f.drops) then
			drops = append_drops_list(drops, f.drops)
		end
		if (f.objects) then
			--minetest.log(dump(f.objects))
			objects = append_object_list(objects, f.objects)
		end
	end
	
	if (properties.make_drops) then
		eject_drops(drops, pos, EstimatedRadius, (properties.drop_speed_multiplier or 1))
	end
	if (properties.destroy_nodes) then
		destroy_exploded_nodes(found)
	end
	if (properties.make_particles) then
		qts.explode_particles(pos, EstimatedRadius, (properties.particle_multiplier or 1))
	end
	if (properties.make_sound) then
		qts.explode_sound(pos, math.pow(EstimatedRadius * 4, 2))
	end
	blast_objects(objects, pos, power, properties)
end

