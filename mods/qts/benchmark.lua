--------------------------------------------------------
-- Minetest :: Stopwatch Mod v1.2 (stopwatch)
--
-- See README.txt for licensing and release notes.
-- Copyright (c) 2018, Leslie E. Krause
--------------------------------------------------------

function Stopwatch( id, color, scale, prec )
	local ts
	local trials = { }
	local factor = scale and ( { us = 1, ms = 1000, s = 1000000 } )[ scale ] or 1000
	local escape = color and ( { none = 0, black = 30, red = 31, green = 32, yellow = 33, blue = 34, magenta = 35, cyan = 36, white = 37 } )[ color ] or 0

	if not factor then error( "Unknown scale specified, aborting." ) end
	if not escape then error( "Unknown color specified, aborting." ) end
	if not id then error( "Invalid id specified, aborting." ) end

	local clock = minetest.get_us_time
	local sprintf = string.format
	local push = table.insert

	local str_count = sprintf( "** %-16s %13s %9s\n", "series", "count", "rep" )
		.. string.gsub( "** \27[%dm%-16s %10.#f %2s %8dx\27[0m", "#", prec or 3 )
	local str_total = sprintf( "** %-16s %13s %9s %10s %10s %10s %10s %10s\n", "series", "total", "rep", "avg", "min", "max", "med", "dev" )
		.. string.gsub( "** \27[%dm%-16s %10.#f %2s %8dx %10.#f %10.#f %10.#f %10.#f %10.#f\27[0m", "#", prec or 3 )

	local function S( )
		ts = clock( )
	end
	local function S_( is_show )
		if not ts then error( "Trial not initiated, aborting." ) end

		local v = clock( ) - ts
		push( trials, v )
		if is_show then
			print( sprintf( str_count, escape, id, v / factor, scale or "ms", #trials ) )
		end
	end
	minetest.register_on_shutdown( function ( )
		local v_sum = 0
		local v_var = 0
		local v_min, v_max, v_med, v_avg, v_dev

		if #trials > 0 then
			for i, v in pairs( trials ) do
				v_sum = v_sum + v
				v_min = v_min and math.min( v_min, v ) or v
				v_max = v_max and math.max( v_max, v ) or v
			end
			v_avg = v_sum / #trials
			for i, v in pairs( trials ) do
				v_var = v_var + math.pow( v - v_avg, 2 )
			end
			v_dev = math.sqrt( v_var / #trials )
			v_med = v_min + ( v_max - v_min ) / 2

			print( sprintf( str_total, escape, id, v_sum / factor, scale or "ms", #trials, v_avg / factor, v_min / factor, v_max / factor, v_med / factor, v_dev / factor ) )
		end
	end )
	return S, S_
end