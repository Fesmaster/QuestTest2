---@meta

--[[
    This file contains special content that is never run as LUA, but is used to generate documentation, tooltips, and other intellisence operations.
    It mostly just clones Minetest stuff.
]]

---@class SimpleSoundSpec
---@field name string Sound Name
---@field gain number Sound Gain
---@field pitch number Sound Pitch

---@alias ColorSpec string format: "#RRGGBB[AA]"

---@alias ParamType
---| "light" node contains light data. IE, a node with translucency and not a full block
---| "none" node contains no specific data, and is thus usable by modding

---@alias Param2Type
---| "flowingliquid" Used by drawtype="flowingliquid" and liquidtype="flowing"
---| "wallmounted" Used to cause a node to be connected to another. Supported drawtypes "torchlight", "signlike", "plantlike", "plantlike_rooted", "normal", "nodebox", and "mesh".
---| "facedir" Used to cause a node to be able to rotate. Supported drawtypes "normal", "nodebox", "mesh".
---| "leveled" Used to control node heights. Supported drawtype "nodebox" and "plantlike_rooted"
---| "degrotate" Used to rotate the mesh. Supported drawtype "plantlike" and "mesh"
---| "meshoptions" Used to change drawtype "plantlike" shape
---| "color" Used to pick a color from a pallate of 256 pixels (16x16)
---| "colorfacedir" Everything for facedir but also the color of a 8 pixel pallate (first 3 bits)
---| "colorwallmounted" Everything from wallmounted but also the color of a 32 pixel pallate
---| "colordegrotate" Everything from degrotate but used an 8 pixel pallate of colors
---| "glasslikeliquidlevel" Level of liquid in a "glasslike_framed" or "glasslike_framed_optional" drawtype
---| "none" Param2 byte is free for modding use

---@alias NodeDrawType
---| "normal" A normal node
---| "airlike" Completely invisible
---| "liquid" A liquid sources
---| "flowingliquid" A flowing liquid
---| "glasslike" Partially-Transparent nodes, only external faces drawn
---| "glasslike_framed" Connected-face Partially-Transparent nodes
---| "glasslike_framed_optional" Switches between "glasslike" and "glasslike_framed" per user option (should be preferred over "glasslike_framed" for scalability)
---| "allfaces" like "glasslike", all faces are drawn, but both inside and outside.
---| "allfaces_optional" switches between "normal", "glasslike", and "allfaces" dependant on user leaves setting (Opaque, Simple Fancy Leaves)
---| "torchlike" single vertical texture
---| "signlike" single texture plane placed against the surface (if wallmounted) or against the floor
---| "plantlike" various forms of vertical and near-vertical planes, determined by "meshoptions" Param2Type
---| "firelike" Surface-touching planes, or a box with an x in it
---| "fencelike" A 3D model for fences.
---| "raillike" Upfacing planes that connect. Connects across single vertical slopes
---| "nodebox" Series of boxes determined by the nodebox field
---| "mesh" 3D mesh file (.obj)
---| "plantlike_rooted" a solid node, with a special plant texture drawn above up, up to 16 blocks

---@alias _PointedThingType
---| "nothing" Nothing is pointed atan
---| "node" A node is pointed at
---| "object" An object is pointed at

---@class Pointed_Thing
---@field type _PointedThingType The pointed thing's type
---@field under Vector When type=="node", this hold the node selected
---@field above Vector When type=="node", this holds the node that would be placed over
---@field ref ObjectRef When type=="object", this holds the ObjRef

---@class ObjectRef
---@field get_pos function Get the Position 
---@field set_pos function(pos) `pos`=`{x=num, y=num, z=num}`
---@field get_velocity function() returns the velocity, a vector.
---@field add_velocity function(vel)
---@field move_to function(pos, continuous=false)
---@field punch function(puncher, time_from_last_punch, tool_capabilities, direction)
---@field right_click function(clicker); `clicker` is another `ObjectRef`
---@field get_hp function() returns number of health points
---@field set_hp function(hp, reason) set number of health points
---@field get_inventory function() returns an `InvRef` for players, otherwise returns `nil`
---@field get_wield_list function() returns the name of the inventory list the wielded item is in.
---@field get_wield_index function() returns the index of the wielded item
---@field get_wielded_item function() returns an `ItemStack`
---@field set_wielded_item function(item) replaces the wielded item, returns `true` if successful.
---@field set_armor_groups function({group1=rating, group2=rating, ...})
---@field get_armor_groups function() returns a table with the armor group ratings
---@field set_animation function(frame_range, frame_speed, frame_blend, frame_loop)
---@field get_animation function() returns `range`, `frame_speed`, `frame_blend` and `frame_loop`.
---@field set_animation_frame_speed function(frame_speed)
---@field set_attach function(parent[, bone, position, rotation, forced_visible])
---@field get_attach function() returns parent, bone, position, rotation, forced_visible, or nil if it isn't attached.
---@field get_children function() returns a list of ObjectRefs that are attached to the object.
---@field set_detach function()
---@field set_bone_position function([bone, position, rotation])
---@field get_bone_position function(bone) returns position and rotation of the bone
---@field set_properties function(object property table)
---@field get_properties function() returns object property table
---@field is_player function() returns true for players, false otherwise
---@field get_nametag_attributes function()
---@field set_nametag_attributes function(attributes)

---@class LuaObject : ObjectRef
---@field remove function() - remove the object
---@field set_velocity function(vel) - set the object's velocity
---@field set_acceleration function(acc) - sets the object's acceleraton
---@field get_acceleration function() - gets the object's acceleraton
---@field set_rotation function(rot) - sets the object's rotation via rotation vector in radians
---@field get_rotation function() - gets the object's rotation as a rotation vector in radians
---@field set_yaw function(yaw) - sets the object's yaw in radians
---@field get_yaw function() - gets the object's yaw in radians
---@field set_texture_mod function(mod) - set the texture modifier for when entity takes damage
---@field get_texture_mod function() - get the texture modifier for when the entity takes damage
---@field set_sprite function(start_frame, num_frames, framelength, select_x_by_camera) - set the entity sprite animations.
---@field get_entity_name function() - **DEPRICATED** get the entity's name
---@field get_luaentity function() - get the luatable that the entity is using (the event callback func, custom stuff, etc.)

---@class Player : ObjectRef
---@field get_player_name function() - gets the player name or "" if not a player
---@field get_look_dir function() - get camera direction as unit vector
---@field get_look_vertical function() - camera pitch in radians
---@field get_look_horizontal function() - camera yaw in radians 
---@field set_look_vertical function(radians) - set camera pitch
---@field set_look_horizontal function(radians) - set camera yaw
---@field get_breath function() - get the player breath value. 0=drowning, 
---@field set_breath function(value) - set the player's breath value
---@field set_fov function(fov, is_multiplier, transition_time) - set the player FOV. 
---@field get_fov function() - get the FOV, 0 for no override.
---@field get_meta function() - retuns a PlayerMetaRef
---@field set_inventory_formspec function(formspec_string) - set the inventory formspec
---@field get_inventory_formspec function() - returns inventory formspec string
---@field set_formspec_prepend function(formspec_string) - set the prepend formspec string
---@field get_formspec_prepend function() - gets th prepend formspec string
---@field get_player_control function() - retuns a table with the pressed keys. {up, down, left, right, jump, aux1, sneak, dig, place, zoom}
---@field get_player_control_bits function() - retusn a packed int with the bits set for controls.
---@field set_physics_override function(override_table) - set the player physics override. Prefer QuestTest functions for this.
---@field get_physics_override function() - get the current physics override
---@field hud_add function(hud_def) - add a hud element to the player screen. Retuns an ID handle on success
---@field hud_remove function(ID) - remove an added HUD by its ID.
---@field hud_change function(ID, stat, value) - change a value of previously added HUD element by ID
---@field hud_get function(ID) - get the HUD definition by ID
---@field hud_set_flags function(flags) - set default HUD elements via flags Flags is table with boolean keys: {hotbar, healthbar, crosshair, wielditem, breathbar, minimap, minimap_radar, basic_debug}
---@field hud_get_flags function() - returns a flag table
---@field hud_set_hotbar_itemcount function(count) - set the number of elements in the hotbar
---@field hud_get_hotbar_itemcount function() - get the number of elements in the hotbar
---@field hud_set_hotbar_image function(texturename) - set the background image for the hotbar
---@field hud_get_hotbar_image function() - get the background image for the hotbar
---@field hud_set_hotbar_selected_image function(texturename) - set the selector image for the hotbar
---@field hud_get_hotbar_selected_image function() - get the selector image for the hotbar
---@field set_minimap_modes function({mode, mode, mode ...}, selected_mode) - set the minimap mode. Supply list of modes and the index of selected mode. mode is MinimapMode
---@field get_sky function(as_table) - get the sky. Boolean should be true, otherwise a depricated format will be returned. Very foolish, yes.
---@field set_sun function(SunParams) - set the sun format.
---@field get_sun function() - returns the current SunParams
---@field set_moon function(MoonParams) - set the moon format
---@field get_moon function() - get the current moon params
---@field set_stars function(StarParams) - 
---@field get_stars function() - get the current star params
---@field set_clouds function(CloudParams) - set the current clouds
---@field get_clouds function() - get the current cloud def
---@field override_day_night_ratio function(number|nil) - if not nil, use a 0-1 value to set the day to night ratio
---@field get_day_night_ratio function() - get the current day to night ratio override.
---@field set_local_animation function(idle, walk, dig, walk_while_dig, frame_speed) - set current animation frames. Each animation is a table in the formatL {x=start_frame, y=end_frame}.
---@field get_local_animation function() - the the current animations
---@field set_eye_offset function({firstperson, thirdperson}) - set eye offsets for the camera.
---@field get_eye_offset function() - get the camera eye offsets
---@field send_mapblock function(blockpos) - send a server-loaded mapblock to the player (devide node pos by 16 for mapblock coord). VERY SLOW USE WITH CAUTION
---@field set_lighting function({shadow={intensity=number,0 to 1}}) - set the shadow intensity. 0=no shadows, 1=blackness.
---@field get_lighting function() - get the lighting table (shadows only)

---@class CloudParams type used in the Player:set_clouds() function
---@field density number|nil alpha value of cloud density. 0=no clouds, 1=overcast. Default=0.4
---@field color ColorSpec|nil Cloud color with alpha. Default: "#fff0f0e5"
---@field ambient ColorSpec|nil Cloud minimum color, for glow at night effect. No Alpha. Default: #000000
---@field height number|nil Cloud height. Default from Config, usually 120
---@field thickness number|nil Could thickness in nodes. Default: 16
---@field speed Vector|nil Cloud speed, in nodes per second. Default: {x=0,z=-2}

---@class StarParams type used in the Player:set_stars() function
---@field visible boolean|nil true to make the stars visible. Default: true
---@field count integer|nil number of stars in "regular" and "skybox" skies. Default: 1000
---@field star_color ColorSpec|nil the color of the stars. Alpa is used to set star brightness. Default: #ebebff69
---@field scale number|nil control the star scale. Default is 1.

---@class MoonParams type used in Player:set_moon() function
---@field visible boolean|nil true to make the moon visible. Default:true
---@field texture string|nil texture name for the moon, or "" to re-enable the moon mesh. Default: "moon.png" if it exists. Will be rotated 180 degrees from Sun texture. use "^[transformR180" to undo this.
---@field tonemap string|nil a 512x1 texture contianing the tonemap for the moon. Default: "moon_tonemap.png"
---@field scale number|nil Control the overall sun size. Default: 1

---@class SunParams type used in Player:set_sun() function
---@field visible boolean|nil true to make the sun visible. Default:true
---@field texture string|nil texture name for the sun, or "" to re-enable the sun mesh. Default: "sun.png" if it exists
---@field tonemap string|nil a 512x1 texture contianing the tonemap for the sun. Default: "sun_tonemap.png"
---@field sunrise string|nil a regular texture for sunrise and sunset. Default: "sunrise.png"
---@field sunrise_visible boolean|nil boolean for if the sunrise texture is visible. Default: true
---@field scale number|nil Control the overall sun size. Default: 1

---@class SkyParams type used for Player:set_sky() function
---@field base_color ColorSpec|nil Color for non "regular" types
---@field type SkyType|nil defaults to "regular"
---@field textures table|nil {top(Y+), bottom(Y-), west(X-), east(X+), north(Z+), south(Z-)}
---@field clouds boolean|nil if clouds should appear. Defaults to true
---@field sky_color SkyColorType|nil table used for "regular" sky type

---@class SkyColorType
---@field day_sky ColorSpec|nil Top half of sky during day. Default is "#61b5f5"
---@field day_horizon ColorSpec|nil Bottom half of sky during day. Default is "#90d3f6"
---@field dawn_sky ColorSpec|nil Top half of sky during dawn/sunset. Color is darkened. Default is "#b4bafa"
---@field dawn_horizon ColorSpec|nil Bottom half of sky during dawn/sunset. Color is darkened. Default is "#bac1f0"
---@field night_sky ColorSpec|nil Top half of sky during night. Color is darkened Default is "#006bff"
---@field night_horizon ColorSpec|nil Bottom half of sky during night. Color is darkened Default is "#4090ff"
---@field indoors ColorSpec|nil Sky color when indoors or underground. Default is "#646464"
---@field fog_sun_tint ColorSpec|nil Fog tint from sun at sunrise/sunset. Default is "#f47d1d"
---@field fog_moon_tint ColorSpec|nil Fog tint from moon at sunrise/sunset (?moonrise/moonset?). Default is "#7f99cc"
---@field fog_tint_type FogTintType|nil Fog tint type

---@alias FogTintType
---|"default" - use default minetest tonemaps
---|"custom" - uses fog_sun_tint and fog_moon_tint

---@alias SkyType
---|"regular" - 0 textures, base_color is ignored
---|"skybox" - 6 textures, base_color is fog
---|"plain" - 0 textures, base_color is fog and sky color


---@class MinimapMode type used for Player:set_minimap_modes() function
---@field type MinimapModeType type of minimap
---@field label string|nil Label for the minimap
---@field texture string|nil when type="texture", this is texture to use
---@field scale string|nil when type="texture", this is nodes per pixel

---@alias MinimapModeType
---|"off" no minimap
---|"surface" regular surface minimap
---|"radar" underground radar minimap
---|"texture" texture displayed around 0,0

---@alias HUDStats
---|'position' 
---|'name'
---|'scale'
---|'text'
---|'number'
---|'item'
---|'dir'

---@class NodeRef
---@field name string the node name
---@field param1 number|nil the first param value
---@field param2 number|nil the second param value

---@class Vector
---@field x number
---@field y number
---@field z number
---@operator add(Vector): Vector
---@operator sub(Vector): Vector
---@operator mul(number): Vector
---@operator mul(Vector): Vector
---@operator div(number): Vector
---@operator div(Vector): Vector
---@operator eq(Vector): Vector
---@operator unm(Vector): Vector

vector ={
    ---Creates a new vector. With no params, results in 0 vector. With vector param, makes a copy. Otherwise combines 3 params to vector.
    ---@param a nil|Vector|number
    ---@param b nil|number
    ---@param c nil|number
    ---@return Vector
    new = function(a, b, c) end,
 
    ---Create a zero vector. **DEPRICATED** in vactor of vector.new()
    ---@deprecated
    ---@return Vector
    zero = function() end,

    ---Create a copy of a vector. **DEPRICATED** in vactor of vector.new(v)
    ---@deprecated
    ---@param v Vector
    ---@return Vector
    copy = function(v) end,
 
    ---Create vector from string
    ---@param s string format: "(x, y, z)"
    ---@param init number optional offset into string
    ---@return Vector|nil , number
    from_string = function(s, init) end,
 
    ---Make string from vector
    ---@param v Vector
    ---@return string
    to_string = function(v) end,
 
    ---Get the unit direction from p1 to p2
    ---@param p1 Vector
    ---@param p2 Vector
    ---@return Vector
    direction = function(p1, p2) end,
 
    ---Get the distance from p1 to p2
    ---@param p1 Vector
    ---@param p2 Vector
    ---@return number
    distance = function(p1, p2) end,
 
    ---Get the length of a vector
    ---@param v Vector
    ---@return number
    length = function(v) end,

    ---Returns a normalized vector in the same direction as the supplied vector
    ---@param v Vector
    ---@return Vector
    normalize = function(v) end,

    ---Returns a new vector with each component rounded down
    ---@param v Vector
    ---@return Vector
    floor = function(v) end,
 
    ---Returns a new vector with each component rounded to the nearest int, .5 goes away from 0
    ---@param v Vector
    ---@return Vector
    round = function(v) end,

    ---Returns a Vector where the function func has been applied to each component
    ---@param v Vector
    ---@param func function
    ---@return Vector
    apply = function(v, func) end,

    ---Checks for equality
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return boolean true if they are the same
    equals = function(v1, v2) end,
 
    ---Returns two vectors for minpos, maxpos the cuboid defined by v1, v2
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return Vector minpos, Vector maxpos
    sort = function(v1, v2) end,
 
    ---Returns the angle between v1 and v2 in radians
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return number the angle in radians
    angle = function(v1, v2) end,
 
    ---Dot Product of V1, V2
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return number
    dot = function(v1, v2) end,

    ---Cross Product of v1, v2
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return Vector
    cross = function(v1, v2) end,
 
    ---Returns the sum of V and (x, y, z)
    ---@param v Vector
    ---@param x number
    ---@param y number
    ---@param z number
    ---@return Vector
    offset = function(v, x, y, z) end,

    ---Check if v is a vector
    ---@param v Vector|any
    ---@return boolean
    check = function(v) end,
 
    ---Add two vectors or a vector and a scalar
    ---@param v Vector
    ---@param x Vector|number
    ---@return Vector
    add = function(v, x) end,

    ---Subtract two vectors or a scalar from a vector
    ---@param v Vector
    ---@param x Vector|number
    ---@return Vector
    subtract = function(v, x) end,
 
    ---Multiply a vector by a scalar
    ---@param v Vector
    ---@param s number
    ---@return Vector
    multiply = function(v, s) end,

    ---Divide a vector by a scalar
    ---@param v Vector
    ---@param s number
    ---@return Vector
    divide = function(v, s) end,

    ---Rotate vector by a euler rotation in radians
    ---@param v Vector
    ---@param r Rotator
    ---@return Vector
    rotate=function(v, r) end,

    ---Rotate a vector around axis
    ---@param v1 Vector the vector
    ---@param v2 Vector the axis
    ---@param a number angle in radians
    ---@return Vector
    rotate_around_axis=function(v1, v2, a) end,

    ---Creates a rotation vector from a direction
    ---@param direction Vector the direction
    ---@param up Vector the up vector. If omitted, roll will be 0.
    ---@return Rotator
    dir_to_rotation=function(direction, up) end,
}

---@alias Rotator Vector {x=Pitch, y=Yaw, z=Roll}, uses radians

---@alias LuaEntity table A special table that comes from a luaentity

---Makes a luaobject into a human-readable string
---@param obj any
---@param name string defaults to "_"
---@return string
function dump2(obj, name) end

---Makes a luaobject into a human-readable string
---@param obj any
---@return string
function dump(obj) end

---Get the hypotenuse of a right triangle with leg lengths x, y
---@param x number the first leg
---@param y number the second leg
---@return number the hypotenuse
function math.hypot(x,y) end

---Gets the sign of x
---@param x number
---@param tolerance number default is 0.0
---@return 
---|1 if x is positive
---|-1 if x is negative
---|0 if x is NaN or abs(x) < tolerance
function math.sign(x, tolerance) end

---Factorial of x
---@param x number
---@return number
function math.factorial(x) end

---Round to the nearest integer. .5 goes away from 0
---@param x number
---@return integer
function math.round(x) end

---splits a string
---@param str string the string to split
---@param seperator string the string to split on
---@param include_empty boolean defaults to false. To include emptry strings 
---@param sep_is_pattern boolean defaults to false. Set to true to make the seperator treated as regex
function string.split(str, seperator, include_empty, sep_is_pattern) end

---trims the whitespaces off of the start and end of a string
---@param str string the string to split
---@return string
function string.trim(str) end

---Add newlines to a string to keep it within a limit
---@param str string the string to wrap
---@param limit number max characters per line
---@param as_table boolean true if return should be table. Default is false
---@return string|table
function minetest.wrap_text(str, limit, as_table) end

---Turn a vector into a string
---@param pos Vector|table
---@param decimal_places number decimel place to round to
---@return string "(X, Y, Z)"
function minetest.pos_to_string(pos, decimal_places) end

---Turn a string into a vector if it can
---@param str string "(X, Y, Z)"
---@return Vector | nil
function minetest.string_to_pos(str) end

---Turn a string of two positions into a pair of vectors describing the area
---@param str string "(X1, Y1, Z1) (X2, Y2, Z2)"
---@return Vector minpos, Vector maxpos
function minetest.string_to_area(str) end

---Escapes special characters in a string so it can be used in formspec
---@param str string
---@return string
function minetest.formspec_escape(str) end

---Check if the arg is a true value ("y", "yes", "true" or a nonzero number)
---@param arg string|number
---@return boolean
function minetest.is_yes(arg) end

---returns true when the arg is NaN
---@param arg any
---@return boolean
function minetest.is_nan(arg) end

---Get the current time with millisecond precision. May or may not represent wall time.
---@return number
function minetest.get_us_time() end

---Deep copy of a table
---@param table table
---@return table a deep copy
function table.copy(table) end

---find the first instance of a value in an array-like table
---@param list table
---@param val any
---@return integer -1 if not found, otherwise index.
function table.indexof(list, val) end

---insert all arraylike values in other_table to table in arraylike fashion
---@param table table table to modify
---@param other_table table table to read values from
function table.insert_all(table, other_table) end

---returns a table with the keys and values swapped. Nondeterministic if two values in original are the same
---@param t table
---@return table
function table.key_value_swap(t) end

---Shuffle the elements in an arraylike table
---@param table table
---@param from integer inclusive, defaults to 1
---@param to integer inclusive, default to #table
---@param random_func function defaults to math.random. takes two arguments, and retuns an inclusive random integer between them
function table.shuffle(table, from, to, random_func) end

---Get the facing position of a placer
---@param placer ObjectRef
---@param pointed_thing Pointed_Thing
---@return Vector
function minetest.pointed_thing_to_face_pos(placer, pointed_thing) end

---@class get_dig_params_results
---@field diggable boolean true if node can be dug
---@field time number time to break the node
---@field wear number how much wear should be added to the node

---Simulates that item digging a node with those groups.
---@param groups table node groups
---@param tool_capabilities Tool_Capabilities
---@param wear number current tool wear. Default is 0
---@return get_dig_params_results
function minetest.get_dig_params(groups, tool_capabilities, wear) end

---@class get_hit_params_results
---@field hp number how much damage would be caused
---@field wear number how much wear should be added to the tool

---Simulate an item hitting an entity with these armor groups
---@param groups table entity armor groups
---@param tool_capabilities Tool_Capabilities
---@param time_from_last_punch number time in second since last punch
---@param wear number original wear of the tool
function minetest.get_hit_params(groups, tool_capabilities, time_from_last_punch, wear) end

---@class Perlin_Noise_Params
---@field offset number offset to the noise value added after scaling
---@field scale number scale of the noise value after octaves combined
---@field spread Vector distance on input needed for a large value change on octave 1. Similar to a wavelength.
---@field seed number random seed for the noise
---@field octaves integer number of octaves used
---@field persistence number roughness of noise. scale intensity of each octave as the previous value * this. often 1/lacunarity for a baseline.
---@field lacunarity number the wavelength (spread) of each octive is multiplied by 1/this to get the wavelength of the next octave. often 2.0, so each is half the size of the previous.
---@field flags string Special string values: "defaults", "eased", "absvalue". See docs for more info, its too long to put here.

---@alias Ore_Type
---| "scatter" ore placed randomly by 3D perlin noise
---| "sheet" ore placed by intersection of two 2D perlin noise functions
---| "puff" cloud-like puff shape of ore generation
---| "blob" sphericoid blobs, deformed by 3D perlin noise
---| "vein" varying density described by intersection of two 3D perlin noise. WARNING: ~200 times more computationally expensive than any other ore type.
---| "stratum" single layer of ore that spans mapchunks evenly

---@class Tool_Capabilities
