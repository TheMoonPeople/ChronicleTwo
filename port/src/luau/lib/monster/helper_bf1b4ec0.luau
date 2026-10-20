--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_bf1b4ec0(arg0: f32, arg1: f32, arg2: f32)
	return vm.f32(vm.f32(vm.f32(arg1 - arg0) * arg2) + arg0)
end

return helper_bf1b4ec0
