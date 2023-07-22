--[[
This file deals with versioning both of QuestTest, and custom version of the Minetest Engine.

qts.version holds the game version.

For custom engine versions, these are related to Fesmaster's dev branch.

Custom Engine Verisons should all be in the format of:
ENGINE_VERSION_COMMIT_LIKE_TEXT_HERE
]]

--QTS VERSION - REMEMBER TO UPDATE FOR EACH RELEASE!
qts.version = {
    major=0,
    minor=1,
    patch=0,
}

local function parseVersionString(str)
    local ints = string.split(str, ".", false, 2, false);
    local vals = {
        major = 0, minor=0,patch=0,
    }
    if (ints) then
        if (type(ints[1]) == "string") then
            vals.major = tonumber(ints[1])
            if vals.major == nil then vals.major = 0 end
        end

        if (type(ints[2]) == "string") then
            vals.minor = tonumber(ints[2])
            if vals.minor == nil then vals.minor = 0 end
        end

        if (type(ints[3]) == "string") then
            vals.patch = tonumber(ints[3])
            if vals.patch == nil then vals.patch = 0 end
        end
    end
    return vals
end

---Check if QTS is at least the veriion provided in versionstring
---@param versionstring string format "<major>.<minor>.<patch>"
function qts.is_version(versionstring)
    local testv = parseVersionString(versionstring)
    if testv.major < qts.version.major then 
        return true
    elseif testv.major == qts.version.major then
        if testv.minor < qts.version.minor then 
            return true
        elseif testv.minor == qts.version.minor then
            if testv.patch <= qts.version.patch then 
                return true
            end
        end
    end
    return false
end

--[[############$$###########################################
                CUSTOM ENGINE VERSIONS BELOW
#################$$##########################################]]

--[[
    a fix for formspec models camera orbit point changing
    PR: https://github.com/minetest/minetest/pull/13312
    branch: https://github.com/Fesmaster/minetest/tree/modelformspecfix
]]
ENGINE_VERSION_FORMSPEC_MODEL_FIX = false;