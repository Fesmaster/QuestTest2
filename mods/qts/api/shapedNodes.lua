--shaped Nodes API
--some of this code is heavily based on the stairs mod in minetest_game
--licensed under lgpl (see the license for QT2 in general)

qts.hammer = {}
function qts.rotate_and_place(itemstack, placer, pointed_thing, dont_place)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0
	
	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end
		
		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1
		
		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999999) then
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

function qts.hammer.rotate_and_set(placer, pointed_thing, node)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0
	local other = node.param2 - node.param2 % 32 --everything but the first five bits
	
	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end
		
		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y - math.floor(p0.y)
		--minetest.log("Face pos:"..tostring(fpos))
		
		if p0.y - 1 == p1.y or (fpos > -1 and fpos < 0 and not(placer:get_pos().y+1 > p0.y))then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.swap_node(p0, {name = node.name, param1 = node.param1, param2 = param2+other}) --last bit of param2 data added back in
end





qts.hammer.CHANGE_TYPE = 1
qts.hammer.CHANGE_STYLE = 2
function qts.hammer.apply(pointed_thing, user, mode)
	if not mode then mode = qts.hammer.CHANGE_TYPE end
	local player_name = user:get_player_name() or ""
	local pos = pointed_thing.under
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return
	end
	local node = minetest.get_node(pos)
	local nodedef= minetest.registered_nodes[node.name]
	if nodedef.on_hammer then
		local rval = nodedef.on_hammer(pointed_thing.under, user, mode)
		if rval == nil or rval == true then
			return
		end
	end
	if minetest.get_item_group(node.name, "shaped_node") >= 1 then
		if node.name:find("_stair") then
			if mode and mode == qts.hammer.CHANGE_STYLE then
				--change corner mode
				if node.name:find("_inner") then
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_inner", "_outer"),param1 = node.param1, param2 = node.param2})
				elseif node.name:find("_outer") then
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_outer", ""),param1 = node.param1, param2 = node.param2})
				else
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name.."_inner",param1 = node.param1, param2 = node.param2})
				end
			else
				--stair-->slab
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_stair", "_slant"),param1 = node.param1, param2 = node.param2})
			end
		elseif node.name:find("_slant") then
			if mode and mode == qts.hammer.CHANGE_STYLE then
				--change corner mode
				if node.name:find("_inner") then
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_inner", "_outer"),param1 = node.param1, param2 = node.param2})
				elseif node.name:find("_outer") then
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_outer", ""),param1 = node.param1, param2 = node.param2})
				else
					qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name.."_inner",param1 = node.param1, param2 = node.param2})
				end
			else
				--stair-->slab
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_slant", "_slab"):gsub("_inner", ""):gsub("_outer", ""),param1 = node.param1, param2 = node.param2})
			end
		elseif node.name:find("_slab") then
			--slab --> whole
			if mode == qts.hammer.CHANGE_TYPE then
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name:gsub("_slab", ""),param1 = node.param1, param2 = node.param2})
			end
		else
			--whole --> stair
			if mode == qts.hammer.CHANGE_TYPE then
				qts.hammer.rotate_and_set(user, pointed_thing, {name = node.name.."_stair",param1 = node.param1, param2 = node.param2})
			end
		end
		--TODO: implement any added shapes into the hammer functionality
	end
end

--[[
qts.register_hammer("Name", {
	description = "Desc",
	inventory_image = "inventory_image.png",
	wield_image = "wield_image.png",
	range = 7,
	groups = {groups=1},
	max_uses = 1000,
})
--]]
qts.register_hammer = function(name, def)
	if not def.groups then def.groups = {} end
	def.groups.hammer = 1
	minetest.register_tool(":"..name, {
		description = def.description,
		inventory_image = def.inventory_image,
		inventory_overlay = def.inventory_overlay,
		wield_image = def.wield_image,
		wield_overlay = def.wield_overlay,
		palette = def.palette,
		color = def.color,
		wield_scale = def.wield_scale,
		liquids_pointable = def.liquids_pointable,
		range = def.range,
		groups = def.groups,
		sound = def.sound,
		max_uses = def.max_uses or 1000,
		on_use = function(itemstack, user, pointed_thing)
			if pointed_thing.under then
				local node = minetest.get_node(pointed_thing.under)
				local nlvl = minetest.get_item_group(node.name, "level")
				local hlvl = minetest.get_item_group(itemstack:get_name(), "level")
				if nlvl <= hlvl then
					if user:get_player_control().sneak then
						qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_FACE)
					else
						qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_TYPE)
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
		end,
		on_place = function(itemstack, user, pointed_thing)
			if pointed_thing.under then
				local node = minetest.get_node(pointed_thing.under)
				local nlvl = minetest.get_item_group(node.name, "level")
				local hlvl = minetest.get_item_group(itemstack:get_name(), "level")
				if nlvl <= hlvl then
					if user:get_player_control().sneak then
						qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_AXIS)
					else
						qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_STYLE)
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
	})
end