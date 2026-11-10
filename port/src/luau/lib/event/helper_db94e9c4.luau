--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_042a5b29 = require("@lib/event/helper_042a5b29")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_6cf80642 = require("@lib/event/helper_6cf80642")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_db94e9c4()
	helper_6cf80642()
	helper_238b5abc(1)
	helper_042a5b29()
	wait_frames_skipping(30)
	wait_frames_skipping(46)
	wait_frames_skipping(15)
	helper_43f02c95(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
end

return helper_db94e9c4
