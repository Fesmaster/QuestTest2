

stonecutter = {}

stonecutter.stoneTypes = {}
--[[
name = group name, used for storage, etc
nodenames = {}
	indexed table of all the nodes in the type

Note: if another type of the same name is found, a warning is issued, but registration proceeds
This will be OK if some items are duplicates
--]]
function stonecutter.register_stonetype(name, nodenames)
	if stonecutter.stoneTypes[name] then
		minetest.log("warning", "Warning: Stonecutter: Duplicate Registration of type: "..name)
	else
		stonecutter.stoneTypes[name] = {}
	end
	--store them as a set! This way, no duplicates!
	for k, nname in ipairs(nodenames) do
		stonecutter.stoneTypes[name][nname] = true
	end
end

--[[
nodename - a valid nodename
this will return the typename of its stone type, or nil if it is not in any of them 
--]]
function stonecutter.get_type(nodename)
	for typename, blocks in pairs(stonecutter.stoneTypes) do
		if blocks[nodename] then --see why we use sets? ONLY ONE LOOP FOR SEARCHING A 2D LIST!!! WOOOOO!!!
			return typename
		end
	end
	return nil
end

--[[
FOR LOOP ITERATOR!!!!!!!!!!!!!!!!!!!
Loops over ALL the nodenames that have been registered as part of a type
--]]
function stonecutter.stones()
	local co = coroutine.create(function () 
		for typename, subtable in pairs(stonecutter.stoneTypes) do
			for nodename, _ in pairs(subtable) do
				coroutine.yield(nodename)
			end
		end
		coroutine.yield(nil)
	end)
	return function()
		local code, res = coroutine.resume(co)
		return res
	end
end

