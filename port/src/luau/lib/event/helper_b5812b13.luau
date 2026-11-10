--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_b5812b13()
	helper_1ef0d4b2()
	helper_238b5abc(1)
	wait_frames_skipping(10)
	wait_frames_skipping(30)
	wait_frames_skipping(20)
	helper_238b5abc(0)
	wait_frames_skipping(10)
	helper_43f02c95(-130.0, 0.0, -365.0, vm.f32(-1.57))
	helper_1ef0d4b2()
end

return helper_b5812b13
