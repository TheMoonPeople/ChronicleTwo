--!strict
-- Shared event helper used by 785 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Waits one frame more than the given count.
local function wait_frames(frames: any)
	while frames >= 0 do
		frames = frames - 1
		vm.wait(1)
	end
end

return wait_frames
