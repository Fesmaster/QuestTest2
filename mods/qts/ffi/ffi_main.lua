--[[
    FFI is used to load native C types into lua environment.

    This is used to push Minetest well beyond its designed limits.
--]]

dofile(qts.path.."/ffi/keybinds.lua") --non-vector math


--[[
    Intrinsics

]]

--[[
    Intel AVX compiler intrinsic functions.

    Taken from immintrin.h
]]
ffi.cdef([[
typedef struct __declspec(intrin_type) __declspec(align(32)) __m256d {
    double m256d_f64[4];
} __m256d;

__m256d _mm256_add_pd(__m256d, __m256d);
__m256d _mm256_sub_pd(__m256d, __m256d);
__m256d _mm256_mul_pd(__m256d, __m256d);
__m256d _mm256_div_pd(__m256d, __m256d);


bool __builtin_cpu_supports(const char*);

// Custom QTS types
    
    typedef union {
        struct{
            double x;
            double y;
            double z;
            double w;
        };
        __m256d reg;
    } vec4d;
]])

local C = ffi.C
vec4d = nil
local mt = {
    __add = function(a, b)
        return vec4d(C._mm256_add_pd(a.reg, b.reg))
    end,
    __sub = function(a, b)
        return vec4d(C._mm256_sub_pd(a.reg, b.reg))
    end,
    __mul = function(a, b)
        return vec4d(C._mm256_mul_pd(a.reg, b.reg))
    end,
    __div = function(a, b)
        return vec4d(C._mm256_div_pd(a.reg, b.reg))
    end,
}

vec4d = ffi.metatype("vec4d", mt)

minetest.register_chatcommand("vector_test", {
	params = "",
	description = "Executes a vector test",
	func = function(name, param)
        local start_lua, end_lua = qts.profile("lua_vector", "us", false)
        local start_native, end_native = qts.profile("native_vector", "us", false)

        minetest.debug(C.__builtin_cpu_supports("avx"))

        start_lua()
        for i=1,10000 do
            local v1 = vector.new(1,2,3)
            local v2 = vector.new(4,5,6)
            local v3 = v1 + v2
            local v4 = v1 - v2
        end
        end_lua()

        start_native()
        for i=1,10000 do
            local v1 = vec4d(1,2,3)
            local v2 = vec4d(4,5,6)
            local v3 = v1 + v2
            local v4 = v1 - v2
        end
        end_native()
	end
})
--local start_lua end_lua = qts.profile("lua_vector")