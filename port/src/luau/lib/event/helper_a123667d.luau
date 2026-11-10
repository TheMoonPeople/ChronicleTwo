--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_f8bbcc57 = require("@lib/event/helper_f8bbcc57")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_a123667d()
	print("00000000000000000000000000\n")
	print("11111111111111111111111111111111\n")
	local _ = helper_f8bbcc57(0, -1, 8, 256, 208, 2, 1)
	wait_frames_skipping(15)
	wait_frames_skipping(30)
end

return helper_a123667d
