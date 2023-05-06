
--fuels
foundry.register_smeltable({
	itemname = "overworld:coal",
	smelt_time = 2,
	type = "fuel",
	heat = 5,
})

foundry.register_smeltable({
	itemname = "craftable:charcoal",
	smelt_time = 2,
	type = "fuel",
	heat = 2,
})


--iron
foundry.register_metal("iron", {
	description = "Iron",
	texture = "foundry_steel_molten.png",
	ingot = "overworld:iron_bar",
	block = "overworld:iron_block",
})

--steel
foundry.register_metal("steel", {
	description = "Steel",
	texture = "foundry_steel_molten.png",
	ingot = "overworld:steel_bar",
	block = "overworld:steel_block",
})

foundry.register_smeltable({
	itemname = "overworld:steel_alloy",
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
	ingot = "overworld:tin_bar",
	block = "overworld:tin_block",
})

--copper
foundry.register_metal("copper", {
	description = "Copper",
	texture = "foundry_steel_molten.png",
	ingot = "overworld:copper_bar",
	block = "overworld:copper_block",
})

--bronze
foundry.register_metal("bronze", {
	description = "Bronze",
	texture = "foundry_steel_molten.png",
	ingot = "overworld:bronze_bar",
	block = "overworld:bronze_block",
})

foundry.register_smeltable({
	itemname = "overworld:bronze_alloy",
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
	ingot = "overworld:gold_bar",
	block = "overworld:gold_block",
})

--silver
foundry.register_metal("silver", {
	description = "Silver",
	texture = "foundry_steel_molten.png",
	ingot = "overworld:silver_bar",
	block = "overworld:silver_block",
})
