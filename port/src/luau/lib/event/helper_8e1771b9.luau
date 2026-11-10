--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_8e1771b9()
	local var0: s32 = 0
	wait_frames_skipping(6)
	print("GET_LANGUAGE=", var0, "\n")
	wait_frames_skipping(90)
	local _ = helper_dbff9fb6(0)
	wait_frames_skipping(30)
end

return helper_8e1771b9
