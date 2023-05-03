--[[
	gems

	This file creats gemstones.

	Coal is also in here because its closer to a gemstone than a metal.
]]

--[[
	List of gems
]]
local gems = {
	{name="ruby", desc="Ruby"},
	--here is the reason that we don't use something like qtcore.string_first_to_upper(...) to get the descriotion
	{name="fire_opal", desc="Fire Opal"},
	{name="citrine", desc="Citrine"},
	{name="emerald", desc="Emerald"},
	{name="diamond", desc="Diamond"},
	{name="sapphire", desc="Sapphire"},
	{name="amathest", desc="Amathest"},
	{name="oynx", desc="Oynx"},
}

--[[
	Since all gems are mechanically the same, registration-wise,
	it is easy to do this in a loop.
]]
for i, gem in ipairs(gems) do
	
	--[[
		First, create the item for the stone.
	]]
	minetest.register_craftitem("overworld:gem_"..gem.name, {
		description = gem.desc.." Gemstone",
		inventory_image = "overworld_gem_"..gem.name..".png",
		groups = {gem = 1,},
	})
	
	--[[
		Since there are many stones, register a gem ore for each stone.
	]]
	qtcore.for_all_materials("stone", function(fields)
		if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then
		
			--[[
				Create the ore, specific to the stone.
			]]
			qts.register_shaped_node("overworld:"..fields.name.."_with_"..gem.name, {
				description = gem.desc.." In " .. fields.desc,
				tiles = {fields.base_img.."^overworld_stone_with_"..gem.name..".png"},
				groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
				sounds = qtcore.node_sound_stone(),
				drop = "overworld:gem_"..gem.name,
			})
	
			--[[
				Then, create the ore registrations.
			]]
			minetest.register_ore({
				ore_type       = "scatter",
				ore            = "overworld:"..fields.name.."_with_"..gem.name,
				wherein        = fields.base_item,
				clust_scarcity = 30 * 30 * 30,
				clust_num_ores = 4,
				clust_size     = 2,
				y_max          = -256,
				y_min          = -1024,
			})
		end
	end)

	--[[
		Create the material for the gemstone
	]]
	qtcore.register_material("gem", {
		name=gem.name,
		desc = gem.desc,
		item = "overworld:gem_"..gem.name,
		ore = "overworld:stone_with_"..gem.name,
	})

end 


--[[
	Coal

	While not a traditional gemstone, Coal has no other logical place to go.

	Coal is handled exactly like a gemstone, except it
]]
minetest.register_craftitem("overworld:coal", {
	description = "Coal Lump",
	inventory_image = "overworld_coal.png",
	groups = {coal = 1,},
})

--[[
	Since there are many stones, register a coal ore for each stone.
]]
qtcore.for_all_materials("stone", function(fields)
	if (fields.name
		and fields.desc
		and fields.craft_group
		and fields.base_img
		and fields.base_item
		and fields.world_layer
		and fields.world_layer == "overworld"
		and fields.has_ore
	) then
	
		--[[
			Create the ore, specific to the stone.
		]]
		qts.register_shaped_node("overworld:"..fields.name.."_with_coal", {
			description = "Coal In " .. fields.desc,
			tiles = {fields.base_img.."^overworld_stone_with_coal.png"},
			groups = {cracky=3, stone=1, [fields.craft_group]=1, ore=1, generation_ground=1},
			sounds = qtcore.node_sound_stone(),
			drop = "overworld:coal",
		})

		--[[
			Then, create the ore registrations.
		]]
		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_coal",
			wherein        = fields.base_item,
			clust_scarcity = 10 * 10 * 10,
			clust_num_ores = 8,
			clust_size     = 3,
			y_max          = 64,
			y_min          = -127,
		})
		
		minetest.register_ore({
			ore_type       = "scatter",
			ore            = "overworld:"..fields.name.."_with_coal",
			wherein        = fields.base_item,
			clust_scarcity = 16 * 16 * 16,
			clust_num_ores = 16,
			clust_size     = 5,
			y_max          = -128,
			y_min          = -31000,
		})
	end
end)
