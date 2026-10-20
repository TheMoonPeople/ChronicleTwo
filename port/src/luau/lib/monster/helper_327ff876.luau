--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_327ff876(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	arg2 = vm.f32(vm.sin(arg0) * arg1)
	arg3 = vm.f32(vm.cos(arg0) * arg1)
	return arg2, arg3
end

return helper_327ff876
