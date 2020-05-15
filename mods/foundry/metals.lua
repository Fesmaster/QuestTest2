

--iron
foundry.register_metal("iron", {
	description = "Iron",
	texture = "foundry_steel_molten.png",
	ingot = "default:iron_bar",
	block = "default:iron_block",
})

foundry.register_smeltable({
	itemname = "default:stone_with_iron",
	smelt_time = 4,
	type = "melt",
	heat = 1,
	metal = "iron",
	metal_ammount = 4,
})

--tin
foundry.register_metal("tin", {
	description = "Tin",
	texture = "foundry_steel_molten.png",
	ingot = "default:tin_bar",
	block = "default:tin_block",
})

foundry.register_smeltable({
	itemname = "default:stone_with_tin",
	smelt_time = 4,
	type = "melt",
	heat = 1,
	metal = "tin",
	metal_ammount = 4,
})

--zinc
foundry.register_metal("zinc", {
	description = "Zinc",
	texture = "foundry_steel_molten.png",
	ingot = "default:zinc_bar",
	block = "default:zinc_block",
})

foundry.register_smeltable({
	itemname = "default:stone_with_zinc",
	smelt_time = 4,
	type = "melt",
	heat = 1,
	metal = "zinc",
	metal_ammount = 4,
})

--copper
foundry.register_metal("copper", {
	description = "Copper",
	texture = "foundry_steel_molten.png",
	ingot = "default:copper_bar",
	block = "default:copper_block",
})

foundry.register_smeltable({
	itemname = "default:stone_with_copper",
	smelt_time = 4,
	type = "melt",
	heat = 1,
	metal = "copper",
	metal_ammount = 4,
})