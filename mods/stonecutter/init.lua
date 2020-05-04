
dofile(minetest.get_modpath("stonecutter").."\\functions.lua")

local esc = minetest.formspec_escape
local P = function(x,y) return qts.gui.gui_makepos(x,y):get() end
local S = function(x,y) return qts.gui.gui_makesize(x,y):get() end

qts.gui.register_gui("stonecutter", {
	tab_owner = true,
	get = function(data, pos, name)
		local spos = pos.x .. "," .. pos.y .. "," .. pos.z
		
		local str = "size["..S(9.5,8).."]real_coordinates[true]"..
			"list[nodemeta:" .. spos .. ";src;"..P(5.3,1.5)..";2,3;]"..
			"list[nodemeta:" .. spos .. ";dst;"..P(8.3,1.5)..";2,3;]"..
			"image_button["..P(7.3,1.5)..";1,1;inventory_craft_arrow.png^gui_one.png;craft_one;]"..--[transformR270
			"image_button["..P(7.3,2.5)..";1,1;inventory_craft_arrow.png^gui_ten.png;craft_ten;]"..
			"image_button["..P(7.3,3.5)..";1,1;inventory_craft_arrow.png^gui_all.png;craft_all;]"
			
			if data.stonecutter_selected then
				str = str .."item_image["..P(7.3,0.5)..";1,1;"..data.stonecutter_selected.."]"
			end
			--ok, thats the craft area
			str = str .. "container[0,0]"..
			"background9[0,0;"..S(3.5,3.4)..";gui_buttonareabg.png;false;16]"
			
			local x = 0
			local y = 0
			local types = {}
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local srclist = inv:get_list("src")
			for i, stack in ipairs(srclist) do
				local name = stonecutter.get_type(stack:get_name())
				minetest.log("Name of stack: ["..dump(stack:get_name()).."] is: "..dump(name))
				if name then
					types[name] = true --store as set
				end
			end
			--add the buttons
			for stonetype, _ in pairs(types) do
				for itemname, __ in pairs(stonecutter.stoneTypes[stonetype]) do
					if data.stonecutter_selected == nil then
						data.stonecutter_selected = itemname
					end
					str = str .. "item_image_button["..P(x,y)..";1,1;"..itemname..";"..itemname..";]"
					--iterator counting
					if x < 3 then
						x = x + 1
					else
						x = 0
						y = y + 1
					end
					if y > 3 then
						break
					end
				end
				if y > 3 then
					break
				end
			end
			
			str = str .. "container_end[]"..
			--main inventory and liststrings
			inventory.get_player_main(qts.gui.gui_makepos(1,4.5), false)..
			"listring[current_player;main]"..
			"listring[nodemeta:" .. spos .. ";src]"..
			"listring[current_player;main]"..
			"listring[nodemeta:" .. spos .. ";dst]"..
			"listring[current_player;main]"
		return str
	end,
	handle = function(data, pos, name, fields)
		--handle the selection buttons
		for itemname in stonecutter.stones() do
			if fields[itemname] then
				data.stonecutter_selected = itemname
				minetest.log(dump(itemname) .. " is selected")
				qts.gui.show_gui(pos, name, "stonecutter")
			end
		end
		
		local doCraft = false
		local craftCount = 0
		if fields.craft_one then
			doCraft = true
			craftCount = 1
		elseif fields.craft_ten then
			doCraft = true
			craftCount = 10
		elseif fields.craft_all then
			doCraft = true
			craftCount = -1
		end
		
		if doCraft and data.stonecutter_selected then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local srclist = inv:get_list("src")
			for i, stack in ipairs(srclist) do
				local sname = stack:get_name()
				if stonecutter.get_type(sname) == stonecutter.get_type(data.stonecutter_selected) then
					if craftCount > 0 or craftCount == -1 then
						--craft one
						local count = stack:get_count()
						if count > craftCount and craftCount ~= -1 then
							--craft some
							local r_count = count - craftCount
							local result = ItemStack(data.stonecutter_selected.." "..craftCount)
							if inv:room_for_item("dst", result) then
								--execute the craft
								inv:add_item("dst", result)
								stack:set_count(r_count)
								inv:set_stack("src", i, stack)
							end
						else
							--craft all in the stack
							local result = ItemStack(data.stonecutter_selected.." "..count)
							if inv:room_for_item("dst", result) then
								--execute the craft
								inv:add_item("dst", result)
								stack:set_count(0)
								inv:set_stack("src", i, "")
							end
							--if not crafting all, remove the crafted from the count
							if craftCount ~= -1 then
								craftCount = craftCount - count
							end
						end
						
					end
				end
			end
		end
	end,
})







minetest.register_node("stonecutter:stonecutter", {
	description = "Stonecutter",
	tiles = {"stonecutter.png"}, --TODO:finish tiles
	--paramtype2 = "facedir",
	groups = {cracky=2},
	is_ground_content = false,
	sounds = qtcore.node_sound_stone(),
	
	can_dig = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("src") and inv:is_empty("dst")
	end,
	
	on_construct = function(pos)
		--setup its inventory
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("src", 6)
		inv:set_size("dst", 6)
	end,
	
	--metadata functions
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "src" then
			local stonetype = stonecutter.get_type(stack:get_name())
			if stonetype ~= nil then
				return stack:get_count()
			else
				return 0
			end
		else
			return 0
		end
	end,
	
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		if listname == "src" then
			local stonetype = stonecutter.get_type(stack:get_name())
			if stonetype ~= nil then
				return stack:get_count()
			else
				return 0
			end
		else
			return 0
		end
	end,
	
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end
		return stack:get_count()
	end,
	
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		qts.gui.show_gui(pos, player, "stonecutter")
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		qts.gui.show_gui(pos, player, "stonecutter")
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		qts.gui.show_gui(pos, player, "stonecutter")
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		qts.gui.show_gui(pos, clicker, "stonecutter")
	end,
	
	on_blast = function(pos)
		local drops = {}
		qts.get_node_inventory_drops(pos, "src", drops)
		qts.get_node_inventory_drops(pos, "dst", drops)
		drops[#drops+1] = "stonecutter:stonecutter"
		minetest.remove_node(pos)
		return drops
	end,
})

--
--Registrations
--

stonecutter.register_stonetype("stone", {
	"default:stone", 
	"default:stone_cobble", 
	"default:stone_brick", 
	"default:stone_block", 
	"default:brick_grey",
	"default:stone_wall",
	"default:stone_cobble_wall",
	"default:stone_brick_wall",
})

stonecutter.register_stonetype("red_stone", {
	"default:red_stone", 
	"default:red_stone_cobble", 
	"default:red_stone_brick", 
	"default:red_stone_block", 
	"default:red_stone_wall",
	"default:red_stone_cobble_wall",
	"default:red_stone_brick_wall",
})

stonecutter.register_stonetype("sandstone", {
	"default:sandstone", 
	"default:sandstone_cobble", 
	"default:sandstone_brick", 
	"default:sandstone_block", 
	"default:sandstone_wall",
	"default:sandstone_cobble_wall",
	"default:sandstone_brick_wall",
})

stonecutter.register_stonetype("desert_sandstone", {
	"default:desert_sandstone", 
	"default:desert_sandstone_cobble", 
	"default:desert_sandstone_brick", 
	"default:desert_sandstone_block", 
	"default:desert_sandstone_wall",
	"default:desert_sandstone_cobble_wall",
	"default:desert_sandstone_brick_wall",
})

stonecutter.register_stonetype("obsidian", {
	"default:obsidian", 
	"default:obsidian_brick", 
	"default:obsidian_block", 
})