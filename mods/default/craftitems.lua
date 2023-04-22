--ingot type object

minetest.register_craftitem("default:refined_clay_lump", {
	description = "Refined Clay",
	inventory_image = "default_refined_clay_lump.png",
})

minetest.register_craftitem("default:tinder", {
	description = "Tinder",
	inventory_image = "default_tinder.png",
})

minetest.register_craftitem("default:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
})

minetest.register_alias("default:brick_single", "default:brick_item")
minetest.register_craftitem("default:brick_item", {
	description = "Brick",
	inventory_image = "default_brick_item.png",
})

minetest.register_craftitem("default:poltice_milfoil", {
	description = "Milfoil Poltice",
	inventory_image = "default_poltice_milfoil.png",
	on_use = minetest.item_eat(2),
})
