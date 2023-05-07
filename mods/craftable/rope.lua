--[[
    Rope and Chains
]]

--[[
	This function is compatable with the node callback 'on_place'
	Its job is to do the whole "place at the bottom" thing that
	ropes and chains do. It is half of the rope equation, the other half being the 
]]
---@param itemstack ItemStack
---@param placer Player
---@param pointed_thing PointedThing
---@return boolean|nil iten_remains true if no item taken from stack
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

--[[
	Basic Rope
]]
minetest.register_node("craftable:rope", {
	description = "Rope",
	tiles = {"craftable_rope.png"},
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

qts.register_craft({
	ingredients = {"farmworks:herb_flax 1"},
	results = {"craftable:rope"},
})

local chain_nodebox = {
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

--[[
	Metal Chains.
	This will automatically register a chain for all utility metals.
]]
qtcore.for_all_materials("metal", function (fields)
	--[[
		Remember to *always* check for the fields you need
		There can be any fields (or even none) passed, 
		in any format.
	]]
	if fields.name
		and fields.desc
		and fields.ingot
		and fields.ingot_image
		and fields.utility_metal
		and fields.craft_groups
	then
		
		--[[
			register the chain itself
			Note the leading ":" on the chain name. This is for when this
			function is called from a mode that is not 'craftable', and allows
			us to bypass the naming restrictions.
		]]
		minetest.register_node(":craftable:chain_"..fields.name, {
			description = fields.desc.." Chain",
			tiles = {fields.ingot_image},
			use_texture_alpha="clip",
			drawtype = "nodebox",
			paramtype = "light",
			groups = {oddly_breakable_by_hand=3, generation_artificial=1, rope=1},
			node_box = chain_nodebox,
			connects_to = {"group:rope"},
			sounds = qtcore.node_sound_metal(),
			walkable = false,
			climbable = true,
			on_place = rope_place,
		})

		--[[
			register the crafting recipe
			note the lack of the leading ":" on the chain name
			this is an item name, and that will break things.
		]]
		qts.register_craft({
			ingredients = {fields.ingot.." 1"},
			results = {"craftable:chain_"..fields.name},
			near = fields.craft_groups,
		})
	end
end)

