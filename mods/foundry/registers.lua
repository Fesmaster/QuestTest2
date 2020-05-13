

---[[
qts.register_shaped_node ("foundry:marker", {
	description = "Test Marker",
	tiles = {"foundry_marker.png"},
	drawtype = "glasslike_framed_optional",
	paramtype = "light",
	groups = {cracky=3},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})

minetest.register_tool("foundry:analizer", {
	description = "Foundry Analizer Tool",
	inventory_image = "foundry_analizer.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local p = foundry.get_pos_foundry(pointed_thing.under)
			if p then
				minetest.log("Foundry: "..minetest.pos_to_string(p))
				local FD = foundry.GetFoundryData(p)
				FD:add_heat(100)
				FD:apply()
			else
				minetest.log("Foundry: NONE")
			end
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local p = foundry.get_pos_foundry(pointed_thing.under)
			if p then
				local FD = foundry.GetFoundryData(p)
				minetest.log("Foundry Data:"..dump(FD))
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

minetest.register_node("foundry:crucible_empty", {
	description = "Empty Crucible",
	drawtype = "glasslike_framed",
	tiles = {"foundry_crucible_top.png"},
	--special_tiles = {"foundry_test_brass.png"},
	paramtype = "light",
	--paramtype2 = "glasslikeliquidlevel",
	groups = {cracky=3, bricks=1, foundry_crucible = 1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
})



foundry.register_metal("iron", {
	description = "Iron",
	texture = "foundry_steel_molten.png",
	ingot = "default:iron_bar",
	block = "default:iron_block",
})

foundry.register_smeltable({
	itemname = "default:iron_bar",
	smelt_time = 4,
	type = "melt",
	heat = 1,
	metal = "iron",
	metal_ammount = 1,
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
		objs = minetest.get_objects_inside_radius(pos, 1)
		for i, obj in ipairs(objs) do
			local luaobj = obj:get_luaentity()
			if luaobj and luaobj.qtid and luaobj.qtid == "foundry_casting_flow" then
				minetest.log("Casting Flow exists")
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
							minetest.log("cannot cast")
							return
						end
					end
					if def and def.on_cast then
						local func = def.on_cast
						minetest.log("Flow should be added")
						local flow = minetest.add_entity(pos, "foundry:casting_flow")
						flow:set_yaw(rot_from_facedir[node.param2 % 4])
						minetest.log(minetest.pos_to_string(pos) .. "|"..minetest.pos_to_string(flow:get_pos()))
						minetest.after(0.75, function(func, flow, pos, below, FD, clicker)
							flow:remove()
							func(pos, below, FD, clicker)
						end, func, flow, vector.add(pos, {x=0, y=-1, z=0}), below, FD, clicker)
					end
				end
			end
		end
	end,
})
--flowing metal
minetest.register_entity("foundry:casting_flow", {
	qtid = "foundry_casting_flow",
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
	end,
})




qts.register_shaped_node ("foundry:ingot_mold", {
	description = "Ingot Mold",
	tiles = {"foundry_ingot_mold.png"},
	groups = {cracky=3, foundry_mold=1},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	can_cast = function(pos, node, FD, caster)
		if node.param2 < 4 and FD then
			return FD:has_metal(1)
		else
			return false
		end
	end,
	on_cast = function(pos, node, FD, caster)
		--minetest.log("From Caster:\n"..dump(FD))
		minetest.log("Func Called")
		if node.param2 < 4 and FD then
			local meta = minetest.get_meta(pos)
			if node.param2 == 0 then
				--set metal type
				meta:set_string("metalType", FD.metalID)
			else
				--check metal type
				local metal = meta:get_string("metalType")
				if metal ~= FD.metalID then
					minetest.log("not the same metal added: "..dump(metal).."|"..dump(FD.metalID))
					return
				end
			end
			if FD:take_metal(1) then
				FD:apply()
				--node world stuff
				node.param2 = node.param2 + 1
				minetest.swap_node(pos, node)
			else
				minetest.log("No Metal")
			end
		end
		
	end,
	on_dig = function(pos, node, digger)
		if node.param2 > 0 then
			--foundry.registered_metals
			local meta = minetest.get_meta(pos)
			local metalID = meta:get_string("metalType")
			minetest.log("Meta: "..dump(metalID))
			if metalID ~= "" then  
				local metal = foundry.registered_metals[metalID]
				if metal then
					minetest.handle_node_drops(pos, {ItemStack(metal.ingot.." "..node.param2)}, digger)
				end
			end
		end
		minetest.node_dig(pos, node, digger)
		return
	end,
})





qts.register_shaped_node ("foundry:block_mold", {
	description = "Block Mold",
	tiles = {"foundry_block_mold.png"},
	groups = {cracky=3, foundry_mold=1},
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
		minetest.log("Func Called")
		if node.param2 < 1 and FD then
			local meta = minetest.get_meta(pos)
			meta:set_string("metalType", FD.metalID)
			if FD:take_metal(16) then
				FD:apply()
				--node world stuff
				node.param2 = node.param2 + 1
				minetest.swap_node(pos, node)
			else
				minetest.log("No Metal")
			end
		end
		
	end,
	on_dig = function(pos, node, digger)
		if node.param2 > 0 then
			--foundry.registered_metals
			local meta = minetest.get_meta(pos)
			local metalID = meta:get_string("metalType")
			minetest.log("Meta: "..dump(metalID))
			if metalID ~= "" then  
				local metal = foundry.registered_metals[metalID]
				if metal then
					minetest.handle_node_drops(pos, {ItemStack(metal.block.." "..node.param2)}, digger)
				end
			end
		end
		minetest.node_dig(pos, node, digger)
		return
	end,
})