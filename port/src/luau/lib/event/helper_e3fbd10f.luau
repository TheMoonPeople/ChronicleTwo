--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_bac0dab2 = require("@lib/event/helper_bac0dab2")

--- Helper function.
local function helper_e3fbd10f(arg0: s32, arg1: s32)
	event.SetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(-5.74, 133.71, 0.0)
	event.CmrsSetRef(-143.54, 66.02, 0.0)
	helper_25abe6d2(45)
	helper_bac0dab2(arg0, arg1)
	helper_bac0dab2(vm.i32(arg0 + 1), arg1)
	helper_bac0dab2(vm.i32(arg0 - 1), arg1)
	helper_bac0dab2(arg0, vm.i32(arg1 + 1))
	helper_bac0dab2(arg0, vm.i32(arg1 - 1))
	helper_25abe6d2(45)
end

return helper_e3fbd10f
