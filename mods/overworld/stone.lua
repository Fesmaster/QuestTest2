--[[
    Overworld stone types.

	Granite
	Mudstone
	Limestone
	Sandstone
	Obsidian
	Marble

	Ice
]]

--[[
	We are going to do the basic stones in a loop, so make a list of the things that are different about them.
	Its really only the name, the description, if there is a cobble form, and if there is ore in this stone.

	We will handle ice seperately, as its unique in that it does not have a mossy form.
]]
local stones = {
	{name="granite", 	desc="Granite", 	cobble=true,	ore=true},
	{name="mudstone", 	desc="Mudstone", 	cobble=true,	ore=true},
	{name="limestone", 	desc="Limestone", 	cobble=true,	ore=true},
	{name="sandstone", 	desc="Sandstone", 	cobble=true,	ore=true},
	{name="obsidian", 	desc="Obsidian", 	cobble=false,	ore=false},
	{name="marble", 	desc="Marble", 		cobble=false,	ore=false},
}

for i, stone in ipairs(stones) do
	local no_cobble = nil
	if stone.cobble == false then
		no_cobble = true
	end

	--[[
		This set of stones has more documentation, the rest follow the same pattern

		First, we register a set of "artistic nodes". Thisis a function from qtcore
		that creates the various styles of stone, indeed, it is designed for this 
		exact purpose.
		It creates the base version, the cobble, all the walls, etc. as well as the 
		crafting recipes. 
		For the base version, it knows to replace the group "generation_artificial"
		with the group "generation_ground".
	]]
	qtcore.register_artistic_nodes("overworld:"..stone.name,{
		description = stone.desc,
		cobble_desc = stone.desc.." Cobble",
		tiles = {"overworld_"..stone.name..".png"},
		--the group "[stone.name] on the next line makes the *value* of stone.name as the key in the groups table, rather than the text "stone.name"
		groups = {cracky=3, stone=1, [stone.name]=1, generation_artificial=1},
		sounds = qtcore.node_sound_stone(),
		craft_group = stone.name,
		no_cobble = no_cobble,
	})

	--[[
		Second, we register a second set of "artistic nodes", but this time using
		an overlay image: moss. This is not one image, but a set, found in qtcore.
		notice the "{TITLE}" in the overlay image name. This is replaced with a
		string naming the style when registering that style. This allows each 
		style to have a custom image. For an example, check out the moss textures
		in qtcore.
	]]
	qtcore.register_artistic_nodes("overworld:"..stone.name.."_moss",{
		description = "Mossy "..stone.desc,
	    cobble_desc = "Mossy "..stone.desc.." Cobble",
		tiles = {"overworld_"..stone.name..".png"},
		groups = {cracky=3, stone=1, [stone.name]=1, generation_artificial=1},
		sounds = qtcore.node_sound_stone(),
		craft_group = stone.name,
		no_cobble = no_cobble,
		overlay_image = "qt_moss_{TITLE}_overlay.png",
	})

	--[[
		Third, we register a material. This is effectively adding the particular stone
		type to a managed list, so that functions can be run for every stone.
		Since these lists are managed, things can be added to the list and functions set to
		run on it in either order and the functions will still run for every element added
		to the list.
		This will allow us to add metal ores and the like.
	]]
	qtcore.register_material("stone", {
		name=stone.name, --stone name
		desc = stone.desc, --stone description
		base_img = "overworld_"..stone.name..".png", --base image
		base_item = "overworld:"..stone.name, --base stone item
		mosy_item = "overworld:"..stone.name.."_moss", --base mossy stone item
		craft_group=stone.name, --intercraftable group
		no_cobble = no_cobble, --if there is cobble or not
		world_layer = "overworld", --the layer of the world it appears in
		has_ore=stone.ore, --if the stone has ore in it
	})


	inventory.register_exemplar_item(stone.name, "overworld:"..stone.name)
end
inventory.register_exemplar_item("stone", "overworld:granite")

--ice
qtcore.register_artistic_nodes("overworld:ice",{
	description = "Ice",
	cobble_desc = "Ice Chunks",
	tiles = {"overworld_ice.png"},
	use_texture_alpha = "blend",
	drawtype = "glasslike",
	paramtype = "light",
	groups = {cracky=3, ice=1, cooling=1, slippery=4, generation_ground=1},
	sounds = qtcore.node_sound_stone(),
	craft_group = "ice",
	singleface = true,
})

--intentional lack of mossy form

qtcore.register_material("stone", {
	name="ice",
	desc = "Ice",
	base_img = "overworld_ice.png",
	base_item = "overworld:ice",
	class = "ice", --class is optional, and if present, it means "I'll be treating this special somewhere"
})
inventory.register_exemplar_item("ice", "overworld:ice")