--[[

{
	ingredients = {[ItemString] = 1, [ItemString] = 1...},
	near = {["nodename"] = 1, ['nodename"] = 1 ...},
	held = {["item"] = 1, ["item"] = 1 ...},
	results = {[ItemString] = 1 ([ItemString] = 1 ...)},
	type = "type",
	
	on_craft = function(crafter, results) return results end
}

qts.register_craft({
	ingredients = {"itemname", "itemname 2" ...},
	near OR near_nodes = {"nodename", "nodename" ...},
	held OR held_items = {"item", "item" ...},
	results = {"itemname", "itemname" ...},
	type = "type", [default: 'default']
	on_craft = function(crafter, results) return results end
})
--]]

qts.crafts = {}

--[[
creating an arbitrary craft recipe
--]]
qts.create_craft_recipe = function(recip)
	local t = {}
	t.ingredients = {}
	t.near = {}
	t.held = {}
	t.results = {}
	t.type = recip.type or 'default'
	if (recip.on_craft) then t.on_craft = recip.on_craft end
	for k, v in ipairs(recip.ingredients) do
		t.ingredients[v] = 1 
	end
	if (recip.near and not recip.near_nodes) then recip.near_nodes = recip.near end
	if (recip.near_nodes) then
		for k, v in ipairs(recip.near_nodes) do
			t.near[v] = 1 
		end
	end
	if (recip.held and not recip.held_items) then recip.held_items = recip.held end
	if (recip.held_items) then
		for k, v in ipairs(recip.held_items) do
			t.held[v] = 1 
		end
	end
	for k, v in ipairs(recip.results) do
		t.results[v] = 1 
	end
	return t
end


--[[
Registers a crafting recipe.
--]]
qts.register_craft = function(recip)
	--minetest.log("CRAFT REGISTRATION BEGIN: " .. dump(recip))
	local t = qts.create_craft_recipe(recip)
	--minetest.log("recip data: " .. dump(t))
	for key, v in pairs(t.results) do
		local itemName = ItemStack(key):get_name()
		--minetest.log("recip stored under: " .. dump(itemName))
		if not qts.crafts[itemName] then
			qts.crafts[itemName] = {}
		end
		qts.crafts[itemName][#qts.crafts[itemName]+1] = t
	end
end



--[[
gets a list of crafting recipes that result in a particular item.
--]]
qts.get_craft_recipes = function(item)
	if (qts.crafts[item]) then
		return qts.table_deep_copy(qts.crafts[item])
	else
		return {}
	end
end

--[[
checks if the player can craft an item. If they can, returns recipe. If not, returns nil.
--]]
qts.player_can_craft_item = function(item, player)
	local r = qts.get_craft_recipes(item)
	for k, recip in ipairs(r) do
		if qts.player_can_craft(recip, player) then
			return recip
		end
	end
	return nil
end

--[[
Checks if the player can craft a specific recipe.
--]]
qts.player_can_craft = function(recipe, player)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	local inv = player:get_inventory()
	for item, v in pairs(recipe.ingredients) do
		if (qts.is_group(item)) then
			if not qts.inv_contains_group(inv, item, recipe.results) then
				return false
			end
		else
			if not inv:contains_item('main', item) then
				return false
			end
		end
	end
	for item, v in pairs(recipe.held) do
		if (qts.is_group(item)) then
			if not qts.inv_contains_group(inv, item) then
				return false
			end
		else
			if not inv:contains_item('main', item) then
				return false
			end
		end
	end
	--qts.is_node_in_radius(pos, radius, nodename)
	for nodename, v in pairs(recipe.near) do
		if (not qts.is_node_in_radius(player:get_pos(), 10, nodename)) then
			return false
		end
	end
	return true
end

--[[
executes a craft for a player
--]]
qts.execute_craft = function(recipe, player)
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	if (not qts.player_can_craft(recipe, player)) then
		return false
	end
	local inv = player:get_inventory()
	
	local results = qts.table_deep_copy(recipe.results)
	
	if (recipe.on_craft) then
		results = recipe.on_craft(player, results)
	end
	
	if (not results) then
		return false
	end
	
	for item, v in pairs(recipe.ingredients) do
		if (qts.is_group(item)) then
			qts.inv_take_group(inv, item, recipe.results)
		else
			inv:remove_item('main', item)
		end
	end
	
	for item, v in pairs(results) do
		local leftover = inv:add_item('main', item)
		if leftover then
			minetest.item_drop(leftover, player, player:get_pos())
		end
	end
	return true
end

--Execute fallback.lua
--this is where minetest-style crafts are re-registered
dofile(qts.path.."/crafting/fallback.lua")