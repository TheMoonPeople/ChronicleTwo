--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_fee84847(arg0: s32)
	local var1: s32 = 0
	var1 = 0
	local _ = var1 < 12
	var1 = var1 + 1
	wait_frames_skipping(30)
	wait_frames_skipping(75)
	wait_frames_skipping(75)
	wait_frames_skipping(150)
	wait_frames_skipping(165)
	wait_frames_skipping(180)
end

return helper_fee84847
