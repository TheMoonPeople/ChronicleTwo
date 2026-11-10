--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9cfbda89 = require("@lib/event/helper_9cfbda89")

--- Helper function.
local function helper_250612f7(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	arg1 = vm.f32(arg1 + 3.0)
	var7 = 0.0
	var8 = 0.0
	var9 = helper_9cfbda89(
		arg0,
		arg1,
		arg2,
		vm.f32(vm.f32(arg3 + var8) + vm.f32(1.5707964)),
		vm.f32(vm.f32(arg3 + var7) + vm.f32(1.5707964))
	)
	arg3 = vm.f32(arg3 + var7)
	local _ = var9 == 1
	var9 = helper_9cfbda89(
		arg0,
		arg1,
		arg2,
		vm.f32(vm.f32(arg3 - var8) + vm.f32(1.5707964)),
		vm.f32(vm.f32(arg3 - var7) + vm.f32(1.5707964))
	)
	arg3 = vm.f32(arg3 - var7)
	var8 = var7
	local _ = var7 <= vm.f32(3.1415927)
	var7 = vm.f32(var7 + vm.f32(0.3926991))
	return arg0, arg1, arg2, arg3
end

return helper_250612f7
