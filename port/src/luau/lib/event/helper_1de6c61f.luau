--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_1de6c61f(arg0: s32)
	local var5: f32 = 0
	wait_frames_skipping(30)
	wait_frames_skipping(50)
	var5 = 1.0
	var5 = vm.f32(var5 + 1.0)
end

return helper_1de6c61f
