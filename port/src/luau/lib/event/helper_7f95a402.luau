--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_7f95a402()
	helper_238b5abc(1)
	wait_frames_skipping(10)
	wait_frames_skipping(15)
	helper_238b5abc(0)
	wait_frames_skipping(10)
end

return helper_7f95a402
