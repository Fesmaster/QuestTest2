--[[
    FFI is used to load native C types into lua environment.

    This is used to push Minetest well beyond its designed limits.
--]]

QTSNativeCommon = nil

ffi.cdef([[
void ModuleStartup();
void ModuleShutdown();


void CheckOpenGLCompat();
]])

local path = ""
if ffi.os == "Linux" then
    ffi.cdef([[
        bool IsKeyPressed(int KeyCode);
    ]])
    path = qts.path .. "/../../NativeCode/bin/Release/libQTSCommon.so"
elseif ffi.os == "Windows" then
    path = qts.path .. "/../../NativeCode/bin/Release/QTSCommon.dll"
end

QTSNativeCommon = ffi.load(path)
if QTSNativeCommon == nil then
    error("Issue loading QTS Native Code! OS: ".. ffi.os .. ". Path loaded: " .. path)
end

QTSNativeCommon.ModuleStartup()
minetest.register_on_shutdown(function()
    QTSNativeCommon.ModuleShutdown()
end)

dofile(qts.path.."/ffi/keybinds.lua")

--[[
minetest.register_chatcommand("checkgl", {
	params = "none",
	description = "check if OpenGL can be used from Native Code",
	func = function(name, param)
		QTSNativeCommon.CheckOpenGLCompat()
	end
})
--]]