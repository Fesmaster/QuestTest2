minetest.log("QTS loading!")
qts = {}
qts_internal = {}

--TODO: Move worldsettings into another file and extend API
qts.WORLDSETTING = Settings(minetest.get_worldpath().."/QTConf.conf")
qts.ISDEV = qts.WORLDSETTING:get("QT_DEV_WORLD") == "true"
if (not qts.ISDEV) then
	qts.WORLDSETTING.set("QT_DEV_WORLD", "false") --makes sure the file contains the key, and exists
end

--TODO: When more functionality needed, move these to another file, and add to. Dont make more registers()
minetest.register_on_joinplayer(function(player)
	minetest.chat_send_all("QuestTest Dev Mode: ".. tostring(qts.ISDEV)) --Testing ONLY
end)

minetest.register_on_shutdown(function()
    qts.WORLDSETTING:write()
end)
