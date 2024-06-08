--[[
    Testing and examples for PenTool


]]

---@class PentoolCaveBrush:PentoolBrush

---Create a PentoolCaveBrush. The cave brush is designed to draw a cave. Currently, its a general eliptoid brush that only draws air.
---@return PentoolCaveBrush
function dtools.create_cave_brush()
    return {
        ---PentoolBrush interface draw
        ---
        ---The `draw(...)` function is run for every step of the drawing. Its required to implement for a brush.
        ---@param self PentoolCaveBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
			
			local nodes = qts.get_nodes_in_blob(transform.pos, transform.scale)
			--minetest.log("Cave blocks: " .. dump(nodes))
			for k, v in ipairs(nodes) do
				if (context:get_draw_alpha() < weight) then
				    minetest.set_node(v.pos, {name="air"})
				end
			end
        end,
        ---PentoolBrush interface copy
        ---
        ---The `copy(...)` function is run when pushing/poping the context state, to save the brush. Its required to implement for a brush.
        ---Since this brush does not have state, it does not need to actually make a copy - it only needs to return itself.
        ---@param self PentoolCaveBrush
        ---@return PentoolCaveBrush
        copy = function(self)
            return self
        end,
    }
end


---@class PentoolHallwayBrush : PentoolBrush

---Create a PentoolHallwayBrush. This brush is an example of a brush that uses the context and other brushes within it.
---This is a good design pattern for brushes that need to represent a more complex structure. In this case, it is a hallway 1 block long.
---@return PentoolHallwayBrush
function dtools.create_hallway_brush()
	
	return {
		---PentoolBrush interface draw
        ---
        ---The `draw(...)` function is run for every step of the drawing. Its required to implement for a brush.
        ---@param self PentoolHallwayBrush
        ---@param transform Transform
        ---@param weight Alpha
        ---@param context PentoolContext
        draw = function(self, transform, weight, context)
            ---This pattern describes one side of the hallway, matching a position to a node.
			local pattern = {
				[vector.new(2,0,0)] = {name="overworld:marble_brick_slab", param2=0},
				[vector.new(2,3,0)] = {name="overworld:marble_brick_slab", param2=20},
				[vector.new(3,0,0)] = {name="overworld:marble_border", param2=0},
				[vector.new(3,1,0)] = {name="overworld:marble_brick_wall", param2=0},
				[vector.new(4,1,0)] = {name="craftable:solas_block_white", param2=0},
				[vector.new(3,2,0)] = {name="overworld:marble_border2", param2=0},
				[vector.new(3,3,0)] = {name="overworld:marble_brick", param2=0},
			}

            -- When using a brush that uses the context internally, you **MUST** push before doing anything and pop right before returning.
            -- this will save the current brush and settings, restoring them after.
			context:push()
			
            -- Create the floor
            -- The "Greedy" box brush will use a virtual cube to draw at each point, so its less likely to leave holes. 
            -- It can also draw outside of bounds though. In this case, that is fine.
			:set_brush(qts.pentool.create_greedy_box_brush("overworld:obsidian_enigma"))
			:teleport_relative(vector.new(3,-1,0))  -- teleport down and to the right
            :rotate(rotator(0,0,90))                -- face to the left
            :pendown()                              -- set the pen as "down". This begins the stroke.
			:forward(5)                             -- move forward 3 blocks, drawing
            :penup()                                -- set the pen as "up". This ends the stroke.
			:peek()                                 -- restore state to the previous `push()`, but don't remvoe that `push()` from the stack.

			-- follow the pattern laid out above.
			for pos, node in pairs(pattern) do
                
				context:set_brush(qts.pentool.create_point_brush(node)) -- set the brush to use the node from the entry in the pattern
                :pendown()                                              -- start a stroke
				:push()                                                 -- save the current transform
				:teleport_relative(pos)                                 -- move to the pattern position
				:mark()                                                 -- draw a single "point" with the brush.
				:peek()                                                 -- restore to the previously saved transform (the push() within this loop)
				:teleport_relative(vector.new(-pos.x,pos.y,pos.z))      -- move to the pattern position, but mirrored to the left
				:mark()                                                 -- draw a dingle "point" with the brush
				:pop()                                                  -- restore to the previously saved transform, *and* remove it from the stack (the push() within this loop)
                :penup()                                                -- end the stroke
				:peek()                                                 -- restore to the previously saved transform (the push() at the top of the function)
			end
			
			-- Create the ceiling
			context:set_brush(qts.pentool.create_greedy_box_brush("overworld:apple_wood_planks"))
			:teleport_relative(vector.new(3,4,0))       -- teleport up and to the right
			:rotate(rotator(0,0,90))                    -- face left
            :pendown()                                  -- start the stroke
			:forward(5)                                 -- move forward, drawing, 5 blocks
            :penup()                                    -- end the stroke
			:pop()                                      -- restore and remove the context state at from the top of the function
        end,

        ---PentoolBrush interface copy
        ---
        ---The `copy(...)` function is run when pushing/poping the context state, to save the brush. Its required to implement for a brush.
        ---Since this brush does not have state, it does not need to actually make a copy - it only needs to return itself.
        ---@param self PentoolCaveBrush
        ---@return PentoolCaveBrush
        copy = function(self)
            return self
        end,
	}
	
end

---Generate a cave room and offshoots
---@param context PentoolContext the context
---@param iters integer how many recursive calls to make
local function generate_cave_room(context, iters)
    -- first, get the params from the context. 
    -- It is faster to use a local variable than to look up the param from the context, 
    -- so we cache the values locally 
	local pathsizemin = context:get_param("pathsizemin")
	local pathsizemax = context:get_param("pathsizemax")
	local forwardmin = context:get_param("forwardmin")
	local forwardmax = context:get_param("forwardmax")
	local roomsizemin = context:get_param("roomsizemin")
	local roomsizemax = context:get_param("roomsizemax")
    
    -- as with any modular function using pentool contexts, its best practice to push at the start and pop and the end
    context:push()
	
    -- Notice the use of functions in the context to get random values
    -- When using PenTool, you must assume that the PenTool is operating in a deterministic way, and not inject external randomness.
    -- this could cause problems if your pentool is running with a context designed to gain some metric about the tool itself, such as its max bounds.

    -- for a random number of steps, make a passage
	for i=1,context:get_random_int_in_range(5,15) do
        -- randomized heading
		context:rotate(rotator(
			0, 
			context:get_random_int_in_range(-45,45), 
			context:get_random_int_in_range(-45,45)
		))
        -- randomized scale
		:set_scale(vector.new(
			context:get_random_int_in_range(pathsizemin, pathsizemax),
			context:get_random_int_in_range(pathsizemin, pathsizemax),
			context:get_random_int_in_range(pathsizemin, pathsizemax)
		))
        -- randomized forward ammount
		:forward(context:get_random_int_in_range(forwardmin, forwardmax),2)
	end
	
    -- randomize the scale to make a room
	context:set_scale(vector.new(
		context:get_random_int_in_range(roomsizemin, roomsizemax),
		context:get_random_int_in_range(2,4),
		context:get_random_int_in_range(roomsizemin, roomsizemax)
	))
	:mark() -- draw a "point" to make a room

    -- recursive calls with iter decrimented.
	if (iters > 0) then
		for i=1, context:get_random_int_in_range(1,3) do
			generate_cave_room(context, iters-1)
		end
	end

    -- as with any modular function using pentool contexts, its best practice to push at the start and pop and the end
	context:pop()
end

-- Rengister a PenTool. Registered pentools are easier to execute, being able to be found by name from anywhere.
-- you can also execute them from a chatcommand.
-- 
-- Registering a pentool requres 3 things:
-- - the name
-- - a set of paramaters (can be empty table)
-- - a function to execute the tool
qts.pentool.register_tool("dtools:cave",
	-- the paramaters to a tool are effectively inputs with their default values that can be overriden.
    -- there is no reason that these have to be numbes - in this example they just all are numbers.
    -- its possible to use any data type. Other ideas include node names, functions to create brushes, etc.
    {
		roomsizemin=4,
		roomsizemax=6,
		pathsizemin=1.5,
		pathsizemax=3,
		forwardmin=3,
		forwardmax=5
	},
    -- The function to execute the tool takes a context as the paramater.
	function (context)
        -- fetch paramaters locally for effecency
        local pathsizemin = context:get_param("pathsizemin")
	    local pathsizemax = context:get_param("pathsizemax")
	    local forwardmin = context:get_param("forwardmin")
	    local forwardmax = context:get_param("forwardmax")

		context
        :penup() -- since we are about to move without wanting to draw, make sure pen is up
		:face_up()
		:forward(1)
		:face_horizontal()
        -- pick a random downward facing direction at any angle
		:rotate(rotator(
			0, 
			context:get_random_int_in_range(-45,0), 
			context:get_random_int_in_range(-180,180)
		))
		:set_brush(dtools:create_cave_brush())
		:set_scale(vector.new(
            context:get_random_int_in_range(pathsizemin, pathsizemax),
			context:get_random_int_in_range(pathsizemin, pathsizemax),
			context:get_random_int_in_range(pathsizemin, pathsizemax)
		))
        :pendown() -- set up, now set pen down to draw
		:forward(context:get_random_int_in_range(forwardmin, forwardmax),2)
		generate_cave_room(context, 3)
        context:penup()
	end
)

-- Tool instances take a name, the parent tool name, and a set of paramater overrides.
-- When executing a pentool, you can execute a tool or a tool instance without having to care which is which.
qts.pentool.register_tool_instance("dtools:cave_larger", "dtools:cave", {
	roomsizemin=6,
	roomsizemax=12,
})

qts.pentool.register_tool_instance("dtools:cave_bulky", "dtools:cave_larger", {
	pathsizemin=3,
	pathsizemax=5,
})

-- Another example tool. Generates a palm tree.
-- this tool does not have paramaters.
qts.pentool.register_tool("dtools:palm", {}, function(context)
	context:pendown()
	:set_brush(qts.pentool.create_point_brush("overworld:palm_log"))
	:forward(5)
	:set_brush(qts.pentool.create_point_brush("overworld:palm_leaves"))
	:forward(1)
	:rotate(vector.new(math.rad(-90), 0, 0))
	:push() -- saves the state of the pentool context to a stack. You can restore by peak() or pop().
	for i=0,5 do
		context:rotate(vector.new(0, math.rad(360/6)*i, 0))
		:forward(1.8, 0.6)
		:rotate(vector.new(math.rad(-40),0,0))
		:forward(1.8, 0.6)
		:peek() -- restore the pentool state to the last push()ed value. Does not remove it from the stack, you you can restore again.
	end
	context:pop() -- restore the pentool state to the last push()ed value. Removes that state from the stack, giving access to the one beneath 
    :penup()
end)

-- a tool to create a circular hallway
qts.pentool.register_tool("dtools:hallway_circle", 
	-- two simple params
    {
		length = 10,
		angle_step = 10,
	},
	function (context)
        -- cache the paramaters locally
		local len = context:get_param("length")
		local angle = context:get_param("angle_step")
        context:face_horizontal(true)
		:set_brush(dtools.create_hallway_brush())
		-- move the tool up 1 block, so that the floor of the hallway (which draws below the tool's location) is on the level the hallway was spawned at
        :teleport_relative(vector.new(0,1,0))
		:pendown()
		-- draw the hallway, to make a full circle.
		for i=0,360,angle do
			context:forward(len)
			:teleport_relative(vector.new(0,0,-2))
			:rotate(rotator(0,0,angle))
		end
        -- its important to remember to call penup() - some brushes might not draw till this is called.
		context:penup()
	end
)

-- a pentool that draws a random tree trunk. For testing the shaped point brush.
qts.pentool.register_tool("dtools:treetrunk", {}, function (context)
    context:set_brush(qts.pentool.create_shaped_point_brush("overworld:oak_log", 0.25, true))
	:forward(1)
	:face_up(true)
	:pendown()
	:forward(1)
	:rotate(rotator(0, context:get_random_int_in_range(-20,20), context:get_random_int_in_range(-20,20)))
	:forward(2)
    -- its important to remember to call penup() - some brushes might not draw till this is called.
	:penup()
end)

-- a pentool that draws an arch. For testing the shaped point brush.
qts.pentool.register_tool("dtools:archway", {}, function (context)
    context:set_brush(qts.pentool.create_shaped_point_brush("overworld:granite", 0.35, true))
    :forward(1)
    :face_up(true)
    :pendown()
    :forward(4,1,true)
    :rotate(rotator(0,-45,0))
    :teleport_relative(vector.new(0,-0.5,0))
    :forward(4,0.6,false)
    :teleport_relative(vector.new(0,0.5,0))
    :rotate(rotator(0,-45,0))
    :forward(4,1,true)
    :rotate(rotator(0,-45,0))
    :teleport_relative(vector.new(0,-0.5,0))
    :forward(4,0.6,false)
    :teleport_relative(vector.new(0,0.5, 0))
    :rotate(rotator(0,-45,0))
    :forward(4,1,true)
    -- its important to remember to call penup() - some brushes might not draw till this is called.
    :penup()
end)

-- item to test pentools with.
minetest.register_tool("dtools:pentool_tester", {
	description = "PenTool testing wand",
	inventory_image = "dtools_green_wand.png",
	range = 10.0,
	on_use = function(itemstack, user, pointed_thing)
		---@cast user Player

		if (pointed_thing.under== nil) then return end
		minetest.log("QTS PenTool Testing Tool used")
		
		local t = transform.new(
			pointed_thing.under,
			(pointed_thing.above - pointed_thing.under):normalize():dir_to_rotation(),
			vector.new(1,1,1)
		)
		t:set_rot(vector.new(t.rot.x, user:get_look_horizontal(), t.rot.z))
		--t:rotate(vector.new(user:get_look_horizontal(), 0, 0))

		minetest.log("Transform: " .. t:format())

        -- executing a pentool
        -- to execute a pentool, you need two things: the pentool name (which can be an instance), and a transform.
        -- optionally, you can also provide a table of param overrides.
		qts.pentool.execute_tool("dtools:hallway_circle", t, {length=5})
	end,
})

