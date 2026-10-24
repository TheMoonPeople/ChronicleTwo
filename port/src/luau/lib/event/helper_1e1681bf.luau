--!strict
-- Shared event helper used by 544 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_1e1681bf(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	return vm.f32(vm.f32(vm.fdiv(vm.f32(vm.f32(arg1 - arg0) * arg2), arg3)) + arg0)
end

return helper_1e1681bf
