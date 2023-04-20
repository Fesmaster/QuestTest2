--[[
	shaped Nodes API

	This handles the Node Registration, as well as Hammers and their functionality.

	New node callback:

	on_hammer = function(pointed_thing, user, mode, newnode)
		return [true|false|nil]
	end
	if return is nul or true then the hammering does not apply normal stuff
--]]

--[[
	Rotate and place a stair, slant, or slab

	Params:
		itemstack - the itemstack to place
		placer - the placing player ObjRef
		pointed_thing - the pointed_thing of the player placing
		dont_place - boolean, if true, then it returns the param2 instead of placing

	Returns:
		if dont_place is false or nil, returns the return value of minetest.item_place
		otherwise, returns the param2 of the node.
]]
---Rotate and Place a facedir / coloredfacedir node
---@param itemstack ItemStack|nil can be nil if dont_place is true
---@param placer ObjectRef
---@param pointed_thing Pointed_Thing
---@param dont_place boolean just return the param2 value, don't actually place. default is false.
---@return ItemStack|number
function qts.rotate_and_place(itemstack, placer, pointed_thing, dont_place)
	local param2 = 0
	
	if placer and pointed_thing and pointed_thing.under then
		local finepos = vector.subtract(minetest.pointed_thing_to_face_pos(placer, pointed_thing), pointed_thing.under)

		if (pointed_thing.under.y == pointed_thing.above.y) then
			param2 = minetest.dir_to_facedir(vector.subtract(pointed_thing.above, placer:get_pos()))
		else
			--if on top or on bottom, then use the edge hit for the direction
			if math.abs(finepos.x) > math.abs(finepos.z) then
				if finepos.x < 0 then
					param2 = 1
				else
					param2 = 3
				end
			else
				if finepos.z < 0 then
					param2 = 0
				else
					param2 = 2
				end
			end
		end
		
		--handle vertical flip
		if (pointed_thing.under.y - 1 == pointed_thing.above.y) or (finepos.y < 0)
		then
			--flip the node upside down.
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	if not dont_place then
		return minetest.item_place(itemstack, placer, pointed_thing, param2)
	else
		return param2
	end
end

---Check if a wallmounted pos and rotation is valid
---@param rotation number
---@param pos Vector
local function check_wallmounted_dir(rotation, pos)
	local off = minetest.wallmounted_to_dir(rotation)
	local node = minetest.get_node_or_nil(pos+off)
	if node == nil then return false end
	local def = minetest.registered_nodes[node.name]
	return def and def.walkable
end

---rotate a node around its axis or change its axis. It preserves any node color.
---@param pos Vector
---@param node NodeRef
---@param change_axis boolean
---@param don_set boolean
---@return any|number
function qts.rotate_node(pos, node, change_axis, don_set)
	local nodedef = minetest.registered_nodes[node.name]
	if not nodedef then return 0 end

	local param2 = node.param2
	--calculate the new param2
	if nodedef.paramtype2 == "facedir" or nodedef.paramtype2 == "colorfacedir" then
		--facedir rotation
		local rotation = param2%0x04 	  --bits 0, 1
		local axis = math.floor(param2/0x04)%0x08 --bits 2,3,4
		local color = 	(math.floor(param2/0x20)%0x08)*0x20 --bits 5,6,7
		if change_axis then
			axis = (axis + 1) % 0x8
		else
			rotation = (rotation + 1) % 0x4
		end
		param2 = rotation + (axis * 0x4) + color
	elseif nodedef.paramtype2 == "wallmounted" or nodedef.paramtype2 == "colorwallmounted" then
		--wallmounted
		--a bit tricky, because there are invalid wallmounted values.
		local dircode = param2%0x8 -- bits 0,1,2,3
		local color = param2-dircode -- bits 3,4,5,6,7
		for i = 1,5 do
			local newdir = (dircode + i)%6 --there are six facing directions
			if check_wallmounted_dir(newdir, pos) then
				dircode = newdir
				break
			end
		end
		param2 = dircode + color
	elseif nodedef.paramtype2 == "4dir" or nodedef.paramtype2 == "color4dir" then
		--4dir
		local rotation = param2%0x04 	  --bits 0,1
		local color = param2-rotation --bits 2,3,4,5,6,7
		rotation = (rotation + 1) % 0x04
		param2 = rotation + color
	end

	--perform final operation: set or return
	if (don_set) then
		return param2
	else
		minetest.swap_node(pos, {name=node.name, param1=node.param1, param2=param2})
	end
end


--[[
	Enum for hammer function modes
		
		CHANGE_TYPE - change the type of node (solid->stair->slant->slab->solid)
		CHANGE_STYLE - change the style of the stair or slant (flat->inner->outer->flat)
]]
---@enum HammerFunction
qts.HAMMER_FUNCTION = {
	CHANGE_TYPE = 1,
	CHANGE_STYLE = 2,
	ROTATE_FACE = 3,
	ROTATE_AXIS = 4,
}

--[[
	Apply a hammer to a node

	Params:
		pointed_thing - the hitter's pointed_thing
		user - the PlayerRef
		mode a qts.HAMMER_FUNCTION for how it should operate

	Will call the on_hammer callback in a node
	on_hammer(pointed_thing, user, mode, newnode) ->boolean 
		if return is nul or true then the hammering does not apply normal stuff
]]
---Apply a hammer to a node
---@param pointed_thing Pointed_Thing
---@param user ObjectRef
---@param mode HammerFunction
function qts.hammer_apply(pointed_thing, user, mode)
	if not mode then mode = qts.HAMMER_FUNCTION.CHANGE_TYPE end
	local player_name = user:get_player_name() or ""
	local pos = pointed_thing.under
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return
	end

	--get node and definition
	local node = minetest.get_node_or_nil(pos)
	if node == nil then return end
	local nodedef= minetest.registered_nodes[node.name]
	if nodedef == nil then return end

	--preliminary of post-hammered form
	local newnode = {name=node.name, param1 = node.param1, param2 = node.param2}
	
	--perform various functions of the hammer
	if minetest.get_item_group(node.name, "shaped_node") >= 1 and (mode == qts.HAMMER_FUNCTION.CHANGE_STYLE or mode == qts.HAMMER_FUNCTION.CHANGE_TYPE) then
		--perform shape changes to shaped nodes
		if node.name:find("_stair") then
			if mode == qts.HAMMER_FUNCTION.CHANGE_STYLE then
				--change corner mode
				if node.name:find("_inner") then
					newnode.name = node.name:gsub("_inner", "_outer")
				elseif node.name:find("_outer") then
					newnode.name = node.name:gsub("_outer", "")
				else
					newnode.name = node.name.."_inner"
				end
			else
				--stair-->slab
				newnode.name = node.name:gsub("_stair", "_slant")
			end
		elseif node.name:find("_slant") then
			if mode == qts.HAMMER_FUNCTION.CHANGE_STYLE then
				--change corner mode
				if node.name:find("_inner") then
					newnode.name = node.name:gsub("_inner", "_outer")
				elseif node.name:find("_outer") then
					newnode.name = node.name:gsub("_outer", "")
				else
					newnode.name = node.name.."_inner"
				end
			else
				--stair-->slab
				newnode.name = node.name:gsub("_slant", "_slab"):gsub("_inner", ""):gsub("_outer", "")
			end
		elseif node.name:find("_slab") then
			--slab --> whole
			if mode == qts.HAMMER_FUNCTION.CHANGE_TYPE then
				newnode.name = node.name:gsub("_slab", "")
			end
		else
			--whole --> stair
			if mode == qts.HAMMER_FUNCTION.CHANGE_TYPE then
				newnode.name = node.name.."_stair"
			end
		end

		--get the param2
		local color = newnode.param2 - newnode.param2%0x20 --everything but the first five bits - to preserve color!
		local param2 = qts.rotate_and_place(nil, user, pointed_thing, true) --get the number instead of placing
		newnode.param2 = param2+color --last bit of param2 data added back in
	elseif mode == qts.HAMMER_FUNCTION.ROTATE_AXIS or mode == qts.HAMMER_FUNCTION.ROTATE_FACE then
		--handle rotations 
		--color preservation is handled by rotate_node
		newnode.param2 = qts.rotate_node(pointed_thing.under, newnode, mode == qts.HAMMER_FUNCTION.ROTATE_AXIS, true) --get the number instead of placing
	end

	if nodedef.on_hammer then
		local rval = nodedef.on_hammer(pointed_thing, user, mode, newnode)
		if rval == nil or rval == true then
			return
		end
	end
	minetest.swap_node(pointed_thing.under, newnode)
end

--[[
	Register a new hammer

	Params:
		name - the tool name
		def - the Tool Definition Table

	Tool Definition Table Additions:
		max_uses = 1000 - the maximum number of uses.

	Tool Definition Table Not Allowed:
		on_use(...)
		on_place(...)

	Default Groups:
		hammer = 1

})
--]]
qts.register_hammer = function(name, def)
	if not def.groups then def.groups = {} end
	def.groups.hammer = 1
	def.max_uses = def.max_uses or 1000

	def.on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local node = minetest.get_node(pointed_thing.under)
			local nlvl = minetest.get_item_group(node.name, "level")
			local hlvl = minetest.get_item_group(itemstack:get_name(), "level")
			if nlvl <= hlvl then
				if user:get_player_control().sneak then
					qts.hammer_apply(pointed_thing, user, qts.HAMMER_FUNCTION.ROTATE_FACE)
				else
					qts.hammer_apply(pointed_thing, user, qts.HAMMER_FUNCTION.CHANGE_TYPE)
				end
				--apply wear
				if not (qts.is_player_creative(user)) then
					local mult = (hlvl-nlvl)^3
					if mult == 0 then mult = 1 end
					local wear = qts.WEAR_MAX / (minetest.registered_tools[itemstack:get_name()].max_uses * mult)
					if not itemstack:set_wear(itemstack:get_wear() + wear) then
						itemstack:take_item()
					end
				end
			end
		end
		return itemstack
	end

	def.on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local node = minetest.get_node(pointed_thing.under)
			local nlvl = minetest.get_item_group(node.name, "level")
			local hlvl = minetest.get_item_group(itemstack:get_name(), "level")
			if nlvl <= hlvl then
				if user:get_player_control().sneak then
					qts.hammer_apply(pointed_thing, user, qts.HAMMER_FUNCTION.ROTATE_AXIS)
				else
					qts.hammer_apply(pointed_thing, user, qts.HAMMER_FUNCTION.CHANGE_STYLE)
				end
				--apply wear
				if not (qts.is_player_creative(user)) then
					local mult = (hlvl-nlvl)^3
					if mult == 0 then mult = 1 end
					local wear = qts.WEAR_MAX / (minetest.registered_tools[itemstack:get_name()].max_uses * mult)
					if not itemstack:set_wear(itemstack:get_wear() + wear) then
						itemstack:take_item()
					end
				end
			end
		end
		return itemstack
	end

	minetest.register_tool(":"..name, def)
end

--[[
	Given a node name, returns the permutation name
	of it if it can find it
	does not check if the node is actually shaped or not.

	Params:
		name - the node name

	Returns: a string, one of:
		"full"
		"stair"
		"stair_inner"
		"stair_outer"
		"slant"
		"slant_inner"
		"slant_outer"
		"slab"

]]
function qts.shaped_node_permutation(name)
	if name:find("_stair") then
		if name:find("_inner") then
			return "stair_inner"
		elseif name:find ("_outer") then
			return "stair_outer"
		else
			return "stair"
		end
	elseif name:find("_slant") then
		if name:find("_inner") then
			return "slant_inner"
		elseif name:find ("_outer") then
			return "slant_outer"
		else
			return "slant"
		end
	elseif name:find("_slab") then
		return "slab"
	else
		return "full"
	end
end

local function purge_shape_perm_from_name(name)
	name:gsub("_inner", "")
	name:gsub("_outer", "")
	name:gsub("_stair", "")
	name:gsub("_slant", "")
	name:gsub("_slab", "")
	return name
end

--[[
	Get the name of a permutation of a shaped node

	Params:
		name - the name of the full block (or any shaped form)
		permutation - a string, one of:
			"full"
			"stair"
			"stair_inner"
			"stair_outer"
			"slant"
			"slant_inner"
			"slant_outer"
			"slab"
	
	Returns:
		The name of that permutation
		Does not check if that permutation is actually registered.
]]
function qts.shaped_node_name(name, permutation)
	name = purge_shape_perm_from_name(name)
	if permutation == "full" then
		return name	
	elseif permutation == "stair" then
		return name .. "_stair"
	elseif permutation == "stair_inner" then
		return name .. "_stair_inner"
	elseif permutation == "stair_outer" then
		return name .. "_stair_outer"
	elseif permutation == "slant" then
		return name .. "_slant"
	elseif permutation == "slant_inner" then
		return name .. "_slant_inner"
	elseif permutation == "slant_outer" then
		return name .. "_slant_outer"
	elseif permutation == "slab" then
		return name .. "_slab"
	else
		minetest.log("Incorrect permutation passed to qts.shaped_node_name: " .. permutation)
		return name
	end
end



--[[
	Register a new shaped node
	These, by default, can be changed form by hammers
	This registers 8 nodes:
		full block          - <name>
		stair straight      - <name>_stair
		stair inner corner  - <name>_stair_inner
		stair outer corner  - <name>_stair_outer
		slant straight      - <name>_slant
		slant inner corner  - <name>_slant_inner
		slant outer corner  - <name>_slant_outer
		slab                - <name>_slab

	Params:
		name - the node name
		def - the node definition table

	No additions to Node Definition Table, 

	Not Recommended for Definition Table:
		drawtype should be "normal" unles you know what you are doing
		selection_box - not overriden for full block, but is for all others.
		collision_box - not overriden for full block, but is for all others.

	Default Groups:
		shaped_node=1
	For solid:
		shaped_full=1
	For stairs (straight, inner, outer)
		shaped_stair=1
	For slants (straight, inner, outer)
		shaped_slant=1
	For slabs (slab)
		shaped_slab=1
	
]]
function qts.register_shaped_node(name, def)
	--prep the data for node registration
	if (def.drop == nil) then
		def.drop = name
		--minetest.log("Node "..name .." did not have any drops")
	end
	def.groups = qts.table_deep_copy(def.groups) --copy the group table to prevent external modification
	--groups setup
	def.groups.shaped_node = 1
	--SOLID-----------------------
	def.groups.shaped_full = 1
	minetest.register_node(":"..name, qts.table_deep_copy(def))

	--NON_SOLID-------------------
	local imgs = {}
	for i, image in ipairs(def.tiles) do
		if type(image) == "string" then
			imgs[i] = {
				name = image,
				backface_culling = true,
				align_style = "world"
			}
		else
			imgs[i] = table.copy(image)
			if imgs[i].backface_culling == nil then
				imgs[i].backface_culling = true
			end
			if imgs[i].align_style == nil then
				imgs[i].align_style = "world"
			end
		end
	end
	def.tiles = imgs --overwrite old tiles
	if def.drop == nil then def.drop = name end --setup drops

	--STAIR-----------------------
	--change def to get various drawtypes etc
	def.groups.not_in_creative_inventory = 1
	def.groups.shaped_full = nil
	def.groups.shaped_stair = 1
	def.drawtype = "nodebox"
	def.paramtype = "light"
	if (def.palette) then
		def.paramtype2 = "colorfacedir"
	else
		def.paramtype2 = "facedir"
	end
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
		},
	}
	def.on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		return qts.rotate_and_place(itemstack, placer, pointed_thing)
	end
	minetest.register_node(":" .. name .."_stair", qts.table_deep_copy(def))
	--STAIR INNER-----------------------
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			{-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
		},
	}
	minetest.register_node(":" .. name.."_stair_inner", qts.table_deep_copy(def))
	--STAIR OUTER-----------------------
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
			{-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
		},
	}
	minetest.register_node(":" .. name.."_stair_outer", qts.table_deep_copy(def))
	--SLANT-----------------------
	def.groups.shaped_stair = nil
	def.groups.shaped_slant = 1
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4375, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.375, 0.375, 0.5, 0.4375, 0.5}, -- NodeBox2
			{-0.5, 0.3125, 0.3125, 0.5, 0.375, 0.5}, -- NodeBox3
			{-0.5, 0.25, 0.25, 0.5, 0.3125, 0.5}, -- NodeBox4
			{-0.5, 0.1875, 0.1875, 0.5, 0.25, 0.5}, -- NodeBox5
			{-0.5, 0.125, 0.125, 0.5, 0.1875, 0.5}, -- NodeBox6
			{-0.5, 0.0625, 0.0625, 0.5, 0.125, 0.5}, -- NodeBox7
			{-0.5, 0, 0, 0.5, 0.0625, 0.5}, -- NodeBox8
			{-0.5, -0.0625, -0.0625, 0.5, 0, 0.5}, -- NodeBox9
			{-0.5, -0.125, -0.125, 0.5, -0.0625, 0.5}, -- NodeBox10
			{-0.5, -0.1875, -0.1875, 0.5, -0.125, 0.5}, -- NodeBox11
			{-0.5, -0.25, -0.25, 0.5, -0.1875, 0.5}, -- NodeBox12
			{-0.5, -0.3125, -0.3125, 0.5, -0.25, 0.5}, -- NodeBox13
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, -- NodeBox14
			{-0.5, -0.4375, -0.4375, 0.5, -0.375, 0.5}, -- NodeBox15
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox16
		},
	}
	minetest.register_node(":" .. name.."_slant", qts.table_deep_copy(def))
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4375, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.375, 0.375, 0.5, 0.4375, 0.5}, -- NodeBox3
			{-0.5, 0.3125, 0.3125, 0.5, 0.375, 0.5}, -- NodeBox4
			{-0.5, 0.25, 0.25, 0.5, 0.3125, 0.5}, -- NodeBox5
			{-0.5, 0.1875, 0.1875, 0.5, 0.25, 0.5}, -- NodeBox6
			{-0.5, 0.125, 0.125, 0.5, 0.1875, 0.5}, -- NodeBox7
			{-0.5, 0.0625, 0.0625, 0.5, 0.125, 0.5}, -- NodeBox8
			{-0.5, 0, 0, 0.5, 0.0625, 0.5}, -- NodeBox9
			{-0.5, -0.0625, -0.0625, 0.5, 0, 0.5}, -- NodeBox10
			{-0.5, -0.125, -0.125, 0.5, -0.0625, 0.5}, -- NodeBox11
			{-0.5, -0.1875, -0.1875, 0.5, -0.125, 0.5}, -- NodeBox12
			{-0.5, -0.25, -0.25, 0.5, -0.1875, 0.5}, -- NodeBox13
			{-0.5, -0.3125, -0.3125, 0.5, -0.25, 0.5}, -- NodeBox14
			{-0.5, -0.375, -0.375, 0.5, -0.3125, 0.5}, -- NodeBox15
			{-0.5, -0.4375, -0.4375, 0.5, -0.375, 0.5}, -- NodeBox16
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox17
			{0.4375, 0.4375, -0.5, 0.5, 0.5, 0.4375}, -- NodeBox18
			{0.375, 0.375, -0.5, 0.5, 0.4375, 0.375}, -- NodeBox19
			{0.3125, 0.3125, -0.5, 0.5, 0.375, 0.3125}, -- NodeBox20
			{0.25, 0.25, -0.5, 0.5, 0.3125, 0.25}, -- NodeBox21
			{0.1875, 0.1875, -0.5, 0.5, 0.25, 0.1875}, -- NodeBox22
			{0.125, 0.125, -0.5, 0.5, 0.1875, 0.125}, -- NodeBox23
			{0.0625, 0.0625, -0.5, 0.5, 0.125, 0.0625}, -- NodeBox24
			{0, 0, -0.5, 0.5, 0.0625, 0}, -- NodeBox25
			{-0.0625, -0.0625, -0.5, 0.5, 0, -0.0625}, -- NodeBox26
			{-0.125, -0.125, -0.5, 0.5, -0.0625, -0.125}, -- NodeBox27
			{-0.1875, -0.1875, -0.5, 0.5, -0.125, -0.1875}, -- NodeBox28
			{-0.25, -0.25, -0.5, 0.5, -0.1875, -0.25}, -- NodeBox29
			{-0.3125, -0.3125, -0.5, 0.5, -0.25, -0.3125}, -- NodeBox30
			{-0.375, -0.375, -0.5, 0.5, -0.3125, -0.375}, -- NodeBox31
			{-0.4375, -0.4375, -0.5, 0.5, -0.375, -0.4375}, -- NodeBox32
		},
	}
	minetest.register_node(":" .. name.."_slant_inner", qts.table_deep_copy(def))
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.4375, 0.4375, -0.4375, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.375, 0.375, -0.375, 0.4375, 0.5}, -- NodeBox3
			{-0.5, 0.3125, 0.3125, -0.3125, 0.375, 0.5}, -- NodeBox4
			{-0.5, 0.25, 0.25, -0.25, 0.3125, 0.5}, -- NodeBox5
			{-0.5, 0.1875, 0.1875, -0.1875, 0.25, 0.5}, -- NodeBox6
			{-0.5, 0.125, 0.125, -0.125, 0.1875, 0.5}, -- NodeBox7
			{-0.5, 0.0625, 0.0625, -0.0625, 0.125, 0.5}, -- NodeBox8
			{-0.5, 0, 0, 0, 0.0625, 0.5}, -- NodeBox9
			{-0.5, -0.0625, -0.0625, 0.0625, 0, 0.5}, -- NodeBox10
			{-0.5, -0.125, -0.125, 0.125, -0.0625, 0.5}, -- NodeBox11
			{-0.5, -0.1875, -0.1875, 0.1875, -0.125, 0.5}, -- NodeBox12
			{-0.5, -0.25, -0.25, 0.25, -0.1875, 0.5}, -- NodeBox13
			{-0.5, -0.3125, -0.3125, 0.3125, -0.25, 0.5}, -- NodeBox14
			{-0.5, -0.375, -0.375, 0.375, -0.3125, 0.5}, -- NodeBox15
			{-0.5, -0.4375, -0.4375, 0.4375, -0.375, 0.5}, -- NodeBox16
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox17
		},
	}
	minetest.register_node(":" .. name.."_slant_outer", qts.table_deep_copy(def))
	--SLAB-----------------------
	def.groups.shaped_slant = nil
	def.groups.shaped_slab = 1
	def.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
	}
	def.on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		local wield_item = itemstack:get_name()
		local player_name = placer and placer:get_player_name() or ""
		local creative_enabled = qts.is_player_creative(player_name)

		if under and under.name:find("_slab") then
			-- place slab using under node orientation
			local dir = minetest.dir_to_facedir(vector.subtract(
				pointed_thing.above, pointed_thing.under), true)

			local p2 = under.param2

			-- Placing a slab on an upside down slab should make it right-side up.
			if p2 >= 20 and dir == 8 then
				p2 = p2 - 20
			-- same for the opposite case: slab below normal slab
			elseif p2 <= 3 and dir == 4 then
				p2 = p2 + 20
			end

			-- else attempt to place node with proper param2
			minetest.item_place_node(ItemStack(wield_item), placer, pointed_thing, p2)
			if not creative_enabled then
				itemstack:take_item()
			end
			return itemstack
		else
			return qts.rotate_and_place(itemstack, placer, pointed_thing)
		end
	end

	minetest.register_node(":"..name.."_slab", qts.table_deep_copy(def))
end