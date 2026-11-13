--!strict
--- Frame-based waiting for effect scripts.

local vm = require("@lib/vm")

local timing = {}

--- Waits for the given number of frames.
function timing.wait_frames(frames: s32)
	for i = 0, frames - 1 do
		vm.wait()
	end
end

return timing
