--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fbf84a80 = require("@lib/event/helper_fbf84a80")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_6615c8c0(arg0: s32)
	local var5: f32 = 0
	print(vm.float(var5), "\n")
	print(vm.float(var5), "\n")
	print(vm.float(var5), "\n")
	local _ = helper_fbf84a80(var5, 0.0, 1.0) == 0
	local _ = helper_fbf84a80(var5, vm.f32(1.57), 1.0) == 0
	local _ = helper_fbf84a80(var5, vm.f32(3.14), 1.0) == 0
	local _ = helper_fbf84a80(var5, vm.f32(-1.57), 1.0) == 0
	helper_238b5abc(0)
	wait_frames_skipping(20)
	wait_frames_skipping(20)
	helper_344d6cd8()
	helper_344d6cd8()
	helper_344d6cd8()
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_ee1c51d0(0, -1, 8, 0, 0)
	helper_ee1c51d0(0, -1, 8, 0, 0)
end

return helper_6615c8c0
