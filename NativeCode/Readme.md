# QuestTest2 Custom Native Code

QuestTest2 uses custom Native (C/C++) code for some tasks.

This is loaded into Lua using the `ffi` library.

## Build Instructions: Linux

To generate project files, use premake5

```sh

premake5 gmake2
make config=release_linux
[or]
make config=debug_linux

```

## Build Instructions: Windows

Not Yet!
