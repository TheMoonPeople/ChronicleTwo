--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_9d8581fa()
	wait_frames_skipping(30)
	helper_1ef0d4b2()
end

return helper_9d8581fa
