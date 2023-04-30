--[[
    Wood-only furnature
]]

local table_nodeboxes = dofile(minetest.get_modpath("furnature").."/nodeboxes/table.lua")
local chair_nodeboxes = dofile(minetest.get_modpath("furnature").."/nodeboxes/chair.lua")

qtcore.for_all_materials("wood", function (fields)
    if fields.name and fields.desc and fields.planks then

        --crate
        do
            fields.crate = "furnature:crate_"..fields.name
            local crate_texture = "default_crate_"..fields.name..".png"
            local crate_desc = fields.desc.." Wood Crate"
            if fields.class == "mushroom" then
                crate_desc = fields.desc.." Crate"
            end

            qts.register_chest(":"..fields.crate, {
                description = crate_desc,
                tiles = {crate_texture},
                groups = {choppy = 2, oddly_breakable_by_hand = 2, generation_artificial=1, bandit_waypoint=1},
                is_ground_content = false,
                sounds = qtcore.node_sound_wood(),
                invsize = 10*4,
                get_chest_formspec = qtcore.get_default_chest_formspec,
            })

            qts.register_craft({
                ingredients = {fields.planks.." 4"},
                results = {fields.crate},
                near = {"group:workbench"},
            })
        end


        if fields.plank_texture then
            
            --table
            do
                fields.table = "furnature:table_"..fields.name
                local nodebox = table_nodeboxes[fields.name]
                if nodebox == nil then
                    nodebox = table_nodeboxes["_default_"]
                    minetest.log("warning", "[Furnature] Unable to find custom table nodebox for: " .. fields.name)
                end

                minetest.register_node(":"..fields.table, {
                    description = fields.desc.. " Table",
                    tiles = {fields.plank_texture},
                    drawtype = "nodebox",
                    paramtype = "light",
                    paramtype2 = "facedir",
                    groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, table=1, generation_artificial=1},
                    node_box = nodebox,
                    sounds = qtcore.node_sound_wood(),
                })

                qts.register_craft({
                    ingredients = {fields.planks},
                    results = {fields.table},
                    near = {"group:workbench"},
                })
            end

            --chair
            do
                fields.chair = "furnature:chair_"..fields.name
                local nodebox = chair_nodeboxes[fields.name]
                if nodebox == nil then
                    nodebox = chair_nodeboxes["_default_"]
                    minetest.log("warning", "[Furnature] Unable to find custom chair nodebox for: " .. fields.name)
                end

                minetest.register_node(":"..fields.chair, {
                    description = fields.desc.." Chair",
                    tiles = {fields.plank_texture},
                    drawtype = "nodebox",
                    paramtype = "light",
                    paramtype2 = "facedir",
                    groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, chair=1, generation_artificial=1},
                    node_box = nodebox,
                    sounds = qtcore.node_sound_wood(),
                })

                qts.register_craft({
                    ingredients = {fields.planks},
                    results = {fields.chair.." 2"},
                    near = {"group:workbench"},
                })
            end

            --bookshelf
            do
                fields.bookshelf = "furnature:bookshelf_"..fields.name
                minetest.register_node (":"..fields.bookshelf, {
                    description = fields.desc.." Bookshelf",
                    drawtype="nodebox",
                    paramtype = "light",
                    tiles = {{name = fields.plank_texture, align_style = "node"}, {name = fields.plank_texture, align_style = "node"}, 
                    fields.plank_texture, fields.plank_texture, fields.plank_texture.."^default_bookshelf.png", fields.plank_texture.."^default_bookshelf.png"},
                    paramtype2 = "facedir",
                    groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, bookshelf=1, generation_artificial=1},
                    sounds = qtcore.node_sound_wood(),
                    node_box = {
                        type = "fixed",
                        fixed = {
                            { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16, },
                            { -8/16, 7/16, -8/16, 8/16, 8/16, 8/16, },
                            { 7/16, -7/16, -8/16, 8/16, 7/16, 8/16, },
                            { -8/16, -7/16, -8/16, -7/16, 7/16, 8/16, },
                            { -7/16, -7/16, -6/16, 7/16, 7/16, 6/16, },
                            { -7/16, -1/16, -8/16, 7/16, 1/16, 8/16, },
                        },
                    },
                    selection_box = {
                        type = "fixed",
                        fixed = {
                            { -8/16, -8/16, -8/16, 8/16, 8/16, 8/16, },
                        }
                    },
                })

                qts.register_craft({
                    ingredients = {fields.planks, "craftable:book 3"},
                    results = {fields.bookshelf},
                    near = {"group:workbench"},
                })
            end


            --ladders
            do
                fields.ladder = "furnature:ladder_"..fields.name

                minetest.register_node(":"..fields.ladder, {
                    description = fields.desc.." Ladder",
                    tiles ={fields.plank_texture},
                    drawtype = "nodebox",
                    paramtype = "light",
                    paramtype2 = "wallmounted",
                    walkable = true,
                    climbable = true,
                    groups = {oddly_breakable_by_hand=3, choppy=2, flammable=2, ladder=1, generation_artificial=1},
                    node_box = {
                        type="fixed",
                        fixed = {
                            {-0.5, -0.4375, -0.375, 0.5, -0.375, -0.3125}, -- NodeBox8
                            {-0.5, -0.4375, -0.125, 0.5, -0.375, -0.0625}, -- NodeBox9
                            {-0.375, -0.5, -0.5, -0.3125, -0.4375, 0.5}, -- NodeBox10
                            {0.3125, -0.5, -0.5, 0.375, -0.4375, 0.5}, -- NodeBox13
                            {-0.5, -0.4375, 0.125, 0.5, -0.375, 0.1875}, -- NodeBox14
                            {-0.5, -0.4375, 0.375, 0.5, -0.375, 0.4375}, -- NodeBox15
                        }
                    },
                    selection_box = {
                        type="fixed",
                        fixed = {
                            {-0.5, -0.5, -0.5, 0.5, -0.375000, 0.5}
                        },
                    },
                    collision_box = {
                        type="fixed",
                        fixed = {
                            {-0.5, -0.5, -0.5, 0.5, -0.375000, 0.5}
                        },
                    },
                    sounds = qtcore.node_sound_wood(),
                    on_place = function(itemstack, placer, pointed_thing)
                        if (pointed_thing.under ~= nil) then
                            local node = minetest.get_node_or_nil(pointed_thing.under)
                            if node and node.name and minetest.get_item_group(node.name, "ladder") ~= 0 then
                                --place with same rotation as under
                                return minetest.item_place(itemstack, placer, pointed_thing, minetest.get_node(pointed_thing.under).param2)
                            end
                        end
                        return minetest.item_place(itemstack, placer, pointed_thing)
                    end,
                })

                qts.register_craft({
                    ingredients = {fields.planks},
                    results = {fields.ladder.." 8"},
                })
            end

        end

    end
end)