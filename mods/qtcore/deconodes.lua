
--[[

qtcore.register_artistic_nodes("name",{
	description = "desc",
	tiles = {"item.png"},
	groups = {},
	sounds = soundsFunc(),
	craft_group = "?_stone",
})

--]]

function qtcore.pillar_place(itemstack, placer, pointed_thing)
	if pointed_thing.type ~= "node" then
		return itemstack
	end
	local param2 = 0
	local p = vector.subtract(pointed_thing.above, pointed_thing.under)
	if (p.y == 1) then param2 = 0
	elseif (p.y == -1) then param2 = 20
	elseif (p.x == 1) then param2 = 12
	elseif (p.x == -1) then param2 = 16
	elseif (p.z == 1) then param2 = 4
	elseif (p.z == -1) then param2 = 8
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end

qtcore.register_artistic_nodes = function(name, def)
	if #def.tiles < 6 then
		for i = #def.tiles+1, 6 do
			def.tiles[i] = def.tiles[3] or def.tiles[1]
		end
	end
	local craft_group = def.craft_group
	def.craft_group = nil
	qts.register_shaped_node (name .. "_brick", {
		description = def.description.." Brick",
		tiles = {
			def.tiles[1].."^qt_brick_overlay.png",
			def.tiles[2].."^qt_brick_overlay.png",
			def.tiles[3].."^qt_brick_overlay.png",
			def.tiles[4].."^qt_brick_overlay.png",
			def.tiles[5].."^qt_brick_overlay.png",
			def.tiles[6].."^qt_brick_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name .. "_block", {
		description = def.description.." Block",
		tiles = {
			def.tiles[1].."^qt_block_overlay.png",
			def.tiles[2].."^qt_block_overlay.png",
			def.tiles[3].."^qt_block_overlay.png",
			def.tiles[4].."^qt_block_overlay.png",
			def.tiles[5].."^qt_block_overlay.png",
			def.tiles[6].."^qt_block_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_cross", {
		description = def.description.." Cross",
		tiles = {
			def.tiles[1].."^qt_cross_overlay.png",
			def.tiles[2].."^qt_cross_overlay.png",
			def.tiles[3].."^qt_cross_overlay.png",
			def.tiles[4].."^qt_cross_overlay.png",
			def.tiles[5].."^qt_cross_overlay.png",
			def.tiles[6].."^qt_cross_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_french", {
		description = def.description.." French",
		tiles = {
			def.tiles[1].."^qt_french_overlay.png",
			def.tiles[2].."^qt_french_overlay.png",
			def.tiles[3].."^qt_french_overlay.png",
			def.tiles[4].."^qt_french_overlay.png",
			def.tiles[5].."^qt_french_overlay.png",
			def.tiles[6].."^qt_french_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_knot", {
		description = def.description.." Knot",
		tiles = {
			def.tiles[1].."^qt_knot_overlay.png",
			def.tiles[2].."^qt_knot_overlay.png",
			def.tiles[3].."^qt_knot_overlay.png",
			def.tiles[4].."^qt_knot_overlay.png",
			def.tiles[5].."^qt_knot_overlay.png",
			def.tiles[6].."^qt_knot_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_pillar", {
		description = def.description.." Pillar",
		tiles = {
			def.tiles[1].."^qt_pillar_top_overlay.png",
			def.tiles[2].."^qt_pillar_top_overlay.png",
			def.tiles[3].."^qt_pillar_overlay.png",
			def.tiles[4].."^qt_pillar_overlay.png",
			def.tiles[5].."^qt_pillar_overlay.png",
			def.tiles[6].."^qt_pillar_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "colorfacedir",
		palette = "default_palette_paint_light.png",
		on_place = qtcore.pillar_place,
	})
	qts.register_shaped_node (name.."_pillar2", {
		description = def.description.." Pillar 2",
		tiles = {
			def.tiles[1].."^qt_pillar2_top_overlay.png",
			def.tiles[2].."^qt_pillar2_top_overlay.png",
			def.tiles[3].."^qt_pillar2_overlay.png",
			def.tiles[4].."^qt_pillar2_overlay.png",
			def.tiles[5].."^qt_pillar2_overlay.png",
			def.tiles[6].."^qt_pillar2_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "colorfacedir",
		palette = "default_palette_paint_light.png",
		on_place = qtcore.pillar_place,
	})
	qts.register_shaped_node (name.."_weave", {
		description = def.description.." Weave",
		tiles = {
			def.tiles[1].."^qt_weave_overlay.png",
			def.tiles[2].."^qt_weave_overlay.png",
			def.tiles[3].."^qt_weave_overlay.png",
			def.tiles[4].."^qt_weave_overlay.png",
			def.tiles[5].."^qt_weave_overlay.png",
			def.tiles[6].."^qt_weave_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_enigma", {
		description = def.description.." Enigma",
		tiles = {
			def.tiles[1].."^qt_enigma_overlay.png",
			def.tiles[2].."^qt_enigma_overlay.png",
			def.tiles[3].."^qt_enigma_overlay.png",
			def.tiles[4].."^qt_enigma_overlay.png",
			def.tiles[5].."^qt_enigma_overlay.png",
			def.tiles[6].."^qt_enigma_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_border", {
		description = def.description.." Border",
		tiles = {
			def.tiles[1].."^qt_block_overlay.png",
			def.tiles[2].."^qt_block_overlay.png",
			def.tiles[3].."^qt_border_overlay.png",
			def.tiles[4].."^qt_border_overlay.png",
			def.tiles[5].."^qt_border_overlay.png",
			def.tiles[6].."^qt_border_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_border2", {
		description = def.description.." Border 2",
		tiles = {
			def.tiles[1].."^qt_block_overlay.png",
			def.tiles[2].."^qt_block_overlay.png",
			def.tiles[3].."^qt_border2_overlay.png",
			def.tiles[4].."^qt_border2_overlay.png",
			def.tiles[5].."^qt_border2_overlay.png",
			def.tiles[6].."^qt_border2_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_shaped_node (name.."_target", {
		description = def.description.." Target",
		tiles = {
			def.tiles[1].."^qt_target_overlay.png",
			def.tiles[2].."^qt_target_overlay.png",
			def.tiles[3].."^qt_target_overlay.png",
			def.tiles[4].."^qt_target_overlay.png",
			def.tiles[5].."^qt_target_overlay.png",
			def.tiles[6].."^qt_target_overlay.png",
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	
	qts.register_fencelike_node(name.."_wall", {
		description = def.description.." Wall",
		type = "wall",
		tiles = {
			def.tiles[1],
			def.tiles[2],
			def.tiles[3],
			def.tiles[4],
			def.tiles[5],
			def.tiles[6],
		},
		groups = def.groups,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	qts.register_fencelike_node(name.."_brick_wall", {
		description = def.description.." Brick Wall",
		type = "wall",
		tiles = {
			def.tiles[1].."^qt_brick_overlay.png",
			def.tiles[2].."^qt_brick_overlay.png",
			def.tiles[3].."^qt_brick_overlay.png",
			def.tiles[4].."^qt_brick_overlay.png",
			def.tiles[5].."^qt_brick_overlay.png",
			def.tiles[6].."^qt_brick_overlay.png",
		},
		groups = def.groups,
		sounds = def.sounds,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	
	if craft_group then
		local names = {"_brick", "_block", "_border", "_border2", "_cross", "_enigma", 
			"_french", "_knot", "_pillar", "_pillar2", "_weave", "_wall","_brick_wall", "_target"}
		for k, v in ipairs(names) do
			qts.register_craft({
				ingredients = {"group:" .. craft_group},
				results = {name..v},
				near = {"group:workbench_heavy"},
			})
		end
	end
	
end