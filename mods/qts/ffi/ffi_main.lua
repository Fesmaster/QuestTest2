--[[
    FFI is used to load native C types into lua environment.

    This is used to push Minetest well beyond its designed limits.
--]]

QTSNativeCommon = nil

ffi.cdef([[
void ModuleStartup();
void ModuleShutdown();

]])

if ffi.os == "Linux" then
    ffi.cdef([[
        bool IsKeyPressed(int KeyCode);
    ]])
    QTSNativeCommon = ffi.load(qts.path .. "/../../NativeCode/bin/Release/libQTSCommon.so")
elseif ffi.os == "windows" then
    QTSNativeCommon = ffi.load(qts.path .. "/../../NativeCode/bin/Release/QTSCommon.dll")
end
QTSNativeCommon.ModuleStartup();
minetest.register_on_shutdown(function()
    QTSNativeCommon.ModuleShutdown();
end)

--/media/electra/InternalStorage/Minetest/minetest-source/bin/../games/QuestTest2/mods/qts../../NativeCode/bin/Release/libQTSCommon.so
dofile(qts.path.."/ffi/keybinds.lua") --non-vector math
