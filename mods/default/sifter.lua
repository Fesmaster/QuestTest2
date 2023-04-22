
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
        minetest.set_node(pos, {name="default:sifter"})
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




minetest.register_node("default:sifter", {
    description = "Sifter",
	tiles = {
		"default_sifter_top.png", --top
		"default_sifter_top.png", --bottom
		"default_oak_wood.png" --sides
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
    def.tiles = string, texture of sift
    def.node = string, the in node name
    def.results = table, possible results
}
]]
local function register_sifter(def)
    for i = 1,6 do
        minetest.register_node("default:sifter_"..def.name.."_"..i, {
            description = "Sifter "..(def.description or def.name) .." ".. i,
        	tiles = {
        		"default_sifter_top.png^("..def.tiles.."^default_sifter_mask_top.png^[makealpha:255,126,126)", --top
        		"default_sifter_top.png^("..def.tiles.."^default_sifter_mask_top.png^[makealpha:255,126,126)", --bottom
        		"default_oak_wood.png^("..def.tiles.."^default_sifter_mask_side.png^[makealpha:255,126,126)" --sides
        	},
        	use_texture_alpha = "clip",
        	drawtype = "nodebox",
        	paramtype = "light",
        	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, sifter=1, sifter_full=1, not_in_creative_inventory=1},
            drop = "default:sifter",
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
    sifter_outs["default:sifter_"..def.name.."_"] = def.results
    sifter_ins[def.node] = "default:sifter_"..def.name.."_6"
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
    tiles = "default_sand.png",
    node = "overworld:sand",
    results = {"default:shell_pieces"}
})

register_sifter({
    name = "dirt",
    description = "Dirt",
    tiles = "default_dirt.png",
    node = "overworld:dirt",
    results = {"default:flint"}
})

register_sifter({
    name = "gravel",
    description = "Dirt",
    tiles = "default_gravel.png",
    node = "overworld:gravel",
    results = {"default:flint"}
})

register_sifter({
    name = "desert_sand",
    description = "Desert Sand",
    tiles = "default_desert_sand.png",
    node = "overworld:desert_sand",
    results = {"default:flint"}
})

register_sifter({
    name = "clay",
    description = "Clay",
    tiles = "default_clay_block.png",
    node = "overworld:clay",
    results = {"default:refined_clay_lump"}
})