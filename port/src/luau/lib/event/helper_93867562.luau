--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_93867562()
	wait_frames_skipping(40)
	wait_frames_skipping(15)
	helper_43f02c95(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
end

return helper_93867562
