--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_3adb7568(arg0: any)
	wait_frames_skipping(15)
	helper_8cd371d7(1060060)
end

return helper_3adb7568
