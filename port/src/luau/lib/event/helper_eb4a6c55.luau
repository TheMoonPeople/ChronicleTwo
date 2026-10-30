--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_eb4a6c55(arg0: any)
	helper_8cd371d7(1060070)
	wait_frames_skipping(15)
	helper_8cd371d7(1060080)
	wait_frames_skipping(15)
	wait_frames_skipping(10)
	helper_8cd371d7(1060090)
	helper_238b5abc(0)
	helper_238b5abc(3)
end

return helper_eb4a6c55
