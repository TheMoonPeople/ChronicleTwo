--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9821a9e1(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	if arg2 == 0.0 then
		arg3 = 0.0
	else
		arg3 = vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(arg0 - vm.f32(arg1 * arg2)) * 2.0), arg2)), arg2))
	end
	return arg3
end

return helper_9821a9e1
