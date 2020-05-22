
--fuels
foundry.register_smeltable({
	itemname = "default:coal",
	smelt_time = 2,
	type = "fuel",
	heat = 5,
})


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

--steel
foundry.register_metal("steel", {
	description = "Steel",
	texture = "foundry_steel_molten.png",
	ingot = "default:steel_bar",
	block = "default:steel_block",
})

foundry.register_smeltable({
	itemname = "default:steel_alloy",
	smelt_time = 2,
	type = "melt",
	heat = 1,
	metal = "steel",
	metal_ammount = 1,
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

--brass
foundry.register_metal("brass", {
	description = "Brass",
	texture = "foundry_steel_molten.png",
	ingot = "default:brass_bar",
	block = "default:brass_block",
})

foundry.register_smeltable({
	itemname = "default:brass_alloy",
	smelt_time = 2,
	type = "melt",
	heat = 1,
	metal = "brass",
	metal_ammount = 1,
})

--bronze
foundry.register_metal("bronze", {
	description = "Bronze",
	texture = "foundry_steel_molten.png",
	ingot = "default:bronze_bar",
	block = "default:bronze_block",
})

foundry.register_smeltable({
	itemname = "default:bronze_alloy",
	smelt_time = 2,
	type = "melt",
	heat = 1,
	metal = "bronze",
	metal_ammount = 1,
})



--gold
foundry.register_metal("gold", {
	description = "Gold",
	texture = "foundry_steel_molten.png",
	ingot = "default:gold_bar",
	block = "default:gold_block",
})

foundry.register_smeltable({
	itemname = "default:stone_with_gold",
	smelt_time = 4,
	type = "melt",
	heat = 1,
	metal = "gold",
	metal_ammount = 4,
})