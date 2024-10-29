--[[
Sandbox worldgen

Sandbox is basically a set of configured worldgen overrides for testing specific things.



--]]

qts.worldgen.SANDBOX_WORLD = qts.config("SANDBOX_WORLD", 0, [[Sandbox world generation setting.
0 - default worldgen
1 - singlenode air
2 - flat default node]])

local SANDBOX_MODE = {
    NONE = 0,
    SINGLENODE = 1,
    FLAT = 2,
}

local CID = qts.worldgen.CID --to simplify and shorten the naming

function qts.worldgen.sandbox(minp, maxp, blockseed)
    local VM, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local Area = VoxelArea:new{MinEdge = {x = emin.x, y = emin.y, z = emin.z}, MaxEdge = {x = emax.x, y = emax.y, z = emax.z}}
	local Data= VM:get_data()
    local mode = qts.worldgen.SANDBOX_WORLD.get()

    for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			for y = maxp.y, minp.y, -1 do
                local i = Area:index(x, y, z)
                if (mode == SANDBOX_MODE.SINGLENODE) then
                    Data[i] = CID["air"]
                elseif (mode == SANDBOX_MODE.FLAT) then
                    if y > 0 then
                        Data[i] = CID["air"]
                    else
                        Data[i] = CID["default"]
                    end
                end
            end
		end
	end

    VM:set_data(Data)	
	VM:calc_lighting()
	VM:write_to_map()
end