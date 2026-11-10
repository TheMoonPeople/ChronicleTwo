--!strict
-- Shared monster helper used by 110 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_28452e16(arg0: f32)
	return vm.f32(vm.f32(arg0 * 180.0) / vm.f32(3.1415927))
end

return helper_28452e16
