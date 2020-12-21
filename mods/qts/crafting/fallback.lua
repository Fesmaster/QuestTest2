--re-register all minetest-style crafts as QuestTest crafts

local L_register_craft = minetest.register_craft

local function convert_name_count(tbl)
	local r = {}
	for k, v in pairs(tbl) do
		local IS = ItemStack(k)
		IS:set_count(v)
		r[#r+1] = IS:to_string()
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
		near[1] = "group:furnace"
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
	qts.register_craft({
		ingredients = convert_name_count(ing),
		near  = near,
		held  = {},
		results = res,
		type = "fallback_" .. ctype
	})
end