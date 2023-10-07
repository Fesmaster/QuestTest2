# Scribe for QTS

Scribe is the GUI system designed for QuestTest2, implemented in QTS. It works with `qts.gui`, the GUI management tool natively.

Like all QuestTest2 documentation, we will be using the following format for file names, paths, and similar elements. These can be combined and nested.
* `<field>` - a field you name yourself, or has a specific description on how it is used
* `[optional]` - an optional bit of text
* `(set|of|options)` - a set of options. Exactly one must be chosen.
* `{set|of|options}` - a set of options. More than one may be chosen, separated by a dash (`-`)

## Design Principles

## Practical Usage Examples

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