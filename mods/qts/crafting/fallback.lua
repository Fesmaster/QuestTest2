--re-register all minetest-style crafts as QuestTest crafts

local L_register_craft = minetest.register_craft

local function convert_name_count(tbl)
	local r = {}
	for k, v in pairs(tbl) do
		if k ~= "" then
			local IS = ItemStack(k)
			IS:set_count(v)
			r[#r+1] = IS:to_string()
		end
	end
	return r
end

minetest.register_craft = function(t)
	if type(t) ~= "table" then error("Invalid craft recipe") end
	L_register_craft(t)
	
	local ing = {}
	local res = {}
	local near = {}
	local ctype = t.type or "shaped"
	local refOnly = false
	if ctype == 'shaped' then
		for k1, st in ipairs(t.recipe) do
			for k, v in ipairs(st) do
				if ing[v] then 
					ing[v] = ing[v] + 1 
				else
					ing[v]=1
				end
			end
		end
	elseif ctype == "shapeless" then
		for k, v in ipairs(t.recipe) do
			if ing[v] then 
				ing[v] = ing[v] + 1 
			else
				ing[v]=1
			end
		end
	elseif ctype == "cooking" then
		ing[t.recipe]=1
		ing["group:furnace"] = 1
		refOnly = true
	else
		return --these are not passed on
	end
	
	res[1] = t.output
	if t.replacements then
		for k, v in pairs(t.replacements) do
			res[#res+1]=v
		end
	end
	--collect inputs
	if refOnly then
		qts.register_reference_craft({
			ingredients = convert_name_count(ing),
			results = res,
			description = "Smelting in a furnace. Requires fuel. Alternatively, you can use a campfire."
		})
	else
		qts.register_craft({
			ingredients = convert_name_count(ing),
			near  = near,
			held  = {},
			results = res,
			type = "fallback_" .. ctype
		})
	end
end

--[[
Make sure all registered nodes that have custom drops (except shaped nodes)
register a reference recipe for their drops
--]]

local L_register_node = minetest.register_node

function minetest.register_node(nodename, def)
	if def.groups and def.groups.shaped_node and def.groups.shaped_full == nil then
		return L_register_node(nodename, def)
	end

	local simplename = nodename
	if string.sub(simplename, 1, 1) == ":" then
		simplename = string.sub(simplename, 2)
	end
	if def.drop and def.drop ~= "" and def.drop ~= simplename then
		local ing = {simplename}
		local res = {}
		if type(def.drop) == "string" then
			local stack = ItemStack(def.drop)
			local name = stack:get_name()
			res[name] = stack:get_count()
		else
			for _, v in ipairs(def.drop.items) do
				for __, itemstring in ipairs(v.items) do
					local stack = ItemStack(itemstring)
					local name = stack:get_name()
						if res[name] then
							res[name] = res[name] + stack:get_count()
						else
							res[name] = stack:get_count()
						end
				end
			end
		end
		qts.register_reference_craft({
			ingredients = ing,
			results = convert_name_count(res),
			description = "Dropped Items"
		})
	end
	return L_register_node(nodename, def)
end


--[[
Ores get their own reference recipe, showing where they are found and at what concentration
--]]
local L_register_ore = minetest.register_ore

function minetest.register_ore(def)
	local desc = "Ore Generation. Type = \""..(def.ore_type or "?").."\" Y=[" .. (def.y_min or "?") .. ", " .. (def.y_max  or "?").. "]\n"
	if def.clust_scarcity then
		local n = math.ceil(def.clust_scarcity^1/3)
		desc = desc .. "Cluster Scarcity: " .. n .. "x".. n .. "x" .. n .. ". "
	end
	if def.clust_num_ores then
		desc = desc .. "Number of Ores: " .. def.clust_num_ores .. ". "
	end
	if def.clust_size then
		desc = desc .. "Cluster Size: " .. def.clust_size .. "x" .. def.clust_size .. "x" .. def.clust_size .. ". "
	end

	local ing = {def.ore}
	if type(def.wherein) == "string" then
		ing[#ing+1] = def.wherein
	else
		for i, k in ipairs(def.wherein) do
			ing[#ing+1] = k
		end
	end
	qts.register_reference_craft({
		ingredients = ing,
		results = {def.ore},
		description = desc
	})
	L_register_ore(def)
end
