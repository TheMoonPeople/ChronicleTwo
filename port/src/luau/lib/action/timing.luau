--!strict
--- Frame and motion waits shared by player character actions.

local vm = require("@lib/vm")

local timing = {}

--- Waits the given number of frames.
function timing.wait_frames(frames: any)
	while frames > 0 do
		frames = frames - 1
		vm.wait()
	end
end

--- Waits until the current motion has finished playing.
function timing.wait_motion_finished()
	local is_finished: s32 = 0
	while true do
		vm.wait()
		is_finished = vm.float_bits(action.is_motion_finished()) or is_finished
		if is_finished ~= 0 then
			return
		end
	end
end

--- Waits until the current motion progress lies within the given range.
function timing.wait_motion_progress_between(min_progress: f32, max_progress: f32)
	local progress: f32 = 0
	local is_waiting: s32 = 0
	is_waiting = 1
	while is_waiting ~= 0 do
		vm.wait()
		progress = action.get_motion_progress() or progress
		if progress >= min_progress and progress <= max_progress then
			is_waiting = 0
		end
	end
end

return timing
