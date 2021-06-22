--holds plants and underbrush

minetest.register_craftitem("default:underbrush_item",{
	description = "Underbrush",
	inventory_image = "default_underbrush_item.png",
	groups = {underbrush=1}
})

local underbrush_drops = {
	max_items = 1,
	items={
		{
			tools = {"~:knife"},
			chance=5,
			items = {"default:tinder"} --this is where to add craft items
		},
		{
			tools = {"~:knife"},
			chance=5,
			items = {"default:milfoil_herb"} --this is where to add craft items
		},
		{
			tools = {"~:knife"},
			chance=5,
			items = {"default:bloodbulb_herb"} --this is where to add craft items
		},
		{
			tools = {"~:axe"},
			chance=1,
			items = {"default:tinder"}
		},
		{
			chance=1,
			items = {"default:underbrush_item"}
		}
	}
}

local function floodFunc(pos, oldnode, newnode)
	local d = minetest.get_node_drops(oldnode, "wieldhand")
	for index, item in ipairs(d) do
		local obj = minetest.add_item(pos, ItemStack(item))
		if obj then
			obj:set_velocity({x = math.random(-1, 1), y = math.random(3, 5), z = math.random(-1, 1)})
		else
			minetest.log("error","invalid drop: ".. dump(itemstack))
		end
	end
	return false
end

minetest.register_node("default:swamp_plant", {
	description = "A Strange Plant that lives in the swamp",
	tiles = {"default_swamp_plant.png"},
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {oddly_breakable_by_hand=2, flammable=2, snappy=3, attached_node=1,underbrush=1},
	sounds = qtcore.node_sound_defaults(),
	drop = underbrush_drops,
})

minetest.register_node("default:small_shroom", {
	description = "A Small Edible Mushroom",
	tiles = {"default_small_shroom.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	walkable = false,
	floodable = true,
	groups = {snappy = 3, flammable = 2, attached_node=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, 0.125, -0.125, -0.3125, 0.1875}, -- NodeBox5
			{-0.25, -0.3125, 0.0625, -0.0625, -0.25, 0.25}, -- NodeBox6
			{-0.25, -0.375, 0, -0.0625, -0.3125, 0.3125}, -- NodeBox7
			{-0.3125, -0.375, 0.0625, 0, -0.3125, 0.25}, -- NodeBox8
			{0.125, -0.5, -0.1875, 0.1875, -0.4375, -0.125}, -- NodeBox9
			{0.0625, -0.4375, -0.25, 0.25, -0.375, -0.0625}, -- NodeBox10
		}
	},
	sounds = qtcore.node_sound_defaults(),
	on_flood = floodFunc,
})



minetest.register_node("default:grass_short", {
	description = "Grass Node",
	tiles ={"default_grass_short.png"},
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	drop = underbrush_drops,
	on_flood = floodFunc,
})

minetest.register_node("default:grass_tall", {
	description = "Grass Node",
	tiles ={"default_grass_tall.png"},
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	drop = underbrush_drops,
	on_flood = floodFunc,
})

minetest.register_node("default:grass_dry_short", {
	description = "Dry Grass Node",
	tiles ={"default_dry_grass_short.png"},
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	drop = underbrush_drops,
	on_flood = floodFunc,
})

minetest.register_node("default:grass_dry_tall", {
	description = "Dry Grass Node",
	tiles ={"default_dry_grass_tall.png"},
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	drop = underbrush_drops,
	on_flood = floodFunc,
})

minetest.register_node("default:underbrush_short", {
	description = "Underbrush",
	tiles ={"default_underbrush.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	buildable_to = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.3125, 0.5, -0.0625, 0.375}, -- NodeBox2
			{-0.5, -0.5, -0.0625, 0.0625, -0.1875, 0.5}, -- NodeBox3
			{-0.375, -0.5, -0.5, 0.25, 0.0625, 2.98023e-008}, -- NodeBox4
		}
	},
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	drop = underbrush_drops,
	on_flood = floodFunc,
})
minetest.register_node("default:underbrush_tall", {
	description = "Underbrush",
	tiles ={"default_underbrush.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	buildable_to = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.1875, 0.4375, 0.5, 0.5}, -- NodeBox2
			{-0.5, -0.5, -0.375, 0.0625, 0.25, 0.3125}, -- NodeBox3
			{-0.125, -0.5, -0.5, 0.5, 0.0625, 1.49012e-008}, -- NodeBox4
			{-0.25, -0.5, -0.4375, 0.375, 0.375, -0.125}, -- NodeBox5
			{-0.4375, -0.5, 0.125, 0, 0.1875, 0.4375}, -- NodeBox6
		}
	},
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1},
	sounds = qtcore.node_sound_defaults(),
	drop = underbrush_drops,
	on_flood = floodFunc,
})

local colors = {"blue", "green", "purple"}
local colorCap = {"Blue", "Green", "Purple"}

for k, color in ipairs(colors) do
	minetest.register_node("default:cave_crystal_"..color, {
		description = colorCap[k].." Cave Crystal",
		drawtype = "mesh",
		tiles = {"default_cave_crystal_"..color..".png"},
		mesh = "cave_crystal.obj",
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		buildable_to = true,
		use_texture_alpha = "blend",
		sunlight_propagates = true,
		on_rotate = false,
		selection_box = qtcore.nb_level1(),
		light_source = 10,
		groups = {cracky=3, crystal = 1, attached_node = 1},
		sounds = qtcore.node_sound_stone(),
	})
end



--[[
--grow_timer = 1,
	--grow_timer_random = 0,
	--on_grow = function(pos)
	--	minetest.log("Grass Grown")
	--	minetest.set_node(pos, {name = "default:grass_5", param2 = qtcore.get_random_meshdata()})
	--	--minetest.log("Grass should be placed")
	--end,
--]]