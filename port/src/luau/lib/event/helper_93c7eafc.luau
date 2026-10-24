--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_93c7eafc(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var5 = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(vm.f32(arg1 * arg2) - arg0) * 2.0), arg2)), arg2))
		var6 = vm.f32(vm.fdiv(vm.f32(vm.f32(2.0 * arg0) - vm.f32(arg1 * arg2)), arg2))
		arg3 = var5
		arg4 = var6
		return arg3, arg4
	end
	if vm.skipping() then
		return skip(1)
	end
	var5 = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(vm.f32(arg1 * arg2) - arg0) * 2.0), arg2)), arg2))
	var6 = vm.f32(vm.fdiv(vm.f32(vm.f32(2.0 * arg0) - vm.f32(arg1 * arg2)), arg2))
	arg3 = var5
	arg4 = var6
	return arg3, arg4
end

return helper_93c7eafc
