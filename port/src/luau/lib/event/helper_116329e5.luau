--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_116329e5(arg0: f32, arg1: f32, arg2: f32, arg3: f32, sp: number)
	vm.stack(sp + 4)
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 5)
		local t1 = vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3))
		vm.stack(sp + 5)
		return vm.f32(t1 + arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 5)
	local t0 = vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3))
	vm.stack(sp + 5)
	return vm.f32(t0 + arg0)
end

return helper_116329e5
