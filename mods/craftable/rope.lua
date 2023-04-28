--[[
    Rope and Chains
]]

local function rope_place(itemstack, placer, pointed_thing)
    local node = minetest.get_node_or_nil(pointed_thing.under)
    if node and minetest.get_item_group(node.name, "rope") ~= 0 then
        local p = vector.new(pointed_thing.under)
        while true do
            p.y = p.y-1
            local n = minetest.get_node_or_nil(p)
            if not n then break end
            if minetest.get_item_group(n.name, "rope") == 0 then
                local def = minetest.registered_nodes[n.name]
                if not def then break end
                if def.buildable_to or n.name == "air" then
                    local pt = {type="node", under=p:copy(), above=pointed_thing.above:copy()}
                    return minetest.item_place(itemstack, placer, pt)
                else
                    break
                end
            end
        end
    end
    return minetest.item_place(itemstack, placer, pointed_thing)
end

minetest.register_node("craftable:rope", {
	description = "Rope",
	tiles = {"default_rope.png"},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1, rope=1},
	node_box = {
		type = "fixed",
		fixed = {-1/16, -8/16, -1/16, 1/16, 8/16, 1/16,},
	},
	connects_to = {"group:rope"},
	sounds = qtcore.node_sound_wood(),
    walkable = false,
	climbable = true,
    on_place = rope_place,
})

local function chain_nodebox()
    return {
		type = "fixed",
		fixed = {
            { -2/32, -16/32, -1/32, 2/32, -15/32, 1/32, },
            { -1/32, -16/32, -2/32, 1/32, -10/32, -1/32, },
            { -1/32, -16/32, 1/32, 1/32, -10/32, 2/32, },
            { -2/32, -12/32, -1/32, 2/32, -10/32, 1/32, },
            { -2/32, -10/32, -1/32, -1/32, -5/32, 1/32, },
            { 1/32, -10/32, -1/32, 2/32, -5/32, 1/32, },
            { -1/32, -7/32, -2/32, 1/32, -5/32, 2/32, },
            { -1/32, -5/32, -2/32, 1/32, 0/32, -1/32, },
            { -1/32, -5/32, 1/32, 1/32, 1/32, 2/32, },
            { -2/32, -1/32, -1/32, 2/32, 1/32, 1/32, },
            { 1/32, 1/32, -1/32, 2/32, 6/32, 1/32, },
            { -2/32, 1/32, -1/32, -1/32, 6/32, 1/32, },
            { -1/32, 4/32, -2/32, 1/32, 6/32, 2/32, },
            { -1/32, 6/32, 1/32, 1/32, 12/32, 2/32, },
            { -1/32, 6/32, -2/32, 1/32, 12/32, -1/32, },
            { -2/32, 10/32, -1/32, 2/32, 12/32, 1/32, },
            { -2/32, 12/32, -1/32, -1/32, 16/32, 1/32, },
            { 1/32, 12/32, -1/32, 2/32, 16/32, 1/32, },
            { -1/32, 15/32, -2/32, 1/32, 16/32, 2/32, },
        }
	}
end

minetest.register_node("craftable:chain_copper", {
	description = "Copper Chain",
	tiles = {"default_copper_ingot_stack.png"},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1, rope=1},
	node_box = chain_nodebox(),
	connects_to = {"group:rope"},
	sounds = qtcore.node_sound_metal(),
    walkable = false,
	climbable = true,
    on_place = rope_place,
})

minetest.register_node("craftable:chain_bronze", {
	description = "Bronze Chain",
	tiles = {"default_bronze_ingot_stack.png"},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1, rope=1},
	node_box = chain_nodebox(),
	connects_to = {"group:rope"},
	sounds = qtcore.node_sound_metal(),
    walkable = false,
	climbable = true,
    on_place = rope_place,
})

minetest.register_node("craftable:chain_iron", {
	description = "Iron Chain",
	tiles = {"default_iron_ingot_stack.png"},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1, rope=1},
	node_box = chain_nodebox(),
	connects_to = {"group:rope"},
	sounds = qtcore.node_sound_metal(),
    walkable = false,
	climbable = true,
    on_place = rope_place,
})

minetest.register_node("craftable:chain_steel", {
	description = "Steel Chain",
	tiles = {"default_steel_ingot_stack.png"},
	use_texture_alpha="clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {oddly_breakable_by_hand=3, generation_artificial=1, rope=1},
	node_box = chain_nodebox(),
	connects_to = {"group:rope"},
	sounds = qtcore.node_sound_metal(),
    walkable = false,
	climbable = true,
    on_place = rope_place,
})

qts.register_craft({
	ingredients = {"default:herb_flax 1"},
	results = {"craftable:rope"},
})

qts.register_craft({
	ingredients = {"overworld:copper_bar 1"},
	results = {"craftable:chain_copper"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:bronze_bar 1"},
	results = {"craftable:chain_bronze"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"overworld:iron_bar 1"},
	results = {"craftable:chain_iron"},
	near = {"group:furnace", "craftable:anvil"},
})

qts.register_craft({
	ingredients = {"overworld:steel_bar 1"},
	results = {"craftable:chain_steel"},
	near = {"group:furnace", "craftable:anvil"},
})
