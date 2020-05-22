-- +z = backwards!
foundry.core_def = {
	bricks = {
		--first level
		{x= 0, y= 0, z= 1},
		{x= 1, y= 0, z= 1},
		{x=-1, y= 0, z= 1},
		{x= 0, y= 0, z= 2},
		--second level
		{x= 0, y= 1, z= 0},
		{x= 1, y= 1, z= 1},
		{x=-1, y= 1, z= 1},
		{x= 0, y= 1, z= 2},
	},
	crucible = { --TODO: FIX THIS SO THAT IT IS A DIRECTLY A VECTOR, NOT A LIST OF 1 ELEMENT!!!!!!!!!!!!!!!
		{x= 0, y= 1, z= 1},
	}
}
foundry.lvl2_def = {
	bricks = {
		--second level
		{x= 0, y= 2, z= 0},
		{x= 1, y= 2, z= 1},
		{x=-1, y= 2, z= 1},
		{x= 0, y= 2, z= 2},
	},
	crucible = {
		{x= 0, y= 2, z= 1},
	}
}
foundry.lvl3_def = {
	bricks = {
		--second level
		{x= 0, y= 3, z= 0},
		{x= 1, y= 3, z= 1},
		{x=-1, y= 3, z= 1},
		{x= 0, y= 3, z= 2},
	},
	crucible = {
		{x= 0, y= 3, z= 1},
	}
}

foundry.worldfoundries = {}

function foundry.rotate_vector_by_facedir(vec, dir)
	if dir == 1 then
		return {x = vec.z, y = vec.y, z = -vec.x}
	elseif dir == 2 then
		return {x = -vec.x, y = vec.y, z = -vec.z}
	elseif dir == 3 then
		return {x = -vec.z, y = vec.y, z = vec.x}
	else
		return vec
	end
end

function foundry.is_foundry(pos, ignore_crucible)
	if ignore_crucible == nil then ignore_crucible = false end
	local node = minetest.get_node_or_nil(pos)
	if (node and node.name 
			and minetest.get_item_group(node.name, "foundry_controller") > 0) then
		--A foundry controller is found
		--now, scan for stuff
		local found = true
		local level = 1
		local param2 = node.param2
		for i, offset in pairs(foundry.core_def.bricks) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			local check = minetest.get_node_or_nil(vector.add(offset_rot, pos))
			if not(check and check.name 
					and minetest.get_item_group(check.name, "bricks") > 0) then
				found = false
				break
			end
		end
		
		if not ignore_crucible then
			for i, offset in pairs(foundry.core_def.crucible) do
				local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
				local check = minetest.get_node_or_nil(vector.add(offset_rot, pos))
				if not(check and check.name 
						and minetest.get_item_group(check.name, "foundry_crucible") > 0) then
					--minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:marker"})
					found = false
					break
				end
			end
		end
		
		if found then
			--check for level 2
			level = 2
			for i, offset in pairs(foundry.lvl2_def.bricks) do
				local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
				local check = minetest.get_node_or_nil(vector.add(offset_rot, pos))
				if not(check and check.name 
						and minetest.get_item_group(check.name, "bricks") > 0) then
					level = 1
					break
				end
			end
			
			if not ignore_crucible then
				for i, offset in pairs(foundry.lvl2_def.crucible) do
					local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
					local check = minetest.get_node_or_nil(vector.add(offset_rot, pos))
					if not(check and check.name 
							and minetest.get_item_group(check.name, "foundry_crucible") > 0) then
						--minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:marker"})
						level = 1
						break
					end
				end
			end
			
			if level == 2 then
				--check for level 3
				level = 3
				for i, offset in pairs(foundry.lvl3_def.bricks) do
					local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
					local check = minetest.get_node_or_nil(vector.add(offset_rot, pos))
					if not(check and check.name 
							and minetest.get_item_group(check.name, "bricks") > 0) then
						level = 2
						break
					end
				end
				
				if not ignore_crucible then
					for i, offset in pairs(foundry.lvl3_def.crucible) do
						local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
						local check = minetest.get_node_or_nil(vector.add(offset_rot, pos))
						if not(check and check.name 
								and minetest.get_item_group(check.name, "foundry_crucible") > 0) then
							--minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:marker"})
							level = 2
							break
						end
					end
				end
			end
			
			return level
		else
			return false
		end
	else
		return false
	end
end

function foundry.make_foundry(pos, level)
	--if level is directly passed from is_foundry, this makes it safe
	if not level then
		minetest.log("ERR: Nil level")
		return 
	end
	local node = minetest.get_node_or_nil(pos)
	if not node then 
		minetest.log("ERR: Nil Node")
		return 
	end
	local param2 = node.param2
	
	if level > 2 then
		--level 3 construction
		for i, offset in pairs(foundry.lvl3_def.bricks) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:scorched_brick"})
		end
		for i, offset in pairs(foundry.lvl3_def.crucible) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:crucible_empty"})
		end
	end
	
	if level > 1 then
		--level 2 construction
		for i, offset in pairs(foundry.lvl2_def.bricks) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:scorched_brick"})
		end
		for i, offset in pairs(foundry.lvl2_def.crucible) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:crucible_empty"})
		end
	end
	
	--base construction
	for i, offset in pairs(foundry.core_def.bricks) do
		local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
		minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:scorched_brick"})
	end
	for i, offset in pairs(foundry.core_def.crucible) do
		local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
		minetest.set_node(vector.add(offset_rot, pos), {name = "foundry:crucible_empty"})
	end
	
end

function foundry.log_foundry(pos, level)
	--if level is directly passed from is_foundry, this makes it safe
	if not level then
		minetest.log("ERR: Nil level")
		return 
	end
	local node = minetest.get_node_or_nil(pos)
	if not node then 
		minetest.log("ERR: Nil Node")
		return 
	end
	local param2 = node.param2
	local foundryID = minetest.hash_node_position(pos)
	
	if foundry.worldfoundries[foundryID] then
		--we need to overrdie its data
		foundry.worldfoundries[foundryID] = nil
	end
	
	local tmp = {}
	
	--base construction
	for i, offset in pairs(foundry.core_def.bricks) do
		local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
		tmp[minetest.hash_node_position(vector.add(offset_rot, pos))] = true
	end
	for i, offset in pairs(foundry.core_def.crucible) do
		local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
		tmp[minetest.hash_node_position(vector.add(offset_rot, pos))] = true
	end
	
	if level > 1 then
		--level 2 construction
		for i, offset in pairs(foundry.lvl2_def.bricks) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			tmp[minetest.hash_node_position(vector.add(offset_rot, pos))] = true
		end
		for i, offset in pairs(foundry.lvl2_def.crucible) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			tmp[minetest.hash_node_position(vector.add(offset_rot, pos))] = true
		end
	end
	
	if level > 2 then
		--level 3 construction
		for i, offset in pairs(foundry.lvl3_def.bricks) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			tmp[minetest.hash_node_position(vector.add(offset_rot, pos))] = true
		end
		for i, offset in pairs(foundry.lvl3_def.crucible) do
			local offset_rot = foundry.rotate_vector_by_facedir(offset, param2)
			tmp[minetest.hash_node_position(vector.add(offset_rot, pos))] = true
		end
	end
	
	foundry.worldfoundries[foundryID] = tmp
end

--this function will return the foundry core pos 
--if the provided pos is in a foundry, nil otherwise
function foundry.get_pos_foundry(pos)
	local h = minetest.hash_node_position(pos)
	if foundry.worldfoundries[h] then
		return pos
	end
	for fID, list in pairs(foundry.worldfoundries) do
		if list[h] then
			return minetest.get_position_from_hash(fID)
		end
	end
	return nil
end


--init a new foundry. Auto-checks if the foundry is already initialized
--MAKE SURE TO CALL AFTER make_foundry()
function foundry.InitFoundry(pos)
	--minetest.log("here")
	local lvl = foundry.is_foundry(pos, false)
	if not lvl then return end
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	do
		local dstr = meta:get_string("foundry_data")
		if dstr ~= "" then 
			--minetest.log("Data loaded: "..dstr)
			return 
		end --already initialized
	end
	--
	local invsize = 4*6 --done like this so I can change it easy
	--create inventory
	--local inv = meta:get_inventory()
	--inv:set_size("main", invsize)
	--minetest.log("inv of node "..minetest.pos_to_string(pos).." should be made")
	
	--create raw foundry data
	local data = {
		heat = 0,
		metalID	 = "",
		metalLVL = 0,
		smeltPercent = {},
		pos = {x = pos.x, y = pos.y, z = pos.z},
		foundryID = minetest.hash_node_position(pos),
		foundryLVL = lvl,
	}
	--create smelt percent
	for i = 1,(invsize) do
		data.smeltPercent[i] = 0
	end
	FoundryData(data)
	foundry.ApplyFoundryData(data)
	
end


--[[
FoundryData

FoundryData is a datatype used by the foundry system to store foundry info 
and apply functions to it.
Its data is stored in the controller's metadata
It contains information like the percentage cooked that each item in its inventory is
its current heat, its current metal and the ammount of that metal
etc.

variable keys:
	heat			* --a 0 to 1 value
	metalID			* --a string, the metal name
	metalLVL		* --a number, 0 - 16 per level (max 16*3 = )
	smeltPercent	* --a table, of number 0 - 100
	pos
	foundryID
	foundryLVL
	
methods:
	tick_smelt_percent(dtime)			--updates all the smelt percentages in the inventory
	add_heat(ammount) 					--adds heat, up to 100
	add_metal(metalID, ammount)			--adds metal, if it can, but does not add if it would exceed max metal, or is the wrong type
	space_for_metal(metalID, ammount)	--checks to see if an ammount of metal of id can fit
	has_metal(ammount)					--checks to see if the metal in it is greater than ammount
	take_metal(ammount)					--removes ammount of metal, if it can. does not, if it would be below 0
	is_empty()							--returns true if there is no metal
	get_max_metal()						--returns the max metal the foundry can hold (lvl * 16)
	update_crucible()					--return t/f Updates the crucible nodes
--]]

--a modify-in-place function that takes a data-only table and adds the functions
function FoundryData(tbl)
	---[[
	local function clamp(v, min, max)
		if v < min then return min end
		if v > max then return max end
		return v
	end
	
	function tbl.tick_smelt_percent(self, dtime)
		--ticks the smelt percent, based off of the items in the inv
		local meta = minetest.get_meta(self.pos)
		local inv = meta:get_inventory()
		local items = inv:get_list("main")
		for i, stack in pairs(items) do
			local ppercent = self.smeltPercent[i]/100 -- 0->1 value
			local recepie = foundry.registered_smeltables[stack:get_name()]
			if recepie then
				--minetest.log("item found: " .. stack:get_name())
				local t = ppercent * recepie.smelt_time
				t = t + dtime
				local npercent = t / recepie.smelt_time
				if npercent >= 1 then
					--minetest.log("item ".. stack:get_name() .. " should be finished melting")
					--apply the stuff
					local ok = true
					if recepie.type == "melt" then
						if self.heat > math.abs(recepie.heat) then
							if self:add_metal(recepie.metal, recepie.metal_ammount) then --does not add if cant work	
								self:add_heat(recepie.heat)
							else
								ok = false
							end
						else
							ok = false
						end
					else
						if self.heat < 100 then
							self:add_heat(recepie.heat)
						else
							ok = false
						end
					end

					if ok then
						--remove the item and reset the percent
						self.smeltPercent[i] = 0
						inv:set_stack("main",i, "")
					end
				else
					--set the new percentage
					--minetest.log("item ".. stack:get_name() .. " should have some percentage added")
					--minetest.log("--"..tostring(npercent))
					self.smeltPercent[i] = math.floor(npercent * 100)
				end
				
			else
				self.smeltPercent[i] = 0
			end
		end
		
	end
	--]]
	function tbl.add_heat(self, ammount)
		--add heat
		self.heat = clamp(self.heat + ammount, 0, 100)
	end
	
	function tbl.add_metal(self, metal, ammount)
		--returns true/false
		if self:is_empty() then
			self.metalID = metal
		end
		if self.metalID == metal then
			local nm = self.metalLVL + ammount
			if nm < 0 or nm > self.foundryLVL*16 then
				return false
			end
			self.metalLVL = nm
			return true
		else
			return false
		end
	end
	
	function tbl.space_for_metal(self, metal, ammount)
		--returns true/false
		if self.metalID == metal or self:is_empty() then
			local nm = self.metalLVL + ammount
			if nm < 0 or nm > self.foundryLVL*16 then
				return false
			else
				return true
			end
		else
			return false
		end
	end
	
	function tbl.has_metal(self, ammount)
		--returns type or nil
		if self.metalLVL >= ammount then
			return self.metalID
		else
			return nil
		end
	end
	
	function tbl.take_metal(self, ammount)
		--returns true/false
		if self.metalLVL >= ammount then
			self.metalLVL = self.metalLVL - ammount
			return true
		else
			return false
		end
	end
	
	function tbl.is_empty(self)
		return self.metalLVL <= 0
	end
	
	function tbl.get_max_metal(self)
		return self.foundryLVL * 16
	end
	
	function tbl.update_crucible(self)
		--returns true/false
		local metalref = foundry.registered_metals[self.metalID]
		if not metalref then return false end
		
		
		local cpos = {}
		cpos[1] = foundry.core_def.crucible[1] --TODO: crucible rework loc
		if self.foundryLVL > 1 then
			cpos[2] = foundry.lvl2_def.crucible[1]
		end
		if self.foundryLVL > 2 then
			cpos[3] = foundry.lvl3_def.crucible[1]
		end
		
		local node = minetest.get_node_or_nil(self.pos)
		if not node then return false end
		local param2 = node.param2
		
		for i, p in ipairs(cpos) do
			local ml = self.metalLVL - ((i-1)*16)
			if ml < 0 then ml = 0 end
			ml = clamp(ml * 4, 0, 63) --convert to param2 space
			local pos = vector.add(self.pos, foundry.rotate_vector_by_facedir(p, param2))
			
			local cruc = minetest.get_node_or_nil(pos)
			if cruc then
				cruc.name = metalref.crucible_name
				cruc.param2 = ml
				minetest.set_node(pos, cruc)
			end
		end
		return true
	end
	
	function tbl.apply(self)
		foundry.ApplyFoundryData(self)
	end
end

function foundry.GetFoundryData(pos)
	local node = minetest.get_node_or_nil(pos)
	if not node then return end
	
	local lvl = foundry.is_foundry(pos, false)
	if lvl == false then return end
	
	local meta = minetest.get_meta(pos)
	local datastr = meta:get_string("foundry_data")
	if not datastr then return end
	local origintbl = minetest.deserialize(datastr)
	if not origintbl then 
		 if foundry.worldfoundries[minetest.hash_node_position(pos)] then
			--the foundry data must be made
			foundry.InitFoundry(pos)
			minetest.log("WARNING: Foundry data was nil. created some, attempting to get")
			return foundry.GetFoundryData(pos) --recursive call
		 else
			minetest.log("Not even a world foundry. strange")
			return
		 end
	end
	--ok. data has been collected from the node meta
	local rtbl = {}
	--copy specific data points into rtbl
	for i, key in pairs{"heat", "metalID", "metalLVL", "smeltPercent"} do
		rtbl[key] = origintbl[key]
	end
	--add the other data
	rtbl.pos = {x=pos.x, y=pos.y, z=pos.z}
	rtbl.foundryID = minetest.hash_node_position(pos) --run once
	rtbl.foundryLVL = lvl --1, 2, or 3
	FoundryData(rtbl) --add the functions
	return rtbl
end

function foundry.ApplyFoundryData(data)
	local node = minetest.get_node_or_nil(data.pos)
	if not node then return end
	
	--create a seperate table for serilization and storage
	local strtbl = {}
	for i, key in pairs{"heat", "metalID", "metalLVL", "smeltPercent"} do
		strtbl[key] = data[key]
	end
	local datastr = minetest.serialize(strtbl)
	
	local it = "Heat: " .. tostring(data.heat) .. 
			"%\nMetal: "..tostring(data.metalLVL/data:get_max_metal()*100)..
			"% (" .. tostring(data.metalLVL) .. 
			"/"..tostring(data:get_max_metal()) .. ")"
	
	local meta = minetest.get_meta(data.pos)
	meta:set_string("foundry_data", datastr)
	meta:set_string("infotext", it)
end


--[[
#############################################################################################
REGISTRATIONS
--]]

foundry.registered_metals = {}
foundry.registered_smeltables = {}

--[[
register_metal
def
	description = "regular description"
	texture = "filename of a 16x64 texture, vertical_frames"
	ingot = "item:name"
	block = "item:name"
--]]
foundry.register_metal = function(name, def)
	def.name = name
	
	--create a crucible for it
	minetest.register_node("foundry:crucible_"..name, {
		description = "Crucible of "..def.description,
		drawtype = "glasslike_framed",
		tiles = {"foundry_crucible_top.png"},
		special_tiles = {{
			name = def.texture,
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 1.5,
				},
		}},
		paramtype = "light",
		paramtype2 = "glasslikeliquidlevel",
		groups = {cracky=3, bricks=1, foundry_crucible = 1, not_in_creative_inventory = 1},
		is_ground_content = false,
		sounds = qtcore.node_sound_stone(),
	})
	def.crucible_name = "foundry:crucible_"..name
	
	foundry.registered_metals[name] = def
	
	--register melting for the ingot and block
	foundry.register_smeltable({
		itemname = def.ingot,
		smelt_time = 2,
		type = "melt",
		heat = 1,
		metal = def.name,
		metal_ammount = 1,
	})
	
	foundry.register_smeltable({
		itemname = def.block,
		smelt_time = 8,
		type = "melt",
		heat = 8,
		metal = def.name,
		metal_ammount = 16,
	})
	
end

--[[
	itemname = "an item name (NOT A GROUP)"
	smelt_time = 1 --a number (in seconds)
	type = "fuel" or "melt"
	heat = 1 number - change in heat. how it is treated is from the type
	metal = "name of registered metal"
	metal_ammount = 1 --the ammount of metal to add. NO EFFECT FOR FUEL
--]]
foundry.register_smeltable = function(def)
	if not def.itemname then error("Foundry: Cannot declare a smeltable without an item to smelt") end
	if foundry.registered_smeltables[def.itemname] then
		minetest.log("warning", "Foundry: Overriding a existing smeltable may cause unpredicted behavior")
	end
	if not def.smelt_time then 
		def.smelt_time = 1
		minetest.log("warning", "Foundry: Declare a smelt_time in register_smeltable")
	end
	if not def.type then error("Foundry: Cannot declare a smeltable without a smelting type") end
	local t = {fuel = true, melt = true}
	if not t[def.type] then error("Foundry: register_smeltable smelt type must be \"fuel\" or \"melt\"") end
	if not def.heat then def.heat = 1 end
	if def.type == "melt" then
		def.heat = -def.heat --invert, cause it removes heat!
		if not def.metal then error("Foundry: metal type smeltables must give a metal name") end
		if not def.metal_ammount then 
			def.metal_ammount = 1
			minetest.log("warning", "Foundry: Declare a metal_ammount in register_smeltable if the type = melt")
		end
	end
	foundry.registered_smeltables[def.itemname] = def
end

