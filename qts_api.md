# QuestTestSystem (QTS) API documentation

# Globals
<!--BEGIN Globals-->
## Settings Variables

* `qts.settings`
A settings clojure object. (NOT Minetest Settings object) Holds settings related to qts operations. This is specific to the install of qts. 

* `qts.world_settings`
A settings clojure object. (NOT Minetest Settings object) Holds world-speicific qts settings. 

* `qts.IDSEV`
True if the world is in devmode, false otherwise. Used to control the registration of specific elements and ABMs. See [Devmode](#devmode) for more details.

* `qts.LEVEL_MULTIPLIER`
A value between 0 and 1 that causes item damage, health, and other aspects of enemies to scale with the player's level.

* `qts.EXPLOTION_MAX_STEPS`
The number of iterative steps allowed in an explotion. This is a hard upper limit.

* `qts.player_modifer_lists[playername]`
A list of physics modifers that are applied to the player as one. This allows multiple sources of physics modifers to not conflict with each other.

## Lists and Registered things

* `qts.open_chests[playername]` 
Holds a refrence to open chests stored by the name of the player opening it. This is structured as a table: `{pos=pos, sound_close=sound_ref}`. This structure is used to play the closing sound of a chest.

* `qts.registered_elements[element_name]` 
Holds a copy of all registered element data. See the [Element System](#element-system) for details. This data is not actually referenced by the system, the system uses data protected by a closure. 

* `qts.registered_item_modifiers[item_mod_name]`
Holds the registered item modifiers from the [Item Modifiers System](#item-modifiers-system)

* `qts.player_data[playername]`
Holds player-specific data. This data is broken into categories, which are each a table. Data can be read from this with `qts.get_player_data(...)` and written to it with `qts.set_player_data(...)` The Categories shoudld be used for grouping similar-use fields, and avoiding field conflict names.

<!--END Globals-->

# Utility Functions 
<!--BEGIN Utility-->
## Math and Vectors

* `qts.nearly_equal(a, b, degree)` Checks to see if `a` and `b` are within `degree` of each other.

### Vector Math (api/vector.lua)
<!--BEGIN Vector Math-->
All the vector math library functions are housed inside of minetest's `vector` namespace. This is simply an addition to it.

Vectors are also used to express euler rotations. In this format, the follow this guide: {x = pitch, y = yaw, z = roll}

* `vector.fill(number)` 
Creates a new vector with `number` in `x`, `y`, and `z`. 
 
* `vector.lengthsq(vector)` 
Gets the squared length of the vector. Faster than the actual length.
 
* `vector.distancesq(pos1, pos2)` 
Gets the squared distance between two vectors. Does not call other functions, for best speed. Equivilent to `vector.lengthsq(vector.sub(pos1, pos2))`
 
* `vector.nearly_equal(v1, v2, degree)` 
Checks to see if `v1` and `v2` are within `degree` of each other. Checks component-wise, not actual distance.
 
* `vector.nearly_equal_xz(v1, v2, degree)` 
Check to see if `v1` and `v2` are within `degree` of each other, ignoring any height difference. Checks component-wise, not the actual distance.
 
* `vector.rotate_yaw(vector, angle)` 
Rotates the vector by an angle around the vertical axis. Returns a new vector.
 
* `vector.unit()` 
Returns a new unit vector, pointing to z+. `{x=0,y=0,z=1}`
 
* `vector.flat_dist(pos1, pos2)` 
Gets the distance between `pos1` and `pos2`, ignoring height (treating them as if they are 2d, with x and z).
 
* `vector.get_rot(vec)` 
Gets the rotation of a vector from forwards (z+). Returns a new vector as a set of euler rotations, around each axis.
 
* `vector.get_forward_vector([rot] [yaw, (pitch)])` 
Gets the forward vector of a rotation. A vector `rot` can be povided, being a set of euler rotations around each axis, or, the `yaw` can be provided and with an optional `pitch`.
 
* `vector.get_right_vector([rot] [yaw, (pitch)])` 
Gets the right vector of a rotation. Params are as in `vector.get_forward_vector(...)`
 
* `vector.get_up_vector([rot] [yaw, (pitch)])` 
Gets the up vector of a rotation. Params are as in `vector.get_forward_vector(...)`

* `vector.lerp(vector1, vector2, alpha)` 
Linear Interpalation between two points or vectors. Returns a new vector.
 
* `vector.slerp(rot1, rot2, alpha)` 
Spherical Interpalation between two sets of euler rotations. **Currently has bugs.**
<!--END Vector Math-->

## Chests And Storage Nodes
<!--BEGIN Chests and Storage Nodes-->
* `qts.is_chest_lid_obstructed(pos)` 
Checks if the position has a block above it that would obstruct vertical access.

* `qts.get_node_inventory_drops(pos, inv_name, drops={})` 
Gets the drops from inventory `inv_name` in the metadata of the node at `pos`, appending this to `drops` array.
 
* `qts.close_chest(playername)` 
Closes the chest opened by player `playername`, if they have one open. calls the callback `on_chest_close(pos, node, player, is_closed)`. Also handles playing the closing sound, if nesecary.
<!--END Chests and Storage Nodes-->

## Explotions 
<!--BEGIN Explotiions-->
* `qts.explode_sound(pos, distance)`
Plays the sound of an explosion at `pos`, heard for `distance` blocks.

* `qts.explode_particles(pos, radius, mult=1)`
Plays the explotion particle effect at `pos` simulating an explotion of radius `radius`. The total number of particles is multiplied by `mult`.

* `qts.explode_ray(pos, slopeVector, stepSize, power, returnFound)`
Causes a single ray of an explotion. `pos` is the origin of the ray, and it travels in the direction of `slopeVector`. The size of the step for the ray is `stepSize`. `power` determines the strength of the ray. If `returnFound` is true, it simply returns the list of destroyed blocks in the format: `{found = array, drops = array, objects = array}`. If `returnFound` is false, it destroyes the nodes and ejects the drops, and blasts the objests.

* `qts.explode(pos, power, properties)`
The actual explosion function. This should be used for all explosions. The explosion is centered on `pos` and has a strength of `power`. `properties` is a table that controls the type of explosion, and has defaults. If any one of the flags should be changed from the default, the entire table must be set up. It's flags and defaults are thus: 
    * `destroy_nodes = true` - if the explosion should destry nodes.
    * `make_drops = true` - if the explosion should make nodes drop.
    * `drop_speed_multiplier = 1`- speed multiplier of the drops.
    * `make_sound = true` - if the explosion should make a sound.
    * `make_particles = true` - if the explosion should make particles.
    * `particle_multiplier = 1` - mulitplier for the number of particles.
    * `damage_entities = true` - if the explosion should damage entities.
    * `damage_player = true` - if the explosion should damage players.
    * `damage_type = "fleshy"` - the damage type of the explosion.
    * `exploder = nil` - the objectRef responsible for the explosion (damage-wise)
<!--END Explotiions-->

## Player Functions
<!--BEGIN Player Funcs-->

* `qts.get_player_data(player, category, field)`
Gets the player data of the player `player` (name or playerref), part of category `category` with fieldname `field`

* `qts.set_player_data(player, category, field, data)`
Sets the player data of the player `player` (name or playerref), part of category `category` with fieldname `field` to `data`

* `qts.pickup_sound(player)` 
Plays the item pickup sound to a player.

* `qts.is_player_creative(playername)`
Checks to see if a player is in creative mode. Checks both the global setting, as well as the player's privs.

* `qts.update_player_modifers(player)`
Runs an update on that specific player modifer list. `player` is a playerref or a playername.

* `qts.set_player_modifier(player, id, modifiers, do_not_set=false)`
Adds a physics modifer to the specified player's list. `player` is a playerref or playername that is reciving the modifer. `id` is the modifier name (each source should have a unique name). `modifiers` is a list of physics override like `player:set_physics_override(...)`. However, only `speed`, `jump`, and `gravity` are supported. The rest are boolean and thus don't blen well. `do_not_set` is a optional value, if true, then the player's physics are not updated, though the modifier is active.

* `qts.get_player_modifier(player, id)`
Gets the modifier called `id` in the specified player's modifier list. `player` is a playerref or playername. Returns a table copied from the list with the fields `speed`, `jump`, and `gravity`.

<!--END Player Funcs-->

## Projectile Functions
<!--BEGIN Projectile Funcs-->
* `qts.projectile_launch_player(projectile, player, inaccuracy=0)`
Called to cause a player to launch a projectile in the direction the player is looking. `projectile` is a registered projectile name. See [qts.register_projectile(...)](#qtsregister_projectilename-def). `player` is a playerref (not a playername). `inaccuracy` is a value to offset the view direction, and counts in percent of a block over a distance of one block. It defaults to 0.

* `qts.projectile_launch_to(projectile, origin, target, launcher, inaccuracy=0)`
Called to launch a projectile from the `origin` to the `target`. This does not guarantee a hit, due to the effects of gravity (and inaccuracy). `projectile` is a registered projectile name. See [qts.register_projectile(...)](#qtsregister_projectilename-def). Both `origin` and `target` are positional vectors. `launcher` is an optional objref, and can be nil. `inaccuracy` is a value to offset the view direction, and counts in percent of a block over a distance of one block. It defaults to 0.

* `qts.projectile_launch_dir(projectile, origin, dir, launcher, inaccuracy=0)`
Called to launch a projectile from `origin` in the direction `dir`.
`projectile` is a registered projectile name. See [qts.register_projectile(...)](#qtsregister_projectilename-def). `origin` is a positional vectors. `dir` is a directional unit vector. `launcher` is an optional objref, and can be nil. `inaccuracy` is a value to offset the view direction, and counts in percent of a block over a distance of one block. It defaults to 0.

* `qts.projectile_default_struck_node(luaentity, pos, node)`
The default function a projectile calls when it strikes a node. It sets the acceleration and velocity to 0, moves the projectile back one step, and deactivated it, ready for pickup.

* `qts.projectile_default_struck_entity(luaentity, obj_other)`
The default function a projectile calls when it strikes an entity. It punches the entity for its damagetype, and removes the projectile object.

* `qts.projectile_default_timeout(luaentity)`
The default function a projectile calls when it's lifetimer hits 0. It removes the projectile object.

<!--END Projectile Funcs-->

## Unsorted
<!--BEGIN Unsorted-->
* `qts.table_deep_copy(orig, copy=nil)` 
Performs a deep copy of a table, metadata included. If copy is a table, it will be used as destination. Destination is also returned. This function is from [lua-users.org](https://lua-users.org/wiki/CopyTable)
 
* `qts.get_nodes_in_radius(pos, radius)` 
Returns a list of all the nodes in `radius` blocks from `pos`. No order is guaranteed.
 
* `qts.get_nodes_on_radius(pos, radius)` 
Returns a list of all the nodes aproximately `radius` blocks from `pos`. This makes a hollow shell shape. No order is guaranteed.
 
* `qts.is_node_in_radius(pos, radius, nodename)` 
Finds a node with name = `nodename` in the `radius` around `pos`. If `nodename` follows the format "group:groupname" then a node of that group is searched for. If a number follows the groupname, ie, "group: groupname 4", then the group level of the node must equal or exceed that number. If a node is found, its position is returned. In the case of multiple nodes, the one returned is random, and not guaranteed to be the closest.
 
* `qts.distribute_points_on_sphere(count)` 
Distributes `count` points on the surface of a unit sphere. Returns a list of unit vectors that tell the direction to each point from an origin. 
 
* `qts.is_damage_tick()`
Returns true if this particular tick is one in which ambiant damage is dealt from blocks, false otherwise.
 
* `qts.ignite(pos)` 
Lights `pos` on fire. The implementation of this function should be in whatever mod adds fire. In the case of QuestTest2, this is the default mod.
 
* `qts.get_modname_from_item(itemname)` 
Returns the modname from an itemname. Itemnames follow the pattern "mod:item".
 
* `qts.remove_modname_from_item(itemname)` 
Return the itemname from an item, with no modname prefix.
 
* `qts.is_group(itemname)` 
Returns true if the itemname follows the pattern "group:[groupname]"
 
* `qts.inv_contains_group(inv, groupName, ignoreNames = {})` 
Check if an inventory contains items with group `groupName`, that are not in the ignored items table. `groupName` follows the convention "group:groupname".  `ignoreNames` is a Set of item names. Returns true/false.
 
* `qts.inv_take_group(inv, groupName, ignoreNames = {})` 
Removes items from an inv that follow group `groupName`, but are not in the ignored items table. `groupName` follows the convention "group:groupname count". `ignoreNames` is a Set of item names. Returns a list of Itemstacks. 
 
* `qts.objects_overlapping(entityRefA, entityRefB)` 
Checks to see if the collisionboxes of the two entityRefs are overlapping. The performs Axis-Alligned Bounding Box overlapping algorithm. It returns true/false


<!--END Unsorted-->
<!--END Utility-->

# Datatypes
<!--BEGIN Datatypes-->
### Set: `Set(t)`
<!--BEGIN Set-->
Creates a set from a list. A Set is just the data stored in the keys of the table, and "true" stored as the value. ie:

    {["item1"]=true, ["item2"]=true, ... ["itemN"]=true}
    
**Params**
* `t` *array* - a 1 indexed list. non-numerical indecies are not processed. Unmodified by the function.

**Return** a new Set table.

**Example**

    Set({1="item1", 2="item2, 3="item3"})
    --results in
    {["item1"]=true, ["item2"]=true, ["item3"]=true}
<!--END Set-->

### Deque: `Deque()`
<!--BEGIN Deque-->
Creates an empty Deque. Functions as Deque, Queue, and Stack structures. All internal methods are called using the `:` notation, ie

`item:pop()`

All methods are declared locally and regerenced by all Deques, maintaining minimum memory footprint.

For the Queue usage style, the front of the queue (where items are taken from) is the front of the Deque, and the back of the queue is the back of the deque.

For the Stack usage style, the front of the deque is the operational end.

**Params** None

**Return** A Deque table.

**Methods**
The following methods are listed with the usage type listed as the object it is being acted on. See example for better usage tips.

* `Deque:add_to_back(item)`
Adds an item to the back of the Deque.

* `Deque:add_to_front(item)`
Adds an item to the front of the Deque.

* `Deque:remove_from_back()`
Removes and returns an item from the back of the deque.

* `Deque:remove_from_front()`
Removes and returns an item from the front of the deque.

* `Deque:peak_back()`
Returns, but does not remove, an item from the back of the deque.

* `Deque:peak_front()`
Returns, but does not remove, an item from the front fo the deque.

* `Queue:enqueue(item)`
Adds an item to the queue.

* `Queue:dequeue()`
Removes and returns an item from the queue.

* `Queue:peek()`
Returns, but does not remove, an item from the queue.

* `Stack:push(item)`
Pushes an item onto the stack.

* `Stack:pop()`
Removes and retuns an item from the stack.

* `Stack:peek()`
Returns, but does not remove, an item from the stack.

**Example**

    local d = Deque()
    d.add_to_front(1)
    d.add_to_front(2)
    d.add_to_front(3)
    d.remove_from_back() -- 1
    d.push(4)
    d.pop() -- 2
    d.deque() -- 3
    d.enqueue(5)
    d.remove_from_front() -- 4
    d.pop() --5

If more examples for this data structure are desired, look some up online. This is a standard data structure.
<!--END Deque-->

### Counter()
<!--BEGIN Counter-->
Creates a counter function. Each time the counter function is called, the returned number is one greater than the previous return value. Each counter is independant. Counters start at 1.

**Params** None

**Return** A Counter function

**Example**

    local c1 = Counter()
    c1() -- 1
    local c2 = c1
    c2() -- 2 (same obj as c1)
    local c3 = Counter()
    c3() -- 1 (different counter)
    c1() -- 3 
<!--END Counter-->
    
### qts.create_settings_clojure(filename)
<!--BEGIN Setings-->
Creates a clojure-protected Minetest Settings object, with extended access functions. 

**Methods**
* `get_str(key)` Gets the string stored at `key`.
* `set_str(key, string)` Sets the string stored at `key` to `string`.
* `get_bool(key)` Gets the boolean stored at `key`.
* `set_bool(key, bool)` Sets the boolean stored at `key` to `bool`.
* `get_num(key)` Gets the number stored at `key`.
* `set_num(key, number)` Sets the number stored at `key` to `number`.
* `get_noiseParams(key)` Gets the noise params stored at `key`.
* `set_noiseParams(key, tbl)` Sets the noise params stored at `key` to `tbl`.
* `get_mapgen_flags(key)` Gets the mapgen flags stored at `key`.
* `remove_key(key)` Removes the key `key`.
* `keys()` retuns the keys as an array.
* `to_table()` retuns the entire set of settings as a table.
*  `save()` writes the Settings out to file.
<!--END Setings-->
<!--END Datatypes-->

# Node Registers
<!--BEGIN Node Registers-->
### qts.register_shaped_node(name, def)
Registers a new shaped node. This should be used for most standard nodes in a game. It allows them to be hammered into various shapes. It's `def` is no different than `minetest.register_node(...)` Nodeboxes for the shaped versions will be overriden though. It is not reccomended to use custom meshes or nodeboxes for shaped nodes.

### qts.register_fencelike_node(name, def)
Regsiters a new fence, rail, wall, or pane.

There is one new requrement for the node def:
* `type = <"fence" OR "rail" OR "wall" OR "pane">`
    * "fence" results in a fence with posts.
    * "rail" results in a fence without posts.
    * "wall" results in a solid stone wall
    * "pane" results in a glass pane shape

### qts.register_liquid(name, def)
Registers a new liquid. Automatically registers bucket items for previously registered buckets.

Most fields in  `def` can be customized, but there are some defaults:

    {
		waving = 3,
		paramtype = "light",
        use_texture_alpha = "blend",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		liquids_pointable = true,
		drop = "",
		drowning = 1,
		liquid_alternative_flowing = name.."_flowing",
		liquid_alternative_source = name.."_source",
		liquid_viscosity = 1,
		post_effect_color = {a = 103, r = 30, g = 60, b = 90},
		groups = {liquid=1},
	}

Further, `def` should contain an aditional texture file name for the buckets:
* `bucket_image = "texture_file_name.png"`

	
Certain parts of `def` are overriden, namely
* `drawtype`
* `liquidtype`
* `paramtype2` (for flowing)

Further, the description is editied to include the "Source" and "Flowing" postfixes. 

### qts.register_ingot(name, def)
Some might expect this to be in the item registration section, it is a bit of a blend between registering a custom item and a custom node. This is for registering items that can be placed on the ground in stacks of multiple of that item. (it can handle up to 99 items in a single node stack)

`def` contains a two custom fields, that are optional:
* `level = number` - the number of items that can be stacked in one node. Should be the same as number of nodeboxes.
* `nodeboxes = {...}` - a list of nodeboxes. NOT a nodebox definition, but, the contents of `fixed` from a nodebox definition. If not supplied, defaults to an ingot set. Each box corresponds to one item placed on the ground.

`def` should not implement an `on_place(...)` function, as it will be overriden.

### qts.register_torch(name, def)
Registers a new torch. This is fairly limited and straightforewared.

There are lots of fields in `def` that should not be used, and will be overriden if they are. This list is:
* `drawtype = "mesh"`
* `paramtype = "light"`
* `paramtype2 = "wallmounted"`
* `group.torch = 1`
* `group.attached_node =1`
* `sunlight_propigates = true`
* `on_rotate = false`
* `mesh = <various>`
* `selection_box = <various>`
* `on_place(...)`
* `drop = self`

Some members of `def` have defaults, but can be safely overriden:
* `use_texture_alpha = "clip"`
* `light_source = 12`

### qts.register_chest(name, def)
Registers a new chest. `def` must contain several elements in addition to normal node def requirements:
* `invsize` = number
* `get_chest_formspec` = function(pos, pname)
* `sound_open` = Sound File Name
* `sound_close` = Sound File Name

There are also some optional callbacks (detailed under [Node Callbacks](#node-callbacks)):
* `on_chest_open(pos, node, opener, is_already_open)`
* `on_chest_close(pos, node, closer, is_final_close)`

These fields from the normal node definition should not be set:
* `on_construct(...)`
* `on_rightclick(...)`

These fields have sensible defaults, but can be overriden.
* `can_dig(...)`
* `on_blast(...)`
* `on_metadata_inventory_move(...)`
* `on_metadata_inventory_put(...)`
* `on_metadata_inventory_take(...)`

### qts.register_growable_node(name, def)
Registers a new growable node. `def` must contain several elements in addition to normal node def requirements:
* `growable_nodes = {}` - A list of nodes or groups ("group:groupname") that the growable node can grow on.
* `on_grow(pos)` - the function to call when grown. detailed under [Node Callbacks](#node-callbacks))

These fields from the normal node definition should not be set:
* `on_timer(...)`
* `on_construct(...)` - defaults to `qts.start_node_growth(...)`
<!--END Node Registers-->

## Node Callbacks
<!--BEGIN Node Callbacks-->
These are special node callbacks that can be applied to most nodes. If otherwise, noted in the description.

* `on_walk(pos, player)` 
Called when a player walks on top of this block.

* `on_walk_in(pos, player, new)`
Called when a player walks in a block. Only effects blocks at food position. `new` is true if this is the first tick in which the player is actively walking in this block.

* `on_walk_exit(pos, player)` 
Called when a player leaves a block they were previously walking in on the last tick.

* `on_projectile_strike(projectile, pointed_thing)`
Called when a projectile hits a node, before the projectile's own on_strike_node() function is called. Does not return anything.

* `on_projectile_enter(projectile_pos)`
Called when a projectile first enters a node. Not called when the projectile strikes the node. Thus, this is only called on nodes the projectile can move through.

* `on_projectile_exit(projectile, pos)`
Called when a projectile leaves the node. Only called on nodes the projectile can move through.


* `on_chest_open(pos, node, player, is_already_open)` **CHEST ONLY** 
Called when a chest is closed. `pos` is the position of the chest, `node` is the chest noderef, `player` is the player object that opened the chest, and `is_already_open` is a boolean, true if there is another player with the chest open. No return value. Used for nodes registered by `qts.register_chest(...)`.

* `on_chest_close(pos, node, player, is_closed)` **CHEST ONLY** 
Called when a chest is closed. `pos` is the position of the chest, `node` is the chest noderef, `player` is the player object that closed the chest, and `is_closed` is a boolean, true if there is no other player keeping the chest open. No return value. Used for nodes registered by `qts.register_chest(...)`.

* `on_grow(pos)` **GROWABLE ONLY** 
Called when the node finishes its grow cycle. If it returns true (or any valid value), a new grow cycle is started at that position. Otherwise, it does nothing once complete. Used for nodes registered by `qts.register_growable_node(...)`
<!--END Node Callbacks-->

# Tool Registers
<!--BEGIN Tool Registers-->

<!--ENG Tool Registers-->
## Tool Callbacks
<!--BEGIN Tool Callbacks-->

<!--END Tool Callbacks-->
# Item Registers
<!--BEGIN Item Registers-->

### qts.register_bucket(name, def)
Registers a new bucket. Automatically makes buckets for all liquid types, no matter the order registered. (Ie, You can register the buckets and liquids in any mod, in any order, and they will all play nicely together.)

`def` is fairly resitricted, and must contain:
* `description = "string"`
* `inventory_image = image`
* `groups = {bucket_level >= 1}`

<!--END Item Registers-->
## Item Callbacks
<!--BEGIN Item Callbacks-->

* `on_carry(itemstack, player)` Called every tick when the item is in the player's inventory. Return an itemstack if the itemstack should change. Return null if no change is desired.

* `on_wield(itemstack, player)` Called when the item is heald in the hand by a player. Called after `on_carry(...)`. Return an itemstack to change the wielded item, or null, for no change.

<!--END Item Callbacks-->
# Entity Registers
<!--BEGIN Entity Registers-->

### qts.register_projectile(name, def)
Registers a new projectile. The projectile is an entity with a bunch of pre-defined behavior and interactions, both with nodes and other entities.

`def` is a table that contains:

**From regular entities**
* `visual`
* `visual_size`
* `textures = {}`
* `use_texture_alpha = true/false`
* `spritediv`
* `initial_sprite_basepos`
* `backface_culling`
* `glow`
* `automatic_rotate`
* `automatic_face_movement_dir`
* `automatic_face_movement_max_rotation_per_sec`
    
**custom Fields**
* `radius = number` 
the radius of the projectile
* `selectable = true/false` 
true if the projectile should be selected (used for deflecting/blocking, etc.)
* `gravity_scale = number` 
the scale of gravity. defaults to 1
* `collectable = "itemstring"` 
the item given to the player when they walk over a motionless projectile.
* `lifetime = number` 
how many seconds the projectile should live for
* `speed = number` 
how fast (blocks/second) the projectile moves
* `damage_groups = {damagetype=value, ...}`
the damage groups for the projectile
    
**custom callbacks** These have default values. Overriding them will not call the default value, and may not have the expected behavior, unless the default value is called or replicated. The default values can be found under [Projectile Functions](#projectile-functions).
* `on_strike_node = function(self, pos, node)`
called when the projectile strikes a node
* `on_strike_entity = function(self, objref)`
called when striking an entity
* `on_timeout = function(self)` 
called when its lifetimer reaches 0, before removing the entity.
* `on_step = function(self, dtime)` 
called every frame. Does not override builtin on_step, but is called inside of it.

There is also a function inside of every projectile's luaentity called `launch`. It is used to launch the projectile in a direction (vector). It takes two paramaters: the direction as a vector, and the launcher, an objectref. The launcher can be nil. Example:

    projectileRef:get_luaentity():launch({x=1,y=0,z=1}, nil)

Projectiles also automatically call callbacks for nodes, see [Node Callbacks](#node-callbacks) for the callback functions.
<!--END Entity Registers-->
## Entity Callbacks
<!--BEGIN Enitity Callbacks-->

<!--END Entity Callbacks-->
# Other Registers
<!--BEGIN Other Registers-->
* `qts.register_element(name, default_func)` - See [Element System](#element-system)
* `qts.gui.register_gui(name, def)` - See [GUI System](#gui-system)
* `qts.register_item_modifer(name, def)` - See [Item Modifiers System](#item-modifiers-system)
<!--END Other Registers-->

# Standard Groups
<!--BEGIN Standard Groups-->

<!--END Standard Groups-->

# Major Systems
<!--BEGIN Major Systems-->

## Element System
<!--BEGIN Element System-->
The element system is a system of block-to-block interactions, like lava being cooled by water. It works by registering an element with some name `name`. Then, several groups and callbacks are used for interactions based on that name. 

Interactions take place between a source and target block. The source block must have the group `<name>ing` and the target block must have the group `<name>able`. If two such blocks come into contact, immedately a callback in the target called `on_<name>(pos, node, active_object_count, active_object_count_wider)` is called. If this callback does not exist, the a default version from the regsitered element is called. 

### Methods of the Element System

* `qts.register_element(name, default_func)`
Registers an element for the [Element System](#element-system). See that for detauls on how it works.

**Params** 
* `name = "string"` - The name of the element.
* `default_func = function(pos, node, active_object_count, active_object_count_wider)` - The default interaction function.

**Returns** Nothing.
<!--END Element System-->

## Growing System
<!--BEGIN Growing System-->
The growing system is intended for saplings, farm plants, and everything else that needs to grow. It is not based off of ABMs, but off of Node Timers. This is to give it a greater sense of regularity, as well as allow the player to take actions to speed up and/or instantly grow plants. It handles needing a specific surface to grow upon. 

Nodes that are growable have the group "growable" and are registered using `qts.register_growable_node(...)` Nodes registered with this need two extra fields: a table called `growable_nodes` that lists nodenames or groups that the node can grow upon, and a callback called `on_grow(pos)`, called when the node is grown. 

Registrations and callbacks from this system are detailed under [Node Registrations](#node-registers)

## Methods of the Growing System

* `qts.start_node_growth(pos)`
Starts the growth timer for the node at `pos` if that node is a growable node.

* `qts.fertalize_node(pos)`
Halves the remaining growth timer for the node at `pos` if that node is growable and has a running growth timer.

* `qts.start_area_growth(pos1, pos2)`
Starts the growth timer for all growable nodes in the rectangular solid defined by corners `pos1` and `pos2`
<!--END Growing System-->

## GUI system
<!--BEGIN GUI System-->
qts.gui is a GUI system build on top of formspec provided by Minetest. It works by registering a form and displaying a form.

A form, as used by the GUI system, contains two major parts: a `get(...)` function that returns a formspec string, and a `handle(...)` function that is called when fields are interacted with. These forms can be made as "tabs" in another form.

**Personal Note:** I don't like this system much, and would like to refactor it a bit, allowing only one function in the defined form, that uses special functions for both generating the formspec string and responding to passed fields. It would be a more robust GUI system that completely hides formspec behind its implementation.

### Globals of the GUI System

* `qts.gui.forms` - a list of all registered forms, indexed by name

* `qts.gui.formData` - stores form instance-specific data

* `qts.gui.gui_conv = {padding = 3/8, spacing = 5/4}` - a constant used for padding and spacing calculations

### Methods of the GUI System
All these methods fall under the `qts.gui` namespace

#### GUI Form registration

* `qts.gui.register_gui(name, def)`
Registers a new gui form. `name` is the name of the form, each must have their own unique name. Using the standard `modname:formname` is reccomended, but not enforced. `def` is a table which contains:
    * `get(data, pos, name)` - a function that returns a formspec string. `data` is instanced form data. `pos` is the positional reference for the form (node location if from a node, player pos if otherwise). `name` is the playername opening the form.
    * `handle(data, pos, name, fields)` - a function that handles the fields from a formspec interaction. Paramaters are the same as `get(...)` with the addition of `fields` a table indexed by the name of the formspec elements, just as in `minetest.register_on_player_redeive_fields(...)`
    * `tab` - should be set to true if this form is a tab inside another.
    * `owner` - must be set to a pre-defined formname if `tab` is true. This form is the owning form.
    * `tabowner` - should be true if this form will contain tabs. Mutually exlusive with `tab`.

#### GUI displaying

* `qts.gui.show_gui(pos, player, formname, tabindex, show, ...)`
Display a GUI form to the player, or, updata a current displayed form. It can also be used to return the formstring, without displaying it. 
    * `pos` is the positional reference. This could be the location of the node this form is associated with (ie, a chest) or the player position if this is not appropreate.
    * `player` is the playerref (or a player name) that is opening the form
    * `formname` is the form to open
    * `tabindex` is the index of the tab for a multi-tabbed form. Individual tabs are not shown, but the tab owner form.
    * `show` defaults to true. If false, then the formspec string is returned with the formname, in the form: {[1] = "qts:"..formname, [2] = formspec_str}
    * `...` Any positional params here are passed to the form's `get(...)` function after its params.

* `qts.gui.set_inventory_gui_name(formname)`
Sets the form to be used for inventories. `formname` is the name of a registered form.

* `qts.gui.get_inventory_gui_name()`
Returns the name of the form used for inventories.

#### GUI Helper functions

* `qts.gui.gui_makepos(x, y, new)`
Returns a special table with three values: `x`, `y` and `get()`. `x` and `y` are the space-converted formspec coordinates, and `get()` is a method (called using ":" notation on the reutrn) for converting it into a string for formspec. The paramaters `x` and `y` are formspec coordinates to be converted, and `new` should either be true (if the values are alredy in the new formspec system) or nil (if the values are in the old formspec system).

* `qts.gui.gui_makesize(x, y, new)`
Functions the exact same as `qts.gui.gui_makepos(...)` but with the `x` and `y` values describing a size instead of a position. Paramaters and return are the same.

* `qts.gui.get_open_gui(player)`
Gets the name of the gui currently open by player, or, if there is none, an empty string. `player` can either be a playerref or a player name.

* `qts.gui.push_to_form(player, data)`
Pushes some custom data to the player's open form's current instance. `player` is a playerref or a player name. `data` is a table containing the data to push. This will silently override any existing data in the form instance.

* `qts.gui.click(playername)`
Plays a button click sound to the player `playername`. Usually called from the GUI function `handle(...)` defined during a form registration.

#### Internal helpe functions
These are exposed publicly in case more customization is needed.

* `qts.gui.generate_tabs(current, formname)`
A function to consolidate and show the tabs within a form. This is automatically called by the system where appropreate, and is only exposed in case it is needed in some edge case.

* `qts.gui.handle_tabs(pos, playername, formname, fields)`
A function to handle tab form fields. Automatically called by the system, when appropreate. 

* `qts.gui.pass_tabs(pos, playername, formname, fields)`
A function to pass tab handling out of automatic control when dealing with an inventory. Automatically called by the system, when appropreate.
<!--END GUI System-->

## Item Modifiers System
<!--BEGIN Item Modifiers System-->
This is a manner of implementing Enchanting and speicalized instances of an item. It attaches special functions to an item through fields in its metadata.

Modifers can be registered, much like an item, and they are called when the regular conditions are met for an item that the modifier is applied to.
For example, lets say modifier X defindes a function `on_place(...)`. Then, that modifer is applied to a specific Steel Pickaxe. Now, when the player places with that specific pickaxe, the registered `on_place(...)` function is called. But if the player places with any old Steel pickaxe, it is not.

### Registering an Item Modifier.
`qts.register_item_modifer(name, def)`

**Params**
* `name` is the unique name for the specific item modifier
* `def` is a table of functions. These are standard Minetest callback functions, that belong to the following list.

**Callback Functions** 
* `on_place(pos, newnode, placer, oldnode, itemstack, pointed_thing)` - only actually gets called for nodes that can be placed
* `on_dignode(pos, node, digger)` - used to break a node 
* `on_punch_node(pos, node, puncher, pointed_thing)` - used to punch a node
* `on_punch_player(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)` - used to punch player. Hitter is the one holding the item if `on_punch_player == nil` and `on_punch_entity ~= nil` then on_punch_entity will be called by player.
* `on_punch_entity(objref, hitter, time_from_last_punch, tool_capabilities, dir, damage)` - used to punch an entity The registered entity is responsible for implementing the calling of this function.
 * `on_dieplayer(player, reason)` - the player with this in his inv dies
* `on_item_eat(hp_change, replace_with_item, itemstack, user, pointed_thing)` - the item is eaten (return true to prevent HPChange)
* `inventory_can_act(player, action, inventory, inventory_info)` -  used to check if some inventory operation can be done to the item
* `inventory_on_act(player, action, inventory, inventory_info)` - called when an inventory operation is done on the item

### Application to an Item
`qts.apply_item_moditer(itemstack, name, level)`

Registered modifiers can be applied to an itemstack using this method. `level` is stored in the itemstack's meta, as the value to the modifer name key. 
<!--END Item Modifiers System-->

<!--END Major Systems-->

# Other arbitrary things
<!--BEGIN Other-->
## Ambient Node Sounds
qts provides a way for nodes to play ambient sounds to the player, like fire crackling. There are two requirements for this to be done. First, the node must have `group:ambient = 1` as part of their groups. Second, there is a special sound field in the `sounds` part of the node definition. It is called `ambience` and it is a table with the following fields:
* `name = soundFileName` - Sound file name
* `spec = SimpleSoundSpec` - A Minetest SimpleSoundSpec
* `chance = number` - 1 in this number chance of playing when it can.
* `playtime = number` - Number of seconds the sound file is long
* `positional = boolean` - True if the sound should come from the node.
* `loop = boolean` - True if the sound should loop

**Example** From the `default:fire` node of QuestTest2:

    groups = {fire = 1, dig_immediate = 3, igniter = 2, ambient = 1},
    sounds = {
		ambience = {
			name = "campfire",
			spec = {gain = 10},
			chance = 1,
			playtime = 16,
			positional = true,
			loop = true,
		}
	},

<!--END Other-->
# Devmode
Devmode is a tool for developing QuestTest2 content. It causes certain items and blocks to be registered, or registered differently, as well as blocks some ABMs. This is so, for example, the dungeon chunks can be built, including the hidden generator blocks, without any problems related to those generator blocks generating a new section of dungon as soon as they are placed. It also enables some tools like the scemantic creation tools and some analitical tools to be registered. Finally, some items, such as fake air, are registered using a different definition, so they are visible in devmode, but invisible regularly.

Worlds can be placed into "devmode" by the chatcommand `devmode on` and taken out of devmode by the chatcommand `devmode off`. 

Worlds are **not** designed to be played in devmode. It breaks certain aspects of play (ie, dugeon generation) It is designed for developing QuestTest2 content and mods for QuestTest2.
