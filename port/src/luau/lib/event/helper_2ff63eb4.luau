--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_2ff63eb4(arg0: s32)
	helper_344d6cd8()
	helper_238b5abc(0)
	helper_238b5abc(1)
	wait_frames_skipping(50)
end

return helper_2ff63eb4
