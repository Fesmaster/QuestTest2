--[[
    This file contains armor for each utility metal.
]]



qtcore.for_all_materials("metal", function (fields_metal)
    if fields_metal.name and fields_metal.desc and fields_metal.ingot and fields_metal.utility_metal and fields_metal.craft_groups then
        do
            local helmetname = "craftable:helmet_"..fields_metal.name
            minetest.register_craftitem(helmetname, {
                description = fields_metal.desc .." Helmet",
                inventory_image = "craftable_armor_"..fields_metal.name.."_helmet_item.png",
                armor_image = "craftable_armor_"..fields_metal.name.."_helmet.png",
                groups = {helmet=1,},
                stack_max=1,
                armor_groups = {fleshy=5},
            })       

            qts.register_craft({
                ingredients = {fields_metal.ingot.." 4"},
                results = {helmetname},
                near = fields_metal.craft_groups,
            })
       end

       do
        local cuirassname = "craftable:cuirass_"..fields_metal.name
        minetest.register_craftitem(cuirassname, {
            description = fields_metal.desc .." Cuirass",
            inventory_image = "craftable_armor_"..fields_metal.name.."_cuirass_item.png",
            armor_image = "craftable_armor_"..fields_metal.name.."_cuirass.png",
            groups = {cuirass=1,},
            stack_max=1,
            armor_groups = {fleshy=15},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 12"},
            results = {cuirassname},
            near = fields_metal.craft_groups,
        })
       end


       do
        local mailname = "craftable:mail_"..fields_metal.name
        minetest.register_craftitem(mailname, {
            description = fields_metal.desc .." Mail",
            inventory_image = "craftable_armor_"..fields_metal.name.."_mail_item.png",
            armor_image = "craftable_armor_"..fields_metal.name.."_mail.png",
            groups = {cuirass=1,},
            stack_max=1,
            armor_groups = {fleshy=15},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 8"},
            results = {cuirassname},
            near = fields_metal.craft_groups,
        })
       end

       do
        local glovesname = "craftable:gloves_"..fields_metal.name
        minetest.register_craftitem(glovesname, {
            description = fields_metal.desc .." Gloves",
            inventory_image = "craftable_armor_"..fields_metal.name.."_gloves_item.png",
            armor_image = "craftable_armor_"..fields_metal.name.."_gloves.png",
            groups = {gloves=1,},
            stack_max=1,
            armor_groups = {fleshy=2},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 2"},
            results = {glovesname},
            near = fields_metal.craft_groups,
        })
       end

       do
        local bootsname = "craftable:boots_"..fields_metal.name
        minetest.register_craftitem(bootsname, {
            description = fields_metal.desc .." Boots",
            inventory_image = "craftable_armor_"..fields_metal.name.."_boots_item.png",
            armor_image = "craftable_armor_"..fields_metal.name.."_boots.png",
            groups = {boots=1,},
            stack_max=1,
            armor_groups = {fleshy=2},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 4"},
            results = {bootsname},
            near = fields_metal.craft_groups,
        })
       end

       do
        local shieldname = "craftable:sheild_"..fields_metal.name
        minetest.register_craftitem(shieldname, {
            description = fields_metal.desc .." Shield",
            inventory_image = "craftable_armor_"..fields_metal.name.."_sheild_item.png",
            armor_image = "craftable_armor_"..fields_metal.name.."_sheild.png",
            groups = {shield=1,},
            stack_max=1,
            armor_groups = {fleshy=15},
        })

        qts.register_craft({
            ingredients = {fields_metal.ingot.." 2", "group:wood 2"},
            results = {shieldname},
            near = fields_metal.craft_groups,
        })
       end
    end
end)
