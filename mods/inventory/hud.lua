--[[
    Hud-related functions
--]]

local hud_ids = {}
local HUDBAR_FULL_VALUE = 72


function inventory.refresh_hud(player)
    minetest.log("here")
    local pname =player:get_player_name() 
    if hud_ids[pname] == nil then
        hud_ids[pname] = {}
    end
    local hud_table = hud_ids[pname]
    
    if hud_table.healthbar then
        player:hud_change(hud_table.healthbar, "number", qts.get_player_hp(player)/qts.get_player_hp_max(player) * HUDBAR_FULL_VALUE)    
    else
        hud_table.healthbar = player:hud_add({
            hud_elem_type = "statbar",
            position = {x=0.5, y=1},
            name = "healthbar",
            text = "inventory_healthbar_full.png", --main texture
            text2 = "inventory_healthbar_empty.png", --background texture
            number = qts.get_player_hp(player)/qts.get_player_hp_max(player) * HUDBAR_FULL_VALUE, --percentage of bar to keep visible
            item = HUDBAR_FULL_VALUE,
            offset = {x=-256-32+2, y=-64-18},
            size = { x=8, y=16 },
            z_index = 0,
        })
    end

end

minetest.register_on_player_hpchange(function(player, hp_change, reason)
    inventory.refresh_hud(player)
end, false)