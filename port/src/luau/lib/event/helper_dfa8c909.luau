--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_dfa8c909(arg0: s32)
	helper_ee1c51d0(0, 2003, 8, 0, 0)
	wait_frames_skipping(30)
	local _ = arg0 ~= 1
	local _ = arg0 == 0
	arg0 = 2
	return arg0
end

return helper_dfa8c909
