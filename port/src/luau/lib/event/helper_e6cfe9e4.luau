--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_e6cfe9e4(arg0: s32, arg1: s32)
	wait_frames_skipping(30)
	wait_frames_skipping(45)
	wait_frames_skipping(45)
end

return helper_e6cfe9e4
