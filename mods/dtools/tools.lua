

minetest.register_tool ("dtools:gauntlet", {
	description = ("Gauntlet of DESTRUCTION"),
	inventory_image = "wieldhand.png",
	wield_image = "wieldhand.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			crumbly = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			choppy = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			snappy = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			oddly_breakable_by_hand = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
		},
		damage_groups = {fleshy=10000},
	},
})


minetest.register_tool("dtools:testingTool", {
	description = "Testing Tool:\nCurrently messes with param2",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		--minetest.log("QTS Testing Tool used")
		minetest.log(dump(minetest.registered_nodes["air"].groups))
		if pointed_thing.under then
			--minetest.log("Node: " .. qts.classify_node(minetest.get_node_or_nil(pointed_thing.under)))
		end
		--[[
		--explode
		if pointed_thing.under then
			qts.explode(pointed_thing.under, 10, {
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
				exploder = user
			})
		end
		--]]
		
		--[[
		--param2 mess
		if pointed_thing.under then
			local node = minetest.get_node(pointed_thing.under)
			node.param2 = node.param2 + 1
			minetest.set_node(pointed_thing.under, node)
			--minetest.set_node(pointed_thing.above, {name="arcane:disollving_stone", param2=20})
			--minetest.log(minetest.pos_to_string(vector.subtract(pointed_thing.above, pointed_thing.under)))
			minetest.set_node(pointed_thing.above, {name="overworld:snow"})
		end
		--]]
        
		--[[
		
		local pos = nil
		if pointed_thing.under then
			pos = pointed_thing.under
		elseif user then
			pos = user:get_pos()
		end
			--local node = minetest.get_node(pointed_thing.under)
			--node.param2 = node.param2 + 1
			--minetest.set_node(pointed_thing.under, node)
			--minetest.set_node(pointed_thing.above, {name="arcane:disollving_stone", param2=10})
		if pos then
			local radius = 10
			for x = -radius, radius do
				for z = -radius, radius do
					for y = -radius, radius do
						local p = vector.add(pos, {x=x,y=y,z=z})
						local node = minetest.get_node(p)
						if node and node.name and minetest.get_item_group(node.name, "ore") == 0 then
							if p.x%5==0 and p.y%5==0 and p.z%5==0 then
								minetest.set_node(p, {name="dtools:light_node"})
							else
								minetest.set_node(p, {name="air"})
							end
						end
					end
				end
			end
		end
		--]]
	end,
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool placed")
		--[[
		--param2 mess
		if pointed_thing.under then
			local node = minetest.get_node(pointed_thing.under)
			node.param2 = node.param2 - 1
			minetest.set_node(pointed_thing.under, node)
			--minetest.set_node(pointed_thing.above, {name="arcane:disollving_stone", param2=20})
			--minetest.log(minetest.pos_to_string(vector.subtract(pointed_thing.above, pointed_thing.under)))
		end
		--]]
        --[[
		local pos = nil
		if pointed_thing.under then
			pos = pointed_thing.under
		elseif user then
			pos = user:get_pos()
		end
		if pos then
			local radius = 10
			for x = -radius, radius do
				for z = -radius, radius do
					for y = -radius, radius do
						local p = vector.add(pos, {x=x,y=y,z=z})
						--local node = minetest.get_node(p)
						--if node and node.name then
						if p.x%5==0 and p.y%5==0 and p.z%5==0 then
							minetest.set_node(p, {name="dtools:light_node"})
						else
							minetest.set_node(p, {name="air"})
						end
					end
				end
			end
		end
        --]]
	end
})

minetest.register_node("dtools:light_node", {
	description = "Light Spreading Node",
	sunlight_propagates = true,
	paramtype = "light",
	drawtype = "airlike",
	walkable = false,
	pointable = false,
	diggable = true,
	floodable = true,
	is_ground_content = false,
	buildable_to = true,
	light_source = minetest.LIGHT_MAX,
})

minetest.register_tool("dtools:light_wand", {
	description = "Light Wand: Spreads Light",
	inventory_image = "dtools_blue_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		local pos = nil
		if (pointed_thing.under) then
			pos = pointed_thing.under
		elseif user then
			pos = user:get_pos()
		end
		local radius = 50
		for x = -radius, radius, 5 do
			for y = -radius, radius, 5 do
				for z = -radius, radius, 5 do
					local p = vector.add(pos, {x=x,y=y,z=z})
					local node = minetest.get_node(p)
					if node.name == "air" then
						minetest.set_node(p, {name="dtools:light_node"})
					end
				end
			end
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		local pos = nil
		if (pointed_thing.under) then
			pos = pointed_thing.under
		elseif user then
			pos = user:get_pos()
		end
		local radius = 50
		for x = -radius, radius do
			for y = -radius, radius do
				for z = -radius, radius do
					local p = vector.add(pos, {x=x,y=y,z=z})
					local node = minetest.get_node(p)
					if node.name == "craftable:torch" then
						minetest.set_node(p, {name="dtools:light_node"})
					end
				end
			end
		end
	end,
})



minetest.register_tool("dtools:timer_tool", {
	description = "Timer Tool:\nShows the node's timer",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Timer Tool used")
		if pointed_thing.under then
			local timer = minetest.get_node_timer(pointed_thing.under)
			if timer then
				minetest.log("Node Timer at: " .. minetest.pos_to_string(pointed_thing.under) .. "\n" ..
					dump(timer:get_elapsed()) .. "/" .. dump(timer:get_timeout()) ..
					"  -  started? " .. dump(timer:is_started()))
				--qts.get_modname_from_item(itemname)

			end
		end
	end,
})


minetest.register_tool("dtools:summoning_wand", {
	description = "Summoning Wand\nCurrently Summoning: dtools:static_entity",
	inventory_image = "dtools_blue_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Summoning Wand used")
		if pointed_thing.above then
			minetest.add_entity(pointed_thing.above, "dtools:mob_test_entity")
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("QTS Summoning Tool placed")
		if (pointed_thing.under) then
			qts.projetile_launch_to(
				"dtools:testing_projectile",
				vector.add(user:get_pos(), {x=0, y=1.5, z=0}),
				pointed_thing.under,
				user,
				25
			)
		end
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Summoning Tool rightclicked")
		--dtools.player_launch_projectile(user, "dtools:testing_projectile")
		qts.projectile_launch_player("dtools:testing_projectile", user, 5)
		--dtools.launch_test_projectile(vector.add(user:get_pos(), {x=0, y=1.5, z=0}), user:get_look_dir(), 25)
	end
})

minetest.register_tool("dtools:anti_stone", {
	description = "Anti Stone Tool",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool used")
		if pointed_thing.under then
			local nodes = qts.get_nodes_in_radius(pointed_thing.under, 10)
			for i, nodedat in ipairs(nodes) do
				if nodedat.noderef.name == "overworld:granite" then
					minetest.remove_node(nodedat.pos)
				end
			end
		end
	end,
	--[[
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool placed")
		if pointed_thing.under then
			local node = minetest.get_node_or_nil(pointed_thing.under)
			if node then
				node.param2 = node.param2 - 1
			end
			minetest.set_node(pointed_thing.under, node)
		end
	end
	--]]
})

minetest.register_tool("dtools:biome_check_tools", {
	description = "Biome Analitics Tool:\nCheck heat/humidity",
	inventory_image = "dtools_red_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if user then
			local p = user:get_pos()
			local humid = minetest.get_humidity(p)
			local heat = minetest.get_heat(p)
			local str = "Pos: ".. minetest.pos_to_string(p) .." Heat: "..dump(heat) .. " Humidity: "..dump(humid)
			minetest.chat_send_all(str)
			minetest.log(str)
		end
	end,

})
--[[
	BIT OP KEY
	counted from least significant to greatest
	Bit	| Binary	|decimal| hex number
	0	| 0000 0001	| 1		| 0x01
	1	| 0000 0010	| 2		| 0x02
	2	| 0000 0100	| 4		| 0x04
	3	| 0000 1000	| 8		| 0x08
	4	| 0001 0000	| 16	| 0x10
	5	| 0010 0000	| 32	| 0x20
	6	| 0100 0000	| 64	| 0x40
	7	| 1000 0000	| 128	| 0x80
]]
local wallmounted_dir_string_map = {
	[0]="y+","y-","x+","x-","z+","z-"
}
local facedir_dir_string_map = {
	[0]="y+","z+","z-","x+","x-","y-"
}
local meshoption_shape_map = {
	[0] = "an 'x' shape plant (default)",
	"a '+' shape plant (just rotated 45 degrees)",
	"a '*' shape plant with three faces instead of two",
	"a '#' shape plant with four faces instead of two",
	"a '#' shape plant with four faces instead of two but they lean out",
	"shape code reserved for future use",
	"shape code reserved for future use",
	"shape code reserved for future use",
}
local paramtype2_parse_funcs = {
	none = function(param)
		minetest.log("Param2: " .. dump(param) .. " : Type: none")
	end,
	flowingliquid = function (param)
		local liquidlevel = 	 param%0x08 		  -- bits 0,1,2,3
		local is_flowing_down = math.floor(param/0x08)%0x02 > 0 -- bit 4
		minetest.log("Param2: " .. dump(param) .. " : Type: flowingliquid\nLiquid Level: " 
			.. dump(liquidlevel) .. "\nIs Flowing Down: " .. dump(is_flowing_down))
	end,
	wallmounted = function(param)
		local dircode = param%0x8 -- bits 0,1,2,3
		local dir_string = wallmounted_dir_string_map[dircode]
		minetest.log("Param2: " .. dump(param) .. " : Type: wallmounted\nDirection: " 
			.. dump(dir_string) .. " (" .. dump(dircode) .. ")"
		)
	end,
	facedir = function(param)
		local count_rotate = param%0x04 	  -- bits 0,1
		local dirID = 		math.floor(param/0x04)%0x08 -- bits 2,3,4,5
		local dir_string = facedir_dir_string_map[dirID]
		minetest.log("Param2: " .. dump(param) .. " : Type: facedir\nDirection:" 
		.. dump(dir_string) .. " (" .. dump(dirID) .. ")\nRotations: "
		.. dump(count_rotate) .. " (" .. dump(count_rotate*90) .. " degrees)"
	)
	end,
	["4dir"] = function(param)
		local count_rotate = param%0x04 --bits 0,1
		minetest.log("Param2: " .. dump(param) .. " : Type: 4dir\nRotations: "
				.. dump(count_rotate) .. " (" .. dump(count_rotate*90) .. " degrees)"
			)
	end,
	wallmounteleveledd = function(param)
		minetest.log("Param2: " .. dump(param) .. " : Type: leveled")
	end,
	degrotate = function(param)
		minetest.log("Param2: " .. dump(param) .. " : Type: degrotate\nRotation: " 
			.. dump(param%240) .. "steps (" .. dump((param%240) * 1.5) .. " Degrees)"
		)
	end,
	meshoptions = function(param)
		local optID = 			 param%0x08			   -- bits 0,1,2
		local vary_horizontal = math.floor(param/0x08)%0x02 == 1 -- bit 3
		local make_larger = 	math.floor(param/0x10)%0x02 == 1 -- bit 4
		local vary_face_height =math.floor(param/0x20)%0x02 == 1 -- bit 5
		local reserved_1 = 		math.floor(param/0x40)%0x02 == 1 -- bit 6
		local reserved_2 = 		math.floor(param/0x80)%0x02 == 1 -- bit 7
		minetest.log("Param2: " .. dump(param) .. " : Type: meshoptions\nShape:"
			.. dump(meshoption_shape_map[optID]) .. " Code: " .. dump(optID)
			.. "\nVary Horizontal: " .. dump(vary_horizontal)
			.. "\nMake Larger: " .. dump(make_larger)
			.. "\nVary Face Height: " .. dump(vary_face_height)
			.. "\nReserved 1: " .. dump(reserved_1)
			.. "\nReserved 2: " .. dump(reserved_2)
		)
	end,
	color = function(param)
		minetest.log("Param2: " .. dump(param) .. " : Type: color")
	end,
	colorfacedir = function(param)
		local count_rotate = param%0x04 	  --bits 0, 1
		local dirID = 		math.floor(param/0x04)%0x08 --bits 2,3,4
		local colorid = 	math.floor(param/0x20)%0x08 --bits 5,6,7
		local dir_string = facedir_dir_string_map[dirID]
		minetest.log("Param2: " .. dump(param) .. " : Type: colorfacedir\nDirection:" 
		.. dump(dir_string) .. " (" .. dump(dirID) .. ")\nRotations: "
		.. dump(count_rotate) .. " (" .. dump(count_rotate*90) .. " degrees)\nColor Index: "
		.. dump(colorid)
		)
	end,
	color4dir = function(param)
		local count_rotate = param%0x04 	  --bits 0,1
		local colorid = 	math.floor(param/0x04)%0x40 --bits 2,3,4,5,6,7
		minetest.log("Param2: " .. dump(param) .. " : Type: color4dir\nRotations: "
			.. dump(count_rotate) .. " (" .. dump(count_rotate*90) .. " degrees)\nColor Index: "
			.. dump(colorid)
		)
	end,
	colorwallmounted = function(param)
		local dircode =  param%0x08 	  -- bits 0,1,2
		local colorid = math.floor(param/0x08)%0x20 -- bits 3,4,5,6,7
		local dir_string = wallmounted_dir_string_map[dircode]
		minetest.log("Param2: " .. dump(param) .. " : Type: colorwallmounted\nDirection: " 
			.. dump(dir_string) .. " (" .. dump(dircode) .. ")\nColor Index: "
			.. dump(colorid)
		)
		
	end,
	glasslikeliquidlevel = function(param)
		local liquidlevel =   param%0x40	  -- bits 0,1,2,3,4,5
		local connect_vert = math.floor(param/0x40)%0x2 -- bit 6
		local connect_horz = math.floor(param/0x80)%0x2 -- bit 7
		minetest.log("Param2: " .. dump(param) .. " : Type: glasslikeliquidlevel\nLiquid Level: "
			.. dump(liquidlevel) .. "\nConnect to nodes Vertically: "
			.. dump(connect_vert) .. "\nConnect to nodes Horizontally: "
			.. dump(connect_horz)
		)
	end,
	colordegrotate = function(param)
		local degbits = param%0x20		-- bots 0,1,2,3,4
		local colorid =math.floor(param/0x20)%0x8	-- bits 5,6,7
		minetest.log("Param2: " .. dump(param) .. " : Type: colordegrotate\nDegree Rotate: "
			.. dump(degbits%24) .. " steps (" .. dump((degbits%24)*15) .. " degrees)\nColor Index: "
			.. dump(colorid)
		)
	end,
}

minetest.register_tool("dtools:param_scanner", {
	description = "Node Param Scanner.\nRightclick:Param1\nLeftclick:Param2",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local node = minetest.get_node_or_nil(pointed_thing.under)
			if node then
				---@type integer
				local param2 = node.param2
				local paramtype2 = "none"
				local node_def = minetest.registered_nodes[node.name]
				if node_def and node_def.paramtype2 then
					paramtype2 = node_def.paramtype2
				end
				if paramtype2_parse_funcs[paramtype2] then
					paramtype2_parse_funcs[paramtype2](param2)
				else
					minetest.log("Param2: " .. dump(param2) .. " : Type: " .. dump(paramtype2))
				end
			else
				minetest.log("No node clicked. Try again.")
			end
		else
			minetest.log("No node clicked. Try again.")
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.under then
			local node = minetest.get_node_or_nil(pointed_thing.under)
			if node then
				
			else
				minetest.log("No node clicked. Try again.")
			end
		else
			minetest.log("No node clicked. Try again.")
		end
	end
})


qts.register_item_modifier("testPlace", {
	description = "Test Place Modifier",
	on_place = function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
		minetest.log("Test Place Modifier Placed")
		return false
	end,
	on_dignode = function(pos, node, digger)
		minetest.log("modified Item used to dig")
	end,
	on_punch_node = function(pos, node, puncher, pointed_thing)
		minetest.log("modified Item used to punch a node")
	end,
	on_punch_player = function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
		minetest.log("warning", "modified Item used to punch a player")
	end,
	on_punch_entity = function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
		minetest.log("warning", "modified Item used to punch a entity")
	end,
	on_dieplayer = function(player, reason)
		minetest.log("player died with modified Item in the inventory")
	end,
	inventory_can_act = function(player, action, inventory, inventory_info)
		minetest.log("player inventory action check with modified Item")
		return -1 --all are OK, or, ignore the results of this func
	end,
	inventory_on_act = function(player, action, inventory, inventory_info)
		minetest.log("player inventory action execute with modified Item")
	end,
})

--[[
minetest.register_tool("dtools:paintbrush", {
	description = "Paintbrush",
	inventory_image = "dtools_paintbrush.png",
	range = 10.0,
	--liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		minetest.log("Paintbrush Used")
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				local pindex = node.param2 / 32
				pindex = pindex + 1
				while(pindex >= 8) do pindex = pindex - 8 end
				--if (pindex >= 8) then pindex = 0 end
				node.param2 = pindex * 32
				minetest.set_node(pointed_thing.under, node)
			end
		end
	end,
	on_place = function(itemstack, user, pointed_thing)
		minetest.log("Paintbrush Placed")
		if (pointed_thing.type == "node") then
			local node = minetest.get_node(pointed_thing.under)
			local node_def = minetest.registered_nodes[node.name]
			if not node_def then return itemstack end
			if (node_def.palette) then
				local pindex = node.param2 / 32
				pindex = pindex - 1
				while(pindex <= -1) do pindex = pindex + 8 end
				--if (pindex <= -1) then pindex = 7 end
				node.param2 = pindex * 32
				minetest.set_node(pointed_thing.under, node)
			end
		end
	end,
})
--]]

minetest.register_craftitem("dtools:equipment_item", {
	description = "Generic Equipment item",
	inventory_image = "dtools_detector_blue.png",
	groups = {equipment=1},
	stack_max=1,
	crown_image = "dtools_horns.png",
	on_equip = function(player, itemstack)
		minetest.log("Fake Equipment Added")
		local handle = qts.add_player_modifier(player, {
			--sprint_multiplier_liquid = 10,
			sneak_multiplier = 1.5,
			ADD_health_bonus = 5,
			ADD_damgae_bonus_fleshy = 10,
			detection_range = 0.5,
			detection_range_sneak = 0.1,
		})
		qts.set_player_hp(player, qts.get_player_hp(player) + 5)
		local meta = itemstack:get_meta()
		meta:set_string("handle", handle)
		return itemstack
	end,
	on_unequip = function(player, itemstack)
		minetest.log("Fake Equipment Removed")
		local meta = itemstack:get_meta()
		local handle = meta:get_string("handle")
		meta:set_string("handle", "")
		qts.remove_player_modifier(player, handle)
		qts.refresh_player_hp(player)
		return itemstack
	end,
})

--gloves=1,shield=1,cuirass=1,cloak=1,boots=1

minetest.register_craftitem("dtools:basic_helmet", {
	description = "Basic Helmet",
	inventory_image = "dtools_helmet_item.png",
	armor_image = "dtools_helmet.png",
	groups = {helmet=1,},
	stack_max=1,
	armor_groups = {fleshy=5},
})

minetest.register_craftitem("dtools:basic_cuirass", {
	description = "Basic Cuirass",
	inventory_image = "dtools_cuirass_item.png",
	armor_image = "dtools_cuirass.png",
	groups = {cuirass=1,},
	stack_max=1,
	armor_groups = {fleshy=15},
})

minetest.register_craftitem("dtools:basic_gloves", {
	description = "Basic Gloves",
	inventory_image = "dtools_gloves_item.png",
	armor_image = "dtools_gloves.png",
	groups = {gloves=1,},
	stack_max=1,
	armor_groups = {fleshy=2},
})

minetest.register_craftitem("dtools:basic_boots", {
	description = "Basic Boots",
	inventory_image = "dtools_boots_item.png",
	armor_image = "dtools_boots.png",
	groups = {boots=1,},
	stack_max=1,
	armor_groups = {fleshy=2},
})

minetest.register_craftitem("dtools:basic_shield", {
	description = "Basic Shield",
	inventory_image = "dtools_shield_item.png",
	armor_image = "dtools_shield.png",
	groups = {shield=1,},
	stack_max=1,
	armor_groups = {fleshy=15},
})

minetest.register_craftitem("dtools:basic_cloak", {
	description = "Basic Cloak",
	inventory_image = "dtools_cape_item.png",
	skin_image = "dtools_cape.png",
	groups = {cloak=1,},
	stack_max=1,
	armor_groups = {fleshy=1},
})

--[[
qts.register_on_player_attack(function(victim, hitter, time_from_last_punch, tool_capabilities, dir)
	minetest.log("player punched something!")
end)
]]

minetest.register_tool("dtools:entity_analyzer", {
	description = "Entity Analizer",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	--liquids_pointable = true,
	--on_use = function(itemstack, user, pointed_thing)
	--end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		if pointed_thing ~= nil and pointed_thing.ref ~= nil then
			local obj = pointed_thing.ref
			local name = qts.object_name(obj)
			local luaentity = obj:get_luaentity()
			minetest.log("ENTITY DEBUG LOG: \n" .. 
				"Name: " .. dump(name) .. "\n"..
				"ID: " .. dump(qts.get_object_id(obj)) .. "\n"..
				"Pos: " .. dump(obj:get_pos()) .. "\n"..
				"Velocity: " .. dump(obj:get_velocity()) .. "\n"..
				"Acceleration: " .. dump(obj:get_acceleration()) .. "\n"..
				"Rotation: " .. dump(obj:get_rotation()) .. "\n"..
				"Yaw: " .. dump(obj:get_yaw()) .. "\n"..
				"Texture Modifier: " .. dump(obj:get_texture_mod()) .. "\n"..
				"HP: " .. dump(obj:get_hp()) .. "\n"..
				"Armor Groups: " .. dump(obj:get_armor_groups()) .. "\n"..
				--"\tAnimation: " .. dump(obj:get_animation()) .. "\n"..
				"Attached: " .. dump(obj:get_attach()) .. "\n"..
				"Num of Children: " .. dump(#(obj:get_children())) .. "\n"..
				"Properties: " .. dump(obj:get_properties()) .. "\n"..
				"Nametag: " .. dump(obj:get_nametag_attributes()) .. "\n"..
				"Lua Entity Table: " .. dump(obj:get_luaentity()) .. "\n"..
				""
			)
		end
	end
})


---@class PentoolCaveBrush:PentoolBrush

---Create a PentoolBrushPoint. This brush type draws a single node, and does not take into account shaped nodes.
---@return PentoolPointBrush
function dtools.create_cave_brush()
    return {
        ---PentoolBrush interface
        ---@param self PentoolCaveBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
			
			local nodes = qts.get_nodes_in_blob(transform.pos, transform.scale)
			--minetest.log("Cave blocks: " .. dump(nodes))
			for k, v in ipairs(nodes) do
				if (context:get_draw_alpha() < weight) then
				    minetest.set_node(v.pos, {name="air"})
				end
			end
        end,
        ---PentoolBrush interface copy
        ---@param self PentoolCaveBrush
        ---@return PentoolCaveBrush
        copy = function(self)
            return self
        end,
    }
end

---Generate a cave room and offshoots
---@param context PentoolContext
---@param iters integer how many recursive calls to make
local function generate_cave_room(context, iters)
	context:push()
	
	for i=1,context:get_random_int_in_range(5,15) do
		context:rotate(rotator(
			0, 
			context:get_random_int_in_range(-45,45), 
			context:get_random_int_in_range(-45,45)
		))
		:set_scale(vector.new(
			context:get_random_int_in_range(
				context:get_param("pathsizemin"),
				context:get_param("pathsizemax")
			),
			context:get_random_int_in_range(
				context:get_param("pathsizemin"),
				context:get_param("pathsizemax")
			),
			context:get_random_int_in_range(
				context:get_param("pathsizemin"),
				context:get_param("pathsizemax")
			)
		))
		:forward(context:get_random_int_in_range(
			context:get_param("forwardmin"),
			context:get_param("forwardmax")
		),2)
	end
	
	context:set_scale(vector.new(
		context:get_random_int_in_range(
			context:get_param("roomsizemin"), 
			context:get_param("roomsizemax")
		),
		context:get_random_int_in_range(2,4),
		context:get_random_int_in_range(
			context:get_param("roomsizemin"), 
			context:get_param("roomsizemax")
		)
	))
	:mark()
	if (iters > 0) then
		for i=1, context:get_random_int_in_range(1,3) do
			generate_cave_room(context, iters-1)
		end
	end
	context:pop()
end

qts.pentool.register_tool("dtools:palm", {}, function(context)
	context:pendown()
	:set_brush(qts.pentool.create_point_brush("overworld:palm_log"))
	:forward(5)
	:set_brush(qts.pentool.create_point_brush("overworld:palm_leaves"))
	:forward(1)
	:rotate(vector.new(math.rad(-90), 0, 0))
	:push()
	for i=0,5 do
		context:rotate(vector.new(0, math.rad(360/6)*i, 0))
		:forward(1.8, 0.6)
		:rotate(vector.new(math.rad(-40),0,0))
		:forward(1.8, 0.6)
		:peek()
	end
	context:pop()
	--located at top of tree.
	context:set_brush(qts.pentool.create_point_brush("overworld:granite"))
	:face_horizontal()
	:teleport_relative(vector.new(0, 5, 0))
	:face_up()
	:forward(1)
	:teleport_origin(vector.new(5, 5, 0)) -- origin is facing "up", so traslating on Z will move pen vertically
	:forward(1)
end)

qts.pentool.register_tool("dtools:cave", {
	roomsizemin=4,
	roomsizemax=6,
	pathsizemin=1.5,
	pathsizemax=3,
	forwardmin=3,
	forwardmax=5
}, function (context)
	context:penup()
	:face_up()
	:forward(1)
	:face_horizontal()
	:rotate(rotator(
		0, 
		context:get_random_int_in_range(-45,0), 
		context:get_random_int_in_range(-180,180)
	))
	:set_brush(dtools:create_cave_brush())
	:pendown()
	:set_scale(vector.new(
		context:get_random_int_in_range(
			context:get_param("pathsizemin"),
			context:get_param("pathsizemax")
		),
		context:get_random_int_in_range(
			context:get_param("pathsizemin"),
			context:get_param("pathsizemax")
		),
		context:get_random_int_in_range(
			context:get_param("pathsizemin"),
			context:get_param("pathsizemax")
		)
	))
	:forward(context:get_random_int_in_range(
		context:get_param("forwardmin"),
		context:get_param("forwardmax")
	),2)
	generate_cave_room(context, 3)
end)

qts.pentool.register_tool_instance("dtools:cave_larger", "dtools:cave", {
	roomsizemin=6,
	roomsizemax=12,
})

qts.pentool.register_tool_instance("dtools:cave_bulky", "dtools:cave_larger", {
	pathsizemin=3,
	pathsizemax=5,
})

minetest.register_tool("dtools:pentool_tester", {
	description = "PenTool testing wand",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	on_use = function(itemstack, user, pointed_thing)
		---@cast user Player

		if (pointed_thing.under== nil) then return end
		minetest.log("QTS PenTool Testing Tool used")
		
		local t = transform.new(
			pointed_thing.under,
			(pointed_thing.above - pointed_thing.under):normalize():dir_to_rotation(),
			vector.new(1,1,1)
		)
		t:set_rot(vector.new(t.rot.x, user:get_look_horizontal(), t.rot.z))
		--t:rotate(vector.new(user:get_look_horizontal(), 0, 0))

		minetest.log("Transform: " .. t:format())

		qts.pentool.execute_tool("dtools:cave_bulky", t)
		

		--qts.pentool.context_base.create(t, {})
		--:set_brush(dtools.create_cave_brush())
		--:set_scale(vector.new(5, 3, 8))
		--:pendown()
		--:mark()
	end,
})

