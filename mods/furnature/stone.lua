--[[
    Stone Furnature
]]


qtcore.for_all_materials("stone", function(fields)
    if fields.name and fields.desc and fields.base_img and fields.craft_group then
        
        minetest.register_node(":furnature:obelisk_"..fields.name, {
            description = fields.desc.." Obelisk",
            tiles = {fields.base_img},
            drawtype="nodebox",
            paramtype2="color",
            paramtype="light",
            node_box = {
                type = "fixed",
		        fixed = {
                    { -3/16, -8/16, -3/16, 3/16, 8/16, 3/16, },
                    { -2/16, 8/16, -2/16, 2/16, 14/16, 2/16, },
                    { -1/16, 14/16, -1/16, 1/16, 17/16, 1/16, },
                    { -2/16, 14/16, -2/16, -1/16, 17/16, -1/16, },
                    { 1/16, 14/16, 1/16, 2/16, 17/16, 2/16, },
                    { 1/16, 14/16, -2/16, 2/16, 17/16, -1/16, },
                    { -2/16, 14/16, 1/16, -1/16, 17/16, 2/16, },
                    { -2/16, 17/16, -2/16, 2/16, 20/16, 2/16, },
                    { -1/16, 20/16, -1/16, 1/16, 23/16, 1/16, },
                }
            },
            selection_box = {
                type="fixed",
                fixed={
                    { -3/16, -8/16, -3/16, 3/16, 23/16, 3/16, },
                }
            },
            groups={cracky=3, obelist=1, generation_artificial=1},
            on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                if clicker and clicker:is_player() then
                    qts.set_player_spawnpoint(clicker--[[@as Player]], clicker:get_pos())
                    minetest.chat_send_player(clicker--[[@as Player]]:get_player_name(), "Spawnpoint Set!")
                end
            end,
            is_ground_content = false,
            palette = "qt_palette_paint_light.png",
        })

        qts.register_craft({
            ingredients={"group:"..fields.craft_group},
            results={"furnature:obelisk_"..fields.name},
            near={"group:workbench_heavy"},
        })

    end
end)