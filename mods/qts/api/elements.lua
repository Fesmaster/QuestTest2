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

local registered_elements = {}

--[[
	Register a new element.  
	Elements are a type of defaulted block-to-block interaction, using groups, ABMs, and functions.  

	Params:  
		name - the element name, a string. This is important later.  
		default_func(pos, node, active_object_count, active_object_count_wider)
			- The default function this element should apply when it is triggered, if not overriden by a block's definition.
			this function is called on blocks that receive the elemental effect.  

	How to use:  
		Nodes can be effected by or cause an elemental effect by groups.  
		* If the node has the "<name>ing" group, it causes the elemental effect in other nodes.  
		* If the node has the "<name>able" group, it can have the effect caused to it.  
		* If the receiving group has a function `on_<name>(pos, node, active_object_count, active_object_count_wider)` then
		it uses this function to reply instead of the default function.  
]]
function qts.register_element(name, default_func)
	local function_name = "on_"..name
	local cause_group_name = name.."ing"
	local effect_group_name = name.."able"
	
	--store this info
	registered_elements[name] = {
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
