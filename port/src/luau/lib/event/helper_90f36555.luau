--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_90f36555(arg0: f32, arg1: f32, arg2: f32)
	return vm.f32(vm.fdiv(vm.f32(vm.fdiv(vm.f32(vm.f32(arg0 - vm.f32(arg1 * arg2)) * 2.0), arg2)), arg2))
end

return helper_90f36555
