# Scribe for QTS

Scribe is the GUI system designed for QuestTest2, implemented in QTS. It works with `qts.gui`, the GUI management tool natively.

Like all QuestTest2 documentation, we will be using the following format for file names, paths, and similar elements. These can be combined and nested.
* `<field>` - a field you name yourself, or has a specific description on how it is used
* `[optional]` - an optional bit of text
* `(set|of|options)` - a set of options. Exactly one must be chosen.
* `{set|of|options}` - a set of options. More than one may be chosen, separated by a dash (`-`)

This document is for the Scribe V1

## Terminology
* Context - Scribe uses an object called a Context to create the GUI. The context contains the functions that create the GUI elements (Forms)
* Context Function - a function, passed a single Context object, that creates GUI Forms
* Form - a specific GUI element, such as a container, a button, a checkbox, a text entry, etc.
* Definition - Each Form has a definition that describes the form's properties
* Child Forms - Some Forms are containers for other Forms, called Child Forms
* Child Context - When a form can take Child Forms, the Child Forms are created from a Child Context, not the same context as the parent Form.
* Event - an object describing a GUI event
* Callback - a function connected to a form that is called when an Event is created for that form. The only parameter to the Callback is the Event.

## Design

When building Scribe, these design goals were the driving force behind the decisions:
1. Easy to write
2. Easy to read and understand
3. Strong organization of the Forms
4. Create good looking and style-able GUIs

### Differences from Formspec

To this end, there are several major deviations from Formspec:
1. List-type containers are a must. Exactly positioning each element is a waste of the programmer's time and a waste of Code. Let Scribe handle that in most cases.
2. Collapse the many types and subtypes of Formspec into major types (I am looking at you, buttons)
3. Avoid using Formspec elements that cannot be styled (tabheader, label, checkbox, etc)

Not every type from formspec is (at time of writing) available in Scribe, notable missing elements include the textlist and the table.

**To Note**:
Scribe provides an automatic calculation of scrollbar ticks and size.
This is calculated according to the algorithm:
```
ticks = ceil((internal_list_size - external_list_size)*10)
paging_size = floor(external_list_size / internal_list_size * ticks)
```
With `internal_list_size` being the length of the content inside the scrollbox (I.E., number of lines in a document) and `external_list_size` being the side length of the scrollbox (IE, number of lines visible at one time).

This algorithm is not documented anywhere we could find in Minetest, but seems to be how Minetest handles the calculations. This is part of the Formspec translation layer.


### Data Transitions

Scribe is not designed to be a "Fancy Formspec", or even rely on Formspec at all.
Scribe could easily have its back-end replaced with a different GUI system.

There are three layers to the GUI data as it passes through Scribe:
1. The Context Function and Form Definitions (User-created)
2. Scribe's internal format
3. Backend (Formspec)

The link between Scribe's internal format and Formspec is a simple translation layer - the entirety of the Scribe API, styling, etc. happens when creating the internal format.

This would allow Scribe to be ported to other GUI backends by swapping out the translation layer between the internal format and the backend.

### Contexts and Functions

Scribe uses a function-based approach, where each GUI is described by a method operating on a Context. The Context creates the GUI Forms by having its methods called.

The Context is a table:
```lua
{
	player=PlayerRef,
	position=Vector,
	name=GUI name,
	userdata={},
	formdata=Black Box,
	callbacks={},
}
```
Context tables also have their metatable set, giving them access to the previously mentioned methods. (These are defined in /mods/qts/scribe/context.lua, `qts.scribe.context_base`)

Notably, the Context contains a field called formdata, which should be treated as a black box when working with Scribe. It contains the internal transitory data for Forms before they are converted into Formspec. Modifying it might not result in a stable experience, and may not work between updates.

`userdata` is a table containing user-controllable data. Scribe does write some fields in here, for example, the checked state of toggleable buttons and which tab is selected in a tabheader.

When a Form has children, it passes a Context Function to the method creating it. This function receives a new Context, with some of the same fields as the parent context, namely:
* player
* position
* name
* userdata
* callbacks

Every method for a Context returns that context, allowing the calls to be strung together.

This results in an expressive API that is highly readable and should not contain too much bloat.

It can be difficult to remember where you are when in a large GUI, as the code does start to occupy many lines, so comments are important.

Because of the functional nature of Scribe, creating reusable GUI elements is as simple as creating a function that takes a context. To use the function, call it with your context. A library of such functions will be provided under `qts.scribeEXT.{}` at some point in the future.

### Forms

Forms are created by calling a method in a Context. (There are some methods that do not create forms, those are discussed later.) These methods take a definition, or, table of fields describing the Form, and other paramaters needed for that form. Most often, those other parameters come in the form of a callback function of a Child Context Function.

The current (at time of writing) Scribe Forms are:
* container
* vertical_box
* horizontal_box
* text
* text_entry
* image
* rect
* separator
* button
* inventory
* model
* tabheader

Some Forms have an optional name field. In practice, this should always be filled with the name of the form. This name is used to associate the Form with the callback. If it is left out, Scribe will assign a transitory name to the Form, but this name changes each time the Form is re-drawn.

Unless otherwise specified, the fields of a Form Definition are all optional. However, the GUI will likely not look good unless you utilize these fields to make it look good.

For details on the exact forms, there is extensive comments in /mods/qts/scribe/context.lua, including lua documentation comments. These comments are written in such a way as to give good intelliscence behavior for the Lua Language Server VSCode plugin ([Lua Language Server](https://marketplace.visualstudio.com/items?itemName=sumneko.lua))

### Other Context Methods

Contexts contain several other methods that do not create Forms.

* `context:quit_callback(...)` - Adds a callback to the quit event.
* `context:refresh_callback(...)` - Adds a callback to the refresh (redraw) event.
* `context:named_callback(...)` - Adds a callback to a specific name. If that name has an event, this will be called. This is useful when adding two callbacks to the same name.
* `context:set_style(...)` - Sets the style of the GUI for the Forms created by this context.
* `context.create(...)` - Creates a brand-new context. Usually better to call `qts.scribe.new_context(...)`. This function is static and does not actually take a self-reference.
* `context:child()` - Create a child context. You should never need to call this, it is used internally by the Form creating methods.
* `context:generate_formspec()` - Creates and returns a Formspec string from the Context in its current state. Should not be called on Child Contexts.
* `context:show_gui()` - Opens the GUI created by the context. Should not be called on Child Contexts.
* `context:get_element_defaults(...)` - Get the style defaults for a specific element name. This function is used by the Form creation methods to apply styles.
* `context:enable_debug_printing(...)` - Turn on debug printing for the context. When the context is shown as a GUI via the `show_gui()` method or via `qts.gui.show_gui(...)`, debug printing will print the entire formspec string to the log. It is undefined if this creates the formspec twice.


### Events

Some forms will call a supplied callback event. The Scribe Event is a table:
```lua
{
	player=PlayerRef,
	position=Vector,
	name=GUI name,
	userdata={},
	fields={},
	callbacks={},
	<other fields>
}
```

There are other fields in an Event, but these should always be treated as a Black Box. Changing them may result in unstable behavior, and they are not guaranteed to stay the same between updates.

The fields table is the Formspec fields. This is the strongest Scribe is coupled to Formspec, and work will be done to decouple this too.

Some fields of an event are the same data as the Context that created the GUI. Namely:
* player
* position'
* name
* userdata
* callbacks

Callbacks are a function that takes an Event as a single parameter. Some Forms (a button, for example), take a Callback function that gets called when the Form is interacted with.

Scribe Events have several methods that can be called on them to mark the GUI for refresh or for close:
```lua
event:mark_for_refresh()
event:mark_for_close()
```

### Constants

Scribe defines several Enums for various GUI uses:

* `qts.scribe.visibility` - The type for the visibility field of Form definitions. 
  * VISIBLE - the Form is visible
  * HIDDEN - the Form is invisible, but still takes up space.
  * COLLAPSED - the Form is invisible and does not take up space.
* `qts.scribe.allignment` - The type for alignment specifiers.
  * MIN
  * LEFT
  * TOP
  * CENTER
  * MAX
  * RIGHT
  * BOTTOM
  * JUSTIFY - this is only used for text.
* `qts.scribe.inventory_source` - The type used to describe where an inventory is coming from
  * CURRENT_NODE - the metadata of the node at the location of `position` in the Context
  * CURRENT_PLAYER - the inventory of the Player in the Context
  * SPECIFIC_PLAYER - a player specified in the Form Definition
  * SPECIFIC_NODE - the metadata of a node position specified in the Form Definition
  * DETACHED - a detached inventory named in the Form Definition

### Styles

Scribe allows styles to be defined. A Style is essentially a set of default fields for Forms, along with some more general fields that apply to the entire UI. (Inventory slot colors, for example)

A style is a table of Form definition tables, and a few other parameters. See /mods/qtcore/GUI_Stormcloud.lua for an example of a style.

Further work with styles will include defining them in a hierarchical manner, allowing one style to be a "child" of another, gaining everything the parent style has plus whatever changed in the child.

### Integration with `qts.gui`

Scribe integrates directly with the `qts.gui` GUI management system. The function `qts.gui.register_scribe_gui(name, function(context) ... end)` registers a GUI that uses a Scribe Context Function, and it can be displayed like a normal GUI registered with `qts.gui`. For an example, see the practical example below. 

### Practical Usage Examples

For a practical example, please see /mods/dtools/gui_elements.lua. This GUI is designed to be both a teststand for creating styles, but also a good introduction into Scribe. Scribe GUIs tend to have many lines of code, so this document will not be bloated by adding an example here.


## Naming Conventions

### Styles
QuestTest2 uses a specific naming convention for scribe style images, the lua files that describe the styles, and how the styles are names.

Textures designed for specific Forms use different formats for their names.

* Backgrounds: `GUI_<stylename>_BG_<width>x<height>.png`
   * `<width>` and `<height>` are the width and height of the image
* Backgrounds: (9-patch): `GUI_<stylename>_BG_[<corners>_]<width>x<height>_M<middle>.png`
   * `<corners>` is a bitfield, ie, a four-digit number with digits being 0 or 1, representing which corners have decoration, starting clockwise from the upper-right corner. See the examples in QTCore.
   * `<width>` and `<height>` are the width and height of the image
   * `<middle>` is a field describing how the middle is formatted. It can be 1, 2, or 4 numbers seperated by a dash (`-`).
     * One number - the padding from the edge for all edges
     * Two numbers - the padding from the edge for x and y
     * Four numbers - the padding from the edge in x-, y-, x+, y+ order. (right, top, left, bottom)
* Button: `GUI_<stylename>_Button_(normal|hovered|pressed|all)_[<corners>_]<width>x<height>[_M<middle>].png` 
   * All fields the same as background
* Toggle Button: `GUI_<stylename>_Toggle_(on|off)_(normal|hovered|pressed|all)_[<corners>_]<width>x<height>[_M<middle>].png`
   * All fields the same as background
* Tab: `GUI_<stylename>_Tab_{top|bottom|left|right}_[(on|off)_](normal|hovered|pressed)_[<corners>_]<width>x<height>[_M<middle>].png`
   * All fields the same as background
   * Since Minetest provides a way to rotate textures, some styles may choose to use this for some tab combinations, rather than providing more textures. This is advised, as textures are large files and use a lot of video memory, particularly when large. Since UI tends to have large textures to make it look nice, this is something to keep in mind.
* 

It is important to note that GUI styles do *not* use the minetest convention of prefixing the texture name with the modname. This is because the style is ideally not "connected" to a mod in the way normal content is.

Styles are defined in their own Lua files, `\<modname>\GUI_<stylename>.lua`.

GUI Styles are named `<modname>:<stylename>` in all lowercase.

# Future Work

Scribe is currently experimental, and is actively being improved. The below is a list of desired features:
* Style inheritance.
* Decouple Events from Formspec field table
* Potentially add support for more Formspec types (textlist and table to be considered).
* ScribeEXT extension library (potentally scribe_ext)
* Vertical text rendering
* Markdown->Minetest hypertext conversion
* Dropdowns (probably implemented with buttons - no way to style Formspec dropdown)
* Front windows (neede for button dropdown, openable hits / group selectors / color selectors)
