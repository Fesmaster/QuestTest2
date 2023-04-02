--[[
	Profiling tools for QuestTest

	Call qts.profile to create a profiler. use the returned start() and stop() functions to styart and stop the profiling.
]]

local function timestr(float)
	return dump( math.floor(float*10000) / 10000)
end

function qts.profile(id, scale, needs_framecount)
	--this is made a local upvalue to make it faster than global access
	local gettime = minetest.get_us_time
	local trials = {}
	local frames
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
		if needs_framecount then
			frames[#frames] = frames[#frames] + (v-timestamp)
		end
		if display_every_time then
			minetest.log("PROFILE: " .. dump(id) ..  "\t" .. dump((v-timestamp)/scalefactor) .. " " .. (scale or "ms"))
		end
		timestamp = nil
	end

	if (needs_framecount) then
		frames = {0}
		minetest.register_globalstep(function(dtime)
			frames[#frames+1]=0
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

				for k, v in ipairs(frames) do
					frame_avg = frame_avg+v --average
					if v < frame_min then -- min
						frame_min = v 
					end
					if v > frame_max then --max
						frame_max = v 
					end
				end
				frame_avg = frame_avg / #frames
				frame_min = frame_min / scalefactor
				frame_max = frame_max / scalefactor
				frame_avg = frame_avg / scalefactor

				framestring = "\tFrame Min: " .. timestr(frame_min) .. scaleString ..
							"\tFrame Max: " .. timestr(frame_max) .. scaleString .. 
							"\tFrame Average: " .. timestr(frame_avg) .. scaleString ..
							"\tTotal Frames: " .. dump(#frames)
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

local PROFILE_ABMS = true
if PROFILE_ABMS then

	local old_register_abm = minetest.register_abm

	function minetest.register_abm(def)
		local start, stop = qts.profile("ABM_"..def.label, "ms", true)
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

local PROFILE_ENTITIES = true
if PROFILE_ENTITIES then
	
	local old_register_eneity_func = minetest.register_entity

	function minetest.register_entity(name, def)
		local old_step = def.on_step
		if (old_step) then
			local start, stop = qts.profile("ENTITY_"..name.."_stepfunction", "ms", true)
			def.on_step=function(self, dtime, moveresult)
				start()
				old_step(self, dtime, moveresult)
				stop()
			end
		end
		old_register_eneity_func(name, def)
	end

end