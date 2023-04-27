
qts.register_craft({
	ingredients = {"group:wood"},
	results = {"craftable:tinder 4"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:wood"},
	results = {"craftable:stick 16"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:leaves"},
	results = {"craftable:tinder"},
	held = {"group:knife"},
})
qts.register_craft({
	ingredients = {"group:underbrush"},
	results = {"craftable:tinder"},
	held = {"group:knife"},
})

--tinderbox
qts.register_craft({
	ingredients = {"group:wood", "craftable:tinder", "overworld:flint"},
	results = {"craftable:tinderbox"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"group:wood 5"},
	results = {"craftable:campfire"},
})

qts.register_craft({
	ingredients = {"craftable:brick_item 4"},
	results = {"craftable:brick"},
	near = {"group:workbench"},
})

qts.register_craft({
	ingredients = {"default:lime", "group:sand 4"},
	results = {"craftable:cement 4"},
})

--paper and books
qts.register_craft({
	ingredients = {"default:reeds 2"},
	results = {"craftable:paper"},
})

qts.register_craft({
	ingredients = {"craftable:paper 2"},
	results = {"craftable:book"},
})

--torch
qts.register_craft({
	ingredients = {"group:wood", "group:coal"},
	results = {"craftable:torch 4",},
})

--sifter
qts.register_craft({
	ingredients = {"group:wood 4", "default:underbrush_item 4"},
	results = {"craftable:sifter"},
	near = {"group:workbench"},
})


--workbenches
qts.register_craft({
	ingredients = {"group:wood 4"},
	results = {"default:workbench",},
})

qts.register_craft({
	ingredients = {"default:workbench", "default:iron_bar 4"},
	results = {"default:workbench_heavy",},
})

--bricks
qts.register_craft({
	ingredients = {"group:gray_stone"},
	results = {"craftable:brick_gray"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"group:brick"},
	results = {"craftable:brick"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"craftable:brick"},
	results = {"craftable:brick_wall"},
	near = {"group:workbench_heavy"},
})
qts.register_craft({
	ingredients = {"craftable:brick_gray"},
	results = {"craftable:brick_gray_wall"},
	near = {"group:workbench_heavy"},
})
