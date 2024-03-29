--[[
    Sifter block
    An autocrafting block available early in the game that
    can be used to process grainy items for more drops, mostly flint.
    Frankly, needs more good uses.
]]

local sifter_outs = {}
local sifter_ins = {}

local function launch_drop(pos, itemstack)
	local obj = minetest.add_item(pos, ItemStack(itemstack))
	if obj then
		obj:set_velocity(vector.new(math.random(-1, 1), math.random(3, 5), math.random(-1, 1)))
	else
		minetest.log("error","invalid drop: ".. dump(itemstack))
	end
end

local function sifter_rightclick(pos, node)
    local number = tonumber(string.sub(node.name, -1)) -1
    local basename = string.sub(node.name, 1, -2)
    if number == 0 then
        minetest.set_node(pos, {name="craftable:sifter"})
        --drops
        local def = sifter_outs[basename]
        if def then
            launch_drop(pos, ItemStack(def[math.random(#def)]))
        else   
            minetest.log("Unknown results")
        end
    else
        minetest.set_node(pos, {name = basename..number})
    end
end




minetest.register_node("craftable:sifter", {
    description = "Sifter",
	tiles = {
		"craftable_sifter_top.png", --top
		"craftable_sifter_top.png", --bottom
		"overworld_oak_wood.png" --sides
	},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, sifter=1, generation_artificial=1},
	node_box = {
		type = "fixed",
		fixed = {
            { -8/16, -8/16, -8/16, -6/16, 4/16, -6/16, },
	        { 6/16, -8/16, -8/16, 8/16, 4/16, -6/16, },
	        { 6/16, -8/16, 6/16, 8/16, 4/16, 8/16, },
	        { -8/16, -8/16, 6/16, -6/16, 4/16, 8/16, },
            { -8/16, 4/16, -8/16, -6/16, 6/16, 8/16, },
            { 6/16, 4/16, -8/16, 8/16, 6/16, 8/16, },
            { -6/16, 4/16, -8/16, 6/16, 6/16, -6/16, },
            { -6/16, 4/16, 6/16, 6/16, 6/16, 8/16, },
            { -6/16, 4/16, -6/16, 6/16, 4/16, 6/16, },
        }
	},
    selection_box = {
        type = "fixed",
		fixed = {
            { -8/16, -8/16, -8/16, -6/16, 4/16, -6/16, },
	        { 6/16, -8/16, -8/16, 8/16, 4/16, -6/16, },
	        { 6/16, -8/16, 6/16, 8/16, 4/16, 8/16, },
	        { -8/16, -8/16, 6/16, -6/16, 4/16, 8/16, },
            { -8/16, 4/16, -8/16, 8/16, 6/16, 8/16, },
        }
    },
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if itemstack then      
            if sifter_ins[itemstack:get_name()] then
                minetest.set_node(pos, {name = sifter_ins[itemstack:get_name()]})
                itemstack:take_item()
                return itemstack
            end
        end
    end
})

--[[
def = {
    name = the sifting name
    description = optional, readable name
    tiles = string, texture of sift
    node = string, the in node name
    results = table, possible results
}
]]
local function register_sifter(def)
    for i = 1,6 do
        minetest.register_node("craftable:sifter_"..def.name.."_"..i, {
            description = "Sifter "..(def.description or def.name) .." ".. i,
        	tiles = {
        		"craftable_sifter_top.png^("..def.tiles.."^craftable_sifter_mask_top.png^[makealpha:255,126,126)", --top
        		"craftable_sifter_top.png^("..def.tiles.."^craftable_sifter_mask_top.png^[makealpha:255,126,126)", --bottom
        		"overworld_oak_wood.png^("..def.tiles.."^craftable_sifter_mask_side.png^[makealpha:255,126,126)" --sides
        	},
        	use_texture_alpha = "clip",
        	drawtype = "nodebox",
        	paramtype = "light",
        	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, sifter=1, sifter_full=1, not_in_creative_inventory=1},
            drop = "craftable:sifter",
        	node_box = {
    		type = "fixed",
    		fixed = {
                { -8/16, -8/16, -8/16, -6/16, 4/16, -6/16, },
                { 6/16, -8/16, -8/16, 8/16, 4/16, -6/16, },
                { 6/16, -8/16, 6/16, 8/16, 4/16, 8/16, },
                { -8/16, -8/16, 6/16, -6/16, 4/16, 8/16, },
                { -8/16, 4/16, -8/16, -6/16, 6/16, 8/16, },
                { 6/16, 4/16, -8/16, 8/16, 6/16, 8/16, },
                { -6/16, 4/16, -8/16, 6/16, 6/16, -6/16, },
                { -6/16, 4/16, 6/16, 6/16, 6/16, 8/16, },
                { -6/16, 4/16, -6/16, 6/16, (4+2*i)/16, 6/16, },
            }
        	},
            selection_box = {
            type = "fixed",
    		fixed = {
                { -8/16, -8/16, -8/16, -6/16, 4/16, -6/16, },
    	        { 6/16, -8/16, -8/16, 8/16, 4/16, -6/16, },
    	        { 6/16, -8/16, 6/16, 8/16, 4/16, 8/16, },
    	        { -8/16, -8/16, 6/16, -6/16, 4/16, 8/16, },
                { -8/16, 4/16, -8/16, 8/16, 6/16, 8/16, },
            }
            },

            on_rightclick = sifter_rightclick
        })
    end
    sifter_outs["craftable:sifter_"..def.name.."_"] = def.results
    sifter_ins[def.node] = "craftable:sifter_"..def.name.."_6"

    --[[
        register a reference crafting recipe for siftable items
    ]]
    qts.register_reference_craft({
        ingredients={def.node , "craftable:sifter"},
        results=def.results,
        type="reference",
        description="Sifting with a sifter."
    })
end

minetest.register_abm({
    label = "autosifting",
    nodenames = {"group:sifter_full"},
    interval = 2.0,
    chance = 1,
    action = function (pos, node)
        local nAbove = minetest.get_node_or_nil(pos+vector.new(0,1,0))
        if nAbove and nAbove.name and minetest.get_item_group(nAbove.name, "water") ~= 0 then
            sifter_rightclick(pos, node)
        end
    end
})

register_sifter({
    name = "sand",
    description = "Sand",
    tiles = "overworld_sand.png",
    node = "overworld:sand",
    results = {"overworld:shell_pieces"}
})

register_sifter({
    name = "dirt",
    description = "Dirt",
    tiles = "overworld_dirt.png",
    node = "overworld:dirt",
    results = {"overworld:flint"}
})

register_sifter({
    name = "gravel",
    description = "Dirt",
    tiles = "overworld_gravel.png",
    node = "overworld:gravel",
    results = {"overworld:flint"}
})

register_sifter({
    name = "desert_sand",
    description = "Desert Sand",
    tiles = "overworld_desert_sand.png",
    node = "overworld:desert_sand",
    results = {"overworld:flint"}
})

register_sifter({
    name = "clay",
    description = "Clay",
    tiles = "overworld_clay_block.png",
    node = "overworld:clay",
    results = {"craftable:refined_clay_lump"}
})