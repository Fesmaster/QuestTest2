# PenTool

PenTool is a system in QuestTest2 designed for world generation. Based on Turtle Graphics, PenTool uses a "pen" in 3D space that can move, drawing nodes into the world as it does.

PenTool was designed to be a replacement for L-System Trees in vanilla Minetest, with more features and significantly more capabilities.

## Basic Structure
A PenTool is essentially a function that takes a PenTool context and moves it around.
A PenTool is broken into two parts: the Context and the Brush.

### PenTool Context
A PenTool Context is the part of a PenTool that exists in 3D space, and moves around. It contains the primary interface that the programmer interacts with.

The basic Context simply does this. Other specialized contexts can be made, for example, a parallel context, which executes the PenTool simultaneously at multiple locations.

Creating a custom PenTool Context is relatively advanced, and if you are up to the task, read the code of current ones for how its done. This document is not intended to cover these details. 

### PenTool Brush
A PenTool Brush is a generic object that implements the interface. It is responsible for actually drawing as the PenTool Context moves. Every Context has a current Brush, and invokes the Brush's `draw(...)` method when moving.

A Brush can choose to draw in any way it chooses. It could use regular `minetest.set_node(...)`, it could use Lua Voxel Manipulator API, or, it could even write to a Lua schematic table, for later insertion.

The Brush is not generally directly interacted with when creating a PenTool, but would be interacted with when creating a custom Context type.

#### The Brush interface

Creating custom brushes for specific jobs should be considered common practice when working with PenTool.

A PenTool brush must implement the following functions:

```lua
{
    draw = function(
        self --[[@type PentoolBrush]], 
        transform --[[@type Transform]], 
        weight --[[@type Alpha]], 
        context --[[@type PentoolContext]]
    ) return end

    copy = function(self --[[@type PentoolBrush]]) 
        return --[[@type PentoolBrush]] 
    end
}
```

Interestingly, a brush can return itself from `copy(...)` if it contains no data.

## PenTool Registration

PenTools can be registered for later use with `qts.pentool.register_tool(...)`.

Registered PenTools can be executed later by calling `qts.pentool.execute_tool(...)`.

This is useful because it allows the behavior of PenTools to be defined one, even if that tool might have several invocation locations.

### Console Commands

PenTool will eventually have console commands to execute a registered PenTool, but this is not yet implemented. 

### PenTool Instancing

Registered PenTools can be Instanced, meaning, you can override the user parameters defined when registering the PenTool. These params can be fetched from the Context to control the PenTool's execution.

Instances can be made at execution time, by providing a table of overrides to `qts.pentool.execute_tool(...)`.

Instances can also be registered, via the function `qts.pentool.register_tool_instance(...)` Registering a PenTool Instance has the same benefits as registering a PenTool itself. Note that a registered PenTool Instance must be registered after its parent. You can also make an instance of a instance, going down as far as you like. The PenTool system will detect and block infinite recursion related to this at execution time. However, this case should never happen unless the underlying data stored in `qts.pentool.registered_instances` is changed manually.



