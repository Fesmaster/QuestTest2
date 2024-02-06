--[[
    This file contains furnature that has a form for each wood cross each metal. Thats a LOT of items.
]]



qtcore.for_all_materials("wood", function (fields_wood)
    if fields_wood.name and fields_wood.desc and fields_wood.planks and fields_wood.plank_texture then
        
        qtcore.for_all_materials("metal", function (fields_metal)
            if fields_metal.name and fields_metal.desc and fields_metal.ingot and fields_metal.utility_metal and fields_metal.craft_groups then

                --chest
                do
                    local chestname = "furnature:chest_"..fields_wood.name.."_"..fields_metal.name
                    qts.register_chest(":"..chestname, {
                        description = fields_wood.desc.." and " .. fields_metal.desc .." Chest",
                        tiles = {
                            fields_wood.plank_texture.."^furnature_chest_"..fields_metal.name.."_top_overlay.png",
                            fields_wood.plank_texture.."^furnature_chest_"..fields_metal.name.."_top_overlay.png",
                            fields_wood.plank_texture.."^furnature_chest_"..fields_metal.name.."_side_overlay.png",
                            fields_wood.plank_texture.."^furnature_chest_"..fields_metal.name.."_side_overlay.png",
                            fields_wood.plank_texture.."^furnature_chest_"..fields_metal.name.."_back_overlay.png",
                            fields_wood.plank_texture.."^furnature_chest_"..fields_metal.name.."_front_overlay.png"

                        },
                        groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
                        drawtype = "nodebox",
                        paramtype = "light",
                        paramtype2 = "facedir",
                        node_box = {
                        type = "fixed",
                        fixed = {
                            { -8/16, -8/16, -5/16, 8/16, 0/16, 5/16, },
                            { -8/16, -8/16, -4/16, 8/16, 1/16, 4/16, },
                            { -8/16, -8/16, -3/16, 8/16, 2/16, 3/16, },
                            { -6/16, 1/16, -4/16, -4/16, 2/16, 4/16, },
                            { 4/16, 1/16, -4/16, 6/16, 2/16, 4/16, },
                            { 4/16, 0/16, -5/16, 6/16, 1/16, 5/16, },
                            { -6/16, 0/16, -5/16, -4/16, 1/16, 5/16, },
                            { 4/16, 2/16, -3/16, 6/16, 3/16, 3/16, },
                            { -6/16, 2/16, -3/16, -4/16, 3/16, 3/16, },
                            { -6/16, -8/16, -6/16, -4/16, 0/16, 6/16, },
                            { 4/16, -8/16, -6/16, 6/16, 0/16, 6/16, },
                            { -1/16, -4/16, -6/16, 1/16, -1/16, -5/16, },
                            },
                            },
                        selection_box = {
                            type = "fixed",
                            fixed = {
                                { -8/16, -8/16, -6/16, 8/16, 3/16, 6/16, },
                            },
                        },
                        is_ground_content = false,
                        sounds = qtcore.node_sound_wood(),
                        
                        invsize = 8*4,
                        get_chest_formspec = qtcore.get_default_chest_formspec,
                    })

                    qts.register_craft({
                        ingredients = {fields_wood.planks, fields_metal.ingot.." 2"},
                        results = {chestname},
                        near = fields_metal.craft_groups,
                    })
                end

                --door
                do
                    local doorname  ="furnature:door_"..fields_wood.name.."_"..fields_metal.name
                    qts.register_door(":"..doorname, {
                        description = fields_wood.desc.." and "..fields_metal.desc.." Door",
                        tiles = {
                            "furnature_door_"..fields_wood.name..".png^furnature_door_"..fields_metal.name.."_overlay.png",
                        },
                        groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
                        sounds = qtcore.node_sound_wood(),
                    })

                    qts.register_craft({
                        ingredients = {fields_wood.planks, fields_metal.ingot.." 2"},
                        results = {doorname},
                        near = fields_metal.craft_groups,
                    })
                end

                --trapdoor
                do
                    local doorname  ="furnature:trapdoor_"..fields_wood.name.."_"..fields_metal.name
                    qts.register_trapdoor(":"..doorname, {
                        description = fields_wood.desc.." and "..fields_metal.desc.." Door",
                        tiles = {
                            fields_wood.plank_texture.."^furnature_trapdoor_"..fields_metal.name.."_overlay.png",
                        },
                        groups = {choppy = 2, oddly_breakable_by_hand = 1, generation_artificial=1},
                        sounds = qtcore.node_sound_wood(),
                    })

                    qts.register_craft({
                        ingredients = {fields_wood.planks, fields_metal.ingot},
                        results = {doorname},
                        near = fields_metal.craft_groups,
                    })
                end

            end
        end)
    end
end)