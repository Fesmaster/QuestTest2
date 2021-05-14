--worldgen stuff

--the worldgen namespace
--septerated form the main qts namespace beacuse it has terribly many functions
qts.worldgen = {}
qts.worldgen.mpagen_aliases = {} --holder for the alias system
qts.worldgen.CID = {} --holder for contentIDs
qts.worldgen.ORE = {}
qts.worldgen.CID_source = {}
qts.worldgen.registered_biomes = {}
qts.worldgen.registered_structures = {}
qts.worldgen.force_singlenode = false

local CID = qts.worldgen.CID --to simplify and shorten the naming
local ORE = qts.worldgen.ORE --also faster

dofile(qts.path .."/worldgen/wg_functions.lua") --load all the functions

local function genParam2Meshoptions()
	return (math.random(0,4)		--first 3 bits (0,1,2)
		+ (math.random(0,1) * 8)    --bit 3
		+ (math.random(0,1) * 16)   --bit 4
		+ (math.random(0,1) * 32))  --bit 5
end

local function genParam2Facedir()
	return math.random(0,3)
end

local function isGenGround(cid)
	--if cid == CID["air"] or cid == CID["water"] or cid == CID["river"] then
	--	return false
	--else
	--	return true
	--end
	if cid == CID['ground'] then return true end
	for name, c in pairs(ORE) do
		if cid == c then return true end
	end
end

local function isGenWater(cid)
	--if cid == CID["water"] or cid == CID["river"] then
	if cid == CID["water"]	then
		return true
	end
	return false
end
minetest.register_on_mods_loaded(function()
	minetest.set_mapgen_setting("mg_flags", "caves,nodungeons,light,decorations,biomes", true)
	
	minetest.register_alias("mapgen_stone", qts.worldgen.mpagen_aliases.stone)
	minetest.register_alias("mapgen_water_source", qts.worldgen.mpagen_aliases.water)
	minetest.register_alias("mapgen_river_water_source", qts.worldgen.mpagen_aliases.river)
	
	--get the contentIDs and store them
	for name, v in pairs(qts.worldgen.CID_source) do
		CID[name] = minetest.get_content_id(name)
	end
	CID["air"] = minetest.CONTENT_AIR
	CID["ground"] = minetest.get_content_id(qts.worldgen.mpagen_aliases.stone)
	CID["water"] = minetest.get_content_id(qts.worldgen.mpagen_aliases.water)
	CID["river"] = minetest.get_content_id(qts.worldgen.mpagen_aliases.river)
	
	for name, _ in pairs(ORE) do
		ORE[name] = CID[name]
	end
	--minetest.register_alias("mapgen_singlenode", "air")
	
	--mapgen v6 aliases. NOT SET
	--mapgen_stone
	--mapgen_water_source
	--mapgen_lava_source
	--mapgen_dirt
	--mapgen_dirt_with_grass
	--mapgen_sand
	--mapgen_gravel
	--mapgen_desert_stone
	--mapgen_desert_sand
	--mapgen_dirt_with_snow
	--mapgen_snowblock
	--mapgen_snow
	--mapgen_ice
	--
	--mapgen_tree
	--mapgen_leaves
	--mapgen_apple
	--mapgen_jungletree
	--mapgen_jungleleaves
	--mapgen_junglegrass
	--mapgen_pine_tree
	--mapgen_pine_needles
	--
	--mapgen_cobble
	--mapgen_stair_cobble
	--mapgen_mossycobble
	--mapgen_stair_desert_stone
end)

---[[
minetest.register_on_generated(function(minp, maxp, blockseed)
	--minetest.log("WORLDGEN 1")
	local columnID = 1
	local heightmap = minetest.get_mapgen_object("heightmap")
	local heatmap = minetest.get_mapgen_object("heatmap")
	local humiditymap = minetest.get_mapgen_object("humiditymap")
	local VM, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local Area = VoxelArea:new{MinEdge = {x = emin.x, y = emin.y, z = emin.z}, MaxEdge = {x = emax.x, y = emax.y, z = emax.z}}
	local Data= VM:get_data()
	local LightData = VM:get_light_data()
	local Param2Data = VM:get_param2_data()
	
	local biomeID = nil
	local biomeRef = nil 
	
	local structures = {}
	
	local biomeBuffer = {}
	
	--probably using Singlenode
	if (heatmap == nil) or (humiditymap == nil) or (heightmap == nil) then
		return
	end
	
	--local heightBuffer = {}
	--minetest.log("WORLDGEN 2")
	--for every Y column
	for z = minp.z, maxp.z do
	for x = minp.x, maxp.x do
		
		--if not qts.worldgen.force_singlenode then
			--get the biome data
			biomeID = qts.worldgen.get_biome_name(heatmap[columnID],humiditymap[columnID],heightmap[columnID])
			biomeRef = qts.worldgen.registered_biomes[biomeID]
			biomeBuffer[columnID] = biomeID
			if not biomeRef then minetest.log("LINE 131: NULL AT CREATION, Name:"..dump(biomeID)) end
			--ground scanning setup
			local groundHeight = -31000
			local isground = false
			local airdepth = -1
			local isWaterAbove = false
		--end
		
		--now, for every node in column, top down
		
		for y = maxp.y, minp.y, -1 do
			--if not biomeRef then minetest.log("LINE 142: NULL AT COL START") end
			if not qts.worldgen.force_singlenode then
				--per-Node data
				local i = Area:index(x, y, z)
				local nID = nil
				
				--replace default ores
				if (Data[i] ~= CID["air"]) and 
						(Data[i] ~= CID["ground"]) and 
						(Data[i] ~= CID["water"]) and 
						(Data[i] ~= CID["river"]) then
					for name, c in pairs(ORE) do
						if Data[i] == c then 
							Data[i] = CID["ground"]
							nID = CID["ground"]
						end
					end
				end 
				
				--update ground scan
				if (not isGenGround(Data[i])) then
					--air or otherwise
					if isground then 
						isground = false
						airdepth = 0
					end
					if airdepth ~= -1 then
						airdepth = airdepth + 1
					end
					
					isWaterAbove = isGenWater(Data[i])
					
					--if not biomeRef then minetest.log("LINE 177: NULL AFTER GROUND AND WATER") end
				else
					--isWaterAbove = isGenWater(Data[i])
					
					--solid ground
					if not isground then
						isground = true
						if y == maxp.y then --the height of the ground is the top of the generated area. This is a problem
							--groundHeight = heightmap[columnID]
							local n = minetest.get_node_or_nil({x=x, y=y+1,z=z})
							if n and n.name and n.name == "air" then
								--local cidbelow = minetest.get_content_id(n.name)
								--if qts.worldgen.is_biome_node(cidbelow, biomeID,{"surface", "fill", "stone"}, true) 
								--		or cidbelow == CID["ground"] then
									groundHeight = y
								--end
							else
								--attempt trace up, since the data is not readily avalable
								local depth = nil
								local traceup_found = false
								for delta_y = 2, biomeRef.stone_depth+1 do
									if traceup_found == false then
										local off_y = y - delta_y
										local n = minetest.get_node_or_nil({x=x, y=off_y,z=z})
										
										if n and n.name and n.name == "air" then
											--local cidbelow = minetest.get_content_id(n.name)
											--if qts.worldgen.is_biome_node(cidbelow, biomeID,{"surface", "fill", "stone"}, true) 
											--		or cidbelow == CID["ground"] then
												depth = delta_y + 2
												traceup_found = true
											--end
										end
									end
								end
								if depth then
									groundHeight = y + depth --found an air node, use it for the ground height
								else
									groundHeight = -31000 --unable to find the data.
								end
							end
						else
							groundHeight = y --a ground height that is within the generated area
						end
					end
				end
				
				--if not biomeRef then minetest.log("LINE 222: NULL AFTER GROUND AND WATER FULL") end
				
				--gen below (how far below ground) and daylight data
				local below = groundHeight - y
				local daylight = -1
				if groundHeight ~= -31000 then
					daylight = LightData[Area:index(x, groundHeight+1, z)] % 16 --get the first 4 bits
				end
				
				--generate the biome solid materials
				if isground and below >= 0 and biomeRef 
						and (airdepth == -1 or airdepth >= biomeRef.min_air) 
						and (daylight >= biomeRef.min_light) then
					below = below + 1 --increase below to measure correctly
					if (isWaterAbove and biomeRef.underwater) then
						if below <= biomeRef.fill_depth then
							nID = qts.worldgen.get_biome_node(biomeID,"underwater")
						end
					else 
						if below <= biomeRef.surface_depth then
							nID = qts.worldgen.get_biome_node(biomeID,"surface")
						elseif below <= biomeRef.fill_depth then
							nID = qts.worldgen.get_biome_node(biomeID,"fill")
						elseif below <= biomeRef.stone_depth then
							nID = qts.worldgen.get_biome_node(biomeID,"stone")
						end
					end
				end
				
				--if not biomeRef then minetest.log("LINE 251: NULL AFTER NODE DATA SET") end
				--place the nodes
				if nID then
					Data[i] = nID
					--dbg_placed = true
				end
			else
				Data[Area:index(x, y, z)] = CID["air"]
				
			end
		end
		columnID = columnID + 1
	end
	end
	
	--if not biomeRef then minetest.log("LINE 266: NULL AFTER FULL CREATION LOOP") end
	
	
	--minetest.log("WORLDGEN 3")
	--set the data
	VM:set_data(Data)
	VM:set_light_data(LightData)
	VM:set_param2_data(Param2Data)
	
	if not qts.worldgen.force_singlenode then
		--STRUCTURES
		columnID = 1
		for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local biomeID = biomeBuffer[columnID]
			--gen trees, structures
			for y = maxp.y, minp.y, -1 do
				local i = Area:index(x, y, z)
				local j = Area:index(x, y-1, z)
				local nID = nil
				if Data[i] == CID["air"] and Data[j] ~= CID["air"] then
					local struc = false
					for name, def in pairs(qts.worldgen.registered_structures) do
						if not struc then
							if qts.worldgen.check_structure(name, biomeID, Data[j]) then
								--local sucess = qts.worldgen.place_structure(name,{x=x,y=y,z=z},VM)
								local strucDef = qts.worldgen.registered_structures[name]
								local rotation = "0"
								if strucDef.rotate then rotation = "random" end
								local sucess = minetest.place_schematic_on_vmanip(
									VM,
									vector.add({x=x,y=y,z=z}, strucDef.offset), 
									strucDef.schematic, 
									rotation, 
									nil, 
									strucDef.force_place, 
									strucDef.flags
								)
								--minetest.log("Structure Placed: "..dump(sucess).." : "..dump({x=x, y=y, z=z}))
								--structures[#structures + 1] = {pos = {x=x, y=y, z=z}, name = name}
								struc = true
								break
							end
							--minetest.log("Structure can be placed")
						end
					end
				end
				if nID then
					Data[i] = nID
				end
			end
			columnID = columnID + 1
		end
		end
		--if not biomeRef then minetest.log("LINE 319: NULL AFTER STRUCTURES") end
		
		--minetest.log("WORLDGEN 4")
		--get the new valid data
		Data= VM:get_data()
		LightData = VM:get_light_data()
		Param2Data = VM:get_param2_data()
		
		columnID = 1
		for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			biomeID = biomeBuffer[columnID]
			biomeRef = qts.worldgen.registered_biomes[biomeID]
			--place plants
			--if not biomeRef then minetest.log("LINE 331: NULL BEFORE PLANT COLUMN") end
			if biomeRef.plant and biomeRef.plant_freq and biomeRef.plant_freq~=0 then
				for y = maxp.y, minp.y, -1 do
					local i = Area:index(x, y, z)
					local nID = nil
					local param2 = nil
					if y < maxp.y then
						local j = Area:index(x, y-1, z)
						
						if Data[i] == CID["air"] and qts.worldgen.is_biome_node(Data[j], biomeID,{"surface"}, true) then
							--it can be a plant
							--minetest.log("plant")
							if math.random(1,biomeRef.plant_freq) == 1 then
								local name = qts.worldgen.get_biome_node(biomeID,"plant", false)
								nID = CID[name]
								local nameDef = minetest.registered_nodes[name]
								if nameDef and nameDef.paramtype2 then
									if nameDef.paramtype2 == "meshoptions" then
										param2 = genParam2Meshoptions()
									elseif nameDef.paramtype2 == "facedir" then
										param2 = genParam2Facedir()
									end
								end
								--minetest.log("Plant Randomly placed. Biome: " .. dump(biomeID))
							--else
								--minetest.log("Plant Randomly not placed.")
							end
						end
					end
					
					if nID then
						Data[i] = nID
					end
					if param2 then
						Param2Data[i] = param2
					end
				end
			--[[
			else
				if (biomeID ~= biomeRef.name) then
				--if biomeID ~= "underwater" and biomeID ~= "beach" then
					minetest.log("Plant Ignored. Biome: " .. dump(biomeID) .. 
						"  Plants: " .. dump(biomeRef.plant) .. 
						"  Freq: " .. dump(biomeRef.plant_freq))
					--if (biomeID ~= biomeRef.name) then
					minetest.log("\nbiomeID: " .. dump(biomeID)  .. "biomeNM: " .. dump(biomeRef.name))
					--end
				end--]]
			end
			--if not biomeRef then minetest.log("LINE 361: NULL BEFORE DUST COLUMN") end
			--retrace for dust
			if false and biomeRef and biomeRef.dust then
				local dust_placed = false
				for y = maxp.y, minp.y, -1 do
					if not dust_placed then
						local i = Area:index(x, y, z)
						local nID = nil
						if Data[i] == CID["air"]
								and not(Data[Area:index(x, y-1, z)] == CID["water"] 
									or Data[Area:index(x, y-1, z)] == CID["river"] )then
							--place dust
							nID = qts.worldgen.get_biome_node(biomeID,"dust")
							dust_placed = true
							break
						end
						if nID then
							Data[i] = nID
							--dbg_placed = true
						end
					end
				end
			end
			
			columnID = columnID + 1
		end
		end
		--minetest.log("WORLDGEN 5")
		--run ore and deco generation
		
		
		--set node data, and write to map
		VM:set_data(Data)
		VM:set_light_data(LightData)
		VM:set_param2_data(Param2Data)
		--generate the ores
		minetest.generate_ores(VM, minp, maxp)
		minetest.generate_decorations(VM, minp, maxp)
	
	end
	
	--VM:set_lighting{day=0, night=0}
	VM:calc_lighting()
	VM:write_to_map()
	
	
end)
--]]

