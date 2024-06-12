# FFI Investigation and Implementation

## Overview
FFI is a library provided by LuaJIT to load Native C code functions and types into Lua
allowing Lua to bind to shared libraries easily, from Lua, and without the shared libraries
being designed to have Lua bind to them.

Areas of investigation include:
- Custom keybinds
- Developing a strategy for custom Native code modules, including location, compilation, loading, build systems, etc.
- vector type and functions using x64 vector register intrinsics (_m128 or _m256 for float/double)
- accelerating entity/AI code to be faster
- dedicated Lua threads
- Injecting rendering passes for custom rendering
- Document findings

## General learnings

Minetest and Irrlitch are written in C++, which means FFI can only bind to functions declared in `extern "C"` blocks.
This severely limits the available Minetest and Irrlitch API that can be accessed from Lua using FFI.

To `require("ffi")` from Lua, you need an insecure environment. To that end, `qts` now *requires* an insecure 
environment, and will have a hard error if it does not have one.

FFI related code has been placed in `/qts/ffi`, with `ffi_main.lua` being the entry file.

## Custom Keybinds

To read keys, qts has to skip over both Minetest and Irrlitch and go straight to the operating system. This necessitates
dedicated OS functionality in Lua to check the OS and load the right function.

Since the key reading code is OS specific, both loading the function to read the key state and the qts api function to check if a key is pressed need to be defined in an OS specific way.

It is suboptimal to check the OS inside of `qts.is_key_pressed(...)` - better to check it once when loading the game and define
two different versions of the function.

Keybind-related API is in the file `/qts/ffi/keybinds.lua`.

Irrlitch uses a enum (`irr::EKEY_CODE` from Keycodes.h) to provide the key names. Moving this enum to Lua is trivial, and can almost be done with copy-paste. QuestTest2 should stick to using this Enum for all platforms, as its names match the same names used by Minetest for its keybinds. In this way, its possible to read from the config files (`minetest.settings.get(...)`)
and retrieve the keybind name in a compatible format. In the same way, all QuestTest-supplied keybinds should have config variables associated with them.

### Windows

The Windows API offers the following function:

```c
unsigned short GetAsyncKeyState(int vKey);
```

### Linux

Linux is significantly less straightforward that Windows, and looks like it will require a custom library to do a bunch of parsing in C/C++ to interact with Xlib.

Based on how Linux's input system works, we had to break apart keyboard and mouse events. Windows treats the mouse as part of the keyboard.

Several limitations of the Linux implementation:

- We cannot detect Mouse4 and Mouse5 buttons.

## Vector types

Attempting to use `__m128`-based float4 types resulted in code that was several orders of magnitude slower than Minetest Vectors. See profiling below:

```Log
PROFILE: "lua_vector"      Min: 38 us      Max: 403 us     Average: 123.9 us       Total Runs: 10  Total Time: 1239 us
PROFILE: "native_vector"   Min: 186310 us  Max: 355202 us  Average: 248676 us      Total Runs: 10  Total Time: 2486760 us
```

The use of native vectors is deemed "not worth it".
