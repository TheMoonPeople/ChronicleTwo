--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_086b6e48 = require("@lib/event/helper_086b6e48")
local helper_1a17a613 = require("@lib/event/helper_1a17a613")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_97b8269e()
	helper_1a17a613()
	wait_frames_skipping(6)
	helper_086b6e48()
end

return helper_97b8269e
