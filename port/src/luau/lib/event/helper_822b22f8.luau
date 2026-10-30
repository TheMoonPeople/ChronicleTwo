--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_822b22f8(arg0: s32)
	helper_344d6cd8()
	wait_frames_skipping(30)
	helper_344d6cd8()
	wait_frames_skipping(10)
	helper_8cd371d7(1060010)
	local _ = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
	helper_8cd371d7(1060040)
	helper_8cd371d7(1060050)
	wait_frames_skipping(30)
	return 1
end

return helper_822b22f8
