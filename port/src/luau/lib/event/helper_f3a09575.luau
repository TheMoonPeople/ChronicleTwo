--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_f3a09575(arg0: s32, arg1: any)
	wait_frames_skipping(20)
	helper_249b75d1(0, -1, arg0, 0, 0)
	wait_frames_skipping(11)
end

return helper_f3a09575
