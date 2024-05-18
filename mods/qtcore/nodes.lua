--[[
    QTCore nodes

    Most of these are for debugging
]]

--Ancient default node, the first made in QuestTest2
minetest.register_node(":default:default", {
	description = "Default Node",
	tiles ={"default.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = qtcore.node_sound_defaults(),
})

minetest.override_item("air", {
	groups={not_in_creative_inventory = 1, generation_replacable=1}
})

if (qts.ISDEV) then

for color, code in pairs(qtcore.colors) do

    qts.register_shaped_node("qtcore:color_"..color, {
    	description = "Debug Color "..color,
    	tiles ={"White.png"},
        color=code,
    	groups = {oddly_breakable_by_hand=3},
    	sounds = qtcore.node_sound_defaults(),
    })
end

end