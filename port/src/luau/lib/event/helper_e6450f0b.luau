--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_e6450f0b(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var11: s32 = 0
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", vm.float(var1), "---------------\n")
	print("fpos[1]=", vm.float(var2), "---------------\n")
	print("fpos[2]=", vm.float(var3), "---------------\n")
	print("train_id=", var11, "---------------\n")
	wait_frames_skipping(10)
	wait_frames_skipping(20)
	wait_frames_skipping(18)
	wait_frames_skipping(12)
	wait_frames_skipping(30)
	wait_frames_skipping(10)
	wait_frames_skipping(20)
	wait_frames_skipping(18)
	wait_frames_skipping(12)
	wait_frames_skipping(30)
end

return helper_e6450f0b
