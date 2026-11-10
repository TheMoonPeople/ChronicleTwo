--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_f41e11f3(arg0: s32)
	wait_frames_skipping(90)
	wait_frames_skipping(30)
	helper_238b5abc(7)
	wait_frames_skipping(75)
end

return helper_f41e11f3
