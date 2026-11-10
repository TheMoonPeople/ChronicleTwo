--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ce0a5798 = require("@lib/event/helper_ce0a5798")
local helper_fbf84a80 = require("@lib/event/helper_fbf84a80")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_cb4e905f()
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	var1, var2, var3, var4 = helper_ce0a5798(var1, var2, var3, var4)
	local _ = helper_fbf84a80(var4, 0.0, 1.0) == 0
	print("\n\n\nROT_0.0\n\n\n")
	local _ = helper_fbf84a80(var4, vm.f32(3.14), 1.0) == 0
	print("\n\n\nROT_3.14\n\n\n")
	local _ = helper_fbf84a80(var4, vm.f32(1.57), 1.0) == 0
	print("\n\n\nROT_1.57\n\n\n")
	local _ = helper_fbf84a80(var4, vm.f32(-1.57), 1.0) == 0
	print("\n\n\nROT_-1.57\n\n\n")
	wait_frames_skipping(30)
	wait_frames_skipping(60)
end

return helper_cb4e905f
