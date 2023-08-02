--[[
    Watermark.
    This file creates the QT2 Watermark in the 
]]

local watermark = [[

________                          __ ___________              __  ________  
\_____  \  __ __   ____   _______/  |\__    ___/___   _______/  |_\_____  \ 
 /  / \  \|  |  \_/ __ \ /  ___/\   __\|    |_/ __ \ /  ___/\   __\/  ____/ 
/   \_/.  \  |  /\  ___/ \___ \  |  |  |    |\  ___/ \___ \  |  | /       \ 
\_____\ \_/____/  \___  >____  > |__|  |____| \___  >____  > |__| \_______ \
       \__>           \/     \/                   \/     \/               \/
]]

local copyright = [[
    Copyright (c) 2023 QuestTest2 Developers.
    QuestTest2 is primarily licensed under the MIT license, and exceptions apply for specific files. Please see the LICENSE file for more details.
]]

minetest.log(watermark .. copyright)
minetest.log("QTS Version "..qts.version.major.."."..qts.version.minor.."."..qts.version.patch)
minetest.log("Loading lua version: " .. _VERSION)

--attempt to get GIT info.
if qts_internal.insecure then
    
    --execute a terminal command from code
    local function ExecuteCommand(cmd)
        local handle = qts_internal.insecure.io.popen(cmd)
        if (handle) then
            local output = handle:read('*a')
            local filtered = output:gsub('[\n\r]', ' ')
            handle:close()
            return filtered
        end
        return ""
    end

    --stupid, easily breakable environment checking to differencitate Windows and UNIX-Like systems (Mac and Linux)
    local function IsUnix()
        local home = ExecuteCommand("echo $HOME")
        return not (home:gmatch("$HOME"))
    end


    local pwd = "pwd"
    if not IsUnix() then
        pwd = "echo %cd%"
        minetest.log("Testing OS: Windows detected")
    else
        minetest.log("Testing OS: UNIX-like OS detected (MacOS or Linux)")
    end

    minetest.log("Working Directory (" .. pwd .. ") : " .. ExecuteCommand(pwd))
    
    --get the last git log entry
    local git_check = ExecuteCommand("git log -n 1 --color=never")
    local commit_present = false
    for commit in git_check:gmatch("commit%s[%da-f]+") do
        minetest.log("Git " .. commit)
        commit_present = true
    end
    if not commit_present then
        minetest.log("Git: integration failed.")
    end
end
