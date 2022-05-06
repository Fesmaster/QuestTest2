

local lakeSize = 24
local halfLakeSize = lakeSize/2
local lakeSizeVector = vector.new(lakeSize,10,lakeSize)
local defolicationConstant = 2
local checkSteps = 6
local minAllowedVariance = 1
local minVarianceValue = 3

local function MakeLakeBasic(pos)
	local p1 = pos - lakeSizeVector
	local p2 = pos + lakeSizeVector
	local nodes = qts.readNodes(p1:copy(), p2:copy())
	
	local points = {}
	local dists = {}
	for i =1, math.random(3, 8) do
		points[#points+1] = vector.new(math.random(-halfLakeSize, halfLakeSize), 0, math.random(-halfLakeSize, halfLakeSize))
		dists[#dists+1] = math.random(3, 8)
	end
	
	for p_off, node in qts.nodePairs(nodes) do
		local pos = p_off - lakeSizeVector
		local isLake = false
		local distDelta = 0
		for i, point in ipairs(points) do
			local d = vector.distance(vector.new(pos.x, 0, pos.z), point)
			if d < dists[i] then
				isLake = true
				distDelta = distDelta + (dists[i] - d)
			end
		end
		--minetest.log(dump(distSum))
		if isLake then
			--part of the lake
			local waterHeight = 3
			if distDelta < 1 then waterHeight = 1
			elseif distDelta < 2 then waterHeight = 2
			end
			
			if pos.y > 0 then
				--make sure no *solid* nodes here.
				local must_destroy = false
				local def = minetest.registered_nodes[node.name]
				
				if def and def.paramtype and def.paramtype ~= "light" then
					must_destroy = true
				end
				if minetest.get_item_group(node.name, "shaped_node") ~= 0 then
					must_destroy = true
				end
				if minetest.get_item_group(node.name, "underbrush") ~= 0 then
					must_destroy = true
				end
				
				if must_destroy then
					node.name="air"
				end
			elseif pos.y > -waterHeight then
				node.name="default:river_water_source"
			elseif pos.y > -waterHeight*3 then
				node.name = "default:gravel"
				--qts.insert3(nodes, p_off, {name="default:gravel"})
			end
		end
	end
	
	--second pass, to wall in water, plant plants.
	local offsets = {vector.new(-1,0,0),vector.new(1,0,0),vector.new(0,0,-1),vector.new(0,0,1)}
	for p_off, node in qts.nodePairs(nodes) do
		if node and (node.name == "air" or minetest.get_item_group(node.name, "underbrush") ~= 0) then
			--first, wall in water
			local needsWall = false
			for i, off in ipairs(offsets) do
				local nearNode = qts.read3(nodes, p_off + off)
				if nearNode and nearNode.name and nearNode.name == "default:river_water_source" then
					needsWall = true
				end
			end
			if needsWall then
				node.name="default:gravel"
				
				--propigate down
				for y = p_off.y, 0, -1 do
					local pv = vector.new(p_off.x, y, p_off.z)
					local nearNode = qts.read3(nodes, pv)
					if nearNode and nearNode.name and nearNode.name == "air" then
						nearNode.name = "default:gravel"
					end
				end
			else
				--add reeds
				local unode = qts.read3(nodes, p_off+vector.new(0,-1,0))
				if unode and unode.name then
					if minetest.get_item_group(unode.name, "soil") ~= 0 or minetest.get_item_group(unode.name, "sand") ~= 0 then
						local nasWaterNear = false
						for i, off in ipairs(offsets) do
							local nearNode = qts.read3(nodes, p_off + off +vector.new(0,-1,0))
							if nearNode and nearNode.name and nearNode.name == "default:river_water_source" then
								nasWaterNear = true
							end
						end
						
						if nasWaterNear and math.random(5) == 1 then
							node.name = "default:reeds_"..math.random(1,4)
						end
					end
				end
			end
		end
	end
	qts.writeNodes(p1:copy(), p2:copy(), nodes)
	
	--perform defoliation, ie, forced aggressive leaf decay
	for pos in qts.rectangle(p1:copy(), p2:copy()) do
		local node = minetest.get_node_or_nil(pos)
		if node and node.name then
			if minetest.get_item_group(node.name, "leaves") ~= 0 and node.param2 == 0 then
				local r = minetest.find_node_near(pos, defolicationConstant, {"group:log"}, false)
				if r == nil then
					minetest.set_node(pos, {name="air"})
				end
			end
		end
	end
end

--checks if a node is ground
local function CheckNode(pos)
	local node = minetest.get_node_or_nil(pos)
	if node and node.name then
		if node.name == "air" then return false end
		if minetest.get_item_group(node.name, "underbrush") ~= 0 then return false end
		if minetest.get_item_group(node.name, "leaves") ~= 0 then return false end
		if minetest.get_item_group(node.name, "log") ~= 0 then return false end
	end --ignore if the node is not found
	return true
end

local function CheckLake(pos)
	local p1 = pos - lakeSizeVector
	local p2 = pos + lakeSizeVector
	
	local varianceCount = 0
	
	for i = 1, checkSteps do
		local x = math.random(p1.x, p2.x)
		local z = math.random(p1.z, p2.z)
		for y = p2.y, p1.y, -1 do
			if CheckNode(vector.new(x,y,z)) then
				if math.abs(y - pos.y) > minVarianceValue then
					varianceCount = varianceCount + 1
				end
				break
			end
		end
	end
	return varianceCount <= minAllowedVariance
end

minetest.register_node ("dungeon:lake_generator", {
	description = "Lake Generator",
	tiles = {"default.png"},
	groups = DUNGEON_GENERATOR_GROUPS,
	sounds = qtcore.node_sound_defaults(),
	drop = "",
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name="air"})
		if CheckLake(pos+vector.new(0,-1,0)) then
			MakeLakeBasic(pos+vector.new(0,-1,0))
		else
			minetest.log("Lake Failed.")
		end
		return itemstack
	end
})

if not qts.ISDEV then
	minetest.register_lbm({
		label = "Lake Generator",
		name = "dungeon:lake_generator_lbm",
		nodenames = {"dungeon:lake_generator"},
		run_at_every_load = false,
		action = function(pos, node)
			minetest.set_node(pos, {name="air"})
			if CheckLake(pos+vector.new(0,-1,0)) then
				MakeLakeBasic(pos+vector.new(0,-1,0))
			else
				minetest.log("Lake Failed.")
			end
		end
	})
end