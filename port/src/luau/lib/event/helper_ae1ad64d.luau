--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_ae1ad64d(arg0: any)
	local _ = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
	wait_frames_skipping(30)
	helper_344d6cd8()
end

return helper_ae1ad64d
