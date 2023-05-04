
--[[

qtcore.register_artistic_nodes("name",{
	description = "desc",
	tiles = {"item.png"},
	groups = {},
	sounds = soundsFunc(),
	craft_group = "?_stone",
	overlay_image = "string with {TITLE} in it for each type."
	singleface = false -- if true, don't use custom top/bottom faces (mostly for ice and other transparent artistic nodes)
})

--]]

---Place a pillar-like node, such as a pillar or tree trunk. Valid for setting the on_place callback in a node to this function.
---@param itemstack ItemStack the placed itemstack
---@param placer ObjectRef the placer entity
---@param pointed_thing PointedThing the pointed_thing
---@return ItemStack remaining the leftover itemstack
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

---@class ArtisticNodeDef
---@field description string the node description
---@field cobble_desc string|nil the cobble node description, as it can vary
---@field tiles TileDefinition[]|TileDefinition the node textures
---@field groups Group_Set the node groups
---@field sounds {ItemSoundField:SimpleSoundSpec|nil|table}|nil the node sounds
---@field craft_group string the group to use for crafting
---@field overlay_image Texture|nil overlay texture. If it contains "{TITLE}", this will be replaced with the node name. See overworld/stone.lua for an example.
---@field no_base boolean|nil if true, do not create node base form
---@field no_generation_ground_for_base boolean|nil if true, do not swap group generation_artificial for generation_ground on base node
---@field no_cobble boolean|nil if true, do not create node cobble form
---@field singleface boolean|nil if true, do not use different textures for top and bottom face. used for compatability with some nodes (IE, transparent ones like ice)
---@field drawtype NodeDrawType|nil if a value, use as the node draw type. Otherwise, its auto-selectec
---@field paramtype ParamType|nil if a value, use as the node param type
---@field use_texture_alpha "blend"|"clip"|"opaque"|nil if a value, use as the node's alpha draw mode

---Register a set of nodes using the stone overlays.
---@param name ItemName the base node name
---@param def ArtisticNodeDef
function qtcore.register_artistic_nodes(name, def)
	if #def.tiles < 6 then
		for i = #def.tiles+1, 6 do
			def.tiles[i] = def.tiles[3] or def.tiles[1]
		end
	end

	local overlay_raw = ""
	if def.overlay_image and type(def.overlay_image) == "string" then
		overlay_raw = def.overlay_image
	end

	if not def.no_base then
		local groups = table.copy(def.groups)
		if not def.no_generation_ground_for_base then
			if groups.generation_artificial then
				groups.generation_artificial = nil
			end
			groups.generation_ground=1
		end
		local overlay = string.gsub(overlay_raw, "{TITLE}", "base")
		if overlay ~= "" then
			overlay = "^"..overlay
		end
		qts.register_shaped_node (name, {
			description = def.description,
			tiles = {
				def.tiles[1]..overlay,
				def.tiles[2]..overlay,
				def.tiles[3]..overlay,
				def.tiles[4]..overlay,
				def.tiles[5]..overlay,
				def.tiles[6]..overlay,
			},
			groups = groups,
			is_ground_content = true, --make caves work!!!
			sounds = def.sounds,
			drawtype=def.drawtype,
			paramtype = def.paramtype,
			use_texture_alpha = def.use_texture_alpha,
			paramtype2 = "color",
			palette = "default_palette_paint_light.png",
		})
		qts.register_craft({
			ingredients = {"group:" .. def.craft_group},
			results = {name},
			near = {"group:workbench_heavy"},
		})
	end

	if not def.no_cobble then

		local overlay = string.gsub(overlay_raw, "{TITLE}", "cobble")
		if overlay ~= "" then
			overlay = "^"..overlay
		end
		qts.register_shaped_node (name.."_cobble", {
            description = def.cobble_desc,
			tiles = {
				def.tiles[1].."^qt_cobble_overlay.png"..overlay,
				def.tiles[2].."^qt_cobble_overlay.png"..overlay,
				def.tiles[3].."^qt_cobble_overlay.png"..overlay,
				def.tiles[4].."^qt_cobble_overlay.png"..overlay,
				def.tiles[5].."^qt_cobble_overlay.png"..overlay,
				def.tiles[6].."^qt_cobble_overlay.png"..overlay,
			},
            groups = def.groups,
            is_ground_content = false,
            sounds = def.sounds,
			drawtype=def.drawtype,
			use_texture_alpha = def.use_texture_alpha,
            paramtype2 = "color",
            palette = "default_palette_paint_light.png",
        })
		qts.register_craft({
			ingredients = {"group:" .. def.craft_group},
			results = {name.."_cobble"},
			near = {"group:workbench_heavy"},
		})

		qts.register_fencelike_node(name.."_cobble_wall", {
			description = def.description.." Cobblestone Wall",
			type = "wall",
			tiles = {
				def.tiles[1].."^qt_cobble_overlay.png"..overlay,
				def.tiles[2].."^qt_cobble_overlay.png"..overlay,
				def.tiles[3].."^qt_cobble_overlay.png"..overlay,
				def.tiles[4].."^qt_cobble_overlay.png"..overlay,
				def.tiles[5].."^qt_cobble_overlay.png"..overlay,
				def.tiles[6].."^qt_cobble_overlay.png"..overlay,
			},
			groups = def.groups,
			sounds = def.sounds,
			use_texture_alpha = def.use_texture_alpha,
			paramtype2 = "color",
			palette = "default_palette_paint_light.png",
		})
		qts.register_craft({
			ingredients = {"group:" .. def.craft_group},
			results = {name.."_cobble_wall"},
			near = {"group:workbench_heavy"},
		})
	end

	local overlay = string.gsub(overlay_raw, "{TITLE}", "brick")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name .. "_brick", {
		description = def.description.." Brick",
		tiles = {
			def.tiles[1].."^qt_brick_overlay.png"..overlay,
			def.tiles[2].."^qt_brick_overlay.png"..overlay,
			def.tiles[3].."^qt_brick_overlay.png"..overlay,
			def.tiles[4].."^qt_brick_overlay.png"..overlay,
			def.tiles[5].."^qt_brick_overlay.png"..overlay,
			def.tiles[6].."^qt_brick_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "block")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name .. "_block", {
		description = def.description.." Block",
		tiles = {
			def.tiles[1].."^qt_block_overlay.png"..overlay,
			def.tiles[2].."^qt_block_overlay.png"..overlay,
			def.tiles[3].."^qt_block_overlay.png"..overlay,
			def.tiles[4].."^qt_block_overlay.png"..overlay,
			def.tiles[5].."^qt_block_overlay.png"..overlay,
			def.tiles[6].."^qt_block_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "cross")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_cross", {
		description = def.description.." Cross",
		tiles = {
			def.tiles[1].."^qt_cross_overlay.png"..overlay,
			def.tiles[2].."^qt_cross_overlay.png"..overlay,
			def.tiles[3].."^qt_cross_overlay.png"..overlay,
			def.tiles[4].."^qt_cross_overlay.png"..overlay,
			def.tiles[5].."^qt_cross_overlay.png"..overlay,
			def.tiles[6].."^qt_cross_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "french")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_french", {
		description = def.description.." French",
		tiles = {
			def.tiles[1].."^qt_french_overlay.png"..overlay,
			def.tiles[2].."^qt_french_overlay.png"..overlay,
			def.tiles[3].."^qt_french_overlay.png"..overlay,
			def.tiles[4].."^qt_french_overlay.png"..overlay,
			def.tiles[5].."^qt_french_overlay.png"..overlay,
			def.tiles[6].."^qt_french_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "knot")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_knot", {
		description = def.description.." Knot",
		tiles = {
			def.tiles[1].."^qt_knot_overlay.png"..overlay,
			def.tiles[2].."^qt_knot_overlay.png"..overlay,
			def.tiles[3].."^qt_knot_overlay.png"..overlay,
			def.tiles[4].."^qt_knot_overlay.png"..overlay,
			def.tiles[5].."^qt_knot_overlay.png"..overlay,
			def.tiles[6].."^qt_knot_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "pillar")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	local overlay_top = string.gsub(overlay_raw, "{TITLE}", "pillar_top")
	if overlay_top ~= "" then
		overlay_top = "^"..overlay_top
	end
	qts.register_shaped_node (name.."_pillar", {
		description = def.description.." Pillar",
		tiles = {
			def.tiles[1]..qts.select(def.singleface, "^qt_pillar_overlay.png"..overlay, "^qt_pillar_top_overlay.png"..overlay_top),
			def.tiles[2]..qts.select(def.singleface, "^qt_pillar_overlay.png"..overlay, "^qt_pillar_top_overlay.png"..overlay_top),
			def.tiles[3].."^qt_pillar_overlay.png"..overlay,
			def.tiles[4].."^qt_pillar_overlay.png"..overlay,
			def.tiles[5].."^qt_pillar_overlay.png"..overlay,
			def.tiles[6].."^qt_pillar_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "colorfacedir",
		palette = "default_palette_paint_light.png",
		on_place = qtcore.pillar_place,
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "pillar2")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	overlay_top = string.gsub(overlay_raw, "{TITLE}", "pillar2_top")
	if overlay_top ~= "" then
		overlay_top = "^"..overlay_top
	end
	qts.register_shaped_node (name.."_pillar2", {
		description = def.description.." Pillar 2",
		tiles = {
			def.tiles[1]..qts.select(def.singleface, "^qt_pillar2_overlay.png"..overlay, "^qt_pillar2_top_overlay.png"..overlay_top),
			def.tiles[2]..qts.select(def.singleface, "^qt_pillar2_overlay.png"..overlay, "^qt_pillar2_top_overlay.png"..overlay_top),
			def.tiles[3].."^qt_pillar2_overlay.png"..overlay,
			def.tiles[4].."^qt_pillar2_overlay.png"..overlay,
			def.tiles[5].."^qt_pillar2_overlay.png"..overlay,
			def.tiles[6].."^qt_pillar2_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "colorfacedir",
		palette = "default_palette_paint_light.png",
		on_place = qtcore.pillar_place,
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "weave")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_weave", {
		description = def.description.." Weave",
		tiles = {
			def.tiles[1].."^qt_weave_overlay.png"..overlay,
			def.tiles[2].."^qt_weave_overlay.png"..overlay,
			def.tiles[3].."^qt_weave_overlay.png"..overlay,
			def.tiles[4].."^qt_weave_overlay.png"..overlay,
			def.tiles[5].."^qt_weave_overlay.png"..overlay,
			def.tiles[6].."^qt_weave_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "enigma")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_enigma", {
		description = def.description.." Enigma",
		tiles = {
			def.tiles[1].."^qt_enigma_overlay.png"..overlay,
			def.tiles[2].."^qt_enigma_overlay.png"..overlay,
			def.tiles[3].."^qt_enigma_overlay.png"..overlay,
			def.tiles[4].."^qt_enigma_overlay.png"..overlay,
			def.tiles[5].."^qt_enigma_overlay.png"..overlay,
			def.tiles[6].."^qt_enigma_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "border")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	overlay_top = string.gsub(overlay_raw, "{TITLE}", "block")
	if overlay_top ~= "" then
		overlay_top = "^"..overlay_top
	end
	qts.register_shaped_node (name.."_border", {
		description = def.description.." Border",
		tiles = {
			def.tiles[1]..qts.select(def.singleface, "^qt_border_overlay.png"..overlay, "^qt_block_overlay.png"..overlay_top),
			def.tiles[2]..qts.select(def.singleface, "^qt_border_overlay.png"..overlay, "^qt_block_overlay.png"..overlay_top),
			def.tiles[3].."^qt_border_overlay.png"..overlay,
			def.tiles[4].."^qt_border_overlay.png"..overlay,
			def.tiles[5].."^qt_border_overlay.png"..overlay,
			def.tiles[6].."^qt_border_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "border2")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_border2", {
		description = def.description.." Border 2",
		tiles = {
			def.tiles[1]..qts.select(def.singleface, "^qt_border2_overlay.png"..overlay, "^qt_block_overlay.png"..overlay_top),
			def.tiles[2]..qts.select(def.singleface, "^qt_border2_overlay.png"..overlay, "^qt_block_overlay.png"..overlay_top),
			def.tiles[3].."^qt_border2_overlay.png"..overlay,
			def.tiles[4].."^qt_border2_overlay.png"..overlay,
			def.tiles[5].."^qt_border2_overlay.png"..overlay,
			def.tiles[6].."^qt_border2_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "target")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_shaped_node (name.."_target", {
		description = def.description.." Target",
		tiles = {
			def.tiles[1].."^qt_target_overlay.png"..overlay,
			def.tiles[2].."^qt_target_overlay.png"..overlay,
			def.tiles[3].."^qt_target_overlay.png"..overlay,
			def.tiles[4].."^qt_target_overlay.png"..overlay,
			def.tiles[5].."^qt_target_overlay.png"..overlay,
			def.tiles[6].."^qt_target_overlay.png"..overlay,
		},
		groups = def.groups,
		is_ground_content = false,
		sounds = def.sounds,
		drawtype=def.drawtype,
		paramtype = def.paramtype,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	
	overlay = string.gsub(overlay_raw, "{TITLE}", "base")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_fencelike_node(name.."_wall", {
		description = def.description.." Wall",
		type = "wall",
		tiles = {
			def.tiles[1]..overlay,
			def.tiles[2]..overlay,
			def.tiles[3]..overlay,
			def.tiles[4]..overlay,
			def.tiles[5]..overlay,
			def.tiles[6]..overlay,
		},
		groups = def.groups,
		sounds = def.sounds,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})

	overlay = string.gsub(overlay_raw, "{TITLE}", "brick")
	if overlay ~= "" then
		overlay = "^"..overlay
	end
	qts.register_fencelike_node(name.."_brick_wall", {
		description = def.description.." Brick Wall",
		type = "wall",
		tiles = {
			def.tiles[1].."^qt_brick_overlay.png"..overlay,
			def.tiles[2].."^qt_brick_overlay.png"..overlay,
			def.tiles[3].."^qt_brick_overlay.png"..overlay,
			def.tiles[4].."^qt_brick_overlay.png"..overlay,
			def.tiles[5].."^qt_brick_overlay.png"..overlay,
			def.tiles[6].."^qt_brick_overlay.png"..overlay,
		},
		groups = def.groups,
		sounds = def.sounds,
		use_texture_alpha = def.use_texture_alpha,
		paramtype2 = "color",
		palette = "default_palette_paint_light.png",
	})
	
	if def.craft_group then
		local names = {"_brick", "_block", "_border", "_border2", "_cross", "_enigma", 
			"_french", "_knot", "_pillar", "_pillar2", "_weave", "_wall","_brick_wall", "_target"}
		for k, v in ipairs(names) do
			qts.register_craft({
				ingredients = {"group:" .. def.craft_group},
				results = {name..v},
				near = {"group:workbench_heavy"},
			})
		end
	end
	
end