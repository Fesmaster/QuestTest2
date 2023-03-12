--[[
This file defines custom Mintest Engine version variables. When these are true, certain commits from Fesmaster's dev branch should be compiled into the engine.

These should all be in the format of:
ENGINE_VERSION_COMMIT_LIKE_TEXT_HERE
]]

--[[
    a fix for formspec models camera orbit point changing
    PR: https://github.com/minetest/minetest/pull/13312
    branch: https://github.com/Fesmaster/minetest/tree/modelformspecfix
]]
ENGINE_VERSION_FORMSPEC_MODEL_FIX = false;