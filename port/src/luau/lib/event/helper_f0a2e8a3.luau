--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_f0a2e8a3()
	wait_frames_skipping(4)
	helper_344d6cd8()
end

return helper_f0a2e8a3
