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

---@alias PointedThing_Type
---| "nothing" Nothing is pointed atan
---| "node" A node is pointed at
---| "object" An object is pointed at

---@class PointedThing
---@field type PointedThing_Type The pointed thing's type
---@field under Vector When type=="node", this hold the node selected
---@field above Vector When type=="node", this holds the node that would be placed over
---@field ref ObjectRef When type=="object", this holds the ObjRef

---@alias Alpha number range 0 to 1 only

---@alias Radians number

---@alias HPChangeReason
---|"set_hp" the hp was set by function
---|"punch" the object was punched
---|"fall" the object took fall damage
---|"node_damage" the object was inside a node that damaged it
---|"drown" the object was underwater too long
---|"respawn" the object was respawned with full HP

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

---@alias HudID number

---@alias HUDStats
---|'position' 
---|'name'
---|'scale'
---|'text'
---|'number'
---|'item'
---|'dir'


---@class ObjectRef
local ObjectRef = {

    ---Get the object position
    ---@return Vector
    get_pos = function(self) end,

    ---Set the position
    ---@param pos Vector
    set_pos = function(self, pos) end,
    
    ---Get the object velocity
    ---@return Vector
    get_velocity = function(self) end,
    
    ---Add velocity to the object
    ---@param vel Vector
    add_velocity = function(self, vel) end,

    ---Move the object to a location
    ---@param pos Vector the location
    ---@param continuous boolean? if should slide, default is false
    move_to = function(self, pos, continuous) end, --
    
    ---Punch the object
    ---@param puncher ObjectRef
    ---@param time_from_last_punch number
    ---@param tool_capabilities table
    ---@param direction Vector
    punch = function(self, puncher, time_from_last_punch, tool_capabilities, direction) end, --
    
    ---Rightclick an Object
    ---@param clicker ObjectRef
    right_click = function(self, clicker) end, --; `clicker` is another `ObjectRef`
    
    --- returns number of health points
    ---@return number health
    get_hp = function(self) end, 

    ---set number of health points
    ---@param hp number
    ---@param reason? HPChangeReason
    set_hp = function(self, hp, reason) end, -- 
    
    ---returns an `InvRef` for players, otherwise returns `nil`
    ---@return InvRef|nil
    get_inventory = function(self) end,
    
    ---Get the name of inventory list the wielded item is in. Player only
    ---@return string|nil
    get_wield_list = function(self) end,
    
    ---Get the index of wielded item. Player only
    ---@return integer|nil
    get_wield_index = function(self) end,

    ---Get the wielded item. Player Only
    ---@return ItemStack|nil
    get_wielded_item = function(self) end, -- returns an `ItemStack`

    ---Set the wielded item. Player Only
    ---@param item ItemStack
    set_wielded_item = function(self, item) end, -- replaces the wielded item, returns `true` if successful.
    
    ---Set the armor groups for the entity
    ---@param groups table<string, number>
    set_armor_groups = function(self, groups) end,
    
    ---Get the armor groups
    ---@return table<string, number>
    get_armor_groups = function(self) end,
    
    ---Set the currently playing animation
    ---@param frame_range {x:number, y:number}
    ---@param frame_speed number
    ---@param frame_blend number
    ---@param frame_loop boolean
    set_animation = function(self, frame_range, frame_speed, frame_blend, frame_loop) end, --

    ---get the currently playing animation
    ---@return {x:number,y:number} range, number speed, number blend, boolean loop
    get_animation = function(self) end, -- returns `range`, `frame_speed`, `frame_blend` and `frame_loop`.

    ---Set the current animation speed
    ---@param frame_speed number
    set_animation_frame_speed = function(self, frame_speed) end, --
    
    ---Attach one entity to another
    ---@param parent ObjectRef
    ---@param bone string "" is root bone
    ---@param position Vector relative to bone
    ---@param rotation Rotator relative to bone
    ---@param forced_visible boolean set to true to force it to appear in first person
    set_attach = function(self, parent, bone, position, rotation, forced_visible) end, --

    ---returns attachment or nil
    ---@return nil | ObjectRef parent, string bone, Vector position, Rotator rotation, boolean force_visible
    get_attach = function(self) end,
    
    ---Return the children attached to this object
    ---@return ObjectRef[]
    get_children = function(self) end,
    
    ---Unknwon, no documentation
    set_detach = function(self) end,
    
    ---Set the position of a given bone.
    ---@param bone string "" for root bone
    ---@param position Vector
    ---@param rotation Rotator
    set_bone_position = function(self, bone, position, rotation) end, --

    ---Get the position and rotation of a given bone
    ---@param bone string "" for root
    ---@return Vector position, Rotator rotation
    get_bone_position = function(self, bone) end,
    
    ---Set the object protperties
    ---@param properties EntityProperties
    set_properties = function(self, properties) end, --
    
    ---Returns object property table
    ---@return EntityProperties
    get_properties = function(self) end, --

    --- returns true for players, false otherwise
    ---@return boolean is_player
    is_player = function(self) end, --
    
    ---Get nametag attributes
    ---@return {text:string, color:ColorSpec, bgcolor:ColorSpec|false} attributes
    get_nametag_attributes = function(self) end, --
    
    ---Set Nametag Attributes
    ---@param attributes {text:string, color:ColorSpec, bgcolor:ColorSpec|false}
    set_nametag_attributes = function(self, attributes) end, --
}



---@class LuaObject : ObjectRef
local LuaObject = {

    ---remove the object
    remove = function(self) end,
    
    ---set the object's velocity
    ---@param vel Vector
    set_velocity = function(self, vel) end,
    
    ---sets the object's acceleraton
    ---@param acc Vector
    set_acceleration = function(self, acc) end,
    
    ---gets the object's acceleraton
    ---@return Vector
    get_acceleration = function(self) end,
    
    ---sets the object's rotation via rotation vector in radians
    ---@param rot Rotator
    set_rotation = function(self, rot) end,
    
    ---gets the object's rotation as a rotation vector in radians
    ---@return Rotator
    get_rotation = function(self) end,
    
    ---sets the object's yaw in radians
    ---@param yaw Radians
    set_yaw = function(self, yaw) end,
    
    ---gets the object's yaw in radians
    ---@return Radians
    get_yaw = function(self) end,
    
    ---set the texture modifier for when entity takes damage
    ---@param mod string
    set_texture_mod = function(self, mod) end,
    
    ---get the texture modifier for when the entity takes damage
    ---@return string
    get_texture_mod = function(self) end,
    
    ---set the entity sprite animations.
    ---@param start_frame {x:integer, y:integer}
    ---@param num_frames integer
    ---@param framelength number
    ---@param select_x_by_camera boolean
    set_sprite = function(self, start_frame, num_frames, framelength, select_x_by_camera) end,
    
    ---**DEPRICATED** get the entity's name
    ---@deprecated
    ---@return string
    get_entity_name = function(self) end,
    
    --- get the luatable that the entity is using (the event callback func, custom stuff, etc.)
    ---@return LuaEntity
    get_luaentity = function(self) end,
    
}



---@class Player : ObjectRef
local Player = {
    --- gets the player name or "" if not a player
    ---@return string
    get_player_name = function(self) end,
    
    --- get camera direction as unit vector
    ---@return Vector
    get_look_dir = function(self) end,
    
    --- camera pitch in radians
    ---@return Radians
    get_look_vertical = function(self) end,
    
    --- camera yaw in radians
    ---@return Radians 
    get_look_horizontal = function(self) end,
    
    --- set camera pitch
    ---@param radians Radians
    set_look_vertical = function(self, radians) end,
    
    --- set camera yaw
    ---comment
    ---@param radians Radians
    set_look_horizontal = function(self, radians) end,
    
    ---get the player breath value. 0=drowning,
    ---@return number 
    get_breath = function(self) end,
    
    --- set the player's breath value
    ---comment
    ---@param value number
    set_breath = function(self, value) end,
    
    --- set the player FOV.
    ---@param fov number
    ---@param is_multiplier boolean
    ---@param transition_time number
    set_fov = function(self, fov, is_multiplier, transition_time) end,
    
    --- get the FOV, 0 for no override.
    ---@return number fov, boolean is_multiplier, number transition_time 
    get_fov = function(self) end,
    
    --- get the player metadata reference
    ---@return PlayerMetaRef
    get_meta = function(self) end,
    
    --- set the inventory formspec
    ---comment
    ---@param formspec_string string
    set_inventory_formspec = function(self, formspec_string) end,
    
    --- returns inventory formspec string
    ---@return string
    get_inventory_formspec = function(self) end,
    
    --- set the prepend formspec string
    ---comment
    ---@param formspec_string string
    set_formspec_prepend = function(self, formspec_string) end,
    
    --- gets th prepend formspec string
    ---@return string
    get_formspec_prepend = function(self) end,
    
    --- retuns a table with the pressed keys.
    ---@return {up:boolean, down:boolean, left:boolean, right:boolean, jump:boolean, aux1:boolean, sneak:boolean, dig:boolean, place:boolean, zoom:boolean}
    get_player_control = function(self) end,
    
    --- retusn a packed int with the bits set for controls.
    ---@return integer
    get_player_control_bits = function(self) end,
    
    --- set the player physics override. Prefer QuestTest functions for this.
    ---comment
    ---@param override_table {speed:number,jump:number,gravity:number,sneak:boolean,sneak_glitch:boolean,new_move:boolean}
    set_physics_override = function(self, override_table) end,
    
    --- get the current physics override
    ---@return {speed:number,jump:number,gravity:number,sneak:boolean,sneak_glitch:boolean,new_move:boolean}
    get_physics_override = function(self) end,
    
    --- add a hud element to the player screen. Retuns an ID handle on success
    ---comment
    ---@param hud_def HudDefinition
    ---@return HudID
    hud_add = function(self, hud_def) end,
    
    --- remove an added HUD by its ID.
    ---comment
    ---@param ID HudID
    hud_remove = function(self, ID) end,
    
    --- change a value of previously added HUD element by ID
    ---comment
    ---@param ID HudID
    ---@param stat "position"|"name"|"scale"|"text"|"number"|"item"|"dir"
    ---@param value Vector|string|number|ItemStack
    hud_change = function(self, ID, stat, value) end,
    
    --- get the HUD definition by ID
    ---comment
    ---@param ID HudID
    ---@return HudDefinition
    hud_get = function(self, ID) end,
    
    --- set default HUD elements via flags Flags is table with boolean keys:
    ---comment
    ---@param flags {hotbar:boolean, healthbar:boolean, crosshair:boolean, wielditem:boolean, breathbar:boolean, minimap:boolean, minimap_radar:boolean, basic_debug:boolean}
    hud_set_flags = function(self, flags) end,
    
    --- returns a flag table
    ---@return {hotbar:boolean, healthbar:boolean, crosshair:boolean, wielditem:boolean, breathbar:boolean, minimap:boolean, minimap_radar:boolean, basic_debug:boolean}
    hud_get_flags = function(self) end,
    
    --- set the number of elements in the hotbar
    ---comment
    ---@param count integer
    hud_set_hotbar_itemcount = function(self, count) end,
    
    --- get the number of elements in the hotbar
    ---@return integer
    hud_get_hotbar_itemcount = function(self) end,
    
    --- set the background image for the hotbar
    ---comment
    ---@param texturename string
    hud_set_hotbar_image = function(self, texturename) end,
    
    --- get the background image for the hotbar
    ---@return string
    hud_get_hotbar_image = function(self) end,
    
    --- set the selector image for the hotbar
    ---comment
    ---@param texturename string
    hud_set_hotbar_selected_image = function(self, texturename) end,
    
    --- get the selector image for the hotbar
    ---@return string
    hud_get_hotbar_selected_image = function(self) end,
    
    --- set the minimap mode. Supply list of modes and the index of selected mode. mode is MinimapMode
    ---comment
    ---@param modes {type:"off"|"surface"|"radar"|"texture", label:string, size:number, texture:string?, scale:number?}[]
    ---@param selected_mode integer
    set_minimap_modes = function(self, modes, selected_mode) end,
    
    ---Set the sky
    ---@param sky? {base_color:ColorSpec, type:"regular"|"skybox"|"plain", textures:string[], clouds:boolean, sky_color:SkyColorType?}
    --[[
        
     * `base_color`: ColorSpec, changes fog in "skybox" and "plain".
          (default: `#ffffff`)
        * `type`: Available types:
            * `"regular"`: Uses 0 textures, `base_color` ignored
            * `"skybox"`: Uses 6 textures, `base_color` used as fog.
            * `"plain"`: Uses 0 textures, `base_color` used as both fog and sky.
            (default: `"regular"`)
        * `textures`: A table containing up to six textures in the following
            order: Y+ (top), Y- (bottom), X- (west), X+ (east), Z+ (north), Z- (south).
        * `clouds`: Boolean for whether clouds appear. (default: `true`)
        * `sky_color`: A table used in `"regular"` type only, containing the
          following values (alpha is ignored):
            * `day_sky`: ColorSpec, for the top half of the sky during the day.
              (default: `#61b5f5`)
            * `day_horizon`: ColorSpec, for the bottom half of the sky during the day.
              (default: `#90d3f6`)
            * `dawn_sky`: ColorSpec, for the top half of the sky during dawn/sunset.
              (default: `#b4bafa`)
              The resulting sky color will be a darkened version of the ColorSpec.
              Warning: The darkening of the ColorSpec is subject to change.
            * `dawn_horizon`: ColorSpec, for the bottom half of the sky during dawn/sunset.
              (default: `#bac1f0`)
              The resulting sky color will be a darkened version of the ColorSpec.
              Warning: The darkening of the ColorSpec is subject to change.
            * `night_sky`: ColorSpec, for the top half of the sky during the night.
              (default: `#006bff`)
              The resulting sky color will be a dark version of the ColorSpec.
              Warning: The darkening of the ColorSpec is subject to change.
            * `night_horizon`: ColorSpec, for the bottom half of the sky during the night.
              (default: `#4090ff`)
              The resulting sky color will be a dark version of the ColorSpec.
              Warning: The darkening of the ColorSpec is subject to change.
            * `indoors`: ColorSpec, for when you're either indoors or underground.
              (default: `#646464`)
            * `fog_sun_tint`: ColorSpec, changes the fog tinting for the sun
              at sunrise and sunset. (default: `#f47d1d`)
            * `fog_moon_tint`: ColorSpec, changes the fog tinting for the moon
              at sunrise and sunset. (default: `#7f99cc`)
            * `fog_tint_type`: string, changes which mode the directional fog
                abides by, `"custom"` uses `sun_tint` and `moon_tint`, while
                `"default"` uses the classic Minetest sun and moon tinting.
                Will use tonemaps, if set to `"default"`. (default: `"default"`)
    ]]
    set_sky = function(self, sky) end,

    --- get the sky. Boolean **must** be true, otherwise a depricated format will be returned. Very foolish, yes.
    ---@param as_table true
    ---@return {base_color:ColorSpec?, type:"regular"|"skybox"|"plain", textures:string[], clouds:boolean, sky_color:SkyColorType}
    get_sky = function(self, as_table) end,
    
    --- set the sun format.
    ---@param SunParams? {visible:boolean, texture:string, tonemap:string, sunrise:string, sunrise_visible:boolean, scale:number}
    --[[

    `sun_parameters` is a table with the following optional fields:
        * `visible`: Boolean for whether the sun is visible. (default: `true`)
        * `texture`: A regular texture for the sun. Setting to `""` will re-enable the mesh sun. (default: "sun.png", if it exists)
        * `tonemap`: A 512x1 texture containing the tonemap for the sun (default: `"sun_tonemap.png"`)
        * `sunrise`: A regular texture for the sunrise texture. (default: `"sunrisebg.png"`)
        * `sunrise_visible`: Boolean for whether the sunrise texture is visible. (default: `true`)
        * `scale`: Float controlling the overall size of the sun. (default: `1`)
    ]]
    set_sun = function(self, SunParams) end,
    
    --- returns the current SunParams
    ---@return {visible:boolean, texture:string, tonemap:string, sunrise:string, sunrise_visible:boolean, scale:number}
    get_sun = function(self) end,
    
    --- set the moon format
    ---comment
    ---@param MoonParams? {visible:boolean, texture:string, tonemap:string, scale:number}
    --[[

    `moon_parameters` is a table with the following optional fields:
        * `visible`: Boolean for whether the moon is visible.
            (default: `true`)
        * `texture`: A regular texture for the moon. Setting to `""`
            will re-enable the mesh moon. (default: `"moon.png"`, if it exists)
            Note: Relative to the sun, the moon texture is rotated by 180°.
            You can use the `^[transformR180` texture modifier to achieve the same orientation.
        * `tonemap`: A 512x1 texture containing the tonemap for the moon
            (default: `"moon_tonemap.png"`)
        * `scale`: Float controlling the overall size of the moon (default: `1`)
    ]]
    set_moon = function(self, MoonParams) end,
    
    --- get the current moon params
    ---@return {visible:boolean, texture:string, tonemap:string, scale:number}
    get_moon = function(self) end,
    
    --- 
    ---Set the stars
    ---@param StarParams? {visible:boolean, count:integer, star_color:ColorSpec, scale:number}
    --[[

     `star_parameters` is a table with the following optional fields:
        * `visible`: Boolean for whether the stars are visible.
            (default: `true`)
        * `count`: Integer number to set the number of stars in
            the skybox. Only applies to `"skybox"` and `"regular"` sky types.
            (default: `1000`)
        * `star_color`: ColorSpec, sets the colors of the stars,
            alpha channel is used to set overall star brightness.
            (default: `#ebebff69`)
        * `scale`: Float controlling the overall size of the stars (default: `1`)
    ]]
    set_stars = function(self, StarParams) end,
    
    --- get the current star params
    ---@return {visible:boolean, count:integer, star_color:ColorSpec, scale:number}
    get_stars = function(self) end,
    
    --- set the current clouds
    ---comment
    ---@param CloudParams? {density:Alpha, color:ColorSpec, ambient:ColorSpec, thickness:number, speed:{x:integer,y:integer}|Vector}
    --[[

    `cloud_parameters` is a table with the following optional fields:
        * `density`: from `0` (no clouds) to `1` (full clouds) (default `0.4`)
        * `color`: basic cloud color with alpha channel, ColorSpec
          (default `#fff0f0e5`).
        * `ambient`: cloud color lower bound, use for a "glow at night" effect.
          ColorSpec (alpha ignored, default `#000000`)
        * `height`: cloud height, i.e. y of cloud base (default per conf,
          usually `120`)
        * `thickness`: cloud thickness in nodes (default `16`)
        * `speed`: 2D cloud speed + direction in nodes per second
          (default `{x=0, z=-2}`).
    ]]
    set_clouds = function(self, CloudParams) end,
    
    --- get the current cloud def
    ---@return {density:Alpha, color:ColorSpec, ambient:ColorSpec, thickness:number, speed:{x:integer,y:integer}|Vector}
    get_clouds = function(self) end,
    
    --- if not nil, use a 0-1 value to set the day to night ratio
    ---@param ratio Alpha|nil
    override_day_night_ratio = function(self, ratio) end,
    
    --- get the current day to night ratio override.
    ---@return Alpha
    get_day_night_ratio = function(self) end,
    
    --- set current animation frames. Each animation is a table in the formatL {x=start_frame, y=end_frame}.
    ---comment
    ---@param idle {x:integer,y:integer}
    ---@param walk {x:integer,y:integer}
    ---@param dig {x:integer,y:integer}
    ---@param walk_while_dig {x:integer,y:integer}
    ---@param frame_speed number
    set_local_animation = function(self, idle, walk, dig, walk_while_dig, frame_speed) end,
    
    --- the the current animations
    ---@return {x:integer,y:integer} idle, {x:integer,y:integer} walk, {x:integer,y:integer} dig, {x:integer,y:integer} walk_while_dig, number frame_speed
    get_local_animation = function(self) end,
    
    --- set eye offsets for the camera.
    ---@param firstperson Vector
    ---@param thirdperson Vector max. values `{x=-10/10,y=-10,15,z=-5/5}`
    set_eye_offset = function(self, firstperson, thirdperson) end,
    
    --- get the camera eye offsets
    ---@return Vector firstperson, Vector thirdperson
    get_eye_offset = function(self) end,
    
    --- send a server-loaded mapblock to the player (devide node pos by 16 for mapblock coord). VERY SLOW USE WITH CAUTION
    ---comment
    ---@param blockpos Vector
    send_mapblock = function(self, blockpos) end,
    
    --- set the shadow intensity. 0=no shadows, 1=blackness.
    ---comment
    ---@param light_definition {shadow:{intensity:Alpha}}
    set_lighting = function(self, light_definition) end,
    
    --- get the lighting table (shadows only)
    ---@return {shadow:{intensity:Alpha}}
    get_lighting = function(self) end,
}

---@class LuaEntity_Base
local LuaEntity_Base = {
    ---Called when the entity is activated, for the first time or from save
    ---@param self LuaEntity
    ---@param staticdata string|nil the saved string
    ---@param dtime_s number time since it was loaded
    on_activate = function(self, staticdata, dtime_s) end, --

    ---Called every update step
    ---@param self LuaEntity
    ---@param dtime number time since last step
    ---@param moveresult table move results
    on_step = function(self, dtime, moveresult) end, --

    ---Called when the entity is punched
    ---@param self LuaEntity
    ---@param puncher ObjectRef the creature that punched this ome
    ---@param time_from_last_punch number time since the puncher punched last
    ---@param tool_capabilities table the tool the puncher hit with
    ---@param dir Vector the direction of the punch
    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir) end, --

    ---Called when the entity is rightclicked
    ---@param self LuaEntity
    ---@param clicker ObjectRef|Player
    on_rightclick = function(self, clicker) end, --

    ---Called when the Entity is being unloaded
    ---@param self LuaEntity
    ---@return string staticdata the save data, passed on on_activate when re-loaded
    get_staticdata = function(self) end, --
}

---@class LuaEntity : LuaEntity_Base
local LuaEntity = {
    ---@type LuaObject the object this luaentity is dealing with
    object=nil,
    ---@type string the entity name
    name="unnamed entity",
    ---@type QTID the QUID of the entity
    QTID=0
}

---@alias QTID string|number QuestTest Entity ID. Strings for players, numbers for entities. Every one has a unique ID.



---@class LuaEntity_Def : LuaEntity_Base
local LuaEntity_Def = {
    ---@type EntityProperties
    initial_properties = {}
}

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
---@field copy fun(self:Vector):Vector copy the vector
---@field to_string fun(self:Vector):string vector to string

vector ={
    ---Creates a new vector. With no params, results in 0 vector. With vector param, makes a copy. Otherwise combines 3 params to vector.
    ---@param a nil|Vector|number
    ---@param b nil|number
    ---@param c nil|number
    ---@return Vector
    new = function(a, b, c) end, --
 
    ---Create a zero vector. **DEPRICATED** in vactor of vector.new()
    ---@deprecated
    ---@return Vector
    zero = function() end, --

    ---Create a copy of a vector. **DEPRICATED** in vactor of vector.new(v)
    ---@deprecated
    ---@param v Vector
    ---@return Vector
    copy = function(v) end, --
 
    ---Create vector from string
    ---@param s string format: "(x, y, z)"
    ---@param init? number optional offset into string
    ---@return Vector|nil , number
    from_string = function(s, init) end, --
 
    ---Make string from vector
    ---@param v Vector
    ---@return string
    to_string = function(v) end, --
 
    ---Get the unit direction from p1 to p2
    ---@param p1 Vector
    ---@param p2 Vector
    ---@return Vector
    direction = function(p1, p2) end, --
 
    ---Get the distance from p1 to p2
    ---@param p1 Vector
    ---@param p2 Vector
    ---@return number
    distance = function(p1, p2) end, --
 
    ---Get the length of a vector
    ---@param v Vector
    ---@return number
    length = function(v) end, --

    ---Returns a normalized vector in the same direction as the supplied vector
    ---@param v Vector
    ---@return Vector
    normalize = function(v) end, --

    ---Returns a new vector with each component rounded down
    ---@param v Vector
    ---@return Vector
    floor = function(v) end, --
 
    ---Returns a new vector with each component rounded to the nearest int, .5 goes away from 0
    ---@param v Vector
    ---@return Vector
    round = function(v) end, --

    ---Returns a Vector where the function func has been applied to each component
    ---@param v Vector
    ---@param func function
    ---@return Vector
    apply = function(v, func) end, --

    ---Checks for equality
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return boolean true if they are the same
    equals = function(v1, v2) end, --
 
    ---Returns two vectors for minpos, maxpos the cuboid defined by v1, v2
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return Vector minpos, Vector maxpos
    sort = function(v1, v2) end, --
 
    ---Returns the angle between v1 and v2 in radians
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return number the angle in radians
    angle = function(v1, v2) end, --
 
    ---Dot Product of V1, V2
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return number
    dot = function(v1, v2) end, --

    ---Cross Product of v1, v2
    ---@param v1 Vector
    ---@param v2 Vector
    ---@return Vector
    cross = function(v1, v2) end, --
 
    ---Returns the sum of V and (x, y, z)
    ---@param v Vector
    ---@param x number
    ---@param y number
    ---@param z number
    ---@return Vector
    offset = function(v, x, y, z) end, --

    ---Check if v is a vector
    ---@param v Vector|any
    ---@return boolean
    check = function(v) end, --
 
    ---Add two vectors or a vector and a scalar
    ---@param v Vector
    ---@param x Vector|number
    ---@return Vector
    add = function(v, x) end, --

    ---Subtract two vectors or a scalar from a vector
    ---@param v Vector
    ---@param x Vector|number
    ---@return Vector
    subtract = function(v, x) end, --
 
    ---Multiply a vector by a scalar
    ---@param v Vector
    ---@param s number
    ---@return Vector
    multiply = function(v, s) end, --

    ---Divide a vector by a scalar
    ---@param v Vector
    ---@param s number
    ---@return Vector
    divide = function(v, s) end, --

    ---Rotate vector by a euler rotation in radians
    ---@param v Vector
    ---@param r Rotator
    ---@return Vector
    rotate=function(v, r) end, --

    ---Rotate a vector around axis
    ---@param v1 Vector the vector
    ---@param v2 Vector the axis
    ---@param a number angle in radians
    ---@return Vector
    rotate_around_axis=function(v1, v2, a) end, --

    ---Creates a rotation vector from a direction
    ---@param direction Vector the direction
    ---@param up Vector the up vector. If omitted, roll will be 0.
    ---@return Rotator
    dir_to_rotation=function(direction, up) end, --
}

---@alias Rotator Vector {x=Pitch, y=Yaw, z=Roll}, uses radians

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
---@param include_empty? boolean defaults to false. To include emptry strings 
---@param max_splits? integer max splits to make
---@param sep_is_pattern? boolean defaults to false. Set to true to make the seperator treated as regex
---@return string[]
function string.split(str, seperator, include_empty, max_splits, sep_is_pattern) end

---trims the whitespaces off of the start and end of a string
---@param str string the string to split
---@return string
function string.trim(str) end

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
local Tool_Capabilities = {

}

---@alias ItemName string "modname:itemname" format. NOT an ItemString, which can have a count.

---@alias ItemWear integer 0 - 65535

---Create an itemstack
---@param param ItemString|ItemTable
---@return ItemStack
function ItemStack(param) end

---@class ItemStack
local ItemStackDef = {
    ---Check if itemstack is empty
    ---@return boolean
    is_empty = function(self) end,

    ---Get the item name
    ---@return ItemString
    get_name = function(self) end,

    ---Override the name of the item in the stack
    ---@param name ItemName
    ---@return boolean true if cleared
    set_name = function(self,name) end,

    ---Get the number of items in the stack
    ---@return integer
    get_count = function(self) end,

    ---Set the number of items in the stack
    ---@param count integer
    set_count = function(self,count) end,

    ---get the wear of the item
    ---@return ItemWear
    get_wear = function(self) end,

    ---Set the wear of the item
    ---@param wear ItemWear
    set_wear = function(self,wear) end,

    ---get the item's metadata
    ---@return ItemStackMetaRef
    get_meta = function(self) end,

    ---Get the item's description
    ---@return string
    get_description = function(self) end,
    
    ---get the item's short description
    ---@return string
    get_short_description = function(self) end,
    
    ---clear the itemstack to have 0 items of no type
    clear = function(self) end,

    ---Replace the contents of the stack
    ---@param item ItemStack|ItemString|ItemTable
    replace = function(self,item) end,

    ---Convert the ItemStack to an ItemString
    ---@return ItemString
    to_string = function(self) end,

    ---convert the ItemStack to an ItemTable
    ---@return ItemTable
    to_table = function(self) end,

    ---Get the max size for the stack
    ---@return integer
    get_stack_max = function(self) end,
    
    ---Get the remaining size for the stack
    ---@return integer
    get_free_space = function(self) end,

    ---Get if there is a registered item for this itemstack
    ---@return boolean
    is_known = function(self) end,

    ---returns the item definition table
    ---@return table
    get_definition = function(self) end,

    ---get the tool capabilities
    ---@return Tool_Capabilities
    get_tool_capabilities = function(self) end,

    ---Add wear to the item
    ---@param wear ItemWear
    add_wear = function(self,wear) end,

    ---Attempt to add two stacks together
    ---@param item Item
    ---@return ItemStack leftovers
    add_item = function(self,item) end,

    ---Check if another stack can be combined with no leftovers
    ---@param item ItemStack|ItemString|ItemTable
    ---@return boolean
    item_fits = function(self,item) end,
    
    ---Take an item from the stack
    ---@param n? integer the number of items to take
    ---@return ItemStack the taken items
    take_item = function(self,n) end,

    ---Act as if you item from the stack, but don't actually remove it
    ---@param n integer the number of items to take
    ---@return ItemStack the taken items
    peek_item = function(self,n) end,
}

---@alias ItemString string a string representation of an item

---@alias ItemTable table a table representation of an item

---@alias Item ItemStack|ItemString|ItemTable

---@class InvRef
local InvRef={

    ---Check if a list is empty
    ---@param self InvRef
    ---@param listname string
    ---@return boolean
    is_empty=function(self, listname) end,

    ---Get the size of an inventory list
    ---@param self InvRef
    ---@param listname string
    ---@return integer
    get_size=function(self, listname) end,

    ---Set the size of an inventory list
    ---@param self InvRef
    ---@param listname string
    ---@param size integer
    ---@return boolean results false if error
    set_size=function(self, listname, size) end,

    ---Get the width of a list
    ---@param self InvRef
    ---@param listname string
    ---@return number
    get_width=function(self, listname) end,

    ---Set the width of an inventory list
    ---@param self InvRef
    ---@param listname string
    ---@param width integer
    ---@return boolean results false if error
    set_width=function(self, listname, width) end,

    ---Get a copy of the ItemStack at index i in list listname
    ---@param self InvRef
    ---@param listname string
    ---@param i number
    ---@return ItemStack|nil
    get_stack=function(self, listname, i) end,

    ---Set a copy of stack into the Inventory's list listname at position i
    ---@param self InvRef
    ---@param listname string
    ---@param i number
    ---@param stack ItemStack
    set_stack=function (self, listname, i, stack) end,

    ---Get list as a list of ItemStacks
    ---@param self InvRef
    ---@param listname string
    ---@return ItemStack[] list
    get_list=function(self, listname) end,

    ---Set list from a list of ItemStacks
    ---@param self InvRef
    ---@param listname string
    ---@param list ItemStack[]
    set_list=function(self, listname, list) end,

    ---Returns a map of listnames to lists of itemstacks
    ---@param self InvRef
    ---@return {string:ItemStack[]}
    get_lists=function(self) end,

    ---Sets the lists from a map of listnames to lists of itemstacks
    ---@param self InvRef
    ---@param lists {string:ItemStack[]}
    set_lists=function(self, lists) end,

    ---Add an item to a list
    ---@param self InvRef
    ---@param listname string
    ---@param stack ItemStack
    ---@return ItemStack leftovers what cannot be added
    add_item=function(self, listname, stack) end,

    ---Check if an ItemStack can be added to a list
    ---@param self InvRef
    ---@param listname string
    ---@param stack ItemStack
    ---@return boolean can_add true if can be fully added with no leftovers
    room_for_item=function(self, listname, stack) end,

    ---Check if a ItemStack can be fully removed from a list
    ---@param self InvRef
    ---@param listname string
    ---@param stack ItemStack
    ---@param match_meta? boolean default: false
    ---@return boolean can_remove true if fully removable
    contains_item=function(self, listname, stack, match_meta) end,

    ---Remove an item from a list. DOES NOT MATCH META, so do that yourself!
    ---@param self InvRef
    ---@param listname string
    ---@param stack ItemStack
    ---@return ItemStack removed removed items, may be different from passed ItemStack
    remove_item=function(self, listname, stack) end,

    ---Get a location compatable with minetest.get_inventory(location)
    ---@param self InvRef
    get_location=function(self) end,
}

---Create an ItemStack
---@return ItemStack
---@param item ItemStack|ItemString|ItemTable
function ItemStack(item) end

-- TODO: these need filling out
-- Classes
---@class AreaStore
---@class MetaDataRef
---@class NodeMetaRef
---@class ItemStackMetaRef
---@class PlayerMetaRef
---@class NodeTimerRef
---@class ModChannel
---@class PcgGrandom
---@class PerlinNoise
---@class PerlinNoiseMap
---@class PersudoRandom
---@class Raycast
---@class SecureRandom
---@class Settings
---@class StorageRef



-- Definition Tables
---@class HudDefinition
---@alias EntityProperties table
--[[
    Minetest namespace. Lots of stuff in here!
]]
minetest = {
    ---Add newlines to a string to keep it within a limit
    ---@param str string the string to wrap
    ---@param limit number max characters per line
    ---@param as_table boolean true if return should be table. Default is false
    ---@return string|table
    wrap_text = function(str, limit, as_table) end,
    
    ---Turn a vector into a string
    ---@param pos Vector|table
    ---@param decimal_places? number decimel place to round to
    ---@return string "(X, Y, Z)"
    pos_to_string = function(pos, decimal_places) end,
    
    ---Turn a string into a vector if it can
    ---@param str string "(X, Y, Z)"
    ---@return Vector | nil
    string_to_pos = function(str) end,
    
    ---Turn a string of two positions into a pair of vectors describing the area
    ---@param str string "(X1, Y1, Z1) (X2, Y2, Z2)"
    ---@return Vector minpos, Vector maxpos
    string_to_area = function(str) end,
    
    ---Escapes special characters in a string so it can be used in formspec
    ---@param str string
    ---@return string
    formspec_escape = function(str) end,
    
    ---Check if the arg is a true value ("y", "yes", "true" or a nonzero number)
    ---@param arg string|number
    ---@return boolean
    is_yes = function(arg) end,
    
    ---returns true when the arg is NaN
    ---@param arg any
    ---@return boolean
    is_nan = function(arg) end,
    
    ---Get the current time with millisecond precision. May or may not represent wall time.
    ---@return number
    get_us_time = function() end,
    
    ---Get the facing position of a placer
    ---@param placer ObjectRef
    ---@param pointed_thing PointedThing
    ---@return Vector
    pointed_thing_to_face_pos = function(placer, pointed_thing) end,

    ---@class get_dig_params_results
    ---@field diggable boolean true if node can be dug
    ---@field time number time to break the node
    ---@field wear number how much wear should be added to the node

    ---Simulates that item digging a node with those groups.
    ---@param groups table node groups
    ---@param tool_capabilities Tool_Capabilities
    ---@param wear number current tool wear. Default is 0
    ---@return get_dig_params_results
    get_dig_params = function(groups, tool_capabilities, wear) end,

    ---@class get_hit_params_results
    ---@field hp number how much damage would be caused
    ---@field wear number how much wear should be added to the tool

    ---Simulate an item hitting an entity with these armor groups
    ---@param groups table entity armor groups
    ---@param tool_capabilities Tool_Capabilities
    ---@param time_from_last_punch number time in second since last punch
    ---@param wear number original wear of the tool
    get_hit_params = function(groups, tool_capabilities, time_from_last_punch, wear) end,

    ---Register a new node
    ---@param name ItemName the itemname
    ---@param def NodeDefinition the node definition
    register_node = function(name, def) end,

    ---Register a new item
    ---@param name ItemName the itemname
    ---@param def ItemDefinition the node definition
    register_craftitem = function(name, def) end,

    ---Register a new tool
    ---@param name ItemName the itemname
    ---@param def ItemDefinition the node definition
    register_tool = function(name, def) end,

}


--[[
    Groups are common classifications of nodes.
    Common groups should be added to this alias.
]]
---@diagnostic disable-next-line: duplicate-doc-alias
---@alias Group string
---| "stone"
---| "wood"

---@alias Group_Set table<Group,number>

--[[
    Textrues are complex strings based on file names and a series of operators to manipulate them
]]
---@alias Texture string

---@class TileAnimationDefinition
---@field type "vertical_frames"|"sheet_2d" type of animation
---@field aspect_w integer|nil with type="vertical_frames", the width of a frame in pixels
---@field aspect_h integer|nil with type="vertical_frames", the height of a frame in pixels
---@field length number|nil with type="vertical_frames", the full loop length of the animation
---@field frames_w integer|nil with type="sheet_2d", the number of frames wide the sheet is
---@field frames_h integer|nil with type="sheet_2d", the number of frames tall the sheet is
---@field frame_length number|nil with type="sheet_2d", the time a single frame takes

---@class TextureComplex
---@field animation TileAnimationDefinition the texture animation
---@field name Texture the texture name
---@field backface_culling boolean if backface culling should apply. Defaults to true.
---@field align_style "node"|"world"|"user" how to align the texture. "user" uses a client setting.
---@field scale integer when align_style is "world", number of nodes in each direction covered by this texture. should divide 16 evenly for best performance. 
---@field color ColorSpec the texture color. Multiplied with the texture. Overrides all other node colors.

---@alias TileDefinition
---| Texture
---| TextureComplex

---@alias ItemSoundField string
---|"breaks"
---|"eat"
---|"punch_use"
---|"punch_use_air"
---|"footstep"
---|"dig"
---|"dug"
---|"place"
---|"place_failed"
---|"fall"

---TODO: fill this out
---@alias NodeBox table

--[[
    Sides a nodebox can connect on
]]
---@alias NodeBoxConnectSides 
---|"top"
---|"bottom"
---|"front"
---|"left"
---|"back"
---|"right"

---TODO: fill this out
---@alias NodeDropTable table

--[[
    The ItemDefinition is a table of many definition fields to control registered items.
]]
---@class ItemDefinition
---@field description string|nil The description. Can contain newlines ("\n"). Gotten by ItemStack:get_description()
---@field short_description string|nil Short description, no newlines. Gotten by ItemStack:get_short_description()
---@field groups Group_Set|nil Item Groups
---@field inventory_image Texture|nil the image used in the inventory
---@field inventory_overlay Texture|nil overlay inventory image not affected by coloration
---@field wield_image Texture|nil image held in the hand
---@field wield_overlay Texture|nil image held in the hand, not affected by coloration
---@field wield_scale Vector|{x:number,y:number,z:number}|nil visual wield scale of the item
---@field palette Texture|nil used to color the item based off of itsm metadata
---@field color ColorSpec|nil the default color, overriden by palette index in metadata 
---@field stack_max integer|nil the max items that can fit in one stack
---@field range number|nil the range that objects and nodes can be pointed at
---@field liquids_pointable boolean|nil true if the object can point at liquids 
---@field light_source integer|nil from 0 to minetest.LIGHT_MAX (14). Outside this range is undefined behavior 
---@field tool_capabilities Tool_Capabilities|nil the tool capabilities of the item
---@field node_placement_prediction string|nil prediction of what node should be placed. ""=no prediction. <other>=place that node if a node 
---@field node_dig_prediction string|nil prediction of what node should be placed. ""=no prediction. "air"=remove pointed node, <other>=node client immedately places on node removal 
---@field sound {ItemSoundField:SimpleSoundSpec|nil|table}|nil the node sounds
---@field on_place nil|fun(itemstack:ItemStack,placer:ObjectRef,pointed_thing:PointedThing):ItemStack|nil function called when item is placed. Returns the leftover ItemStack or nil 
---@field on_secondary_use nil|fun(itemstack:ItemStack,placer:ObjectRef,pointed_thing:PointedThing):ItemStack|nil function called when item is placed without pointing at anything. Returns replacement ItemStack 
---@field on_pickup nil|fun(itemstack:ItemStack, picker:ObjectRef, pointed_thing:PointedThing, time_from_last_punch:number, ...):ItemStack|nil called when dropped item is picked up. Returns itemstack that should remain on floor.
---@field on_use nil|fun(itemstack:ItemStack, user:ObjectRef, pointed_thing:PointedThing):ItemStack|nil Called when puched when item. Returns replacement ItemStack.
---@field after_use nil|fun(itemstack:ItemStack, user:ObjectRef, node:NodeRef, digparams:table):ItemStack|nil Called after node destroyed with item. returns replacement ItemStack.


--[[
    The NodeDefinition is a table of many definition fields to control registered nodes. Anything from ItemDefinition also applies.
]]
---@class NodeDefinition : ItemDefinition
---@field drawtype NodeDrawType|nil The node draw type
---@field visual_scale number|nil Node scale, supported for drawtypes: plantlike, signlike, torchlike, firelike, mesh, nodebox, allfaces
---@field tiles nil|TileDefinition[] List of tiles. Order: +Y, -Y, +X, -X, +Z, -Z (top, bottom, right, left, front, back)
---@field overlay_tiles nil|TileDefinition[] List of overlay tiles. Not affected by coloration.
---@field special_tiles nil|TileDefinition[] special tiles used by some drawtypes
---@field use_texture_alpha nil|"opaque"|"clip"|"blend" Alpha mode of the textures. Opaque is default for opaque nodes, clip for others. (Clip is masked). blend for translucency
---@field post_effect_color nil|ColorSpec the screen color when camera is inside the node
---@field paramtype nil|ParamType the node param type
---@field paramtype2 nil|Param2Type the node param2 type
---@field place_param2 nil|integer the default param2 of the node
---@field is_ground_content nil|boolean if false, the cave generator will not carve through this node. Default:true
---@field walkable nil|boolean Node collision enabled. Default:true
---@field pointable nil|boolean Node selection enabled. Default:true
---@field diggable nil|boolean Node can be or cannot be broken. Default:true
---@field climbable nil|boolean Node climbing enabled. Default:false
---@field move_resistance nil|integer 0-7, resistance a node offers to movement in it
---@field buildable_to nil|boolean if true, placed nodes replace this node. Default:false
---@field floodable nil|boolean if true, flowing liquids will replace this node. Default:false
---@field liquidtype nil|"none"|"source"|"flowing" the node liquid type. Default:"none"
---@field liquid_alternative_flowing nil|ItemName the node name for the flowing node if a liquid
---@field liquid_alternative_source nil|ItemName the node name for the source node if a liquid
---@field liquid_viscosity nil|integer 0-7 Liquid flow speed, 0 being fast.
---@field liquid_renewable nil|boolean liquid renewability, ie, two sources flowing into same block becomes source. Default:true
---@field liquid_move_physics nil|boolean liquid physics. nil:treated as true if liquid, false otherwise. Default:nil
---@field liquid_range nil|number 0-8 Liquid flow range. Default:8
---@field leveled nil|number For nodebox drawtype, the default level value. 0 < leveled < leveled_max
---@field leveled_max nil|number 0-127. For nodebox drawtype, hard limit on leveled height. Default:127
---@field drowning nil|number the ammount of damage the player takes if they have no bubbles left in this node. Default:0 (disables drowning entirely - no bubbles)
---@field damage_per_second nil|number the ammoutn of damage the player takes if they are inside this node. Default:0 (no damage)
---@field node_box nil|NodeBox the visual nodebox for nodebox drawtype
---@field connects_to nil|ItemName[] nodes that this one connects to with the drawtype nodebox
---@field connect_sides nil|NodeBoxConnectSides[] the sides that this node can connect on. Defaults to all of them that have boxes.
---@field mesh nil|string Mesh filename for mesh drawtype. Obj Format.
---@field selection_box nil|NodeBox Selection boxes Defaults to node_box if not defined
---@field collision_box nil|NodeBox Colliosion boxes. Defaults to node_box if not defined
---@field waving nil|number Waving mode: 1:wave like plants. 2:wave like leaves. 3:wave like water.
---@field drop nil|ItemString|NodeDropTable the drops of the node. Defaults to itself.
---@field on_construct nil|fun(pos:Vector):nil Called when node added (exept by minetest:swap_node, schematics, or VoxelManip). WARNING: Can cause infinite loops if it replaces node via minetest:set_node(...)
---@field on_destruct nil|fun(pos:Vector):nil Called before removing a node. Not called for bulk node placement (VoxelManip)
---@field after_destruct nil|fun(pos:Vector, oldnode:NodeRef) Called after removing a node. Not called for bulk node placement (VoxelManip)
---@field on_flood nil|fun(pos:Vector, oldnode:NodeRef, newnode:NodeRef):nil Called when a node is flooded
---@field preserve_metadata nil|fun(pos:Vector, oldnode:NodeRef, oldmeta:NodeMetaRef, drops:ItemStack[]) Called when a node is about to become an Itemstack, but before the node is removed. Used to move metadata from old node to ItemStack metadata
---@field after_place_node nil|fun(pos:Vector, placer:ObjectRef|nil, itemstack:ItemStack, pointed_thing:PointedThing):boolean Called after a node is placed in a player-like fashion. Return of true blocks ItemStack from having an item taken.
---@field after_dig_node nil|fun(pos:Vector, oldnode:NodeRef, oldmetadata:NodeMetaRef, digger:ObjectRef|nil):nil Called after a node was dug in a player-like fashion.
---@field can_dig nil|fun(pos:Vector, player:ObjectRef|nil):boolean returns true if node can be dug by player.
---@field on_punch nil|fun(pos:Vector, node:NodeRef, puncher:ObjectRef, pointed_thing:PointedThing):nil Called when node is punched. Default:minetest.node_punch which calls the minetest.register_on_punchnode callbacks
---@field on_rightclick nil|fun(pos:Vector, node:NodeRef, clicker:ObjectRef, itemstack:ItemStack, pointed_thing:PointedThing|nil):nil|ItemStack Called when node is built against. Return the leftover ItemStack 
---@field on_dig nil|fun(pos:Vector, node:NodeRef, digger:ObjectRef):boolean Called when a node is dug. return true if node dug Sucessfully.
---@field on_timer nil|fun(pos:Vector, elapsed:number):nil|boolean Called when a node timer runs out. Return true to restart timer. 
---@field on_receive_fields nil|fun(pos:Vector, formname:string, fields:table, sender:Player) Called when there is input in that node's UI.
---@field allow_metadata_inventory_move nil|fun(pos:Vector, from_list:string, from_index:integer, to_list:string, to_index:integer, count:integer, player:Player):boolean
---@field allow_metadata_inventory_put nil|fun(pos:Vector, listname:string, index:integer, stack:ItemStack, player:Player):boolean
---@field allow_metadata_inventory_take nil|fun(pos:Vector, listname:string, index:integer, stack:ItemStack, player:Player):boolean
---@field on_metadata_inventory_move nil|fun(pos:Vector, from_list:string, from_index:integer, to_list:string, to_index:integer, count:integer, player:Player):nil
---@field on_metadata_inventory_put nil|fun(pos:Vector, listname:string, index:integer, stack:ItemStack, player:Player):nil
---@field on_metadata_inventory_take nil|fun(pos:Vector, listname:string, index:integer, stack:ItemStack, player:Player):nil
---@field on_blast nil|fun(pos:Vector, intensity:number):any called when node is exploded.
---@field mod_origin string The origin mod. Do not set when registering a node.

