--[[
    QTS Pentool:

    QTS Pentool is a turtle graphics like system for generating game structures.

    It is designed to overcome the limitations of Minetest's L-system trees.

    As a rule, Pentool writes to a node when its position *enters* that node.
    If a pentool is at {0,0,0} and moves 5 blocks up, it will not change the node at {0,0,0}
]]


qts.pentool = {}


dofile(qts.path.."/pentool/brush.lua")
dofile(qts.path.."/pentool/context.lua")