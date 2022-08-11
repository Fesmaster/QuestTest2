

--[[
qts.register_shaped_node ("foundry:marker", {
	description = "Test Marker",
	tiles = {"foundry_marker.png"},
	drawtype = "glasslike_framed_optional",
	paramtype = "light",
	groups = {cracky=3},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})
--]]

minetest.register_tool("foundry:analizer", {
	description = "Foundry Analizer Tool",
	inventory_image = "foundry_analizer.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local p = foundry.get_pos_foundry(pointed_thing.under)
			if p then
				minetest.log("info","Foundry: "..minetest.pos_to_string(p))
				local FD = foundry.GetFoundryData(p)
				FD:add_heat(100)
				FD:apply()
			else
				minetest.log("info","Foundry: NONE")
			end
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local p = foundry.get_pos_foundry(pointed_thing.under)
			if p then
				local FD = foundry.GetFoundryData(p)
				minetest.log("info","Foundry Data:"..dump(FD))
			end
		end
	end,
})

--]]

qts.register_shaped_node ("foundry:scorched_brick", {
	description = "Scorched Brick",
	tiles = {"foundry_scorched_brick.png"},
	groups = {cracky=3, bricks=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

minetest.register_node ("foundry:casting_sand",  {
description = "Casting Sand",
	tiles = {"foundry_casting_sand.png"},
	groups = {oddly_breakable_by_hand = 3, crumbly = 3, falling_node=1,sand=1},
	sounds = qtcore.node_sound_sand(),
})

minetest.register_node("foundry:crucible_empty", {
	description = "Empty Crucible",
	drawtype = "glasslike_framed",
	tiles = {"foundry_crucible_top.png"},
	drop = "",
	--special_tiles = {"foundry_test_brass.png"},
	paramtype = "light",
	--paramtype2 = "glasslikeliquidlevel",
	groups = {cracky=3, bricks=1, foundry_crucible = 1, not_in_creative_inventory = 1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})





local rot_from_facedir = {
	[0] = 0,
	-math.pi/2,
	math.pi,
	math.pi/2,
}

--the foundry spout
minetest.register_node("foundry:spout", {
	description = "Spout",
	drawtype = "mesh",
	mesh = "spout.obj",
	tiles = {{name = "foundry_scorched_brick.png"}},
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {-3/16, -3/16, 0, 3/16, 3/16, 1/2},
	},
	collision_box = {
		type = "fixed",
		fixed = {-3/16, -3/16, 0, 3/16, 3/16, 1/2},
	},
	groups = {cracky=3},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	on_rotate = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local off = foundry.rotate_vector_by_facedir({x=0, y=0, z=1}, node.param2)
		local fpos = foundry.get_pos_foundry(vector.add(pos, off))
		local objs = minetest.get_objects_inside_radius(pos, 1)
		for i, obj in ipairs(objs) do
			local luaobj = obj:get_luaentity()
			if luaobj and luaobj.qtid and luaobj.qtid == "foundry_casting_flow" then
				minetest.log("info","FOUNDRY: Casting Flow exists. Ignoring second construction.")
				return --the casting flow exists
			end
		end
		if fpos then
			local FD = foundry.GetFoundryData(fpos)
			if FD and FD:has_metal(1) then
				--minetest.log(dump(FD))
				local below = minetest.get_node_or_nil(vector.add(pos, {x=0, y=-1, z=0}))
				if below and below.name then
					local def = minetest.registered_nodes[below.name]
					if def and def.can_cast then
						if not def.can_cast(vector.add(pos, {x=0, y=-1, z=0}), below, FD, clicker) then
							minetest.log("info","FOUNDRY: cannot cast")
							return
						end
					end
					if def and def.on_cast then
						local func = def.on_cast
						minetest.log("info","FOUNDRY: Flow should be added")
						local flow = minetest.add_entity(pos, "foundry:casting_flow")
						flow:set_yaw(rot_from_facedir[node.param2 % 4])
						minetest.log("verbose", "FOUNDRY: pos:"..minetest.pos_to_string(pos) .. "|flow pos"..minetest.pos_to_string(flow:get_pos()))
						minetest.after(0.75, function(func, flow, pos, below, fpos, clicker)
							local FD = foundry.GetFoundryData(fpos)
							flow:remove()
							if FD then
								func(pos, below, FD, clicker)
							else
								minetest.log("Foundry Issue")
							end
						end, func, flow, vector.add(pos, {x=0, y=-1, z=0}), below, fpos, clicker)
					end
				end
			end
		end
	end,
})
--flowing metal
minetest.register_entity("foundry:casting_flow", {
	--qtid = "foundry_casting_flow",
	visual = "mesh",
	mesh = "flow.obj",
	static_save = false,
	textures = {"foundry_steel_molten.png"},
	visual_size = {x=10, y=10, z=10},
	is_visible = true,
	pointable = false,
	physical = false,
	glow = minetest.LIGHT_MAX,
	on_step = function(self, dtime)
		local pos = self.object:get_pos()
		local node = minetest.get_node_or_nil(pos)
		if node then
			if node.name ~= "foundry:spout" then
				self.object:remove()
			end
		end
	end,
	on_activate = function(self)
		self.object:set_armor_groups({immortal = 1})
		self.QTID = qts.gen_entity_id()
	end,
})




minetest.register_node ("foundry:ingot_mold", {
	description = "Ingot Mold",
	tiles = {"foundry_mold_top.png", "foundry_ingot_mold.png"},
	groups = {cracky=3, oddly_breakable_by_hand=2, foundry_mold=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	can_cast = function(pos, node, FD, caster)
		if node.param2 < 8 and FD then
			return FD:has_metal(1)
		else
			return false
		end
	end,
	on_cast = function(pos, node, FD, caster)
		--minetest.log("From Caster:\n"..dump(FD))
		if node.param2 < 8 and FD then
			local meta = minetest.get_meta(pos)
			if node.param2 == 0 then
				--set metal type
				meta:set_string("metalType", FD.metalID)
			else
				--check metal type
				local metal = meta:get_string("metalType")
				if metal ~= FD.metalID then
					minetest.log("info","FOUNDRY: not the same metal added: "..dump(metal).."|"..dump(FD.metalID))
					return
				end
			end

			--get the maximum that can be added
			local addable_ammount = math.min(8 - node.param2, FD:get_metal_ammount())
			

			if FD:take_metal(addable_ammount) then
				FD:apply()
				--node world stuff
				node.param2 = node.param2 + addable_ammount
				minetest.swap_node(pos, node)
			else
				minetest.log("info","FOUNDRY: No Metal")
			end
		end

	end,
	on_dig = function(pos, node, digger)
		if node.param2 > 0 then
			--foundry.registered_metals
			local meta = minetest.get_meta(pos)
			local metalID = meta:get_string("metalType")
			if metalID ~= "" then
				local metal = foundry.registered_metals[metalID]
				if metal then
					minetest.handle_node_drops(pos, {ItemStack(metal.ingot.." "..node.param2)}, digger)
				end
			end
		end
		return minetest.node_dig(pos, node, digger)
	end,
})





minetest.register_node ("foundry:block_mold", {
	description = "Block Mold",
	tiles = {"foundry_mold_top.png", "foundry_block_mold.png"},
	groups = {cracky=3, oddly_breakable_by_hand=2, foundry_mold=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	can_cast = function(pos, node, FD, caster)
		if node.param2 < 1 and FD then
			return FD:has_metal(16)
		else
			return false
		end
	end,
	on_cast = function(pos, node, FD, caster)
		--minetest.log("From Caster:\n"..dump(FD))
		if node.param2 < 1 and FD then
			local meta = minetest.get_meta(pos)
			meta:set_string("metalType", FD.metalID)
			if FD:take_metal(16) then
				FD:apply()
				--node world stuff
				node.param2 = node.param2 + 1
				minetest.swap_node(pos, node)
			else
				minetest.log("info","FOUNDRY: No Metal")
			end
		end

	end,
	on_dig = function(pos, node, digger)
		if node.param2 > 0 then
			--foundry.registered_metals
			local meta = minetest.get_meta(pos)
			local metalID = meta:get_string("metalType")
			if metalID ~= "" then
				local metal = foundry.registered_metals[metalID]
				if metal then
					minetest.handle_node_drops(pos, {ItemStack(metal.block.." "..node.param2)}, digger)
				end
			end
		end
		return minetest.node_dig(pos, node, digger)
	end,
})


--[[
CRAFTING
--]]


qts.register_craft({
	ingredients = {"default:cement", "default:clay_lump"},
	results = {"foundry:spout",},
})

qts.register_craft({
	ingredients = {"group:sand", "default:clay_lump"},
	results = {"foundry:casting_sand",},
})

qts.register_craft({
	ingredients = {"group:sand", "default:clay_lump"},
	results = {"foundry:block_mold",},
})

qts.register_craft({
	ingredients = {"group:sand", "default:clay_lump"},
	results = {"foundry:ingot_mold",},
})

qts.register_craft({
	ingredients = {"foundry:casting_sand"},
	results = {"foundry:block_mold",},
})

qts.register_craft({
	ingredients = {"foundry:casting_sand"},
	results = {"foundry:ingot_mold",},
})

qts.register_craft({
	ingredients = {"default:brick 4", "default:cement"},
	results = {"foundry:foundry_inactive",},
})
