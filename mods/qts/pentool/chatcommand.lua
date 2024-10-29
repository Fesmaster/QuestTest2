--[[
PenTool Chatcommand

This file creates the PenTool chatcommand to execute a tool at a position.
]]


minetest.register_chatcommand("pentool", {
    params = "<string>, <transform>",
    privs={creative=1},
	description = "Spawn a PenTool object",
	func = function(name, param)
		local args = qts.breakdown_args(param, {"string", "string", "transform"}, minetest.get_player_by_name(name), nil)
        if args then
            if args[1] == "list" then
                --list all pentools
                local sorted = {}                
                for k, _ in pairs(qts.pentool.registered_tools) do
                    sorted[#sorted+1] = k
                end
                for k, _ in pairs(qts.pentool.registered_tool_instances) do
                    sorted[#sorted+1] = k
                end
                table.sort(sorted)
                local message = "Registered PenTools:" 
                for _, name in ipairs(sorted) do
                    message = message .. "\n" .. name
                end
                minetest.chat_send_player(name, message)
                return

            elseif args[1] == "execute" then
                if qts.pentool.is_tool(args[2]) then
                    if transform.check(args[3]) then
                        qts.pentool.execute_tool(args[2], args[3], {})
                    else
                        minetest.chat_send_player(name, "Unable to spawn the PenTool - '"..dump(args[3]).."' is not a transform!")
                    end
                else
                    minetest.chat_send_player(name, "Unable to spawn the PenTool - '"..dump(args[2]).."' is not a tool!")
                end
            end
        else
            minetest.chat_send_player(name, "Unable to spawn the PenTool - invalid arguments!")
        end
	end
})