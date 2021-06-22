--[[
Elements are a system of block - to - block interactions

qts.register_element(name, default_func)

a function that registers an elemental effect
any node that causes the effect needs the group name.."ing"
and any node that receives the effect needs the group name.."able"
and a callback function "on_"..name taking (pos, node, active_object_count, active_object_count_wider)

default_func takes the same params, and is run if that callback function is not found

all element data is saved to qts.registered_element, but is not read from it

--]]

qts.registered_elements = {}


function qts.register_element(name, default_func)
	local function_name = "on_"..name
	local cause_group_name = name.."ing"
	local effect_group_name = name.."able"
	
	--store this info
	qts.registered_elements[name] = {
		name = name,
		function_name = function_name,
		cause_group_name = cause_group_name,
		effect_group_name = effect_group_name,
		default_func = default_func,
	}
	
	minetest.register_abm({
		label = "ELEMENTAL_"..name.."_ABM",
		nodenames = {"group:"..effect_group_name},
		neighbors = {"group:"..cause_group_name},
		interval = 1,
		chance = 1,
		catch_up = false,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local def = minetest.registered_nodes[node.name]
			if (def[function_name]) then
				def[function_name](pos, node, active_object_count, active_object_count_wider)
			else
				default_func(pos, node, active_object_count, active_object_count_wider)
			end
		end,
	})
	
end
