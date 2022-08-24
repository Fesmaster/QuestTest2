--------------------------------------------------------
-- Minetest :: Stopwatch Mod v1.2 (stopwatch)
--
-- See README.txt for licensing and release notes.
-- Copyright (c) 2018, Leslie E. Krause
--------------------------------------------------------

function qts.profile(id, scale)
	--this is made a local upvalue to make it faster than global access
	local gettime = minetest.get_us_time
	local trials = {}
	local timestamp
	local scalefactor = scale and ({us=1,ms=1000,s=1000000})[scale] or 1000
	if not scalefactor then
		error("Unknwon Scale Factor in profiling: " .. dump(id))
	end


	local function startfunc()
		timestamp=gettime()
	end

	local function endfunc(display_every_time)
		local v = gettime()
		if not timestamp then
			minetest.log("warning", "Attemtped to stop a profiler before starting it!")
		end
		table.insert(trials, v-timestamp)
		if display_every_time then
			minetest.log("PROFILE: " .. dump(id) ..  "\t" .. dump((v-timestamp)/scalefactor) .. " " .. (scale or "ms"))
		end
		timestamp = nil
	end

	minetest.register_on_shutdown(function()
		--collect metrics
		if #trials > 0 then
			local min = trials[1]
			local max = trials[1]
			local avg = 0

			for k, v in ipairs(trials) do
				avg = avg+v --average
				if v < min then -- min
					min = v 
				end
				if v > max then --max
					max = v 
				end
			end
			avg = avg / #trials
			min = min / scalefactor
			max = max / scalefactor
			avg = avg / scalefactor

			local scaleString = " " .. (scale or "ms")
			minetest.log("PROFILE: " .. dump(id) ..  "\tMin: " .. dump(min) ..scaleString .. "\tMax: " .. dump(max) .. scaleString .. "\tAverage: " .. dump(avg) .. scaleString )
		else
			minetest.log("PROFILE: " .. dump(id) .. " NOT RUN")
		end
	end)

	return startfunc, endfunc
end

