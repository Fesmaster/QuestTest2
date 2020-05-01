
function qts.start_node_growth(pos)
	local node = minetest.get_node_or_nil(pos)
	if node == nil then return end
	local nodedef = minetest.registered_nodes[node.name]
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
		local p = {x=x,y=y,z=z}
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
			if node == nil then return end
			local nodedef = minetest.registered_nodes[node.name]
			if nodedef.on_grow then
				nodedef.on_grow(pos)
			end
		end,
		on_construct = qts.start_node_growth,
		groups = {},
		on_grow = function(pos)
			return
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