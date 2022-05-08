--[[
QuestTest Development Tools

This mod does nothing outside of dev mode
It mod contains tools and the like used to 
make and analize during QuestTest development
]]

if qts.ISDEV then
dtools = {}
local path = minetest.get_modpath("dtools")

local insecure = minetest.request_insecure_environment()
if insecure then
    function dtools.writeToFile(filename, data, binary)
        local writeOption = "w"
        if binary then writeOption = "wb" end
        local file = insecure.io.open(minetest.get_worldpath()..filename, writeOption) --open in write binary mode
		if file == nil then 
			minetest.log("An error occured opening the output file.")
			return
		end
		file:write(data)
		file:flush()
		file:close()
    end
else
    function dtools.writeToFile(filename, data)
        minetest.log("No Insecure enviroment. If you really need this, add 'dtools' to the list of trusted mods in advanced settings")
    end

end 

dofile(path.."/chatcommands.lua")
dofile(path.."/tools.lua")
dofile(path.."/schematics.lua")

dofile(path.."/other.lua")
end