
foundry.registered_casting_recipes = {}
local RCR = foundry.registered_casting_recipes


--[[
name - type name
def contains - {
	block_tiles = {}, --tiles of the casting block
	volume = 1, --default volume of metal to cast
	description = "human readable description"
	
}
]]
function foundry.register_casting_type(name, def)
	def.name = name
	
	def.recipes = {}
	
	
	minetest.register_node ("foundry:"..name.."_mold", {
		description = def.description .. " Mold",
		tiles =def.block_tiles,
		groups = {cracky=3, oddly_breakable_by_hand=2, foundry_mold=1},
		is_ground_content = false,
		sounds = qtcore.node_sound_stone(),
		can_cast = function(pos, node, FD, caster)
			if node.param2 == 0 and FD then
				local Recp = RCR[name].recipes[FD.metalID]
				if Recp then
					--FD:has_metal(1)
					local metalVol = Recp.volume or RCR[name].volume or 1
					return FD:has_metal(metalVol)
				else
					return false
				end
			else
				return false
			end
		end,
		on_cast = function(pos, node, FD, caster)
			--minetest.log("From Caster:\n"..dump(FD))
			--minetest.log("Func Called")
			if node.param2 == 0 and FD then
				local meta = minetest.get_meta(pos)
				local Recp = RCR[name].recipes[FD.metalID]
				if Recp then
					--set metal type
					meta:set_string("metalType", FD.metalID)
					--check metal type
					local metalVol = Recp.volume or RCR[name].volume or 1
				
					if FD:take_metal(metalVol) then
						FD:apply()
						--node world stuff
						node.param2 = 1
						minetest.swap_node(pos, node)
					--else
					--	minetest.log("No Metal")
					end
				end
			end
			
		end,
		on_dig = function(pos, node, digger)
			if node.param2 == 1 then
				--foundry.registered_metals
				local meta = minetest.get_meta(pos)
				local metalID = meta:get_string("metalType")
				--minetest.log("Meta: "..dump(metalID))
				
				if metalID ~= "" then
					local Recp = RCR[name].recipes[metalID]
					
					if Recp then
						minetest.handle_node_drops(pos, {ItemStack(Recp.result)}, digger)
					end
				end
			end
			return minetest.node_dig(pos, node, digger)
		end,
	})

	def.block_name = "foundry:"..name.."_mold"
	RCR[name] = def
end


--[[
rtype = "recepie type" 
def = {
	metal = "metal name",
	volume = 1, --overrides the volume given in recepie type
	result = "itemstring"
}
]]
function foundry.register_casting_recipe(rtype, def)
	if RCR[rtype] then

		local ingotName = ""
		local metalDef = foundry.registered_metals[def.metal]
		if metalDef then
			ingotName = metalDef.ingot
		end
		if def.result ~= ingotName then
			qts.register_reference_craft({
				ingredients = {ingotName .. " " .. (def.volume or RCR[rtype].volume or 1), RCR[rtype].block_name },
				results = {def.result},
				description = "Foundry Casting. Uses metal: " .. def.metal 
			})
		end

		def.rtype = rtype
		def.result = ItemStack(def.result):to_string()
		RCR[rtype].recipes[def.metal] = def
	end
end

