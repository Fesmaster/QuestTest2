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
			tool_groups = {"knife"},
			rarity=5,
			items = {"default:herb_milfoil", "default:seed_milfoil"},
		},
		{
			tool_groups = {"knife"},
			rarity=4,
			items = {"default:herb_bloodbulb", "default:seed_bloodbulb"},
		},
		{
			tool_groups = {"knife"},
			rarity=3,
			items = {"default:herb_wolfshood", "default:seed_wolfshood"},
		},
		{
			tool_groups = {"knife"},
			rarity=4,
			items = {"default:herb_sapweed", "default:seed_sapweed"},
		},
		{
			tool_groups = {"knife"},
			rarity=3,
			items = {"default:herb_kingscrown", "default:seed_kingscrown"},
		},
		{
			tool_groups = {"axe", "knife"},
			items = {"default:tinder"}
		},
		{
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
			minetest.log("error","invalid drop: ".. dump(obj))
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
	groups = {oddly_breakable_by_hand=2, flammable=2, snappy=3, attached_node=1, underbrush=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	drop = underbrush_drops,
})

minetest.register_node("default:small_mushroom", {
	description = "A Small Mushroom",
	tiles = {"default_small_mushroom.png"},
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	walkable = false,
	floodable = true,
	groups = {snappy = 3, flammable = 2, attached_node=1, underbrush=1, generation_replacable=1},
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
minetest.register_alias("default:small_shroom", "default:small_mushroom")


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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
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
		groups = {cracky=3, crystal = 1, attached_node = 1, generation_replacable=1},
		sounds = qtcore.node_sound_stone(),
	})
end

minetest.register_node("default:beach_grass", {
	description = "Grass Node",
	tiles ={"default_beach_grass.png"},
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
	groups = {snappy=3, flammable = 2, underbrush=1, growable =1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	drop = underbrush_drops,
	on_flood = floodFunc,
})

--natural coconut

minetest.register_node("default:natural_coconut", {
	description = "Natural Coconut",
	tiles = {
			"default_coconut_top.png",
			"default_coconut_side.png",
			"default_coconut_side.png"
		},
	drawtype = "nodebox",
	inventory_image = "default_coconut.png",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=1, choppy = 2, generation_trees=1, not_in_creative_inventory=1},
	node_box = {
		type = "fixed",
		fixed = {
			{ -2/16, 3/16, 3/16, 3/16, 8/16, 8/16, },
		},
	},
	drop = {
		items = {
			{items = {"default:coconut"}},
		}
	},
	sounds = qtcore.node_sound_wood(),
})


minetest.register_node("default:bonewort", {
	description = "Bonewort",
	tiles ={"default_bonewort.png"},
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
	groups = {snappy=3, flammable = 2, growable =1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	drop = "default:herb_bonewort",
	on_flood = floodFunc,
})

--flowers
minetest.register_node("default:flower_kniphofia", {
	description = "Kniphofia",
	tiles ={"default_kniphofia.png"},
	inventory_image = "default_kniphofia_item.png",
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	param2 = 0,
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, growable =1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	on_flood = floodFunc,
})

minetest.register_node("default:flower_iris", {
	description = "White Iris",
	tiles ={"default_iris.png"},
	inventory_image = "default_iris_item.png",
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	param2 = 0,
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, growable =1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	on_flood = floodFunc,
})

minetest.register_node("default:flower_chicory", {
	description = "Chicory",
	tiles ={"default_chicory.png"},
	inventory_image = "default_chicory_item.png",
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
	groups = {snappy=3, flammable = 2, growable =1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	on_flood = floodFunc,
})

minetest.register_node("default:flower_violet", {
	description = "Violet",
	tiles ={"default_violet.png"},
	inventory_image = "default_violet_item.png",
	use_texture_alpha = "clip",
	drawtype = "plantlike",
	paramtype = "light",
	paramtype2 = "meshoptions",
	param2 = 0,
	sunlight_propagates = true,
	walkable = false,
	floodable = true,
	waving = 1,
	buildable_to = true,
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, growable =1, attached_node=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
	on_place = qtcore.place_random_plantlike,
	on_flood = floodFunc,
})
--[[
--grow_timer = 1,
	--grow_timer_random = 0,
	--on_grow = function(pos)
	--	minetest.log("Grass Grown")
	--	minetest.set_node(pos, {name = "default:grass_5", param2 = qtcore.get_random_meshdata()})
	--	--minetest.log("Grass should be placed")
	--end,
--]]

local function reeds_rightclick(pos, node, clicker, itemstack, pointed_thing)
	local name = itemstack:get_name()
	if minetest.get_item_group(name, "knife") ~= 0 then
		--holding a knife
		local suffix = string.sub(node.name, -1)
		local sfx = {s=1, ["2"]=2, ["3"]=3, ["4"]=4}
		local count = sfx[suffix] -1
		local need_to_drop = ItemStack("default:reeds " .. count)
		if clicker then
			local inv = clicker:get_inventory()
			if inv then
				--add to inv
				need_to_drop = inv:add_item("main", need_to_drop)
			end
		end
		if need_to_drop and not need_to_drop:is_empty() then
			minetest.item_drop(need_to_drop, clicker, pos)
		end
		
		minetest.swap_node(pos, {name = "default:reeds"})
		
		--wear
		if not (qts.is_player_creative(clicker)) then
			qts.apply_default_wear(itemstack, node.name)
		end
	end
	return itemstack
end

minetest.register_node("default:reeds", {
	description = "Reeds",
	tiles ={"default_reeds.png"},
	inventory_image ="default_reeds_item.png",
	wield_image = "default_reeds_item.png",
	use_texture_alpha = "clip",
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{ -7/16, -8/16, -5/16, -3/16, 0.5, -5/16, },
			{ -5/16, -8/16, -7/16, -5/16, 0.5, -3/16, },
			{ -3/16, -8/16,  0/16,  3/16, 0.5,  0/16, },
			{  3/16, -8/16, -5/16,  7/16, 0.5, -5/16, },
			{  5/16, -8/16, -7/16,  5/16, 0.5, -3/16, },
			{ -5/16, -8/16,  3/16, -5/16, 0.5,  7/16, },
			{  5/16, -8/16,  3/16,  5/16, 0.5,  7/16, },
			{ -7/16, -8/16,  5/16, -3/16, 0.5,  5/16, },
			{  3/16, -8/16,  5/16,  7/16, 0.5,  5/16, },
			{  0/16, -8/16, -3/16,  0/16, 0.5,  3/16, },
		}
	},
	selection_box = qtcore.nb_level1(),
	groups = {snappy=3, flammable = 2, attached_node=1, reeds=1, generation_replacable=1},
	sounds = qtcore.node_sound_defaults(),
})
for i = 2, 4 do
	minetest.register_node("default:reeds_"..i, {
		description = "Reeds " .. i,
		tiles ={"default_reeds.png"},
		use_texture_alpha = "clip",
		drawtype = "nodebox",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		node_box = {
			type = "fixed",
			fixed = {
				{ -7/16, -8/16, -5/16, -3/16, i - 0.5, -5/16, },
				{ -5/16, -8/16, -7/16, -5/16, i - 0.5, -3/16, },
				{ -3/16, -8/16,  0/16,  3/16, i - 0.5,  0/16, },
				{  3/16, -8/16, -5/16,  7/16, i - 0.5, -5/16, },
				{  5/16, -8/16, -7/16,  5/16, i - 0.5, -3/16, },
				{ -5/16, -8/16,  3/16, -5/16, i - 0.5,  7/16, },
				{  5/16, -8/16,  3/16,  5/16, i - 0.5,  7/16, },
				{ -7/16, -8/16,  5/16, -3/16, i - 0.5,  5/16, },
				{  3/16, -8/16,  5/16,  7/16, i - 0.5,  5/16, },
				{  0/16, -8/16, -3/16,  0/16, i - 0.5,  3/16, },
			}
		},
		selection_box = qtcore.nb_level1(),
		groups = {snappy=3, flammable = 2, attached_node=1, reeds=1, not_in_creative_inventory=1, generation_replacable=1},
		sounds = qtcore.node_sound_defaults(),
		drop = "default:reeds " .. i,
		on_rightclick = reeds_rightclick,
	})
end

minetest.register_alias("default:reeds_1", "default:reeds")



