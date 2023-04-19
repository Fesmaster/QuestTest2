--[[
	Profiling tools for QuestTest

	Call qts.profile to create a profiler. use the returned start() and stop() functions to start and stop the profiling.
]]

local PROFILE_ABMS = qts.config("PROFILE_ABMS", false, "Include auto-profiling of registered AMBs", {loadtime=true})
local PROFILE_ENTITIES = qts.config("PROFILE_ENTITIES", false, "Include auto-profiling of registered Entity step functions", {loadtime=true})

local function timestr(float)
	return dump( math.floor(float*10000) / 10000)
end

function qts.profile(id, scale, needs_framecount)
	--this is made a local upvalue to make it faster than global access
	local gettime = minetest.get_us_time
	local trials = {}
	local frames
	local framecounts
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
		if timestamp == nil then
			minetest.log("warning", "Attemtped to stop a profiler before starting it!")
		end
		table.insert(trials, v-timestamp)
		if needs_framecount then
			frames[#frames] = frames[#frames] + (v-timestamp)
			framecounts[#framecounts] = framecounts[#framecounts] + 1
		end
		if display_every_time then
			minetest.log("PROFILE: " .. dump(id) ..  "\t" .. dump((v-timestamp)/scalefactor) .. " " .. (scale or "ms"))
		end
		timestamp = nil
	end

	if (needs_framecount) then
		frames = {0}
		framecounts = {0}
		minetest.register_globalstep(function(dtime)
			frames[#frames+1]=0
			framecounts[#framecounts+1]=0
		end)
	end

	minetest.register_on_shutdown(function()
		--collect metrics
		if #trials > 0 then
			local min = trials[1]
			local max = trials[1]
			local total_time = 0
			for k, v in ipairs(trials) do
				total_time = total_time+v --average
				if v < min then -- min
					min = v 
				end
				if v > max then --max
					max = v 
				end
			end
			
			local avg = total_time / #trials
			min = min / scalefactor
			max = max / scalefactor
			avg = avg / scalefactor
			total_time = total_time / scalefactor

			local scaleString = " " .. (scale or "ms")

			local framestring=""
			if needs_framecount then
				local frame_min = frames[1]
				local frame_max = frames[1]
				local frame_avg = 0
				local framecounts_min = framecounts[1]
				local framecounts_max = framecounts[1]
				local framecounts_avg = 0

				local framecount = 0

				for i, v in ipairs(frames) do
					local fc = framecounts[i]
					if fc > 0 then
						framecount = framecount + 1
						frame_avg = frame_avg+v --average
						if v < frame_min then -- min
							frame_min = v 
						end
						if v > frame_max then --max
							frame_max = v 
						end

					end

					framecounts_avg = framecounts_avg+fc --average
					if fc < framecounts_min then -- min
						framecounts_min = fc
					end
					if fc > framecounts_max then --max
						framecounts_max = fc
					end
				end
				frame_avg = frame_avg / framecount
				frame_min = frame_min / scalefactor
				frame_max = frame_max / scalefactor
				frame_avg = frame_avg / scalefactor

				framecounts_avg = framecounts_avg / #framecounts

				framestring = "\tPer-Frame Min: " .. timestr(frame_min) .. scaleString ..
							"\tPer-Frame Max: " .. timestr(frame_max) .. scaleString .. 
							"\tPer-Frame Average: " .. timestr(frame_avg) .. scaleString ..
							"\tCalls In Frame Min: " .. dump(framecounts_min) ..
							"\tCalls In Frame Max: " .. dump(framecounts_max) ..
							"\tCalls In Frame Average: " .. timestr(framecounts_avg) ..
							"\tTotal Frames: " .. dump(framecount)
			end

			minetest.log("PROFILE: " .. dump(id) ..  
							"\tMin: " .. timestr(min) ..scaleString .. 
							"\tMax: " .. timestr(max) .. scaleString .. 
							"\tAverage: " .. timestr(avg) .. scaleString ..
							framestring..
							"\tTotal Runs: " .. dump(#trials) ..
							"\tTotal Time: " .. timestr(total_time) .. scaleString
						)
		else
			minetest.log("PROFILE: " .. dump(id) .. " NOT RUN")
		end
	end)

	return startfunc, endfunc
end


if PROFILE_ABMS.get() then
	minetest.log("Profiling ABMs")

	local old_register_abm = minetest.register_abm

	function minetest.register_abm(def)
		local start, stop = qts.profile("ABM|"..def.label, "ms", true)
		old_register_abm({
			label = def.label,
			nodenames = def.nodenames,
			neighbors = def.neighbors,
			interval = def.interval,
			chance = def.chance,
			min_y = def.min_y,
			max_y = def.max_y,
			catch_up = def.catch_up,
			action=function(pos, node, active_object_count, active_object_count_wider)
				start()
				def.action(pos, node, active_object_count, active_object_count_wider)
				stop()
			end
		})
	end

end


if PROFILE_ENTITIES.get() then
	minetest.log("Profiling Entity step functions")
	
	local old_register_eneity_func = minetest.register_entity

	function minetest.register_entity(name, def)
		local old_step = def.on_step
		if (old_step) then
			local start, stop = qts.profile("ENTITY|"..name.."|stepfunction", "ms", true)
			def.on_step=function(self, dtime, moveresult)
				start()
				old_step(self, dtime, moveresult)
				stop()
			end
		end
		old_register_eneity_func(name, def)
	end

end