
--qts.worldgen functionality
local CID = qts.worldgen.CID
local ORE = qts.worldgen.ORE
--qts.worldgen.mpagen_aliases

--[[
	Set the default nodes for map generation

	Params:
		stone = the name of the stone node
		water = the name of the water node
		river = the name of the river water node
]]
qts.worldgen.set_mapgen_defaults = function(stone, water, river)
	if not stone then stone = "air" end
	if not water then water = "air" end
	if not river then river = "air" end
	qts.worldgen.mpagen_aliases = {
		stone = stone,
		water = water,
		river = river
	}
end

--[[
	Add an item name to the worldgen CID (content ID)
	cache
	Since getting the CID cannot be done at the time LUA files are run,
	this makes an internal set of names that need CIDs,
	then generates them when it can.
	Once generated, they are found in qts.worldgen.CID[name]

	Params:
		name - the node name to add
]]
qts.worldgen.add_to_CID = function(name)
	qts.worldgen.CID_source[name] = true
end

--[[
ORE OVERRIDE
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_tin",
	wherein        = "default:stone",
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 1025,
	y_min          = -64,
})
]]
local register_ore_internal = minetest.register_ore

minetest.register_ore = function(def)
	ORE[def.ore] = true
	qts.worldgen.add_to_CID(def.ore)
	register_ore_internal(def)
end

--qts.worldgen.registered_biomes


--[[
	biome registration

	Params:
		name - string name of the biome
		def - teh Biome Definition Table

	Biome Definition Table
	{
	Where the biome will spawn
		heat_point = number, 0 to 100
		humidity_point = number, 0 to 100
		min_ground_height = number --unlike regular biomes, this is NOT the node Y height, it is the ground default height
		max_ground_height = number --unlike regular biomes, this is NOT the node Y height, it is the ground default height
		min_air - number of air blocks above that must exist
		min_light - min day light level

	What nodes are spawned
		dust                 -|
		surface               |
		fill                  |- nodenames, or arrays of nodenames for random picking
		stone                 |- These are the node categories
		underwater            |
		surface_water         |
		plant                -|

	How much of what does it spawn:
		surface_depth = number
		fill_depth = number
		stone_depth = number

	special spawn chance
		plant_freq 1 in x chance 
	}
	
--]]
qts.worldgen.register_biome = function(name, def)
	--add to worldgen CID system
	for i, t in ipairs{"dust", "surface", "fill", "stone", "plant", "surface_water", "underwater"} do
		if type(def[t]) == "string" then
			qts.worldgen.add_to_CID(def[t])
			def[t] = {def[t]} --force into a table
		elseif type(def[t]) == "table" then
			for j, n in ipairs(def[t]) do
				qts.worldgen.add_to_CID(n)
			end
		end
	end
	--min air reqired to generate surface
	if not def.min_air then def.min_air = 10 end
	if not def.min_light then def.min_light = 0 end
	if not def.plant_freq then def.plant_freq = 0 end
	if not def.surface_water then def.surface_water = -1 end
	--make these indexed to the surface
	def.stone_depth = def.stone_depth + def.fill_depth + def.surface_depth
	def.fill_depth = def.fill_depth + def.surface_depth
	def.name = name
	qts.worldgen.registered_biomes[name] = def
end


--[[
	Get a biome node, from the type provided

	Params:
		name - the biome name
		ntype - category, one of "dust", "surface", "fill", "stone", "plant", "underwater", "surface_water"
		asCID - boolean, if true, then return teh CID instead of the name

	Returns:
		name or CID of oen of the nodes if found, otherwise nil
]]
qts.worldgen.get_biome_node = function(name, category, asCID)
	if asCID == nil then asCID = true end
	if qts.worldgen.registered_biomes[name] and qts.worldgen.registered_biomes[name][category] then
		local nodelist = qts.worldgen.registered_biomes[name][category]
		local found = nil
		while (found == nil) do
			local nodename = nodelist[math.random(#nodelist)]
			if CID[nodename] then
				found = nodename
			end
		end
		if asCID then
			return CID[found]
		else
			return found
		end
	end
	--minetest.log("get_biome_node: biome or level do not exist Biome: ".. name .. " Node Type: "..ntype)
	return nil
end

--[[
	check if a CID is part of a particular biome

	Params:
		cid - the node's CID
		biome - the biome name
		group - the array of categories to check, and defaults to the full list
				values can be: "dust", "surface", "fill", "stone", "plant", "underwater", "surface_water"
		solidOnly - only check  "solid" groups, IE, ignoring "plant" and  "dust"

	Returns:
		boolean true or false
]]
qts.worldgen.is_biome_node = function(cid, biome, group, solidOnly)
	if solidOnly == nil then solidOnly = true end
	local check = {"dust", "surface", "fill", "stone", "plant", "underwater", "surface_water"}
	if group then
		check = group
	end
	local ignore_keys = {}
	if solidOnly then
		ignore_keys.dust = true
		ignore_keys.plant = true
	end
	local biomeDef =  qts.worldgen.registered_biomes[biome]
	if biomeDef then
		for i, t in ipairs(check) do
			if not ignore_keys[t] then
				local nodelist = biomeDef[t]
				if nodelist then
					for j, node in ipairs(nodelist) do
						if cid == CID[node] then 
							return true
						end
					end
				end
			end
		end
	end
	return false
end

--[[
	these "distance functions" accept 2 points structured like:
	p{
		heat = 
		humid = 
	}
	the reason that this systen exists is because im not sure how I want to 
	calculate which biome that a specific heat/humid value is in
--]]
qts.worldgen.dist_funcs = {
	euclidian = function(p1, p2)
		return math.sqrt((p1.heat - p2.heat)^2 + (p1.humid - p2.humid)^2)
	end,
	manhatten = function(p1, p2)
		return math.abs(p1.heat - p2.heat) + math.abs(p1.humid - p2.humid)
	end,
	less = function(p1, p2)
		return math.min(math.abs(p1.heat - p2.heat), math.abs(p1.humid - p2.humid))
	end,
	greatest = function(p1, p2)
		return math.max(math.abs(p1.heat - p2.heat), math.abs(p1.humid - p2.humid))
	end,
	average = function(p1, p2)
		return (math.abs(p1.heat - p2.heat) + math.abs(p1.humid - p2.humid)) / 2
	end,
}
local select_dist_func = "euclidian"

--[[
	Set the distance function used to select biomes
	The default function is "euclidian"

	Params:
		fname - the function name, one of: "euclidian", "manhatten", "less", "greatest", "average"
]]
qts.worldgen.set_dist_func = function(fname)
	if qts.worldgen.dist_funcs[fname] then
		qts.worldgen.select_dist_func = fname
		select_dist_func = fname
	end
end


--[[
	this function gets the biome name based off of heat and humidity values

	Params:
		heat - the heat point (from a heat map)
		humidity - the humidity point (from a humidity map)
		height - the map height (from a height map)

	Returns:
		a biome name

	Errors:
		if it cannot find a biome, it will raise an error
--]]
qts.worldgen.get_biome_name = function(heat, humidity, height)
	local nearest_name = nil
	local nearest_dist = nil
	
	local df = qts.worldgen.dist_funcs[select_dist_func]
	for name, def in pairs(qts.worldgen.registered_biomes) do --
		--minetest.log("Checking biome: " .. dump(name))
		if 	(def.min_ground_height == nil and def.max_ground_height == nil)
				or (def.min_ground_height == nil and height <= def.max_ground_height)
				or (def.max_ground_height == nil and height >= def.min_ground_height) 
				or (height <= def.max_ground_height and height >= def.min_ground_height) then
			--it works
			--minetest.log("Biome: " .. dump(name) .. ": Checking nearest...")
			if nearest_name then
				local dist = df({heat = heat, humid = humidity}, {heat = def.heat_point, humid = def.humidity_point})
				if dist < nearest_dist then
					--minetest.log("Biome: " .. dump(name) .. ": Nearest replacement")
					nearest_dist = dist
					nearest_name = name
				end
			else
				--minetest.log("Biome: " .. dump(name) .. ": No nearest. Using this")
				nearest_name = name
				nearest_dist = df({heat = heat, humid = humidity}, {heat = def.heat_point, humid = def.humidity_point})
			end
		else
			--minetest.log("Biome: " .. dump(name) .. " is not in the right height")
			--minetest.log("Ignoring biome (wrong height): "..dump(name)..", height: "..dump(height))
		end
	end
	if nearest_name then
		return nearest_name
	else
		error("WORLDGEN: error: biome generation issue. Height: " .. dump(height))
	end
end



--qts.worldgen.registered_structures

--[[
	Register a structure to spawn

	Params:
		name - the structure name
		def - the Structure Definition Table

	Structure Definition Table
		{
			schematic = "path to schematic.mts" --must contain ".mts", it is not added for you!!
			chance = number                     --one in chance of placing. math: math.random(chance) == 1
			biomes = {} or "name"               --the biome names (converted to table in register)
			nodes = {} or "name"                --the below node names (converted to table in register)
			force_place = boolean [false]       --should the placement be forced?
			rotate = boolen [true]              --should the placed rotation be random?
			offset = vector or nil              --offset to placement
			flags = string [""]                 --minetest schematic placement flags
		}

--]]
qts.worldgen.register_structure = function(name, def)
	--biomes and nodes are changed to sets, to more easily check to see if a value is in them
	if type(def.biomes) == "string" then
		local s = def.biomes
		def.biomes = {s = true}
	else
		def.biomes = Set(def.biomes)
	end
	if type(def.nodes) == "string" then
		local n = def.nodes
		def.nodes = {n = true}
	else
		def.nodes = Set(def.nodes)
	end
	if def.force_place == nil then def.force_place = false end
	if def.rotate == nil then def.rotate = false end
	if not def.offset then def.offset = vector.zero() end
	if not def.flags then def.flags = "" end
	def.name = name
	
	qts.worldgen.registered_structures[name] = def
end

--[[
	Check if a structure can be placed in a biome and at a specific block

	Params:
		name - the structure name
		biome - the biome name
		cid - the block CID
	
	Returns:
		boolean true or false
]]
qts.worldgen.check_structure = function(name, biome, cid)
	local strucDef = qts.worldgen.registered_structures[name]
	if strucDef then
		if strucDef.biomes[biome] and strucDef.nodes[minetest.get_name_from_content_id(cid)] then
			--minetest.log("Structure chance")
			return math.random(strucDef.chance) == 1
		else
			--minetest.log("Error:"..dump(strucDef.biomes).."\n"..dump(strucDef.nodes))
			return false
		end
	end
	return false
end

--used to get the flag string for centering a schmatic
--[[
	Get a shematic center string from a bool vector

	Params:
		x = bool - should center on X
		y = bool - should center on Y
		z = bool - should center on Z

	Return:
		a string compatible with schematic placing functions
]]
qts.worldgen.centers = function(x, y, z)
	local str = ""
	if x then str = str .. "place_center_x," end
	if y then str = str .. "place_center_y," end
	if z then str = str .. "place_center_z" end
	return str
end

--[[
	register a node to be scattered over a biome in world generation

	Params:
		name - the scatter name
		def - the Scatter Definition Table

	Scatter Definition Table
		{
			nodes = {} or string			--list of possible nodename
			replace = {} or nil or string	--list of nodes that can be replaced, nil or {} to ignore
			above = {} or nil or string		--list of nodes that must be above, nil or {} to ignore
			below = {} or nil or string 	--list of nodes that must be below, nil or {} to ignore
			beside = {} or nil or string	--list of nodes that must be next to, nil or {} to ignore
			biomes = {} or nil or string	--list of the allowed biomes. nil or {} to ignore
			beside_count = 1-4 [1]			--how many of the beside nodes must be in the category. defaults to 1
			chance = number [100]			--one in x chance of placing this node. defaults to 100.
			stage = one of: ("pre-structre", "post-structure", "post-plant", "post-ore")
		}

--]]
qts.worldgen.register_scatter = function (name, def)
	if def.nodes and type(def.nodes) == "string" then
		def.nodes = {def.nodes}
	end
	if def.replace and type(def.replace) == "string" then
		def.replace = {def.replace}
	end
	if def.above and type(def.above) == "string" then
		def.above = {def.above}
	end
	if def.below and type(def.below) == "string" then
		def.below = {def.below}
	end
	if def.beside and type(def.beside) == "string" then
		def.beside = {def.beside}
	end
	if def.biomes and type(def.biomes) == "string" then
		def.biomes = {def.biomes}
	end
	--add stuff to CID
	if def.nodes then
		for i, name in ipairs(def.nodes) do
			qts.worldgen.add_to_CID(name)
		end
	end
	if def.replace then
		for i, name in ipairs(def.replace) do
			qts.worldgen.add_to_CID(name)
		end
	end
	if def.above then
		for i, name in ipairs(def.above) do
			qts.worldgen.add_to_CID(name)
		end
	end
	if def.below then
		for i, name in ipairs(def.below) do
			qts.worldgen.add_to_CID(name)
		end
	end
	if def.beside then
		for i, name in ipairs(def.beside) do
			qts.worldgen.add_to_CID(name)
		end
	end

	def.beside_count = def.beside_count or 1
	def.chance = def.chance or 100
	def.stage = def.stage or "pre-structure"
	def.name = name
	qts.worldgen.scatters_stage_marker[def.stage] = true
	qts.worldgen.registered_scatters[name] = def;

end

--[[
	Check if a particular position should have a scatter node put into it

	Params:
		def - the scatter def
		x, y, z - the position
		Area - the VoxelArea ref
		Data - the node data
		biomeID - the biome name. one of ("pre-structure", "post-structure", "post-plant", "post-ore")

	Returns:
		boolean true or false
--]]
qts.worldgen.check_scatter = function(def, x, y, z, Area, Data, biomeID)
	local allowed = false

	if def.biomes and #def.biomes > 0 then
		allowed = false
		for _, biome in ipairs(def.biomes) do
			if biome == biomeID then allowed = true end
		end
		if not allowed then return false end
	end
	
	if def.replace and #def.replace > 0 then
		allowed = false
		local i = Area:index(x, y, z)
		for _, name in ipairs(def.replace) do
			if Data[i] == CID[name] then allowed = true end
		end 
		if not allowed then return false end
	end

	if def.below and #def.below > 0 then 
		allowed = false
		local i = Area:index(x, y-1, z)
		for _, name in ipairs(def.below) do
			if Data[i] == CID[name] then allowed = true end
		end
		if not allowed then return false end
	end

	if def.above and #def.above > 0 then 
		allowed = false
		local i = Area:index(x, y-1, z)
		for _, name in ipairs(def.above) do
			if Data[i] == CID[name] then allowed = true end
		end
		if not allowed then return false end
	end

	if def.beside and #def.beside > 0 then 
		local xoff = {-1, 1, 0, 0}
		local zoff = {0, 0, -1, 1}
		local count = 0
		for j = 1, 4 do
			allowed = false
			local i = Area:index(x+xoff[j], y, z+zoff[j])
			for _, name in ipairs(def.beside) do
				if Data[i] == CID[name] then allowed = true end
			end
			if allowed then 
				count = count + 1
			end
		end
		if count < def.beside_count then
			return false
		end
	end
	return math.random(def.chance) == 1
end

--[[
	run a stage of the scatter process

	Params:
		Area - the VoxelArea reference
		Data - the CID data
		BiomeBuffer - the biome buffer
		minp, maxp - the min and max positions as vectors
		stageName - the stage name, as string. One of: ("pre-structure", "post-structure", "post-plant", "post-ore")

	Returns:
		Data
--]]
qts.worldgen.process_scatter_stage = function(Area, Data, BiomeBuffer, minp, maxp, stageName)
	if qts.worldgen.scatters_stage_marker[stageName] == nil then return Data end
	--minetest.log("WorldGen: Scatterer: Running stage:" .. stageName)
	local columnID = 1
	for z = minp.z+1, maxp.z-1 do
	for x = minp.x+1, maxp.x-1 do
		local biomeID = BiomeBuffer[columnID]
		for y = maxp.y-1, minp.y+1, -1 do
			local i = Area:index(x, y, z)
			for name, def in pairs(qts.worldgen.registered_scatters) do
				if def.stage == stageName and qts.worldgen.check_scatter(def, x, y, z, Area, Data, biomeID) then
					Data[i] = CID[def.nodes[math.random(#def.nodes)]]
					break
				end
			end
		end
		columnID = columnID + 1
	end
	end
	return Data
end