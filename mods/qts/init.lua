minetest.log("info", "QTS loading!")
qts = {}
qts_internal = {}
qts.path = minetest.get_modpath("qts")
dofile(qts.path.."/worldsettings.lua")
--load the QT2 Settings File
qts.GameSettings = CreateSettingsFunctions(minetest.get_modpath("qts") .. "\\QT2Settings.conf")

dofile(qts.path.."/util.lua")
--any other code here



dofile(qts.path.."/chatcommands.lua")
dofile(qts.path.."/mt_impl.lua")





if qts.ISDEV then
	minetest.register_tool("qts:testingTool", {
		description = "Testing Tool:\nCurrently Removes nodes in radius",
		inventory_image = "qts_testing_tool.png",
		range = 10.0,
		liquids_pointable = true,
		on_use = function(itemstack, user, pointed_thing)
			minetest.log("QTS Testing Tool used")
			if pointed_thing.under then
				nodes = qts.get_nodes_in_radius(pointed_thing.under, 5)
				for i, n in ipairs(nodes) do
					minetest.set_node(n.pos, {name="air"})
				end
			end
		end,
	})
end