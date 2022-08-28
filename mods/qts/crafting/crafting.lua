--[[

Craft Recipe post-register format
{
	ingredients = {[ItemString] = 1, [ItemString] = 1...}, 		--set of ingredients
	near = {["nodename"] = 1, ['nodename"] = 1 ...},			--set of nodes that must be nearby
	held = {["item"] = 1, ["item"] = 1 ...},					--set of items that must be heald
	results = {[ItemString] = 1 ([ItemString] = 1 ...)},		--set of results
	type = "type",												--they type
	on_craft = function(crafter, results) -> results_override	--callback function, returns new results
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
	creating an arbitrary craft recipe, and return it
	This can be used for dynamic crafting, or other on-demand recipes.
	For regular craft recipes, use qts.register_craft(...)

	Params: 
		recip - a crafting recipe definition

	Returns: a craft recipe in post-register format

	Craft Recipe Definition
	Table
	{
		ingredients - array of itemstrings that are consumed by the craft
		near_nodes OR near - (may be nil) array of node names that must be near the player for the craft to be available (can take groups)
		held_items OR held - (may be nil) array of itemstrings that must be in the player's inventory for the crafft ot be available (can take groups)
		results - array of resulting itemstrings
		type = string, the type of recipe. used to sort them. special type "reference" is never craftable
		on_craft(crafter, results) -> results_override - function executed when the craft takes place, overrides the results
		description - when type == "reference", this is displayed instead of ingredients. Used for displaying non-normal manners of getting items (such as drops)
	}

	Craft Recipe post-register format
	{
		ingredients = {[ItemString] = 1, [ItemString] = 1...}, 		--set of ingredients
		near = {["nodename"] = 1, ['nodename"] = 1 ...},			--set of nodes that must be nearby
		held = {["item"] = 1, ["item"] = 1 ...},					--set of items that must be heald
		results = {[ItemString] = 1 ([ItemString] = 1 ...)},		--set of results
		type = "type",												--they type
		on_craft = function(crafter, results) -> results_override	--callback function, returns new results
		description													--only present if a reference recipe
	}
--]]
function qts.create_craft_recipe(recip)
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
	if t.type == "reference" then
		--reference recipes are not actually craftable
		t.description = recip.description or "Unknown Reference Recipe"
	end
	return t
end


--[[
Registers a crafting recipe.

	Params: 
		recip - a crafting recipe definition

	Craft Recipe Definition
	Table
	{
		ingredients - array of itemstrings that are consumed by the craft
		near_nodes OR near - (may be nil) array of node names that must be near the player for the craft to be available (can take groups)
		held_items OR held - (may be nil) array of itemstrings that must be in the player's inventory for the crafft ot be available (can take groups)
		results - array of resulting itemstrings
		type = string, the type of recipe. used to sort them. special type "reference" is never craftable
		on_craft(crafter, results) -> results_override - function executed when the craft takes place, overrides the results
		description - when type == "reference", this is displayed instead of ingredients. Used for displaying non-normal manners of getting items (such as drops)
	}
--]]
function qts.register_craft(recip)
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
	Register a reference craft recipe. This is basically a wrapper around qts.register_craft

	Params: 
		recip - a crafting recipe definition

	Craft Recipe Definition
	Table
	{
		ingredients - array of itemstrings that are consumed by the craft
		near_nodes OR near - (may be nil) array of node names that must be near the player for the craft to be available (can take groups)
		held_items OR held - (may be nil) array of itemstrings that must be in the player's inventory for the crafft ot be available (can take groups)
		results - array of resulting itemstrings
		type = for this function specifically, forced to be "reference"
		on_craft(crafter, results) -> results_override - function executed when the craft takes place, overrides the results
		description - when type == "reference", this is displayed instead of ingredients. Used for displaying non-normal manners of getting items (such as drops)
	}
]]
function qts.register_reference_craft(recip)
	recip.type = "reference"
	qts.register_craft(recip)
end

--[[
	gets a list of crafting recipes that result in a particular item.

	Params:
		item - an item name (no count)

	Returns:
		an array of crafing recipes (in the post-registered format)

	Craft Recipe post-register format
	{
		ingredients = {[ItemString] = 1, [ItemString] = 1...},      --set of ingredients
		near = {["nodename"] = 1, ["nodename"] = 1 ...},            --set of nodes that must be nearby
		held = {["item"] = 1, ["item"] = 1 ...},                    --set of items that must be heald
		results = {[ItemString] = 1 ([ItemString] = 1 ...)},        --set of results
		type = "type",                                              --they type
		on_craft = function(crafter, results) -> results_override   --callback function, returns new results
	}
--]]
function qts.get_craft_recipes(item)
	if (qts.crafts[item]) then
		return qts.table_deep_copy(qts.crafts[item])
	else
		return {}
	end
end

--[[
	checks if the player can craft an item. If they can, returns recipe. If not, returns nil.

	Params: 
		item - the item name
		player - the player

	Returns:
		the first recipe found in post-register format, or nil

	Craft Recipe post-register format
	{
		ingredients = {[ItemString] = 1, [ItemString] = 1...},      --set of ingredients
		near = {["nodename"] = 1, ["nodename"] = 1 ...},            --set of nodes that must be nearby
		held = {["item"] = 1, ["item"] = 1 ...},                    --set of items that must be heald
		results = {[ItemString] = 1 ([ItemString] = 1 ...)},        --set of results
		type = "type",                                              --they type
		on_craft = function(crafter, results) -> results_override   --callback function, returns new results
	}
--]]
function qts.player_can_craft_item(item, player)
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

	Params:
		recipe - a recipe in post-register format
		player - the player

	Returns
		boolean true or false

	Craft Recipe post-register format
	{
		ingredients = {[ItemString] = 1, [ItemString] = 1...},      --set of ingredients
		near = {["nodename"] = 1, ["nodename"] = 1 ...},            --set of nodes that must be nearby
		held = {["item"] = 1, ["item"] = 1 ...},                    --set of items that must be heald
		results = {[ItemString] = 1 ([ItemString] = 1 ...)},        --set of results
		type = "type",                                              --they type
		on_craft = function(crafter, results) -> results_override   --callback function, returns new results
	}
--]]
function qts.player_can_craft(recipe, player)
	--reference recipes are not craftable
	if recipe.type == "reference" then return false end
	if type(player) == "string" then
		player = minetest.get_player_by_name(player)
	end
	local inv = player:get_inventory()
	for item, v in pairs(recipe.ingredients) do
		if (qts.is_group(item)) then
			if not qts.inventory_contains_group(inv, "main", item, recipe.results) then
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
			if not qts.inventory_contains_group(inv, "main", item) then
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
	executes a craft for a player. 
	Ingredients are taken from inventory,
	Results are added.

	Params:
		recipe - the recipe in post-register format
		player - the player

	Returns:
		boolean true or false

	Craft Recipe post-register format
	{
		ingredients = {[ItemString] = 1, [ItemString] = 1...},      --set of ingredients
		near = {["nodename"] = 1, ["nodename"] = 1 ...},            --set of nodes that must be nearby
		held = {["item"] = 1, ["item"] = 1 ...},                    --set of items that must be heald
		results = {[ItemString] = 1 ([ItemString] = 1 ...)},        --set of results
		type = "type",                                              --they type
		on_craft = function(crafter, results) -> results_override   --callback function, returns new results
	}
--]]
function qts.execute_craft(recipe, player)
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
			qts.inventory_take_group(inv, "main", item, recipe.results)
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

--sort the recipes, with reference always being at the end
local function craft_sorter(a, b)
	if a.type == "reference" then return false end
	return string.lower(a.type) < string.lower(b.type)
end

--recipes need to be sorted by type
minetest.register_on_mods_loaded(function()
	for item, subtable in pairs(qts.crafts) do
		table.sort(subtable, craft_sorter)
	end
end)

--Execute fallback.lua
--this is where minetest-style crafts are re-registered
dofile(qts.path.."/crafting/fallback.lua")