
function qts.start_node_growth(pos)
	local node = minetest.get_node_or_nil(pos)
	if node == nil then return end
	local nodedef = minetest.registered_nodes[node.name]
			
	if nodedef.growable_nodes then
		--check below for a valid node
		local nodeb = minetest.get_node_or_nil(vector.add(pos, vector.new(0, -1, 0)))
		if nodeb == nil then return false end
		local nameb = nodeb.name
		
		local f = false
		for i, gnode_name in ipairs(nodedef.growable_nodes) do
			if (qts.get_modname_from_item(gnode_name) == "group") then
				if (minetest.get_item_group(nameb, qts.remove_modname_from_item(gnode_name)) ~= 0) then
					f = true
					break
				end
			else
				if gnode_name == nameb then
					f = true
					break
				end
			end
		end
		--the node is not on a growable surface
		if (not f) then
			return
		end
		
	end
	
	if nodedef.grow_timer and nodedef.grow_timer > 0 then
		local t = nodedef.grow_timer
		if nodedef.grow_timer_random and nodedef.grow_timer_random < t then
			t = t + (((math.random()*2)-1) * nodedef.grow_timer_random)
		end
		local timer = minetest.get_node_timer(pos)
		timer:set(t, 0)
	end
end

function qts.fertalize_node(pos)
	local node = minetest.get_node_or_nil(pos)
	if node and minetest.get_item_group(node.name, "growable") > 0 then
		local t = nodedef.grow_timer
		t:set(t:get_timeout(), t:get_elapsed()/2)
	end
end

function qts.start_area_growth(pos1, pos2)
	pos1, pos2 = vector.sort(pos1, pos2)
	for z = pos1.z, pos2.z do
	for y = pos1.y, pos2.y do
	for z = pos1.x, pos2.x do
		local p = vector.new(x,y,z)
		local node = minetest.get_node_or_nil(p)
		if node and minetest.get_item_group(node.name, "growable") > 0 then
			qts.start_node_growth(p)
		end
	end
	end
	end
end

function qts.register_growable_node(name, def)
	
	local defualts = {
		on_timer = function(pos, elapsed)
			local node = minetest.get_node_or_nil(pos)
			if node == nil then return false end
			
			local nodedef = minetest.registered_nodes[node.name]
			
			if nodedef.growable_nodes then
				--check below for a valid node, or restart timer
				local nodeb = minetest.get_node_or_nil(vector.add(pos, {x=0, y=-1, z=0}))
				if nodeb == nil then return false end
				local nameb = nodeb.name
				
				local f = false
				for i, gnode_name in ipairs(nodedef.growable_nodes) do
					if (qts.get_modname_from_item(gnode_name) == "group") then
						if (minetest.get_item_group(nameb, qts.remove_modname_from_item(gnode_name)) ~= 0) then
							f = true
							break
						end
					else
						if gnode_name == nameb then
							f = true
							break
						end
					end
				end
				--the node is not on a growable surface
				if (not f) then
					return false
				end
				
			end
			
			if nodedef.on_grow then
				return nodedef.on_grow(pos)
			else
				return false
			end
		end,
		on_construct = qts.start_node_growth,
		groups = {},
		on_grow = function(pos)
			return false
		end,
	}
	
	for k, v in pairs(defualts) do
		if def[k] == nil then
			def[k]=v
		end
	end
	
	def.groups.growable = 1
	
	
	minetest.register_node(name, def)
end