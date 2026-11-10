--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_9ced6ae4 = require("@lib/event/helper_9ced6ae4")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_453c6114(arg0: s32)
	helper_fbd9683d(0, 7)
	wait_frames_skipping(20)
	helper_238b5abc(1)
	helper_9ced6ae4(0, -1, arg0, 0, 0)
	helper_238b5abc(1)
	helper_9ced6ae4(0, -1, arg0, 0, 0)
	helper_fbd9683d(0, 1)
	local _ = helper_7d54f41c(0, -1, 5, 256, 208, 2, 0)
end

return helper_453c6114
