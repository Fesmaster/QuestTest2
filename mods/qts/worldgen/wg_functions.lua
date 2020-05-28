
--qts.worldgen functionality
local CID = qts.worldgen.CID
--qts.worldgen.mpagen_aliases

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

qts.worldgen.add_to_CID = function(name)
	qts.worldgen.CID_source[name] = true
end
--[[
biome registration
keys in def:
	#where it will spawn
	heat_point = number
	humidity_point = number
	min_ground_height = number --unlike regular biomes, this is NOT the node Y height, it is the ground default height
	max_ground_height	^^
	min_air - #of air blocks above that must exist
	min_light - min day light level
	
	#what it spawns
	dust = "nodename"    -|
	surface = "nodename"  |
	fill = "nodename"     |- these SHOULD be able to be tables to get a random one, too
	stone = "nodename"    |
	plant = "nodename"   -|
	
	#how much does it spawn
	surface_depth = number
	fill_depth = number
	stone_depth = number
	
	#special spawn chance
	plant_freq (0-100) % chance of a plant growing math: math.random(100-plant_freq) == 1
	
--]]
--qts.worldgen.registered_biomes
qts.worldgen.register_biome = function(name, def)
	--add to worldgen CID system
	for i, t in ipairs{"dust", "surface", "fill", "stone", "plant"} do
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
	if not def.plant_freq then def.plant_freq = 50 end
	--make these indexed to the surface
	def.stone_depth = def.stone_depth + def.fill_depth + def.surface_depth
	def.fill_depth = def.fill_depth + def.surface_depth
	def.name = name
	qts.worldgen.registered_biomes[name] = def
end

--name = biome name
--ntype = "dust", "surface", "fill", "stone", "plant"
qts.worldgen.get_biome_node = function(name, ntype, asCID)
	if asCID == nil then asCID = true end
	if qts.worldgen.registered_biomes[name] and qts.worldgen.registered_biomes[name][ntype] then
		local nodelist = qts.worldgen.registered_biomes[name][ntype]
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
	minetest.log("get_biome_node: biome or level do not exist Biome: ".. name .. " Node Type: "..ntype)
	return nil
end

qts.worldgen.is_biome_node = function(cid, biome, group, solidOnly)
	if solidOnly == nil then solidOnly = true end
	local check = {"dust", "surface", "fill", "stone", "plant"}
	if group then
		check = group
	end
	if solidOnly then
		check.dust = nil
		check.plant = nil
	end
	local biomeDef =  qts.worldgen.registered_biomes[biome]
	if biomeDef then
		for i, t in ipairs(check) do
			local nodelist = biomeDef[t]
			if nodelist then
				for i, node in ipairs(nodelist) do
					if cid == CID[node] then 
						return true
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

qts.worldgen.set_dist_func = function(fname)
	if qts.worldgen.dist_funcs[fname] then
		qts.worldgen.select_dist_func = fname
	end
end


--[[
	this function gets the biome name based off of heat and humidity values
--]]
qts.worldgen.get_biome_name = function(heat, humidity, height)
	local nearest_name = nil
	local nearest_dist = nil
	local df = qts.worldgen.dist_funcs[select_dist_func]
	for name, def in pairs(qts.worldgen.registered_biomes) do --
		if 	(def.min_ground_height == nil and def.max_ground_height == nil)
				or (def.min_ground_height == nil and height <= def.max_ground_height)
				or (def.max_ground_height == nil and height >= def.min_ground_height) 
				or (height <= def.max_ground_height and height >= def.min_ground_height) then
			--it works
			if nearest_name then
				local dist = df({heat = heat, humid = humidity}, {heat = def.heat_point, humid = def.humidity_point})
				if dist < nearest_dist then
					nearest_dist = dist
					nearest_name = name
				end
			else
				nearest_name = name
				nearest_dist = df({heat = heat, humid = humidity}, {heat = def.heat_point, humid = def.humidity_point})
			end
		--else
			--minetest.log("Ignoring biome (wrong height): "..dump(name)..", height: "..dump(height))
		end
	end
	if nearest_name then
		return nearest_name
	end
end



--qts.worldgen.registered_structures
--[[
def contains:
	schematic = "path to schematic.mts" --must contain ".mts", it is not added for you!!
	chance = (0-100) % chance of placing. math: math.random(100-freq) == 1
	biomes = {} or "name" (converted to table in register)
	nodes = {} or "name" (converted to table in register)
	force_place = false -- should the placement be forced?
	rotate = true - should the placed rotation be random?
	offset = vector or nil
	flags = flags for placing
--]]
qts.worldgen.register_structure = function(name, def)
	--biomes and nodes are changed to sets, to more easily check to see if a value is in them
	if type(def.biomes) == "string" then
		local s = def.biomes
		def.biomes = {s = true}
	else
		def.biomes = qts.Set(def.biomes)
	end
	if type(def.nodes) == "string" then
		local n = def.nodes
		def.nodes = {n = true}
	else
		def.nodes = qts.Set(def.nodes)
	end
	if def.force_place == nil then def.force_place = false end
	if def.rotate == nil then def.rotate = false end
	if not def.offset then def.offset = {x=0,y=0,z=0} end
	if not def.flags then def.flags = "" end
	def.name = name
	
	qts.worldgen.registered_structures[name] = def
end

qts.worldgen.check_structure = function(name, biome, cid)
	local strucDef = qts.worldgen.registered_structures[name]
	if strucDef then
		if strucDef.biomes[biome] and strucDef.nodes[minetest.get_name_from_content_id(cid)] then
			--minetest.log("Structure chance")
			return math.random(100-strucDef.chance) == 1
		else
			--minetest.log("Error:"..dump(strucDef.biomes).."\n"..dump(strucDef.nodes))
			return false
		end
	end
	return
end

--used to get the flag string for centering a schmatic
qts.worldgen.centers = function(x, y, z)
	local str = ""
	if x then str = str .. "place_center_x," end
	if y then str = str .. "place_center_y," end
	if z then str = str .. "place_center_z" end
	return str
end

--name, pos, vm, flags
qts.worldgen.place_structure = function(name, pos, VM)
	local strucDef = qts.worldgen.registered_structures[name]
	if strucDef then
		
	end
end