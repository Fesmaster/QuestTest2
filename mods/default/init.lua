-- default (Minetest 0.4 mod)
-- Most default stuff

-- The API documentation in here was moved into doc/lua_api.txt

-- Definitions made by this mod that other mods can use too
default = {}

-- Load other files
dofile(minetest.get_modpath("default").."/mapgen.lua")

-- The hand
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={[2]=2.00, [3]=1.00}, uses=0, maxlevel=1},
			crumbly = {times={[2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=7.00,[2]=4.00,[3]=1.40}, uses=0, maxlevel=3},
		},
		damage_groups = {fleshy=1},
	}
}) 



-- Default node sounds

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name="", gain=1.0}
	table.dug = table.dug or
			{name="default_dug_node", gain=1.0}
	return table
end

-- Register nodes

minetest.register_node("default:default", {
	description = "Default Node",
	tiles ={"default.png"},
	groups = {oddly_breakable_by_hand=3},
	sounds = default.node_sound_defaults(),
})

--devmode items that are used for fun testing stuff
if qts.ISDEV then
	minetest.register_tool("default:testingTool", {
		description = "Testing Tool:\nCurrently hammers nodes \nand functions as a screwdriver \nif shift held",
		inventory_image = "qts_testing_tool.png",
		range = 10.0,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			minetest.log("QTS Testing Tool used")
			if pointed_thing.under then
				if user:get_player_control().sneak then
					qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_FACE)
				else
					qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_TYPE)
				end		
			end
			
		end,
		on_place = function(itemstack, user, pointed_thing)
		minetest.log("QTS Testing Tool placed")
			if pointed_thing.under then
				if user:get_player_control().sneak then
					qts.screwdriver.apply(pointed_thing, user, qts.screwdriver.ROTATE_AXIS)
				else
					qts.hammer.apply(pointed_thing, user, qts.hammer.CHANGE_STYLE)
				end
			end
			
		end
	})
	
	qts.register_shaped_node("default:testNode", {
		description = "Test Node", 
		tiles ={"default_testing.png"}, 
		groups = {oddly_breakable_by_hand=3},
		sounds = default.node_sound_defaults(),
	})
	
	minetest.register_on_joinplayer(function(player)
		local inv = player:get_inventory()
		inv:add_item("main", "default:testingTool")
		inv:add_item("main", "default:gauntlet")
		inv:add_item("main", "default:testNode 99")
	end)
	
end

--register materials here
minetest.register_tool ("default:gauntlet", {
	description = ("Gauntlet of DESTRUCTION"),
	inventory_image = "wieldhand.png",
	wield_image = "wieldhand.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			crumbly = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			choppy = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			snappy = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
			oddly_breakable_by_hand = {times={[3]=.1, [2]=.25, [1]=.5}, uses=1000000000000000000000, maxlevel=3},
		},
		damage_groups = {fleshy=10000},
	},
})


qts.register_shaped_node("default:stone", {
	description = "stone",
	tiles = {"default_stone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
	drop = "default:cobble"
})

qts.register_shaped_node ("default:cobble", {
	description = "cobble",
	tiles = {"default_cobble.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})
	
qts.register_shaped_node ("default:mossycobble", {
	description = "mossy cobble",
	tiles = {"default_mossycobble.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:sandstone", {
	description = "sandstone",
	tiles = {"default_sandstone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:stone_brick", {
	description = "Stone Brick",
	tiles = {"default_stone_brick.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:obsidian", {
	description = "obsidian",
	tiles = {"default_obsidian.png"},
	groups = {cracky=1},
	sounds = default.node_sound_defaults(),
})

qts.register_shaped_node ("default:brick", {
	description = "Brick",
	tiles = {"default_brick.png"},
	groups = {cracky=3},
	sounds = default.node_sound_defaults(),
})
	
qts.register_shaped_node ("default:wood", {
	description = "Wood Planks",
	tiles = {"default_wood.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2},
	sounds = default.node_sound_defaults(),
})