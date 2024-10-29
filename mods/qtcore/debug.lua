--[[

qtcore's debugging library

]]


if qts.ISDEV then
-- debugging enabled

---@class DebugLuaEntity:LuaEntity
---@field time_to_live number
---@field setup fun(self:DebugLuaEntity,is_line:boolean,color:ColorSpec,lifetime:number,size:number)

minetest.register_entity("qtcore:debug_visualizer", {
    ---@tupe ObjectProperties
    initial_properties = {
        physical = false,
        collide_with_objects = false,
        visual="mesh",
        textures = {"White.png"},
        use_texture_alpha = false,
        mesh = "Center_Cube.obj",
        glow=4,
        hp_max=1,
        is_visible=true,
        static_save = false,
        selectionbox = {0,0,0,0,0,0,false},
    },
    time_to_live = 10,

    ---@param self DebugLuaEntity
    ---@param dtime number
    on_step = function(self, dtime)
        self.time_to_live = self.time_to_live - dtime
        if self.time_to_live < 0 then
            self.object:remove()
        end
    end,

    ---comment
    ---@param self DebugLuaEntity
    ---@param staticdata string
    ---@param dtime_s number?
    on_activate = function (self, staticdata, dtime_s)
        local pack = minetest.deserialize(staticdata)
        if pack and pack.is_line ~= nil and pack.color and pack.lifetime and pack.size then
            self:setup(pack.is_line, pack.color, pack.lifetime, pack.size)
        end
    end,
    
    ---Set the properties of the debug display object
    ---@param self DebugLuaEntity
    ---@param is_line boolean
    ---@param color ColorSpec
    ---@param lifetime number
    ---@param size number
    setup = function (self, is_line, color, lifetime, size)
        local props = self.object:get_properties()
        if is_line then
            props.mesh = "Center_Line.obj"
            props.visual_size={x=1,y=size,z=1}
        else
            props.visual_size={x=size,y=size,z=size}
        end
        props.textures={"White.png^[multiply:"..color}
        self.time_to_live = lifetime
        self.object:set_properties(props)
    end
})

    ---Draw a debug visualizer for a point
    ---@param position Vector
    ---@param color ColorSpec?
    ---@param size number?
    ---@param lifetime number? how long the visualization will last
    function qtcore.debug_point(position, color, size, lifetime)
        if color == nil then color = "#ffffff" end
        if size == nil then size = 1 end
        if lifetime == nil then lifetime = 10 end

        local obj = minetest.add_entity(position, "qtcore:debug_visualizer", minetest.serialize({
            is_line = false,
            color=color,
            lifetime=lifetime,
            size=size
        }))
    end

    minetest.register_chatcommand("debugpoint", {
        params = "<position> <color> <size> <time>",
        privs={creative=1},
        description = "Draw a debug point",
        func = function(name, param)
            local args = qts.breakdown_args(param, {"vector", "string", "number", "number"}, minetest.get_player_by_name(name), nil)
            if args then
                qtcore.debug_point(args[1], args[2], args[3], args[4])
            else
                minetest.chat_send_player(name, "Unable to draw debug point - invalid arguments!")
            end
        end
    })

else
-- debugging disabled
local function define_debug_function(name)
    qtcore[name] = function(...)
        minetest.log('warning', "Debug Function Used! - " .. name)
    end
end

define_debug_function("debug_point")

end